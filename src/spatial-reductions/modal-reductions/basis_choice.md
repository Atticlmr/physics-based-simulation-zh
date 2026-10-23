## 非线性变形下的基的选择

约化模型的质量取决于时不变基矩阵 $\mathbf{U} \in \mathbb{R}^{3n \times r}$ 的选取，前几章中我们假定了它的存在。该基经过预处理成为质量正交归一的（$\mathbf{U}^T\mathbf{M}\mathbf{U} = \mathbf{I}$），它必须能有效张成预期的非线性变形所在的空间。

### 由仿真数据构造基（POD）
这种数据驱动方法又称**本征正交分解**（Principal Orthogonal Directions，POD），它从已有的仿真数据中构造出最优基。

首先离线运行一次未降维的仿真，生成 $N$ 个变形状态向量 $\{\mathbf{u}_1, \mathbf{u}_2, ..., \mathbf{u}_N\}$。
随后把这些快照组装成矩阵 $\mathbf{A} = [\mathbf{u}_1, \mathbf{u}_2, ..., \mathbf{u}_N]$。通过对该矩阵做奇异值分解（SVD）来提取基，通常相对于质量加权内积 $\langle\mathbf{x}, \mathbf{y}\rangle_\mathbf{M} = \mathbf{x}^T\mathbf{M}\mathbf{y}$ 进行（这一技术称为质量-PCA）。分解 $\mathbf{A} = \mathbf{U}\Sigma\mathbf{V}^T$ 中对应最大 $r$ 个奇异值的 $\mathbf{U}$ 的列，就构成基 $\mathbf{U}$！

该方法对训练数据而言是最优的，但其主要缺点在于必须进行缓慢的离线预仿真。

### 由模态导数构造基
该方法通过分析系统的基本非线性响应来自动构造基，无需像 POD 那样做未降维的预仿真。

其关键洞见是：线性模态是一个不完备的基。当非线性系统沿某个线性模态的方向被激励时，由于非线性耦合，其他变形会**自然伴随出现**。模态导数正是这些耦合变形。

在数学上，我们分析沿线性模态 $\mathbf{U}_{lin}$ 方向施加力所产生的静态变形 $\mathbf{u}(\mathbf{p})$：$\mathbf{f}_{int}(\mathbf{u}) = \mathbf{M}\mathbf{U}_{lin}\mathbf{\Lambda}\mathbf{p}$，其中 $\mathbf{\Lambda}$ 是频率平方构成的对角矩阵，$\mathbf{p}$ 是参数向量。解 $\mathbf{u}(\mathbf{p})$ 可以在 $\mathbf{p}=\mathbf{0}$ 附近展开为二阶泰勒级数：

$$ \mathbf{u}(\mathbf{p}) = \sum_{i=1}^k \psi_i p_i + \frac{1}{2} \sum_{i=1}^k \sum_{j=1}^k \mathbf{\Phi}_{ij} p_i p_j + O(||\mathbf{p}||^3).$$


该展开揭示了系统的响应结构。一阶导数 $\psi_i = \frac{\partial \mathbf{u}}{\partial p_i}|_{\mathbf{p}=\mathbf{0}}$ 正是我们熟悉的线性振动模态，表示对施力的初始线性响应。关键的非线性耦合由二阶导数刻画，$$\mathbf{\Phi}_{ij} = \frac{\partial^2 \mathbf{u}}{\partial p_i \partial p_j}|_{\mathbf{p}=\mathbf{0}},$$ 它们被称为**模态导数**。每个 $\mathbf{\Phi}_{ij}$ 都是一个变形向量，可通过求解一个涉及常数静止状态刚度矩阵 $\mathbf{K}$ 的线性系统来计算。


完整的向量集合 $\{\psi_i, \mathbf{\Phi}_{ij}\}$ 通常规模过大。一个紧凑的 $r$ 维基 $\mathbf{U}$ 是这样得到的：收集全部线性模态与模态导数，对它们缩放以优先突出低频贡献，再用质量-PCA 提取最重要的组合形状。由此得到一个通用基，它无需事先了解运行时的外力，就能捕捉本质的非线性行为。

更多信息与推导请参阅 SIGGRAPH 课程讲义 {{#cite sifakis2012finite}}。
