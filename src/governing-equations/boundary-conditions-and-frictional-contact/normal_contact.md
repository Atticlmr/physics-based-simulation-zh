## 非穿透的法向接触

为防止仿真过程中发生自相互穿透，必须施加一个条件，保证对任意 $t \geq 0$，变形映射 $\phi(\cdot, t): \Omega^0 \rightarrow \Omega^t$ 都是双射。该双射性由作用于相互接触的表面区域对（记作 $\Gamma_C$）上的边界力来维持。我们可以把这些力看作另一组诺伊曼边界条件：只有在需要防止相互穿透时，它们才在 $\Gamma_C$ 上施加额外的力。于是，我们可以将弱形式中的边界积分项扩展如下：

$$
\begin{aligned}
&\int_{\partial \Omega^0} \mathbf{Q}_i(\mathbf{X}, t) \mathbf{T}_i(\mathbf{X}, t) \, ds(\mathbf{X}) \\
&= \int_{\Gamma_D} \mathbf{Q}_i(\mathbf{X}, t) \mathbf{T}_{D|i}(\mathbf{X}, t) \, ds(\mathbf{X}) + \int_{\Gamma_N} \mathbf{Q}_i(\mathbf{X}, t) \mathbf{T}_{N|i}(\mathbf{X}, t) \, ds(\mathbf{X}) \\
&+ \int_{\Gamma_C} \mathbf{Q}_i(\mathbf{X}, t) \mathbf{T}_{C|i}(\mathbf{X}, t) \, ds(\mathbf{X}),
\end{aligned}
{{numeq}}{eq:lec18:boundary_int_with_contact}
$$

其中 $\mathbf{T}_N(\mathbf{X}, t)$ 是问题设置中给定的原始诺伊曼边界力，而 $\mathbf{T}_C(\mathbf{X}, t)$ 是由双射性约束产生的法向接触力。

与狄利克雷边界条件类似，$\mathbf{T}_C(\mathbf{X}, t)$ 只有在问题求解之后才能确定。然而，施加非相互穿透条件比指定位移更为复杂。所幸我们可以借助 IPC 中 $\mathbf{T}_C(\mathbf{X}, t)$ 的近似本构模型，把接触力表示为 $\mathbf{x}$ 的函数，从而只需引入这个额外的保守力即可保证非相互穿透。

> **{{rem}}{rem:lec18:contact_conditions}[重叠边界]**
> 注意，此处 $\Gamma_C$ 可以与 $\Gamma_D$ 和 $\Gamma_N$ 都发生重叠。对于与狄利克雷边界接触的自由（诺伊曼）边界，在施加狄利克雷边界条件时，狄利克雷部分上的 $\mathbf{T}_C(\mathbf{X}, t)$ 同样会被忽略。但是，如果两个狄利克雷边界相互穿透，则问题在双射性约束下无解。