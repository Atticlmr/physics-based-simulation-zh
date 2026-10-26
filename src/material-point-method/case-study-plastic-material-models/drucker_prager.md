## Drucker-Prager 弹塑性

**Drucker-Prager** 塑性模型被广泛用于仿真沙子、土壤等颗粒材料。它对冯·米塞斯模型作了推广，引入了**摩擦角**，该角度决定了材料相对于法向应力能够承受多大的剪应力。从物理上看，这对应于颗粒之间的类库仑摩擦：当剪应力超过基于压力、与摩擦相关的界限时，材料即发生屈服。

在应力空间中，Drucker-Prager 屈服面呈**锥形**，需要分三种情形处理：
- **情形 I（弹性）**：应力严格位于锥体内部，不发生塑性。
- **情形 II（膨胀）**：应力对应的构形使材料发生体积膨胀（迹为正），且不施加任何抵抗——这映射到锥顶。
- **情形 III（剪切）**：应力位于锥体之外，但压力为压缩状态，必须投影回锥面。

该模型最好在<strong>对数应变（Hencky 应变）</strong>空间中、利用变形梯度的 SVD 来实现，这已在上一节中介绍过。

> {{exp}}{exp:lec27:drucker_prager_yield_criterion}[Drucker-Prager 屈服准则，对数应变形式]
> 我们将**对数应变**定义为：
>
> $$
\boldsymbol{\epsilon} = \log(\boldsymbol{\Sigma}) + \frac{1}{d} \log(J_\mathrm{vol}) \, \mathbf{I}.
$$
>
> 其偏斜部分为：
>
> $$
\hat{\boldsymbol{\epsilon}} = \boldsymbol{\epsilon} - \frac{1}{d} \, \text{tr}(\boldsymbol{\epsilon}) \, \mathbf{I}.
$$
>
> 塑性乘子按下式计算：
>
> $$
\Delta \gamma = \|\hat{\boldsymbol{\epsilon}}\| + \frac{(d\lambda + 2\mu)}{2\mu} \cdot \text{tr}(\boldsymbol{\epsilon}) \cdot \alpha.
$$
>
> 其中 $\alpha = \sqrt{\frac{2}{3}} \cdot \frac{2\sin\phi}{3 - \sin\phi}$ 是由摩擦角 $\phi$ 导出的 Drucker-Prager 摩擦系数。
>
> 随后我们执行返回映射：
> 
> - 若 $\text{tr}(\boldsymbol{\epsilon}) > 0$（情形 II），则投影到锥顶：令 $\boldsymbol{\epsilon} = 0$。
> - 若 $\Delta \gamma \le 0$，则位于锥体内部（情形 I）：不变。
> - 否则（情形 III），投影回锥面：
>
> $$
\boldsymbol{\epsilon}^{n+1} = \boldsymbol{\epsilon} - \frac{\Delta \gamma}{\|\hat{\boldsymbol{\epsilon}}\|} \, \hat{\boldsymbol{\epsilon}}.
$$
>
> 最后，我们计算更新后的奇异值：
>
> $$
\boldsymbol{\Sigma}_\mathrm{E}^{n+1} = \exp(\boldsymbol{\epsilon}^{n+1}),
$$
>
> 并重构弹性变形：
>
> $$
\mathbf{F}_\mathrm{E}^{n+1} = \mathbf{U} \, \text{diag}(\boldsymbol{\Sigma}_\mathrm{E}^{n+1}) \, \mathbf{V}^T.
$$

> {{exp}}{exp:lec30:drucker_prager_projection}[带体积修正的 Drucker-Prager 塑性]
>
> 对沙子这类颗粒材料，若处理不当，体积膨胀会导致**非物理的体积增大**。标准的 Drucker-Prager 投影在膨胀（迹为正）时把应力映射到锥顶，这对应于**无应力状态**。然而，这可能会不真实地把膨胀后的构形“锁定”为新的静止形状。
>
> 当颗粒先经历弹性膨胀、再经历塑性投影时，这种效应会导致体积持续膨胀。此后任何压缩都会产生人为的弹性惩罚，从而得到错误的材料响应。
>
> 为修正这一点，我们采用 {{#cite tampubolon2017multi}} 所述的体积修正处理，引入逐颗粒的标量累加量 $v_\mathrm{vol}$，用以跟踪塑性投影所引起的**对数体积变化**：
>
> $$
v_\mathrm{vol}^{n+1} = v_\mathrm{vol}^n - \log \det \mathbf{F}_\mathrm{E}^{n+1} + \log \det \mathbf{F}_\mathrm{trial}.
$$
>
> 该修正通过在执行返回映射之前调整应变，自然地融入**对数应变形式**：
>
> $$
\boldsymbol{\epsilon}_\text{corrected} = \boldsymbol{\epsilon}_\text{trial} + \frac{v_\mathrm{vol}}{d} \mathbf{I},
$$
>
> 其中 $d$ 为空间维数。这样，后续的压缩就能**抵消此前的体积增大**，而不会受到弹性抵抗。在下面的代码中，`diff_log_J` 提供了该体积修正项，它由行列式对数差的累加计算得到。

{{imp}}{imp:lec30:drucker_prager}[Drucker-Prager 弹塑性返回映射，simulator.py]
```python
{{#include ../../solid-sim-tutorial/11_mpm_plastic/simulator.py:drucker_prager}}
```

返回映射在颗粒状态更新时执行：

{{imp}}{imp:lec30:particle_update}[颗粒状态更新，simulator.py]
```python
{{#include ../../solid-sim-tutorial/11_mpm_plastic/simulator.py:particle_update}}
```
