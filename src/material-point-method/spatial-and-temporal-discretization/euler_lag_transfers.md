## 粒子-网格传输

在 MPM 中，物质状态存储在**拉格朗日粒子**上，而[控制方程](../../governing-equations/strong-and-weak-forms/strong_and_weak_forms.md)（例如动量守恒）则在临时的**欧拉网格**上求解。因此，我们必须在每个时间步内在粒子与网格节点之间传输信息。

本节讨论**质量**、**动量**与<strong>内力（应力）</strong>如何从粒子传输到网格（P2G），以及更新后的速度如何从网格传回粒子（G2P）。



### 粒子到网格（P2G）传输

**质量传输**：设 $m_p$ 为粒子 $p$ 的质量，$w_{\mathbf{i}p} = N_\mathbf{i}(\mathbf{x}_p)$ 为网格节点 $\mathbf{i}$ 与粒子 $p$ 之间的[插值权重](interpolating_functions.md)。我们通过加权求和把质量传输到网格节点 $\mathbf{i}$：

$$
m_\mathbf{i} = \sum_p w_{\mathbf{i}p} \, m_p.
$$

**动量传输**：类似地，用粒子速度 $\mathbf{v}_p$ 计算节点动量：

$$
(m \mathbf{v})_\mathbf{i} = \sum_p w_{\mathbf{i}p} \, m_p \mathbf{v}_p.
$$

于是每个网格节点的**节点速度**为：

$$
\mathbf{v}_\mathbf{i} = \frac{(m \mathbf{v})_\mathbf{i}}{m_\mathbf{i}}.
$$

**内力（应力）传输**：在 MPM 中，力在网格节点上计算，[牛顿第二定律](../../simulation-with-optimization/discrete-space-and-time/newton_2nd_law.md)也在节点上应用。对于超弹性材料，内部弹性力既可由动量方程的[弱形式](../../governing-equations/strong-and-weak-forms/weak_form.md)导出，也可由[应变能](../../hyperelasticity/strain-energy/strain_energy.md)的梯度导出。当存在定义良好的能量密度函数时，通常更倾向于后者。

假设每个粒子 $p$ 处具有基于变形梯度的超弹性能量密度 $\Psi_p(\mathbf{F}_p)$，则系统的总势能为：

$$
\mathcal{E} = \sum_p V_p^0 \, \Psi_p(\mathbf{F}_p),
$$

其中 $V_p^0$ 为粒子 $p$ 的初始（静止）体积。作用在网格节点 $i$ 上的弹性力则计算为总能量对节点位置 $\mathbf{x}_\mathbf{i}$ 的负梯度：

$$
\mathbf{f}_\mathbf{i}(\mathbf{x}) = - \frac{\partial \mathcal{E}}{\partial \mathbf{x}_\mathbf{i}} = - \sum_p V_p^0 \, \frac{\partial \Psi_p}{\partial \mathbf{F}}(\mathbf{F}_p(\mathbf{x})) \, \mathbf{F}_p^T \, \nabla w_{\mathbf{i}p}.
$$

在显式时间积分（例如辛欧拉法）的情形下，力在当前时间步 $n$ 处取值：

$$
\mathbf{f}_\mathbf{i}^n = - \sum_p V_p^0 \, \frac{\partial \Psi_p}{\partial \mathbf{F}}\left(\mathbf{F}_p^n\right) \, (\mathbf{F}_p^n)^T \, \nabla w_{\mathbf{i}p}^n.
$$

该形式表达了邻近粒子的弹性应力贡献对网格节点 $i$ 的作用力。它完全依赖于当前时间步已知的粒子属性与插值权重。

### 网格更新

在从粒子收集信息之后，便在网格上执行时间积分，其中通常采用一阶格式：

$$
\hat{\mathbf{v}}_\mathbf{i}^{n+1} = \mathbf{v}_\mathbf{i}^n + \frac{\Delta t}{m_\mathbf{i}} (\mathbf{f}_\mathbf{i} + \mathbf{f}_\mathbf{i}^{\text{ext}}).
$$
这里用 $\hat{\mathbf{v}}_\mathbf{i}^{n+1}$ 表示网格更新后的速度，以区别于下一时间步 P2G 传输之后的网格速度，后者记作 $\mathbf{v}_\mathbf{i}^{n+1}$。

[边界处理](../boundary-treatments/mpm_bc.md)也在这一阶段施加，将在后续课程中讨论。

### 网格到粒子（G2P）传输

一旦网格速度 $\hat{\mathbf{v}}_\mathbf{i}^{n+1}$ 更新完毕，就需要把信息传回粒子。G2P 传输中要更新的主要量是粒子速度 $\mathbf{v}_p^{n+1}$，它将在[平流](./particle_state_update.md)步骤中使用。

最简单的方法是直接从网格插值速度：

$$
\mathbf{v}_p^{n+1} = \sum_\mathbf{i} w_{\mathbf{i}p} \, \hat{\mathbf{v}}_\mathbf{i}^{n+1}.
$$

这一直接的方案属于**质点网格法（Particle-In-Cell，PIC）** {{#cite harlow1962particle}}，但它耗散性很强。实践中，我们常采用改进的传输方案，以更好地保持速度模态并守恒角动量。

### 不同的传输方案

传输方案定义了 **P2G** 与 **G2P** 如何协同工作，以不同方式在数值稳定性、能量守恒与物理真实性之间取得平衡。

> {{exp}}{exp:lec26:pic}[PIC，质点网格法] $$ $$
**P2G**：粒子速度 $\mathbf{v}_p$ 通过下式传输到网格：
$$
(m\mathbf{v})_\mathbf{i} = \sum_p w_{\mathbf{i}p} \, m_p \mathbf{v}_p.
$$
**G2P**：粒子速度直接从网格插值：
$$
\mathbf{v}_p^{n+1} = \sum_\mathbf{i} w_{\mathbf{i}p} \, \hat{\mathbf{v}}_\mathbf{i}^{n+1}.
$$
PIC 非常稳定且守恒线动量，但数值耗散严重、会丢失细尺度运动，并且不守恒角动量。

> {{exp}}{exp:lec26:flip}[FLIP，流体隐式粒子法] $$ $$
**P2G**：与 PIC 相同。 $$ $$
**G2P**：在 FLIP 中，粒子速度通过混合新插值得到的速度与时间步之间的速度变化来更新：
$$
\mathbf{v}_p^{n+1} =
\sum_\mathbf{i} w_{\mathbf{i}p} \, \hat{\mathbf{v}}_\mathbf{i}^{n+1}
+ \alpha \left( \mathbf{v}_p^n - \sum_\mathbf{i} w_{\mathbf{i}p} \, \mathbf{v}_\mathbf{i}^n \right),
$$
其中 $\alpha \in [0, 1]$ 为 **FLIP-PIC 混合因子**（$\alpha = 1$ 时恢复为完全的 FLIP，常用取值为 $\alpha = 0.99$）。由于 FLIP 只对速度变化量进行插值，数值耗散被有效缓解。 $$ $$
然而需要注意的是，为保证粒子与网格之间的嵌入关系，粒子位置仍需用 PIC 的速度更新：
$$
\mathbf{x}_p^{n+1} = \mathbf{x}_p^n + \Delta t \sum_\mathbf{i} w_{\mathbf{i}p} \, \hat{\mathbf{v}}_\mathbf{i}^{n+1}.
$$
FLIP 能在长时间尺度上保持系统能量与细尺度运动，因此很适合仿真具有细致局部特征的流体。然而，由于缺乏内在的平滑机制，它在固体仿真中可能引入噪声、穿透甚至不稳定。

> {{exp}}{exp:lec26:apic}[APIC，仿射质点网格法] $$ $$
@@jiang2015affine 引入了**仿射速度场**，以更准确地刻画粒子的局部运动并保持角动量。每个粒子除速度 $\mathbf{v}_p$ 之外还存储一个仿射速度矩阵 $\mathbf{C}_p$。粒子速度场写作：
$$
\mathbf{v}_p(\mathbf{x}) = \mathbf{v}_p + \mathbf{C}_p (\mathbf{x} - \mathbf{x}_p).
$$
**P2G**：动量传输中包含了仿射运动：
$$
(m\mathbf{v})_\mathbf{i} = \sum_p w_{\mathbf{i}p} \, m_p \left( \mathbf{v}_p + \mathbf{C}_p (\mathbf{x}_\mathbf{i} - \mathbf{x}_p) \right).
$$
这使得粒子能够把线动量与角动量一并传输到网格。 $$ $$
**G2P**：在网格更新之后，粒子速度与仿射矩阵由网格值重建：
$$
\mathbf{v}_p^{n+1} = \sum_\mathbf{i} w_{\mathbf{i}p} \, \hat{\mathbf{v}}_\mathbf{i}^{n+1},
$$
$$
\mathbf{B}_p^{n+1} = \mathbf{D}_p^{-1} \sum_\mathbf{i} w_{\mathbf{i}p} \, \hat{\mathbf{v}}_\mathbf{i}^{n+1} (\mathbf{x}_\mathbf{i} - \mathbf{x}_p)^T.
$$
这里 $\mathbf{D}_p$ 是定义为下式的二阶矩矩阵：
$$
\mathbf{D}_p = \sum_\mathbf{i} w_{\mathbf{i}p} (\mathbf{x}_\mathbf{i} - \mathbf{x}_p)(\mathbf{x}_\mathbf{i} - \mathbf{x}_p)^T.
$$
对于常见的 B 样条插值核（二次与三次），$\mathbf{D}_p$ 取常数值： $$ $$
 **二次 B 样条**：$\mathbf{D}_p = \frac{1}{4} \Delta x^2 \mathbf{I}$。 $$ $$
 **三次 B 样条**：$\mathbf{D}_p = \frac{1}{3} \Delta x^2 \mathbf{I}$。 $$ $$
因此，$\mathbf{D}_p^{-1}$ 只是一个常数缩放因子，无需对每个粒子重新计算。 $$ $$
与 PIC 相比，APIC 通过仿射速度场捕捉局部旋转与剪切效应，显著降低了耗散，同时保持角动量。尽管它需要为每个粒子额外存储一个局部矩阵 $\mathbf{C}_p$，并计算粒子到网格的矩贡献，但实际开销并不大。
