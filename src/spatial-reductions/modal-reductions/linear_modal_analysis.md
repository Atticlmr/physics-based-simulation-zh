## 线性模态分析

我们从最简单的情形开始探讨模型降维：线弹性 {{eqref: eq:lec13:strain_energy_lin}}。尽管它局限于小变形，这一情形却能为子空间仿真的核心概念提供清晰而直观的入门。

### 振动模态的物理

物体并不会随意地变形，而是以若干特定特征模式的叠加形式振动，这些模式称为**模态**（mode）。其中每个基本模式称为一个**模态形状**（mode shape），它描述了物体可以采取的一种特定变形方式。整体运动则由各模态形状在任意时刻对总变形的贡献大小来描述；这一"贡献量"就是**模态幅值**（modal amplitude）。

每个模态都对应一个固有频率。低频模态对应幅度大、能量低的变形（例如音叉的基本弯曲），而高频模态则代表复杂、高能的振动，这类振动往往难以看清且迅速耗散。

关键洞见在于：物体可见动态行为的绝大部分都可以由少数几个低频模态描述。只要把仿真限制在这些重要模态上，我们就能构造出极为高效的近似。务必记住，这一方法仅在小变形下成立，此时材料的响应近似保持线性。也就是说，抵抗变形的内力与位移量成正比（这一关系通常由胡克定律描述）。在我们的离散设定中，这由常数刚度矩阵 $\mathbf{K}$ 刻画，它同时也是应变能海森矩阵的负值。对于大变形，刚度性质会随变形而改变，线性模态分析不再适用。


### 计算模态

求这些模态需要求解一个广义特征值问题。整个设置过程是：先定义完整系统，再施加约束。从现在起我们假定系统是三维的。
1. 首先组装完整的质量矩阵 $\mathbf{M} \in \mathbb{R}^{3n \times 3n}$ 与刚度矩阵 $\mathbf{K} \in \mathbb{R}^{3n \times 3n}$。
2. 为了计入狄利克雷边界条件（固定顶点），我们从 $\mathbf{M}$ 与 $\mathbf{K}$ 中删去对应于固定自由度的行与列，得到规模更小的约束矩阵 $\hat{\mathbf{M}}$ 与 $\hat{\mathbf{K}}$。

随后在这些约束矩阵上求解特征值问题：
$$
\hat{\mathbf{K}}\hat{\mathbf{\psi}}_i = \lambda_i \hat{\mathbf{M}}\hat{\mathbf{\psi}}_i.
{{numeq}}{eq:lec26:linear_system}
$$

> {{exp}}{exp:lec26:eigenproblem_intuition}[理解广义特征值问题]
> 方程 {{eqref:eq:lec26:linear_system}} 是理解机械系统振动的基础。我们逐项拆解：
> *   $\mathbf{K} \in \mathbb{R}^{3n \times 3n}$ 是完整的**刚度矩阵**。它把位移与内部弹性力联系起来（$\mathbf{f}_{elastic} = \mathbf{K}\mathbf{u}$）。$\mathbf{K}$ 中数值越大，表示物体越强烈地抵抗变形。
> *   $\mathbf{M} \in \mathbb{R}^{3n \times 3n}$ 是完整的**质量矩阵**。它把加速度与惯性力联系起来（$\mathbf{f}_{inertial} = \mathbf{M}\mathbf{a}$）。
> *   **特征向量** $\mathbf{\psi}_i \in \mathbb{R}^{3n}$ 是一个**模态形状**。它是一个描述某个特定振动模态空间形态的向量。
> *   **特征值** $\lambda_i \in \mathbb{R}$ 是对应模态 $\mathbf{\psi}_i$ 的**固有频率**的平方。

方程 $\mathbf{K}\mathbf{\psi}_i = \lambda_i \mathbf{M}\mathbf{\psi}_i$ 实质上说明：模态变形 $\mathbf{\psi}_i$ 是特殊的——若物体被变形为该形状，则弹性回复力（$\mathbf{K}\mathbf{\psi}_i$）与产生该形状正弦振动所需的惯性力（$\mathbf{M}\mathbf{\psi}_i$）恰好成正比。

**模态**就是弹性力与惯性力完全对齐的那些形状。低特征值对应低能模态，它们对视觉动画最为重要。

特征值求解器给出的结果是未约束自由度上的特征值 $\lambda_i$ 与特征向量 $\hat{\mathbf{\psi}}_i$。特征值即振动固有频率的平方，$\lambda_i = \omega_i^2$；特征向量则表示模态形状。为了检验特征值求解是否成功，常见做法是把各个模态按 $\mathbf{\psi}_i\sin(\omega_i t)$ 做动画可视化，其中 $t$ 为时间。

不同的模态向量通常被组装成一个**模态基矩阵**：

$$
\mathbf{U} = [\mathbf{\psi}_1, \dots, \mathbf{\psi}_r] \in \mathbb{R}^{3n \times r},
$$ 

其中我们选取对应最小非零特征值的 $r$ 个模态。



### 线性动力学的子空间仿真

现在来看模态基如何加速仿真。带阻尼的线弹性系统在完整空间中的运动方程为：

$$
\mathbf{M}\ddot{\mathbf{u}} + \mathbf{D}\dot{\mathbf{u}} + \mathbf{K}\mathbf{u} = \mathbf{f}_{ext},
{{numeq}}{eq:lec26:main_ode}
$$

其中 $\mathbf{D}$ 为阻尼矩阵，$\mathbf{f}_{ext}$ 为外力向量。为对该系统降维，我们引入子空间方法的核心近似：完整空间位移 $\mathbf{u}$ 用基向量的线性组合来近似：

$$
\mathbf{u}(t) \approx \mathbf{U}\mathbf{q}(t).
$$

这里 $\mathbf{q}(t) \in \mathbb{R}^r$ 是**约化坐标**（或**模态幅值**）向量，理想情况下 $r \ll 3n$。每个分量 $q_i(t)$ 表示时刻 $t$ 的变形中含有"多少"模态 $\mathbf{\psi}_i$。

为导出 $\mathbf{q}$ 的运动方程，我们把 $u(t)$ 的近似代入 {{eqref:eq:lec26:main_ode}}，并用 $\mathbf{U}^T$ 左乘整个方程，将其投影到子空间上：
$$
\mathbf{U}^T (\mathbf{M}(\mathbf{U}\ddot{\mathbf{q}}) + \mathbf{D}(\mathbf{U}\dot{\mathbf{q}}) + \mathbf{K}(\mathbf{U}\mathbf{q})) = \mathbf{U}^T\mathbf{f}_{ext}
$$
$$
(\mathbf{U}^T\mathbf{M}\mathbf{U})\ddot{\mathbf{q}} + (\mathbf{U}^T\mathbf{D}\mathbf{U})\dot{\mathbf{q}} + (\mathbf{U}^T\mathbf{K}\mathbf{U})\mathbf{q} = \mathbf{U}^T\mathbf{f}_{ext}.
$$
奇妙之处就在这里。得益于广义特征值问题的性质，特征向量可以被缩放为**质量正交归一**的，即 $\mathbf{\psi}_i^T\mathbf{M}\mathbf{\psi}_j = \delta_{ij}$（$i=j$ 时为 1，否则为 0）。



> **{{met}}{met:lec26:mass_orthonormalization}[特征向量的质量正交归一化]**
为得到 $\mathbf{U}^T\mathbf{M}\mathbf{U} = \mathbf{I}$ 这一简化，必须让模态基**质量正交归一**。这分两步完成。首先，广义特征值问题自然产生的特征向量是**M 正交**的，即对任意两个不同模态 $i$ 与 $j$ 有 $\mathbf{\psi}_i^T \mathbf{M} \mathbf{\psi}_j = 0$。该性质保证投影后质量矩阵的所有非对角元为零。其次，为使对角元等于 1，我们用求解器给出的每个原始特征向量 $\tilde{\mathbf{\psi}}_i$ 的质量加权长度对其显式归一化：
$$
\begin{aligned}
    \mathbf{\psi}_i = \frac{\tilde{\mathbf{\psi}}_i}{\sqrt{\tilde{\mathbf{\psi}}_i^T \mathbf{M} \tilde{\mathbf{\psi}}_i}}.
\end{aligned}
{{numeq}}{eq:lec26:mass_normalization}
$$
所得向量 $\mathbf{\psi}_i$ 满足 $\mathbf{\psi}_i^T \mathbf{M} \mathbf{\psi}_i = 1$，它们被组装成基 $\mathbf{U}$。M 正交性与 M 归一化共同保证投影后的质量矩阵为单位矩阵，而这正是使方程组解耦的原因。

这使投影后的矩阵被大幅简化：
*   $\mathbf{U}^T\mathbf{M}\mathbf{U} = \mathbf{I}$；
*   $\mathbf{U}^T\mathbf{K}\mathbf{U} = \mathbf{\Lambda}$，其中 $\mathbf{\Lambda}$ 为特征值构成的对角矩阵，即 $\text{diag}(\lambda_1, \dots, \lambda_r)$。

若假设采用**瑞利阻尼**，即 $\mathbf{D} = \alpha\mathbf{M} + \beta\mathbf{K}$，则投影后的阻尼矩阵也成为对角阵：
$$\mathbf{U}^T\mathbf{D}\mathbf{U} = \alpha\mathbf{I} + \beta\mathbf{\Lambda}.$$

这意味着最终的约化系统变成 $r$ 个完全独立的一维常微分方程：
$$
\ddot{q}_i + (\alpha + \beta\lambda_i)\dot{q}_i + \lambda_i q_i = \mathbf{\psi}_i^T \mathbf{f}_{ext} \quad \text{for } i=1, \dots, r.
{{numeq}}{eq:lec26:linear_system_simple}
$$


> {{met}}{met:lec10:linear_modal_simulation}[线性模态仿真]
我们可以把整个流程看作一次性预计算加上高效的运行时循环。
> 
> **预计算：**
> 1.  离散化物体，组装全局质量矩阵 $\mathbf{M}$ 与刚度矩阵 $\mathbf{K}$。
> 2.  对最小的 $r$ 个非零特征值 $\lambda_i$ 及其对应特征向量 $\mathbf{\psi}_i$，求解广义特征值问题 $\mathbf{K}\mathbf{\psi}_i = \lambda_i \mathbf{M}\mathbf{\psi}_i$。
> 3.  组装质量正交归一的基矩阵 $\mathbf{U} = [\mathbf{\psi}_1, \dots, \mathbf{\psi}_r]$。
> 
> **运行时循环（每个时间步）：**
> 1.  在完整空间中计算外力 $\mathbf{f}_{ext}$（例如来自重力、用户交互）。
> 2.  把力投影到约化基上：$\mathbf{f}_{reduced} = \mathbf{U}^T\mathbf{f}_{ext}$。
> 3.  对每个模态 $i=1, \dots, r$，求解其一维 ODE 方程 {{eqref:eq:lec26:linear_system_simple}} 以更新幅值 $q_i$。这可以用简单且稳定的隐式积分格式完成。
> 4.  为渲染重建完整空间中的变形：$\mathbf{u} = \mathbf{U}\mathbf{q}$。

计算量的节省是巨大的。我们不再求解一个庞大且耦合的 $3n \times 3n$ 系统，而是求解 $r$ 个极小且独立的一维方程，其中 $r$ 可能是 20-50，而 $3n$ 可能达到数万乃至数百万。



