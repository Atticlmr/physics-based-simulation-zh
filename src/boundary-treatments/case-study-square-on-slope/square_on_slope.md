# 案例研究：斜面上的方块*

本节基于我们在[摩擦接触](../frictional-contact/friction.md)中学到的内容，在优化时间积分框架内为斜面实现摩擦接触。我们首先扩展[方块下落](../filter-line-search/square_drop.md)案例研究中用于水平地面的接触模型，使其能够处理具有任意朝向与位置的斜面。

在此扩展的基础上，我们为斜面实现摩擦，并通过仿真一个落在斜面上的弹性方块来测试。根据摩擦系数 $\mu$ 的不同，方块会停在斜面上的不同位置，或者持续下滑。

本节可执行的 Python 工程见 [https://github.com/phys-sim-book/solid-sim-tutorial](https://github.com/phys-sim-book/solid-sim-tutorial) 中的 `4_friction` 文件夹。
[MUDA](https://github.com/MuGdxy/muda) GPU 实现见 [https://github.com/phys-sim-book/solid-sim-tutorial-gpu](https://github.com/phys-sim-book/solid-sim-tutorial-gpu) 中的 `simulators/4_friction` 文件夹。
