## 障碍能量及其导数

有了已实现的点-边距离函数，我们就可以遍历所有点-边对，组装总障碍能量及其导数。它们将用于在时间步进优化中求解搜索方向。

由于使用的是平方距离，这里我们把障碍函数重新缩放为
$$
b(d^2, \hat{d}^2) = 
\begin{cases}
    \frac{\kappa}{8} \hat{d} \left(\frac{d^2}{\hat{d}^2} - 1\right) \ln \frac{d^2}{\hat{d}^2} & d < \hat{d} \\
    0 & d \geq \hat{d},
\end{cases}
{{numeq}}{eq:lec21:scaled_barrier_func}
$$
从而
$$
\frac{\partial^2 b}{\partial (\frac{d}{\hat{d}})^2}(\hat{d}^2, \hat{d}^2) = \kappa \hat{d}
$$
依然成立。与弹性类似，$s = d/\hat{d}$ 可视为一种应变度量，于是能量密度（每单位面积）函数 $b$ 关于 $s$ 的二阶导数在 $s=1$ 处的取值对应于杨氏模量乘以厚度 $\hat{d}$，这使得 $\kappa$ 具有物理意义且便于设定。

基于式 {{eqref: eq:lec20:barrier_discrete}}，可推导障碍势能的梯度与海森矩阵为
$$
\begin{aligned}
    \nabla P_b(x) & = \frac{1}{2} \sum_{\hat{a}} A_{\hat{a}}  \sum_{e \in \mathcal{E} - I(\mathbf{X}_{\hat{a}})} \frac{\partial b}{\partial d}( d(\mathbf{x}_{\hat{a}}, e), \hat{d}^2) \nabla_x d(\mathbf{x}_{\hat{a}}, e) \ \text{and} \\
    \nabla^2 P_b(x) & = \frac{1}{2} \sum_{\hat{a}} A_{\hat{a}}  \sum_{e \in \mathcal{E} - I(\mathbf{X}_{\hat{a}})} \Big( \frac{\partial^2 b}{\partial d^2}( d(\mathbf{x}_{\hat{a}}, e), \hat{d}^2) \nabla_x d(\mathbf{x}_{\hat{a}}, e) \nabla_x d(\mathbf{x}_{\hat{a}}, e)^T + \\&\frac{\partial b}{\partial d}( d(\mathbf{x}_{\hat{a}}, e), \hat{d}^2) \nabla^2_x d(\mathbf{x}_{\hat{a}}, e) \Big),
\end{aligned}
$$
其中 $A_{\hat{a}} = \frac{\|\mathbf{X}_{\hat{a}} - \mathbf{X}_{\hat{a} - 1} \| + \|\mathbf{X}_{\hat{a}} - \mathbf{X}_{\hat{a} + 1} \|}{2}$，并且我们省略了平方点-边距离函数的上标与下标（此处 $d(\mathbf{x}_{\hat{a}}, e)$ 表示 $d^{\text{PE}}_{\text{sq}}(\mathbf{x}_{\hat{a}}, e)$）。

障碍接触势能的能量、梯度与海森矩阵实现如下：

{{imp}}{imp:lec21:BarrierEnergy_value}[障碍能量计算，BarrierEnergy.py]
```python
{{#include ../../solid-sim-tutorial/7_self_contact/BarrierEnergy.py:value}}
```

{{imp}}{imp:lec21:BarrierEnergy_grad}[障碍能量梯度计算，BarrierEnergy.py]
```python
{{#include ../../solid-sim-tutorial/7_self_contact/BarrierEnergy.py:gradient}}
```

{{imp}}{imp:lec21:BarrierEnergy_hess}[障碍能量海森矩阵计算，BarrierEnergy.py]
```python
{{#include ../../solid-sim-tutorial/7_self_contact/BarrierEnergy.py:Hessian}}
```
