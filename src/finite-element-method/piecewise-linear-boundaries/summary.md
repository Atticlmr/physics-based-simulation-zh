## 小结

我们已把离散弱形式（式 {{eqref:eq:lec19:discrete_weak_form_BE}}）与 [过滤线搜索](../../hyperelasticity/case-study-inversion-free-elasticity/filter_line_search.md) 中关于边界条件与接触的实现联系了起来。此外，我们推导了二维离散曲面之间的自接触，并将在下一讲中实现。

这些推导遵循统一的方法论：首先把全局积分改写为各单元局部积分之和，然后用特定的求积规则对局部积分进行近似或解析求值。

本讲没有明确讨论摩擦，因为其在连续情形下的力定义已在 [边界条件与摩擦接触](../../governing-equations/boundary-conditions-and-frictional-contact/BC_and_fric.md) 中介绍。其积分近似可以按照与法向接触力类似的方式进行（详见 [案例研究：二维摩擦自接触](../2d-frictional-self-contact/2d_self_fric.md)）。

在推导过程中，我们还注意到，从强形式走向优化时间积分实现的路线，即：

$$
\begin{aligned}
    & \text{strong form} \rightarrow \text{weak form} \rightarrow \text{discrete weak form} \rightarrow \\
    & \text{finite element approximation} \rightarrow \text{optimization time integration}
\end{aligned}
$$

并不是唯一的。我们可以直接写出势能的连续形式，再通过空间离散化与近似得到节点力。对这一思路感兴趣的读者可以参阅拉格朗日力学或哈密顿力学。
