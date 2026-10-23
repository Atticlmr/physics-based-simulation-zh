## 运动学

与二维三角形单元类似，我们使用 $\beta, \gamma, \tau \in [0,1]$ 且 $\beta + \gamma + \tau \leq 1$ 来表示四面体单元内任意点 $\mathbf{X}$ 的材料空间坐标，该四面体由顶点 $\mathbf{X}_1, \mathbf{X}_2, \mathbf{X}_3,$ 与 $\mathbf{X}_4$ 定义如下：
$$
\begin{aligned}
    \mathbf{X}(\beta, \gamma, \tau) & = \mathbf{X}_1 + \beta (\mathbf{X}_2 - \mathbf{X}_1) + \gamma (\mathbf{X}_3 - \mathbf{X}_1) + \tau (\mathbf{X}_4 - \mathbf{X}_1) \\
    & = (1 - \beta - \gamma - \tau) \mathbf{X}_1 + \beta \mathbf{X}_2 + \gamma \mathbf{X}_3 + \tau \mathbf{X}_4.
\end{aligned}
$$
这里，$\mathbf{X}$ 是 $(\beta, \gamma, \tau)$ 的线性函数。使用线性形函数时，近似世界空间坐标 $\hat{\mathbf{x}}$ 同样是 $(\beta, \gamma, \tau)$ 的线性函数：
$$
\begin{aligned}
    \mathbf{x}(\beta, \gamma, \tau) \approx \hat{\mathbf{x}}(\beta, \gamma, \tau) = (1 - \beta - \gamma - \tau) \mathbf{x}_1 + \beta \mathbf{x}_2 + \gamma \mathbf{x}_3 + \tau \mathbf{x}_4,
\end{aligned}
$$
其中 $\mathbf{x}(\mathbf{X}_i)$ 记为 $\mathbf{x}_i$。这意味着形函数为：
$$
\begin{aligned}
    N_1(\beta, \gamma, \tau) &= 1 - \beta - \gamma - \tau, \\
    N_2(\beta, \gamma, \tau) &= \beta, \\
    N_3(\beta, \gamma, \tau) &= \gamma, \\
    N_4(\beta, \gamma, \tau) &= \tau.
\end{aligned}
$$
