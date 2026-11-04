# GPU 缓冲与呈现时序：重绘交接包

图稿依据 2026-11-01 系统基线：PYNQ-Z2 / XC7Z020CLG400-1，Vivado 2026.1，BUILD_ID 0xC0061000。当前三配置的性能与资源见 [GPU 优化与验证](../../gpu_optimization.md)。

| 图 | 内容 | 使用建议 |
|---|---|---|
| 01_gpu_buffers | PS 提交、PL 命令/资源、双帧缓冲、连续 HDMI 扫描 | 视频主图、海报、报告架构图 |
| 02_gpu_present_timing | 上传、渲染、消隐换页、ACK、软件完成收据 | 视频分步动画、报告实现时序 |
| 03_gpu_encoding_storage | 命令字段、INDEX4/token/RGB 编码、容量对照、资源提交 | 技术特写、报告表格、海报数据区 |

先看 `figures/gpu_buffer_timing_all.pdf`。每张均有 JSON、原生可编辑 draw.io、SVG、高清 PNG、矢量 PDF。图形、连线、文字分别可编辑。

## 交付内容

- `TECHNICAL_NOTES.md`：机制、坐标/字节字段、关键源码定位与解说建议。
- `data/`：二进制构造示例、命令/头部表、缓冲容量表、配置时序、52 步驱动内存后端轨迹。
- `reference_only/`：图稿基线的 Python 和导入 RTL 副本，用于核对机制；部署采用工程目录中的配套运行包。
- `scripts/`：重绘、数据重建与清单检查脚本。
- `SOURCE_INDEX.json`、`FILE_MANIFEST.json`：来源路径与 SHA-256。
- `VALIDATION.md`：检查方法与结果。

## 重绘保留的关键语义

1. 当前配置的上传与渲染串行，后台绘制与前台扫描并行。
2. 命令 bank、资源 bank、图像 bank 分别标注，呈现三类缓冲的职责和生命周期。
3. 上传接受、渲染完成、呈现完成是三个节点；软件结合对应序号和状态确认完成。
4. 换页在 `vblank_start` 发生，随后有效像素区输出新画面。
5. 像素域先切显示 bank，ACK 回写域后才切写 bank。中间指针可以相同，但像素写入停止。
6. 换页等待期间继续扫描旧前台；这一机制维持显示连续性，其他故障按各模块状态与恢复流程处理。
7. Palette 与 framebuffer 分别提交，图中保留两套独立握手。
8. 16.67 ms 标注为 720p 扫描周期，30 fps 标注为视频目标；GPU 渲染耗时采用核内测量。
9. 112.5 / 337.5 KiB 表示同分辨率的逻辑像素容量；实际 BRAM 利用率由 Vivado 实现报告给出。

颜色沿用深粉 `#bf286e`、蓝 `#25638d`、青绿 `#197b71`、深蓝文字 `#172b3a`。时间轴宽度仅表示顺序，数值容量条宽度为 1:3。

## 独立复现

在交接包根目录运行：

```powershell
# 标准库：核对所有文件及构造包
python scripts/check_package.py

# PySide6：重绘至 generated/
python scripts/redraw.py

# NumPy：当前 ABI 与 sink 类的内存后端检查
python scripts/verify_gpu_figure.py --source-root . --output regenerated_data
```

预期：三个可编辑图组、重建的 CSV/BIN/JSON 与 PASS。下一步在 draw.io 或矢量编辑器润色，保留字段和时序含义，再排入报告/海报或分层制作视频。draw.io 与 JSON 分别维护，后续编辑选定其中一种作为母稿。
