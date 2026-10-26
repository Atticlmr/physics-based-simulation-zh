## 仿射体动力学

此前我们回顾了刚体动力学，并用显式积分实现了一个简单的求解器。

当需要处理大量刚体——尤其是几何复杂、接触密集的情形——时，自然会想到用 IPC 来处理接触。然而，用位置 $\bm{x}$ 与旋转 $\bm{q}$ 来表示刚体会带来一个难题：由于四元数更新的非线性，牛顿法中的步长过滤对 $\alpha$ 而言变成了非线性的。

设刚体的状态记为 $\bm{y} = (\bm{x}, \bm{q})$，其中 $\bm{x}$ 为质心，$\bm{q}$ 为代表朝向的单位四元数。在一次牛顿迭代中，设更新方向为 $\bm{p} = (\bm{p}_{\bm{x}}, \bm{p}_{\bm{q}})$，步长为 $\alpha$，于是更新后的状态为 $\tilde{\bm{y}} = \bm{y} + \alpha \bm{p}$。初始位于 $\bm{x}_v^{(0)}$ 的顶点位置随即变换为：

$$
\tilde{\bm{x}}_v = \tilde{\bm{q}} (\bm{x}_v^{(0)} - \bm{x}^{(0)}) \tilde{\bm{q}}^{-1} + \tilde{\bm{x}}
$$

展开后可见 $\tilde{\bm{x}}_v$ 关于 $\alpha$ 是非线性的：

$$
\tilde{\bm{x}}_v = (\bm{q} + \alpha \bm{p}_{\bm{q}})(\bm{x}_v^{(0)} - \bm{x}^{(0)})(\bm{q} + \alpha \bm{p}_{\bm{q}})^{-1} + \bm{x} + \alpha \bm{p}_{\bm{x}}
$$
而由于 $\tilde{\bm{q}}$ 非线性地依赖于 $\alpha$，$\tilde{\bm{x}}_v$ 也是如此。因此，线性 CCD 可能无法保证运动过程中不发生相交。

我们也可以把刚体建模为非常硬的软体（例如质点-弹簧或超弹性体），但这样做效率低下，而且抵消了自由度降维带来的好处。

仿射体动力学（Affine Body Dynamics，ABD）{{#cite lan2022affine}}正是为解决这一问题而提出：它不要求严格的刚性，而是允许每个顶点 $\bm{x}$ 发生微小的仿射变形 $\bar{\bm{x}} \mapsto \bm{x}=\mathbf{A}\bm{x} + \bm{b}$，其中 $\bar{\bm{x}}$ 表示静止位置。刚体状态为 $\bm{y} = (\bm{b}^T, \bm{a}_1^T, \bm{a}_2^T, \bm{a}_3^T)$，其中 $\mathbf{A}=(\bm{a}_1, \bm{a}_2, \bm{a}_3)^T$，于是顶点位置 $\bm{x}$ 变为：

$$
\begin{equation}
\bm{x} = \mathbf{J} \bm{y} \nonumber
\end{equation}
$$

其中 $\mathbf{J}=(\mathbb{I}_{3\times 3}, \mathbb{I}_{3\times 3} \otimes \bar{\bm{x}}^T)$，$\otimes$ 表示克罗内克积。

这种线性关系使 $\bm{x}$ 线性地依赖于优化步长 $\alpha$，从而能够使用稳健的线性 CCD。

设 $E(\bm{x})$ 为增广后的 IPC 能量。原始 IPC 求解：
$$
\begin{equation}
\nabla_{\bm{x}} E(\bm{x}) = 0 \nonumber
\end{equation}  
$$

而 ABD 在一个约化子空间中求解：

$$
\begin{equation}
\nabla_{\bm{y}} E(\mathbf{J} \bm{y}) = 0 \nonumber
\end{equation}
$$

利用链式法则：

$$
\begin{aligned}
\nabla_{\bm{y}} E(\mathbf{J} \bm{y}) &= \mathbf{J}^T \nabla_{\bm{x}} E(\bm{x}) \\
D^2_{\bm{y}} E(\mathbf{J} \bm{y}) &= \mathbf{J}^T D^2_{\bm{x}} E(\bm{x}) \mathbf{J}

{{numeq}}{eq:lec25:newton_chain_rules}
\end{aligned}
$$
由此，我们可以通过求解线性系统 $\mathbf{J}^T D^2_{\bm{x}} E(\bm{x}) \mathbf{J} = -\mathbf{J}^T \nabla_{\bm{x}} E(\bm{x})$ 来得到牛顿优化方向。

有了这些，我们便可以用隐式欧拉积分实现一个简单二维情形下的 ABD。

在动手实现之前，不妨考虑这样一个几何视角：在二维中，仿射变换由 3 个点确定。为每个刚体选一个三角形，我们就可以通过重心坐标插值出所有顶点。三角形驱动仿真，而原始网格用于碰撞。这便得到一个约化的自由度系统，其中三角形控制运动——这本质上正是 ABD 的做法。
