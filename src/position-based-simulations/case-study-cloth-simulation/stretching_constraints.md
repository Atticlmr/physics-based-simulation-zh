## 通过距离约束实现抗拉伸性

大多数纺织品的主要特点是具有很强的抗拉伸能力。在基于位置的动力学（Position-Based Dynamics，PBD）中，这一性质通过约束相连粒子之间的距离，使其保持在初始（静止）距离附近来实现。这是基于位置的动力学（PBD）体系中最简单、也最关键的约束之一。

### 理论：距离约束形式

考虑两个粒子 $i=1, 2$，其位置为 $\bm{p}_1$ 与 $\bm{p}_2$，质量为 $m_1$ 与 $m_2$，二者之间的静止距离为 $d$。拉伸约束函数 $C$ 定义为当前距离与静止距离之差：

> **{{def}}{def:cloth:stretching_constraint}[拉伸约束]**
两个粒子的拉伸约束函数 $C$ 为：
$$
{{numeq}}{eq:cloth:stretch_constraint}
C(\bm{p}_1, \bm{p}_2) = \|\bm{p}_1 - \bm{p}_2\| - d
$$
目标是求出修正量 $\Delta\bm{p}_1$ 与 $\Delta\bm{p}_2$，使得 $C(\bm{p}_1+\Delta\bm{p}_1, \bm{p}_2+\Delta\bm{p}_2) = 0$。

约束函数关于粒子位置的梯度为：
$$
\nabla_{\bm{p}_1} C = \frac{\bm{p}_1 - \bm{p}_2}{\|\bm{p}_1 - \bm{p}_2\|} = \bm{n} \quad \text{and} \quad \nabla_{\bm{p}_2} C = -\frac{\bm{p}_1 - \bm{p}_2}{\|\bm{p}_1 - \bm{p}_2\|} = -\bm{n}
$$
其中 $\bm{n}$ 是沿连接两粒子轴线方向的单位向量。

按照通用的基于位置的动力学（PBD）投影公式，标量拉格朗日乘子 $\lambda$ 计算为：
$$
{{numeq}}{eq:cloth:lambda_stretch}
\lambda = \frac{C(\bm{p}_1, \bm{p}_2)}{w_1\|\nabla_{\bm{p}_1} C\|^2 + w_2\|\nabla_{\bm{p}_2} C\|^2} = \frac{\|\bm{p}_1 - \bm{p}_2\| - d}{w_1 + w_2}
$$
其中 $w_i = 1/m_i$ 是粒子 $i$ 的逆质量。

随后，让粒子沿各自的梯度方向移动，并按逆质量与 $\lambda$ 缩放，即得位置修正量：
$$
{{numeq}}{eq:cloth:position_correction}
\Delta\bm{p}_1 = - \frac{w_1}{w_1+w_2}(\|\bm{p}_1 - \bm{p}_2\| - d)\bm{n} \\
\Delta\bm{p}_2 = + \frac{w_2}{w_1+w_2}(\|\bm{p}_1 - \bm{p}_2\| - d)\bm{n}
$$

施加这些修正后，粒子将恰好满足静止长度。总修正量按逆质量在两个粒子之间分配，从而保证较轻的粒子移动得比重粒子更多，同时保持线动量守恒。

为了获得不同的弹性程度，可以引入刚度参数 $k \in [0, 1]$，将修正量 $\Delta\bm{p}_i$ 乘以 $k$。这样便能得到弹性各异的材料，从完全刚性（$k=1$）到完全不刚（$k=0$）。

### 实现：距离约束求解器

```python
@ti.kernel
def solve_stretching_constraints(
    compliance: ti.f64, dt: ti.f64, num_stretching_constraints: ti.i32,
    pos: ti.template(), stretching_ids: ti.template(), stretching_lengths: ti.template(),
    inv_mass: ti.template(), lambdas: ti.template()):
    """Solve stretching constraints using PBD projection - implements Equation {{eqref:eq:cloth:position_correction}}"""
    alpha = compliance / (dt * dt)
    for i in range(num_stretching_constraints):
        id0, id1 = stretching_ids[i, 0], stretching_ids[i, 1]
        w0, w1 = inv_mass[id0], inv_mass[id1]
        w_sum = w0 + w1
        if w_sum == 0.0: continue
        p0, p1 = pos[id0], pos[id1]
        delta = p0 - p1
        dist = delta.norm()
        if dist == 0.0: continue
        grad = delta / dist
        C = dist - stretching_lengths[i]
        dlambda = -(C + alpha * lambdas[i]) / (w_sum + alpha)
        lambdas[i] += dlambda
        pos[id0] += dlambda * w0 * grad
        pos[id1] -= dlambda * w1 * grad
```

该核函数直接实现了 {{eqref:eq:cloth:position_correction}}。约束违反量 `C` 是当前距离与静止长度之差。拉格朗日乘子 `s` 遵循带柔度软化的 {{eqref:eq:cloth:lambda_stretch}}。位置修正量以相反的符号施加，以保持动量守恒。

求解约束需要静止长度，因此我们在仿真开始前一次性计算所有静止边长：

```python
@ti.kernel
def init_physics():
    """Initialize physics state including rest lengths for constraints"""
    for i in range(num_stretching_constraints):
        id0, id1 = stretching_ids[i, 0], stretching_ids[i, 1]
        stretching_lengths[i] = (pos[id0] - pos[id1]).norm()
```

为确定哪些边构成约束，我们从三角形网格拓扑中提取所有不重复的边：

```python
def find_constraint_indices(tri_ids_np):
    """Extract edge constraints from triangle mesh topology"""
    edge_to_tri_map = {}
    for i, tri in enumerate(tri_ids_np):
        for j in range(3):
            v0_idx, v1_idx = tri[j], tri[(j + 1) % 3]
            edge = tuple(sorted((v0_idx, v1_idx)))
            if edge not in edge_to_tri_map:
                edge_to_tri_map[edge] = []
            edge_to_tri_map[edge].append(i)
    
    stretching_ids = list(edge_to_tri_map.keys())
    return np.array(stretching_ids, dtype=np.int32)
```

该函数处理三角形网格，找出所有不重复的边，它们即成为拉伸约束。`sorted` 元组保证无论三角形的朝向如何，每条边都以一致的方式表示。
