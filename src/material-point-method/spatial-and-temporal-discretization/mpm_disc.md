# 空间与时间离散化

**本讲作者：[Chang Yu](https://changyu.io/)，加州大学洛杉矶分校*

在第一讲[离散空间与时间](../../simulation-with-optimization/discrete-space-and-time/discrete_space_time.md)中，我们介绍了固体对象的各种表示方式。我们没有从经典连续体方程出发，而是直接把弹性仿真表述为离散的代数问题，此前的讨论主要集中于基于网格的纯拉格朗日格式。

本讲介绍物质点法（Material Point Method，MPM）——一种尤其适合仿真大变形与拓扑变化的拉格朗日-欧拉混合格式。与 [FEM](../../finite-element-method/linear-finite-elements/linear_FEM.md) 等通过精心构造的网格结构的**单元**来跟踪材料变形的纯拉格朗日方法不同，MPM 把材料简单地离散为一组[**物质点**](material_particles.md)。每个粒子存储质量、动量、变形梯度与应力等关键物理信息。随后 MPM 借助一个临时的规则笛卡尔背景网格求解动量方程，并在粒子与网格节点之间[传输](euler_lag_transfers.md)信息。

具体而言，在每个时间步中，物质点的信息首先被传输到欧拉网格上，并在网格上高效地求解控制方程；更新后的网格解随后被传回粒子，[更新粒子状态](particle_state_update.md)（如位置与变形梯度）。传输完成后，网格被重置，粒子成为材料历史的唯一载体。这种混合策略天然适应大变形与复杂接触场景，有效克服了传统基于网格的纯拉格朗日方法所固有的网格畸变难题。
