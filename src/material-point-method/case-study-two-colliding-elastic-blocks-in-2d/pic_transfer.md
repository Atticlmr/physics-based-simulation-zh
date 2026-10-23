## 质点网格传输

在每次仿真步开始时，必须先清空网格，然后再累加新的粒子到网格传输量。

{{imp}}{imp:lec29:reset_grid}[重置网格，simulator.py]
```python
{{#include ../../solid-sim-tutorial/10_mpm_elasticity/simulator.py:reset_grid}}
```

我们采用 Saint Venant–Kirchhoff（StVK）本构模型，它利用变形梯度的 SVD，在对数（Hencky）应变空间中表述。

{{imp}}{imp:lec29:stvk}[Stvk Hencky 弹性，simulator.py]
```python
{{#include ../../solid-sim-tutorial/10_mpm_elasticity/simulator.py:stvk}}
```


在粒子到网格（P2G）传输过程中，我们使用二次 B 样条插值，把每个粒子的质量、动量与内力分配到其相邻的网格节点上。该过程遵循 PIC（Particle-In-Cell）格式，即粒子速度被直接传输到网格，而不存储仿射速度场。

{{imp}}{imp:lec29:p2g}[PIC 粒子到网格（P2G）传输，simulator.py]
```python
{{#include ../../solid-sim-tutorial/10_mpm_elasticity/simulator.py:p2g}}
```

紧接在粒子到网格（P2G）传输之后，我们对网格动量作归一化以得到节点速度，并通过将计算域边缘附近的速度置零来施加狄利克雷边界条件。

{{imp}}{imp:lec29:grid_update}[网格更新，simulator.py]
```python
{{#include ../../solid-sim-tutorial/10_mpm_elasticity/simulator.py:grid_update}}
```

在网格到粒子（G2P）传输过程中，我们从背景网格收集更新后的速度，并利用由插值函数导出的速度梯度计算弹性变形梯度的更新。

{{imp}}{imp:lec29:g2p}[PIC 网格到粒子（G2P）传输，simulator.py]
```python
{{#include ../../solid-sim-tutorial/10_mpm_elasticity/simulator.py:g2p}}
```

最后，粒子位置通过使用辛欧拉时间积分的平流来更新。

{{imp}}{imp:lec29:particle_update}[粒子状态更新，simulator.py]
```python
{{#include ../../solid-sim-tutorial/10_mpm_elasticity/simulator.py:particle_update}}
```

一个完整的 MPM 仿真步由以下阶段组成：

{{imp}}{imp:lec29:time_step}[MPM 的一个完整时间步，simulator.py]
```python
{{#include ../../solid-sim-tutorial/10_mpm_elasticity/simulator.py:time_step}}
```

<figure>
    <center>
    <img src="mpm_elastic_blocks_simulation_result.png">
    </center>
    <figcaption><b>{{fig}}{fig:lec29:mpm_elastic_blocks_simulation_result}</b> <b>二维中两块弹性体碰撞的时间序列</b>。红、蓝两方块以相反速度相互接近，撞击时发生大幅度弹性变形，随后回弹并恢复形状。该仿真展示了 MPM 框架下对称的动量交换与弹性储能。 </figcaption>
</figure>
