# 案例研究：基于位置的网格仿真*

本案例研究演示如何实现一个完整的体积网格仿真系统。

核心算法实现了两种基本约束类型：用于抵抗拉伸的距离约束，以及用于保证不可压缩性的体积约束。该仿真还包含若干高级特性，例如仿真网格与视觉网格的解耦以及重心坐标蒙皮，从而在保持高效仿真的同时实现高质量渲染。

在实现上，我们使用 [Taichi](https://docs.taichi-lang.org/) 作为编程框架，它提供高效的 GPU 并行能力，这对具有复杂网格拓扑的高性能体积仿真必不可少。

本节的可执行 Python 工程位于 [https://github.com/phys-sim-book/solid-sim-tutorial](https://github.com/phys-sim-book/solid-sim-tutorial) 的 `13_pbd_mesh` 文件夹下。
