## 质量矩阵

回顾质量矩阵的计算方式
$$
M_{ab} = \sum_{e\in\mathcal{T}} \int_{\Omega^0_e} R(\mathbf{X},0) N_a(\mathbf{X}) N_b(\mathbf{X}) d\mathbf{X},
$$
其中 $\Omega^0_e$ 表示四面体 $e$ 的材料空间。把积分变量从 $\mathbf{X}$ 换为 $(\beta, \gamma, \tau)$，得到
$$
\begin{aligned}
    & \int_{\Omega^0_e} R(\mathbf{X},0) N_a(\mathbf{X}) N_b(\mathbf{X}) d\mathbf{X} \\
    = & \int_0^1 \int_0^{1-\tau} \int_0^{1-\beta-\tau} R(\beta, \gamma, \tau, 0) N_a(\beta, \gamma, \tau) N_b(\beta, \gamma, \tau) \left| \det\left(\frac{\partial \mathbf{X}}{\partial (\beta, \gamma, \tau)}\right) \right| d\gamma d\beta d\tau.
\end{aligned}
$$

对于顶点为 $\mathbf{X}_1$、$\mathbf{X}_2$、$\mathbf{X}_3$ 与 $\mathbf{X}_4$ 的单元 $e$，
$$
\left| \det\left(\frac{\partial \mathbf{X}}{\partial (\beta, \gamma, \tau)}\right) \right| = \left| \det([\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1, \mathbf{X}_4 - \mathbf{X}_1]) \right| = 6 V_e,
$$
其中 $V_e$ 是四面体 $e$ 的体积。

这里我们将省略一致质量矩阵中各元素的具体推导。假设密度 $R$ 均匀，对于集中质量矩阵，
$$
M_{aa}^\text{lump} = \sum_{e\in\mathcal{T}(a)} \frac{1}{4} R V_e \quad \text{and} \quad M_{ab}^\text{lump} = 0 \quad (a \neq b),
$$
其中 $\mathcal{T}(a)$ 表示与节点 $a$ 相邻的四面体集合。换言之，每个四面体的质量被均匀分配到它的 4 个节点上，这与二维情形在直觉上完全类似。
