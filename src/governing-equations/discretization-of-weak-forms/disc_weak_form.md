# 弱形式的离散化

本讲中，我们将对动量守恒方程的弱形式（暂时忽略体力）在空间与时间两个层面进行离散化，从而得到离散形式——即[第一讲](../../simulation-with-optimization/discrete-space-and-time/discrete_space_time.md)中引入的方程组。

我们首先着眼于某个特定时刻 $t = t^n$。由动量守恒方程的弱形式（公式 {{eqref: eq:lec16:weakform_lagrangian}}），我们有：
$$
\begin{aligned}
& \int_{\Omega^0} R^0(\mathbf{X}) Q^n_i(\mathbf{X}) A^n_i(\mathbf{X}) d\mathbf{X} \\
&= \int_{\partial \Omega^0} Q^n_i(\mathbf{X}) T^n_i(\mathbf{X}) ds(\mathbf{X}) - \int_{\Omega^0} Q^n_{i,j}(\mathbf{X}) P^n_{ij}(\mathbf{X}) d\mathbf{X},
{{numeq}}{eq:lec17:weakform_lagrangian_tn}
\end{aligned}
$$
对任意 $\mathbf{Q}^n(\mathbf{X})$ 成立，其中上标 $n$ 表示在 $t = t^n$ 时刻测得的量。这里：
- $R$ 与 $\mathbf{T}$ 由仿真设置给定，
- $\mathbf{P}$ 可由自由度 $\mathbf{x}$ 通过本构关系计算得到，
- $\mathbf{A} = \frac{\partial^2 \mathbf{x}}{\partial t^2}$ 是 $\mathbf{x}$ 对时间的二阶导数，且
- $\mathbf{Q}$ 是任意向量场。
