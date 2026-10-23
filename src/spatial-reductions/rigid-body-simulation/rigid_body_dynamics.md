## 刚体动力学

在进入 ABD 之前，让我们先回顾仿真刚体动力学的传统方法。

我们先回顾牛顿力学——具体来说，是质量为 $m$、位置为 $\bm{x}(t)$ 的质点所遵循的牛顿第二定律：

$$
\begin{aligned}
\frac{d \bm{x}}{d t} & = \bm{v}, \\
m\frac{d \bm{v}}{d t} & = \bm{f}.
\end{aligned}
$$

现在计算 $\frac{d (m \bm{x} \times \bm{v})}{dt}$：

$$
\begin{aligned}
\frac{d (m \bm{x} \times \bm{v})}{dt}
&= m\frac{d\bm{x}}{dt} \times \bm{v} + m\bm{x} \times \frac{d\bm{v}}{dt} \\
&= m\bm{v} \times \bm{v} + \bm{x} \times \bm{f} \\
&= \bm{0} + \bm{x} \times \bm{f} \\
&= \bm{x} \times \bm{f}.
\end{aligned}
$$

这里，$m\bm{x} \times \bm{v}$ 称为**角动量**，$\bm{x} \times \bm{f}$ 称为**力矩**。

对于刚体 $\mathcal{B}$，我们可以在其体积上积分：

$$
\frac{d}{dt}\left(\int_{\mathcal{B}} \rho \bm{x} \times \bm{v} \, d\bm{x}\right) = \int_{\mathcal{B}} \rho \bm{x} \times \bm{f}(\bm{x}) \, d\bm{x},
$$
其中 $\rho = \rho(\bm{x})$ 是 $\mathcal{B}$ 在位置 $\bm{x}$ 处的质量密度。

现在设 $\bm{c}$ 表示 $\mathcal{B}$ 的质心（center of mass，COM）。于是：

$$
\begin{aligned}
\frac{d}{dt}\left(\int_{\mathcal{B}} \rho \bm{c} \times \bm{v} \, d\bm{x}\right) 
&= \int_{\mathcal{B}} \rho \bm{c} \times \frac{d\bm{v}}{dt} \, d\bm{x} \\
&= \int_{\mathcal{B}} \rho \bm{c} \times \bm{f}(\bm{x}) \, d\bm{x}.
\end{aligned}
$$

将两者合并：

$$
\frac{d}{dt}\left(\int_{\mathcal{B}} \rho (\bm{x} - \bm{c}) \times \bm{v} \, d\bm{x}\right) = \int_{\mathcal{B}} \rho (\bm{x} - \bm{c}) \times \bm{f}(\bm{x}) \, d\bm{x}.
$$

由于 $\int_{\mathcal{B}} \rho (\bm{x} - \bm{c}) \times \bm{v}_{\bm{c}} d\bm{x} = (\int_{\mathcal{B}} \rho (\bm{x} - \bm{c}) d\bm{x}) \times \bm{v}_{\bm{c}} = \bm{0} \times \bm{v}_{\bm{c}} = \bm{0}$，我们可以进一步化简：

$$
\frac{d}{dt}\left(\int_{\mathcal{B}} \rho (\bm{x} - \bm{c}) \times (\bm{v} - \bm{v}_{\bm{c}}) \, d\bm{x}\right) = \int_{\mathcal{B}} \rho (\bm{x} - \bm{c}) \times \bm{f}(\bm{x}) \, d\bm{x},
$$
其中右端是绕质心的力矩 $\bm{\tau}$。

把右端记为力矩 $\bm{\tau}_{\bm{c}}$，计算左端：

$$
    \begin{aligned}
        \frac{d}{dt}(\int_{\mathcal{B}} \rho (\bm{x} - \bm{c}) \times (\bm{v} - \bm{v}_{\bm{C}}) d\bm{x}) &= \frac{d}{dt}(\int_{\mathcal{B}} \rho (\bm{x} - \bm{c}) \times (\bm{\omega} \times (\bm{x} - \bm{c})) d\bm{x}) \\ 
        &= \frac{d}{dt}(\int_{\mathcal{B}} \rho(\langle \bm{x} - \bm{c}, \bm{x} - \bm{c}\rangle \bm{\omega} - \langle \bm{x} - \bm{c},\bm{\omega}\rangle (\bm{x} - \bm{c}) )d\bm{x}) \\
        &= \frac{d}{dt}(\mathbf{I}_{\mathcal{B}}^{\bm{c}} \bm{\omega}).
    \end{aligned}
$$

这里，**惯性张量** $\mathbf{I}_{\mathcal{B}}^{\bm{c}}$ 定义为：

$$
\mathbf{I}_{\mathcal{B}}^{\bm{c}} := \int_{\mathcal{B}} \rho \left(\Vert\bm{x} - \bm{c}\Vert_2^2 \mathbb{I} - (\bm{x} - \bm{c})(\bm{x} - \bm{c})^T \right) d\bm{x}.
$$

由于 $\bm{x}$ 依赖于 $t$，$\mathbf{I}_{\mathcal{B}}^{\bm{c}}$ 也随之变化。设 $\mathbf{R}(t)$ 为旋转矩阵（即 $\mathcal{B}$ 从时刻 $0$ 到 $t$ 的旋转）。容易验证：

$$
\mathbf{I}_{\mathcal{B}}^{\bm{c}}(t) = \mathbf{R}(t)\mathbf{I}_{\mathcal{B}}^{\bm{c}}(0)\mathbf{R}(t)^T.
$$

求导可得：

$$
\bm{\tau}_{\bm{c}} = \bm{\omega} \times (\mathbf{I}^{\bm{c}} \bm{\omega}) + \mathbf{I}^{\bm{c}} \frac{d\bm{\omega}}{dt}.
$$

于是，刚体动力学定律变为：

$$
\begin{aligned}
\frac{d}{dt}(m\bm{v}_{\bm{c}}) &= \bm{f}, \\
\bm{\omega} \times (\mathbf{I}^{\bm{c}} \bm{\omega}) + \mathbf{I}^{\bm{c}} \frac{d\bm{\omega}}{dt} &= \bm{\tau}_{\bm{c}}.
\end{aligned}
{{numeq}}{eq:lec25:rigid_body_dynamics}
$$

这些方程与牛顿第二定律相似。第一式描述力如何影响刚体的线动量，第二式描述力矩如何影响其角动量。

用一个简单的显式积分器，我们可以按如下方式仿真刚体运动：

$$
\begin{aligned}
\bm{v}_{n+1} &= \bm{v}_n + \Delta t \frac{\bm{f}_n}{m}, \\
\bm{x}_{n+1} &= \bm{x}_n + \Delta t \bm{v}_n, \\
\bm{\omega}_{n+1} &= \bm{\omega}_n + \Delta t (\mathbf{I}^{\bm{c}})^{-1}(\bm{\tau}_{\bm{c}} - \bm{\omega} \times (\mathbf{I}^{\bm{c}} \bm{\omega})), \\
\hat{\bm{q}}_{n+1} &= \bm{q}_n + \frac{\Delta t}{2} \bm{\omega} \bm{q}_n, \\
\bm{q}_{n+1} &= \frac{\hat{\bm{q}}_{n+1}}{|\hat{\bm{q}}_{n+1}|}.
\end{aligned}
{{numeq}}{eq:lec25:rigid_body_explicit}
$$

这里，$\bm{q}$ 是表示刚体旋转的单位四元数。其更新基于一阶近似：

$$
\begin{aligned}
    \bm{\widetilde{q}} - \bm{q} &= e^{\frac{\Delta t}{2}\bm{\omega}} \bm{q}  - \bm{q}  \nonumber\\ 
    &= (\cos\frac{\Vert\bm{\omega}\Vert\Delta t}{2} - 1 + \frac{\bm{\omega}}{\Vert\bm{\omega}\Vert}\sin\frac{\Vert\bm{\omega}\Vert\Delta t}{2})\bm{q} \\ 
    &= (\Theta(\Delta t^2) + \frac{\Delta t}{2}\bm{\omega})\bm{q},
\end{aligned}
$$
由此可得：
$$
\lim_{\Delta t \to 0} \frac{\bm{\widetilde{q}} - \bm{q}}{\Delta t} = \frac{1}{2} \bm{w} \bm{q},
$$

其中 $\bm{w} = (\bm{\omega}_x, \bm{\omega}_y, \bm{\omega}_z, 0)$；$\bm{\widetilde{q}}$ 是把旋转向量 $\Delta t\bm{\omega}$ 所表示的旋转与 $\bm{q}$ 所表示的旋转复合起来的结果。

> **{{rem}}{rem:lec25:quaternion}[旋转向量到四元数]**
绕单位向量 $\bm{u} = (\bm{u}_x, \bm{u}_y, \bm{u}_z) = \bm{u}_x \bm{i} + \bm{u}_y \bm{j} + \bm{u}_z \bm{k}$ 所定义的轴旋转角度 $\theta$ 的旋转，可以用如下四元数表示
$$
\bm{q} = e^{\frac{\theta}{2}(\bm{u}_x \bm{i} + \bm{u}_y \bm{j} + \bm{u}_z \bm{k})} = \cos{\frac{\theta}{2}} + (\bm{u}_x \bm{i} + \bm{u}_y \bm{j} + \bm{u}_z \bm{k}) \sin{\frac{\theta}{2}} = \cos{\frac{\theta}{2}} + \bm{u}\sin{\frac{\theta}{2}}
$$
