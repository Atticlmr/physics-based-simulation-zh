## 引入边界条件

在我们推导出的弱形式（见公式 {{eqref: eq:lec16:weakform_lagrangian}}）中，有一个边界项 $\int_{\partial\Omega^0} \mathbf{Q}_i(\mathbf{X}, t) \mathbf{T}_i(\mathbf{X}, t) \, ds(\mathbf{X})$，它描述外部作用在固体边界上的力。

若不存在狄利克雷边界条件，则整个边界都按**诺伊曼边界条件**处理，此时边界力作为问题设置的一部分被给定。回忆我们讨论过的[狄利克雷边界条件](../../boundary-treatments/dirichlet-boundary-conditions/dirichlet_BC_solve.md)，其中边界的位移被直接指定。在实践中，外力作用于狄利克雷边界上，以确保其位移精确等于给定值，而这些力正是由这些位移直接计算得到的。

在固体仿真问题中，边界既可以是狄利克雷边界，也可以是诺伊曼边界，这可以用一个更一般的问题提法以强形式描述：
$$
\begin{aligned}
R(\mathbf{X}, 0) \frac{\partial \mathbf{V}}{\partial t}(\mathbf{X}, t) = \nabla^\mathbf{X} \cdot \mathbf{P}(\mathbf{X}, t) + R(\mathbf{X}, 0) \mathbf{A}^\text{ext}(\mathbf{X}, t), & \\ \quad \forall \mathbf{X} \in \Omega^0 \text{ and } t \geq 0; & \\
\mathbf{x} = \mathbf{x}_D(\mathbf{X}, t), & \\ \quad \forall \mathbf{X} \in \Gamma_D \text{ and } t \geq 0; & \\
\mathbf{P}(\mathbf{X}, t) \mathbf{N}(\mathbf{X}) = \mathbf{T}_N(\mathbf{X}, t), & \\ \quad \forall \mathbf{X} \in \Gamma_N \text{ and } t \geq 0. &
\end{aligned}
{{numeq}}{eq:lec18:strong_form_with_BC}
$$

此处 $\Gamma_N$ 与 $\Gamma_D$ 分别为诺伊曼边界与狄利克雷边界，$\Gamma_N \cup \Gamma_D = \partial \Omega_0$，$\Gamma_N \cap \Gamma_D = \emptyset$，且 $\mathbf{x}_D$ 与 $\mathbf{T}_N$ 为已知量。在推导出动量守恒的弱形式（见公式 {{eqref: eq:lec18:strong_form_with_BC}} 第一行）之后，边界项 $\int_{\partial\Omega^0} \mathbf{Q}_i(\mathbf{X}, t) \mathbf{T}_i(\mathbf{X}, t) \, ds(\mathbf{X})$ 可以按狄利克雷边界与诺伊曼边界分别考虑：
$$
\begin{aligned}
\int_{\partial\Omega^0} \mathbf{Q}_i(\mathbf{X}, t) \mathbf{T}_i(\mathbf{X}, t) \, ds(\mathbf{X}) \\
= \int_{\Gamma_D} \mathbf{Q}_i(\mathbf{X}, t) \mathbf{T}_{D|i}(\mathbf{X}, t) \, ds(\mathbf{X}) + \int_{\Gamma_N} \mathbf{Q}_i(\mathbf{X}, t) \mathbf{T}_{N|i}(\mathbf{X}, t) \, ds(\mathbf{X}).
\end{aligned}
$$


对于诺伊曼边界，由于面力 $\mathbf{T}_N(\mathbf{X}, t)$ 已知，上述积分在离散化后可直接计算。但对于狄利克雷边界，$\mathbf{T}_D(\mathbf{X}, t)$ 在问题求解之前是未知的。因此，一种直接的思路是把狄利克雷边界上的面力作为未知量引入，并求解由离散弱形式方程与狄利克雷边界条件共同构成的系统。



> **{{rem}}{rem:lec18:optimization_form}[优化形式]**
> 在[优化形式](../../simulation-with-optimization/optimization-framework/opt_framework.md)中，势能并不包含任何狄利克雷边界，这相当于忽略了弱形式中的边界积分。这样做是合理的，因为狄利克雷边界条件将由线性等式约束来施加，而相应的离散弱形式方程会被覆盖。
