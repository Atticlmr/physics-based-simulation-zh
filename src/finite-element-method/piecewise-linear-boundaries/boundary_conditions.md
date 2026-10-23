## 边界条件

### 狄利克雷

得益于有限元方法（FEM）精确的边界分辨率，施加狄利克雷边界条件十分直接。我们只需把边界节点的世界空间坐标约束到给定值：

$$
\hat{\mathbf{x}}(\mathbf{X}_i) = \mathbf{x}_D(\mathbf{X}_i) \quad \forall \ \mathbf{X}_i \in \Gamma_D.
$$

一旦正确施加了这些约束，狄利克雷边界积分项就可以忽略。

同一机制也可用于指定任意内部节点的位移。虽然这并不直接对应任何物理效应，但可以简化仿真设置。

### 诺伊曼

对于诺伊曼边界条件，我们可以用参数空间变量 $\beta$ 与 $\gamma$ 来计算边界积分项。在三角形网格离散下，有：

$$
\int_{\Gamma_N} N_{\hat{a}}(\mathbf{X}) T_{\hat{i}}(\mathbf{X},t^n) \, ds(\mathbf{X}) = \sum_{e \in \mathcal{T}} \int_{\partial \Omega_e^0 \cap \Gamma_N} N_{\hat{a}}(\mathbf{X}) T_{\hat{i}}(\mathbf{X}, t^n) \, ds(\mathbf{X}),
$$

其中 $\partial \Omega_e^0 \cap \Gamma_N$ 是三角形 $e$ 位于诺伊曼边界上的那条边。

对二维中的任意边界节点 $\hat{a}$，采用线性形函数时积分至多只需考虑两个关联三角形。我们来考察有两个关联三角形的情形，并只看其中一个积分。不失一般性，设 $N_{\hat{a}} = \beta$（即 $\mathbf{X}_{\hat{a}}$ 对应三角形 $e$ 中的 $\mathbf{X}_2$），并设 $\mathbf{X}_3$ 是 $e$ 位于边界边上的另一个节点。则把积分变量换为 $\beta$ 可得：

$$
\int_{\partial \Omega_e^0 \cap \Gamma_N} N_{\hat{a}}(\mathbf{X}) T_{\hat{i}}(\mathbf{X}, t^n) \, ds(\mathbf{X}) = \int_0^1 \beta T_{\hat{i}}(\beta \mathbf{X}_2 + (1 - \beta) \mathbf{X}_3, t^n) \left| \frac{\partial s}{\partial \beta} \right| d\beta.
$$

这里 $\left| \frac{\partial s}{\partial \beta} \right|$ 就是边长 $\|\mathbf{X}_2 - \mathbf{X}_3\|$。若 $T$ 在 $t^n$ 时刻沿边界为常值，则可算出：

$$
T^n_{\hat{i}} \int_0^1 \beta \left| \frac{\partial s}{\partial \beta} \right| d\beta = \frac{1}{2} \|\mathbf{X}_2 - \mathbf{X}_3\| T^n_{\hat{i}}.
$$

因此，要想给离散系统施加一个常值的诺伊曼力，我们先计算每个边界节点的长度权重，即把边界边的长度平均分配到其两个顶点上，再乘以面力 $T_{\hat{i}}^n$。如果 $\mathbf{T}$ 沿边界不是常值，就需要进行更复杂的边界积分计算。对于只有一个关联三角形的边界节点，其长度权重来自同一三角形内与它相连的两条边。

> **{{rem}}{rem:lec20:neumann_potential}[诺伊曼边界条件]** 这里我们注意到，标准诺伊曼边界条件中给定的面力与 $\mathbf{x}$ 无关，这简化了势能的推导，即便在连续情形下诺伊曼力沿域变化也是如此：
$$
\int_{\Gamma_N} \mathbf{x}(\mathbf{X}) \cdot \mathbf{T}(\mathbf{X}, t^n) \, ds(\mathbf{X}).
{{numeq}}{eq:lec20:neumann_potential}
$$
为验证这一点，我们可以把 $\mathbf{x}(\mathbf{X})$ 替换为空间离散化后的 $\hat{\mathbf{x}}(\mathbf{X}) = N_{\hat{a}}(\mathbf{X}) \mathbf{x}_{\hat{a}} + \ldots$。对 $\mathbf{x}_{\hat{a}}$ 求导即可得到离散弱形式中的力积分项：
$$
\frac{\partial \int_{\Gamma_N} \hat{\mathbf{x}}(\mathbf{X}) \cdot \mathbf{T}(\mathbf{X}, t^n) \, ds(\mathbf{X})}{\partial \mathbf{x}_{\hat{a}}} = \int_{\Gamma_N} N_{\hat{a}}(\mathbf{X}) \mathbf{T}(\mathbf{X}, t^n) \, ds(\mathbf{X}).
$$
