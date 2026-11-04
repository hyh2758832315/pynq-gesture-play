# PL–PS 系统图：横向展开中英文版

基线是独立项目 `contest_v3`，PYNQ-Z2 / Zynq-7020，冻结运行包 R15b 与手部运行时 R16，BUILD_ID `0xC0061000`。本次调整图的布局和表达，不改变系统实现。

## 文件

| 版本 | 高清 PNG | 矢量 PDF | 矢量 SVG | 可编辑 draw.io |
| --- | --- | --- | --- | --- |
| 中文 | [system_zh.png](system_zh.png) | [system_zh.pdf](system_zh.pdf) | [system_zh.svg](system_zh.svg) | [system_zh.drawio](system_zh.drawio) |
| English | [system_en.png](system_en.png) | [system_en.pdf](system_en.pdf) | [system_en.svg](system_en.svg) | [system_en.drawio](system_en.drawio) |

两版画布均为 3080×1640，PNG 为 6160×3280。`preview_zh.png` / `preview_en.png` 是各自 PDF 的 1800×958 回渲染预览。`system_zh.json` / `system_en.json` 为绘图源；模块坐标和连线完全一致，英文长标签单独调整字号。当前共 42 个图形节点（含标题与分组）、39 条连接；上一版为 25 个节点、15 条连接。

`system.*` 与 `pdf_check.png` 保留旧链接兼容，内容已同步为当前中文版。最初上下布局存放在 `detailed_v1/`；前一版横向简图、说明与生成器快照保留在 `concise_v2/`。

## 布局与表达

- PL 在左，PS 在右，宽度比例 1660:510，约 3.25:1；这只是绘图空间分配，不代表芯片面积或资源利用率。
- PL 视觉处理与渲染 GPU 上下分区，颜色及横向实线同时区分。视觉数据向右交给 PS，绘图命令向左返回 GPU。
- OV5640、HDMI 显示器、上位机和灵巧手在芯片框外保留图片位置；接口分别为 DVP、HDMI、Ethernet、USB。
- 模块只保留一至两行核心功能；展开实际分支与连接，版本身份、滤波窗口、寄存器及帧身份细节留在证据与说明中。

本次展开的 PL 功能包括：RGB 旁路与 RGB VDMA；缩减 / HSV 后的原始掩膜 FIFO、形态 / 高斯滤波分支及双掩膜打包；独立掩膜 SG DMA；相机 I²C 和帧准入 / 三槽管理；GPU 包分发、命令缓冲、Atlas / Tilemap 资源存储、调色板、填充 / 精灵 / 图块绘制、共享 BRAM 双帧缓冲、消隐期交换、扫描和独立 OSD。

## 拓扑含义与省略项

本图是功能与数据流概览，不是逐网表连接图。`AXI HP` 区块与标有 `DDR` 的箭头表示经 PS DDR 控制器和板载 DDR 交换缓冲区，不表示 DMA 直接连接 OpenCV 或软件函数，也不表示 DDR 实体属于 PL。为精简主图，未画独立 DDR 芯片及控制器方框。

当前图将 HP0、HP1、HP3 的多组 AXI 数据互连汇总成一条竖向 `AXI HP` 区块，并用各端口标注保留通路身份；它不是一个新增硬件 IP，也不表示三条 DMA 流在 PL 内直接互相连通。通往 PS 的箭头是经 DDR 的功能数据通路。

RGB 从 Demosaic 输出旁路进入帧采集；肤色分割和滤波分支形成原始/滤波双掩膜。实际 BD 中 `frame_dma → HP1`、`moments_dma → HP3`，绘图上传 `axi_dma MM2S → HP0`。PS 使用 OpenCV 完成手势识别，最新手势与位置分别供交互应用和灵巧手调度读取。图中保留两条独立语义通路，未画成必须由游戏进程转发识别结果。

GPU 接收 Scene 命令和资源，完成光栅化后写入 BRAM 双帧缓冲，再经扫描、独立 OSD 和 rgb2dvi 输出 HDMI。GPU 与视觉前端不存在直接像素串联通路。灰色 AXI GP 控制箭头汇总采集配置、相机 I²C、GPU 与 OSD 的 AXI-Lite / MMIO 访问。按键 GPIO、时钟复位、HP2 调试回读、状态回执、具体视频解码过程等未展开。

GPU 内的填充、精灵、图块是按命令选择和调度的绘制功能，三条写入箭头表示它们共享帧缓冲写入通路，不宣称三个引擎同时写入。图集和图块存储合并展示，供绘制模块读取；调色板单独连接扫描输出。消隐期帧交换根据绘制完成状态切换读写帧。控制寄存器条只展开相机 I²C、帧管理、独立 OSD 的代表性访问分支，未逐个列出全部 GPIO 状态和控制连线。

Ethernet 概括 Studio 与板端的管理、内容和观察接口；灵巧手由 PS 的独立动作进程通过 USB SDK 访问。外设图片仍为用户要求的预留位置，不使用他人项目的设备照片。

## 版式参考

1. [PYNQ-Z2 Audio Analyzer 系统图](https://github.com/VincentttWang/FPGA_SocChina_2025/blob/main/doc/img/System%20Graph.png)：参考其横向 PL 大区、PS 小区与芯片外上位机的空间组织。
2. [AMD / Xilinx PYNQ-ZU Base Overlay 模块图](https://xilinx.github.io/PYNQ-ZU/overlays)：参考功能模块、硬件区域边界和外部接口的简洁表达。

以上图片已查看，仅借鉴表达方式。本图重新绘制，连接、模块和算法均以本项目为依据，不沿用参考项目的音频链路或未核实的接线。

## 可复现生成

在 `contest_v3` 目录中，使用已具备 PySide6 的 Python 环境：

```powershell
python -B tools/draw_pl_ps_system.py
python -B tools/render_system_diagram.py report/figures/pl_ps_v3/system_zh.json --output report/figures/pl_ps_v3/system_zh
python -B tools/render_system_diagram.py report/figures/pl_ps_v3/system_en.json --output report/figures/pl_ps_v3/system_en
```

第一条输出两份 JSON 和 `evidence.json`，后两条分别输出四种格式。下一步可在 draw.io 中替换图片预留、编辑模块或导出所需尺寸。直接编辑 draw.io 不会反向更新 JSON。兼容别名 `system.*` 是导出后的中文版副本；正式使用建议选明确带 `_zh` / `_en` 的文件。

## 核验

`evidence.json` 记录十四份项目来源的 SHA256，包括实际工程导入的视觉与 GPU RTL、冻结 HWH 的六个关键模块身份和实际 BD 的 HP 总线连接。新增模块与分支已对照 `axis_rgb_dual_mask_capture`、`axis_binary_mask_pair`、`axis_rgb_mask_frontend`、`scene2d_c4m7_core`、`scene2d_c4m3_core` 和 `scene2d_clear_fill_renderer`。`validation.json` 记录两版文字宽高、连线端点、正交路径、穿越无关模块检查、SVG / draw.io 解析、双语布局一致性与 PDF 单页导出检查。两个 PDF 均已回渲染并人工查看，英文图无中文残留。

## 建议图题

中文：GESTURE PLAY 的 PL–PS 协同架构。PL 视觉前端经共享 DDR 向 PS 提供 RGB 与双掩膜数据，PS 完成手势识别和交互处理，并生成 Scene 命令，由独立 Scene2D GPU 渲染后输出 HDMI；最新视觉状态同时驱动灵巧手调度。

English: PL–PS architecture of GESTURE PLAY. The PL vision front end transfers RGB frames and dual masks through shared DDR for gesture recognition and interaction processing on the PS. Scene commands are then rendered by an independent Scene2D GPU and displayed through HDMI, while the latest visual state also feeds robotic hand control.
