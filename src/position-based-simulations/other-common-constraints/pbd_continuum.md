## 基于连续体力学的约束

尽管距离、体积等简单几何约束对许多材料都很有效，但直接从连续体力学原理出发推导约束，可以获得物理上更严谨、表达能力更强的仿真。这一做法把基于位置的动力学与有限元方法（Finite Element Method，FEM）等成熟方法所拥有的丰富理论基础联系起来，使得仿真各向异性、弹塑性、非线性弹性等复杂材料行为成为可能。
其核心思想是基于变形梯度来定义约束，该张量度量材料的局部拉伸与剪切。

本节首先回顾离散化[变形与应变](../../finite-element-method/3d-elastodynamics/kinematics.md)所需的概念，然后详细介绍两种构造基于连续体的约束的方法：一种是以[应变能](../../hyperelasticity/strain-energy/strain_energy.md)为基础的整体式方法，另一种是更细粒度、直接约束应变张量各分量的方法。


### 应变能约束

将标准超弹性材料模型纳入基于位置的动力学（Position-Based Dynamics，PBD）最直接的方式，就是把它的应变能势用作约束函数。

在四面体网格这样的离散设定中，假定每个单元内的变形梯度为常数。对于材料空间顶点为 $(\bm{P}_1, \bm{P}_2, \bm{P}_3, \bm{P}_4)$、世界空间顶点为 $(\bm{p}_1, \bm{p}_2, \bm{p}_3, \bm{p}_4)$ 的四面体，我们可以由边向量定义材料空间形状矩阵 $\bm{D}_m$ 与世界空间形状矩阵 $\bm{D}_s$：
$$
\begin{aligned}
\bm{D}_m &= [\bm{P}_1-\bm{P}_4, \quad \bm{P}_2-\bm{P}_4, \quad \bm{P}_3-\bm{P}_4] \\
\bm{D}_s &= [\bm{p}_1-\bm{p}_4, \quad \bm{p}_2-\bm{p}_4, \quad \bm{p}_3-\bm{p}_4]
\end{aligned}
$$
于是该四面体的变形梯度由 $\bm{F} = \bm{D}_s \bm{D}_m^{-1}$ 给出。注意 $\bm{D}_m^{-1}$ 是常数，可以预先计算。

由 $\bm{F}$ 可以导出多种应变度量。其中最常用的是与刚体旋转无关的 **Green-St. Venant 应变张量** $\bm{\varepsilon}$：
$$
{{numeq}}{eq:continuum:green_strain}
\bm{\varepsilon} = \frac{1}{2}(\bm{F}^T\bm{F} - \bm{I})
$$
相关的**右 Cauchy-Green 变形张量** $\bm{S} = \bm{F}^T\bm{F} = 2\bm{\varepsilon} + \bm{I}$ 在构造直接应变约束时特别有用。若没有变形，则 $\bm{F}=\bm{I}$、$\bm{S}=\bm{I}$，且 $\bm{\varepsilon}=\bm{0}$。

根据胡克广义定律，我们可以把应力与应变联系起来：

$$\bm{S} = \bm{C}\bm{\varepsilon}$$
其中 $\bm{C}$ 为材料的弹性张量。回顾一下，变形固体的能量由标量应变能密度场在整个物体 $\Omega$ 上积分定义：

$$
E_s =\int_{\Omega} \Psi_s d\bm{P}
$$
其中应变能密度可以用应力与应变表示为：
$$
\Psi_s = \frac{1}{2}\varepsilon : \bm{S} = \frac{1}{2}tr(\varepsilon ^\top \bm{S})
$$

因此，单个四面体单元的总应变能等于其静止体积 $V_0$ 乘以能量密度。在未变形状态下，该能量为零。这自然导出如下约束形式：
$$
{{numeq}}{eq:continuum:energy_constraint}
C(\bm{p}_1, ..., \bm{p}_4) = E_s = V_0 \Psi_s(\bm{F}(\bm{p}_1, ..., \bm{p}_4)) = 0
$$


基于位置的动力学（PBD）求解器需要约束对顶点位置的梯度。这一梯度具有深刻的物理意义，因为它与**第一类 Piola-Kirchhoff 应力张量** $\bm{P}$ 直接相关，后者把当前构型中的力与参考构型中的面积联系起来。应力张量是变形梯度的函数 $\bm{P}(\bm{F})$。利用链式法则，前三个顶点的能量梯度可以写成紧凑的矩阵形式：
$$
{{numeq}}{eq:continuum:energy_gradient_tet}
\left[ \frac{\partial E_s}{\partial \bm{p}_1}, \frac{\partial E_s}{\partial \bm{p}_2}, \frac{\partial E_s}{\partial \bm{p}_3} \right] = V_0 \bm{P}(\bm{F}) \bm{D}_m^{-T}
$$
第四个顶点的梯度由平移不变性条件（即单元受到的合力必须为零）确定：
$$
{{numeq}}{eq:continuum:energy_gradient_tet4}
\frac{\partial E_s}{\partial \bm{p}_4} = - \sum_{i=1}^{3} \frac{\partial E_s}{\partial \bm{p}_i}
$$
这种表述可以自然地推广到由三角形构成的表面网格。对于静止面积为 $A_0$ 的三角形，约束为 $C(\bm{p}) = A_0 \Psi_s(\bm{F}_{\text{tri}})$。梯度的计算方式与之类似：
$$
{{numeq}}{eq:continuum:energy_gradient_tri}
\left[ \frac{\partial E_s}{\partial \bm{p}_1}, \frac{\partial E_s}{\partial \bm{p}_2} \right] = A_0 \bm{P}(\bm{F}_{\text{tri}}) \bm{D}_m^{-T} \quad \text{and} \quad \frac{\partial E_s}{\partial \bm{p}_3} = - \sum_{i=1}^{2} \frac{\partial E_s}{\partial \bm{p}_i}
$$

> **{{rem}}{rem:continuum:degenerate_elements}[处理单元翻转]**
> 标准本构模型通常并未对退化或翻转的单元（即 $\det(\bm{F}) \le 0$ 的情形）作定义，这可能引起仿真不稳定。这是一个关键的实际问题。通过为本构模型补充专为处理翻转而设计的技术，可以稳健地解决该问题。

这种应变能约束的优点在于其一般性。它并不局限于 St. Venant-Kirchhoff 模型这样的单一材料类型。更复杂、更符合物理的模型，例如用于类橡胶材料的新胡克（neo-Hookean）模型，只需替换相应的能量密度函数 $\Psi_s$ 即可直接支持。这使得基于位置的动力学（PBD）能够以很高的保真度与效率仿真横向收缩（泊松效应）、各向异性以及弹塑性等复杂物理效应。



### 基于直接应变的约束

对于需要对材料属性进行更细粒度或更直观控制的应用，尤其是各向异性仿真，为每种变形模式分别定义约束是有利的。该做法作用于右 Cauchy-Green 变形张量 $\bm{S} = \bm{F}^T\bm{F}$ 的各个分量。

#### 拉伸约束
$\bm{S}$ 的对角元素 $S_{ii}$ 表示沿材料参考轴的拉伸的平方。在未变形状态下 $S_{ii}=1$。为使约束投影保持线性并能在一步内收敛，拉伸约束基于拉伸本身而非其平方来构造：
$$
{{numeq}}{eq:continuum:linear_stretch_constraint}
C_{\text{stretch}, i}(\bm{x}) = \sqrt{S_{ii}} - 1 = 0
$$
通过为每个主轴定义一个这样的约束，就可以赋予各自独立的刚度参数，而这正是对各向异性拉伸抗力建模的关键。

#### 剪切约束
$\bm{S}$ 的非对角元素 $S_{ij} = \bm{f}_i \cdot \bm{f}_j$（其中 $\bm{f}_k$ 为 $\bm{F}$ 的列向量）度量材料轴之间的剪切。朴素的约束 $S_{ij}=0$ 会把剪切与拉伸耦合在一起，带来问题。为隔离剪切变形，必须对该约束做归一化，使其只依赖于变形后各轴之间的夹角：
$$

{{numeq}}{eq:continuum:decoupled_shear_constraint}
C_{\text{shear}, ij}(\bm{x}) = \frac{\bm{f}_i \cdot \bm{f}_j}{|\bm{f}_i||\bm{f}_j|} = 0
$$
这种表述确保剪切约束只强制材料轴之间保持正交，而不干扰控制其长度的拉伸约束。这种解耦对于直观且独立地调节材料行为至关重要。
