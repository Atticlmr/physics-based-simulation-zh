## 离散化与近似

由公式 {{eqref: eq:lec18:smooth-frict}}，单位面积上的摩擦力定义为

$$
\mathbf{T}_F(\mathbf{X}, t) = - \mu \|\mathbf{T}_C(\mathbf{X}, t)\| \ f(\|\mathbf{V}_F(\mathbf{X}, t)\|) \ \mathbf{s}(\mathbf{V}_F(\mathbf{X}, t)),
$$

其中 $\mu$ 为摩擦系数，$\mathbf{T}_C$ 为法向接触力，$\mathbf{V}_F$ 为相对滑动速度。这里当 $\|\mathbf{V}_F\| > 0$ 时 $\mathbf{s}(\mathbf{V}_F) = \frac{\mathbf{V}_F}{\|\mathbf{V}_F\|}$，而当 $\|\mathbf{V}_F\| = 0$ 时 $\mathbf{s}(\mathbf{V}_F)$ 取任意与法向 $\mathbf{N}(\mathbf{X}, t)$ 正交的单位向量。此外，摩擦缩放函数 $f$ 关于 $\mathbf{V}_F$ 同样是不可微的：当 $\|\mathbf{V}_F\| > 0$ 时 $f(\|\mathbf{V}_F\|) = 1$，而当 $\|\mathbf{V}_F\| = 0$ 时 $f(\|\mathbf{V}_F\|) \in [0, 1]$。

需要注意，若不进行时间离散，摩擦并不存在对应的势能。然而，与[摩擦接触](../3d-frictional-self-contact/friction.md)类似，一旦我们把法向力大小与切向算子离散到上一个时间步，并对摩擦缩放函数 $f$ 作光滑近似，第 $(n+1)$ 个时间步上的摩擦力就变得关于 $\mathbf{x}$ 可积，从而得到

$$
\mathbf{T}^{n+1}_F(\mathbf{X}) \approx -\frac{\partial D^{n+1}(\mathbf{X})}{\partial \mathbf{x}^{n+1}(\mathbf{X})} = -\frac{\partial \big( \mu \|\mathbf{T}^{n}_C(\mathbf{X})\| f_0(\| \bar{\mathbf{V}}^{n+1}_F(\mathbf{X}) \hat{h} \|)  \big)}{\partial \mathbf{x}^{n+1}(\mathbf{X})}.
$$

这里，$\bar{\mathbf{V}}^{n+1}_F(\mathbf{X}) = (\mathbf{I} - \mathbf{N}^{n}(\mathbf{X}) \mathbf{N}^{n}(\mathbf{X})^T) (\mathbf{V}^{n+1}(\mathbf{X}) - \mathbf{V}^{n+1}(\mathbf{X}_2))$ 为近似相对滑动速度，其中 $\mathbf{N}^{n}$ 与 $\mathbf{X}_2$ 分别是上一个时间步的法向方向以及与 $\mathbf{X}$ 相接触的点，$\hat{h}I = (\partial v/\partial x)^{-1}$，并且

$$
f_0(y) =
\begin{cases}
    -\frac{y^3}{3\epsilon_v^2 \hat{h}^2} + \frac{y^2}{\epsilon_v \hat{h}} + \frac{\epsilon_v  \hat{h}}{3}, & y \in[0, \epsilon_v \hat{h}); \\
    y, & y \geq  \epsilon_v \hat{h}.
\end{cases}
$$

因此，考虑自接触后，整个边界上的近似摩擦势能可以写为

$$
\int_{\Gamma_C} \frac{1}{2}  \mu \|\mathbf{T}^{n}_C(\mathbf{X})\| f_0(\| \bar{\mathbf{V}}^{n+1}_F(\mathbf{X}) \hat{h} \|) \, ds(\mathbf{X}),
$$

其中 $\frac{1}{2}$ 这一系数来自积分中对每一对接触点之间摩擦力的重复计数（与[边界条件与摩擦接触](../../governing-equations/boundary-conditions-and-frictional-contact/BC_and_fric.md)中法向接触力的情形类似）。

在把边界曲线离散为折线、并用求和近似法向接触力分量中的 max 算子之后（[分段线性边界](../piecewise-linear-boundaries/pw_linear_boundary.md)），我们同样可以得到空间离散后的摩擦势能：

$$
\int_{\Gamma_C} \sum_{e \in \mathcal{E} - I(\mathbf{X})} \frac{1}{2} \mu \left(-\frac{\partial b( d^\text{PE}(\mathbf{x}^{n}(\mathbf{X}), e), \hat{d})}{\partial d}\right) f_0(\| \bar{\mathbf{V}}^{n+1}_F(\mathbf{X}, e) \hat{h} \|) \, ds(\mathbf{X}).
$$

这里，$d^\text{PE}(\mathbf{x}^{n}(\mathbf{X}), e)$ 是 $\mathbf{x}^{n}(\mathbf{X})$ 与边 $e$ 在上一个时间步的点-边距离，$\bar{\mathbf{V}}^{n+1}_F(\mathbf{X}, e)$ 是该点-边对在接触法向与最近点均离散到上一个时间步时的近似相对滑动速度（详见下一节）。

若选取边界节点作为求积点来近似该积分，我们最终得到离散的摩擦势能：

$$
\begin{aligned}
    P_f(x) 
    & = \sum_{\hat{a}} A_{\hat{a}} \sum_{e \in \mathcal{E} - I(\mathbf{X}_{\hat{a}})} \frac{1}{2}\mu \left(-\frac{\partial b( d^\text{PE}(\mathbf{x}^{n}_{\hat{a}}, e), \hat{d})}{\partial d}\right) f_0(\| \bar{\mathbf{V}}^{n+1}_F(\mathbf{X}_{\hat{a}}, e) \hat{h} \|) \\
    & = \sum_{k \in \{ (\hat{a}, e) \} } \mu \lambda_k^{n} f_0(\|\bar{\mathbf{v}}_k \hat{h}\|)
\end{aligned}
$$

其中 $A_{\hat{a}} = \frac{\|\mathbf{X}_{\hat{a}} - \mathbf{X}_{\hat{a} - 1} \| + \|\mathbf{X}_{\hat{a}} - \mathbf{X}_{\hat{a} + 1} \|}{2}$ 为积分权重。记 $\bar{\mathbf{v}}_k = \bar{\mathbf{V}}^{n+1}_F(\mathbf{X}_{\hat{a}}, e)$、$\lambda^{n}_k = \frac{1}{2}A_{\hat{a}} \left(-\frac{\partial b( d^\text{PE}(\mathbf{x}^{n}_{\hat{a}}, e), \hat{d})}{\partial d}\right)$，则 $P_f$ 的表达式与我们直接推导出的公式 {{eqref: eq:lec9:fric_potential}} 的离散形式一致，区别仅在于此处的 $k$ 遍历边界上所有非相邻的点-边对。

基于这一光滑半隐式摩擦势能的离散形式，我们现在需要确定如何计算点-边对的 $\lambda$ 与 $\bar{\mathbf{v}}$，实现 $P_f(x)$ 的值、梯度与海森矩阵的计算，并把它们纳入优化之中。
