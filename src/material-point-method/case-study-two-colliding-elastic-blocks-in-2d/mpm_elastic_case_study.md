# 案例研究：带球体碰撞体的二维沙子*

*本讲作者：[Chang Yu](https://changyu.io/)，加州大学洛杉矶分校*

至此，我们已经介绍了构建完整、物理上合理的物质点法（Material Point Method，MPM）仿真系统所需的全部核心组件——包括材料离散化、时间积分与数据传输格式。

在本案例研究中，我们将这些组件组合起来，仿真二维中两块相互碰撞的弹性体。我们首先[设置](simulation_setup.md)仿真的材料属性与数据结构定义。随后，我们实现[质点网格（Particle-In-Cell，PIC）传输](pic_transfer.md)，以处理粒子与网格之间的动量交换。

本示例是 MPM 流程使用弹性材料的一个**快速入门**演示，不涉及塑性或复杂边界条件。

在实现上，我们使用 NumPy 与 [Taichi](https://docs.taichi-lang.org/) 作为编程框架。Taichi 在 CPU 与 GPU 上都能提供高效的并行能力，更重要的是，它支持[稀疏数据结构](https://docs.taichi-lang.org/docs/sparse)，这对高性能的 MPM 网格计算至关重要。

本节可执行的 Python 工程位于 [https://github.com/phys-sim-book/solid-sim-tutorial](https://github.com/phys-sim-book/solid-sim-tutorial) 的 `10_mpm_elasticity` 文件夹下。
