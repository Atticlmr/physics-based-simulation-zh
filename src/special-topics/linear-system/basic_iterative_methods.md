## 基本迭代法

对于规模大或高度稀疏的线性系统，受内存或计算资源的限制，直接求解器可能变得不可行。此时，迭代法提供了另一种选择：它产生一个近似解序列，该序列（理想情况下）收敛到真实解。本节介绍两种最基本的迭代法：Jacobi 法与 Gauss-Seidel 法。

### Jacobi 法

Jacobi 法是求解 $A x = b$ 的一种简单且完全可并行化的方法。在每次迭代中，$x$ 的每个分量仅利用上一次迭代的取值独立更新。设 $A = D + (L + U)$，其中 $D$ 为 $A$ 的对角部分，$L$ 为严格下三角部分，$U$ 为严格上三角部分。更新规则为：
$$
x^{(k+1)} = D^{-1} (b - (L + U)x^{(k)}),
{{numeq}}{eq: lec31:jacobi}
$$
或写成分量形式：
$$
x_i^{(k+1)} = \frac{1}{A_{ii}} \left( b_i - \sum_{j \neq i} A_{ij} x_j^{(k)} \right), \quad i = 1, \ldots, n.
$$
> **{{rem}}[并行性]**
> 在 Jacobi 法中，所有分量 $x_i$ 可同时更新，因而非常适合并行计算。

### Gauss-Seidel 法

Gauss-Seidel 法在 Jacobi 法的基础上改进：一旦某个分量的新值可用，就立即使用它。这意味着同一迭代内，每个新得到的 $x_i^{(k+1)}$ 会立刻用于后续更新。更新规则为：
$$
x^{(k+1)} = (D + L)^{-1} (b - U x^{(k)}),
{{numeq}}{eq: lec31:forward_gs}
$$
或写成分量形式：
$$
x_i^{(k+1)} = \frac{1}{A_{ii}} \left( b_i - \sum_{j=1}^{i-1} A_{ij} x_j^{(k+1)} - \sum_{j=i+1}^n A_{ij} x_j^{(k)} \right), \quad i = 1, \ldots, n.
$$
也可以定义**反向 Gauss-Seidel** 迭代，其中每次迭代的更新扫描从 $i = n$ 递减到 $1$：
$$
x^{(k+1)} = (D + U)^{-1} (b - L x^{(k)}),
{{numeq}}{eq: lec31:backward_gs}
$$
或写成分量形式：
$$
x_i^{(k+1)} = \frac{1}{A_{ii}} \left( b_i - \sum_{j=i+1}^{n} A_{ij} x_j^{(k+1)} - \sum_{j=1}^{i-1} A_{ij} x_j^{(k)} \right), \quad i = n, n-1, \ldots, 1.
$$
> **{{rem}}[顺序更新]**
> Gauss-Seidel 法通常比 Jacobi 法收敛更快，因为它在每次迭代中融入了最新信息。然而，其更新本质上是串行的。

### 收敛性分析

这三种方法——Jacobi、前向 Gauss-Seidel 与反向 Gauss-Seidel——都可写成如下形式：
$$
x^{(k+1)} = G x^{(k)} + c,
{{numeq}}{eq: lec31:convergence_form}
$$
其中 $G$ 为迭代矩阵。具体而言，
$$
\begin{aligned}
    G_{JA} &= I - D^{-1}A, \\
    G_{FGS} &= I - (D + L)^{-1}A, \\
    G_{BGS} &= I - (D + U)^{-1}A,
\end{aligned}
$$
分别对应 Jacobi、前向 Gauss-Seidel 与反向 Gauss-Seidel 迭代。这些方法的收敛性取决于谱半径 $\rho(G)$（即 $G$ 的特征值绝对值的最大者）。当且仅当 $\rho(G) < 1$ 时，方法收敛。

两类方法收敛的一个充分条件是 $A$ **严格对角占优**（即对所有 $i$ 有 $|A_{ii}| > \sum_{j \neq i} |A_{ij}|$）。对于 Gauss-Seidel 法，只要 $A$ 对称正定（Symmetric Positive Definite，SPD），收敛性同样有保证。

### 终止准则

实际中，迭代法在解被认为足够精确时即终止，而不会无限运行下去。常见的终止准则包括：

1. **基于残差：** 当 $\|r^{(k)}\| = \|b - Ax^{(k)}\| < \epsilon$ 或 $\|r^{(k)}\| / \|b\| < \epsilon$ 时停止，其中 $\epsilon$ 为给定的容差。
2. **解的变化：** 当 $\|x^{(k+1)} - x^{(k)}\| < \epsilon$ 或 $\|x^{(k+1)} - x^{(k)}\| / \|x^{(k)}\| < \epsilon$ 时停止，表明已收敛。
3. **最大迭代次数：** 达到预定迭代次数后停止，以防止无限循环。

基于相对残差的准则 $\|r^{(k)}\| / \|b\| < \epsilon$ 最为常用，因为它直接衡量了当前解在考虑问题尺度的情况下满足原始线性系统的程度。
