# GPU 缓冲与呈现时序：重绘交接包

2026-11-01。基线为 contest_v3 独立工程、R15b、BUILD_ID 0xC0061000；PYNQ-Z2 / XC7Z020CLG400-1，现有 Vivado 工程版本 2026.1。署名留空。

| 图 | 内容 | 使用建议 |
|---|---|---|
| 01_gpu_buffers | PS 提交、PL 命令/资源、双帧缓冲、连续 HDMI 扫描 | 视频主图、海报、报告架构图 |
| 02_gpu_present_timing | 上传、渲染、消隐换页、ACK、软件完成收据 | 视频分步动画、报告实现时序 |
| 03_gpu_encoding_storage | 命令字段、INDEX4/token/RGB 编码、容量对照、资源提交 | 技术特写、报告表格、海报数据区 |

先看 `figures/gpu_buffer_timing_all.pdf`。每张均有 JSON、原生可编辑 draw.io、SVG、高清 PNG、矢量 PDF。图形、连线、文字分别可编辑。

## 交付内容

- `TECHNICAL_NOTES.md`：机制、坐标/字节字段、关键源码定位与解说建议。
- `data/`：二进制构造示例、命令/头部表、缓冲容量表、配置时序、52 步驱动内存后端轨迹。
- `reference_only/`：当前 Python 和导入 RTL 副本，用于核对图；不是单独可部署工程。
- `scripts/`：重绘、数据重建与清单检查脚本。
- `SOURCE_INDEX.json`、`FILE_MANIFEST.json`：来源路径与 SHA-256。
- `VALIDATION.md`：检查方法与结果。

## 重绘保留的关键语义

1. 当前版本上传与渲染不重叠；绘制后台与扫描前台可以并行。
2. 命令 bank、资源 bank、图像 bank 分开标注；不要把它们画成统一的三缓冲队列。
3. 上传接受、渲染完成、呈现完成是三个节点。渲染序号或呈现序号单独更新均不是充分收据。
4. 换页发生在 `vblank_start`，不是有效像素区；随后有效区才输出新画面。
5. 像素域先切显示 bank，ACK 回写域后才切写 bank。中间指针可以相同，但像素写入停止。
6. 未及时完成换页时继续扫描旧前台；此处描述的是尚未完成提交，不代表所有错误均有自动恢复保证。
7. Palette 与 framebuffer 的提交是独立握手，不画成同一个原子换页。
8. 16.67 ms 来自 720p 扫描配置，30 fps 是视频目标；均不标成实测 GPU 渲染速度。
9. 112.5 / 337.5 KiB 是相同分辨率下的逻辑像素容量，不当作 Vivado 综合后 BRAM 利用率。

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

预期：三个可编辑图组、重建的 CSV/BIN/JSON 与 PASS。下一步在 draw.io 或矢量编辑器润色，保留字段和时序含义，再排入报告/海报或分层制作视频。手工编辑 draw.io 不会回写 JSON，应选择一种母稿维护。

本轮没有读取板卡或启动运行时，也没有修改部署文件和冻结清单。
