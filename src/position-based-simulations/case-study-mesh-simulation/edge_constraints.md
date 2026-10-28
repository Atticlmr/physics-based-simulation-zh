## 用于抗拉伸的边约束

体积约束保证不可压缩性，而边约束提供抗拉伸性，防止网格在外力作用下发生过度变形。这类约束把边长限制在其静止值上，从而维持体网格的结构完整性。

### 理论：距离约束形式

体网格中的边约束与布料仿真中所用的距离约束完全相同。四面体网格中的每条边都被视为其两个顶点之间的一个距离约束。

> **{{def}}{def:mesh:edge_constraint}[边距离约束]**
 给定由一条静止长度为 $d$ 的边相连的两个顶点，其位置为 $\bm{p}_1$ 与 $\bm{p}_2$，则边约束函数 $C$ 定义为：
 $$
 {{numeq}}{eq:mesh:edge_constraint}
 C(\bm{p}_1, \bm{p}_2) = \|\bm{p}_1 - \bm{p}_2\| - d
 $$
 当 $C=0$ 时约束得到满足。

该函数关于顶点位置的梯度为：
$$
\nabla_{\bm{p}_1} C = \frac{\bm{p}_1 - \bm{p}_2}{\|\bm{p}_1 - \bm{p}_2\|} = \bm{n} \quad \text{and} \quad \nabla_{\bm{p}_2} C = -\frac{\bm{p}_1 - \bm{p}_2}{\|\bm{p}_1 - \bm{p}_2\|} = -\bm{n}
$$
其中 $\bm{n}$ 是沿边方向的单位向量。

按照标准的基于位置的动力学（Position-Based Dynamics，PBD）投影公式，标量拉格朗日乘子 $\lambda$ 计算为：
$$
{{numeq}}{eq:mesh:edge_lambda}
\lambda = \frac{C(\bm{p}_1, \bm{p}_2)}{w_1\|\nabla_{\bm{p}_1} C\|^2 + w_2\|\nabla_{\bm{p}_2} C\|^2} = \frac{\|\bm{p}_1 - \bm{p}_2\| - d}{w_1 + w_2}
$$
其中 $w_i = 1/m_i$ 是顶点 $i$ 的逆质量。

位置修正量即为：
$$
{{numeq}}{eq:mesh:edge_correction}
\Delta\bm{p}_1 = - \frac{w_1}{w_1+w_2}(\|\bm{p}_1 - \bm{p}_2\| - d)\bm{n} \\
\Delta\bm{p}_2 = + \frac{w_2}{w_1+w_2}(\|\bm{p}_1 - \bm{p}_2\| - d)\bm{n}
$$

这些修正量按逆质量把约束违反量分配到两个顶点之间，从而保证动量守恒。

### 实现：边约束求解器


```python
@ti.kernel
def solve_edges(
    compliance: ti.f64, dt: ti.f64, num_edges: ti.i32,
    pos: ti.template(), edge_ids: ti.template(), edge_lengths: ti.template(),
    inv_mass: ti.template(), lambdas: ti.template()):
    """Solve edge constraints using PBD projection - implements Equation {{eqref:eq:mesh:edge_correction}}"""
    alpha = compliance / (dt * dt)
    for i in range(num_edges):
        id0, id1 = edge_ids[i, 0], edge_ids[i, 1]
        w0, w1 = inv_mass[id0], inv_mass[id1]
        w_sum = w0 + w1
        if w_sum == 0.0: continue
        delta = pos[id0] - pos[id1]
        dist = delta.norm()
        if dist == 0.0: continue
        grad = delta / dist
        C = dist - edge_lengths[i]
        dlambda = -(C + alpha * lambdas[i]) / (w_sum + alpha)
        lambdas[i] += dlambda
        pos[id0] += dlambda * w0 * grad
        pos[id1] -= dlambda * w1 * grad
```

该核函数直接实现了 {{eqref:eq:mesh:edge_correction}}。约束违反量 `C` 是当前距离与静止长度之差。拉格朗日乘子 `s` 遵循带柔度软化的 {{eqref:eq:mesh:edge_lambda}}。位置修正量以相反的符号施加，从而保持动量守恒。

求解约束需要静止长度，因此我们在仿真开始前一次性计算所有静止边长：

```python
@ti.kernel
def init_physics():
    """Initialize physics state including rest lengths for edge constraints"""
    for i in range(num_edges):
        id0, id1 = edge_ids[i, 0], edge_ids[i, 1]
        edge_lengths[i] = (pos[id0] - pos[id1]).norm()
```

```python
def substep():
    pre_solve(sdt, 1, num_particles, gravity, box_min, box_max, pos, prev_pos, vel, inv_mass)
    # XPBD: reset lambdas once per substep (they accumulate across solver iterations)
    reset_constraint_lambdas(num_edges, num_tets, edge_lambdas, vol_lambdas)
    for _ in range(solver_iterations):
        solve_edges(edge_compliance, sdt, num_edges, pos, edge_ids, edge_lengths, inv_mass, edge_lambdas)
        solve_volumes(vol_compliance, sdt, num_tets, pos, tet_ids, rest_vol, inv_mass, vol_id_order, vol_lambdas)
    post_solve(sdt, num_particles, pos, prev_pos, vel, inv_mass)
```

在每次迭代中，边约束先于体积约束求解。这一顺序使体积约束在边约束提供局部结构完整性之后，能够基于更稳定的网格结构工作。

```python
edge_compliance = 0.0  # Very stiff stretching (nearly inextensible)
vol_compliance = 0.0   # Very stiff volume (nearly incompressible)
```

柔度值越小，材料越刚硬。边柔度与体积柔度之间的关系决定了材料行为：高边柔度配合低体积柔度会得到柔软、可压缩的材料，而两者都取低值则得到刚硬、不可压缩的材料。
