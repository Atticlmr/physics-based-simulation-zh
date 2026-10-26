# 案例研究：二维自接触*

我们已经把线性有限元与弹性动力学及摩擦接触的弱形式推导衔接起来了。现在该来看看这些概念如何在代码中实现。本讲中，我们将基于[案例研究：无翻转弹性](../../hyperelasticity/case-study-inversion-free-elasticity/inv_free_elasticity.md)中用 Python 开发的无翻转弹性仿真，实现二维无摩擦自接触。

本节可运行的 Python 工程可在 [https://github.com/phys-sim-book/solid-sim-tutorial](https://github.com/phys-sim-book/solid-sim-tutorial) 的 `7_self_contact` 文件夹中找到。
[MUDA](https://github.com/MuGdxy/muda) GPU 实现可在 [https://github.com/phys-sim-book/solid-sim-tutorial-gpu](https://github.com/phys-sim-book/solid-sim-tutorial-gpu) 的 `simulators/7_self_contact` 文件夹中找到。
我们将在下一讲中实现摩擦自接触。
