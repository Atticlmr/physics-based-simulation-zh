## 离散时间


时间离散把 $\mathbf{A}$ 与自由度（Degree of Freedom，DOF）$\mathbf{x}$ 联系起来。在连续框架下，$\mathbf{A}(\mathbf{X}, t) = \frac{\partial^2 \mathbf{x}}{\partial t^2}(\mathbf{X}, t)$。现在，如第一章所述，我们把时间划分为若干小间隔 $t^0, t^2, \ldots, t^n, \ldots$。利用有限差分公式，我们可以方便地用 $\mathbf{x}$ 近似 $\mathbf{A}$。


例如，采用后向欧拉法：
$$
\begin{aligned}
\mathbf{A}^n(\mathbf{X}) &= \frac{\mathbf{V}^n(\mathbf{X}) - \mathbf{V}^{n-1}(\mathbf{X})}{t^n - t^{n-1}}, \\
\mathbf{V}^n(\mathbf{X}) &= \frac{\mathbf{x}^n(\mathbf{X}) - \mathbf{x}^{n-1}(\mathbf{X})}{t^n - t^{n-1}},
\end{aligned}
$$
由此得到：
$$
\mathbf{A}^n(\mathbf{X}) = \frac{\mathbf{x}^n(\mathbf{X}) - (\mathbf{x}^{n-1}(\mathbf{X}) + \Delta t \mathbf{V}^{n-1}(\mathbf{X}))}{\Delta t^2},
$$
其中 $\Delta t = t^n - t^{n-1}$。将这一关系在采样点处代入公式 {{eqref: eq:lec17:test_func_chosen}}，得到：
$$
\begin{aligned}
& M_{\hat{a}b} \frac{x^n_{b|\hat{i}} - (x^{n-1}_{b|\hat{i}} + \Delta t V^{n-1}_{b|\hat{i}})}{\Delta t^2} \\
&= \int_{\partial\Omega^0} N_{\hat{a}}(\mathbf{X}) T_{\hat{i}}(\mathbf{X}, t^n) ds(\mathbf{X}) - \int_{\Omega^0} N_{\hat{a},j}(\mathbf{X}) P_{\hat{i}j}(\mathbf{X}, t^n) d\mathbf{X}.
\end{aligned}
{{numeq}}{eq:lec17:BE}
$$

随后，施加质量集中与零面力边界条件，即 $\mathbf{T}(\mathbf{X}, t) = \mathbf{0}$，我们最终看到：公式 {{eqref: eq:lec17:BE}} 正是[第一讲](../../simulation-with-optimization/discrete-space-and-time/discrete_space_time.md)中后向欧拉时间积分离散形式的第 $(\hat{a}d+\hat{i})$ 行：
$$
M (\mathbf{x}^{n+1} - (\mathbf{x}^n + \Delta t \mathbf{v}^n)) - \Delta t^2 f(\mathbf{x}^{n+1}) = 0,
$$
其中弹性力 $f(\mathbf{x})$ 由下式的求值得到：
$$
-\int_{\Omega^0} N_{\hat{a},j}(\mathbf{X}) P_{\hat{i}j}(\mathbf{X}, t) d\mathbf{X},
$$
这将在下一章讨论。
