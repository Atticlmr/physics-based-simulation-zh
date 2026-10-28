## 基于位置的流体中的密度约束

### 逐粒子密度约束

PBF 的基本原理是确保每个流体粒子周围的密度保持恒定。给定粒子位置处的密度通过对其邻居进行基于核函数的求和来估计。

位置为 $\bm{p}_i$ 的粒子 $i$ 的密度 $\rho_i$ 估计为：
$$
{{numeq}}{eq:pbf:sph_density}

\rho_i = \sum_{j} m_j W(\bm{p}_i - \bm{p}_j, h)
$$
其中求和遍历所有邻居粒子 $j$，$m_j$ 为粒子 $j$ 的质量，$h$ 为平滑核半径，$W$ 为径向对称的平滑核函数。为简单起见，我们可以假设所有粒子质量相等，并将其并入密度计算中。

目标是强制该估计密度 $\rho_i$ 与用户定义的静止密度 $\rho_0$ 一致。这可以表述为逐粒子约束函数 $C_i$。

> **{{def}}{def:pbf:density_constraint}[PBF 密度约束]**
> 对每个粒子 $i$，密度约束 $C_i$ 定义为相对静止密度 $\rho_0$ 的缩放偏差：
$$
{{numeq}}{eq:pbf:constraint_func}
C_i(\bm{p}_1, ..., \bm{p}_N) = \frac{\rho_i}{\rho_0} - 1
$$
该约束在 $C_i = 0$ 时得到满足。

为求解该约束系统，PBF 为每个粒子计算位置修正 $\Delta \bm{p}_i$。按照基于位置的动力学（Position-Based Dynamics，PBD）方法，我们首先计算 $C_i$ 关于粒子 $k$ 位置的梯度：
$$
{{numeq}}{eq:pbf:constraint_gradient}
\nabla_{\bm{p}_k} C_i = \frac{1}{\rho_0} \sum_{j} m_j \nabla_{\bm{p}_k} W(\bm{p}_i - \bm{p}_j, h) =
\begin{cases}
\frac{1}{\rho_0} \sum_j m_j \nabla W(\bm{p}_i - \bm{p}_j, h) & \text{if } k=i \\
-\frac{m_k}{\rho_0} \nabla W(\bm{p}_i - \bm{p}_k, h) & \text{if } k \ne i
\end{cases}
$$
标准 PBD 求解器使用公式 $\lambda_i = -C_i / (\sum_k \|\nabla_{\bm{p}_k} C_i\|^2)$ 为每个约束 $C_i$ 计算一个拉格朗日乘子 $\lambda_i$。粒子 $\Delta\bm{p}_i$ 的位置修正则来自其自身约束与邻居约束的共同影响。由于核函数梯度的对称性（$\nabla_{\bm{p}_i} W(\bm{p}_i - \bm{p}_j, h) = -\nabla_{\bm{p}_j} W(\bm{p}_i - \bm{p}_j, h)$），粒子 $i$ 的位置修正最终得到一个简洁高效的更新规则：
$$
{{numeq}}{eq:pbf:position_correction}
\Delta \bm{p}_i = \frac{1}{\rho_0} \sum_j (\lambda_i + \lambda_j) \nabla W(\bm{p}_i - \bm{p}_j, h)
$$
这里通常使用另一种核函数，即 Spiky 核，因为它的梯度不会在原点处消失，从而能防止粒子聚集。

> **{{rem}}{rem:pbf:regularization}[鲁棒性与约束软化]**
> 当某个粒子的邻居很少时会出现一个实际问题：分母 $\sum_k \|\nabla_{\bm{p}_k} C_i\|^2$ 可能趋近于零，从而导致位置修正过大且不稳定。为避免这种情况，我们在分母中加入一个很小的松弛参数 $\varepsilon$ 来软化约束。这被称为约束力混合（Constraint Force Mixing，CFM）{{#cite smith2005open}}。于是：
$$
{{numeq}}{eq:pbf:lambda_cfm}
\lambda_i = - \frac{C_i(\bm{p}_1, ..., \bm{p}_N)}{\sum_k \|\nabla_{\bm{p}_k} C_i\|^2 + \varepsilon}
$$

### 实现：核函数

PBF 实现需要两种不同的核函数，各有特定用途：

**用于密度估计的 Poly6 核**

Poly6 核用于通过对邻居粒子进行平滑加权来估计粒子密度：

```python
@ti.func
def poly6_value(s, h_):
    """Poly6 kernel for density estimation - implements Equation {{eqref:eq:pbf:sph_density}}"""
    result = 0.0
    if 0 < s and s < h_:
        x = (h_ * h_ - s * s) / (h_ * h_ * h_)
        result = poly6_factor * x * x * x
    return result
```

该核函数在紧支撑半径 `h` 内提供平滑的密度估计。三次衰减保证远处粒子对密度计算的影响极小，从而产生真实的流体行为。

**用于位置修正的 Spiky 核**

Spiky 核用于计算位置修正，因为它在原点附近的梯度不会消失，从而防止粒子聚集：

```python
@ti.func  
def spiky_gradient(r, h_):
    """Spiky kernel gradient for position corrections - used in Equation {{eqref:eq:pbf:position_correction}}"""
    result = ti.Vector([0.0, 0.0, 0.0])
    r_len = r.norm()
    if 0 < r_len and r_len < h_:
        x = (h_ - r_len) / (h_ * h_ * h_)
        g_factor = spiky_grad_factor * x * x
        result = r * g_factor / r_len
    return result
```

Spiky 核的线性衰减在粒子彼此靠近时提供很强的排斥力，这对维持恰当的粒子间距、避免聚集伪影至关重要。

### 实现：密度约束求解器

密度约束求解器实现了理论章节中描述的三阶段 PBD 算法：

**阶段 1：计算拉格朗日乘子**

```python
@ti.kernel
def solve_density_constraints():
    # Phase 1: Compute Lagrange multipliers λ_i for each particle
    for p_i in positions:
        pos_i = positions[p_i]
        grad_i, sum_gradient_sqr, density_constraint = ti.Vector([0.0, 0.0, 0.0]), 0.0, 0.0

        for j in range(particle_num_neighbors[p_i]):
            p_j = particle_neighbors[p_i, j]
            pos_ji = pos_i - positions[p_j]
            grad_j = spiky_gradient(pos_ji, h)
            grad_i += grad_j
            sum_gradient_sqr += grad_j.dot(grad_j)
            density_constraint += poly6_value(pos_ji.norm(), h)

        # Implement Equation {{eqref:eq:pbf:constraint_func}}: C_i = ρ_i/ρ₀ - 1
        density_constraint = (mass * density_constraint / rho0) - 1.0
        sum_gradient_sqr += grad_i.dot(grad_i)
        
        # Implement Equation {{eqref:eq:pbf:lambda_cfm}}: CFM regularization
        denominator = (1.0 / mass) * sum_gradient_sqr + lambda_epsilon
        lambdas[p_i] = -density_constraint / denominator if denominator > epsilon else 0.0
```

该阶段为每个粒子计算约束违反量，并计算相应的拉格朗日乘子。CFM 正则化可防止粒子邻居很少时出现数值不稳定。

**阶段 2：计算位置修正**

```python
    # Phase 2: Compute position corrections using Equation {{eqref:eq:pbf:position_correction}}
    for p_i in positions:
        pos_i = positions[p_i]
        lambda_i = lambdas[p_i]
        pos_delta_i = ti.Vector([0.0, 0.0, 0.0])

        for j in range(particle_num_neighbors[p_i]):
            p_j = particle_neighbors[p_i, j]
            lambda_j = lambdas[p_j]
            pos_ji = pos_i - positions[p_j]
            pos_delta_i += (lambda_i + lambda_j) * spiky_gradient(pos_ji, h)
        
        position_deltas[p_i] = pos_delta_i / rho0
```

该阶段使用对称约束公式为每个粒子计算位置修正。修正量同时取决于该粒子自身的约束违反量及其邻居的约束违反量。

**阶段 3：应用位置修正**

```python
    # Phase 3: Apply position corrections
    for i in positions:
        positions[i] += position_deltas[i]
```

最后一个阶段应用计算得到的修正量来更新粒子位置，从而满足密度约束。
