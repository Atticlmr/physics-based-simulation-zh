## 点-边距离

接下来我们计算点-边距离及其导数。它们将用于求解接触力。对于节点 $\mathbf{p}$ 与边 $\mathbf{e}_0 \mathbf{e}_1$，其平方距离定义为

$$
d^{\text{PE}}_{\text{sq}}(\mathbf{p}, \mathbf{e}_0, \mathbf{e}_1) =  \min_\lambda \|\mathbf{p} - ((1 - \lambda)\mathbf{e}_0 +  \lambda \mathbf{e}_1)\|^2 \quad \text{s.t.} \quad \lambda \in [0,1],
$$

即 $\mathbf{p}$ 与 $\mathbf{e}_0 \mathbf{e}_1$ 上任意一点之间最近距离的平方。

> **{{rem}}{rem:lec21:dist_calc}[距离计算优化]**
> 这里我们使用平方无符号距离来评估接触能量。这样做避免了开平方根，因为开方会使导数的表达式变得复杂，并在计算过程中增加数值舍入误差。此外，无符号距离可以直接推广到余维接触对，例如点-点对，这在二维中仿真粒子接触时很有用。当存在大位移时，它们也不会像有符号距离那样出现锁定（locking）问题。

幸运的是，$d^{\text{PE}}_{\text{sq}}(\mathbf{p}, \mathbf{e}_0, \mathbf{e}_1)$ 关于自由度是一个分段光滑函数：
$$
d^{\text{PE}}_{\text{sq}}(\mathbf{p}, \mathbf{e}_0, \mathbf{e}_1) = 
\begin{cases}
    \|\mathbf{p} - \mathbf{e}_0\|^2  \quad \text{if} \ (\mathbf{e}_1 - \mathbf{e}_0) \cdot (\mathbf{p} - \mathbf{e}_0) < 0, \\
    \|\mathbf{p} - \mathbf{e}_1\|^2  \quad \text{if} \ (\mathbf{e}_1 - \mathbf{e}_0) \cdot (\mathbf{p} - \mathbf{e}_0) > \| \mathbf{e}_1 - \mathbf{e}_0 \|^2, \\
    \frac{1}{\|\mathbf{e}_1 - \mathbf{e}_0\|^2} \big(\det([\mathbf{p} - \mathbf{e}_0, \mathbf{e}_1 - \mathbf{e}_0])\big)^2  \quad \text{otherwise,}
\end{cases}
{{numeq}}{eq:lec21:pw_pe_dist}
$$
其中光滑表达式可通过判断该节点是否位于边的正交跨度内来确定。有了这些光滑表达式，我们就可以对它们分别求导，从而得到点-边距离函数的导数。具体实现如下：

{{imp}}{imp:lec21:PointEdgeDistance}[点-边距离计算（省略海森矩阵），PointEdgeDistance.py]
```python
{{#include ../../solid-sim-tutorial/7_self_contact/distance/PointEdgeDistance.py:PE_val_grad}}
```
可以验证，点-边距离函数在处处为 $C^1$ 连续，包括在不同分段之间的交界处。对于点-点情形，我们有：

{{imp}}{imp:lec21:PointPointDistance}[点-点距离计算，PointPointDistance.py]
```python
{{#include ../../solid-sim-tutorial/7_self_contact/distance/PointPointDistance.py}}
```

对于点-直线情形，距离的计算可实现如下，其导数可以用符号微分工具得到。

{{imp}}{imp:lec21:PointLineDistance}[点-直线距离计算（省略海森矩阵），PointLineDistance.py]
```python
{{#include ../../solid-sim-tutorial/7_self_contact/distance/PointLineDistance.py:PL_val_grad}}
```
