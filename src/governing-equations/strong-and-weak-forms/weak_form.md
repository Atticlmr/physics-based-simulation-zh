## 弱形式

首先，由于外力项 $R(\mathbf{X},0) \mathbf{A}^{\text{ext}}(\mathbf{X}, t)$ 与左端动量的时间导数颇为相似，为简便起见，我们在推导中先将其忽略。
然后，对任意测试函数 $\mathbf{Q}(\cdot,t): \Omega^0 \rightarrow \mathbb{R}^d$，计算其与方程 {{eqref: eq:lec16:momentum_conserve_derived}} 两端的点积并在 $\Omega^0$ 上积分，即可得到弱形式：
$$
\begin{aligned}
& \int_{\Omega^0} R(\mathbf{X},0) \mathbf{Q}(\mathbf{X},t) \cdot \mathbf{A}(\mathbf{X},t) d\mathbf{X} \\
= & \int_{\Omega^0} \mathbf{Q}(\mathbf{X},t) \cdot (\nabla^\mathbf{X} \cdot \mathbf{P}(\mathbf{X},t)) d\mathbf{X}, 
\forall \ \mathbf{Q}(\cdot,t) : \Omega^0 \rightarrow \mathbb{R}^d \ \text{and} \ t\geq 0.
\end{aligned}
{{numeq}}{eq:lec16:weak_form}
$$
这里我们记 $\mathbf{A}(\mathbf{X}, t) = \frac{\partial \mathbf{V}}{\partial t}(\mathbf{X}, t)$。在不深究有限元分析细节的前提下，我们断言弱形式与强形式充分等价：因为方程 {{eqref: eq:lec16:weak_form}} 要求对任意的 $\mathbf{Q}(\cdot, t)$ 都成立，而求解弱形式所给出的解是原问题的一个"足够好"的解。

采用指标记法，其中 $A_i$ 表示向量值函数 $\mathbf{A} : \Omega^0 \rightarrow \mathbb{R}^d$ 的第 $i$ 个分量，$A_{i,j}$ 表示 $\frac{\partial A_i}{\partial X_j}$，我们可以把方程 {{eqref: eq:lec16:weak_form}} 改写为
$$
\int_{\Omega^0} R(\mathbf{X},0) \sum_i Q_i(\mathbf{X},t) A_i(\mathbf{X},t) d\mathbf{X} = \int_{\Omega^0} \sum_i Q_i(\mathbf{X},t) \sum_j P_{ij,j}(\mathbf{X},t) d\mathbf{X}.
{{numeq}}{eq:lec16:weak_form_index}
$$
如果我们进一步省略求和符号，并约定重复下标表示求和（这就是爱因斯坦记法），则得到
$$
\int_{\Omega^0} R(\mathbf{X},0) Q_i(\mathbf{X},t) A_i(\mathbf{X},t) d\mathbf{X} = \int_{\Omega^0} Q_i(\mathbf{X},t) P_{ij,j}(\mathbf{X},t) d\mathbf{X}.
{{numeq}}{eq:lec16:weak_form_index_nosum}
$$
现在对右端应用分部积分，我们可以把方程 {{eqref: eq:lec16:weak_form_index_nosum}} 改写为
$$
\begin{aligned}
&\int_{\Omega^0} R(\mathbf{X},0) Q_i(\mathbf{X},t) A_i(\mathbf{X},t) d\mathbf{X} \\
&= \int_{\Omega^0} (\nabla \cdot (Q_i(\mathbf{X},t) \mathbf{P}_i(\mathbf{X},t)) - \nabla Q_i(\mathbf{X},t) \cdot \mathbf{P}_i(\mathbf{X},t)) d\mathbf{X} \\
&= \int_{\Omega^0} ((Q_i(\mathbf{X},t) P_{ij}(\mathbf{X},t))_{,j} - Q_{i,j}(\mathbf{X},t) P_{ij}(\mathbf{X},t)) d\mathbf{X}.
{{numeq}}{eq:lec16:weak_form_index_IBP}
\end{aligned}
$$

> **{{def}}{def:lec16:integration_by_parts}[分部积分]**
> 对标量值函数 $u(\mathbf{x})$ 与向量值函数（向量场）$\mathbf{V}(\mathbf{x})$，散度的乘积法则为：
$$
\nabla \cdot (u(\mathbf{x}) \mathbf{V}(\mathbf{x})) = u(\mathbf{x}) \nabla \cdot \mathbf{V}(\mathbf{x}) + \nabla u(\mathbf{x}) \cdot \mathbf{V}(\mathbf{x}).
$$
> 在区域 $\Omega$ 上对两端积分，得到：
$$
\int_\Omega \nabla \cdot (u(\mathbf{x}) \mathbf{V}(\mathbf{x})) d\mathbf{x} = \int_\Omega u(\mathbf{x}) \nabla \cdot \mathbf{V}(\mathbf{x}) d\mathbf{x} + \int_\Omega \nabla u(\mathbf{x}) \cdot \mathbf{V}(\mathbf{x}) d\mathbf{x}.
$$

然后，若对方程 {{eqref: eq:lec16:weak_form_index_IBP}} 右端的第一部分进一步应用散度定理，可得
$$
\begin{aligned}
& \int_{\Omega^0} R(\mathbf{X},0) Q_i(\mathbf{X},t) A_i(\mathbf{X},t) d\mathbf{X} \\
&= \int_{\partial\Omega^0} Q_i(\mathbf{X},t) P_{ij}(\mathbf{X},t) N_j(\mathbf{X}) ds(\mathbf{X}) - \int_{\Omega^0} Q_{i,j}(\mathbf{X},t) P_{ij}(\mathbf{X},t) d\mathbf{X}.
{{numeq}}{eq:lec16:weak_form_index_final}
\end{aligned}
$$
量 $P_{ij} N_j$ 将作为边界条件给定。若令 $\mathbf{T}(\mathbf{X},t)$ 为单位参考面积上的边界力（面力），且 $T_i = P_{ij} N_j$，则可以说动量守恒蕴含：$\forall \mathbf{Q}(\cdot,t): \Omega^0 \rightarrow \mathbb{R}^d$
$$
\begin{aligned}
&\int_{\Omega^0} R(\mathbf{X},0) Q_i(\mathbf{X},t) A_i(\mathbf{X},t) d\mathbf{X} \\
&=\int_{\partial\Omega^0} Q_i(\mathbf{X},t) T_i(\mathbf{X},t) ds(\mathbf{X}) - \int_{\Omega^0} Q_{i,j}(\mathbf{X},t) P_{ij}(\mathbf{X},t) d\mathbf{X}.
{{numeq}}{eq:lec16:weakform_lagrangian}
\end{aligned}
$$
这就是写在 $\Omega^0$ 上的动量守恒弱形式。

<!-- <p style="color:red">TODO: discuss the pros and cons comparing weak form to strong form</p> -->

> **{{rem}}{rem:lec16:why_weak_form}[为何采用弱形式]**
在固体的有限元方法（FEM）中，动量守恒以弱形式表述，而不是直接离散强形式，这是因为弱形式具有特定的优势。强形式要求位移场及其导数在整个区域上连续可微，而在涉及复杂几何或材料不连续的实际情况中，这一点难以满足。另一方面，弱形式只要求位移场本身连续，从而放宽了对连续导数的要求。这使得弱形式更能适应不规则的网格几何，也更适合引入边界条件与处理界面问题。弱形式基于积分的处理方式降低了对局部不规则性的敏感性，使其在固体力学的数值计算中更加稳定、鲁棒。因此，尽管强形式直接表达了物理定律，但直接离散强形式对于 FEM 分析中典型的计算需求与复杂性而言并不实用。
