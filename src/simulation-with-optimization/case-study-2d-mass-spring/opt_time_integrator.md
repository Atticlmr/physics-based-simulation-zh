## 优化时间积分器

在能够计算任意构型下的增量势能之后，我们现在把注意力转向优化时间积分器的实现。该积分器对于最小化增量势能至关重要，并由此更新节点的位置与速度。这一实现遵循 {{ref: alg:lec3:PN_method_IE}} 中给出的方法：


{{imp}}{imp:lec4:time_integrator}[time_integrator.py]
```python
{{#include ../../solid-sim-tutorial/1_mass_spring/time_integrator.py}}
```

这里 `step_forward()` 本质上是带线搜索的投影牛顿法（{{ref: alg:lec3:PN_method_IE}}）的直接转写；为清晰起见，我们把增量势能的值（`IP_val()`）、梯度（`IP_grad()`）与海森矩阵（`IP_hess()`）的计算实现为独立的函数。

对于搜索方向的计算，我们使用 [Scipy library](https://scipy.org/) 中的线性求解器，它擅长处理稀疏矩阵。值得注意的是，该求解器接受压缩稀疏行（Compressed Sparse Row，CSR）格式的矩阵。选择这一格式与求解器是出于它们在处理效率与内存占用方面的优势，这在处理计算仿真中常见的大规模稀疏矩阵问题时尤为有利。
