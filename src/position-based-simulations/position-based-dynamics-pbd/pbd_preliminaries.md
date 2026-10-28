## 预备知识

要充分领会基于位置的动力学（Position-Based Dynamics，PBD）方法，首先需要理解它所借鉴的拉格朗日动力学的经典表述。由 $N$ 个粒子组成的动力学系统的状态，由各粒子的质量 $m_i$、位置 $\bm{p}_i \in \mathbb{R}^3$ 与速度 $\bm{v}_i \in \mathbb{R}^3$ 描述。该系统的演化由牛顿第二定律导出的两个一阶常微分方程控制：
$$
\dot{\bm{v}}_i = \frac{1}{m_i} \bm{f}_i
{{numeq}}{eq:lagrangian:particle_motion}
$$
$$
\dot{\bm{p}}_i = \bm{v}_i
{{numeq}}{eq:lagrangian:particle_kinematic}

$$
其中 $\bm{f}_i$ 是作用在粒子 $i$ 上的所有力的总和。

刚体还需要额外的属性来描述其转动状态：姿态四元数 $\bm{q}_i \in \mathbb{H}$、角速度 $\bm{\omega}_i \in \mathbb{R}^3$ 以及惯性张量 $\bm{I}_i \in \mathbb{R}^{3 \times 3}$。于是转动运动由牛顿-欧拉方程描述：
$$
\dot{\bm{\omega}}_i = \bm{I}_i^{-1} \left( \bm{\tau}_i - \left( \bm{\omega}_i \times (\bm{I}_i \bm{\omega}_i) \right) \right)
{{numeq}}{eq:lagrangian:rigid_body_motion}

$$
$$
\dot{\bm{q}}_i = \frac{1}{2} \hat{\bm{\omega}}_i \bm{q}_i
{{numeq}}{eq:lagrangian:rigid_body_kinematic}

$$
其中 $\bm{\tau}_i$ 是合力矩，$\hat{\bm{\omega}}_i$ 是四元数 $[0, \bm{\omega}_i]$。

为仿真这一演化过程，需要用数值积分器对上述连续方程进行离散。辛欧拉（Symplectic Euler）法先更新速度，再用新得到的速度更新位置，相比标准显式欧拉法具有更好的稳定性。对单个粒子，时间步为 $\Delta t$ 时的更新为：
$$
\bm{v}_i(t_0 + \Delta t) = \bm{v}_i(t_0) + \Delta t \frac{1}{m_i} \bm{f}_i(t_0)
{{numeq}}{eq:lagrangian:symplectic_euler_v}

$$
$$
\bm{p}_i(t_0 + \Delta t) = \bm{x}_i(t_0) + \Delta t \bm{v}_i(t_0 + \Delta t)
{{numeq}}{eq:lagrangian:symplectic_euler_x}

$$
上述流程可类似地应用于刚体状态。

> **{{rem}}{rem:lagrangian:quaternion_normalization}[四元数归一化]**
> 由于数值积分误差，四元数 $\bm{q}_i$ 可能偏离单位长度。每次积分步骤之后都必须重新归一化四元数，以维持有效的转动状态。

最后，物体间的相互作用与物理限制通过<strong>完整约束（holonomic constraints）</strong>来建模，这类约束只依赖位置与姿态，而不依赖速度！约束是以等式和不等式形式给出的运动学限制，用于限制物体之间的相对运动。<strong>等式（双侧）</strong>约束的形式为 $C_j(\bm{p}, \bm{q}) = 0$，而<strong>不等式（单侧）</strong>约束为 $C_j(\bm{p}, \bm{q}) \ge 0$。在经典动力学中，这些约束通过计算约束力并将其加入方程 {{eqref:eq:lagrangian:particle_motion}} 中的 $\bm{f}_i$ 来满足。PBD 从根本上改变的正是这种处理约束的机制。
