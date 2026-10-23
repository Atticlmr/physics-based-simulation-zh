## 基于 SDF 的球体碰撞体

在[有符号距离](../../boundary-treatments/distance-barrier-for-nonpenetration/signed_dists.md)一节中，我们介绍了固体几何的**解析表示**——球体、盒子、半空间等形状由其坐标上的数学表达式定义。那里引入的一个强大抽象是**有符号距离函数（SDF）**。该函数对空间中的任意给定点求值，得到该点到几何表面的有符号距离：负值表示点在物体内部，正值表示在外部，零则恰位于表面上。

这一概念可以自然地用于 MPM 等仿真框架中的**碰撞检测与边界条件施加**。

### 用解析 SDF 表示碰撞体

考虑一个圆心为 $\mathbf{c} = (c_x, c_y)$、半径为 $r$ 的**二维球**（圆）。其 SDF 定义为：

$$
\phi(\mathbf{x}) = \|\mathbf{x} - \mathbf{c}\| - r.
$$

- 若 $\phi(\mathbf{x}) < 0$，则该点位于球体**内部**。
- 若 $\phi(\mathbf{x}) = 0$，则该点位于球体表面**上**。
- 若 $\phi(\mathbf{x}) > 0$，则该点位于球体**外部**。

这一定义使我们能够通过对每个网格节点求 SDF 值，在整个仿真域上统一施加**接触边界条件**。

{{imp}}{imp:lec30:sphere_sdf}[带摩擦接触的球体 SDF 碰撞体，simulator.py]
```python
{{#include ../../solid-sim-tutorial/11_mpm_plastic/simulator.py:sphere_sdf}}
```
