## 小结

基于在时间与空间上离散化的弱形式，我们在线性有限元框架下探讨了计算质量矩阵、变形梯度与弹性力的方法，这些都与我们在[无翻转弹性](../../hyperelasticity/case-study-inversion-free-elasticity/inv_free_elasticity.md)一节中的实现相一致。

采用线性有限元时，世界空间坐标 $\mathbf{x}$ 被近似为 $\mathbf{X}$ 的分段线性函数。这一近似 $\hat{\mathbf{x}}(\mathbf{X})$ 在每个三角形内部是线性函数，并在边处 $C^0$ 连续。通过引入两个参数 $\beta$ 与 $\gamma$ 来表示各三角形上的点，我们可以确定对三角形顶点位移进行插值的线性形函数，并推导变形梯度 $\mathbf{F}$。于是，质量矩阵的元素与弹性项都可以通过对 $\beta$ 和 $\gamma$ 的积分算出。
