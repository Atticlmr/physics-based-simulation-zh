## 弹性项

对于式 {{eqref: eq:lec19:discrete_weak_form_BE}} 中离散弱形式系统里的弹性项 $\int_{\Omega^0} N_{\hat{a},j}(\mathbf{X}) P_{\hat{i}j}(\mathbf{X}, t^n) d\mathbf{X}$，我们可以把它写成各三角形 $e$ 上积分之和的向量形式：

$$
\begin{aligned}
& \int_{\Omega^0} N_{\hat{a},j}(\mathbf{X}) P_{\hat{i}j}(\mathbf{X}, t^n) d\mathbf{X} = \int_{\Omega^0} (\mathbf{P}(\mathbf{X}, t^n) \nabla^{\mathbf{X}} N_{\hat{a}}(\mathbf{X}))_{\hat{i}} \ d\mathbf{X} \\
& = \sum_{e \in \mathcal{T}} \int_{\Omega^0_e} (\mathbf{P}(\mathbf{X}, t^n) \nabla^{\mathbf{X}} N_{\hat{a}}(\mathbf{X}))_{\hat{i}} \ d\mathbf{X}.
\end{aligned}
{{numeq}}{eq:lec19:elastic_integral}
$$

类似地，这一求和也只需涉及节点 $\hat{a}$ 的关联三角形。

回忆[应变能](../../hyperelasticity/strain-energy/strain_energy.md)一节，要计算第一类 Piola-Kirchhoff 应力 $\mathbf{P}(\mathbf{X}, t^n)$，我们只需要变形梯度 $\mathbf{F}(\mathbf{X}, t^n)$。由[运动学](../3d-elastodynamics/kinematics.md)一节可知 $\mathbf{F} = \frac{\partial \mathbf{x}}{\partial \mathbf{X}}$。以参数空间变量 $(\beta, \gamma)$ 为中间变量应用链式法则，可得：

$$
\begin{aligned}
&\mathbf{F} = \frac{\partial \mathbf{x}}{\partial (\beta, \gamma)} \left(\frac{\partial \mathbf{X}}{\partial (\beta, \gamma)}\right)^{-1} 
\approx \frac{\partial \hat{\mathbf{x}}}{\partial (\beta, \gamma)} \left(\frac{\partial \mathbf{X}}{\partial (\beta, \gamma)}\right)^{-1} \\
& = [\mathbf{x}_2 - \mathbf{x}_1, \mathbf{x}_3 - \mathbf{x}_1] [\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1]^{-1},
\end{aligned}
{{numeq}}{eq:lec19:compute_F}
$$

这与我们早先实现中的式 {{eqref: eq:lec15:compute_F}}（见[无翻转弹性](../../hyperelasticity/case-study-inversion-free-elasticity/inv_free_elasticity.md)一节）完全相同。这里我们还可以看到，采用线性有限元时，变形梯度场在 $\Omega^0$ 上分段常值，$\mathbf{P}$ 也是如此。

接下来，对于 $\nabla^{\mathbf{X}} N_{\hat{a}}(\mathbf{X})$，根据 $\hat{a}$ 在三角形 $e$ 中的索引，我们同样可以借助参数空间变量推导得到：

$$
\begin{aligned}
    \nabla^{\mathbf{X}} N_1(\mathbf{X}) & = \frac{\partial (1 - \beta - \gamma)}{\partial \mathbf{X}} = \left(\frac{\partial (1 - \beta - \gamma)}{\partial (\beta, \gamma)} (\frac{\partial \mathbf{X}}{\partial (\beta, \gamma)})^{-1}\right)^T \\ 
    &= ([-1, -1] [\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1]^{-1})^T \\
    \nabla^{\mathbf{X}} N_2(\mathbf{X}) & = \frac{\partial \beta}{\partial \mathbf{X}} = \left(\frac{\partial \beta}{\partial (\beta, \gamma)} \left(\frac{\partial \mathbf{X}}{\partial (\beta, \gamma)}\right)^{-1}\right)^T \\
    = ([1, 0] [\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1]^{-1})^T \\
    \nabla^{\mathbf{X}} N_3(\mathbf{X}) & = \frac{\partial \gamma}{\partial \mathbf{X}} = \left(\frac{\partial \gamma}{\partial (\beta, \gamma)} \left(\frac{\partial \mathbf{X}}{\partial (\beta, \gamma)}\right)^{-1}\right)^T \\
    = ([0, 1] [\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1]^{-1})^T.
\end{aligned}
$$

由此还可以看出，$\mathbf{P}(\mathbf{X}, t^n) \nabla^{\mathbf{X}} N_{\hat{a}}(\mathbf{X})$ 在任意三角形 $e$ 内为常值，并且它等价于 $\frac{\partial \Psi_e}{\partial \mathbf{x}_{\hat{a}}}$，因为：

$$
\begin{aligned}
\frac{\partial \Psi_e}{\partial \mathbf{x}_{\hat{a}}} 
= \frac{\partial \Psi_e}{\partial \mathbf{F}} \frac{\partial \mathbf{F}}{\partial \mathbf{x}_{\hat{a}}}
= \mathbf{P} \nabla^{\mathbf{X}} N_{\hat{a}}.
\end{aligned}
$$

把 $\frac{\partial \Psi_e}{\partial \mathbf{x}_{\hat{a}}}$ 代入式 {{eqref: eq:lec19:elastic_integral}} 可得：

$$
\begin{aligned}
\int_{\Omega^0} N_{\hat{a},j}(\mathbf{X}) P_{\hat{i}j}(\mathbf{X}, t^n) d\mathbf{X} 
& = \sum_{e \in \mathcal{T}} \int_{\Omega^0_e} (\mathbf{P}(\mathbf{X}, t^n) \nabla^{\mathbf{X}} N_{\hat{a}}(\mathbf{X}))_{\hat{i}} \ d\mathbf{X} \\
& = \sum_{e \in \mathcal{T}} \int_{\Omega^0_e} \left(\frac{\partial \Psi_e}{\partial \mathbf{x}_{\hat{a}}}\right)_{\hat{i}} \ d\mathbf{X} \\
& = \sum_{e \in \mathcal{T}} A_e \left(\frac{\partial \Psi_e}{\partial \mathbf{x}_{\hat{a}}}\right)_{\hat{i}},
\end{aligned}
$$

这正是[无翻转弹性](../../hyperelasticity/case-study-inversion-free-elasticity/inv_free_elasticity.md)一节中计算节点弹性力的方式。这也说明，总弹性势能可以按 $\sum_{e \in \mathcal{T}} A_e \Psi_e$ 计算，而它在空间离散之前就是 $\int_{\Omega^0} \Psi(\mathbf{X}) d\mathbf{X}$。

> **{{rem}}{rem:lec19:linear_FEM_elasticity} [线性有限元]**
> 线性有限元指的是 $\mathbf{x}$ 是 $\mathbf{X}$ 的分段线性函数，但弹性模型仍然可以是非线性的，即 $\mathbf{P}$ 可以是 $\mathbf{F}$ 的非线性函数。
