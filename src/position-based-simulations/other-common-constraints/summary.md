## 小结

我们通过各类约束考察了[基于位置的动力学框架](../position-based-dynamics-pbd/core_framework.md)的多功能性，借助这些约束可以仿真多样化的物理系统。**距离约束**提供了[布料的拉伸与弯曲抗力](../case-study-cloth-simulation/cloth_pbd.md)，而**单边不等式约束**在位置层面处理[接触与摩擦](pbd_collisions_constraints.md)。**体积守恒约束**通过[四面体体积与全局体积保持](../case-study-mesh-simulation/volume_constraints.md)维持不可压缩性，**密度约束**则借助基于 SPH 的核函数实现[基于位置的流体仿真](../case-study-position-based-fluids/fluids_pbd.md)。最后，**基于连续体力学的约束**通过应变能形式与直接的应变分量控制，把基于位置的动力学（Position-Based Dynamics，PBD）与[超弹性材料模型](pbd_continuum.md)联系起来。这些约束类型共同展示了 PBD 的统一思路：在同一个高效框架内仿真布料、流体、软体与接触现象。
