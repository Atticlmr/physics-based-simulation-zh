# 案例研究：塑性材料模型*

*本讲作者：[Chang Yu](https://changyu.io/)，加州大学洛杉矶分校*

在上一章“二维两块弹性体碰撞”中，我们用质点网格法（Particle-In-Cell，PIC）传输格式实现了一个最简的物质点法（Material Point Method，MPM）仿真。在此基础上，本案例研究将展示如何以极小的额外工作量把该系统扩展到高级塑性材料的仿真。

本案例研究涵盖两个重要的塑性材料模型。首先，我们通过一个带球体碰撞体的沙子仿真来演示 [Drucker-Prager 弹塑性](drucker_prager.md)。随后，我们通过一个双条仿真来介绍[粘塑性材料模型](2d_viscoplastic_bars.md)。

## 使用 Drucker-Prager 模型的沙子仿真

在沙子仿真中，我们使用 [Poisson 圆盘采样](../spatial-and-temporal-discretization/mpm_disc.md)来初始化物质点，这有助于减少混叠瑕疵与结构化噪声，从而在颗粒材料仿真中产生更符合物理实际的行为。

沙子采用 [Drucker-Prager 弹塑性](drucker_prager.md) {{#cite klar2016drucker}} 本构模型来建模，使我们能够捕捉不可恢复的变形与内摩擦——这是颗粒材料行为的关键特征。

我们在计算域内放置一个[静态球体碰撞体](sphere_sdf.md)，它与下落的沙粒通过摩擦接触相互作用。碰撞体边界用<strong>有符号距离函数（Signed Distance Function，SDF）</strong>表示，并施加接触约束与库仑摩擦。

我们扩展原始的质点网格法（PIC）格式，引入 [APIC 传输格式](apic_transfer.md)，以获得更高的精度并减少数值耗散。

## 粘塑性材料模型

*本节作者：[Žiga Kovačič](https://zzigak.github.io)，康奈尔大学*

此外，我们在[二维粘塑性条](2d_viscoplastic_bars.md)中演示了一个**粘塑性**材料模型，它在传统塑性理论的基础上引入了率相关行为。该模型可刻画牙膏或高粘性流体这类材料——它们对变形的抵抗取决于加载速率。

本节可执行的 Python 工程位于 [https://github.com/phys-sim-book/solid-sim-tutorial](https://github.com/phys-sim-book/solid-sim-tutorial) 的 `11_mpm_plastic` 文件夹下。
