# 线性有限元

从连续形式的控制方程出发，我们使用后向欧拉时间积分格式推导出了离散的弱形式系统（$nd$ 个方程）：

$$
\begin{aligned}
   & M_{\hat{a}b} \frac{x^n_{b|\hat{i}} - (x^{n-1}_{b|\hat{i}} + h V^{n-1}_{b|\hat{i}})}{\Delta t^2} \\
   & = \int_{\partial \Omega^0} N_{\hat{a}}(\mathbf{X}) T_{\hat{i}}(\mathbf{X}, t^n) \, ds(\mathbf{X}) - \int_{\Omega^0} N_{\hat{a}, j}(\mathbf{X}) P_{\hat{i}j}(\mathbf{X}, t^n) \, d\mathbf{X}.
\end{aligned}
{{numeq}}{eq:lec19:discrete_weak_form_BE}
$$
本章我们先在线性有限元的背景下讨论形函数 $N_{\hat{a}}$。这一探讨将有助于理解[无翻转弹性](../../hyperelasticity/case-study-inversion-free-elasticity/inv_free_elasticity.md)一节中详述的实现。

我们将专门关注单纯形有限元。在二维情形下，2-单纯形就是三角形，而本书自始至终都用三角形网格把固体域离散为一组互不相交的三角形单元。

> **{{def}}{def:lec19:simplex}[单纯形]**  
> n-单纯形是存在于 $n$ 维空间中的、具有 $n + 1$ 个顶点的几何对象，它无法容纳于任何更低维的空间中。