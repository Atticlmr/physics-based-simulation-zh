## 分段线性位移场

对于固体域中顶点为 $\mathbf{X}_1$、$\mathbf{X}_2$ 与 $\mathbf{X}_3$ 的三角形单元，我们可以利用空间离散化（见式 {{eqref: eq:lec17:spatial_discretization}}）来近似该单元内任意一点 $\mathbf{X}$ 的世界空间坐标：

$$
\hat{\mathbf{x}}(\mathbf{X}) = \mathbf{x}(\mathbf{X}_1) N_1(\mathbf{X}) + \mathbf{x}(\mathbf{X}_2) N_2(\mathbf{X}) + \mathbf{x}(\mathbf{X}_3) N_3(\mathbf{X}),
{{numeq}}{eq:lec19:2d_interpolation}
$$

该式表示一种二维插值，是实验 {{ref: exp:lec17:1d_interpolation}} 的推广。这里我们假设：单元内任意一点的世界空间坐标都可以仅由该单元各顶点的坐标插值得到。

线性有限元在式 {{eqref: eq:lec19:2d_interpolation}} 中采用线性的形函数 $N_i$，从而在整个区域上得到分段线性的（逐三角形线性的）位移场 $\mathbf{u} = \hat{\mathbf{x}}(\mathbf{X}) - \mathbf{X}$。在给出 $N$ 关于 $\mathbf{X}$ 的精确表达式之前，我们先引入另一个参数空间来简化推导。

令 $\beta, \gamma \in [0,1]$ 且 $\beta + \gamma \leq 1$，则可用它们把单元 $\mathbf{X}_1 \mathbf{X}_2 \mathbf{X}_3$ 内任意一点 $\mathbf{X}$ 的材料空间坐标表示为：

$$
\begin{aligned}
    \mathbf{X}(\beta, \gamma) & = \mathbf{X}_1 + \beta (\mathbf{X}_2 - \mathbf{X}_1) + \gamma (\mathbf{X}_3 - \mathbf{X}_1) \\
    & = (1 - \beta - \gamma) \mathbf{X}_1 + \beta \mathbf{X}_2 + \gamma \mathbf{X}_3.
\end{aligned}
$$

这里 $\mathbf{X}$ 是 $(\beta, \gamma)$ 的线性函数。采用线性形函数时，近似 $\hat{\mathbf{x}}$ 是 $\mathbf{X}$ 的线性函数。

回忆一下，为满足插值要求，我们必须满足条件 $\hat{\mathbf{x}}(\mathbf{X}_i) = \mathbf{x}(\mathbf{X}_i)$。把这些条件放在一起，可以得到唯一解：

$$
\begin{aligned}
    \mathbf{x}(\beta, \gamma) \approx \hat{\mathbf{x}}(\beta, \gamma) & = \mathbf{x}_1 + \beta (\mathbf{x}_2 - \mathbf{x}_1) + \gamma (\mathbf{x}_3 - \mathbf{x}_1) \\
    & = (1 - \beta - \gamma) \mathbf{x}_1 + \beta \mathbf{x}_2 + \gamma \mathbf{x}_3,
\end{aligned}
$$

其中我们把 $\mathbf{x}(\mathbf{X}_i)$ 记作 $\mathbf{x}_i$。这表明：

$$
N_1(\beta, \gamma) = 1 - \beta - \gamma, \quad N_2(\beta, \gamma) = \beta, \quad N_3(\beta, \gamma) = \gamma.
$$

有趣的是，有了 $\mathbf{X}(\beta, \gamma)$、$\mathbf{x}(\beta, \gamma)$ 与 $N(\beta, \gamma)$ 的表达式之后，在后续推导中计算式 {{eqref: eq:lec17:BE}} 的各项时，我们并不一定需要 $\hat{\mathbf{x}}(\mathbf{X})$ 和 $N(\mathbf{X})$ 的精确表达式。

> **{{rem}}{rem:lec19:fem_partition}[单位分解]** 有限元的形函数在每个单元内处处满足**单位分解**（partition of unity）：
$$
N_1(\beta, \gamma) + N_2(\beta, \gamma) + N_3(\beta, \gamma) = 1 \quad \forall \ \beta, \gamma \in [0, 1] \ \text{and} \ \beta + \gamma \leq 1.
$$
> 与基于网格或基于粒子的表示相比，有限元的一个优点是它能提供精确的边界分辨率。有限元网格的边界节点可以恰好落在连续域的边界上。单元在域内部生成，把边界节点连接起来构成离散边界，而随着分辨率提高，该离散边界会收敛到连续域的边界。  
> 尽管基于粒子的方法也可以在域的边界上采样粒子，但其球形形函数会延伸到域外，从而破坏单位分解。这会在边界外形成一层“软”的材料层，使边界受力的计算不准确。相比之下，有限元的形函数只在各自单元内非零，而单元内处处满足单位分解。

