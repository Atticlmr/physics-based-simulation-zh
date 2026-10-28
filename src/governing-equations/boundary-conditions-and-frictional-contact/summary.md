## 小结

我们在连续框架下讨论了诺伊曼边界条件与狄利克雷边界条件以及摩擦接触，从而补全了严谨的问题提法。将所有内容以强形式汇总，对任意 $t \geq 0$ 有：

$$
\begin{aligned}
    R(\mathbf{X}, 0) \frac{\partial \mathbf{V}}{\partial t}(\mathbf{X}, t) = \nabla^\mathbf{X} \cdot \mathbf{P}(\mathbf{X}, t) + R(\mathbf{X}, 0) \mathbf{A}^\text{ext}(\mathbf{X}, t), \quad &\forall \ \mathbf{X} \in \Omega^0; \\
    \mathbf{x} = \mathbf{x}_D(\mathbf{X}, t), \quad &\forall \ \mathbf{X} \in \Gamma_D; \\
    \mathbf{P}(\mathbf{X}, t) \mathbf{N}(\mathbf{X}) = \mathbf{T}_N(\mathbf{X}, t) + \mathbf{T}_C(\mathbf{X}, t) + \mathbf{T}_F(\mathbf{X}, t), \quad &\forall \ \mathbf{X} \in \Gamma_N; \\
    \phi(\mathbf{X}, t) : \Omega^0 \rightarrow \Omega^t \text{ is bijective,} \quad &\forall \ \mathbf{X} \in \Omega^0; \\
    \mathbf{T}_F(\mathbf{X}, t) = \argmin_{\boldsymbol{\beta} \in \mathbb{R}^d} \boldsymbol{\beta}^T \mathbf{V}_F(\mathbf{X}, t) \\
    \text{s.t.} \quad \|\boldsymbol{\beta}\| \leq \mu \|\mathbf{T}_C(\mathbf{X}, t)\| \ \ \text{and} \ \ \boldsymbol{\beta} \cdot \mathbf{N}(\mathbf{X}, t) = 0, \quad &\forall \ \mathbf{X} \in \Gamma_C.
\end{aligned}
{{numeq}}{eq:lec18:strong_form_with_BC_and_fric_contact}
$$

在推导出动量方程的弱形式之后，边界积分项可拆分如下：

$$
\begin{aligned}
    \int_{\partial \Omega^0} Q_i(\mathbf{X}, t) \mathbf{T}_i(\mathbf{X}, t) \, ds(\mathbf{X}) = & \int_{\Gamma_D} Q_i(\mathbf{X}, t) \mathbf{T}_{D|i}(\mathbf{X}, t) \, ds(\mathbf{X}) \\
    & + \int_{\Gamma_N} Q_i(\mathbf{X}, t) \mathbf{T}_{N|i}(\mathbf{X}, t) \, ds(\mathbf{X}) \\
    & + \int_{\Gamma_C} Q_i(\mathbf{X}, t) \mathbf{T}_{C|i}(\mathbf{X}, t) \, ds(\mathbf{X}) \\
    & + \int_{\Gamma_C} Q_i(\mathbf{X}, t) \mathbf{T}_{F|i}(\mathbf{X}, t) \, ds(\mathbf{X}).
\end{aligned}
{{numeq}}{eq:lec18:boundary_int_with_fric_contact}
$$

此处只有诺伊曼力 $\mathbf{T}_N(\mathbf{X}, t)$ 是已知的，而其余边界力都要在求解耦合系统之后才能确定。所幸，狄利克雷边界条件可以自然地作为线性等式约束在优化框架中施加。摩擦接触力 $\mathbf{T}_C(\mathbf{X}, t)$ 与 $\mathbf{T}_F(\mathbf{X}, t)$ 都可以光滑地近似为保守力，且误差可控。

在下一章中，我们将讨论如何用有限元方法（Finite Element Method，FEM）对弱形式进行离散化，从而把本章的推导与离散仿真方法联系起来。
