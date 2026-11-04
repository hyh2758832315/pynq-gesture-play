# 视觉识别与双路跟随：重绘交接包

图稿依据 2026-11-01 集成系统基线，BUILD_ID 0xC0061000；源码身份和字段核验见随附来源索引。

这组接在“灵巧手驱动与低负荷通信”之后，回答三个问题：图像如何变成手势、为什么位置与分类可分别更新、怎样让 HDMI 与实体手独立读取同一观察。

| 图 | 主要内容 | 使用建议 |
|---|---|---|
| 01_vision_dual_follow | PL 双掩膜、PS 最新帧处理、HDMI/实体手双路发布 | 视频主图、报告总图、海报 |
| 02_recognition_logic | 轮廓特征、质心、三态规则、5 帧确认和两类输出 | 算法讲解、报告方法、局部动画 |
| 03_dms1_osd_timing | DMS1 像素编码、OSD 寄存器、跨时钟帧边界提交 | 报告实现、技术特写 |

先打开 `figures/vision_dual_follow_all.pdf`。三张均有原生可编辑 draw.io、SVG、高清 PNG、矢量 PDF 和场景 JSON。箭头、文字和手圈示意可单独修改。

## 资料目录

- `TECHNICAL_NOTES.md`：处理算法、数据布局、刷新逻辑与统计范围。
- `data/verification.json`：离线构造示例检查结果。
- `data/rules.csv`、`vote_trace.csv`：规则输入和多帧确认序列。
- `data/dms1_example.bin`、`dms1_trailer.csv`：完整可解码的构造包、16 字尾部表。
- `data/osd_registers.csv`：一组有效握拳位置的寄存器提交示例。
- `data/formats.csv`：图像、双掩膜与 OSD 配置的逻辑尺寸/字节数。
- `reference_only/`：图稿基线运行时与导入 RTL 副本，用于核对机制；部署采用工程内的配套运行包。
- `scripts/`：重绘脚本、离线校验脚本和文件完整性检查脚本。
- `SOURCE_INDEX.json`、`FILE_MANIFEST.json`：原始路径、用途与 SHA-256。

## 重绘时保留

1. PL 做逐像素前处理；PS 做轮廓、几何分类与多帧确认。
2. 原始 mask 用于选中区域的像素质心，滤波 mask 用于轮廓。质心是分割区域中心。
3. 位置有效与类别确定分开：类别待定时有效位置仍可显示绿圈。
4. 识别最近 5 帧内同类至少 3 次，且当前帧必须同类；它是时序确认规则。
5. 采集层最新帧槽容量为 1；结果层包含两个独立读取路径，图中分别表示采集和结果发布。
6. HDMI 扫描、OSD 提交和视觉识别分别标注节拍；30 Hz/60 Hz 为配置值，识别 FPS 按输出结果统计。
7. 实体手调度窗口写 t（当前配置 3 s），手圈按最新有效位置独立更新。
8. DMS1 为小端格式。上一组灵巧手 SCSCL 的 16 位字段高字节在前，两种接口分别标注。
9. 示例序列与二进制包标注为“构造示例”，用于验证规则和编码；实拍与准确率采用单独测试。

沿用深粉 `#bf286e`、蓝 `#25638d`、青绿 `#197b71`、深蓝文字 `#172b3a`。修改颜色时保留分区/图例语义。手圈小图仅解释状态，实际 HDMI 半径见技术说明。

## 复现

在交接包根目录，用已有 Python 环境运行：

```powershell
# 标准库：核对文件哈希和表格
python scripts/check_package.py

# PySide6：从场景 JSON 重绘三张图到 generated/
python scripts/redraw.py

# NumPy + OpenCV：使用参考源码再做构造示例检查
python scripts/verify_vision_figure.py --source-root . --output regenerated_data
```

预期输出：三组 SVG/PNG/PDF/draw.io；重新生成的数据与 PASS JSON。下一步检查长文字、连线、字节顺序和指标名称，再排入报告、海报或视频。draw.io 与 JSON 分别维护，后续编辑选定其中一种作为母稿。
