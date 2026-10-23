## 固体-障碍物接触

回顾一下，我们曾用一个保守力模型来近似接触面力 $\mathbf{T}_C$，使其在给定固体当前构型的情况下可以直接计算。由此得到接触势能：

$$
P_C = \int_{\Gamma_C} \frac{1}{2} b\left(\min_{\mathbf{X}_2 \in \Gamma_C - \mathcal{N}(\mathbf{X})} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) \, ds(\mathbf{X}),
$$

其中 $b()$ 是障碍能量密度函数，$\mathcal{N}(\mathbf{X})$ 是 $\mathbf{X}$ 周围的一个无穷小区域，出于理论上的严谨性，该区域内的接触被忽略。

对于被仿真固体与碰撞障碍物之间的法向接触（暂不考虑自接触），$P_C$ 可以写成简单得多的形式
$$
\begin{aligned}
    P_C 
    & = \int_{\Gamma_S} \frac{1}{2} b\left(\min_{\mathbf{X}_2 \in \Gamma_O} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) ds(\mathbf{X}) \\ &+ \int_{\Gamma_O} \frac{1}{2} b\left(\min_{\mathbf{X}_2 \in \Gamma_S} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) ds(\mathbf{X}) \\
    & = \int_{\Gamma_S} b\left(\min_{\mathbf{X}_2 \in \Gamma_O} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) ds(\mathbf{X}) \\
    & = \int_{\Gamma_S} b\left(d^{PO}(\mathbf{x}(\mathbf{X}, t), O), \hat{d}\right) ds(\mathbf{X}).
\end{aligned}
$$
其中 $\Gamma_S$ 与 $\Gamma_O$ 分别是被仿真固体与障碍物的边界，$d^{PO}(\mathbf{x}(\mathbf{X},t), O) = \min_{\mathbf{X}_2 \in \Gamma_O} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|$ 是点-障碍物距离，而由两项简化为单项则得益于连续情形下的对称性。
采用三角形离散后，
$$
    \int_{\Gamma_S} b (d^{PO}(\mathbf{x}(\mathbf{X},t), O),\hat{d}) ds(\mathbf{X}) \approx \sum_{e \in \mathcal{T}} \int_{\partial \Omega_e^0 \cap \Gamma_S} b (d^{PO}(\mathbf{x}(\mathbf{X},t), O),\hat{d}) ds(\mathbf{X}).
    {{numeq}}{eq:lec20:discrete_contact_potential}
$$
与诺伊曼边界的推导类似，对带 2 个关联三角形的任意边界节点 $\hat{a}$，我们来看其中一个积分。不失一般性，可设 $N_{\hat{a}} = \beta$（即 $\mathbf{X}_{\hat{a}}$ 对应三角形 $e$ 中的 $\mathbf{X}_2$），并设 $X_3$ 是 $e$ 位于边界边上的另一个节点。于是把积分变量换为 $\beta$ 可得
$$
\begin{aligned}
   & \int_{\partial \Omega_e^0 \cap \Gamma_S} b (d^{PO}(\mathbf{x}(\mathbf{X},t), O),\hat{d}) ds(\mathbf{X}) \\
    = & \int_0^1 b (d^{PO}(\mathbf{x}(\beta\mathbf{X}_2 +(1-\beta) \mathbf{X}_3,t), O),\hat{d}) \left|\frac{\partial s}{\partial \beta}\right| d\beta.
    {{numeq}}{eq:lec20:point_obstacle_1}
\end{aligned}
$$
由于 $b()$ 与 $d^{PO}()$ 都是高度非线性的函数，我们无法得到式 {{eqref: eq:lec20:point_obstacle_1}} 的闭式表达式。若取两个端点 $\mathbf{X}_2$ 与 $\mathbf{X}_3$ 作为求积点并各取权重 $\frac{1}{2}$，则可把积分近似为
$$
\begin{aligned}
    & \int_0^1 b (d^{PO}(\mathbf{x}(\beta\mathbf{X}_2 +(1-\beta) \mathbf{X}_3,t), O),\hat{d}) \left|\frac{\partial s}{\partial \beta}\right| d\beta \\
    \approx & \frac{1}{2} b (d^{PO}(\mathbf{x}(\mathbf{X}_2,t), O),\hat{d}) \left|\frac{\partial s}{\partial \beta}\right| + \frac{1}{2} b (d^{PO}(\mathbf{x}( \mathbf{X}_3,t), O),\hat{d}) \left|\frac{\partial s}{\partial \beta}\right|.
\end{aligned}
{{numeq}}{eq:lec20:ipc_end_point_quadrature}
$$
于是，整个边界积分可近似为
$$
    \int_{\Gamma_S} b (d^{PO}(\mathbf{x}(\mathbf{X},t), O),\hat{d}) ds(\mathbf{X}) \approx \sum_{\hat{a}}  \frac{\|\mathbf{X}_{\hat{a}} - \mathbf{X}_{\hat{a} - 1} \| + \|\mathbf{X}_{\hat{a}} - \mathbf{X}_{\hat{a} + 1} \|}{2} b (d^{PO}(\mathbf{x}_{\hat{a}}, O),\hat{d}),
$$
这里假设 $\mathbf{X}_{\hat{a} - 1}$ 与 $\mathbf{X}_{\hat{a} + 1}$ 是 $\mathbf{X}_{\hat{a}}$ 在边界上的两个相邻节点。这正是 [过滤线搜索](../../hyperelasticity/case-study-inversion-free-elasticity/filter_line_search.md) 中已经实现的内容。

> **{{rem}}{rem:lec20:quadrature_choice}[线段积分的求积点选择]** 选取两个端点（$\beta = 0, 1$）作为线段积分的求积点（式 {{eqref: eq:lec20:ipc_end_point_quadrature}}）并不是常见的设计选择。通常，高斯求积会使用 $\beta = \frac{3 \pm \sqrt{3}}{6}$。选择 $\beta = 0, 1$ 的优点在于全局的求积点更少，从而降低计算开销，因为相邻的边共享端点。


为看清 $P_C$ 如何与离散弱形式中的边界积分（式 {{eqref: eq:lec20:bi_disc_weak}}）相联系，我们对离散接触势能（式 {{eqref: eq:lec20:discrete_contact_potential}}）关于 $\mathbf{x}_{\hat{a}}$ 求导：
$$
\begin{aligned}
   & -\frac{\partial (\sum_{e \in \mathcal{T}} \int_{\partial \Omega_e^0 \cap \Gamma_S} b (d^{PO}(\mathbf{x}(\mathbf{X},t), O),\hat{d}) ds(\mathbf{X}))}{\partial \mathbf{x}_{\hat{a}}} \\
   = &
   \sum_{e \in \mathcal{T}} \int_{\partial \Omega_e^0 \cap \Gamma_S} -\frac{\partial b (d^{PO}(\mathbf{x}(\mathbf{X},t), O),\hat{d})}{\partial \mathbf{x}} \frac{\partial \mathbf{x}}{\partial \mathbf{x}_{\hat{a}}} ds(\mathbf{X}) \\
   = & \sum_{e \in \mathcal{T}} \int_{\partial \Omega_e^0 \cap \Gamma_S} -\frac{\partial b (d^{PO}(\mathbf{x}(\mathbf{X},t), O),\hat{d})}{\partial \mathbf{x}} N_{\hat{a}}(\mathbf{X}) ds(\mathbf{X}).
\end{aligned}
$$
由此我们也验证了此处 $\mathbf{T}_C(\mathbf{X}, t) = -\frac{\partial b (d^{PO}(\mathbf{x}(\mathbf{X},t), O),\hat{d})}{\partial \mathbf{x}}$。
