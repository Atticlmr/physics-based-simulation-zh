# 案例研究：基于位置的布料仿真*


本案例研究以[基于位置的动力学：通用框架](../position-based-dynamics-pbd/position_based_dynamics.md)中建立的理论基础为出发点，演示如何实现一个完整的布料仿真系统。与其他 PBD 应用领域（流体与体网格）相比，布料需要同时通过距离约束与二面角约束来建模抗拉伸性和弯曲行为，这带来了独特的挑战。

核心算法实现了两种基本约束类型：用于抗拉伸的距离约束，以及用于弯曲行为的二面角约束。仿真包含带柔度参数的动态约束求解，从而可以精细控制材料属性。

在实现上，我们使用 [Taichi](https://docs.taichi-lang.org/) 作为编程框架，它提供高效的 GPU 并行能力，这对具有复杂网格拓扑的高性能布料仿真必不可少。

本节的可执行 Python 工程可在 [https://github.com/phys-sim-book/solid-sim-tutorial](https://github.com/phys-sim-book/solid-sim-tutorial) 的 `12_pbd_cloth` 文件夹中找到。
