## 质量矩阵与集中化

回忆[弱形式的离散化](../../governing-equations/discretization-of-weak-forms/disc_weak_form.md)一节：

$$
M_{ab} = \int_{\Omega^0} R(\mathbf{X},0) N_a(\mathbf{X}) N_b(\mathbf{X}) d\mathbf{X}.
{{numeq}}{eq:lec19:mass_matrix}
$$

当固体域被离散为三角形集合 $\mathcal{T}$ 后，我们有：

$$
M_{ab} = \sum_{e \in \mathcal{T}} \int_{\Omega^0_e} R(\mathbf{X},0) N_a(\mathbf{X}) N_b(\mathbf{X}) d\mathbf{X},
{{numeq}}{eq:lec19:mass_matrix_sum_tri}
$$

其中 $\Omega^0_e$ 表示三角形 $e$ 的材料空间。注意，对于线性三角形单元，由于 $N_i$ 只在节点 $i$ 的关联三角形上非零，这里只需考虑同时以 $a$ 和 $b$ 为顶点的那些三角形。

我们把积分变量从 $\mathbf{X}$ 换为 $(\beta, \gamma)$，得到：

$$
\begin{aligned}
& \int_{\Omega^0_e} R(\mathbf{X},0) N_a(\mathbf{X}) N_b(\mathbf{X}) d\mathbf{X} \\
=& \int_0^1 \int_0^{1-\beta} R(\beta, \gamma, 0) N_a(\beta, \gamma) N_b(\beta, \gamma) \left|\det\left(\frac{\partial \mathbf{X}}{\partial (\beta, \gamma)}\right)\right| d\gamma d\beta.
\end{aligned}
{{numeq}}{eq:lec19:mass_matrix_per_tri_param}
$$

为简便起见，把该三角形 $e$ 的顶点记为 $\mathbf{X}_1$、$\mathbf{X}_2$ 与 $\mathbf{X}_3$，于是有：

$$
\left|\det\left(\frac{\partial \mathbf{X}}{\partial (\beta, \gamma)}\right)\right| = |\det([\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1])| = 2 A_e,
$$

其中 $A_e$ 是三角形 $e$ 的面积。这里 $N_a$ 与 $N_b$ 根据顶点索引 $a$、$b$ 取 $1-\beta-\gamma$、$\beta$ 或 $\gamma$。例如，若 $a$ 与 $b$ 分别对应三角形 $e$ 的第 2、第 3 个顶点，则 $N_a = \beta$，$N_b = \gamma$。假设密度均匀，可得：

$$
\begin{aligned}
    \int_{\Omega^0_e} R(\mathbf{X},0) N_a(\mathbf{X}) N_b(\mathbf{X}) d\mathbf{X}
    = & 2 R A_e \int_0^1 \int_0^{1-\beta} \beta \gamma d\gamma d\beta \\
    = & 2 R A_e \int_0^1 \left. \frac{1}{2} \beta \gamma^2 \right|_{\gamma=0}^{\gamma=1-\beta} d\beta \\
    =& R A_e \int_0^1 \beta (1-\beta)^2 d\beta \\
    = & R A_e \left. \left(\frac{\beta^2}{2} - \frac{2\beta^3}{3} + \frac{\beta^4}{4}\right) \right|_{\beta=0}^{\beta=1} = \frac{1}{12} R A_e.
\end{aligned}
{{numeq}}{eq:lec19:mass_matrix_per_tri_betagamma}
$$

采用质量集中时，$M^{\text{lump}}_{ab} = \delta_{ab}\sum_c M_{ac}$，即：

$$
M_{aa}^\text{lump} = \sum_{e \in \mathcal{T}} \sum_{b \in \mathcal{V}} \int_{\Omega^0_e}  R(\mathbf{X},0) N_a(\mathbf{X}) N_b(\mathbf{X}) d\mathbf{X},
{{numeq}}{eq:lec19:lumped_mass_matrix_sum_tri}
$$

其中 $\mathcal{V}$ 包含网格的所有节点，且 $M^\text{lump}$ 的所有非对角元素均为 $0$。同样，由于 $N$ 的局部性，对每个三角形单元而言，$b$ 只需遍历该三角形的三个顶点：

$$
\begin{aligned}
    M_{aa}^\text{lump} & = \sum_{e \in \mathcal{T}(a)} 2 R A_e \left( \int_0^1 \int_0^{1-\beta} \beta (1- \beta - \gamma) d\gamma d\beta + \int_0^1 \int_0^{1-\beta} \beta^2 d\gamma d\beta\right. \\ &+ \left.\int_0^1 \int_0^{1-\beta} \beta \gamma d\gamma d\beta \right) \\
    & = \sum_{e \in \mathcal{T}(a)} 2 R A_e \int_0^1 \beta d\gamma d\beta = \sum_{e \in \mathcal{T}(a)} 2 R A_e \int_0^1 \beta \gamma |_{\gamma=0}^{\gamma =1-\beta} d\beta \\
    & = \sum_{e \in \mathcal{T}(a)} 2 R A_e \int_0^1 \beta (1-\beta) d\beta = \sum_{e \in \mathcal{T}(a)} 2 R A_e \left. \left(\frac{\beta^2}{2} - \frac{\beta^3}{3} \right) \right|_{\beta=0}^{\beta=1} \\ 
    &= \sum_{e \in \mathcal{T}(a)} \frac{1}{3} R A_e,
\end{aligned}
{{numeq}}{eq:lec19:lumped_mass_matrix_sum_tri_param}
$$

其中 $\mathcal{T}(a)$ 表示与节点 $a$ 关联的三角形集合。这一结果也解释了为什么在[无翻转弹性](../../hyperelasticity/case-study-inversion-free-elasticity/inv_free_elasticity.md)一节中计算所有节点的质量时，我们遍历所有三角形，算出三角形质量 $RA_e$ 并把它平均分配到三个顶点上。质量矩阵算出之后，动量变化项与外部体力项（包括它们的能量形式）都容易处理了。
