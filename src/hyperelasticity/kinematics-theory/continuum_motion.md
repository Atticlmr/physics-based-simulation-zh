## 连续体运动

运动学是研究连续体材料中运动的学科，主要关注在不同坐标系下（无论是局部还是整体）所发生的形状变化或变形。其目标是定性与定量地描述运动，这对于推导动力学与力学响应的控制方程至关重要。值得注意的是，运动学通常无需引入力、应力乃至质量等概念即可描述。

在连续体力学中，变形通常通过三个关键部分来表示：
- **材料（或未变形）空间 $\mathbf{X}$**：表示材料中任意一点的初始位置。
- **世界（或变形后）空间 $\mathbf{x}$**：表示任意一点的当前位置。
- **变形映射 $\phi(\mathbf{X},t)$**：该函数把点从材料空间映射到世界空间，显示物质点的位置如何随时间变化。

在初始时刻 $t=0$，材料空间 $\mathbf{X}$ 与世界空间 $\mathbf{x}$ 重合，即每个点都从自己的未变形位置开始。

> **{{def}}{def:lec12:flow_map}[变形/流动映射]**
> 连续体力学中物质的运动由一个映射 $\phi(\cdot,t):\Omega^0\rightarrow\Omega^t$ 决定，其中 $\Omega^0,\Omega^t\subset\mathbb{R}^d$，$d=2$ 或 $3$ 表示所仿真问题（或区域）的维度。该映射通常称为流动映射或变形映射，对于理解物质点如何随时间运动至关重要。
>
> - **物质点 $\mathbf{X}$**：集合 $\Omega^0$ 中的点称为物质点，记作 $\mathbf{X}$。
> - **当前位置 $\mathbf{x}$**：$\Omega^t$ 中的点表示物质点在时刻 $t$ 的位置，记作 $\mathbf{x}$。
> 变形映射 $\phi$ 描述了每个物质点 $\mathbf{X}\in\Omega^0$ 随时间变化的轨迹，表示为：
$$
    \mathbf{x} = \mathbf{x}(\mathbf{X},t) = \phi(\mathbf{X},t).
$$

> **{{exp}}{exp:lec12:motion_examples}**
> 如果我们的物体以恒定速率 $v$ 沿方向 $\mathbf{n}$ 运动，则有
$$
\mathbf{x} = \mathbf{X} + tv\mathbf{n}. 
{{numeq}}{eq:lec12:motion_eg1}
$$
> 如果一个物体在时刻 $t$ 之后（相对于时刻 $0$）发生某种刚体运动，则会有
$$
\mathbf{x} = \mathbf{R}\mathbf{X} + \mathbf{b}, 
{{numeq}}{eq:lec12:motion_eg2}
$$
> 其中 $\mathbf{R}$ 是旋转矩阵，$\mathbf{b}$ 是某个平移量。$\mathbf{R}$ 与 $\mathbf{b}$ 很可能是时间 $t$ 和初始位置 $\mathbf{X}$ 的函数，具体取决于实际运动。

映射 $\phi$ 可用于量化相关的连续体物理量。例如，给定物质点 $\mathbf{X}$ 在时刻 $t$ 的速度为
$$
\mathbf{V}(\mathbf{X},t) = \frac{\partial \phi}{\partial t}(\mathbf{X},t), {{numeq}}{eq:lec12:lagragian_V}
$$
而加速度为
$$
\mathbf{A}(\mathbf{X},t) = \frac{\partial^2 \phi}{\partial t^2}(\mathbf{X},t) = \frac{\partial \mathbf{V}}{\partial t}(\mathbf{X},t). {{numeq}}{eq:lec12:lagragian_A}
$$
也就是说，$\mathbf{V}(\cdot,t):\Omega^0\rightarrow\mathbb{R}^d$ 且 $\mathbf{A}(\cdot,t):\Omega^0\rightarrow\mathbb{R}^d$。

> **{{rem}}{rm:lec12:lagrangian_view}**
> 上文中，速度 $\mathbf{V}$ 与加速度 $\mathbf{A}$ 是从拉格朗日视角定义的。这意味着速度与加速度都是材料构型 $\mathbf{X}$ 与时间 $t$ 的函数，关注的是材料内部特定的粒子。从物理上讲，这意味着这些量针对的是自仿真开始时就占据一定体积、且自身具有质量的粒子。拉格朗日视角对于跟踪单个粒子随时间的动力学尤为重要，能够细致揭示粒子在各种条件下如何在材料内部运动、加速与相互作用。
