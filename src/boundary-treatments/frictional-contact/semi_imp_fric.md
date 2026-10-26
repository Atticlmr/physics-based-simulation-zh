## 半隐式离散化

然而，将摩擦纳入优化时间积分仍然存在挑战。一个主要问题是摩擦力并非保守力，不存在一个良好定义的势能，使其梯度的相反数恰好给出摩擦力。换言之，隐式摩擦力不可积。没有势能，就无法执行回溯线搜索，从而对优化稳定性与收敛性的保证也会被破坏。

事实上，一个力是否具有良好定义的势能，其实取决于时间离散方式。例如在显式时间积分中，任何力 $f$ 在一个时间步内都是常数，因而具有势能 $-f^T x$。
受此启发，我们可以借助更聪明的时间离散方式使摩擦力变得可积。但若让摩擦力在一个时间步内保持常数，要获得高质量的结果就必然会限制时间步长的取值。因此，我们将摩擦力的一部分显式离散，从而构造出可积的半隐式摩擦力。

参照 IPC，我们在非线性优化过程中将法向力大小 $\lambda$（仅用于计算摩擦的那部分）与切向算子 $T$ 固定为上一个时间步 $n$ 的取值：$\lambda^n = \lambda(x^n)$、$T^n=T(x^n)$，于是摩擦力变得可积，其势能为
$$
    P_f(x) = \sum_{k} \mu \lambda_k^n f_0(\|\bar{\mathbf{v}}_k \hat{h}\|),
    {{numeq}}{eq:lec9:fric_potential}
$$
其中 $\bar{\mathbf{v}}_k = (T_k^n)^T v$、$\hat{h}I = (\partial v/\partial x)^{-1}$，且 
$$
    f_0(y) =
    \begin{cases}
        -\frac{y^3}{3\epsilon_v^2 \hat{h}^2} + \frac{y^2}{\epsilon_v \hat{h}} + \frac{\epsilon_v  \hat{h}}{3}, & y \in[0, \epsilon_v \hat{h})\\
     	y, & y \geq  \epsilon_v \hat{h},
    \end{cases}
    {{numeq}}{eq:lec9:f0}
$$
使得 $f'_0(y)=f_1(y/\hat{h})$。对大多数线性（多）步时间积分方法——包括隐式欧拉以及高阶后向差分公式等——$\hat{h}$ 都是时间步长 $h$ 的常数倍。
然后，对式 {{eqref: eq:lec9:fric_potential}} 关于 $x$ 求梯度，得到
$$
    -\nabla P_f(x) = -\sum_{k}\mu \lambda^n_k T^n_k f_1(\|\bar{\mathbf{v}}_k\|) \mathbf{s}(\bar{\mathbf{v}}_k),
    {{numeq}}{eq:lec9:fric_grad}
$$
这就是对光滑化后的摩擦力所做的半隐式离散，其中 $\lambda^n_k$ 与 $T^n_k$ 为显式项。
$P_f$ 的海森矩阵可计算为
$$
\begin{aligned}
    &\nabla^2 P_f(x) \nonumber \\
    =& \sum_{k}\mu \lambda^n_k T^n_k \Big(\frac{f'_1(\|\bar{\mathbf{v}}_k\|)\|\bar{\mathbf{v}}_k\| - f_1(\|\bar{\mathbf{v}}_k\|)}{\|\bar{\mathbf{v}}_k\|^3} \bar{\mathbf{v}}_k \bar{\mathbf{v}}_k^T
     + \frac{f_1(\|\bar{\mathbf{v}}_k\|)}{\|\bar{\mathbf{v}}_k\|}\mathbf{I}_{3}\Big) {T_k^n}^T \frac{\partial v}{\partial x}.
\end{aligned}
     {{numeq}}{eq:lec9:fric_hess}
$$

> **{{rem}}{rm:lec9:fric_grad_div0}**
> 在摩擦梯度与海森矩阵的表达式（式 {{eqref: eq:lec9:fric_grad}} 与式 {{eqref: eq:lec9:fric_hess}}）中，分母含有 $\|\mathbf{v}_k\|$；当接触点处没有相对滑动时，该值可能为 $0$。
> 为避免计算中除以 $0$，对摩擦梯度可推出
$$
     \frac{f_1(\|\bar{\mathbf{v}}_k\|)}{\|\bar{\mathbf{v}}_k\|} =
     \begin{cases}
     	-\frac{\|\bar{\mathbf{v}}_k\|}{\epsilon_v^2 } + \frac{2}{\epsilon_v}, & \|\bar{\mathbf{v}}_k\| \in[0, \epsilon_v)\\
     	1/\|\bar{\mathbf{v}}_k\|, & \|\bar{\mathbf{v}}_k\| \geq  \epsilon_v,
  \end{cases}
  {{numeq}}{eq:lec9:f1_term}
 $$
> 该式处处有良好定义，于是得到
 $$
     -\nabla P_{f,k}(x) = -\mu \lambda^n_k T^n_k \frac{f_1(\|\bar{\mathbf{v}}_k\|)}{\| \bar{\mathbf{v}}_k \|} \bar{\mathbf{v}}_k = 0 \quad \text{when} \quad \|\bar{\mathbf{v}}_k\| = 0.
 $$
> 对摩擦海森矩阵，可推出
 $$
     \frac{f'_1(\|\bar{\mathbf{v}}_k\|)\|\bar{\mathbf{v}}_k\| - f_1(\|\bar{\mathbf{v}}_k\|)}{\|\bar{\mathbf{v}}_k\|^2} =
     \begin{cases}
     	-1/\epsilon_v^2, & \|\bar{\mathbf{v}}_k\| \in[0, \epsilon_v)\\
     	-1/\|\bar{\mathbf{v}}_k\|^2, & \|\bar{\mathbf{v}}_k\| \geq  \epsilon_v,
  \end{cases}
  {{numeq}}{eq:lec9:hess_term}
 $$
> 该式同样处处有良好定义；又因 $\|\bar{\mathbf{v}}_k\| = 0$ 时 $\bar{\mathbf{v}}_k \bar{\mathbf{v}}_k^T /\|\bar{\mathbf{v}}_k\| = \bm{0}$，可知
 $$
     \nabla^2 P_{f,k}(x) = \mu \lambda^n_k T^n_k \Big(\frac{f_1(\|\bar{\mathbf{v}}_k\|)}{\|\bar{\mathbf{v}}_k\|}\mathbf{I}_{3}\Big) {T_k^n}^T \frac{\partial v}{\partial x} \quad \text{when} \quad \|\bar{\mathbf{v}}_k\| = 0.
$$

> **{{rem}}{rm:lec9:friction_variations}**
> 本讲的摩擦公式与原始 IPC {{#cite li2020incremental}} 中的表述略有不同，共有两处：
> 1.  我们将相对滑动速度 $\mathbf{v}_k$ 而非 IPC 中的相对滑动位移 $\mathbf{u}_k = \hat{h} \mathbf{v}_k$ 直接作为光滑化函数 $f_1()$ 的输入，因此我们的 $f_1()$ 与 IPC 中的版本在分母所含的 $\hat{h}$ 上有所不同。当采用隐式欧拉之外的时间积分格式时（此时 $x^{n+1}-x^n \neq \hat{h} v^{n+1}$），仍把 $\mathbf{u}_k$ 称为相对滑动位移并不恰当，可能引起混淆。
> 2.  我们没有引入切向基来表示切空间中的相对滑动速度，因为在计算摩擦能量、梯度与海森矩阵时并不需要这样做。
