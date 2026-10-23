# 案例研究：无翻转弹性*

在本章末尾，我们实现前几讲中介绍的 Neo-Hookean 模型，以仿真无翻转的弹性固体。
本节可执行的 Python 项目位于 [https://github.com/phys-sim-book/solid-sim-tutorial](https://github.com/phys-sim-book/solid-sim-tutorial) 的 `6_inv_free` 文件夹中。
[MUDA](https://github.com/MuGdxy/muda) GPU 实现位于 [https://github.com/phys-sim-book/solid-sim-tutorial-gpu](https://github.com/phys-sim-book/solid-sim-tutorial-gpu) 的 `simulators/6_inv_free` 文件夹中。
与质点-弹簧模型中把弹性离散到弹簧上不同，我们在此把 Neo-Hookean 模型离散到三角形单元上，根据变形梯度 $\mathbf{F}$ 与世界空间节点位置 $\mathbf{x}$ 之间的关系，应用链式法则计算弹性力，然后发展出一种基于求根的方法来过滤线搜索的初始步长，以保证无翻转。
