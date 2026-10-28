## 高级流体效果：粘性与涡量

虽然 PBF 中的主要约束作用于位置，但为了模拟粘性等现象并重新引入损失的能量，仍需要在速度层面进行更新。这些更新在主基于位置的动力学（Position-Based Dynamics，PBD）求解器循环完成位置与速度的更新之后，作为后处理步骤施加。

**XSPH 粘性：** 为了获得更具内聚性的类液体运动并减少粒子间的混杂，需要施加 XSPH 粘性。它调整每个粒子的速度，使其更接近其邻居的平均速度：
$$
{{numeq}}{eq:pbf:xsph_viscosity}
\bm{v}_i^{\text{new}} = \bm{v}_i + c \sum_j (\bm{v}_j - \bm{v}_i) W(\bm{p}_i - \bm{p}_j, h)
$$
其中 $c$ 为正的粘性系数，通常取 $0.01$ 这样的较小值。

**涡量限制：** PBD 的迭代特性会引入数值阻尼，使流体损失旋转能量并显得过于粘稠。涡量限制可用于抵消这一效应：它计算每个粒子处的涡量（速度场的旋度）$\bm{\omega}_i = \nabla \times \bm{v}_i$，并施加修正力 $\bm{f}_{\text{vorticity}} = \varepsilon (\bm{N} \times \bm{\omega}_i)$。其中，$\bm{N}$ 是涡量模长梯度的归一化形式，$\bm{N} = \nabla|\bm{\omega}|/\|\nabla|\bm{\omega}|\|$，指向旋转增强的区域。该力重新引入小尺度的旋转细节。

### 实现：高级流体效果

XSPH 粘性与涡量限制都作为主 PBD 求解器之后的后处理步骤实现，以增强流体的真实感：

**XSPH 粘性的实现**

XSPH 粘性通过与邻居粒子取平均来平滑粒子速度：

```python
@ti.kernel
def apply_xsph_viscosity():
    """XSPH viscosity implementation - Equation {{eqref:eq:pbf:xsph_viscosity}}"""
    for i in positions:
        vel_i = velocities[i]
        delta_v = ti.Vector([0.0, 0.0, 0.0])
        for j in range(particle_num_neighbors[i]):
            p_j = particle_neighbors[i, j]
            pos_ji = positions[i] - positions[p_j]
            vel_ij = velocities[p_j] - vel_i
            w_ij = poly6_value(pos_ji.norm(), h)
            delta_v += vel_ij * w_ij
        velocity_deltas_xsph[i] = xsph_viscosity_c * delta_v

    for i in positions:
        velocities[i] += velocity_deltas_xsph[i]
```

这通过减小相邻粒子之间的速度差产生更具内聚性的类液体运动，有效地模拟了粘性行为。

**涡量限制的实现**

涡量限制重新引入在迭代约束求解过程中损失的旋转能量：

```python
@ti.kernel
def calculate_vorticity():
    """Calculate vorticity field: ω_i = ∇ × v_i"""
    for i in positions:
        vort_i = ti.Vector([0.0, 0.0, 0.0])
        for j in range(particle_num_neighbors[i]):
            p_j = particle_neighbors[i, j]
            pos_ji = positions[i] - positions[p_j]
            vel_ij = velocities[p_j] - velocities[i]
            vort_i += vel_ij.cross(spiky_gradient(pos_ji, h))
        vorticity[i] = vort_i
```

首先，通过相对速度与核函数梯度的叉积求速度场的旋度，从而计算涡量场。

```python
@ti.kernel
def apply_vorticity_confinement():
    """Apply vorticity confinement force: f_vorticity = ε(N × ω_i)"""
    for i in positions:
        eta = ti.Vector([0.0, 0.0, 0.0])
        vort_i_norm = vorticity[i].norm()
        for j in range(particle_num_neighbors[i]):
            p_j = particle_neighbors[i, j]
            pos_ji = positions[i] - positions[p_j]
            vort_j_norm = vorticity[p_j].norm()
            eta += (vort_j_norm - vort_i_norm) * spiky_gradient(pos_ji, h)
        
        eta_norm = eta.norm()
        if eta_norm > epsilon:
            N = eta / eta_norm
            vorticity_force[i] = vorticity_epsilon * N.cross(vorticity[i])
        else:
            vorticity_force[i] = ti.Vector([0.0, 0.0, 0.0])

    for i in velocities:
        velocities[i] += vorticity_force[i] * time_delta
```

限制力通过求涡量模长的梯度得到，并施加一个同时垂直于涡量向量及其梯度的修正力，从而重新引入小尺度的旋转细节。
