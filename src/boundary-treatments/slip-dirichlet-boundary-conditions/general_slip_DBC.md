## 一般滑移 DBC

幸运的是，对于滑移 DBC 这类按节点解耦的约束，SVD 得到的 $U$ 与 $V$ 直接就是块对角的，并可以用高效的程序化方式构造。
节点 $i$ 上的三维平面滑移 DBC 可表示为
$$
    \mathbf{n}_i^T (\mathbf{x}_i - \mathbf{x}_i') = 0,
$$
其中 $\mathbf{n}_i$ 是节点 $i$ 所滑移平面的法向，$\mathbf{x}_i'$ 是该平面上的任意一点。 
如式 {{eqref: eq:lec5:BC_dx}} 附近所讨论的，若在时间步开始时节点 $i$ 已位于该平面上，则约束简化为
$$
    \mathbf{n}_i^T \Delta \mathbf{x}_i = 0.
$$
进而对行向量 $\mathbf{n}_i^T$ 作 SVD，得到
$$
    \mathbf{n}_i^T = \mathbf{U}_i \mathbf{S}_i \mathbf{V}_i^T = 1 \begin{bmatrix} 1 & 0 & 0\end{bmatrix} \begin{bmatrix} \mathbf{n}_i^T \\ \textbf{m}_i^T \\ \mathbf{l}_i^T \end{bmatrix},
    {{numeq}}{eq:lec6:BC_normal_SVD}
$$
其中单位向量 $\mathbf{n}_i$、$\textbf{m}_i$ 与 $\mathbf{l}_i$ 共同构成三维空间中的一组正交归一基。 

于是可以看出，在全局层面上，$U$ 就是一个 $m\times m$ 单位矩阵；$S$ 是一个 $m\times dn$ 矩阵，其每一行恰好在对应于该滑移 BC 节点第一个自由度的那一列上含有一个取值为 1 的元素；$V$ 是一个 $dn \times dn$ 块对角矩阵，仅在与各 BC 节点对应的块上取 $d\times d$ 正交归一块，其余位置为 $d\times d$ 单位矩阵。

要从 $\mathbf{n}_i$ 计算 $\textbf{m}_i$ 与 $\mathbf{l}_i$，我们首先注意到可能的解有无穷多个。 
因此，我们可以先直接构造 $\textbf{m}_i = \mathbf{n}_i \times \begin{bmatrix}1 & 0 & 0\end{bmatrix}^T$；若 $\mathbf{n}_i$ 与 $\begin{bmatrix}1 & 0 & 0\end{bmatrix}^T$ 近乎共线，则改为 $\textbf{m}_i = \mathbf{n}_i \times \begin{bmatrix}0 & 1 & 0\end{bmatrix}^T$；然后再构造 $\mathbf{l}_i = \mathbf{n}_i \times \textbf{m}_i$。
要得到 $V^T (-g)$，只需把每个 $\mathbf{V}_i^T = \begin{bmatrix} \mathbf{n}_i^T \\ \textbf{m}_i^T \\ \mathbf{l}_i^T \end{bmatrix}$ 左乘到 $-\mathbf{g}_i$ 上。 
至于 $V^T H V$，先把每个 $\mathbf{V}_i^T$ 左乘到 $H$ 的第 $i$ 个块行中的每个块上，得到 $V^T H$；随后针对 $V^T H$ 的第 $i$ 个块列，把 $\mathbf{V}_i = \begin{bmatrix} \mathbf{n}_i & \textbf{m}_i & \mathbf{l}_i \end{bmatrix}$ 右乘到每个块上。 
最后，在修改后的系统（式 {{eqref: eq:lec6:BC_KKT_SVD}}）上应用自由度消元法解出 $y$，即求解
$$
    (I - S^T S) V^T H V y = (I - S^T S)(- V^T g),
    {{numeq}}{eq:lec6:BC_normal_SVD_lambda_solved}
$$
之后，$\Delta x$ 可通过 $\Delta x = V y$ 以类似的按块（按节点）运算得到。

> {{exp}}{exp:lec6:general_slip_DBC_example}[一般滑移 DBC]
对于滑移 DBC 示例（{{ref: exp:lec5:slip}}）中提到的同一个二维两节点系统，若要把第一个节点 $(x_{11}, x_{12})$ 约束在 $3x + 4y = 2$ 这条直线上，则该滑移 DBC 可表示为
$$
    \begin{bmatrix}
      3 & 4 & 0 & 0
    \end{bmatrix}  
    \begin{bmatrix}
      x_{11}\\
      x_{12}\\
      x_{21}\\
      x_{22}\\
    \end{bmatrix}
    = 2
$$
并可构造
$$
    U =1,\
    S = \begin{bmatrix} 
    1 & 0 & 0 & 0
    \end{bmatrix},\
    V^T = \begin{bmatrix} 
    0.6 & 0.8 & & \\ 
    -0.8 & 0.6 & & \\
    & & 1 & \\ 
    & & & 1 \\
    \end{bmatrix}
$$
以完成换基。
接着，在某个该滑移 DBC 已满足的时间步中，假设有
$$
    H = \begin{bmatrix}
      4 & -1 & -1 & -1 \\
      -1 & 4 & -1 & -1 \\
      -1 & -1 & 4 & -1 \\
      -1 & -1 & -1 & 4
    \end{bmatrix}, \quad \text{and} \quad
    g = \begin{bmatrix}
      1 \\
      2 \\
      3 \\
      4
    \end{bmatrix},
$$
我们可以算出
$$
    V^T H V = \begin{bmatrix}
      3.04 & 0.28 & -1.4 & -1.4 \\
      0.28 & 4.96 & 0.2 & 0.2 \\
      -1.4 & 0.2 & 4 & -1 \\
      -1.4 & 0.2 & -1 & 4
    \end{bmatrix}, \quad \text{and} \quad
    V^T g = \begin{bmatrix}
      2.2 \\
      0.4 \\
      3 \\
      4
    \end{bmatrix},
$$
并求解系统
$$
    \begin{bmatrix}
      1 & 0 & 0 & 0 \\
      0 & 4.96 & 0.2 & 0.2 \\
      0 & 0.2 & 4 & -1 \\
      0 & 0.2 & -1 & 4
    \end{bmatrix}  
    \begin{bmatrix}
      y_{11}\\
      y_{12}\\
      y_{21}\\
      y_{22}\\
    \end{bmatrix}
    = 
    \begin{bmatrix}
      0 \\
      -0.4 \\
      -3 \\
      -4
    \end{bmatrix}
$$
以得到 $y$。随后由 $\Delta x = Vy$ 可得到搜索方向，使得 $3 \Delta x_{11} + 4 \Delta x_{12} = 0$，因此无论步长多大，第一个节点都将停留在 $3x + 4y = 2$ 这条直线上。
