# PL–PS 系统图：横向中英文版

图稿依据 2026-11-01 系统基线：PYNQ-Z2 / Zynq-7020，BUILD_ID `0xC0061000`。模块身份与数据流由随附来源索引核对。

## 文件

| 版本 | 高清 PNG | 矢量 PDF | 矢量 SVG | 可编辑 draw.io |
| --- | --- | --- | --- | --- |
| 中文 | [system_zh.png](system_zh.png) | [system_zh.pdf](system_zh.pdf) | [system_zh.svg](system_zh.svg) | [system_zh.drawio](system_zh.drawio) |
| English | [system_en.png](system_en.png) | [system_en.pdf](system_en.pdf) | [system_en.svg](system_en.svg) | [system_en.drawio](system_en.drawio) |

两版画布均为 2400×1060，PNG 为 4800×2120。`preview_zh.png` / `preview_en.png` 是各自 PDF 的 1800×795 回渲染预览。`system_zh.json` / `system_en.json` 为绘图源；模块坐标和连线完全一致，英文长标签单独调整字号。

`system.*` 与 `pdf_check.png` 保留旧链接兼容，内容已同步为当前中文版。上下布局的详细图、说明与生成器快照见相邻的 [detailed_v1](../detailed_v1/README.md)。

## 布局与表达

- PL 在左，PS 在右，宽度比例 1135:440，约 2.58:1；该比例用于布局；芯片资源利用率见完整实现报告。
- PL 视觉处理与渲染 GPU 上下分区，颜色及横向实线同时区分。视觉数据向右交给 PS，绘图命令向左返回 GPU。
- OV5640、HDMI 显示器、上位机和灵巧手在芯片框外保留图片位置；接口分别为 DVP、HDMI、Ethernet、USB。
- 模块只保留一至两行核心功能；版本身份、滤波窗口、寄存器、帧身份与 DMA 实例细节留在证据与说明中。

## 拓扑含义与省略项

本图概括功能与数据流；逐网表连接见 Vivado Block Design。标为 `AXI HP / DDR` 的箭头表示经 PS DDR 控制器和板载 DDR 交换缓冲区，DMA 将数据写入共享缓冲区，由 PS 软件读取；DDR 由 PS 控制器访问，物理存储位于芯片外。主图将 DDR 芯片和控制器汇总为数据通路。

RGB 从 Demosaic 输出旁路进入帧采集；肤色分割和滤波分支形成原始/滤波双掩膜。实际 BD 中 `frame_dma → HP1`、`moments_dma → HP3`，绘图上传 `axi_dma MM2S → HP0`。PS 使用 OpenCV 完成手势识别，最新手势与位置分别供交互应用和灵巧手调度读取。图中保留识别结果到应用与灵巧手调度的两条独立通路。

GPU 接收 Scene 命令和资源，完成光栅化后写入 BRAM 双帧缓冲，再经扫描、独立 OSD 和 rgb2dvi 输出 HDMI。GPU 绘制与视觉前处理采用独立像素通路，由 PS 识别与应用逻辑衔接。灰色 AXI GP 控制箭头汇总采集配置、相机 I²C、GPU 与 OSD 的 AXI-Lite / MMIO 访问。按键 GPIO、时钟复位、HP2 调试回读、状态回执、具体视频解码过程等未展开。

Ethernet 概括 Studio 与板端的管理、内容和观察接口；灵巧手由 PS 的独立动作进程通过 USB SDK 访问。外设区域预留照片位置，可放置本项目设备实拍。

## 版式参考

1. [PYNQ-Z2 Audio Analyzer 系统图](https://github.com/VincentttWang/FPGA_SocChina_2025/blob/main/doc/img/System%20Graph.png)：参考其横向 PL 大区、PS 小区与芯片外上位机的空间组织。
2. [AMD / Xilinx PYNQ-ZU Base Overlay 模块图](https://xilinx.github.io/PYNQ-ZU/overlays)：参考功能模块、硬件区域边界和外部接口的简洁表达。

参考图提供版式与信息组织思路；本图的模块、算法和连接依据本项目源码、HWH 与 Block Design 绘制。

## 可复现生成

在 `project` 目录中，使用已具备 PySide6 的 Python 环境：

```powershell
python -B tools/render_system_diagram.py report/figures/pl_ps_v3/concise_v2/system_zh.json --output build/output/figures/concise_zh
python -B tools/render_system_diagram.py report/figures/pl_ps_v3/concise_v2/system_en.json --output build/output/figures/concise_en
```

以上命令从随附场景 JSON 输出 SVG、draw.io、PNG 和 PDF。`generator_snapshot.py` 保存该版图形生成逻辑供查阅。下一步可在 draw.io 中替换图片预留、编辑模块或导出所需尺寸。draw.io 与 JSON 分别维护，后续编辑选定其中一种作为母稿。兼容别名 `system.*` 是导出后的中文版副本；正式使用建议选明确带 `_zh` / `_en` 的文件。

## 核验

`evidence.json` 记录八份项目来源的 SHA256，以及冻结 HWH 的六个关键模块身份和实际 BD 的 HP 总线连接。`validation.json` 记录两版文字宽高、连线端点、正交路径、穿越无关模块检查、SVG / draw.io 解析、双语布局一致性与 PDF 单页导出检查。两个 PDF 均已回渲染并人工查看，英文图无中文残留。

## 建议图题

中文：GESTURE PLAY 的 PL–PS 协同架构。PL 视觉前端经共享 DDR 向 PS 提供 RGB 与双掩膜数据，PS 完成手势识别和交互处理，并生成 Scene 命令，由独立 Scene2D GPU 渲染后输出 HDMI；最新视觉状态同时驱动灵巧手调度。

English: PL–PS architecture of GESTURE PLAY. The PL vision front end transfers RGB frames and dual masks through shared DDR for gesture recognition and interaction processing on the PS. Scene commands are then rendered by an independent Scene2D GPU and displayed through HDMI, while the latest visual state also feeds robotic hand control.
