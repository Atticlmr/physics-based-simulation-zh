## 变形梯度与粒子状态更新

在 MPM 中，每个粒子携带一个变形梯度 $\mathbf{F}_p$，它跟踪附着于该粒子的局部材料体积随时间如何被拉伸、旋转或剪切。它在依据本构模型计算应力时起核心作用。

每个时间步开始时，网格位于规则的、未变形的格点上。设 $\mathbf{x}_i^n$ 为网格节点 $i$ 在时刻 $t^n$ 的位置。在给定网格速度场 $\hat{\mathbf{v}}_i^{n+1}$ 的前提下，通过观察网格在该时间步内的局部运动即可更新变形梯度。

### 变形梯度更新

最常见的方法是采用一阶近似计算 $\mathbf{F}_p^{n+1}$：

$$
\mathbf{F}_p^{n+1} =
\left( \mathbf{I} + \Delta t \sum_i \mathbf{v}_i^{n+1} \nabla (w_{ip}^n)^T \right) \mathbf{F}_p^n.
$$

在 **MLS-MPM** {{#cite hu2018moving}} 与 **APIC** {{#cite jiang2015affine}} 中，变形梯度的更新可以利用 P2G 与 G2P 传输过程中已经计算出的仿射速度矩阵 $\mathbf{C}_p$ 更紧凑地重写。

回顾局部仿射速度场：

$$
\mathbf{v}_p(\mathbf{x}) = \mathbf{v}_p + \mathbf{C}_p (\mathbf{x} - \mathbf{x}_p).
$$

由此，网格运动诱导出局部速度梯度 $\mathbf{C}_p$，变形梯度可按如下方式更新：

$$
\mathbf{F}_p^{n+1} = \left( \mathbf{I} + \Delta t \, \mathbf{C}_p \right) \mathbf{F}_p^n.
\tag{3}
$$

这样就无需显式求值 $\nabla w_{ip}$，而是使用已经聚合在 $\mathbf{C}_p$ 中的仿射行为。

**塑性流动**也在这一阶段施加，以把更新后的变形梯度投影回由材料屈服准则所定义的可容许空间。这一过程称为**返回映射**，它保证材料满足塑性极限，将在[下一讲](../beyond-elasticity-plasticity-and-viscosity/mpm_plasticity.md)中详细讨论。

### 位置更新

时刻 $t^{n+1}$ 的粒子位置随后按如下方式平流：

$$
\mathbf{x}_p^{n+1} = \mathbf{x}_p^{n} + \Delta t \mathbf{v}_p^{n+1}.
$$
