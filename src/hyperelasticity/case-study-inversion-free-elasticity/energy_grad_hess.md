## 计算能量、梯度与海森矩阵

我们首先按照[应变能](../strain-energy/strain_energy.md)与[应力及其导数](../stress-and-its-derivatives/stress_and_derivatives.md)两节，实现 $\Psi(\mathbf{F})$、$\mathbf{P} = \frac{\partial \Psi}{\partial \mathbf{F}}$ 以及经 SPD 投影的 $\frac{\partial \mathbf{P}}{\partial \mathbf{F}}$ 的计算：

{{imp}}{imp:lec15:NeoHookeanEnergy_wrt_F}[关于 $\mathbf{F}$ 的能量导数，NeoHookeanEnergy.py]
```python
{{#include ../../solid-sim-tutorial/6_inv_free/NeoHookeanEnergy.py:helper_func}}
```

接下来，我们实现 $\mathbf{F}(x)$ 的计算，以及与 $\frac{\partial \mathbf{F}}{\partial x}$ 的张量积，以便基于链式法则计算弹性能量的梯度与海森矩阵：

{{imp}}{imp:lec15:NeoHookeanEnergy_F_x}[关于 $x$ 的能量导数，NeoHookeanEnergy.py]
```python
{{#include ../../solid-sim-tutorial/6_inv_free/NeoHookeanEnergy.py:stress_deriv}}
```

最后，整个网格上的 Neo-Hookean 能量值、梯度与海森矩阵可按如下方式计算：

{{imp}}{imp:lec15:NeoHookeanEnergy_wrt_x}[能量值、梯度与海森矩阵，NeoHookeanEnergy.py]
```python
{{#include ../../solid-sim-tutorial/6_inv_free/NeoHookeanEnergy.py:val_grad_hess}}
```
