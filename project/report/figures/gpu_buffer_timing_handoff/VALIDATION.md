# 交付检查

日期：2026-11-01。当前基线：contest_v3 / R15b / BUILD_ID 0xC0061000。

| 检查 | 结果 |
|---|---|
| 当前 ABI 打包 | 4,160 B Scene、1,088 B Palette、FILL_RECT 字段与 INDEX4 半字节顺序通过 |
| 当前驱动类 + 内存 DMA/MMIO | 两帧提交成功；呈现 seq 提前更新时，仍等待 present count 到达目标 |
| 资源提交 | 等待 Palette accepted 与 generation；损坏 CRC 在发 DMA 前被拒绝 |
| 容量边界 | 超过128条命令被拒绝；暂存 buffer 在 DMA 已完成后释放 |
| 配置与源码 | 当前 overlap 关闭；100 MHz / 74.25 MHz；frame-swap 接 vblank_start |
| 数据表 | 7项逻辑容量和1:3对照；720p配置周期计算；52步内存后端轨迹 |
| 包内独立重绘 | 三张 PNG 与原输出逐像素一致 |
| 包内独立数据重建 | 9个生成的数据文件与原件逐字节一致 |
| 版面与格式 | 文本宽度通过；SVG/draw.io可解析；节点边界和正交连线通过；合并PDF为3页 |
| 溯源与打包 | SHA-256清单及ZIP完整性通过 |

图稿已检查文字和连线，容量条按数值比例，呈现时间轴按事件顺序。驱动验证使用原始类实现和内存后端；图中的跨时钟机制依据导入RTL核对，验证方式为源码核对与内存后端测试。

独立复现命令与预期输出见 START_HERE.md；构造输入和范围见 data/verification.json。
