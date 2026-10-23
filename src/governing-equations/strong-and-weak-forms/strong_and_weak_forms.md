# 强形式与弱形式

固体仿真中所使用的更新规则（参见方程 {{eqref: eq:lec1:updateRule_implicit}}）以及相应的优化问题（参见方程 {{eqref: eq:lec2:optimization_IE}}），都是通过对守恒定律——也就是我们的控制方程——的连续形式进行离散而导出的。本章将探讨这些守恒定律的强形式与弱形式的推导过程。随后我们将讨论它们的时间与空间离散化方法，这些方法对于建立我们要求解的离散问题至关重要。

我们研究的核心基本控制方程是质量守恒与动量守恒（牛顿第二定律）。下面先列出这些方程，本讲稍后给出详细推导。

> {{def}}{def:lec16:strong_form}[强形式]
> 设 $\mathbf{V}(\mathbf{X},t)=\frac{\partial\phi(\mathbf{X},t)}{\partial t}=\frac{\partial\mathbf{x}(\mathbf{X},t)}{\partial t}$ 为定义在 $\mathbf{X}$ 上的速度，则这些方程为 {{#cite gonzalez2008first}}：
$$
\begin{align}
    R(\mathbf{X},t)J(\mathbf{X},t) = R(\mathbf{X},0) \quad &\text{Conservation of mass},\\
    R(\mathbf{X},0)\frac{\partial\mathbf{V}}{\partial t}(\mathbf{X}, t) = \nabla^{\mathbf{X}}\cdot\mathbf{P}(\mathbf{X}, t) + R(\mathbf{X},0)\mathbf{g}
    \quad &\text{Conservation of momentum},
\end{align}
$$
> 其中 $\mathbf{X}\in\Omega_0$ 且 $t\geq 0$。这里 $R$ 为质量密度，$J(\mathbf{X}, t) = \det{\mathbf{F}(\mathbf{X}, t)}$，$\mathbf{P}$ 为第一类 Piola-Kirchhoff 应力，$\mathbf{g}$ 为常重力加速度。注意 $J(\mathbf{X}, 0) = 1$，质量守恒也可写成
$$
\frac{\partial}{\partial t}\left(R(\mathbf{X},t)J(\mathbf{X},t)\right) = 0.
$$

这些方程最初是以强形式给出的。本讲中我们还将推导力平衡方程（动量守恒）的等价弱形式。弱形式用积分表达式重新表述守恒定律，这对于随后用有限元方法导出方程的时间与空间离散化至关重要。


<!-- <p style="color:red">TODO: Discuss why not directly discretize the strong form?</p> -->
<!-- Remark in 16.3 -->
