## 刚体零空间与旋转不变性

正如上一讲所述，对于只发生平移和/或旋转运动的固体，不会储存弹性势能，因而也不会产生弹性力。这意味着任意应变能密度函数 $\Psi(\mathbf{F})$ 都具有**刚体零空间**，即当输入的变形梯度为任意旋转矩阵 $\mathbf{R}$ 时，$\Psi(\mathbf{F})$ 都应保持为 $0$：
$$
    \Psi(\mathbf{F}) = 0 \quad \forall \ \mathbf{F} = \mathbf{R}.
$$
方阵 $\mathbf{F}$ 是旋转矩阵，当且仅当：
$$
    \mathbf{F}^T = \mathbf{F}^{-1} \quad \text{and} \quad J \equiv \text{det}(\mathbf{F}) = 1.
$$
由这一定义可以直接得到 $\Psi(\mathbf{F})$ 的一种形式：用二次项惩罚 $\mathbf{F}$ 偏离旋转矩阵的程度：
$$
    \Psi(\mathbf{F}) = \frac{\mu}{4} \| \mathbf{F}^T \mathbf{F} - \mathbf{I} \|^2_F + \frac{\lambda}{2} (J - 1)^2.
    {{numeq}}{eq:lec13:strain_density_intuitive}
$$
这里，$\mu$ 与 $\lambda$ 为刚度参数，其中第一项来自在 $\mathbf{F}^T = \mathbf{F}^{-1}$ 两边右乘 $\mathbf{F}$。这一直观的形式与许多标准应变能密度函数的构造方式高度吻合。

> **{{def}}{def:lec13:neo_hookean}[新胡克弹性]**
> 新胡克（neo-Hookean）弹性模型由如下能量密度函数刻画：
$$
    \Psi_\text{NH}(\mathbf{F}) = \frac{\mu}{2}\left(\text{tr}(\mathbf{F}^T\mathbf{F})-d\right)-\mu\ln(J)+\frac{\lambda}{2}\ln^2(J).
    {{numeq}}{eq:lec13:strain_density_NH}
$$
> 对 $\Psi_\text{NH}(\mathbf{F})$ 关于 $\mathbf{F}$ 求导，得到：
$$
    \frac{\partial \Psi}{\partial \mathbf{F}}(\mathbf{F}) = \mu(\mathbf{F}-\mathbf{F}^{-T})+\lambda\ln(J)\mathbf{F}^{-T}.
$$
> 由该梯度可见，当 $\mathbf{F} - \mathbf{F}^{-T} = 0$（即 $\mathbf{F}^T = \mathbf{F}^{-1}$）时，$\mu$ 项取到局部极小值；而对 $\lambda$ 项，局部极小值出现在 $J=1$ 处。

> **{{def}}{def:lec13:lame_parameters}[拉梅参数]**
> 在标准应变能密度函数中，刚度参数 $\mu$ 与 $\lambda$ 称为拉梅参数。这两个参数与**杨氏模量** $E$ 以及**泊松比** $\nu$ 直接相关：前者衡量材料抵抗拉伸的能力，后者衡量固体的不可压缩性：
$$
    \mu = \frac{E}{2(1+\nu)}, \quad \lambda = \frac{E\nu}{(1+\nu)(1-2\nu)}.
$$

> **{{def}}{def:lec13:rotation_invariance}[旋转不变性]**
> 任何非线性弹性模型的能量密度函数都是旋转不变的。用数学语言表述为：
$$
    \Psi(\mathbf{F}) = \Psi(\mathbf{R} \mathbf{F}) \quad \forall \ \mathbf{F} \in \mathbb{R}^{d\times d} \ \text{and} \ d \times d \ \text{rotation matrix} \ \mathbf{R}.
    {{numeq}}{eq:lec13:rot_invariant}
$$
> 直观地说，这意味着在变形之后施加的任何旋转都不应改变应变能密度函数的取值。

然而，最简单的应变能密度函数——**线性弹性**——其零空间中不包含刚体模态，也不满足式 {{eqref: eq:lec13:rot_invariant}}。这是因为线性弹性是专门针对**无穷小应变**设计的，此类情形不涉及明显的旋转。

> **{{def}}{def:lec13:linear_elasticity}[线性弹性]**
> 线性弹性的能量密度函数为
$$
    \Psi_\text{lin}(\mathbf{F}) = \mu \|\bm{\epsilon}\|^2_F + \frac{\lambda}{2} \text{tr}^2(\bm{\epsilon}).
    {{numeq}}{eq:lec13:strain_energy_lin}
$$
> 其中 $\bm{\epsilon} = \frac{1}{2}(\mathbf{F} + \mathbf{F}^T) - \mathbf{I}$ 为**小应变张量**，可以看到 $\Psi_\text{lin}(\mathbf{F})$ 是 $\mathbf{F}$ 的二次函数。

值得注意的是，配合相应拉梅参数的线性弹性模型是针对小变形条件下的真实实验进行校准的。在此类情形下，所有标准应变能密度函数都必须与线性弹性一致。在下一节引入 $\mathbf{F}$ 的极奇异值分解之后，我们将简要说明这些模型与线性弹性之间的一致性。

旋转不变性（式 {{eqref: eq:lec13:rot_invariant}}）不应与某些弹性模型的各向同性性质混为一谈。

> **{{def}}{def:lec13:isotropic_elasticity}[各向同性弹性]**
> 各向同性弹性模型的能量密度函数满足
$$
    \Psi(\mathbf{F}) = \Psi(\mathbf{F} \mathbf{R}) \quad \forall \ \mathbf{F} \in \mathbb{R}^{d\times d} \ \text{and} \ d \times d \ \text{rotation matrix} \ \mathbf{R}.
    {{numeq}}{eq:lec13:isotropic_condition}
$$
> 这意味着在任何方向上施加相同的拉伸量都会引起相同的能量变化。因此，材料中不存在比其他方向更难或更易变形的特殊方向。

新胡克模型（式 {{eqref: eq:lec13:strain_density_NH}}）与我们此前的直观模型（式 {{eqref: eq:lec13:strain_density_intuitive}}）都是各向同性模型的例子。然而，线性弹性（式 {{eqref: eq:lec13:strain_energy_lin}}）不满足这一条件（式 {{eqref: eq:lec13:isotropic_condition}}），因为它并非为有效处理旋转运动而设计。

对于**各向异性弹性模型**，抵抗拉伸的能力随方向而变化。布料、骨骼、肌肉与木材等材料都是各向异性材料的例子，它们在不同方向上表现出不同的力学性质。
