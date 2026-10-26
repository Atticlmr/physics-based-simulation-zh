## 应力

应力是与变形梯度 $\mathbf{F}$ 类似的张量场，它定义在固体材料的整个区域上。应力量化材料物体内部承受的压力与张力。应力与应变（或 $\mathbf{F}$）之间的联系通过所谓的**本构关系**建立。这一关系描述了材料如何响应各种变形。

本构关系的一个常见例子是一维胡克定律，它适用于许多常规材料在弹性条件下的情形。在**超弹性材料**的语境下，该关系具体由应变能函数 $\Psi(\mathbf{F})$ 定义。 

> **{{def}}{def:lec13:hyperelastic}[超弹性材料]**
> 超弹性材料是这样一类弹性固体：其**第一类 Piola-Kirchhoff 应力** $\mathbf{P}$
可由应变能密度函数 $\Psi(\mathbf{F})$ 通过下式导出
$$
\mathbf{P} = \frac{\partial \Psi}{\partial \mathbf{F}}. {{numeq}}{eqn:stress}
$$
> 用指标记法表示，即 
$$
P_{ij} = \frac{\partial \Psi}{\partial F_{ij}}.
$$
> $\mathbf{P}$ 在离散意义下是一个与 $\mathbf{F}$ 维数相同的小矩阵。


在研究材料在应力作用下的行为时，人们会使用各种定义，其中**柯西应力**在工程领域尤为常用。柯西应力记为 $\sigma(\cdot,t):\Omega^t\rightarrow\mathbb{R}^{d\times d}$，它可通过如下关系在数学上与第一类 Piola-Kirchhoff 应力张量 $\mathbf{P}$ 相联系：
$$
\sigma = \frac{1}{J} \mathbf{P} \mathbf{F}^T = \frac{1}{\text{det}(\mathbf{F})} \frac{\partial \Psi}{\partial \mathbf{F}} \mathbf{F}^T.
$$

对于不需要奇异值分解（SVD）的能量模型，例如新胡克（Neo-Hookean）模型，由应变能函数 $\Psi(\mathbf{F})$ 计算 $\mathbf{P}$ 相对直接。然而，一般的各向同性弹性模型，如 ARAP（As-Rigid-As-Possible），往往依赖主拉伸或最近旋转矩阵的计算，因而需要 SVD。当要确定对隐式时间积分至关重要的 $\frac{\partial \mathbf{P}}{\partial \mathbf{F}}$ 时，这一计算会变得格外复杂且耗费资源。

我们介绍一种利用稀疏结构的高效方法（由 {{#cite stomakhin2012energetically}} 提出），用于计算一般各向同性弹性材料的第一类 Piola-Kirchhoff 应力张量 $\mathbf{P}$ 及其导数 $\frac{\partial \mathbf{P}}{\partial \mathbf{F}}$（无论以张量形式还是以微分 $\delta \mathbf{P}$ 形式给出）。该方法借助符号计算软件包，我们将具体讨论在 *Mathematica* 中的实现。在 *Maple* 或其他软件中的实现同样直接，遵循相同的概念框架。若想更深入地了解计算机图形学中常用的导数计算，可参阅 {{#cite schroeder2022practical}} 的工作。

需要注意的是，所讨论的计算策略也可用于对角空间中的其他导数，与 $\frac{\partial \mathbf{P}}{\partial \mathbf{F}}$ 类似。例如，在某些模型中，人们更倾向于使用**基尔霍夫应力** $\tau$ 而不是第一类 Piola-Kirchhoff 应力 $\mathbf{P}$。基尔霍夫应力表示为：
$$
\tau = \mathbf{U} \hat{\tau} \mathbf{U}^T,
$$
其中 $\hat{\tau}$ 是一种对角应力度量，其每个元素都是奇异值 $\Sigma$ 的函数。计算 $\frac{\partial \tau}{\partial \mathbf{F}}$ 的方法与计算 $\mathbf{P}$ 的方法相同。
