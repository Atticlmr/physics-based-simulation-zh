## 质点-弹簧势能

在本案例研究中，我们只关注把质点-弹簧弹性势能纳入系统。质点-弹簧弹性的概念类似于把网格的每条边都视为一根弹簧。这一做法受胡克定律启发，使我们能够将边 $e$ 上的势能写成如下形式：

$$
    P_e(x) = l^2 \frac{1}{2} k \left(\frac{\| \mathbf{x}_1 - \mathbf{x}_2 \|^2}{l^2} - 1\right)^2,
    {{numeq}}{eq:lec4:mass_sprint_E}
$$

这里，$\mathbf{x}_1$ 与 $\mathbf{x}_2$ 表示边两端点的当前位置。变量 $l$ 表示边的原始长度，$k$ 是控制弹簧刚度的参数。值得注意的是，当两端点之间的距离 $\| \mathbf{x}_1 - \mathbf{x}_2 \|$ 等于原始长度 $l$ 时，势能 $P_e(x)$ 取得全局最小值 $0$，表明没有力作用。

该形式的一个重要特点是开头引入了 $l^2$。这相当于在整个固体上对弹簧能量进行积分，并选取边作为求积点。这一积分有助于在网格分辨率发生变化时，仍保持刚度行为与参数 $k$ 之间的一致关系。

与标准弹簧能量形式的另一处不同是，我们避免了开平方运算。我们直接使用 $\| \mathbf{x}_1 - \mathbf{x}_2 \|^2$，使我们的模型具有多项式性质。这一简化使梯度与海森矩阵的表达式更为简洁：

$$
    \frac{\partial P_e}{\partial \mathbf{x}_1} (x) = -\frac{\partial P_e}{\partial \mathbf{x}_2} (x) = 2 k \left(\frac{\| \mathbf{x}_1 - \mathbf{x}_2 \|^2}{l^2} - 1\right) (\mathbf{x}_1 - \mathbf{x}_2),
$$

$$
\begin{aligned}
    \frac{\partial^2 P_e}{\partial \mathbf{x}_1^2} (x) & = \frac{\partial^2 P_e}{\partial \mathbf{x}_2^2} (x) = -\frac{\partial^2 P_e}{\partial \mathbf{x}_1\mathbf{x}_2} (x) = -\frac{\partial^2 P_e}{\partial \mathbf{x}_2\mathbf{x}_1} (x) \\ & = \frac{4 k}{l^2} (\mathbf{x}_1 - \mathbf{x}_2) (\mathbf{x}_1 - \mathbf{x}_2)^T + 2 k \left(\frac{\| \mathbf{x}_1 - \mathbf{x}_2 \|^2}{l^2} - 1\right) \mathbf{I} \\
    & = \frac{2k}{l^2} \left(2(\mathbf{x}_1 - \mathbf{x}_2) (\mathbf{x}_1 - \mathbf{x}_2)^T + (\| \mathbf{x}_1 - \mathbf{x}_2 \|^2 - l^2)\mathbf{I}\right).
\end{aligned}
$$

系统的总势能记为 $P(x)$，可通过将所有边上的势能求和得到。这利用公式 {{eqref: eq:lec4:mass_sprint_E}} 计算。因此，总势能表示为：
$$
    P(x) = \sum_e P_e(x)
$$
其中求和遍历网格中的所有边。

{{imp}}{imp:lec4:mass_spring_energy}[MassSpringEnergy.py]
```python
{{#include ../../solid-sim-tutorial/1_mass_spring/MassSpringEnergy.py}}
```

在处理质点-弹簧能量的海森矩阵时，需要注意的是它并非对称正定（Symmetric Positive Definite，SPD）的。为此，我们采用了一种特定的修正：将每条边对应的局部海森矩阵的负特征值中和掉。这一操作在把这些局部海森矩阵组装进全局矩阵之前完成。该过程将负特征值置为零，从而使所得的全局海森矩阵更接近所需的对称正定（SPD）性质。这一修正对牛顿法至关重要。

{{imp}}{imp:lec4:utils}[半正定投影]
```python
{{#include ../../solid-sim-tutorial/1_mass_spring/utils.py}}
```
