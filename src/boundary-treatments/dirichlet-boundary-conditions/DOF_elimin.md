## 自由度消元法

以最简单的粘着狄利克雷边界条件为例，其约束雅可比矩阵 \\( A \\) 充当选择矩阵。因此，\\( AA^T \\) 构成一个 \\( m \times m \\) 单位矩阵，而 \\( A^T A \\) 成为 \\( dn \times dn \\) 对角矩阵。在该矩阵中，对应于 BC 节点的元素为 1，其余元素均为 0。

当我们用 \\( A \\) 左乘公式 {{eqref: eq:lec5:BC_KKT}} 的第一个分块行时，所得方程为：

$$
    \begin{bmatrix}A H & A A^T\\ A & \end{bmatrix} \begin{bmatrix}\Delta x\\ \lambda \end{bmatrix} = \begin{bmatrix} -A g \\ 0\end{bmatrix}.
$$

这一处理使我们能够直接解出 \\( \lambda \\)：

$$
    \lambda = -A H \Delta x - Ag.
    {{numeq}}{eq:lec5:BC_lambda}
$$

将公式 {{eqref: eq:lec5:BC_lambda}} 代回公式 {{eqref: eq:lec5:BC_KKT}} 的第一个分块行，可导出如下方程：

$$
    (I - A^T A) H\Delta x = (I - A^T A)(-g).
    {{numeq}}{eq:lec5:BC_lambda_solved}
$$

这里，左乘 \\((I - A^T A)\\) 实际上把对应于 BC 节点的那些行置零。因此，公式 {{eqref: eq:lec5:BC_lambda_solved}} 表示一个欠约束系统。然而，公式 {{eqref: eq:lec5:BC_KKT}} 的第二个分块行实际上给出了 BC 节点处的 \\(\Delta x\\) 取值（因此它们并非真正的未知量）。考虑到这一点，我们可以把公式 {{eqref: eq:lec5:BC_lambda_solved}} 改写为对称正定（SPD）系统：

$$
    H_{UB} \Delta x_B + H_{UU} \Delta x_U = -g_U,
$$

其中矩阵与向量按如下方式分块：

$$
H = \begin{bmatrix}H_{BB} & H_{BU} \\ H_{UB} & H_{UU} \end{bmatrix}, \quad 
\Delta x = \begin{bmatrix} \Delta x_B \\ \Delta x_U \end{bmatrix}, \quad
g = \begin{bmatrix}g_B \\ g_U \end{bmatrix},
$$

而下标 \\(B\\) 表示 BC 节点。已知 \\(\Delta x_B = 0\\)，系统简化为：

$$
    H_{UU} \Delta x_U = -g_U,
    {{numeq}}{eq:lec5:BC_final_system}
$$

它表示一个排除了 BC 节点的 SPD 系统。

### 更实用的做法

上述方法主要用于数学上的说明。在实际应用中，往往并不构造公式 {{eqref: eq:lec5:BC_final_system}}。这是因为它需要重排自由度（DOF），并把 BC 节点与无约束节点分开，这个过程既繁琐又低效，尤其当狄利克雷节点集合随时间变化时更是如此。

为了免去重排 DOF 的麻烦，可以直接修改原始线性系统，使其与公式 {{eqref: eq:lec5:BC_final_system}} 一致。这一调整包括：把 \\( H \\) 与 \\( g \\) 中对应于 BC 节点的行内所有元素置为 \\( 0 \\)。此外，对于 \\( H \\) 中与 BC 节点关联的列，所有非对角元素置为 \\( 0 \\)，而对角元素赋为 \\( 1 \\) 或其他正实数，以保证系统仍然良态。求解该修改后的系统之后，所得的 \\( \Delta x_U \\) 值即可直接获得，而所有 \\( \Delta x_B \\) 值都保证为 \\( 0 \\)。

> {{exp}}{exp:lec5:DOF_elim_example}[自由度消元]
对于 {{ref: exp:lec5:dbc}} 中定义的问题，其中二维双节点系统的第二个节点 \\((x_{21}, x_{22})\\) 被固定在 \\((1,2)\\)，假设在某个时间步的某次迭代中
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
我们求解系统
$$
    \begin{bmatrix}
      4 & -1 & 0 & 0 \\
      -1 & 4 & 0 & 0 \\
      0 & 0 & 1 & 0 \\
      0 & 0 & 0 & 1
    \end{bmatrix}  
    \begin{bmatrix}
      \Delta x_{11}\\
      \Delta x_{12}\\
      \Delta x_{21}\\
      \Delta x_{22}\\
    \end{bmatrix}
    = 
    \begin{bmatrix}
      -1\\
      -2\\
      0\\
      0
    \end{bmatrix}.
    {{numeq}}{eq:sec5:BC_projected_system}
$$
以得到搜索方向 \\(\Delta x\\)，使得 \\(\Delta x_{21} = \Delta x_{22} = 0\\)，而经过线搜索之后我们确知 \\((x_{21}, x_{22}) = (1, 2)\\) 仍然成立，因为 $(x_{21} + \alpha \Delta x_{21}, x_{22} + \alpha \Delta x_{22}) = (x_{21}, x_{22})$。这里的 {{eqref: eq:sec5:BC_projected_system}} 本质上就是
$$
    \begin{bmatrix} H_{UU} & \\  & I \end{bmatrix} \begin{bmatrix}\Delta x_U \\ \Delta x_B \end{bmatrix} = \begin{bmatrix} -g_U \\ 0\end{bmatrix}
$$

> **{{rem}}{rem:lec5:DOF_elim_limitations}[自由度消元的局限]**
在粘着 BC 节点于时间步开始时即已建立的情形下，所描述的自由度消元法是有效的。然而，若非如此，且公式 {{eqref: eq:lec5:BC_KKT}} 中的约束函数具有非零右端项（rhs），则自由度消元法不再适用。问题并不在于无法在右端项非零的约束下求解 \\( \Delta x \\)；而在于所得的 \\( \Delta x \\) 可能不构成增量势能中的下降方向。这会导致线搜索后的步长极小，甚至可能使优化过程停滞。
>
> 直观地说，如果 \\( \Delta x_B \\) 的方向朝向规定的 BC 坐标，它就可能无意中增大增量势能，而该势能并未针对 BC 作出调整。反之，当 BC 已经满足时，若 \\( \Delta x_B \\) 直接取 \\( 0 \\)，则相当于只用一部分变量来最小化增量势能，这仍然是有效的做法。
>
> 那么有人会问，为什么不把 DOF 调整到满足 BC 之后再开始优化呢？然而这一策略可能导致不可行的构型，例如出现相交的情形。一种可行的替代方案是：先施加刚度很大的弹簧力，在优化过程中逐步把 BC 节点“拖”到其受约束的位置，之后再改用自由度消元法以提升收敛性。这一技巧将在[移动边界条件*](../moving-boundary-conditions/mov_DBC.md)一节中进一步讨论。
