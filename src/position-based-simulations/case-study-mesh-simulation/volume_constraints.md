## 体积守恒约束

对不可压缩或近似不可压缩材料的仿真是计算机图形学中许多应用的关键。在基于力的框架中，不可压缩性通常需要求解复杂的压力泊松方程。基于位置的动力学（Position-Based Dynamics，PBD）则提供了一种更直接、往往也更简单的方法：通过几何约束来强制体积守恒。

### 理论：四面体体积约束形式

对于离散为四面体网格的体积对象，可以通过约束每个四面体的体积保持其静止体积来近似不可压缩性。

> **{{def}}{def:volume:tetrahedral}[四面体体积约束]**
 给定由位置为 $\bm{p}_1, \bm{p}_2, \bm{p}_3, \bm{p}_4$ 的四个顶点定义的四面体及其静止体积 $V_0$，体积约束函数 $C$ 定义为：
 $$
 {{numeq}}{eq:volume:tetra_constraint}
 C(\bm{p}_1, \bm{p}_2, \bm{p}_3, \bm{p}_4) = \frac{1}{6} \left( (\bm{p}_2 - \bm{p}_1) \times (\bm{p}_3 - \bm{p}_1) \right) \cdot (\bm{p}_4 - \bm{p}_1) - V_0
 $$
 该约束在 $C=0$ 时得到满足。

该函数关于四个顶点位置的梯度为：
$$
\begin{aligned}
\nabla_{\bm{p}_1} C &= \frac{1}{6} \left( (\bm{p}_3 - \bm{p}_2) \times (\bm{p}_4 - \bm{p}_2) \right) \\
\nabla_{\bm{p}_2} C &= \frac{1}{6} \left( (\bm{p}_4 - \bm{p}_3) \times (\bm{p}_1 - \bm{p}_3) \right) \\
\nabla_{\bm{p}_3} C &= \frac{1}{6} \left( (\bm{p}_1 - \bm{p}_4) \times (\bm{p}_2 - \bm{p}_4) \right) \\
\nabla_{\bm{p}_4} C &= \frac{1}{6} \left( (\bm{p}_2 - \bm{p}_1) \times (\bm{p}_3 - \bm{p}_1) \right)
\end{aligned}
$$

这些梯度——与对面面积成正比的向量——用于计算四个顶点的位置修正。按照标准的 PBD 投影机制，拉格朗日乘子 $\lambda$ 计算为：

$$
{{numeq}}{eq:volume:lambda}
\lambda = \frac{C(\bm{p}_1, \bm{p}_2, \bm{p}_3, \bm{p}_4)}{\sum_{i=1}^{4} w_i \|\nabla_{\bm{p}_i} C\|^2}
$$

其中 $w_i = 1/m_i$ 为顶点 $i$ 的逆质量。位置修正则为：

$$
{{numeq}}{eq:volume:position_correction}
\Delta\bm{p}_i = -\lambda w_i \nabla_{\bm{p}_i} C
$$

### 实现：体积约束求解器

```python
@ti.kernel
def solve_volumes(
    compliance: ti.f64, dt: ti.f64, num_tets: ti.i32,
    pos: ti.template(), tet_ids: ti.template(), rest_vol: ti.template(), inv_mass: ti.template(),
    vol_id_order: ti.template(), lambdas: ti.template()):
    """Solve volume constraints using PBD projection - implements Equation {{eqref:eq:volume:position_correction}}"""
    alpha = compliance / (dt * dt)
    for i in range(num_tets):
        p_indices = ti.Vector([tet_ids[i, 0], tet_ids[i, 1], tet_ids[i, 2], tet_ids[i, 3]])
        w_sum = 0.0
        grads = ti.Matrix.zero(ti.f64, 4, 3)
        for j in ti.static(range(4)):
            ids = ti.Vector([p_indices[vol_id_order[j, c]] for c in range(3)])
            p0, p1, p2 = pos[ids[0]], pos[ids[1]], pos[ids[2]]
            grad = (p1 - p0).cross(p2 - p0) / 6.0
            grads[j, :] = grad
            w_sum += inv_mass[p_indices[j]] * grad.norm_sqr()
        if w_sum == 0.0: continue
        C = get_tet_volume(p_indices, pos) - rest_vol[i]
        dlambda = -(C + alpha * lambdas[i]) / (w_sum + alpha)
        lambdas[i] += dlambda
        for j in ti.static(range(4)):
            pos[p_indices[j]] += dlambda * inv_mass[p_indices[j]] * grads[j, :]
```

该核函数使用公式 {{eqref:eq:volume:tetra_constraint}} 中的叉积公式计算梯度。`vol_id_order` 数组确保叉积所用顶点顺序正确。约束违反量 `C` 按当前体积与静止体积之差计算，拉格朗日乘子 `s` 遵循带柔度软化项的公式 {{eqref:eq:volume:lambda}}。

```python
@ti.func
def get_tet_volume(p_indices):
    """Calculate tetrahedral volume using scalar triple product - implements Equation {{eqref:eq:volume:tetra_constraint}}"""
    p0, p1, p2, p3 = pos[p_indices[0]], pos[p_indices[1]], pos[p_indices[2]], pos[p_indices[3]]
    return (p1 - p0).cross(p2 - p0).dot(p3 - p0) / 6.0
```

该函数使用标量三重积公式实现了公式 {{eqref:eq:volume:tetra_constraint}} 中的体积计算。

```python
@ti.kernel
def init_physics():
    """Initialize physics state including rest volumes for constraints"""
    inv_mass.fill(0.0)
    for i in range(num_tets):
        p_indices = ti.Vector([tet_ids[i, 0], tet_ids[i, 1], tet_ids[i, 2], tet_ids[i, 3]])
        vol = get_tet_volume(p_indices)
        rest_vol[i] = vol
        if vol > 0.0:
            p_inv_mass = 1.0 / (vol / 4.0)
            for j in ti.static(range(4)):
                inv_mass[p_indices[j]] += p_inv_mass
```

静止体积在初始化时计算一次并存储，供约束求解使用。质量按四面体体积分配，因此属于较大四面体的顶点具有更大的质量。
