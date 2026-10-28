## 拉伸不稳定性修正

基于光滑粒子流体动力学（Smoothed Particle Hydrodynamics，SPH）的流体仿真中一个众所周知的瑕疵是“拉伸不稳定性”：自由表面附近的粒子由于无法满足静止密度而聚集成团。基于位置的流体（Position-Based Fluids，PBF）通过引入人工压力项给出了直接的解决方案。

具体而言，引入人工压力项 $s_{\text{corr}}$，在邻近粒子之间产生短程排斥力。该项是 $W$ 的函数：
$$
{{numeq}}{eq:pbf:scorr}
s_{\text{corr}} = -k \left( \frac{W(\bm{p}_i - \bm{p}_j, h)}{W(\Delta\bm{q}, h)} \right)^n
$$
其中 $k$ 与 $n$ 为小的正常数（例如 $k=0.1, n=4$），$\Delta\bm{q}$ 是表示核半径内一个小距离的向量（例如 $\|\Delta\bm{q}\| = 0.3h$）。该项只用于将粒子推开，并直接并入式 {{eqref:eq:pbf:position_correction}} 的位置修正计算：
$$
{{numeq}}{eq:pbf:scorr_correction}
\Delta \bm{p}_i = \frac{1}{\rho_0} \sum_j (\lambda_i + \lambda_j + s_{\text{corr}}) \nabla W(\bm{p}_i - \bm{p}_j, h)
$$
如此可避免成团，并在流体边界处隐式地产生类表面张力的效应。

### 实现：拉伸不稳定性修正

拉伸不稳定性修正实现为一个额外的人工压力项，它在邻近粒子之间产生排斥力：

**计算人工压力项**

```python
@ti.func
def compute_scorr(pos_ji):
    """Tensile instability correction - implements Equation {{eqref:eq:pbf:scorr}}"""
    x = poly6_value(pos_ji.norm(), h) / poly6_value(corr_deltaQ_coeff * h, h)
    x = x * x; x = x * x  # pow(x, 4)
    return -corrK * x
```

该函数计算按核函数取值之比缩放的人工压力项 `s_corr`。四次幂保证当粒子彼此非常接近时修正最强，从而形成有效的排斥。

**并入位置修正**

人工压力项被并入位置修正的计算：

```python
# Integration into density constraint solver
for j in range(particle_num_neighbors[p_i]):
    p_j = particle_neighbors[p_i, j]
    lambda_j = lambdas[p_j]
    pos_ji = pos_i - positions[p_j]
    scorr_ij = compute_scorr(pos_ji)  # Tensile instability correction
    pos_delta_i += (lambda_i + lambda_j + scorr_ij) * spiky_gradient(pos_ji, h)
```

人工压力项被加到标准的约束修正之上，产生短程排斥力，既防止自由表面附近的粒子聚集成团，又保持整体的密度约束满足。
