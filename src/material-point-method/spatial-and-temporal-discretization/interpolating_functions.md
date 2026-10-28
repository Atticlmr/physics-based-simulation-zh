## 插值函数

在物质点法（Material Point Method，MPM）的每个时间步中，粒子先把自身的质量与动量传输到背景网格，随后又从网格取回更新后的速度以执行平流。两种传输都依赖**插值函数**来确定每个粒子与附近网格节点的相互作用方式。

我们把与网格节点 $\mathbf{i}$ 相关联的插值函数定义为 $N_\mathbf{i}(\mathbf{x})$。此处 $\mathbf{i}$ 是一个多重指标——二维时为 $(i, j)$，三维时为 $(i, j, k)$——而 $\mathbf{x}$ 是任意空间位置。在粒子位置 $\mathbf{x}_p$ 处求值该函数时，采用如下简记：

$$
w_{\mathbf{i}p} = N_\mathbf{i}(\mathbf{x}_p).
$$

该权重决定了粒子 $p$ 对网格节点 $\mathbf{i}$ 的影响强度：粒子离节点越近，$w_{\mathbf{i}p}$ 就越大。

> {{exp}}{exp:lec26:linear}[线性插值]
在一维中，最简单的插值函数选择是**线性（帐篷）函数**：
$$
N(x) =
\begin{cases}
1 - |x| & \text{if } 0 \leq |x| < 1, \\
0 & \text{otherwise}.
\end{cases}
$$
要在基于网格的框架中使用它，我们把空间坐标相对于**网格间距** $h$（即沿某一轴相邻网格节点之间的距离）进行缩放。缩放后的形式为：
$$
N\left( \frac{x_p - x_i}{h} \right).
$$
在更高维（二维、三维）中，我们使用一维函数的**张量积**：
$$
N_\mathbf{i}(\mathbf{x}_p) = N\left(\frac{x_p - x_i}{h}\right) \cdot N\left(\frac{y_p - y_j}{h}\right) \cdot N\left(\frac{z_p - z_k}{h}\right).
$$

线性插值计算高效、易于实现，在流体仿真的 FLIP {{#cite brackbill1988flip}} {{#cite bridson2015fluid}} 中被广泛使用。然而，当应用于 MPM 时，它存在两个严重问题：

1. 其梯度 $\nabla N(x)$ **不连续**，导致力的计算不稳定且带有噪声。
2. 当粒子靠近网格单元边界时，$w_{\mathbf{i}p}$ 变小而 $\nabla w_{\mathbf{i}p}$ 仍然很大，从而引发称为**跨单元不稳定性**的数值不稳定。
3. 函数的支撑域过窄，当相邻粒子没有共享足够的网格节点时容易发生**数值断裂**。

由于这些问题，MPM 中通常避免使用线性插值，在固体仿真中尤其如此。

> {{exp}}{exp:lec26:quad}[二次 B 样条插值]
更好的选择是**二次 B 样条**插值函数，它具有 $C^1$ 连续性（梯度连续）以及更宽的支撑域：
$$
N(x) =
\begin{cases}
\frac{3}{4} - x^2 & \text{if } |x| < \frac{1}{2}, \\
\frac{1}{2} \left( \frac{3}{2} - |x| \right)^2 & \text{if } \frac{1}{2} \leq |x| < \frac{3}{2}, \\
0 & \text{otherwise}.
\end{cases}
$$

二次 B 样条的支撑域宽度为 $3h$，能在粒子与网格之间提供平滑、稳定的相互作用。它计算高效，且比更高阶的 B 样条占用更少内存。

> {{exp}}{exp:lec26:cubic}[三次 B 样条插值]
若希望获得更好的平滑性与更宽的支撑域，可以使用**三次 B 样条**插值函数：
$$
N(x) =
\begin{cases}
\frac{1}{2} |x|^3 - |x|^2 + \frac{2}{3} & \text{if } 0 \leq |x| < 1, \\
\frac{1}{6}(2 - |x|)^3 & \text{if } 1 \leq |x| < 2, \\
0 & \text{otherwise}.
\end{cases}
$$

三次 B 样条的支撑域为 $[-2h, 2h]$，因此对数值断裂与不稳定更为鲁棒。不过，更宽的支撑域也意味着每个粒子会与更多网格节点相互作用，从而增加**传输过程中的计算开销**（例如质量、动量与力的传输）。选择插值核时，应当在平滑性与效率之间权衡。

### 插值函数的梯度

计算力时需要用到梯度。对于由张量积定义的高维插值函数，我们利用链式法则计算其梯度：
$$
\nabla N_\mathbf{i}(\mathbf{x}_p) =
\begin{pmatrix}
\frac{1}{h} N'\left(\frac{x_p - x_i}{h}\right) N\left(\frac{y_p - y_j}{h}\right) N\left(\frac{z_p - z_k}{h}\right) \\
N\left(\frac{x_p - x_i}{h}\right) \frac{1}{h} N'\left(\frac{y_p - y_j}{h}\right) N\left(\frac{z_p - z_k}{h}\right) \\
N\left(\frac{x_p - x_i}{h}\right) N\left(\frac{y_p - y_j}{h}\right) \frac{1}{h} N'\left(\frac{z_p - z_k}{h}\right)
\end{pmatrix}.
$$
这里 $N'(x)$ 是一维插值函数 $N(x)$ 的导数。
