## 等式约束形式

狄利克雷边界条件（Dirichlet boundary condition，BC）在融入优化时间积分器后，被表示为线性等式约束：
$$
    A x = b,
    {{numeq}}{eq:lec5:BC_x}
$$
式中矩阵 \\(A\\) 为 \\(m \times dn\\) 矩阵，其中 \\(m \leq dn\\)。该矩阵用于挑选受边界条件作用的节点处的自由度（Degree of Freedom，DOF）。向量 \\(b\\) 为 \\(m \times 1\\) 向量，给出这些条件所规定的确切空间数值。

> {{exp}}{exp:lec5:dbc}[粘着狄利克雷边界条件]
对于包含两个节点 \\((x_{11}, x_{12})\\) 与 \\((x_{21}, x_{22})\\) 的二维系统，要把第二个节点固定在位置 \\((1, 2)\\)，边界条件（公式 {{eqref: eq:lec5:BC_x}}）可写为
$$
    \begin{bmatrix}
      0 & 0 & 1 & 0 \\
      0 & 0 & 0 & 1
    \end{bmatrix}  
    \begin{bmatrix}
      x_{11}\\
      x_{12}\\
      x_{21}\\
      x_{22}\\
    \end{bmatrix}
    = 
    \begin{bmatrix}
      1\\
      2
    \end{bmatrix}.
$$

最常见的两类狄利克雷边界条件是粘着与滑移：

**粘着边界条件**：这类条件实际上固定了某些节点在一个时间步内的位置。其特征是分块形式的约束雅可比矩阵 \\(A\\)。在该矩阵中，每 \\(d\\) 行恰好包含一个 \\(d \times d\\) 单位矩阵，其余部分由零矩阵构成。这种结构如 {{ref: exp:lec5:dbc}} 所示。粘着边界条件的实现可确保指定节点在仿真过程中保持静止、遵循规定位置。

**滑移边界条件**：这类条件旨在把每个边界条件（BC）节点约束在一个特定的线性子空间内，例如一个平面或一条直线，且该子空间不必与坐标轴对齐。以平面滑移边界条件为例：此时矩阵 \\(A\\) 中每个 BC 节点对应一行，该行包含平面的法向量，该向量占据与 BC 节点对应的列，详见 {{ref: exp:lec5:slip}}。这类条件允许节点运动，但仅限于所定义的线性子空间之内，从而提升了仿真的复杂性与真实感。

> {{exp}}{exp:lec5:slip}[滑移狄利克雷边界条件]
对于 {{ref: exp:lec5:dbc}} 中的同一双节点系统，要把第一个节点约束在方程为 \\(2x + 3y = 4\\) 的直线上，约束（公式 {{eqref: eq:lec5:BC_x}}）可写为
$$
    \begin{bmatrix}
      2 & 3 & 0 & 0
    \end{bmatrix}  
    \begin{bmatrix}
      x_{11}\\
      x_{12}\\
      x_{21}\\
      x_{22}\\
    \end{bmatrix}
    = 4.
$$

在每个时间步开始时，如果已知所有边界条件都已满足，那么优化过程中的目标就只是保持边界条件节点的位置不变。这表示为：
$$
    A \Delta x = 0.
    {{numeq}}{eq:lec5:BC_dx}
$$
这里 \\(\Delta x\\) 是每次优化迭代中的搜索方向。保持该条件即可确保任何更新后的节点位置 \\(x + \alpha \Delta x\\)（其中 \\(\alpha\\) 为线搜索得到的步长）仍然满足边界条件：
$$
    A (x + \alpha \Delta x) = b.
$$
这保证了在整个优化过程中始终遵循边界条件。

为了在一个时间步内对粘着狄利克雷边界条件（Dirichlet Boundary Condition，DBC）施加线性等式约束（公式 {{eqref: eq:lec5:BC_dx}}），我们在每次牛顿迭代求解搜索方向 \\( \Delta x \\) 时处理该约束。该过程利用增量势能的二次近似构造拉格朗日函数：

$$
    L(\Delta x, \lambda) = \frac{1}{2}\Delta x^T H \Delta x + g^T \Delta x + \lambda^T A\Delta x,
$$

这里 \\( \lambda \\) 为 \\( m\times 1 \\) 拉格朗日乘子向量。增量势能的梯度与海森矩阵分别记为 \\( g \\) 与 \\( H \\)。

其解通过一个极大-极小优化问题逼近：

$$
    \max_\lambda \min_{\Delta x} L(\Delta x, \lambda),
$$

由此得到 Karush-Kuhn-Tucker（KKT）系统：

$$
    \begin{bmatrix}H & A^T\\ A & \end{bmatrix} \begin{bmatrix}\Delta x\\ \lambda \end{bmatrix} = \begin{bmatrix} -g \\ 0\end{bmatrix}.
    {{numeq}}{eq:lec5:BC_KKT}
$$

求解该 KKT 系统是确定搜索方向的关键。注意该系统并非对称正定（Symmetric Positive Definite，SPD），且其规模随 BC 节点数目增加而增大。

