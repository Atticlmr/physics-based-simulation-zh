## 摩擦力

与[摩擦接触](../../finite-element-method/3d-frictional-self-contact/friction.md)类似，在库仑约束下最大化耗散率，可以变分地定义单位面积上的摩擦力：

$$
\begin{aligned}
    \mathbf{T}_F(\mathbf{X}, t) = \argmin_{\boldsymbol{\beta} \in \mathbb{R}^d} \boldsymbol{\beta}^T \mathbf{V}_F(\mathbf{X}, t) \\
    \text{s.t.} \quad \|\boldsymbol{\beta}\| \leq \mu \|\mathbf{T}_C(\mathbf{X}, t)\| \ \ \text{and} \ \ \boldsymbol{\beta} \cdot \mathbf{N}(\mathbf{X}, t) = 0.
\end{aligned}
{{numeq}}{eq:lec18:frictionForceDef}
$$

此处，$\mathbf{V}_F(\mathbf{X}, t) = \mathbf{V}(\mathbf{X}, t) - \mathbf{V}(\mathbf{X}_2, t)$ 是 $\mathbf{X}$ 与最近点 $\mathbf{X}_2 = \text{arg}\min_{\mathbf{X}_2 \in \Gamma_C - \mathcal{N}(\mathbf{X)}} \|\mathbf{X} - \mathbf{X}_2\|$ 之间的相对滑动速度，$\mu$ 为摩擦系数，$\mathbf{T}_C$ 为单位面积上的法向接触力，$\mathbf{N}$ 为法向。

这等价于：

$$
\mathbf{T}_F(\mathbf{X}, t) = - \mu \|\mathbf{T}_C(\mathbf{X}, t)\| \ f(\|\mathbf{V}_F(\mathbf{X}, t)\|) \ \mathbf{s}(\mathbf{V}_F(\mathbf{X}, t)),
{{numeq}}{eq:lec18:smooth-frict}
$$

其中当 $\|\mathbf{V}_F\| > 0$ 时 $\mathbf{s}(\mathbf{V}_F) = \frac{\mathbf{V}_F}{\|\mathbf{V}_F\|}$，而当 $\|\mathbf{V}_F\| = 0$ 时 $\mathbf{s}(\mathbf{V}_F)$ 取任意与 $\mathbf{N}(\mathbf{X}, t)$ 正交的单位向量。

此外，摩擦缩放函数 $f$ 关于 $\mathbf{V}_F$ 也是非光滑的，因为当 $\|\mathbf{V}_F\| > 0$ 时 $f(\|\mathbf{V}_F\|) = 1$，而当 $\|\mathbf{V}_F\| = 0$ 时 $f(\|\mathbf{V}_F\|) \in [0,1]$。这些非光滑性质会严重阻碍、甚至破坏基于梯度的优化的收敛性。此处对摩擦-速度关系的磨光处理，采用与[摩擦接触](../../finite-element-method/3d-frictional-self-contact/friction.md)相同的方式。
