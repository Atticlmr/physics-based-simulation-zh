## 惯性项

对于惯性项，令 \\(\tilde{x}^n = x^n + h v^n\\)，有
\\[
    E_I(x) = \frac{1}{2}\\|x - \tilde{x}^n \\|_M^2, \quad \nabla E_I(x) = M(x - \tilde{x}^n), \quad \text{and} \quad \nabla^2 E_I(x) = M,
\\]
它可以直接实现：

{{imp}}{imp:lec4:inertia_energy}[InertiaEnergy.py]
```python
{{#include ../../solid-sim-tutorial/1_mass_spring/InertiaEnergy.py}}
```

`val()`、`grad()` 与 `hess()` 函数分别用于计算惯性项的不同组成部分。具体而言：

- `val()`：计算惯性项的值。
- `grad()`：计算惯性项的梯度。
- `hess()`：确定惯性项的海森矩阵。

关于海森矩阵，我们采用了一种节省内存的方法。我们并不分配一个大型二维数组来存储海森矩阵的所有条目，而是只保留非零条目。这通过 `IJV` 结构实现，它由三个列表组成：

1. **行索引**：标识每个非零条目所在的行位置。
2. **列索引**：指示每个非零条目所在的列位置。
3. **值**：指定行与列处的实际非零值。

该方法显著降低了内存占用以及与下游处理相关的计算开销。
