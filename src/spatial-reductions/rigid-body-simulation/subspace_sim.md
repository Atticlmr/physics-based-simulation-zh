## 子空间仿真

本小节中，我们采用子空间优化方法，推导出刚体动力学方程的约束形式。该形式将刚体动力学与增量势能接触（Incremental Potential Contact，IPC）方法联系起来，后续小节将对此作进一步阐述。

回顾一下，在增量势能接触（IPC）中，仿真问题被表述为如下优化问题：
$$
\begin{equation}
\begin{aligned}
    \mathbf{x}^{n+1} &= \argmin_{\mathbf{x}} E(\mathbf{x})  \nonumber \\ 
    \text{where} \ E(\mathbf{x}) &= \frac{1}{2} \Vert \mathbf{x} - \tilde{\mathbf{x}}^n\Vert + \Delta t^2P(\mathbf{x}). 
\end{aligned}
\end{equation}
$$

此处，$E(\mathbf{x})$ 为增量势能，$\mathbf{x}$ 表示待求解的粒子位置。


设 $\bm{x}$ 为刚体上的粒子位置，它由该刚体的旋转矩阵 $\bm{Q}$ 与平移 $\bm{q}$ 参数化。刚体运动学施加约束 $\bm{x} = \bm{Q} \bar{\bm{x}} + \bm{q}$，其中 $\bar{\bm{x}}$ 是该粒子在物体局部坐标系中的位置。写成堆叠形式，即：

$$
\mathbf{x} = \bar{\mathbf{x}} \mathbf{Q} + \bar{\mathbf{S}} \mathbf{q},
$$

其中 $\bar{\mathbf{x}}$ 与 $\bar{\mathbf{S}}$ 是不依赖于 $\mathbf{Q}$ 和 $\mathbf{q}$ 的常数矩阵，因为它们只取决于物体坐标系中的局部粒子位置。

代入增量势能接触（IPC）形式，我们得到如下约束优化问题：

$$
\begin{equation}
\begin{aligned}
    \mathbf{Q}^{n+1}, \mathbf{q}^{n+1} &= \argmin_{\mathbf{Q}, \mathbf{q}} E(\mathbf{Q}, \mathbf{q}) \quad \text{s.t.} \quad \mathbf{f}(\mathbf{Q}) = \mathbf{0},  \nonumber\\ 
    \text{where} \quad E(\mathbf{Q}, \mathbf{q}) &= \frac{1}{2} \left\| \bar{\mathbf{x}} \mathbf{Q} + \bar{\mathbf{S}} \mathbf{q} - \tilde{\mathbf{x}}^n \right\|^2 + \Delta t^2 P(\bar{\mathbf{x}} \mathbf{Q} + \bar{\mathbf{S}} \mathbf{q}),
\end{aligned}
\end{equation}
$$

其中约束 $\mathbf{f}(\mathbf{Q}) = \bm{0}$ 强制每个刚体 $i$ 的旋转矩阵 $\bm{Q}_i$ 满足刚性条件，即 $\bm{Q}_{i}^T\bm{Q}_{i} - \mathbb{I}_3 = \bm{0}$。

应用拉格朗日乘子法，我们引入拉格朗日函数：

$$
G = E(\mathbf{Q}, \mathbf{q}) + \bm{\lambda}^\top \mathbf{f}(\mathbf{Q}),
$$

并推导出驻值条件：
$$
\begin{equation}
\begin{aligned}
\nabla_{\mathbf{q}} G &= 0,  \nonumber\\ 
\nabla_{\mathbf{Q}} G &= 0, \\ 
\nabla_{\bm{\lambda}} G &= 0.
\end{aligned}
\end{equation}
$$

由此得到如下受约束的刚体动力学方程：

$$
\begin{equation}
\begin{aligned}
\bar{\mathbf{x}}^\top \mathbf{M} (\bar{\mathbf{x}} \mathbf{Q} + \bar{\mathbf{S}} \mathbf{q}) + \Delta t^2 \bar{\mathbf{x}}^\top \nabla P(\bar{\mathbf{x}} \mathbf{Q} + \bar{\mathbf{S}} \mathbf{q}) + (\nabla \mathbf{f}(\mathbf{Q}))^\top \bm{\lambda} &= \mathbf{0},  \nonumber\\
\bar{\mathbf{S}}^\top \mathbf{M} (\bar{\mathbf{x}} \mathbf{Q} + \bar{\mathbf{S}} \mathbf{q}) + \Delta t^2 \bar{\mathbf{S}}^\top \nabla P(\bar{\mathbf{x}} \mathbf{Q} + \bar{\mathbf{S}} \mathbf{q}) &= \mathbf{0}, \\
\mathbf{f}(\mathbf{Q}) &= \mathbf{0}.
\end{aligned}
\end{equation}
{{numeq}}{eq:lec25:rigid_body_constrained_formulation}
$$

这些方程定义了刚体在子空间约束动力学下的运动，同时满足能量一致性与刚性约束。
