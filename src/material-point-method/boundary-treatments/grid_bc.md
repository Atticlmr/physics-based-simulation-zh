## 边界条件

在物质点法中，<strong>边界条件（Boundary Condition，BC）</strong>施加在背景欧拉网格上，因为控制方程是以弱形式离散、并在网格节点上表述的，而网格节点才是系统真正的自由度（Degree of Freedom，DOF）。这些节点必须满足牛顿第二定律。因此，包括静态墙面、移动边界或接触力在内的所有外部约束，都必须在 P2G 之后、G2P 之前直接施加到网格上。

与通常做法一样，我们把网格节点 $\mathbf{x}_i$ 上的节点速度记为 $\hat{\mathbf{v}}_i^{n+1}$。在积分外力之后，我们根据边界条件的类型对边界节点施加不同的速度投影。

### 边界条件的类型

设 $\mathbf{n}$ 为边界网格节点 $\mathbf{x}_i$ 处的表面法向：

- **粘着**：速度被完全抑制：
  $$
  \hat{\mathbf{v}}_i^{n+1} \leftarrow \mathbf{0}.
  $$

- **滑移**：只移除法向分量，切向运动得以保留：
  $$
  \hat{\mathbf{v}}_i^{n+1} \leftarrow \hat{\mathbf{v}}_i^{n+1} - \mathbf{n}(\mathbf{n}^\top \hat{\mathbf{v}}_i^{n+1}).
  $$

- **分离（单向墙）**：法向的流入被阻挡，但向外的运动被允许：
  $$
  \hat{\mathbf{v}}_i^{n+1} \leftarrow \hat{\mathbf{v}}_i^{n+1} - \mathbf{n} \cdot \min(\mathbf{n}^\top \hat{\mathbf{v}}_i^{n+1}, 0).
  $$

这些操作都是**局部的**，对每个边界网格节点独立施加。

### 外力

**重力**等外力可以在 P2G 之后加入：

$$
\hat{\mathbf{v}}_i^{n+1} \leftarrow \hat{\mathbf{v}}_i^{n+1} + \Delta t \cdot \mathbf{g}.
$$

### 移动碰撞体

对于运动或变形中的物体，我们使用[**有符号距离函数（SDF）**](../../boundary-treatments/distance-barrier-for-nonpenetration/signed_dists.md)来判断某个网格节点 $\mathbf{x}_i$ 是否位于物体内部。一旦检测到，就计算**表面法向** $\mathbf{n}$ 与**相对速度** $\Delta \mathbf{v}$，并据此调整网格速度。

### 库仑摩擦

为了在嵌入的碰撞体（例如球体或胶囊体）上施加**库仑摩擦**，我们沿表面法向施加一个投影后的速度修正：

设 $\mathbf{n}$ 为接触法向，$\Delta \mathbf{v}$ 为反向速度（即 $\Delta \mathbf{v} = \mathbf{v}_{\text{SDF}} -\hat{\mathbf{v}}_i^{n+1}$）。定义法向分量：

$$
\dot{v}_n = \mathbf{n}^\top \Delta \mathbf{v}.
$$

于是修正后的网格速度为：

$$
\hat{\mathbf{v}}_i^{n+1} \leftarrow \hat{\mathbf{v}}_i^{n+1} + \Delta \mathbf{v} \cdot \mu + \mathbf{n} \cdot \dot{v}_n \cdot (1 - \mu),
$$

其中 $\mu \in [0, 1]$ 为**摩擦系数**。该操作在完全**分离**（$\mu = 0$）与**粘着**（$\mu = 1$）之间平滑过渡。
