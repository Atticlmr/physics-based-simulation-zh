## 非线性系统的模型降维

线性模态分析的效率极高，但其背后的小变形假设是一个重大局限。对于屈曲、大弯曲或扭转这类视觉上丰富的现象，线性模型会产生严重的视觉瑕疵。如上一节所示，简单的线性模型无法捕捉物体弯曲时自然发生的透视缩短，导致长度与体积出现不真实的膨胀。为了正确捕捉这些本质的非线性效应，我们必须对完整的非线性运动方程施加模型降维。

### 投影非线性方程

含阻尼的一般超弹性物体的运动方程为：

$$ \mathbf{M}\ddot{\mathbf{u}} + \mathbf{D}\dot{\mathbf{u}} + \mathbf{f}_{int}(\mathbf{u}) = \mathbf{f}_{ext}. {{numeq}}{eq:lec26:nonlinear_system} $$

这里，线性弹力 $\mathbf{K}\mathbf{u}$ 被替换为一般的**内力函数** $\mathbf{f}_{int}(\mathbf{u})$，它可以是位移 $\mathbf{u}$ 的复杂非线性函数。这种非线性可能来自材料模型（应力-应变关系），也可能来自应变度量本身（几何非线性）。

我们沿用与线性情形相同的基于投影的流程。假设存在合适的基矩阵 $\mathbf{U} \in \mathbb{R}^{3n \times r}$（其中 $r \ll 3n$）——关于基的选取将在下一节详述——并用约化坐标 $\mathbf{q} \in \mathbb{R}^r$ 近似全空间位移 $\mathbf{u}$：

$$ \mathbf{u}(t) \approx \mathbf{U}\mathbf{q}(t). $$

将其代入 {{eqref:eq:lec26:nonlinear_system}} 并左乘 $\mathbf{U}^T$ 把动力学投影到子空间，得到**约化非线性运动方程**：

$$ \mathbf{U}^T\mathbf{M}\mathbf{U}\ddot{\mathbf{q}} + \mathbf{U}^T\mathbf{D}\mathbf{U}\dot{\mathbf{q}} + \mathbf{U}^T\mathbf{f}_{int}(\mathbf{Uq}) = \mathbf{U}^T\mathbf{f}_{ext}.
$$

假设我们已构造出质量正交归一的基，使 $\mathbf{U}^T\mathbf{M}\mathbf{U} = \mathbf{I}$，则上式简化为：

$$ \ddot{\mathbf{q}} + \hat{\mathbf{D}} \dot{\mathbf{q}} + \hat{\mathbf{f}}_{int}(\mathbf{q}) = \hat{\mathbf{f}}_{ext},
{{numeq}}{eq:lec26:simplified_nonlinear}
$$

其中：
*   $\hat{\mathbf{D}} = \mathbf{U}^T\mathbf{D}\mathbf{U}$ 是 $r \times r$ 的约化阻尼矩阵。
*   $\hat{\mathbf{f}}_{int}(\mathbf{q}) = \mathbf{U}^T\mathbf{f}_{int}(\mathbf{Uq})$ 是 $r \times 1$ 的**约化内力**向量。
*   $\hat{\mathbf{f}}_{ext} = \mathbf{U}^T\mathbf{f}_{ext}$ 是 $r \times 1$ 的约化外力向量。


与线性情形不同，{{eqref:eq:lec26:simplified_nonlinear}} 中的约化系统不再是一组相互独立的 1D 振子。约化内力 $\hat{\mathbf{f}}_{int}(\mathbf{q})$ 是一个非线性函数，它把 $\mathbf{q}$ 的所有分量耦合在一起。这带来两个关键问题：
1.  如何高效地对这个耦合的非线性系统进行时间步进？
2.  如何选取一个能够表示非线性变形的有效基 $\mathbf{U}$？（见下一节）

### 时间步进与求值瓶颈

为了求解 {{eqref:eq:lec26:simplified_nonlinear}}，我们通常采用隐式时间积分格式，这是处理弹性系统中常见的高频刚度所必需的。一个隐式步需要求解一个涉及力导数的线性系统。对我们的约化系统而言，这意味着需要**约化切刚度矩阵** $\hat{\mathbf{K}}(\mathbf{q})$：

<!-- $$ \hat{\mathbf{K}}(\mathbf{q}) = \frac{\partial \hat{\mathbf{f}}_{int}(\mathbf{q})}{\partial \mathbf{q}} $$ -->
$$ \hat{\mathbf{K}}(\mathbf{q}) = D_\mathbf{q} \hat{\mathbf{f}}_{int}(\mathbf{q}). $$

利用链式法则，可以把它与全空间切刚度矩阵 $\mathbf{K}(\mathbf{u}) = D_{\mathbf{u}}\mathbf{f}_{int}(\mathbf{u})$ 联系起来：

<!-- $$ \hat{\mathbf{K}}(\mathbf{q}) = \frac{\partial}{\partial \mathbf{q}} \left( \mathbf{U}^T\mathbf{f}_{int}(\mathbf{Uq}) \right) = \mathbf{U}^T \frac{\partial \mathbf{f}_{int}(\mathbf{Uq})}{\partial \mathbf{q}} = \mathbf{U}^T \left( \frac{\partial \mathbf{f}_{int}(\mathbf{u})}{\partial \mathbf{u}} \bigg|_{\mathbf{u}=\mathbf{Uq}} \frac{\partial (\mathbf{Uq})}{\partial \mathbf{q}} \right) $$ -->
$$ \hat{\mathbf{K}}(\mathbf{q}) = D_{\mathbf{q}} \left( \mathbf{U}^T\mathbf{f}_{int}(\mathbf{Uq}) \right) = \mathbf{U}^T D_{\mathbf{q}} (\mathbf{f}_{int}(\mathbf{Uq}))= \mathbf{U}^T \left( D_{\mathbf{u}} (\mathbf{f}_{int}(\mathbf{u}))\bigg|_{\mathbf{u}=\mathbf{Uq}} D_{\mathbf{q}}(\mathbf{Uq} ) \right), $$

$$ \hat{\mathbf{K}}(\mathbf{q}) = \mathbf{U}^T \mathbf{K}(\mathbf{Uq}) \mathbf{U}.$$

在每个时间步，隐式积分器都要解一个涉及 $\hat{\mathbf{K}}$ 的 $r \times r$ 稠密线性系统。由于 $r \ll 3n$，与求解原始的 $3n \times 3n$ 稀疏系统相比，这是巨大的改进。

然而，一个主要的计算难题随之出现：如何高效地计算 $\hat{\mathbf{f}}_{int}(\mathbf{q})$ 与 $\hat{\mathbf{K}}(\mathbf{q})$？朴素的做法是：
1.  取当前的约化坐标 $\mathbf{q}$。
2.  **反投影**得到全空间变形：$\mathbf{u} = \mathbf{Uq}$。
3.  通过遍历高分辨率网格中的所有单元，**求值**全空间的力 $\mathbf{f}_{int}(\mathbf{u})$ 与刚度 $\mathbf{K}(\mathbf{u})$。
4.  **投影回**约化空间：$\hat{\mathbf{f}}_{int} = \mathbf{U}^T\mathbf{f}_{int}$ 与 $\hat{\mathbf{K}} = \mathbf{U}^T\mathbf{K}\mathbf{U}$。

这一过程极其缓慢，因为第 3 步仍然需要对高分辨率网格做一次完整遍历，完全抵消了模型降维的意义。更糟的是，计算矩阵乘积 $\mathbf{U}^T\mathbf{K}\mathbf{U}$ 既费计算又费内存。

### 加速力的求值

要让非线性模型降维切实可用，我们需要一种无需构造全空间对应量就能求值约化力与刚度矩阵的方法。

#### 多项式拟合（针对特定材料）
对某些材料模型，可以采用一种极高效的分析方法。例如，在几何非线性但材料线性的模型（如 St. Venant-Kirchhoff 模型）中，全空间内力向量 $\mathbf{f}_{int}(\mathbf{u})$ 的每个分量都是 $\mathbf{u}$ 各分量的三次多项式。

由于 $\mathbf{u} = \mathbf{Uq}$，约化力 $\hat{\mathbf{f}}_{int}(\mathbf{q}) = \mathbf{U}^T\mathbf{f}_{int}(\mathbf{Uq})$ 同样是三次多项式，只不过是约化坐标 $\mathbf{q}$ 的三次多项式。我们可以预计算这个 $r$ 元三次多项式的系数。运行时，求值 $\hat{\mathbf{f}}_{int}(\mathbf{q})$ 及其导数 $\hat{\mathbf{K}}(\mathbf{q})$ 只需计算这些预计算的多项式。力的求值代价为 $O(r^4)$，隐式积分则为 $O(r^3)$，对较小的 $r$（例如 $r < 30$）完全可以承受，而且与网格规模 $n$ 完全无关。遗憾的是，这一方法只适用于力为低次多项式的材料。



#### 求积（针对一般材料）
更通用、更强大的方案是**求积（cubature）** {{#cite an2008optimizing}}。其核心洞见在于重新审视约化力是如何计算的。

约化能量 $\hat{E}$ 是全能量在子空间内的取值：
$$ \hat{E}(\mathbf{q}) = E(\mathbf{Uq}) = \int_{\Omega_0} \Psi(\mathbf{F}(\mathbf{Uq}, X)) \, dV. $$

约化内力 $\hat{\mathbf{f}}_{int}$ 正是该约化能量对约化坐标 $\mathbf{q}$ 的梯度。把导数移到积分号内，可得：
<!-- $$ \hat{\mathbf{f}}_{int}(\mathbf{q}) = \frac{\partial \hat{E}}{\partial \mathbf{q}} = \int_{\Omega_0} \frac{\partial \Psi(\mathbf{F}(\mathbf{Uq}))}{\partial \mathbf{q}} \, dV  $$ -->
$$ \hat{\mathbf{f}}_{int}(\mathbf{q}) =  \nabla_{\mathbf{q}}E  = \int_{\Omega_0} \nabla_\mathbf{q}\Psi(\mathbf{F(\mathbf{Uq}, X)}) \, dV.  $$
这表明约化力是*约化能量密度梯度*在物体体积上的积分。投影 $\mathbf{U}^T$ 通过链式法则隐含在导数 $\nabla_\mathbf{q}$ 之中。

与其通过累加所有有限单元的贡献来精确计算这个积分，求积法改为用极少数 $T$ 个预先选定的采样点（或"求积点"）$\mathbf{X}_j \in \Omega_0$ 上的加权和来近似它：

$$ \hat{\mathbf{f}}_{int}(\mathbf{q}) \approx \sum_{j=1}^{T} w_j \nabla_{\mathbf{q}}\Psi(\mathbf{F}(\mathbf{Uq}, X))  \bigg|_{\mathbf{X}=\mathbf{X}_j}.
 {{numeq}}{eq:lec25:cuabture_force}$$

求积点的数目 $T$ 可以小得惊人（通常与 $r$ 同量级），却仍能给出高度精确的近似。这些点 $\mathbf{X}_j$ 及其非负权重 $w_j$ 在一个预计算步骤中被优化，使得在一组具有代表性的"训练"位形上，近似结果与真实的约化力最吻合。

运行时，求值约化力与刚度只需遍历这 $T$ 个点。代价变得与原始网格分辨率 $n$ 无关，从而使复杂非线性材料的快速仿真成为可能。


可以看到，*如何*选取基 $\mathbf{U}$ 以最有效地表示非线性变形空间，可能非常重要。这将在下一节讨论！
