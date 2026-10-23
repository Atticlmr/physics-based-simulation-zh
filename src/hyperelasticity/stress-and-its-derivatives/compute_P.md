## 计算 $\mathbf{P}$

我们从 $\mathbf{P}$ 的计算开始。对于各向同性材料，第一类 Piola-Kirchhoff 应力张量可按如下方式计算：
$$
\begin{aligned}
    \mathbf{P} & = \mathbf{U} \hat{\mathbf{P}} \mathbf{V}^T \\
    \text{where} \quad
    \mathbf{F} & = \mathbf{U} \bm{\Sigma} \mathbf{V}^T, \quad
    \Psi(\mathbf{F}) = \hat{\Psi}(\bm{\Sigma}), \quad \text{and} \quad
    \hat{P}_{ij} = \frac{\partial \hat{\Psi}}{\partial \sigma_i} \delta_{ij}.
\end{aligned}
{{numeq}}{eqn:PdiagonalSpace}
$$
该形式利用了 $\mathbf{P}$ 与 $\mathbf{F}$ 共享同一 SVD 空间这一性质，从而简化了推导与计算过程。

> **{{exp}}{exp:lec13:neo_hook_model}**
> 对于新胡克模型（式 {{eqref: eq:lec13:strain_density_NH}}），有：
$$
    \hat{\Psi}_{\text{NH}}(\bm{\Sigma}) = \frac{\mu}{2} \left(\sum_i^d \sigma_{i}^2 - d\right) - \mu \ln(J) + \frac{\lambda}{2} \ln^2(J).
$$
> 因此，我们可以先对 $\mathbf{F} = \mathbf{U} \bm{\Sigma} \mathbf{V}$ 执行 SVD，并由此得到：
$$
    \hat{P}_{ii} = \mu \left(\sigma_i - \frac{1}{\sigma_i}\right) + \lambda \ln(J) \frac{1}{\sigma_i}
$$
> 从而无需符号推导 $\Psi$ 关于 $\mathbf{F}$ 的导数，即可计算 $\frac{\partial \Psi}{\partial \mathbf{F}} = \mathbf{P} = \mathbf{U} \hat{\mathbf{P}} \mathbf{V}^T$。

这里我们给出 $\mathbf{P}$ 在对角空间中与旋转可交换的证明（见式 {{eqref: eqn:PdiagonalSpace}}）。为说明对任意旋转矩阵 $\mathbf{R}$ 都有 $\mathbf{P}(\mathbf{R}\mathbf{F}) = \mathbf{R}\mathbf{P}(\mathbf{F})$，考虑一个一般（可以是各向异性）的材料模型。关键在于，变形之后施加的旋转不改变材料储存的能量，因此有恒等式 $\Psi(\mathbf{F}) = \Psi(\mathbf{R}\mathbf{F})$。将该式两边对变形梯度 $\mathbf{F}$ 求导，得到：

$$
\begin{align*}
\delta \Psi &= \frac{\partial \Psi}{\partial \mathbf{F}}(\mathbf{F}) : \delta \mathbf{F} = \frac{\partial \Psi}{\partial \mathbf{F}}(\mathbf{R}\mathbf{F}) : \delta (\mathbf{R}\mathbf{F}), \\
\mathbf{P}(\mathbf{F}) : \delta \mathbf{F} &= \mathbf{P}(\mathbf{R}\mathbf{F}) : (\mathbf{R} \delta \mathbf{F}), \\
\mathbf{P}(\mathbf{F}) : \delta \mathbf{F} &= (\mathbf{R}^T \mathbf{P}(\mathbf{R}\mathbf{F})) : \delta \mathbf{F}, \\
\mathbf{P}(\mathbf{F}) &= \mathbf{R}^T \mathbf{P}(\mathbf{R}\mathbf{F}), \\
\mathbf{R} \mathbf{P}(\mathbf{F}) &= \mathbf{P}(\mathbf{R}\mathbf{F}).
\end{align*}
$$

此外，对于满足 $\Psi(\mathbf{F}\mathbf{R}) = \Psi(\mathbf{F})$ 的各向同性材料，类似的论证表明 $\mathbf{P}(\mathbf{F}\mathbf{R}) = \mathbf{P}(\mathbf{F})\mathbf{R}$。综合 $\mathbf{P}$ 在旋转下的这些关系，我们得到：
$$
\mathbf{P}(\mathbf{F}) = \mathbf{P}(\mathbf{U}\bm{\Sigma}\mathbf{V}^T) = \mathbf{U}\mathbf{P}(\bm{\Sigma})\mathbf{V}^T = \mathbf{U}\hat{\mathbf{P}}\mathbf{V}^T.
$$
该形式确认了 $\mathbf{P}$ 在对角空间中的旋转不变性。

### 关于 $\mathbf{P}(\bm{\Sigma})=\hat{\mathbf{P}}=\frac{\partial\hat{\Psi}}{\partial \Sigma}$ 的补充证明

上文中最后一个等号来自如下事实：
$$
\mathbf{P}(\mathbf{F}=\bm{\Sigma}) = \frac{\partial\hat{\Psi}}{\partial\bm{\Sigma}}.
$$
下面说明该式为何成立。

（1）首先，我们断言 $\mathbf{P}(\bm{\Sigma})$ 是对角矩阵。这可以从各向同性弹性的如下表达式看出：
$$
\mathbf{P}(\mathbf{F}) = \sum_k \frac{\partial \Psi}{\partial I_k}(\mathbf{F}) \frac{\partial I_k}{\partial \mathbf{F}}(\mathbf{F}),
$$
其中 $I_k$ 为各向同性不变量。参照 {{#cite sifakis2012finite}}（第 23 页），可以观察到：当自变量 $\mathbf{F}$ 为对角矩阵时，$\frac{\partial I_k}{\partial \mathbf{F}}(\mathbf{F})$ 必为对角矩阵。因此，当 $\mathbf{F}$ 为对角矩阵时，$\mathbf{P}(\mathbf{F})$ 也是对角矩阵。

（2）其次，我们断言
$$
\text{diag}\left(\frac{\partial \Sigma}{\partial F_{ij}}\right) = \text{diag}\left(\mathbf{U}^T \frac{\partial \mathbf{F}}{\partial F_{ij}} \mathbf{V}\right).
$$
该式在 {{#cite xu2015nonlinear}}（式 7）中已给出证明。


（3）基于（2），可知对任意 $ij$，代入 $\mathbf{F}=\bm{\Sigma}$ 后有
$$
\text{diag}\left(\frac{\partial \Sigma}{\partial F_{ij}}(\Sigma)\right) = \text{diag}\left(\mathbf{I}^T \frac{\partial \mathbf{F}}{\partial F_{ij}}(\Sigma) \mathbf{I}\right),
$$
利用此式可以写出 $ij=11, ij=22,ij=33$ 的情形。例如对 $ij=11$，有
$$
\frac{\partial \Sigma}{\partial F_{11}}(\Sigma) = \begin{pmatrix}
1 & * & * \\
* & 0 & *\\
* & * & 0 
\end{pmatrix}
$$

（4）最后，我们推导 $\mathbf{P}(\Sigma)$。由（1）已知它是对角矩阵，因此只需推导其对角元素。以 $11$ 元素为例：
$$
\begin{align*}
P_{ab}(\Sigma) &= \frac{\partial \hat{\Psi}}{\partial F_{ab}}(\Sigma)= \frac{\partial \hat{\Psi}}{\partial \Sigma}(\Sigma) : \frac{\partial\Sigma}{\partial F_{ab}}(\Sigma)\\
P_{11}(\Sigma) &= \frac{\partial \hat{\Psi}}{\partial \Sigma}(\Sigma) : \frac{\partial\Sigma}{\partial F_{11}}(\Sigma)\\
P_{11}(\Sigma) &= \begin{pmatrix}
\frac{\partial\hat{\Psi}}{\partial \sigma_1} &&\\
&\frac{\partial\hat{\Psi}}{\partial \sigma_1} &\\
&&\frac{\partial\hat{\Psi}}{\partial \sigma_1} \\
\end{pmatrix}
:
\begin{pmatrix}
1 & * & * \\
* & 0 & *\\
* & * & 0 
\end{pmatrix}
=\frac{\partial\hat{\Psi}}{\partial \sigma_1}
\end{align*}
$$
至此，最终证明完成。
