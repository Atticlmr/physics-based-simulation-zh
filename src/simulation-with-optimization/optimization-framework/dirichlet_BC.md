## 狄利克雷边界条件

势能并非建模物理现象的唯一手段；约束同样不可或缺。先从最简单的形式——**线性等式约束**——说起。该约束优化问题定义如下：
$$
    \min_x E(x) \quad s.t. \quad Ax = b,
    {{numeq}}{eq:lec2:LEC_problem}
$$
其中 \\(A\\in \mathbb{R}^{m\\times dn}\\) 与 \\(b\\in \mathbb{R}^{m}\\) 表示 \\(m\\) 个线性等式约束。

仿真过程中，常常需要在每个时间步控制固体上某些点的位置。这可以是固定一组节点，用以建模地面、障碍物等不可移动的物体；也可以是让特定节点沿预定路径移动，从而引导固体的运动。例如，在弹弓场景（{{ref: fig:lec1:slingshot}}）中，犰狳的脚和耳朵保持静止。这类控制称为**狄利克雷边界条件（Dirichlet Boundary Condition，DBC）**。在优化时间积分器框架内，这些条件可以表示为线性等式约束。

具体而言，式 {{eqref:eq:lec2:LEC_problem}} 中的矩阵 \\(A\\) 通常是 \\(m\\times dn\\) 矩阵（\\(m\\leq dn\\) 且 \\(m \mod d = 0\\)），它挑选出狄利克雷边界条件（DBC）点的坐标。相应地，\\(b\\) 是 \\(m \\times 1\\) 向量，给出规定的位置。通过求解该优化问题，所选点被固定在这些指定位置上，而这些位置可以逐时间步变化。

在式 {{eqref:eq:lec2:LEC_problem}} 所示问题的局部极小点处，满足 **KKT 条件**
$$
\begin{aligned}
    \nabla E(x) - A^T \lambda = 0 \\
    A x = b
\end{aligned}
{{numeq}}{eq:lec2:LEC_KKT}
$$
其中 \\(\\lambda \\in \\mathbb{R}^{m}\\) 表示**拉格朗日乘子**向量，它由全部拉格朗日乘子构成。

> **{{rem}}{rem:lec2:solving_KKT}[求解 KKT 系统]**
求解带等式约束的非线性优化问题，可以通过直接处理式 {{eqref:eq:lec2:LEC_KKT}} 所示的非线性 KKT（Karush-Kuhn-Tucker）系统来实现。为此通常采用牛顿法之类的方法。然而，这种做法计算开销可能很大。对于边界条件，我们可以利用矩阵 \\(A\\) 的特殊结构，以无约束的方式求解该约束问题。实现这一思路的技术将在后续章节中演示。
