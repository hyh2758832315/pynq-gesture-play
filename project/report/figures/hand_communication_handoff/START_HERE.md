# 灵巧手驱动与低负荷通信：重绘交接包

交接日期：2026-11-01。

请在现有四张母图的基础上调整排版、配色与图形表现，用于视频、报告和海报。前三张解释 系统的灵巧手控制实现；第四张提供历史板测与离线同用例数据，图内已标明范围。

## 先打开什么

1. `figures/hand_communication_all.pdf`：四页总览。
2. `figures/01_logic.drawio`、`02_sequence.drawio`、`03_packet.drawio`：文字、模块、箭头可单独编辑。
3. `figures/04_comparison.svg`：数据图矢量文件；优先用 `data/comparison_metrics.csv` 和绘图脚本重新排版。
4. `TECHNICAL_NOTES.md`：每张图的含义、通信格式、统计口径和应保留的技术细节。

## 文件结构

| 目录/文件 | 内容 |
|---|---|
| `figures/` | 四张高清 PNG/SVG/PDF，前三张 draw.io/JSON，小尺寸预览，四页合并 PDF |
| `data/raw/` | H143/H150/H164 原始板测分析 JSON、归档离线 verification-final.json |
| `data/comparison_metrics.csv` | 对比图逐项数据、单位、来源和工况 |
| `data/comparison_data.json` | 聚合结果、计算公式、数据来源 SHA-256 |
| `data/packet_fields.csv` | 13 字节位置指令的逐字节表 |
| `data/protocol_examples.json` | 位置、启动读取、卸力写入/读回的编码样例 |
| `data/packet_check.json` | 本地实际 SDK 经内存串口校验的位置命令结果 |
| `reference_only/` | 冻结运行时与 SDK 的相关源码副本，供核对逻辑，不构成可上板项目 |
| `scripts/` | 场景重绘、数据图重绘、数据与文件哈希检查脚本 |
| `SOURCE_INDEX.json` | 来源路径、文件 SHA-256 及用途 |
| `FILE_MANIFEST.json` | 交接包内全部文件的 SHA-256 |
| `THIRD_PARTY_NOTICES.md` | SDK/Orca 参考代码的原始许可说明 |
| `VALIDATION.md` | 独立重绘、数据复算及完整性检查结果 |

## 重绘约定

- 动作调度窗口统一写 **t**，中间变化点写 **t₁、t₂**，保持 `0 < t₁ < t₂ < t`。
- 保留“只取最新状态”“同态保持”“default 无额外等待”“逐 ID 写入＋ACK”四个核心意思。
- CPU 时间、墙钟时间、理论串行线时间分开命名；图 04 上下区的实测/离线标识保留。
- 图 03 的字节、地址、长度和校验和以数据表为准。SCSCL 高字节在前；不要根据 SDK 常量名字中的 `_L` 推断字节序。
- 17 表示配置的电机数量。机械关节/独立自由度图需结合实物标注，不能直接替换这个名称。
- 署名区域留空。字体可以替换为思源黑体等中文字体；第三方源码的原始许可与版权文本保留。

推荐沿用深粉 `#bf286e`、深蓝文字 `#172b3a`、蓝 `#25638d`、青绿 `#197b71` 和浅灰底。更改配色时同时更新图例。海报可裁出某个子图；其量纲、来源与工况说明一并保留。避免从不同测试拼成一个没有定义的整机“提升倍数”。

## 重新生成

在交接包根目录，使用已有相应 Python 环境：

```powershell
# 仅核对数据、字节样例和文件完整性：只需要 Python 标准库
python scripts/check_data.py

# 前三张：需要 PySide6；输出 generated/，不覆盖母图
python scripts/redraw_scenes.py

# 第四张：需要 Matplotlib / NumPy；可用 --font 指定中文字体
python scripts/plot_comparison.py --data data/raw --output generated
# 已有外置依赖目录时可追加 --deps 路径
```

结果是 `generated/` 中的 PNG/SVG/PDF，前三张还包含 draw.io。下一步以预览图检查文字溢出、箭头方向、数据与单位，再交付最终排版；若有意修改包内原文件，`check_data.py` 的原始哈希检查会报告变更，保留初始包即可追溯。

当前交接包只整理本地材料，没有访问板卡、启动项目或驱动电机。CPU/RSS 的最终版配对测试尚未补测；当前图中的资源数据为明示范围的历史进程 CPU 观测。
