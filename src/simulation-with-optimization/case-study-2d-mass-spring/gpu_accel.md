## GPU 加速仿真

**本节作者：[Zhaofeng Luo](https://roushelfy.github.io/)，卡内基梅隆大学*

现在我们将二维质点-弹簧仿真器改写为利用 GPU 加速的版本。
我们没有直接编写 [CUDA](https://developer.nvidia.com/cuda-toolkit)，而是借助 [MUDA](https://github.com/MuGdxy/muda)——一个为 GPU 加速计算提供简洁接口的轻量级库。

GPU 加速仿真器的架构与 Python 版本相似。所有函数名与变量名都与 Numpy 版本保持一致。然而，由于 GPU 的体系结构与编程模型不同，实现细节有所差异。在深入细节之前，让我们先从下面的 gif（{{ref: fig:lec4:cpu_vs_gpu}}）中直观感受 GPU 能为我们带来的加速。

<figure>
    <center>
    <img src="cpu_gif.gif">
    <img src="gpu_gif.gif">
    </center>
    <figcaption><b>{{fig}}{fig:lec4:cpu_vs_gpu}</b> Numpy CPU 版本（左）与 MUDA GPU 版本（右）的仿真速度示意。</figcaption>
</figure>

### GPU 编程的关键考虑

为最大化 GPU 上的资源利用率，有两个重要方面需要考虑：
- **最小化数据传输。** 在大多数现代体系结构中，CPU 与 GPU 拥有各自独立的内存空间。在这些空间之间传输数据的代价可能很高。因此，必须尽量减少 CPU 与 GPU 之间的数据传输。
- **充分利用并行性。** GPU 擅长并行计算。但必须注意避免多个线程同时尝试访问同一内存位置时可能出现的读写冲突。

### 最小化数据传输

为减少 CPU 与 GPU 之间的数据传输，我们将主要的能量值及其导数存储在 GPU 上。随后计算直接在 GPU 上进行，只有必要的位置信息被传回 CPU 用于控制与渲染。更高效的实现可以直接在 GPU 上渲染，从而连这部分数据传输也一并消除，但为简单与可读性起见，我们在此并未实现该方案。

为使代码更易读，以 `device_` 开头的变量存储在 GPU 内存中，以 `host_` 开头的变量存储在 CPU 内存中。

{{imp}}{imp:lec4:energy_definition}[数据结构，MassSpringEnergy.cu]
```cpp
{{#include ../../solid-sim-tutorial-gpu/simulators/1_mass_spring/src/MassSpringEnergy.cu:definition}}
```
如上段代码所示，能量值及其导数，以及所有必要的参数，都存储在一个 `DeviceBuffer` 对象中；该对象是 MUDA 库实现的 CUDA 设备内存的封装。这使我们能够直接在 GPU 上执行计算，而无需在 CPU 与 GPU 之间传输数据。

### 牛顿法

牛顿法的迭代是一个串行过程，无法并行化。因此，我们将这部分实现在 CPU 上：

{{imp}}{imp:lec4:gpu_time_integrator}[牛顿法，simulator.cu]
```cpp
{{#include ../../solid-sim-tutorial-gpu/simulators/1_mass_spring/src/simulator.cu:step_forward}}
```
在函数 `step_forward` 中，实现了带线搜索的投影牛顿法，它在 GPU 上执行必要的计算，同时在 CPU 上控制整个流程。
此处任何以 `device_` 开头的变量都是 GPU 上的 `DeviceBuffer` 对象。为调试而打印 `DeviceBuffer` 中的值时，常见做法是将数据传回 CPU，或调用 `uti.cu` 中实现的 `display_vec` 函数（该函数在 GPU 上并行调用 `printf`）。

`update_x` 函数把节点的位置更新给所有 Energy 类，并将更新后的位置传回 CPU 用于渲染：

{{imp}}{imp:lec4:gpu_update_x}[更新位置，simulator.cu]
```cpp
{{#include ../../solid-sim-tutorial-gpu/simulators/1_mass_spring/src/simulator.cu:update_x}}
```
由于 Energy 类已经更新了各自的位置，`IP_val` 函数不再需要传入任何参数，从而避免了不必要的数据传输。
事实上，它只调用所有 energy 类的 `val` 函数，然后把结果相加：

{{imp}}{imp:lec4:gpu_ip_val}[计算 IP，simulator.cu]
```cpp
{{#include ../../solid-sim-tutorial-gpu/simulators/1_mass_spring/src/simulator.cu:IP_val}}
``` 
`IP_grad` 与 `IP_hess` 函数同理：

{{imp}}{imp:lec4:gpu_ip_grad_hess}[计算 IP 梯度与海森矩阵，simulator.cu]
```cpp
{{#include ../../solid-sim-tutorial-gpu/simulators/1_mass_spring/src/simulator.cu:IP_grad and IP_hess}}
``` 
请注意，它们利用 GPU 上的并行操作（`add_vector` 与 `add_triplet`，均在 `uti.cu` 中实现）来完成梯度与海森矩阵的求和。

### 并行计算

在我们的实现中，并行计算主要用于能量及其导数的计算，以及向量的加法与减法。下面以 MassSpringEnergy 的计算为例。

#### 能量计算
{{imp}}{imp:lec4:MassSpringEnergyVal}[计算能量，MassSpringEnergy.cu]
```cpp
{{#include ../../solid-sim-tutorial-gpu/simulators/1_mass_spring/src/MassSpringEnergy.cu:val}}
```
`ParallelFor` 函数将计算分配到多个 GPU 线程上。lambda 函数中捕获的变量使每个线程都能访问所需的数据结构。

#### 梯度计算
{{imp}}{imp:lec4:MassSpringEnergyGrad}[计算梯度，MassSpringEnergy.cu]
```cpp
{{#include ../../solid-sim-tutorial-gpu/simulators/1_mass_spring/src/MassSpringEnergy.cu:grad}}
```
`atomicAdd` 函数在梯度计算中至关重要，它确保对共享数据的安全并发更新（不同的边可能更新同一节点的梯度），从而防止竞态条件。

#### 海森矩阵计算
我们使用稀疏矩阵数据结构来存储海森矩阵。计算在多个线程上并行进行，每个线程更新海森矩阵的一个特定元素。稀疏矩阵的实际大小在仿真开始时计算得出，从而只为非零元素分配恰好足够的内存。这里主要考虑的是在仿真过程中为每个元素计算正确的索引：

{{imp}}{imp:lec4:MassSpringEnergyHess}[计算海森矩阵，MassSpringEnergy.cu]
```cpp
{{#include ../../solid-sim-tutorial-gpu/simulators/1_mass_spring/src/MassSpringEnergy.cu:hess}}
```

