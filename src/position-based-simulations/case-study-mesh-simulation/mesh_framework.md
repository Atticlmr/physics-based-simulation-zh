## 完整网格仿真

现在我们把已实现的边约束与体积约束结合起来，构建一个完整的体积网格仿真。主仿真循环迭代地求解这两类约束，然后更新速度。

```python
def substep():
    """Complete mesh simulation integrating all components"""
    pre_solve(sdt, 1)
    for _ in range(solver_iterations):
        solve_edges(edge_compliance, sdt)
        solve_volumes(vol_compliance, sdt)
    post_solve(sdt)
```

在每次迭代中，求解器交替处理边约束与体积约束。先求解边约束，因为它提供结构完整性；随后体积约束保证不可压缩性。

本实现的关键优势之一是将仿真网格与视觉网格解耦。我们使用粗糙的四面体网格进行高效仿真，并使用精细的三角形网格获得高质量渲染：

```python
# Simulation mesh (tetrahedral)
pos = ti.Vector.field(3, dtype=ti.f64, shape=num_particles)
tet_ids = ti.field(ti.i32, shape=(num_tets, 4))
edge_ids = ti.field(ti.i32, shape=(num_edges, 2))

# Visual mesh (triangular)
vis_mesh_rest_pos = ti.Vector.field(3, dtype=ti.f64, shape=num_vis_verts)
vis_mesh_pos = ti.Vector.field(3, dtype=ti.f64, shape=num_vis_verts)
vis_mesh_indices = ti.field(ti.i32, shape=num_vis_tris * 3)
```

这种分离使得我们既能用粗糙四面体进行高效仿真，又能以精细三角形保持高质量渲染。

视觉网格利用由仿真网格计算得到的重心坐标进行变形：

```python
@ti.kernel
def update_vis_mesh():
    """Update visual mesh using barycentric skinning"""
    for i in range(num_vis_verts):
        tet_idx = skinning_info_tet_idx[i]
        if tet_idx < 0:
            vis_mesh_pos[i] = vis_mesh_rest_pos[i]
            continue
        
        p_indices = ti.Vector([tet_ids[tet_idx, 0], tet_ids[tet_idx, 1], tet_ids[tet_idx, 2], tet_ids[tet_idx, 3]])
        p0, p1, p2, p3 = pos[p_indices[0]], pos[p_indices[1]], pos[p_indices[2]], pos[p_indices[3]]
        b = skinning_info_bary_weights[i]
        b3 = 1.0 - b.sum()
        vis_mesh_pos[i] = b[0] * p0 + b[1] * p1 + b[2] * p2 + b3 * p3
```

该方法确保视觉网格平滑地跟随仿真网格的变形，在保持仿真效率的同时提供高质量渲染。

蒙皮计算借助空间哈希网格进行加速：

```python
def build_hash_grid():
    """Multi-step process to build the spatial hash grid for skinning acceleration"""
    grid_cell_counts.fill(0)
    
    @ti.kernel
    def count_verts_in_cells():
        for i in range(num_vis_verts):
            cell = get_grid_cell(vis_mesh_rest_pos[i])
            ti.atomic_add(grid_cell_counts[cell], 1)
    
    count_verts_in_cells()
    
    # Build prefix sum for cell starts
    total_verts = 0
    counts_np = grid_cell_counts.to_numpy()
    starts_np = np.zeros_like(counts_np)
    for i in range(GRID_SIZE):
        for j in range(GRID_SIZE):
            for k in range(GRID_SIZE):
                starts_np[i, j, k] = total_verts
                total_verts += counts_np[i, j, k]
    grid_cell_starts.from_numpy(starts_np)
```

这种空间加速结构使蒙皮计算期间能够高效地查找邻居，即使对复杂网格也能让预处理阶段非常快。

仿真中包含简单的盒体碰撞处理：

```python
@ti.func
def clamp_to_box(p):
    """Clamp a position to stay within the collision box bounds"""
    return ti.Vector([
        ti.max(box_min[0], ti.min(box_max[0], p[0])),
        ti.max(box_min[1], ti.min(box_max[1], p[1])),
        ti.max(box_min[2], ti.min(box_max[2], p[2]))
    ])

@ti.kernel
def pre_solve(dt: ti.f64, use_gravity: ti.i32):
    for i in range(num_particles):
        if inv_mass[i] == 0.0: continue
        if use_gravity != 0:
            vel[i] += gravity * dt
        prev_pos[i] = pos[i]
        pos[i] += vel[i] * dt
        
        pos[i] = clamp_to_box(pos[i])
```

这提供了基本的碰撞检测与响应，使粒子保持在仿真域内。

### 仿真结果

完整的网格实现通过几何约束展现出真实的体积行为，体现了恰当的变形、不可压缩性以及与边界的复杂交互。

<figure>
    <center>
        <img src="dragon.gif">
    </center>
        <figcaption><b>{{fig}}{fig:mesh:dragon}</b> 龙模型的体积网格仿真，展示了边约束与体积约束以及无条件稳定性。</figcaption>
</figure>




