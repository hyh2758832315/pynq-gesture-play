# PL–PS 系统框图

绘制日期：2026-11-01。唯一项目基线为独立目录 `contest_v3`：PYNQ-Z2 / xc7z020clg400-1，Vivado 2026.1，冻结 R15b 系统运行包及 R16 手部运行时，BUILD_ID `0xC0061000`。未混用当前开发树中的 HDMI 标识候选包或历史音频设计。

## 文件

- `system.drawio`：draw.io / diagrams.net 原生可编辑图，模块、标题与连接线可分别修改。
- `system.svg`：文本及几何均为矢量，适合排版。
- `system.pdf`：单页矢量导出，适合论文和答辩材料。
- `system.png`：4800×3260 高分辨率预览。
- `system.json`：统一场景数据；修改此文件后可重新生成以上四种格式。
- `evidence.json`：八份实际来源的 SHA256、HWH 模块核验和 BD 的 HP 总线连接。
- `pdf_check.png`：从最终 PDF 单独回渲染的版面核验图。

## 图的含义与抽象边界

蓝色视觉前端与紫色渲染 GPU 在 PL 内明确分区，并以竖向分隔线强调。PL 与 PS 使用独立外框；DDR3 位于芯片外，PS 中画的是 DDR 控制器与 DMA 使用的共享缓冲抽象，不是将 DDR 内存放进 PL。

PL 固定像素处理形成原始/滤波双掩膜；PS 使用 OpenCV 提取轮廓、凸包、凸缺陷、位置和三态手势，算法不是 PL 上的神经网络。图中的“RGB 旁路 + 双掩膜”表示采集分支汇总，不表示 RGB 经过二值掩膜后仍保留颜色。为控制主图复杂度，帧拥有权、生命周期、VDMA 和 SG DMA 汇总在一个采集模块中。

BD 实际连接：`frame_dma → HP1`、`moments_dma → HP3`、`axi_dma MM2S → HP0`。Scene2D 双逻辑帧缓冲位于 BRAM，GPU 扫描后接独立 OSD 和 rgb2dvi。PS 使用 MMIO 更新 OSD；应用经 Scene 编译、命令/资源 DMA 才进入 GPU，不存在视觉前端直接驱动图形光栅化的通路。

本图省略了 HP2 return_dma 调试回读通路、逐个 GPIO 状态寄存器、时钟/复位互连细节与视频解码内部实现；主图定位是运行系统分工，不是逐网表连线图。摄像头 I²C/SCCB 控制线是通过 PL camera_iic IP 执行的 PS 控制路径。上位机一侧的 Ethernet 汇总 SSH 标准安装、VVGP Agent 控制/内容和 HTTP 按需回传，不表示这些操作都进入 Agent 同一服务。灵巧手经 PS 独立动作进程、USB SDK 访问，未将其误接到 PL GPIO。

## 可复现绘图

独立目录中附带报告渲染工具：`tools/render_system_diagram.py`。在 `contest_v3` 根目录，使用具备 PySide6 的 Python 环境执行：

```powershell
python -B tools/draw_pl_ps_system.py
python -B tools/render_system_diagram.py report/figures/pl_ps_v3/system.json --output report/figures/pl_ps_v3/system
```

第一条重新提取项目证据并输出场景和来源 JSON；第二条输出 SVG、draw.io、PNG、PDF。下一步可在 draw.io 中替换外设图片占位、调整注释，再导出投稿尺寸。若直接编辑 draw.io，其修改不会自动反向写入 JSON。

本机使用仓库根 `.venv/Scripts/python.exe`（Python 3.13.2 / PySide6），无需新增绘图库或联网服务。初次 offscreen SVG 导出字体显示方框，已经通过原生 Windows Qt 字体后端和显式加载 Microsoft YaHei 修正，并以最终 PNG 和 PDF 回渲染确认；最终版本不再使用该失败导出。技能 frontmatter 已用系统 skill-creator 验证器检查通过（复用本机现有带 PyYAML 的 Python）。

本次仅新增图、技能与绘图脚本，不修改冻结运行包、硬件源、现有报告、原封存 manifest。工具技能用于可复用制图，不被当作算法创新或新的硬件验收证据。

## 建议图题

GESTURE PLAY 的 PL–PS 协同架构。PL 视觉前端通过共享 DDR 将双掩膜帧交给 PS 完成手势识别；PS 交互逻辑生成 Scene 命令，由独立 Scene2D GPU 渲染并叠加 OSD 后输出 HDMI。最新视觉状态同时供交互和灵巧手调度消费，上位机通过以太网完成内容管理与按需观察。
