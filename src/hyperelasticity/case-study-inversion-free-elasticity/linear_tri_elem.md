## 线性三角形单元

在前面的讨论中，我们学会了计算 $\Psi$ 及其关于 $\mathbf{F}$ 的导数。然而在仿真中，我们需要的是 $\frac{\partial \Psi}{\partial x}$ 与 $\frac{\partial^2 \Psi}{\partial x^2}$。这就要求我们清楚地理解 $\mathbf{F}(x)$，因为只有这样，我们才能有效地运用链式法则推导出这些关于 $x$ 的导数。

在二维仿真中，我们常常把固体区域划分为非退化的三角形单元。假设映射 $\mathbf{x} = \phi(\mathbf{X})$ 在每个三角形内是线性的，从而使变形梯度 $\mathbf{F}$ 保持为常数。参考 {{ref: exp:lec12:deformation_gradient}}，对于由顶点 $\mathbf{X}_1\mathbf{X}_2\mathbf{X}_3$ 定义的三角形，有：
$$
\mathbf{x}_2 - \mathbf{x}_1 = \mathbf{F} (\mathbf{X}_2 - \mathbf{X}_1) \quad \text{and} \quad
\mathbf{x}_3 - \mathbf{x}_1 = \mathbf{F} (\mathbf{X}_3 - \mathbf{X}_1),
$$
其中 $\mathbf{x}_i$ 表示三角形顶点的世界空间坐标。这一关系给出 $\mathbf{F}$ 的表达式：
$$
\mathbf{F} = [\mathbf{x}_2 - \mathbf{x}_1, \mathbf{x}_3 - \mathbf{x}_1] [\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1]^{-1}.
{{numeq}}{eq:lec15:compute_F}
$$
式 {{eqref: eq:lec15:compute_F}} 表明，这里得到的 $\mathbf{F}$ 通过三角形边 $\mathbf{X}_2 - \mathbf{X}_1$ 与 $\mathbf{X}_3 - \mathbf{X}_1$ 的线性组合，把三角形内的任意线段映射到其世界空间中的对应线段。该公式更一般、更严格的推导将在后续章节中给出。

一旦建立了 $\mathbf{F}(x)$，我们就可以对每个三角形计算它关于 $x$ 的导数如下：
$$
\frac{\partial [\mathbf{F}_{11}, \mathbf{F}_{21}, \mathbf{F}_{12}, \mathbf{F}_{22}]^T}{\partial [\mathbf{x}_1^T, \mathbf{x}_2^T, \mathbf{x}_3^T]^T} =
\begin{bmatrix}
    -\mathbf{B}_{11} - \mathbf{B}_{21} & 0 & \mathbf{B}_{11} & 0 & \mathbf{B}_{21} & 0 \\
    0 & -\mathbf{B}_{11} - \mathbf{B}_{21} & 0 & \mathbf{B}_{11} & 0 & \mathbf{B}_{21} \\
    -\mathbf{B}_{12} - \mathbf{B}_{22} & 0 & \mathbf{B}_{12} & 0 & \mathbf{B}_{22} & 0 \\
    0 & -\mathbf{B}_{12} - \mathbf{B}_{22} & 0 & \mathbf{B}_{12} & 0 & \mathbf{B}_{22}
\end{bmatrix},
$$
其中 $\mathbf{B} = [\mathbf{X}_2 - \mathbf{X}_1, \mathbf{X}_3 - \mathbf{X}_1]^{-1}$ 表示由第二、第三个顶点分别减去第一个顶点所构成的矩阵的逆。该矩阵 $\mathbf{B}$ 可以在初始化时与其他属性（如每个三角形的体积和拉梅参数）一起预先计算：

{{imp}}{imp:lec15:elem_precomp}[单元信息的预计算，simulator.py]
```python
{{#include ../../solid-sim-tutorial/6_inv_free/simulator.py:elem_precomp}}
```

杨氏模量与泊松比：
```python
{{#include ../../solid-sim-tutorial/6_inv_free/simulator.py:lame_param}}
```

这里，`e` 不再像质点-弹簧模型中那样存储所有边单元，而是表示所有三角形单元，这可以通过如下修改网格生成代码来得到：

{{imp}}{imp:lec15:tri_vert_ind}[组装每个三角形的顶点索引，square_mesh.py]
```python
{{#include ../../solid-sim-tutorial/6_inv_free/square_mesh.py:tri_vert_ind}}
```

三角形以对称方式排列，可通过绘制三条边来渲染：

{{imp}}{imp:lec15:draw_tri}[绘制三角形，simulator.py]
```python
{{#include ../../solid-sim-tutorial/6_inv_free/simulator.py:draw_tri}}
```
