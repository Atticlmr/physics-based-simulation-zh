## 质量守恒

我们可以认为质量密度 $R(\mathbf{X}, t)$ 是在 $\Omega^0$ 上自然定义的，即
$$
R(\mathbf{X}, t) = \lim_{\epsilon \to +0} \frac{\text{mass}(B^t_\epsilon)}{\text{volume}(B^t_\epsilon)} = \lim_{\epsilon \to +0} \frac{\text{mass}(B^t_\epsilon)}{\int_{B^t_\epsilon} d\mathbf{x}}
{{numeq}}{eq:lec16:mass_def}
$$
其中 $B^t_\epsilon$ 是 $B^0_\epsilon$（围绕任意 $\mathbf{X} \in \Omega^0$ 的半径为 $\epsilon$ 的球）在世界空间中对应的区域。
这可以说是一个自然的定义，因为 $\text{mass}(B^t_\epsilon)$ 应当是一个可测量的量。质量守恒可表述为
$$
\text{mass}(B^t_\epsilon) = \text{mass}(B^0_\epsilon), \quad \forall \ B^0_\epsilon \subset \Omega^0 \ \text{and} \ t \geq 0.
{{numeq}}{eq:lec16:mass_conservation}
$$

<!-- <p style="color:red">TODO: modify derivation</p> -->

现在，通过变量替换可得 $\int_{B^t_\epsilon} d\mathbf{x} = \int_{B^0_\epsilon} J(\mathbf{X}, t) d\mathbf{X}$，于是方程 {{eqref: eq:lec16:mass_def}} 变为
$$
R(\mathbf{X}, t) = \lim_{\epsilon \to +0} \frac{\text{mass}(B^t_\epsilon)}{\int_{B^0_\epsilon} J(\mathbf{X}, t) d\mathbf{X}},
{{numeq}}{eq:lec16:R_X_t_formula}
$$
进而
$$
R(\mathbf{X}, 0) = \lim_{\epsilon \to +0} \frac{\text{mass}(B^0_\epsilon)}{\int_{B^0_\epsilon} d\mathbf{X}}
{{numeq}}{eq:lec16:R_X_0_formula}
$$
这是因为 $J(\mathbf{X}, 0) = 1$。
然后，结合方程 {{eqref:eq:lec16:mass_conservation}}、{{eqref:eq:lec16:R_X_t_formula}} 与 {{eqref:eq:lec16:R_X_0_formula}}，我们可以把质量守恒表述为
$$
\int_{B^0_\epsilon} R(\mathbf{X}, t) J(\mathbf{X}, t) d\mathbf{X} = \int_{B^0_\epsilon} R(\mathbf{X}, 0) d\mathbf{X}, \quad \forall \ B^0_\epsilon \subset \Omega^0 \ \text{and} \ t \geq 0.
$$
这只是在说，$B^t_\epsilon$ 中的质量（用质量密度的积分表示）不随时间改变。该集合与 $t$ 时刻的一部分物质相关联；随着这部分物质在流动中演化，它会占据更多或更少的空间，但集合中物质的量（质量）始终不变。由于 $B^0_\epsilon$ 是任意的，因此必然有
$$
R(\mathbf{X}, t) J(\mathbf{X}, t) = R(\mathbf{X}, 0), \quad \forall \ \mathbf{X} \in \Omega^0 \ \text{and} \ t \geq 0.
$$

> **{{rem}}{rem:lec16:lag_and_aug}[拉格朗日视角与欧拉视角]** 
在直接基于 $\Omega^0$ 离散并追踪物质的仿真方法中，质量守恒是自动满足的。例如，在我们的有限元方法（Finite Element Method，FEM）仿真器中，$\Omega^0$ 被划分为若干三角形，无论仿真过程中如何变形，每个三角形的质量都保持不变。这种做法称为**拉格朗日方法**。相比之下，**欧拉方法**基于 $\Omega^t$ 离散并演化物理量，因而往往需要专门处理质量守恒。

