# 案例研究：基于位置的流体仿真*

基于位置的动力学框架可以很自然地推广到不可压缩流体的仿真。由此得到的方法称为基于位置的流体（Position-Based Fluids，PBF）{{#cite macklin2013position}}，它用一组几何约束取代了传统光滑粒子流体动力学（Smoothed Particle Hydrodynamics，SPH）{{#cite koschier2020smoothed}}中复杂的压力求解。这一方法继承了 PBD 的稳定性与高效性，允许使用适合实时应用的大时间步长，同时有效地强制满足不可压缩流动所特有的常密度条件。

在 [基于位置的流体：密度与表面约束](./density_constraints.md) 所建立的理论基础之上，本案例研究演示如何实现一个完整的 PBF 仿真系统。与前面讨论的其他 PBD 应用领域（布料与体积网格）相比，流体通过密度约束实现不可压缩性，这带来了独特的挑战。

核心算法实现了三阶段密度约束求解器：计算拉格朗日乘子 $\lambda_i$、使用对称约束公式计算位置修正，以及在防止拉伸不稳定性的前提下应用修正。

该仿真包含用于产生内聚类液体运动的 XSPH 粘性，以及用于重新引入迭代约束求解过程中损失的旋转能量的涡量限制。动态墙体提供了压缩场景，展示了该方法处理复杂边界交互的能力。

在实现上，我们使用 [Taichi](https://docs.taichi-lang.org/) 作为编程框架，它提供高效的 GPU 并行能力，这对结合空间哈希的高性能粒子仿真必不可少。

本节的可执行 Python 工程位于 [https://github.com/phys-sim-book/solid-sim-tutorial](https://github.com/phys-sim-book/solid-sim-tutorial) 的 `14_pbf` 文件夹下。
