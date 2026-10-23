## 求解精度

那么，为什么我们可以通过求解式 {{eqref: eq:lec7:barrier_IPC}} 来近似原问题（式 {{eqref: eq:lec7:constrained_IP}}）的解呢？
与[狄利克雷边界条件](../../simulation-with-optimization/optimization-framework/dirichlet_BC.md)类似，在式 {{eqref: eq:lec7:constrained_IP}} 的解 \\(x^*\\) 处，下列 KKT 条件全部成立：
$$
\begin{aligned}
    \nabla E(x^*) - \sum_{i,j} \gamma_{ij} \nabla d_{ij}(x^*) = 0, \\
    \forall {i,j}, \ d_{ij}(x^*) \geq 0, \ \gamma_{ij} \geq 0, \ \gamma_{ij} d_{ij}(x^*) = 0.
\end{aligned}
{{numeq}}{eq:lec7:IC_KKT}
$$
而在式 {{eqref: eq:lec7:barrier_IPC}} 的局部最优解 \\(x'\\) 处，有
$$
    \nabla E(x') + h^2 \nabla P_b(x') = 0,
    {{numeq}}{eq:lec7:optimality_barrier}
$$
这等价于
$$
    \nabla E(x') + h^2 \sum_{i,j} A_i \hat{d} \nabla b(d_{ij}(x')) = 0
$$
以及
$$
    \nabla E(x') + h^2 \sum_{i,j} A_i \hat{d} 
    \frac{\partial b}{\partial d}(d_{ij}(x')) \nabla d_{ij}(x') = 0
$$
只要代入 \\(\nabla b(d_{ij})\\) 的表达式。
令 \\(\gamma_{ij}' = -h^2 A_i \hat{d} \frac{\partial b}{\partial d}(d_{ij}(x'))\\)，我们可以进一步将式 {{eqref: eq:lec7:optimality_barrier}} 改写为
$$
    \nabla E(x') - \sum_{i,j} \gamma_{ij}' \nabla d_{ij}(x') = 0,
$$
若把 \\(\gamma_{ij}'\\) 视为对偶变量，这本质上就是平稳性条件（式 {{eqref: eq:lec7:IC_KKT}} 中的第一行）。
现在，由于障碍函数能提供任意大的排斥作用以避免相互穿透，可知 \\(\forall i,j\\)，\\(d_{ij}(x') \geq 0\\)。此外，由构造方式可知 \\(\frac{\partial b}{\partial d} \leq 0\\)，因此对所有 \\(i,j\\) 也有 \\(\gamma_{ij}' \geq 0\\)。这意味着在 \\(x'\\) 处，动量达到平衡，不出现相互穿透，且接触力只推不拉。 

在我们的仿真中，\\( x' \\) 处唯一未被严格满足的 Karush-Kuhn-Tucker（KKT）条件是互补松弛条件。这源于障碍近似发挥作用的方式。具体而言，我们面对的情形是 \\( \gamma_{ij} > 0  \Longleftrightarrow  0 < d_{ij} < \hat{d} \\)，它表示接触力依据固体与障碍物之间的距离而被激活。

随着阈值 \\( \hat{d} \\) 减小，接触力只有在固体靠得更近时才会激活（如 {{ref: fig:lec7:barrier_func}} 所示）。这一调整会降低互补松弛误差，而该误差可以在一定程度上加以控制。然而需要指出，这种控制是有代价的：计算效率可能下降。原因在于，由较小的 \\( \hat{d} \\) 值导致的更尖锐的目标函数，往往需要更多的牛顿迭代才能求解。因此，仿真的精度（就满足 KKT 条件而言）与所需的计算资源之间存在权衡。
