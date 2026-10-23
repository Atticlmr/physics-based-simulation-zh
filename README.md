# 《基于物理的仿真》中文版

> **Physics-Based Simulation** 全书中文译本 · 9 部分 37 章 · 190 篇正文
>
> 📖 在线阅读：**<https://atticlmr.github.io/physics-based-simulation-zh/>**

本书是开源教材 *Physics-Based Simulation*（作者：Minchen Li、Chenfanfu Jiang、Zhaofeng Luo、Wenxin Du、Chang Yu、Žiga Kovačič、Tianyi Xie）的完整中文翻译。原书站点：<https://phys-sim-book.github.io/>，源码仓库：[phys-sim-book/mdbook-src](https://github.com/phys-sim-book/mdbook-src)。

## 这本书讲什么

它系统讲解**如何把物理仿真写成一个能量最小化问题，并用牛顿法 + 障碍函数 + 线搜索解得稳定、不穿透、不翻转**：从质点、刚体、超弹性有限元，到物质点法（MPM）、基于位置的动力学（PBD），以及接触、摩擦、碰撞检测与线性求解器。每章都配有可直接运行的 Python / CUDA 教程代码。

| 部分 | 章节 |
|---|---|
| 基于优化的仿真 | 1–4：离散时空、优化时间积分器、投影牛顿法、二维质点-弹簧 |
| 边界处理 | 5–11：狄利克雷边界、距离障碍函数、过滤线搜索、摩擦接触、移动边界 |
| 超弹性 | 12–15：运动学、应变能、应力及导数、无翻转弹性 |
| 控制方程 | 16–18：强/弱形式、离散化、边界与摩擦接触 |
| 有限元方法 | 19–24：线性有限元、自接触、2D/3D 摩擦自接触 |
| 空间降维 | 25–26：刚体动力学、子空间仿真、仿射体动力学（ABD）、模态降维 |
| 物质点法 | 27–31：粒子-网格传输、塑性、屈服与返回映射、SDF 碰撞体 |
| 基于位置的仿真 | 32–36：PBD/XPBD、布料、网格、PBF 流体、常见约束 |
| 专题 | 37：直接求解器与共轭梯度 |

译本规模：190 个 Markdown 文件、约 8.6 万汉字、506 个公式、45 幅插图、133 个代码块。

## 仓库结构

```text
.
├── src/              # 中文 Markdown 源文件（含图片、视频与教程源码）
├── theme/            # mdBook 主题（citation 元数据、本地 MathJax 配置）
├── tools/numthm-zh/  # 本地化补丁版 mdbook-numthm（中文环境标签）
├── book.toml         # 中文书名、language = "zh"、环境标签配置
├── build.sh          # 一键构建
├── 翻译说明.md        # 翻译范围、术语、校验方法与版权说明
└── README.md
```

构建产物不放在 `main` 分支；在线阅读由 `gh-pages` 分支提供，因此 `main` 体积更小、便于二次编辑。

## 本地构建

需要 Rust 与 mdBook 0.4.52 及四个插件：

```bash
cargo install mdbook --version 0.4.52 --locked
cargo install mdbook-katex --version 0.9.4 --locked
cargo install mdbook-numeq --version 0.4.0 --locked
cargo install mdbook-bib --version 0.0.6 --locked
cargo install --path tools/numthm-zh --force   # 中文「定义/图/实现」等标签
./build.sh
```

构建完成后打开 `book/index.html`。公式使用**本地 MathJax 3（SVG 输出）**，断网也能正常显示。

> 若改用 crates.io 的官方 `mdbook-numthm`，环境标签会显示为英文 `Definition`、`Figure` 等；中文标签依赖 `tools/numthm-zh` 中允许覆盖内置环境的补丁。

## 翻译与校验

- 统一术语表与 190 个章节标题译名，分 29 批翻译；
- 自动校验：代码块、全部公式、`{{def}}/{{fig}}/{{numeq}}/{{eqref}}` 标记与标签 ID、标题层级、图片路径**逐字一致**，190/190 通过；
- 0 缺图、0 断链：原书残留的 108 处旧版 `lecX.Y-*.md` 交叉引用已重新映射到当前章节；
- 修正 14 处中文标点导致的 Markdown 粗体失效。

细节见 [翻译说明.md](./翻译说明.md)。

## 版权与致谢

原书采用 **CC BY-NC-SA 4.0**（署名—非商业性使用—相同方式共享）许可，本译文作为演绎作品沿用同一许可，并保留原作者署名：

> Minchen Li, Chenfanfu Jiang, Zhaofeng Luo, Wenxin Du, Chang Yu, Žiga Kovačič, Tianyi Xie. *Physics-Based Simulation*, version 1.0.3, 2026. <https://phys-sim-book.github.io/>

请勿将本译本用于商业用途。
