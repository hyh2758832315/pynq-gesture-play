# PL–PS 系统框图

图稿依据 2026-11-01 系统基线：PYNQ-Z2 / xc7z020clg400-1，Vivado 2026.1，BUILD_ID `0xC0061000`。模块身份与数据流由随附来源索引核对。

## 文件

- `system.drawio`：draw.io / diagrams.net 原生可编辑图，模块、标题与连接线可分别修改。
- `system.svg`：文本及几何均为矢量，适合排版。
- `system.pdf`：单页矢量导出，适合论文和答辩材料。
- `system.png`：4800×3260 高分辨率预览。
- `system.json`：统一场景数据；修改此文件后可重新生成以上四种格式。
- `evidence.json`：八份实际来源的 SHA256、HWH 模块核验和 BD 的 HP 总线连接。
- `pdf_check.png`：从最终 PDF 单独回渲染的版面核验图。

## 图的含义与抽象边界

蓝色视觉前端与紫色渲染 GPU 在 PL 内明确分区，并以竖向分隔线强调。PL 与 PS 使用独立外框；DDR3 位于芯片外，PS 区域绘制 DDR 控制器及 DMA 使用的共享缓冲抽象。

PL 固定像素处理形成原始/滤波双掩膜；PS 使用 OpenCV 提取轮廓、凸包、凸缺陷、位置和三态手势，采用经典颜色分割与几何特征分类。图中的“RGB 旁路 + 双掩膜”汇总独立 RGB 支路与原始/滤波掩膜支路。为控制主图复杂度，帧拥有权、生命周期、VDMA 和 SG DMA 汇总在一个采集模块中。

BD 实际连接：`frame_dma → HP1`、`moments_dma → HP3`、`axi_dma MM2S → HP0`。Scene2D 双逻辑帧缓冲位于 BRAM，GPU 扫描后接独立 OSD 和 rgb2dvi。PS 使用 MMIO 更新 OSD；应用经 Scene 编译和命令/资源 DMA 进入 GPU，视觉前处理与光栅化通过 PS 逻辑衔接。

本图省略了 HP2 return_dma 调试回读通路、逐个 GPIO 状态寄存器、时钟/复位互连细节与视频解码内部实现；主图呈现运行系统分工，逐网表连接见 Vivado Block Design。摄像头 I²C/SCCB 控制线是通过 PL camera_iic IP 执行的 PS 控制路径。上位机一侧的 Ethernet 汇总 SSH 标准安装、VVGP Agent 控制/内容和 HTTP 按需回传，各操作由对应的 SSH、Agent 与 HTTP 服务处理。灵巧手通过 PS 独立动作进程与 USB SDK 访问。

## 可复现绘图

工程附带渲染工具 `tools/render_system_diagram.py`。在 `project` 根目录，使用具备 PySide6 的 Python 环境执行：

```powershell
python -B tools/render_system_diagram.py report/figures/pl_ps_v3/detailed_v1/system.json --output build/output/figures/detailed
```

命令从随附场景 JSON 输出 SVG、draw.io、PNG 和 PDF；`generator_snapshot.py` 保存该版图形生成逻辑供查阅。下一步可在 draw.io 中替换外设图片占位、调整注释，再导出投稿尺寸。draw.io 与 JSON 分别维护，后续编辑选定其中一种作为母稿。

图稿生成环境为 Python 3.13.2 / PySide6，采用原生 Windows Qt 字体后端与 Microsoft YaHei；PNG 和 PDF 回渲染已确认中文与版面显示。

图稿通过场景 JSON、来源索引和渲染脚本复现；硬件验证结果见 [验证汇总](../../../validation.md)。

## 建议图题

GESTURE PLAY 的 PL–PS 协同架构。PL 视觉前端通过共享 DDR 将双掩膜帧交给 PS 完成手势识别；PS 交互逻辑生成 Scene 命令，由独立 Scene2D GPU 渲染并叠加 OSD 后输出 HDMI。最新视觉状态同时供交互和灵巧手调度消费，上位机通过以太网完成内容管理与按需观察。
