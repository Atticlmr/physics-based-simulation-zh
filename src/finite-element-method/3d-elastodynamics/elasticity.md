## 弹性

对于弹性，与二维情形类似，变形梯度 $\mathbf{F}$ 在每个四面体内同样为常数，可以按如下方式计算
$$
\begin{aligned}
    \mathbf{F} = & \frac{\partial \mathbf{x}}{\partial (\beta, \gamma, \tau)} \left(\frac{\partial \mathbf{X}}{\partial (\beta, \gamma, \tau)}\right)^{-1} 
    \\
    \approx & \frac{\partial \hat{\mathbf{x}}}{\partial (\beta, \gamma, \tau)} \left(\frac{\partial \mathbf{X}}{\partial (\beta, \gamma, \tau)}\right)^{-1} \\
    =& [\mathbf{x}_2 - \mathbf{x}_1, \mathbf{x}_3 - \mathbf{x}_1, \mathbf{x}_4 - \mathbf{x}_1] [\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1, \mathbf{X}_4 - \mathbf{X}_1]^{-1}.
\end{aligned}
$$
在计算力与海森矩阵时，所需的 $\partial \mathbf{F} / \partial \mathbf{x}$ 可以用下式计算
$$
\begin{aligned}
    \nabla^\mathbf{X} N_1(\mathbf{X}) & = \frac{\partial (1 - \beta - \gamma - \tau)}{\partial \mathbf{X}} = \left(\frac{\partial (1 - \beta - \gamma - \tau)}{\partial (\beta, \gamma, \tau)} \left(\frac{\partial \mathbf{X}}{\partial (\beta, \gamma, \tau)}\right)^{-1}\right)^T \\
    & = ([-1, -1, -1] [\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1, \mathbf{X}_4 - \mathbf{X}_1]^{-1})^T
\end{aligned}
$$
类似地
$$
    \begin{aligned}
        \nabla^\mathbf{X} N_2(\mathbf{X}) & = \frac{\partial \beta}{\partial \mathbf{X}} = ([1, 0, 0] [\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1, \mathbf{X}_4 - \mathbf{X}_1]^{-1})^T,
        \\
        \nabla^\mathbf{X} N_3(\mathbf{X}) & = \frac{\partial \gamma}{\partial \mathbf{X}} = ([0, 1, 0] [\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1, \mathbf{X}_4 - \mathbf{X}_1]^{-1})^T,
        \\
        \nabla^\mathbf{X} N_3(\mathbf{X}) & = \frac{\partial \tau}{\partial \mathbf{X}} = ([0, 0, 1] [\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1, \mathbf{X}_4 - \mathbf{X}_1]^{-1})^T.
    \end{aligned}
$$
有了 $\mathbf{F}$，应变能 $\Psi$、应力 $\mathbf{P}$ 与应力导数 $\partial \mathbf{P}/\partial \mathbf{F}$ 的计算均可在[应变能](../../hyperelasticity/strain-energy/strain_energy.md)与[应力及其导数](../../hyperelasticity/stress-and-its-derivatives/stress_and_derivatives.md)中找到，而力与海森矩阵的计算遵循与二维相同的思路。

为保证仿真过程中四面体单元不发生翻转，可以逐个四面体求解一维方程，得到首次使任意四面体体积变为 $0$ 的临界步长 $\alpha^{I}$
$$
    V({\mathbf{x}_i + \alpha^I \mathbf{p}_i}) = 0,
$$
然后取所有求得的步长中的最小值。
这里 $\mathbf{p}_i$ 是节点 $i$ 的搜索方向，在三维中这等价于
$$
    \det([\mathbf{x}^\alpha_{21}, \mathbf{x}^\alpha_{31}, \mathbf{x}^\alpha_{41}]) \equiv (\mathbf{x}^\alpha_{21} \times \mathbf{x}^\alpha_{31}) \cdot \mathbf{x}^\alpha_{41} = 0
    {{numeq}}{eq:lec23:det_tri_equals_0}
$$
其中 $\mathbf{x}^\alpha_{ij} = \mathbf{x}_{ij} + \alpha^I \mathbf{p}_{ij}$，$\mathbf{x}_{ij} = \mathbf{x}_i - \mathbf{x}_j$，$\mathbf{p}_{ij} = \mathbf{p}_i - \mathbf{p}_j$。展开公式 {{eqref: eq:lec23:det_tri_equals_0}}，我们得到关于 $\alpha^I$ 的如下三次方程：

$$
\begin{aligned}
\big( (\mathbf{p}_{21} \times \mathbf{p}_{31}) \cdot \mathbf{p}_{41} \big) {\alpha^I}^3  \\+ \big( (\mathbf{x}_{21} \times \mathbf{p}_{31} + \mathbf{p}_{21} \times \mathbf{x}_{31}) \cdot \mathbf{p}_{41} + (\mathbf{p}_{21} \times \mathbf{p}_{31}) \cdot \mathbf{x}_{41} \big) {\alpha^I}^2 \\
+ \big( (\mathbf{x}_{21} \times \mathbf{p}_{31} + \mathbf{p}_{21} \times \mathbf{x}_{31}) \cdot \mathbf{x}_{41} + (\mathbf{x}_{21} \times \mathbf{x}_{31}) \cdot \mathbf{p}_{41} \big) \alpha^I \\ + (\mathbf{x}_{21} \times \mathbf{x}_{31}) \cdot \mathbf{x}_{41} = 0,
\end{aligned}
$$

该三次方程有时会退化为二次或一次方程，尤其是当节点运动并未显著改变四面体体积时。为应对潜在的数值不稳定，我们依据常数项系数对方程各项进行缩放：

$$
\begin{aligned}
&\frac{ (\mathbf{p}_{21} \times \mathbf{p}_{31}) \cdot \mathbf{p}_{41} }{(\mathbf{x}_{21} \times \mathbf{x}_{31}) \cdot \mathbf{x}_{41}} {\alpha^I}^3 \\ &+ \frac{ (\mathbf{x}_{21} \times \mathbf{p}_{31} + \mathbf{p}_{21} \times \mathbf{x}_{31}) \cdot \mathbf{p}_{41} + (\mathbf{p}_{21} \times \mathbf{p}_{31}) \cdot \mathbf{x}_{41} }{(\mathbf{x}_{21} \times \mathbf{x}_{31}) \cdot \mathbf{x}_{41}} {\alpha^I}^2 \\
&+ \frac{ (\mathbf{x}_{21} \times \mathbf{p}_{31} + \mathbf{p}_{21} \times \mathbf{x}_{31}) \cdot \mathbf{x}_{41} +(\mathbf{x}_{21} \times \mathbf{x}_{31}) \cdot \mathbf{p}_{41} }{(\mathbf{x}_{21} \times \mathbf{x}_{31}) \cdot \mathbf{x}_{41}} \alpha^I + 1 = 0,
\end{aligned}
{{numeq}}{eq:lec23:scaled_quad_eq_of_alphaI}
$$

从而保证可以用标准阈值（例如 $10^{-6}$）安全地进行量级检查。

实际实现中，我们还会留出一定的安全余量：求解使任意四面体体积减少 80% 的 $\alpha^I$，即把公式 {{eqref: eq:lec23:scaled_quad_eq_of_alphaI}} 中的常数项系数由 $1$ 改为 $0.8$。若找不到正实根，则可认为该步长是安全的，不会发生翻转。以下是求解该缩放三次方程的 C++ 代码片段：

{{imp}}{imp:lec23:cubic_solve}[三次方程求解器]
```c++
double getSmallestPositiveRealRoot_cubic(double a, double b, double c, double d,
    double tol)
{
    // return negative value if no positive real root is found
    double t = -1;

    if (abs(a) <= tol)
        t = getSmallestPositiveRealRoot_quad(b, c, d, tol); // covered in the 2D case
    else {
        complex<double> i(0, 1);
        complex<double> delta0(b * b - 3 * a * c, 0);
        complex<double> delta1(2 * b * b * b - 9 * a * b * c + 27 * a * a * d, 0);
        complex<double> C = pow((delta1 + sqrt(delta1 * delta1 - 4.0 * delta0 * delta0 * delta0)) / 2.0, 1.0 / 3.0);
        if (std::abs(C) == 0.0) // a corner case
            C = pow((delta1 - sqrt(delta1 * delta1 - 4.0 * delta0 * delta0 * delta0)) / 2.0, 1.0 / 3.0);

        complex<double> u2 = (-1.0 + sqrt(3.0) * i) / 2.0;
        complex<double> u3 = (-1.0 - sqrt(3.0) * i) / 2.0;

        complex<double> t1 = (b + C + delta0 / C) / (-3.0 * a);
        complex<double> t2 = (b + u2 * C + delta0 / (u2 * C)) / (-3.0 * a);
        complex<double> t3 = (b + u3 * C + delta0 / (u3 * C)) / (-3.0 * a);

        if ((abs(imag(t1)) < tol) && (real(t1) > 0))
            t = real(t1);
        if ((abs(imag(t2)) < tol) && (real(t2) > 0) && ((real(t2) < t) || (t < 0)))
            t = real(t2);
        if ((abs(imag(t3)) < tol) && (real(t3) > 0) && ((real(t3) < t) || (t < 0)))
            t = real(t3);
    }
    return t;
}
```
