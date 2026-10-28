## 障碍势能

正如[非穿透的距离障碍函数](../../boundary-treatments/distance-barrier-for-nonpenetration/dist_barrier.md)中所讨论的，增量势能接触（Incremental Potential Contact，IPC）处理固体-障碍物接触的原理是：借助障碍函数，确保仿真全过程中任意节点自由度（Degree of Freedom，DOF）与障碍物之间的有符号距离始终为正。为处理自接触（对于余维对象尤其可能出现），这一思想被进一步推广：确保仿真全过程中任意边界点与边界之间的无符号距离始终不为零。

我们考虑边界上两个相互碰撞的区域 $\Gamma_1 \subset \partial \Omega^0$ 与 $\Gamma_2 \subset \partial \Omega^0$。对任意点 $\mathbf{X}_1 \in \Gamma_1$，必须确保 $\mathbf{X}_1$ 与 $\Gamma_2$ 上任意点之间的最近距离始终不为零。这可以通过障碍函数来强制该最小距离实现，而该函数的负梯度即给出接触力。此式可写作

$$
\mathbf{T}_C(\mathbf{X}_1, t) = -\frac{\partial b(\min_{\mathbf{X}_2 \in \Gamma_2} \|\mathbf{x}(\mathbf{X}_1, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d})}{\partial \mathbf{x}(\mathbf{X}_1, t)},
{{numeq}}{eq:lec18:solid_solid_contact_force}
$$

其中 $b$ 为障碍函数：

$$
b(d, \hat{d}) = 
\begin{cases}
    \frac{\kappa}{2} \hat{d} \left(\frac{d}{\hat{d}} - 1\right) \ln \frac{d}{\hat{d}} & d < \hat{d} \\
    0 & d \geq \hat{d},
\end{cases}
{{numeq}}{eq:lec18:barrier_func}
$$

它充当接触势能密度。此处，障碍函数在距离趋于零时趋于无穷，从而提供任意大的排斥力以阻止相互穿透；当距离超过阈值 $\hat{d}$、并未发生接触时，则不施加任何接触力。通过使用障碍函数，原本非光滑的接触约束被一个本构模型近似，该模型中的力是保守的，因而可借助基于优化的时间积分器得到一致求解。

> **{{rem}}{rem:lec18:barrier_density}[障碍密度]**
> 与公式 {{eqref: eq:lec7:barrier_func}} 相比，此处的障碍能量密度函数额外乘以 $\hat{d}$，以使曲面积分后的量纲保持一致。回忆 {{ref: rm:lec7:contact_layer}} 中的说明：障碍势能可以看作紧贴固体边界外侧的一层额外的（厚度为 $\hat{d}$ 的）虚拟薄层材料，而 $\kappa$ 的作用类似于杨氏模量。

> **{{rem}}{rem:lec18:min_operator}[最小值算子]**
> 当有多个点到 $\mathbf{X}_1$ 的距离同时取最小值时，应把 $\mathbf{X}_1$ 到这些点的距离障碍函数全部相加。`min` 算子是非光滑的，这仍然会使基于优化的时间积分变得复杂。在下一章中，我们将演示如何按[非穿透的距离障碍函数](../../boundary-treatments/distance-barrier-for-nonpenetration/dist_barrier.md)中所述对其进行近似。

两个相互碰撞区域的情形导出一个边界积分：

$$
\int_{\Gamma_1}\mathbf{Q}_i(\mathbf{X}_1,t)\mathbf{T}_{C_1|i}(\mathbf{X}_1,t)\,ds(\mathbf{X}) + \int_{\Gamma_2}\mathbf{Q}_i(\mathbf{X}_2,t)\mathbf{T}_{C_2|i}(\mathbf{X}_2,t)\,ds(\mathbf{X}),
$$

其中 $\mathbf{T}_{C_1}$ 由公式 {{eqref: eq:lec18:solid_solid_contact_force}} 定义，且：

$$
\mathbf{T}_{C_2}(\mathbf{X}_2, t) = -\frac{\partial b(\min_{\mathbf{X}_1 \in \Gamma_1} \|\mathbf{x}(\mathbf{X}_2, t) - \mathbf{x}(\mathbf{X}_1, t)\|, \hat{d})}{\partial \mathbf{x}(\mathbf{X}_2, t)},
{{numeq}}{eq:lec18:solid_solid_contact_force2}
$$

然而，在此例中我们忽略了 $\Gamma_1$ 与 $\Gamma_2$ 各自的自接触。因此，要推广到整个区域上的任意自接触，我们仍可保留公式 {{eqref: eq:lec18:boundary_int_with_contact}} 中用于接触的单个边界积分项 $\int_{\Gamma_C}\mathbf{Q}_i(\mathbf{X},t)\mathbf{T}_{C|i}(\mathbf{X},t)\,ds(\mathbf{X})$，并将面力更一般地定义为：

$$
\mathbf{T}_C(\mathbf{X}, t) = -\frac{\partial b(\min_{\mathbf{X}_2 \in \Gamma_C - \mathcal{N}(\mathbf{X})} \|\mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d})}{\partial \mathbf{x}(\mathbf{X}, t)},
{{numeq}}{eq:lec18:solid_self_contact_force}
$$

其中 $\mathcal{N}(\mathbf{X}) = \{ \mathbf{X}_N \in \mathbb{R}^d \mid \|\mathbf{X}_N - \mathbf{X}\| < r \}$ 是围绕 $\mathbf{X}$ 的一个无穷小圆，其半径 $r$ 取足够小，以避免一个点与其测地邻域内的点之间产生不必要的接触力。

> **{{rem}}{rem:lec18:barrier_force_limit}[障碍力的极限]**
> 在公式 {{eqref: eq:lec18:solid_self_contact_force}} 中，对位于 $\mathcal{N}(\mathbf{X})$ 内部的点忽略了自接触。这是为光滑地近似接触力所付出的代价，因为从宏观视角看接触力是不连续的。类似地，$\hat{d}$ 引入了另一个误差来源。不过，当 $\hat{d} \rightarrow 0$ 且 $r \rightarrow 0$ 时，我们的模型收敛于该不连续的定义。注意我们还需要 $\hat{d}/r \rightarrow 0$，否则在 $r$ 与 $\hat{d}$ 之间仍可能存在某个距离 $d$，使障碍函数在极限下发生发散。

最后，我们可以将整个边界 $\Gamma_C$ 上的接触势能定义为：

$$
\int_{\Gamma_C} \frac{1}{2} b\left(\min_{\mathbf{X}_2 \in \Gamma_C - \mathcal{N}(\mathbf{X})} \|\mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) \, ds(\mathbf{X}).
{{numeq}}{eq:lec18:barrier_potential}
$$

此处使用系数 $\frac{1}{2}$，是因为每一对相互接触点的障碍能量密度 $b$ 由于对称性会在积分中被计算两次。在计算障碍力时，两处出现都需要求导。因此，引入系数 $\frac{1}{2}$ 可使结果与公式 {{eqref: eq:lec18:solid_self_contact_force}} 中的力定义相匹配。我们将在下一章离散弱形式的讨论中详细说明这一点。

弱形式中并不需要接触势能，但它对基于优化的时间积分很有用。
