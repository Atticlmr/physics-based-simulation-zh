## 简化模型与可逆性

> **{{def}}{def:lec13:corotated_linear_elasticity}[共旋线性弹性]**
> 为使线性弹性在保持简洁性的同时具备旋转感知能力，我们可以引入一个基准旋转 $\mathbf{R}^n$，并构造能量密度函数
$$
    \Psi_\text{LC}(\mathbf{F}) = \Psi_\text{lin}((\mathbf{R}^n)^T \mathbf{F}),
$$
> 用它惩罚 $\mathbf{F}$ 与这个固定的 $\mathbf{R}^n$ 之间的偏差。这称为共旋线性弹性。

$\Psi_\text{LC}(\mathbf{F})$ 仍是关于 $\mathbf{F}$ 的二次能量，对动态仿真非常有用。在每个时间步 $n+1$ 的优化开始时，我们计算 $\mathbf{F}^n$ 的最接近旋转 $\mathbf{R}^n$：
$$
    \mathbf{R}^n = \text{arg}\min_{\mathbf{R}} \|\mathbf{F}^n - \mathbf{R} \|_\text{F}^2 \quad \text{s.t.} \quad \mathbf{R}^T = \mathbf{R}^{-1} \quad \text{and} \quad \det(\mathbf{R}) = 1.
    {{numeq}}{eq:lec13:min_rotation}
$$
如前所述，该解由对 $\mathbf{F}^n$ 的极分解给出；借助极分解 SVD $\mathbf{F}^n=\mathbf{U}^n \mathbf{\Sigma}^n (\mathbf{V}^n)^T$，可得 $\mathbf{R}^n = \mathbf{U}^n (\mathbf{V}^n)^T$。然而，共旋线性弹性仍然不是旋转不变的，因为 $\mathbf{R}^n$ 在优化过程中不随 $\mathbf{F}$ 变化。因此，它不适用于大变形。

对于旋转不变的弹性模型，计算机图形学领域的从业者出于视觉计算的需要对其进行了简化。例如，在能量密度函数中只保留 $\mu$ 项而忽略 $\lambda$ 项，以获得更高的计算效率：
$$
    \Psi_\text{R}(\mathbf{F}) = \frac{\mu}{4} \| \mathbf{F}^T \mathbf{F} - \mathbf{I} \|^2_\text{F}, \quad \text{or} \quad \Psi_\text{ARAP}(\mathbf{F}) = \mu \sum_i^d (\sigma_i - 1)^2, \quad \text{etc}.
    {{numeq}}{eq:lec13:simplified_models}
$$
这里 $\Psi_\text{ARAP}(\mathbf{F})$ 称为<strong>尽可能刚性（As-Rigid-As-Possible，ARAP）</strong>能量，广泛用于形状建模、布料仿真与曲面参数化等。$\Psi_\text{R}(\mathbf{F})$ 虽然相对 ARAP 而言是 $\mathbf{F}$ 的更高阶多项式，但其计算无需对 $\mathbf{F}$ 执行昂贵的 SVD。

本讲中我们考察过的所有应变能密度函数，除新胡克模型外，其余都定义在整个定义域 $\mathbb{R}^{d\times d}$ 上。新胡克能量密度函数定义在 $\{\mathbf{F} \ | \ \mathbf{F} \in \mathbb{R}^{d\times d}, \ \det(\mathbf{F})>0 \}$ 上。正如 IPC 中用于防止相互穿透的障碍能量，$\Psi_\text{NH}(\mathbf{F})$ 也是一种障碍能量，当 $\det(\mathbf{F})$ 趋近于 $0$ 时它趋于无穷大，从而提供任意大的弹性力以防止**翻转**（$\det(\mathbf{F}) \leq 0$）。

允许 $\det(\mathbf{F}) \leq 0$ 的应变能密度函数也称为**可逆弹性模型**。它们易于处理（无需线搜索过滤），但不能保证无翻转。设计一种既能提供相当大的抗翻转能力又可逆的弹性能量，在计算机图形学研究中受到了广泛关注 {{#cite stomakhin2012energetically}} {{#cite smith2018stable}}。
