## 计算 $\partial\mathbf{P} /\partial\mathbf{F}$ 或 $\delta\mathbf{P}$

为计算 $\mathbf{P}$ 关于 $\mathbf{F}$ 的导数，我们利用前文针对 $\mathbf{P}$ 讨论过的旋转不变性。任取两个旋转矩阵 $\mathbf{R}$ 与 $\mathbf{Q}$。由 $\mathbf{P}$ 的旋转性质可得：

$$
\mathbf{P}(\mathbf{F}) = \mathbf{P}(\mathbf{R}\mathbf{R}^T \mathbf{F} \mathbf{Q} \mathbf{Q}^T) = \mathbf{R} \mathbf{P}(\mathbf{R}^T \mathbf{F} \mathbf{Q}) \mathbf{Q}^T.
$$

定义 $\mathbf{K} = \mathbf{R}^T \mathbf{F} \mathbf{Q}$，则有：

$$
\mathbf{P}(\mathbf{F}) = \mathbf{R} \mathbf{P}(\mathbf{K}) \mathbf{Q}^T.
$$

将 $\mathbf{R}$ 与 $\mathbf{Q}$ 视为常量，对 $\mathbf{P}$ 取微分，得：

$$
\delta\mathbf{P} = \mathbf{R} \left[\frac{\partial\mathbf{P}}{\partial\mathbf{F}}(\mathbf{K}) : \delta(\mathbf{K})\right] \mathbf{Q}^T = \mathbf{R} \left[\frac{\partial\mathbf{P}}{\partial\mathbf{F}}(\mathbf{K}) : (\mathbf{R}^T \delta\mathbf{F} \mathbf{Q})\right] \mathbf{Q}^T.
$$

令 $\mathbf{R} = \mathbf{U}$、$\mathbf{Q} = \mathbf{V}$，此时 $\mathbf{K} = \bm{\Sigma}$，微分表达式简化为：

$$
\delta\mathbf{P} = \mathbf{U} \left[\frac{\partial\mathbf{P}}{\partial\mathbf{F}}(\bm{\Sigma}) : (\mathbf{U}^T \delta\mathbf{F} \mathbf{V})\right] \mathbf{V}^T.
$$

张量导数 $\partial\mathbf{P}/\partial\mathbf{F}$ 用指标记法表示为：

$$
(\delta\mathbf{P})_{ij} = U_{ik} \left(\frac{\partial\mathbf{P}}{\partial\mathbf{F}}(\bm{\Sigma})\right)_{klmn} U_{rm} \delta F_{rs} V_{sn} V_{jl}, \quad \text{and} \quad
(\delta\mathbf{P})_{ij} =\left(\frac{\partial\mathbf{P}}{\partial\mathbf{F}}(\mathbf{F})\right)_{ijrs} \delta F_{rs}.
$$

这些表达式对任意 $\delta\mathbf{F}$ 都必须成立，由此得到关系式：

$$
\left(\frac{\partial\mathbf{P}}{\partial\mathbf{F}}(\mathbf{F})\right)_{ijrs} = \left(\frac{\partial\mathbf{P}}{\partial\mathbf{F}}(\bm{\Sigma})\right)_{klmn} U_{ik} U_{rm} V_{sn} V_{jl}.
$$

于是剩下的任务就是计算 $\frac{\partial\mathbf{P}}{\partial\mathbf{F}}(\bm{\Sigma})$。下面说明在三维情形下如何计算。

首先介绍罗德里格斯旋转公式（Rodrigues' rotation formula），它给出了用单位向量 $\mathbf{k}$ 与旋转角 $\theta$ 表示任意旋转矩阵的方法。该公式为：
$$
\mathbf{R}=\mathbf{I}+\sin(\theta)\mathbf{K}+(1-\cos(\theta))\mathbf{K}^2, {{numeq}}{eqn:rodrigues}
$$
其中 $\mathbf{K}$ 是与 $\mathbf{k}$ 关联的反对称叉乘矩阵。该公式表明，任意旋转矩阵仅由三个自由度刻画，记为 $r_1, r_2, r_3$。这些分量用于定义旋转向量 $\mathbf{r}$，$\mathbf{k}$ 与 $\theta$ 则由其按如下方式得到：

$$
\mathbf{k} = \frac{\mathbf{r}}{|\mathbf{r}|}, \quad \theta = |\mathbf{r}|.
$$

采用这种参数化，旋转矩阵 $\mathbf{U}$ 与 $\mathbf{V}$ 各可由三个参数描述。

现在我们用如下代码，以
$s1$、$s2$、$s3$、$u1$、$u2$、$u3$、$v1$、$v2$、$v3$ 定义 $\mathbf{F}$，其中 $\mathbf{U}$ 与 $\mathbf{V}$ 由 $u_i$ 与 $v_i$ 借助罗德里格斯旋转公式定义，
$s_i$ 是来自 $\bm{\Sigma}$ 的奇异值。

```
id=IdentityMatrix[3];
var={s1,s2,s3,u1,u2,u3,v1,v2,v3};
Sigma=DiagonalMatrix[{s1,s2,s3}];
cp[k1_,k2_,k3_]={{0,-k3,k2},{k3,0,-k1},{-k2,k1,0}};
vV={v1,v2,v3};
vU={u1,u2,u3};
nv=Sqrt[Dot[vV,vV]];
nu=Sqrt[Dot[vU,vU]];
UU=cp[u1,u2,u3]/nu;
VV=cp[v1,v2,v3]/nv;
U=id+Sin[nu]*UU+(1-Cos[nu])*UU.UU;
V=id+Sin[nv]*VV+(1-Cos[nv])*VV.VV;
F=U.Sigma.Transpose[V];
```
其中 cp 是生成叉乘矩阵的函数（对应于计算
方程 {{eqref: eqn:rodrigues}} 中的 $\mathbf{K}$）。

此后，我们把 $3\times 3\times 3\times 3$ 张量
$\frac{\partial\mathbf{P}}{\partial\mathbf{F}}(\bm{\Sigma})$ 以及其他同类张量写成 $9 \times 9$ 矩阵。
也就是说，每个 $3 \times 3$ 矩阵现在是一个长度为 $9$ 的向量。容易看出，原来的
$\frac{\partial P_{ij}}{\partial F_{kl}}$ 现在变为
$\frac{\partial P_{3(i-1)+j}}{\partial F_{3(k-1)+l}}$。我们进一步称向量 $\mathbf{S}=\{s1,s2,s3,u1,u2,u3,v1,v2,v3\}$ 为 $\mathbf{F}$ 的参数化。于是可以应用链式法则
$$
\frac{\partial\mathbf{P}}{\partial\mathbf{F}}(\bm{\Sigma})=\frac{\partial\mathbf{P}}{\partial\mathbf{S}}(\bm{\Sigma})\frac{\partial\mathbf{S}}{\partial\mathbf{F}}(\bm{\Sigma})
$$

下面是计算它们的 Mathematica 代码。注意，我们通过取极限 $\{u1,u2,u3,v1,v2,v3\}=+\epsilon$ 来得到 $\mathbf{F}=\bm{\Sigma}$，
这对应于旋转几乎为零的情形。
```language=Mathematica
dFdS=D[Flatten[F],{var}];
dFdS0=dFdS/.{u1->e,u2->e,u3->e,v1->e,v2->e,v3->e};
dFdS1=Limit[dFdS0,e->0,Direction->-1];
dSdF0=Inverse[dFdS1];
Phat=DiagonalMatrix[{t1[s1,s2,s3],t2[s1,s2,s3],t3[s1,s2,s3]}];
P=U.Phat.Transpose[V];
dPdS=D[Flatten[P],{var}];
dPdS0=dPdS/.{u1->e,u2->e,u3->e,v1->e,v2->e,v3->e};
dPdS1=Limit[dPdS0,e->0,Direction->-1];
dPdF=Simplify[dPdS1.dSdF0];
```
注意，Mathematica 中的 'Direction->-1' 表示从较大值一侧取极限趋向较小的极限值。Mathematica 的计算结果将以奇异值与
$\hat{\mathbf{P}}$ 表示。随后即可据此写出公式，在代码中实现它们。
{{#cite stomakhin2012energetically}} 给出了结果：$\frac{\partial\mathbf{P}}{\partial\mathbf{F}}(\bm{\Sigma})$（尺寸为 $9
\times 9$ 的矩阵）经置换后成为分块对角矩阵，对角块为 $\mathbf{A}^{3\times 3},\mathbf{B}_{12}^{2\times 2},\mathbf{B}_{13}^{2\times 2},\mathbf{B}_{23}^{2\times 2}$，其中
$$
\mathbf{A} = \left(
\begin{array}{ccc}
\hat{\Psi}_{,\sigma_1 \sigma_1} & \hat{\Psi}_{,\sigma_1 \sigma_2} & \hat{\Psi}_{,\sigma_1 \sigma_3} \\
\hat{\Psi}_{,\sigma_2 \sigma_1} & \hat{\Psi}_{,\sigma_2 \sigma_2} & \hat{\Psi}_{,\sigma_2 \sigma_3} \\
\hat{\Psi}_{,\sigma_3 \sigma_1} & \hat{\Psi}_{,\sigma_3 \sigma_2} & \hat{\Psi}_{,\sigma_3 \sigma_3}
\end{array}
\right)
$$
以及
$$
\mathbf{B}_{ij} = \frac{1}{\sigma_i^2-\sigma_j^2}\left(
\begin{array}{cc}
\sigma_i \hat{\Psi}_{,\sigma_i}-\sigma_j \hat{\Psi}_{,\sigma_j} & \sigma_j \hat{\Psi}_{,\sigma_i}-\sigma_i \hat{\Psi}_{,\sigma_j} \\
\sigma_j \hat{\Psi}_{,\sigma_i}-\sigma_i \hat{\Psi}_{,\sigma_j} & \sigma_i \hat{\Psi}_{,\sigma_i}-\sigma_j \hat{\Psi}_{,\sigma_j} 
\end{array}
\right).
$$
对于 $\mathbf{B}$ 中可能引入除零的项（在将它们完全化简之后），需要做分母钳制。
这里我们将 $\frac{\partial \hat{\Psi}}{\partial \sigma_i}$ 与 $\frac{\partial^2 \hat{\Psi}}{\partial \sigma_i\partial \sigma_j}$ 分别记为 $\hat{\Psi}_{,\sigma_i}$ 与 $\hat{\Psi}_{,\sigma_i\sigma_j}$。
当两个奇异值接近相等，或两个奇异值之和接近零时，除以 $\sigma_i^2-\sigma_j^2$ 会出问题。后者在允许奇异值取负的约定下是可能出现的
（如可逆弹性 {{#cite irving2004invertible}} {{#cite stomakhin2012energetically}}）。

将 $\mathbf{B}_{ij}$ 按部分分式展开，可得有用的分解
$$
\mathbf{B}_{ij} = \frac{1}{2}\frac{\hat{\Psi}_{,\sigma_i}-\hat{\Psi}_{,\sigma_j}}{\sigma_i-\sigma_j}\left(
\begin{array}{cc}
1 & 1\\
1 & 1
\end{array}
\right) + \frac{1}{2}\frac{\hat{\Psi}_{,\sigma_i}+\hat{\Psi}_{,\sigma_j}}{\sigma_i+\sigma_j}\left(
\begin{array}{cc}
1 & -1\\
-1 & 1
\end{array}
\right).
$$
注意，若 $\hat{\Psi}$ 在奇异值置换下不变，则当
$\sigma_i \rightarrow \sigma_j$ 时有 $\hat{\Psi}_{,\sigma_i} \rightarrow \hat{\Psi}_{,\sigma_j}$。因此，
只要实现得当，对于各向同性模型，第一项通常可以稳健地计算。而若当
$\sigma_i +\sigma_j \rightarrow 0$ 时 $\hat{\Psi}_{,\sigma_i} + \hat{\Psi}_{,\sigma_j} \rightarrow 0$，则另一分式也可稳健计算。
但这一条件通常并不成立，因为那意味着本构模型难以从退化或翻转的构形中恢复。
因此，该项在某些情形下会无界。
我们的处理办法是在做除法之前把分母的幅值钳制为不小于 $10^{-6}$，从而将导数限制在有界范围内。

在二维情形，旋转矩阵现在只需用单个 $\theta$ 参数化，其重构方式为

$$
\mathbf{R}=
\left(
\begin{array}{cc}
\cos\theta & -\sin\theta\\
\sin\theta & \cos\theta
\end{array}
\right).
$$
完整的二维 Mathematica 代码如下
```language=Mathematica
id=IdentityMatrix[2];
var={s1,s2,u1,v1};
S=DiagonalMatrix[{s1,s2}];
U={{Cos[u1],-Sin[u1]

},{Sin[u1],Cos[u1]}};
V={{Cos[v1],-Sin[v1]},{Sin[v1],Cos[v1]}};
F=U.S.Transpose[V];
dFdS=D[Flatten[F],{var}];
dFdS0=dFdS/.{u1->e,v1->e};
dFdS1=Limit[dFdS0,e->0,Direction->-1};
dSdF0=Inverse[dFdS1];
Phat=DiagonalMatrix[{t1[s1,s2],t2[s1,s2]}];
P=U.Phat.Transpose[V];
dPdS=D[Flatten[P],{var}];
dPdS0=dPdS/.{u1->e,v1->e};
dPdS1=Limit[dPdS0,e->0,Direction->-1];
dPdF=Simplify[dPdS1.dSdF0];
```
其中 $\mathbf{A}$ 现在也是 $2\times 2$，且只有一个 $\mathbf{B}$。
