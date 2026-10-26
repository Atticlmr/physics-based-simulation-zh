# 应变能

既然变形梯度 $\mathbf{F}$ 可以作为局部变形的严格数学度量，我们便能基于 $\mathbf{F}$ 定义弹性势能，从而更准确地刻画固体的弹性行为。$\mathbf{F}$ 是在固体域内每个局部点上度量的。我们会对每个点局部度量弹性势，再把弹性势在整个域上积分。这一做法与 [二维质点-弹簧系统](../../simulation-with-optimization/case-study-2d-mass-spring/2d_mass_spring.md) 案例研究中的过程如出一辙——在那里，每根弹簧的能量按估计体积加权，在离散框架下求和。此处 $\mathbf{F}$ 也称为**应变**，而弹性势 $P_e$（称为**应变能**）则来自对固体域内每个物质点上的**应变能密度函数** $\Psi(\mathbf{F}) : \mathbb{R}^{d \times d} \rightarrow \mathbb{R}$ 进行积分：
$$
    P_e = \int_{\Omega_0} \Psi(\mathbf{F}) d\mathbf{X}.
$$
本讲将探讨 $\Psi(\mathbf{F})$ 的各种设计选择，并考察它们的一些性质。
