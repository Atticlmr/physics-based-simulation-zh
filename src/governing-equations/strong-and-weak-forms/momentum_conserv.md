## 动量守恒

在连续体情形下，力被分为体力（又称外力，例如重力）与面力（又称内力，通常由应力给出，例如弹性产生的力）。我们通过面力场来定义基于应力的力，并假定该场存在。面力即单位面积上的力，由场 $\mathbf{T}(\cdot, \mathbf{N}, t): \Omega^0 \rightarrow \mathbb{R}^d$ 表示，其定义为：
$$
\text{force}_S(B^0_\epsilon) = \int_{\partial B^0_\epsilon} \mathbf{T}(\mathbf{X}, \mathbf{N}(\mathbf{X})) \, ds(\mathbf{X}),
$$
其中 $\mathbf{N}$ 表示物质空间中的外法向。这里，$\text{force}_S(B^0_\epsilon)$ 表示 $\partial B^0_\epsilon$ 之外的材料通过二者界面施加在 $B^0_\epsilon$ 之内材料上的合力。函数 $\mathbf{T}(\mathbf{X}, \mathbf{N}, t)$ 刻画的是位于 $\mathbf{N}^+$ 一侧的材料在点 $\mathbf{X}$ 处作用于位于 $\mathbf{N}^-$ 一侧材料的单位面积（$d=3$）或单位长度（$d=2$）上的力。

可以证明，这意味着存在一个应力场（第一类 Piola-Kirchhoff 应力）$\mathbf{P}(\cdot, t): \Omega^0 \rightarrow \mathbb{R}^{d \times d}$，满足：
$$
\mathbf{T}(\mathbf{X}, \mathbf{N}, t) = \mathbf{P}(\mathbf{X}, t) \mathbf{N}.
$$

于是，对 $B^0_\epsilon$ 应用牛顿第二定律，我们可以把动量守恒表述为：
$$
\begin{aligned}
& \int_{B^0_\epsilon} R(\mathbf{X}, 0) \frac{\partial \mathbf{V}}{\partial t}(\mathbf{X}, t) \, d\mathbf{X} \\
= & \int_{\partial B^0_\epsilon} \mathbf{P}(\mathbf{X}, t) \mathbf{N}(\mathbf{X}) \, ds(\mathbf{X}) + \int_{B^0_\epsilon} R(\mathbf{X}, 0) \mathbf{A}^\text{ext}(\mathbf{X}, t) \, d\mathbf{X},
\end{aligned}
{{numeq}}{eq:lec16:conserve_momentum_pBeps}
$$
对所有 $B^0_\epsilon \subset \Omega^0$ 与 $t \geq 0$ 成立。

应用散度定理，我们可以把方程 {{eqref: eq:lec16:conserve_momentum_pBeps}} 中的边界积分化为体积积分，得到：
$$
\begin{aligned}
& \int_{B^0_\epsilon} R(\mathbf{X}, 0) \frac{\partial \mathbf{V}}{\partial t}(\mathbf{X}, t) \, d\mathbf{X} \\
= & \int_{B^0_\epsilon} \nabla^\mathbf{X} \cdot \mathbf{P}(\mathbf{X}, t) \, d\mathbf{X} + \int_{B^0_\epsilon} R(\mathbf{X}, 0) \mathbf{A}^\text{ext}(\mathbf{X}, t) \, d\mathbf{X},
\end{aligned}
{{numeq}}{eq:lec16:conserve_momentum_Beps}
$$
对所有 $B^0_\epsilon \subset \Omega^0$ 与 $t \geq 0$ 成立。

> **{{def}}{def:lec16:div_theorem}[向量形式的散度定理]**
> 对定义在闭区域 $\Omega$ 上的向量值函数 $\mathbf{f}(\mathbf{x}) : \Omega \rightarrow \mathbb{R}^d$，设 $\mathbf{n}(\mathbf{x})$ 为该区域边界上的外法向，则下列等式成立：
$$
\int_{\partial \Omega} \mathbf{f} \cdot \mathbf{n} \, ds(\mathbf{x}) = \int_{\Omega} \nabla \cdot \mathbf{f} \, d\mathbf{x}.
$$
该定理使我们能够方便地在边界积分与体积积分之间转换。

这里散度算子 $\nabla \cdot$ 独立作用于 $\mathbf{P}$ 的每一行向量，并得到一个列向量：$(\nabla^\mathbf{X} \cdot \mathbf{P})_i = \sum_j P_{ij,j}$。由于方程 {{eqref: eq:lec16:conserve_momentum_Beps}} 对任意的 $B^0_\epsilon$ 也成立，我们去掉积分即可得到力平衡方程的强形式：
$$
\begin{aligned}
R(\mathbf{X}, 0) \frac{\partial \mathbf{V}}{\partial t}(\mathbf{X}, t) = \nabla^\mathbf{X} \cdot \mathbf{P}(\mathbf{X}, t) + R(\mathbf{X}, 0) \mathbf{A}^\text{ext}(\mathbf{X}, t), \\ \forall \ \mathbf{X} \in \Omega^0 \ \text{and} \ t \geq 0.
\end{aligned}
{{numeq}}{eq:lec16:momentum_conserve_derived}
$$

> **{{rem}}{rem:lec16:conserv_momentum}[固体仿真中的动量守恒]**
> 动量守恒是我们仿真固体时使用的主要控制方程。如前所述，加速度 $\frac{\partial \mathbf{V}}{\partial t}(\mathbf{X}, t)$ 与内力 $\nabla^\mathbf{X} \cdot \mathbf{P}(\mathbf{X}, t)$ 都可以用世界空间坐标 $\mathbf{x}$ 来描述。在其他相关量都已确定之后，我们逐步求解 $\mathbf{x}$，从而一步一步地得到动态运动。

