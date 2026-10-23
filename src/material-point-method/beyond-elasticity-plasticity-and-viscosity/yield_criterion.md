## 屈服条件与返回映射

为了在离散的时间与空间上施加屈服条件与流动法则，我们采用一种称为**返回映射**的算法。这是一种基于投影的算法，它修正弹性变形梯度，使由此得到的应力满足屈服条件。

### 返回映射

设 $\mathbf{F}_\mathrm{tr}$ 表示**试探弹性变形梯度**，它在[粒子状态更新](../spatial-and-temporal-discretization/particle_state_update.md)之后、施加塑性之前得到。若由 $\mathbf{F}_\mathrm{tr}$ 计算出的应力位于屈服面**内部**，则变形是纯弹性的，无需任何修正。

若应力位于屈服面**外部**，我们就施加返回映射来修正试探弹性状态：沿着塑性流动法则所指定的方向，把 $\mathbf{F}_{\mathrm{tr}}$ 引起的应力投影回屈服面。将返回映射的结果记为：

$$
\mathbf{F}_\mathrm{E}^{n+1} = \mathcal{Z}(\mathbf{F}_\mathrm{tr}),
$$

其中 $\mathcal{Z}(\cdot)$ 为**返回映射算子**，它依据屈服面的几何形状与材料模型对弹性预测子进行修正。

在实践中，返回映射既可以解析地实现（适用于冯·米塞斯、Drucker-Prager 等简单屈服准则），也可以在屈服面复杂时通过数值求解器迭代实现。

> {{exp}}{exp:lec27:von_mises_log_strain}[冯·米塞斯屈服准则，对数应变形式]
>
> 在基于对数应变的塑性理论中，返回映射在 SVD 对角化后的空间中进行。设 $\mathbf{F}^{n+1} = \mathbf{U} \boldsymbol{\Sigma} \mathbf{V}^T$，$\boldsymbol{\sigma}_p^n$ 为已存储的塑性对数应变。试探弹性拉伸为：
> $$
\boldsymbol{\Sigma}_\mathrm{tr} = \boldsymbol{\Sigma} \cdot \left( \exp(\boldsymbol{\sigma}_p^n) \right)^{-1}, \quad
\boldsymbol{\epsilon}_\mathrm{tr} = \log(\boldsymbol{\Sigma}_\mathrm{tr}).
$$
> 计算偏斜对数应变：
> $$
\boldsymbol{\epsilon}_\mathrm{dev} = \boldsymbol{\epsilon}_\mathrm{tr} - \frac{1}{d} \, \text{tr}(\boldsymbol{\epsilon}_\mathrm{tr}) \, \mathbf{I}.
$$
> 若 $\| \boldsymbol{\epsilon}_\mathrm{dev} \| > \sqrt{2/3} \, \epsilon_Y$，则执行径向返回：
> $$
\boldsymbol{\epsilon}_\mathrm{dev}^{n+1} = \left( 1 - \frac{ \| \boldsymbol{\epsilon}_\mathrm{dev} \| - \sqrt{2/3} \epsilon_Y }{ \| \boldsymbol{\epsilon}_\mathrm{dev} \| } \right) \boldsymbol{\epsilon}_\mathrm{dev}.
$$
> 修正后的弹性对数应变为：
> $$
\boldsymbol{\epsilon}_\mathrm{log}^{n+1} = \boldsymbol{\epsilon}_\mathrm{dev}^{n+1} + \frac{1}{d} \, \text{tr}(\boldsymbol{\epsilon}_\mathrm{tr}) \, \mathbf{I}.
$$
> 然后更新：
> $$
\boldsymbol{\Sigma}_\mathrm{E}^{n+1} = \exp(\boldsymbol{\epsilon}_\mathrm{log}^{n+1}), \quad
\boldsymbol{\sigma}_p^{n+1} = \log(\boldsymbol{\Sigma}) - \log(\boldsymbol{\Sigma}_\mathrm{E}^{n+1}),
$$
> 并重建弹性变形：
> $$
\mathbf{F}_\mathrm{E}^{n+1} = \mathbf{U} \boldsymbol{\Sigma}_\mathrm{E}^{n+1} \mathbf{V}^T.
$$
