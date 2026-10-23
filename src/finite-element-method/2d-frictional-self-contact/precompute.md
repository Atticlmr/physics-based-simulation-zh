## 预计算法向与切向信息

为使时间离散后的摩擦力可积，我们必须显式离散某些法向与切向信息。这些信息只需在每个时间步开始时计算一次，因为它在每次优化过程中保持不变。

首先，我们需要利用 $\mathbf{x}^{n}$ 为每个点-边对计算 $\lambda^{n}$。回顾一下，我们使用距离的平方作为障碍函数的输入，因此 $\lambda^{n}$ 应按如下方式用链式法则计算：

$$
\begin{aligned}
    \lambda^{n}_{\hat{a}, e} 
    & = \frac{1}{2}A_{\hat{a}} \left(-\frac{\partial b( d^\text{PE}_\text{sq}(\mathbf{x}^{n}_{\hat{a}}, e), \hat{d}^2)}{\partial d^{\text{PE}}}\right)
    = \frac{1}{2}A_{\hat{a}} \left(-\frac{\partial b( d^\text{PE}_\text{sq}(\mathbf{x}^{n}_{\hat{a}}, e), \hat{d}^2)}{\partial d^{\text{PE}}_\text{sq}} \frac{\partial d^\text{PE}_\text{sq}}{\partial d^\text{PE}}\right) \\
    & = \frac{1}{2} A_{\hat{a}} \left(-\frac{\partial b( d^\text{PE}_\text{sq}(\mathbf{x}^{n}_{\hat{a}}, e), \hat{d}^2)}{\partial d^{\text{PE}}_\text{sq}}\right) 2 d^\text{PE}.
\end{aligned}
$$

根据以距离平方为输入的缩放障碍函数（公式 {{eqref: eq:lec21:scaled_barrier_func}}），可以推出

$$
\frac{\partial b(d_{\text{sq}}, \hat{d}^2)}{\partial d_{\text{sq}}} = 
\begin{cases}
    \frac{\kappa}{8} \hat{d} \left( \frac{1}{\hat{d}^2} \ln{\frac{d_{\text{sq}}}{\hat{d}^2}} + \frac{1}{d_{\text{sq}}}\left(\frac{d_{\text{sq}}}{\hat{d}^2} - 1\right) \right) & \text{if } d < \hat{d}; \\
    0 & \text{if } d \geq \hat{d}.
\end{cases}
$$


> **{{rem}}{rm:lec22:set_difference_friction}** 在我们的半隐式摩擦设定中，用于摩擦的点-边对集合在每个时间步内是固定的，且与法向接触对集合不同。摩擦所用的集合只包含满足 $d^\text{PE}(\mathbf{x}^{n}_{\hat{a}}, e) < \hat{d}$ 的那些对，并且在当前时间步内不随优化变量 $\mathbf{x}^{n+1}$ 变化。

至于切向信息，关键在于保持法向以及边上最近点的重心坐标不变。对于第 $k$ 个点-边对，若把该点与边的节点编号分别记为 $p$、$e_0$ 和 $e_1$，则相对滑动速度可以写为

$$
\mathbf{v}_k = (\mathbf{I} - \mathbf{n}\mathbf{n}^T) \big( \mathbf{v}_p - ((1 - r) \mathbf{v}_{e_0} + r \mathbf{v}_{e_1}) \big),
$$

其中 $r = \argmin_{c} \| \mathbf{x}_p - ((1-c) \mathbf{x}_{e_0} + c \mathbf{x}_{e_1})\|$ 是重心坐标，$\mathbf{n} = \big( \mathbf{x}_p - ((1-r) \mathbf{x}_{e_0} + r \mathbf{x}_{e_1}) \big) / \| \mathbf{x}_p - ((1-r) \mathbf{x}_{e_0} + r \mathbf{x}_{e_1})\|$ 是边的法向。这里可以看到，$r$ 与 $\mathbf{n}$ 都依赖于 $\mathbf{x}$，因此直接对 $\mathbf{v}_k$ 积分并不容易。通过用 $\mathbf{x}^{n}$ 计算 $\mathbf{n}$ 和 $r$，我们得到半隐式相对滑动速度

$$
\bar{\mathbf{v}}_k = (\mathbf{I} - \mathbf{n}^{n}(\mathbf{n}^{n})^T) \big( \mathbf{v}_p - ((1 - r^{n}) \mathbf{v}_{e_0} + r^{n} \mathbf{v}_{e_1}) \big),
$$

此时只有速度依赖于 $\mathbf{x}^{n+1}$，使得积分与求导都变得简单直接。若记 $\hat{\mathbf{v}}_k =  \mathbf{v}_p - ((1 - r^{n}) \mathbf{v}_{e_0} + r^{n} \mathbf{v}_{e_1})$，我们得到

$$
\frac{\partial \bar{\mathbf{v}}_k}{\partial \hat{\mathbf{v}}_k} = (\mathbf{I} - \mathbf{n}^{n}(\mathbf{n}^{n})^T) \quad \text{and} \quad 
\frac{\partial \hat{\mathbf{v}}_k}{ \partial [\mathbf{x}_p^T, \mathbf{x}_{e_0}^T, \mathbf{x}_{e_1}^T]^T } = \frac{1}{\hat{h}} \begin{bmatrix}\mathbf{I} & (r^{n} - 1) \mathbf{I} & -r^{n} \mathbf{I}\end{bmatrix}.
$$

### 代码

接下来看代码。{{ref: imp:lec22:contact_point_and_normal}} 在给定点与边节点位置的情况下计算最近点的重心坐标与法向。其思路是把 $\mathbf{x}_p$ 正交投影到边上。


{{imp}}{imp:lec22:contact_point_and_normal}[计算接触点与法向，PointEdgeDistance.py]
```python
{{#include ../../solid-sim-tutorial/8_self_friction/distance/PointEdgeDistance.py:tangent}}
```

随后，{{ref: imp:lec22:fric_precomp}} 遍历所有距离小于 $\hat{d}$ 的非相邻点-边对，计算 $\lambda$，并调用上面的函数计算 $\mathbf{n}$ 与 $r$。

与[摩擦接触](../3d-frictional-self-contact/friction.md)中一样，这几行代码在 `time_integrator.py` 中每个时间步开始时执行，每个摩擦对的信息会被存储下来，并传递给接下来要讨论的能量、梯度与海森矩阵计算函数。

{{imp}}{imp:lec22:fric_precomp}[半隐式摩擦预计算，BarrierEnergy.py]
```python
{{#include ../../solid-sim-tutorial/8_self_friction/BarrierEnergy.py:fric_precomp}}
```
