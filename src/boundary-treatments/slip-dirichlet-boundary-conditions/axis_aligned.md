## 轴对齐滑移 DBC

轴对齐的滑移狄利克雷边界条件（DBC）把某些节点的运动限制在与坐标轴对齐的线性子空间中。例如，这类约束可以把运动限制在平行于 x 轴的直线或平行于 yz 平面的平面上。轴对齐滑移 DBC 的一个优势在于，其约束雅可比矩阵与粘着型 DBC 的约束雅可比矩阵相似。因此，可以用相同的自由度消元法高效地处理它们。

> {{exp}}{exp:lec6:axis_aligned_slip_DBC}[轴对齐滑移 DBC]
考虑前文提到的二维空间中的两节点系统，如滑移 DBC 示例（{{ref: exp:lec5:slip}}）中所引用的。若要施加一个滑移 DBC，把坐标为 \\((x_{11}, x_{12})\\) 的第一个节点约束为只沿直线 \\(y = 3\\) 运动，我们可把该约束写成一个线性等式：
$$
    \begin{bmatrix}
      0 & 1 & 0 & 0
    \end{bmatrix}  
    \begin{bmatrix}
      x_{11}\\
      x_{12}\\
      x_{21}\\
      x_{22}\\
    \end{bmatrix}
    = 3.
$$
接着，与粘着型 DBC 类似，在某个该滑移 DBC 已满足的时间步中，假设有
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
我们可以求解如下系统
$$
    \begin{bmatrix}
      4 & 0 & -1 & -1 \\
      0 & 1 & 0 & 0 \\
      -1 & 0 & 4 & -1 \\
      -1 & 0 & -1 & 4
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
      0\\
      -3\\
      -4
    \end{bmatrix}
$$
以得到搜索方向，使得 \\(\Delta x_{12} = 0\\)，并且由于第一个节点的 \\(y\\) 坐标不会变化，无论步长多大它都将停留在 \\(y=3\\) 这条直线上。
