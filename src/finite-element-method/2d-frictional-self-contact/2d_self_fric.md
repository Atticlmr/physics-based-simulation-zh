# 二维摩擦自接触*

本讲将在[案例研究：二维自接触](../case-study-2d-self-contact/2d_self_contact.md)中二维自接触实现的基础上，实现二维摩擦。本节对应的可执行 Python 工程见 [https://github.com/phys-sim-book/solid-sim-tutorial](https://github.com/phys-sim-book/solid-sim-tutorial)。

为简单起见，我们将专注于实现半隐式版本的摩擦。这意味着法向力大小 $\lambda$ 与切向算子 $T$ 都被离散到上一个时间步，并且我们在每个时间步只求解一次优化问题，而不再执行额外的、收敛到完全隐式摩擦（[摩擦接触](../3d-frictional-self-contact/friction.md)）解的不动点迭代，后者位于 `8_self_friction` 文件夹下。
[MUDA](https://github.com/MuGdxy/muda) 的 GPU 实现见 [https://github.com/phys-sim-book/solid-sim-tutorial-gpu](https://github.com/phys-sim-book/solid-sim-tutorial-gpu) 中的 `simulators/8_self_friction` 文件夹。
结合增量势能接触（Incremental Potential Contact，IPC）中对静-动摩擦转换的平滑近似，把摩擦纳入优化时间积分框架就如同增加一项额外的势能一样直接。
