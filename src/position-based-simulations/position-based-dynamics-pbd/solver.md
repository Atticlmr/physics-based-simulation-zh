## 约束求解器
基于位置的动力学（Position-Based Dynamics，PBD）算法的核心是约束求解器，它迭代地把预测的粒子位置投影到满足已定义约束的位置。由于这种投影必须以物理上合理的方式进行——理想情况下对内部约束应保持系统的总线性动量与总角动量守恒——我们采用非线性高斯-赛德尔求解器。

### 约束投影：动量守恒
为使结果尽可能符合物理，我们要确保对任何内部约束，修正步骤都不应引入虚构的外力，即通常所说的“鬼力”（ghost forces）。这一点通过保证线动量与角动量的净变化为零来实现。设 $\Delta\bm{p}_i$ 为粒子 $i$ 的位置修正量。若修正后质心保持不变，则线动量守恒：

$$
\sum_i m_i \Delta\bm{p}_i = \bm{0}
$$

若各修正量相对于共同旋转中心 $\bm{c}$ 产生的净力矩为零，则角动量守恒：

$$
\sum_i (\bm{p}_i - \bm{c}) \times (m_i \Delta\bm{p}_i) = \bm{0}
$$

> **{{rem}}{rem:lec31:grad_dir}[约束梯度]**
> 一个关键的洞见是：若拼接后的粒子位置修正向量 $\Delta\bm{p} = [\Delta\bm{p}_1^T, \dots, \Delta\bm{p}_n^T]^T$ 取为与约束梯度 $\nabla_{\bm{p}}C$ 平行，即：
> $$\Delta p ^\top \nabla_{\bm{p}}C = 0$$
> 那么对许多常见的内部约束（它们与刚体变换无关），当各粒子质量相等时，两种动量都自动守恒。

因此，我们假定每个粒子的修正量都与其约束梯度平行。这一选择的依据是：梯度指向约束函数上升最陡的方向，因此沿相反方向移动是减小约束误差最直接的途径。


### 位置修正（一般约束）
 
考虑涉及 $n$ 个粒子的单个约束 $C(\bm{p}_1, \dots, \bm{p}_n) = 0$。给定一组违反该约束的预测位置 $\bm{p}$（即 $C(\bm{p}) \neq 0$），我们寻求修正量 $\Delta\bm{p}$，使得 $C(\bm{p} + \Delta\bm{p}) = 0$。为使问题易于处理，我们在当前位置 $\bm{p}$ 处用一阶泰勒展开对约束函数线性化：
$$
\begin{align*}
{{numeq}}{eq:pbd:linearized_constraint}
C(\bm{p} + \Delta\bm{p}) &= C(\bm{p}) + \nabla_{\bm{p}} C(\bm{p})^\top \Delta\bm{p} + \mathcal{O}(\|\Delta p\|^2) \succ 0, \\
C(\bm{p} + \Delta\bm{p}) &\approx C(\bm{p}) + \nabla_{\bm{p}} C(\bm{p})^\top \Delta\bm{p} \succ 0.
\end{align*}
$$

如上所述，我们把修正量限制在约束梯度方向上。这样便能用一个未知标量 $\lambda$ 来表示单个粒子 $i$ 的修正量，该标量充当拉格朗日乘子：
$$
{{numeq}}{eq:solver:correction_form}

\Delta\bm{p}_i = - \lambda \, w_i \, \nabla_{\bm{p}_i} C(\bm{p})
$$
其中 $w_i = 1/m_i$ 为逆质量，从而质量越小的粒子位移越大。负号是一种约定，使 $\lambda$ 在约束被正向违反时与排斥力的概念相对应。对所有相关粒子写成向量形式，即为 $\Delta\bm{p} = -\lambda \mathbf{M}^{-1} \nabla_{\bm{p}}C$，其中 $\mathbf{M}$ 为对角质量矩阵。

为求出 $\lambda$ 的值，我们把方程 {{eqref:eq:solver:correction_form}} 中的修正量代回线性化后的约束，即方程 {{eqref:eq:pbd:linearized_constraint}}。对等式约束，这给出：
$$
C(\bm{p}) + \nabla_{\bm{p}} C(\bm{p})^\top (-\lambda \mathbf{M}^{-1} \nabla_{\bm{p}} C(\bm{p})) = 0
$$
解出拉格朗日乘子 $\lambda$ 得：
$$
{{numeq}}{eq:solver:lambda}

\lambda = \frac{C(\bm{p})}{\sum_{j=1}^{n} w_j \|\nabla_{\bm{p}_j} C(\bm{p})\|^2}
$$
$\lambda$ 确定之后，每个粒子的位置修正量 $\Delta\bm{p}_i$ 便完全确定。将方程 {{eqref:eq:solver:lambda}} 代入方程 {{eqref:eq:solver:correction_form}}，还可以把完整修正写成单一表达式：
$$
{{numeq}}{eq:pbd:final_correction}

\Delta\bm{p}_i = - \frac{C(\bm{p}_1, \dots, \bm{p}_n)}{\sum_{j=1}^{n} w_j \|\nabla_{\bm{p}_j}C\|^2} w_i \nabla_{\bm{p}_i}C(\bm{p})
$$
该方程是基于位置的动力学（PBD）求解器的基石。它给出了一种直接而计算高效的方法，用于计算在满足单个线性化约束、同时顾及粒子质量的前提下所需的位置修正量。在单个时间步内，每个约束的投影会被求解多次。需要注意，对于沿其梯度方向呈线性的约束（例如简单的距离约束），这种线性化是精确的，约束可在一步之内得到满足。



> **{{exp}}{exp:solver:distance_constraint}[距离约束]**
> 让我们考虑最基本的约束之一：距离约束，它强制两个粒子 $\bm{p}_1$ 与 $\bm{p}_2$ 之间保持固定间隔 $d$。这是常用的基本构件，可用于建模弹簧的抗拉伸能力、布料网格的边，或物体之间的刚性连杆。
>
> 约束函数定义为当前距离与期望的静止距离 $d$ 之差：
$$
  C(\bm{p}_1, \bm{p}_2) = \|\bm{p}_1 - \bm{p}_2\| - d
$$
> 该函数直接度量了需要修正的误差。虽然可以套用方程 {{eqref:eq:pbd:final_correction}} 的通用投影方法，但对于这一常见特例，结果会化简为非常直观的形式。每个粒子的最终位置修正量可直接写为：
$$
 \begin{align*}
 \Delta\bm{p}_1 &= - \frac{w_1}{w_1 + w_2} (\|\bm{p}_1 - \bm{p}_2\| - d) \frac{\bm{p}_1 - \bm{p}_2}{\|\bm{p}_1 - \bm{p}_2\|} && \\
 \Delta\bm{p}_2 &= + \frac{w_2}{w_1 + w_2} (\|\bm{p}_1 - \bm{p}_2\| - d) \frac{\bm{p}_1 - \bm{p}_2}{\|\bm{p}_1 - \bm{p}_2\|} && 
 \end{align*}
 $$
>  其中 $(\|\bm{p}_1 - \bm{p}_2\| - d)$ 表示沿连接两粒子的向量方向所需的总修正量。该总修正量随后按逆质量比 $w_i / (w_1 + w_2)$ 在两个粒子之间分配。修正沿单位向量 $(\bm{p}_1 - \bm{p}_2)/\|\bm{p}_1 - \bm{p}_2\|$ 施加：若两粒子相距过远（$C > 0$）则相互靠近，若相距过近（$C < 0$）则相互远离。这一形式直接满足线动量守恒！






### 层次化求解器

基于位置的动力学（PBD）中标准的高斯-赛德尔求解器在低频、大尺度变形上收敛缓慢，因为修正只能局部传播。为加速收敛，层次化基于位置的动力学（Hierarchical Position Based Dynamics，HPBD）{{#cite muller2008hierarchical}} 引入了多分辨率方法。系统被表示为从粗到细的层次化网格。
求解器先在最粗的层级上运行，使大尺度误差的修正能够迅速传播到整个物体。随后在单次由粗到细的遍历中，通过插值（延拓，prolongation）把这些修正传递到逐级更细的层级上并加以细化。这种受多重网格启发的技术显著提升了收敛速度。为使该过程正确工作，粗层级上的约束必须是单侧的（不等式约束），即只抵抗拉伸，从而避免人为限制物体的大尺度弯曲与折叠。
