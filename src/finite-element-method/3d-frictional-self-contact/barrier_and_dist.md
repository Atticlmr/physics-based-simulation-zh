## 障碍函数与距离

在三角形网格离散下，连续情形中的障碍势能（式 {{eqref: eq:lec18:barrier_potential}}）可以近似为
$$
\begin{aligned}
    & \int_{\Gamma_C} \frac{1}{2} b\left(\min_{\mathbf{X}_2 \in \Gamma_C - \mathcal{N}(\mathbf{X})} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) ds(\mathbf{X}) \\
    \approx & \int_{\Gamma_C} \frac{1}{2} b\left(\min_{e \in \mathcal{T} - I(\mathbf{X})} \min_{\mathbf{X}_2 \in e} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) ds(\mathbf{X}) \\
    = & \int_{\Gamma_C} \frac{1}{2} b\left(\min_{e \in \mathcal{T} - I(\mathbf{X})} d^\text{PT}(\mathbf{x}(\mathbf{X},t), e), \hat{d}\right) ds(\mathbf{X}) \\
    = & \int_{\Gamma_C} \frac{1}{2} \max_{e \in \mathcal{T} - I(\mathbf{X})} b\left(d^\text{PT}(\mathbf{x}(\mathbf{X},t), e), \hat{d}\right) ds(\mathbf{X}),
\end{aligned}
{{numeq}}{eq:lec24:tri_disc_barrier_pot}
$$
其中 $\mathcal{T}$ 为所有表面三角形的集合，$I(\mathbf{X})$ 为所有包含点 $\mathbf{X}$ 的表面三角形的集合，$d^{\text{PT}}$ 为点-三角形距离。
进一步用求和近似 max 算子，并以网格表面节点 $\hat{a}$ 作为求积点，可得
$$
\begin{aligned}
    & \int_{\Gamma_C} \frac{1}{2} \max_{e \in \mathcal{T} - I(\mathbf{X})} b(d^\text{PT}(\mathbf{x}(\mathbf{X},t), e), \hat{d}) ds(\mathbf{X}) \\
    \approx & \int_{\Gamma_C} \frac{1}{2} \sum_{e \in \mathcal{T} - I(\mathbf{X})} b( d^\text{PT}(\mathbf{x}(\mathbf{X},t), e), \hat{d}) ds(\mathbf{X}) \\
    \approx &
    \sum_{\hat{a}} \frac{1}{2} w_{\hat{a}} \sum_{e \in \mathcal{T} - I(\mathbf{X}_{\hat{a}})} b( d^\text{PT}(\mathbf{x}_{\hat{a}}, e), \hat{d}),
\end{aligned}
{{numeq}}{eq:lec23:barrier_discrete}
$$
其中 $w_{\hat{a}} = \hat{d} \frac{1}{3} \sum_{j\in I(\mathbf{X}_{\hat{a}})} A_j$ 为积分权重，$A_j$ 为节点 $\hat{a}$ 的第 $j$ 个相邻表面三角形的面积。

现在回到式 {{eqref: eq:lec24:tri_disc_barrier_pot}} 的第二行，若我们只用边上的点来近似最小距离，则得到
$$
\begin{aligned}
    & \int_{\Gamma_C} \frac{1}{2} b\left(\min_{\mathbf{X}_2 \in \Gamma_C - \mathcal{N}(\mathbf{X})} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) ds(\mathbf{X}) \\
    \approx & \int_{\Gamma_C} \frac{1}{2} b\left(\min_{e \in \mathcal{E} - I(\mathbf{X})} \min_{\mathbf{X}_2 \in e} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) ds(\mathbf{X}) \\
    = & \int_{\Gamma_C} \frac{1}{2} \max_{e \in \mathcal{E} - I(\mathbf{X})} b\left(\min_{\mathbf{X}_2 \in e} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) ds(\mathbf{X}).
\end{aligned}
$$
然后，若对每条表面边 $e_1$ 选取一个特殊的求积点 $\mathbf{X}_{e_1}$，并用求和近似 max 算子，则得到
$$
\begin{aligned}
    & \int_{\Gamma_C} \frac{1}{2} \max_{e \in \mathcal{E} - I(\mathbf{X})} b\left(\min_{\mathbf{X}_2 \in e} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) ds(\mathbf{X}) \\
    \approx & \sum_{e_1 \in \mathcal{E}} \frac{1}{2} w_{e_1} \sum_{e \in \mathcal{E} - I(\mathbf{X}_{e_1})} b\left(\min_{\mathbf{X}_2 \in e} \| \mathbf{x}(\mathbf{X}_{e_1}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right),
\end{aligned}
$$
其中 $w_{e_1} = \hat{d} \frac{1}{3} \sum_{j\in I(e_1)} A_j$ 为积分权重，$A_j$ 为 $e_1$ 的第 $j$ 个相邻表面三角形的面积。
接下来，若我们总取 $\mathbf{X}_{e_1}$ 为 $e_1$ 上距 $\mathbf{X}_2$ 最近的点，则得到
$$
\begin{aligned}
    & \sum_{e_1 \in \mathcal{E}} \frac{1}{2} w_{e_1} \sum_{e \in \mathcal{E} - I(\mathbf{X}_{e_1})} b\left(\min_{\mathbf{X}_2 \in e} \| \mathbf{x}(\mathbf{X}_{e_1}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) \\
    \approx & \sum_{e_1 \in \mathcal{E}} \frac{1}{2} w_{e_1} \sum_{e \in \mathcal{E} - \mathcal{N}(e_1)} b\left(\min_{\mathbf{X}_2 \in e, \mathbf{X} \in e_1} \| \mathbf{x}(\mathbf{X}, t) - \mathbf{x}(\mathbf{X}_2, t)\|, \hat{d}\right) \\
    = & \sum_{e_1 \in \mathcal{E}} \frac{1}{2} w_{e_1}  \sum_{e \in \mathcal{E} - \mathcal{N}(e_1)} b\left(d^{\text{EE}}(e, e_1), \hat{d}\right),
\end{aligned}
{{numeq}}{eq:lec24:edge_barrier}
$$
其中 $\mathcal{N}(e_1)$ 为 $e_1$ 的所有表面边邻居再加上它自身构成的集合。对于式 {{eqref: eq:lec24:edge_barrier}} 中遍历所有表面边的求和，若只计入满足 $e_1 < e$ 的 $(e_1, e)$，或反过来，则可省略系数 $1/2$。

至此，我们对三维障碍势能有了两种离散化方式。为了在实践中同时使用它们，可以利用两者的线性组合，其系数通常可设为 $1/2$。

点-三角形距离与边-边距离同样都是具有解析解的小型优化问题，可以表示为分段光滑函数，就像式 {{eqref: eq:lec21:pw_pe_dist}} 中的二维点-边距离那样。
例如在点-三角形情形中，表达式可通过判断该点在三角形平面上的投影落在哪个区域来确定。

> {{def}}{def:lec24:pt_dist}[三维点-三角形距离] 点 $\mathbf{x}_p$ 与顶点为 $\mathbf{x}_{t1}$、$\mathbf{x}_{t2}$ 和 $\mathbf{x}_{t3}$ 的三角形之间的距离可定义为 $$ \text{arg}\min_{\beta_1,\beta_2} \|\mathbf{x}_p - (\mathbf{x}_{t1} + \beta_1 (\mathbf{x}_{t2} - \mathbf{x}_{t1}) + \beta_2 (\mathbf{x}_{t3} - \mathbf{x}_{t1})) \| \quad \text{s.t.} \quad \beta_1,\beta_2 \geq 0, \ \beta_1+\beta_2 \leq 1 $$

> {{def}}{def:lec24:ee_dist}[三维边-边距离] 端点为 $\mathbf{x}_{e1a}$ 和 $\mathbf{x}_{e1b}$ 的边与端点为 $\mathbf{x}_{e2a}$ 和 $\mathbf{x}_{e2b}$ 的边之间的距离可定义为
> $$ \text{arg}\min_{\beta_1,\beta_2} \| \mathbf{x}_{e1a} + \beta_1 (\mathbf{x}_{e1b} - \mathbf{x}_{e1a}) - (\mathbf{x}_{e2a} + \beta_2 (\mathbf{x}_{e2b} - \mathbf{x}_{e2a})) \| \quad \text{s.t.} \quad \beta_1,\beta_2 \in [0,1] $$

> **{{rem}}{rem:lec24:smoothness}[三维距离函数的平滑性]** 注意，点-三角形距离处处至少是 $C^1$ 连续的。这意味着即使投影点落在分段函数的边界上，距离梯度仍然存在且连续。然而对于边-边距离，当两条边平行时，距离函数仅为 $C^0$ 连续，因为相邻区域中表达式的梯度并不一致。为解决这一问题，增量势能接触（Incremental Potential Contact，IPC） {{#cite li2020incremental}} 提出在边-边障碍能量密度函数上乘以一个磨光函数（mollifier），使势能在处处为 $C^1$ 连续。当两条边趋于平行时，该磨光函数平滑地减至零。这保证了基于梯度的优化方法仍可被高效地用于求解该问题。
