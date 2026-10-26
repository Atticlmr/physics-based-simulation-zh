## 约束求解中的刚度与阻尼


### 刚度
材料刚度由参数 $k \in [0, 1]$ 控制，它决定约束被执行的强度。引入刚度最直接的做法是把计算出的修正量按 $k$ 缩放：$\Delta\bm{p}_i \leftarrow k \cdot \Delta\bm{p}_i$。然而，这会使有效刚度依赖于求解器的迭代次数 $n_s$。若一个约束被投影 $n_s$ 次，投影后的残余误差将与 $(1-k)^{n_s}$ 成正比。一种更稳健、能把刚度与迭代次数解耦的表述为：
$$
{{numeq}}{eq:pbd:stiffness}
k' = 1 - (1 - k)^{1/n_s}
$$
把修正量按 $k'$ 而非 $k$ 缩放后，$n_s$ 次迭代后的残余误差变为 $(1-k')^{n_s} = 1-k$，与 $n_s$ 无关。这样，美术人员调校材料刚度 $k$ 时无需关心求解器使用了多少次迭代。

### 阻尼
尽管 PBD 方法总体上是稳定的，但仿真仍可能出现过度振荡或动能增益，尤其是在约束较硬时。引入适当的阻尼格式通常可以改善动态仿真的质量：它通过减小物体各点位置在时间上的抖动来提高稳定性，还允许采用更大的时间步，从而提升动态仿真的性能。

对所有速度做朴素的阻尼会不必要地影响物体的整体运动，使其整体平移与转动变慢。更精细的做法是只对粒子之间的相对运动施加阻尼，同时保持系统的总线性动量与总角动量不变。




> **{{met}}{met:pbd:damping}[动量守恒阻尼]**
>
> 1.  **计算质心与质心速度：**
>     $\bm{p}_{cm} = \frac{\sum_i m_i \bm{p}_i}{\sum_i m_i}$,
>     $\bm{v}_{cm} = \frac{\sum_i m_i \bm{v}_i}{\sum_i m_i}$
>
> 2.  **计算角动量与惯性张量：** 令 $\bm{r}_i = \bm{x}_i - \bm{p}_{cm}$。
> 
>     $\bm{L} = \sum_i \bm{r}_i \times (m_i \bm{v}_i)$
>
>     $\bm{I} = \sum_i m_i ((\bm{r}_i \cdot \bm{r}_i)\mathbf{Id} - \bm{r}_i \otimes \bm{r}_i)$
>
> 3.  **计算角速度：**
>     $\bm{\omega} = \bm{I}^{-1}\bm{L}$
>
> 4.  **施加阻尼：** 对每个粒子 $i$：
>
>     a.  计算其速度相对于刚体运动的偏差：
>         $\Delta\bm{v}_i = (\bm{v}_{cm} + \bm{\omega} \times \bm{r}_i) - \bm{v}_i$
>
>     b.  对该偏差施加阻尼：
>         $\bm{v}_i \leftarrow \bm{v}_i + k_{damping} \Delta\bm{v}_i$
>

该方法有效地分离出运动中的非刚体成分，并只对这些成分施加阻尼。在极端情形 $k_{damping} = 1$ 下，所有相对运动都被消除，物体表现为理想刚体。


### 扩展基于位置的动力学（XPBD）

尽管方程 {{eqref:eq:pbd:stiffness}} 中的刚度表述把有效刚度与求解器迭代次数解耦，标准 PBD 仍存在一个根本局限：由此得到的材料刚度依然依赖于仿真时间步 $\Delta t$。被称为<strong>扩展基于位置的动力学（Extended Position Based Dynamics，XPBD）</strong>的扩展解决了这一问题，实现了真正与参数无关的刚度。

XPBD 由柔顺约束（compliant constraint）形式推导而来，并引入了柔度（compliance）这一概念，即刚度的倒数。

> **{{def}}{def:pbd:compliance}[柔度]**
> 柔度 $\alpha \ge 0$ 是材料刚度 $k$ 的倒数，即 $\alpha = 1/k$。它描述材料在载荷作用下发生变形的倾向。在 XPBD 中，柔度 $\alpha = 0$ 对应无限刚硬（即硬）的约束。

XPBD 的核心思想是：不把拉格朗日乘子 $\lambda$ 视为每次迭代重新计算的临时量，而把它视为代表累积冲量的物理量，并以增量方式更新。在每次求解器迭代中，我们计算一个冲量增量 $\Delta\lambda$，把它加到该约束的总冲量 $\lambda$ 上。该增量的公式对方程 {{eqref:eq:solver:lambda}} 作如下修改：
$$
{{numeq}}{eq:pbd:xpbd_delta_lambda}

\Delta\lambda = \frac{C(\bm{p}) + \hat{\alpha} \lambda}{\sum_{j} w_j |\nabla_{\bm{p}_j} C(\bm{p})|^2 + \hat{\alpha}}
$$
这里 $\lambda$ 是当前时间步内此前各次迭代为该约束累积的总拉格朗日乘子。$\hat{\alpha}$ 是按时间步缩放的柔度，定义为：
$$
\hat{\alpha} = \frac{\alpha}{(\Delta t)^2}
$$


这一缩放保证了柔度参数 $\alpha$ 在动力学系统中具有物理上一致的单位。计算出 $\Delta\lambda$ 后，求解器同时更新粒子位置与该约束的累积拉格朗日乘子：
$$
\Delta\bm{p}_i = - \Delta\lambda \, w_i \, \nabla_{\bm{p}_i} C(\bm{p}) \qquad \text{and} \qquad \lambda \leftarrow \lambda + \Delta\lambda
$$

> **{{rem}}{rem:pbd:xpbd_benefits}[对 XPBD 的解读]**
> 方程 {{eqref:eq:pbd:xpbd_delta_lambda}} 分母中的 $+\hat{\alpha}$ 项起到限制修正冲量 $\Delta\lambda$ 幅值的作用。随着柔度 $\alpha$ 增大（即材料变软），$\hat{\alpha}$ 也随之增大，从而减小每次迭代施加的冲量。当柔度为零（$\alpha=0$）时，$\hat{\alpha}$ 项消失，$\Delta\lambda$ 的公式退化为方程 {{eqref:eq:solver:lambda}} 中标准的 PBD 表述。

> **{{rem}}{rem:pbd:xpbd_convention}[关于符号的说明]**
> 在 PBD 的推导中，我们采用的约定是把修正量（$\Delta p_i$）显式地写成沿（$-\nabla_{p_i} C$）方向。为在 XPBD 中与这一选择保持一致，我们定义的累积乘子与原始论文中所用的符号相反。若你阅读原始论文或许多综述论文，请留意这一差异。


XPBD 的主要优势**不在于更快的收敛，而在于收敛到物理上一致、能正确反映用户设定柔度 $\alpha$ 的状态**，且与时间步或迭代次数无关。即使求解器被提前终止，系统仍在某种程度上表现出期望的柔软度，而不是人为的、不可控的柔度。这使材料行为更可预测，也更**稳健**。
