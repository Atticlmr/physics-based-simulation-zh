## 变量替换

### 一般滑移 DBC 与自由度消元法面临的困难

在处理一般线性等式约束（例如非轴对齐的滑移 DBC）时，直接套用自由度（Degrees of Freedom，DOF）消元法存在一定局限。当 \\( AA^T \\) 不是 \\( m \times m \\) 单位矩阵时，这一点尤为明显。根据 Karush-Kuhn-Tucker（KKT）系统（式 {{eqref: eq:lec5:BC_KKT}}），拉格朗日乘子向量 \\( \lambda \\) 可按如下方式解出：

$$
    \lambda = -(AA^T)^{-1} A H \Delta x - (AA^T)^{-1} Ag.
    {{numeq}}{eq:lec6:slipBC_lambda}
$$

把式 {{eqref: eq:lec6:slipBC_lambda}} 代回 KKT 系统，可得：

$$
    (I - A^T (AA^T)^{-1} A) H\Delta x = (I - A^T (AA^T)^{-1} A)(-g),
    {{numeq}}{eq:lec6:slipBC_lambda_solved}
$$

这样就得到一个欠约束系统。此处的关键困难在于，\\( I - A^T (AA^T)^{-1} A \\) 并不具有某种可被方便利用的特殊结构，因而无法据此导出既等价又非奇异、同时仍满足约束的系统。这使得对一般滑移 DBC 直接应用自由度消元法并不现实。

### 用奇异值分解简化约束

我们的做法是把自由度（DOF）变换为一组新的变量，使约束变得与粘着型 DBC 中的约束一样简单。为此，我们对约束雅可比矩阵 \\( A \\) 作奇异值分解（Singular Value Decomposition，SVD）。\\( A \\) 的 SVD 写为：
$$
    A = U S V^T.
$$
其中 \\( U \\) 是 \\( m \times m \\) 正交矩阵，\\( V \\) 是 \\( dn \times dn \\) 正交矩阵，\\( S \\) 是 \\( m \times dn \\) 对角矩阵。

通过定义 \\( y = V^T \Delta x \\)，我们可以把 Karush-Kuhn-Tucker（KKT）系统（式 {{eqref: eq:lec5:BC_KKT}}）改写为一种新的形式：

$$
    \begin{bmatrix}V^T H V & S^T\\ S & 0\end{bmatrix} \begin{bmatrix}y\\ \lambda' \end{bmatrix} = \begin{bmatrix} -V^T g \\ 0\end{bmatrix}.
    {{numeq}}{eq:lec6:BC_KKT_SVD}
$$

在这个变换后的系统中，\\( \lambda' = U^T \lambda \\)。值得注意的是，对角矩阵 \\( S \\) 出现在非对角块中，使得可以直接应用自由度消元法。一旦解出 \\( y \\)，原始变量 \\( \Delta x \\) 便可通过矩阵-向量乘积 \\( \Delta x = V y \\) 轻松恢复。

> **{{rem}}{rem:lec6:SVD_limitations}[使用 SVD 进行自由度消元的局限]**
上面的推导借助奇异值分解（SVD）说明了这一思路；但 SVD 在实际使用中仍有局限，矩阵规模一大尤其明显。主要有两点顾虑：
> 1. **大矩阵难以处理：** 对规模很大的矩阵做 SVD 在计算上颇具挑战，且往往不切实际。
> 2. **对计算效率的影响：** 增量势能的海森矩阵 \\( H \\) 通常是稀疏的，因而在仿真中的线性求解里可以高效地分解。然而，若 SVD 得到的 \\( V \\) 是稠密的，则 \\( V^T H V \\) 也会是稠密的。这不仅会拖慢计算，还会显著增加线性求解的开销。
>
> 需要强调的是，新的基集（\\( V \\) 的列向量）只需线性无关，并不一定要求正交归一。认识到这一点，我们就有可能找到稀疏的基集。在处理一般线性等式约束时，这样的基集能够保持计算效率。该做法的一个实际示例参见 {{#cite chen2022unified}}。
