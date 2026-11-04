# S2V1 Tile 视频格式

## 1. 范围

S2V1 将 PC 端视频确定性转换为冻结 C6I/C4M7 可直接消费的
Asset、Palette、Tilemap 和 Scene packet。编码在 PC 执行，PYNQ PS 负责校验、
调度和 DMA，PL 继续使用现有 2D renderer、双 framebuffer、vblank 与 HDMI。

S2V1 V1 固定为 320x180、30/1 fps CFR、16x16 tile、20x12 tilemap。
编码器在底部补 12 行得到 320x192，renderer 输出时裁剪回 320x180。
FRAME8、H.264/H.265、音频和新增 RTL 不属于 V1。

## 2. 硬件映射

| 项目 | V1 值 |
| --- | --- |
| Asset bundle slot 0 | 1x1 透明占位 |
| Asset bundle slot 1 | 256x240 INDEX4 tile atlas |
| Asset bundle slot 2 | 1x1 透明占位 |
| Tile atlas | 16x15 个 16x16 tile，共 240 个 |
| Tilemap | 20x12，screen tile N 映射 atlas tile N |
| Palette bank | tile N 固定使用 `N % 15`，bank 15 保留 |
| Scene | `CLEAR`、`DRAW_TILE_LAYER`、`END_FRAME` |

每个 GOP 提交一次 Palette packet。Tilemap 在启动、seek 或 generation 恢复时提交。
每帧提交 Asset bundle packet 和 Scene packet。Asset、Palette、Tilemap 和 Scene
generation 必须匹配后 renderer 才可开始该帧。

index 0 保持硬件透明语义；视频像素只使用 index 1--15。透明像素显示 Scene
background color。V1 默认 background 为黑色。

## 3. `.s2v` 容器

容器使用 ZIP32/ZIP64 标准解析器，所有 entry 使用 `ZIP_STORED`，时间戳固定为
1980-01-01 00:00:00，路径使用 ASCII 正斜杠，禁止重复路径、绝对路径和 `..`。
固定 entry 顺序如下：

1. `tilemap.bin`
2. `gops/NNNNNN/palette.bin`
3. `gops/NNNNNN/frames/NNNNNNNN.asset.bin`
4. `gops/NNNNNN/frames/NNNNNNNN.scene.bin`
5. `manifest.json`

`manifest.json` 使用 UTF-8、排序 key、紧凑分隔符和末尾换行。它至少包含：

- `format="S2V1"`、`version=[1,0]`
- width、height、padded height、tile size、fps numerator/denominator
- frame count、GOP size、duration
- 可选 `encoding.quality_profile`；缺失时按 `legacy` 解释
- 每个 entry 的 path、length、CRC32 和 SHA-256
- 每帧 frame index、PTS、generation 以及所属 GOP

同一规范化输入、编码参数和编码器版本必须生成逐字节一致的 `.s2v`。

## 4. 码本与帧编码

GOP 默认 30 帧。240 个 tile 按 `tile_id % 15` 分入 15 个固定 palette bank。
每个 bank 从该 GOP 对应 tile 的 RGB555 直方图中按频次选择 15 个颜色，频次相同
时按 RGB555 数值升序。颜色展开到 8 bit channel 时使用 bin 中心值。

每个像素选择同 bank 中平方 RGB 距离最小的颜色，距离相同时选择较小 index。
编码 index 为 1--15。padding 使用黑色并执行相同量化。首版不使用运动补偿、
熵编码、跨 GOP 预测或有损帧丢弃。

编码器提供两个 PC 端质量 profile：

- `legacy` 保持上述独立 GOP 高频排序，默认 Python API 使用该 profile，以兼容既有
	artifact 的逐字节输出。
- `stable` 保持每个 GOP 的颜色集合和 legacy 最近邻量化结果，对当前 GOP 的 15 个
	可见颜色槽执行确定性最小代价匹配。匹配成本按上一 GOP 最后一帧对应 index 的实际
	像素使用次数加权，随后只重映射 INDEX4 index，使硬件等价 RGB 与 legacy 完全一致。

`stable` 不改变 Tilemap、Palette、Asset 或 Scene packet 的数量、大小、generation、
上传顺序和持续带宽。其目标是减小 Palette 在新 framebuffer present 前生效时，旧
framebuffer token 被新颜色槽解释造成的 GOP 边界色闪。

## 5. 字节预算

| Packet | V1 大小 |
| --- | ---: |
| Tilemap | 1,040 B，启动/seek 提交 |
| Palette | 1,088 B，每 GOP 提交 |
| Asset bundle | 30,897 B，每帧提交 |
| Scene | 4,160 B，每帧提交 |

30 fps 的持续 Asset+Scene 下行约 1,051,710 B/s，即约 8.41 Mb/s；GOP Palette
开销约 1.1 KiB/s。该值是格式预算，最终以 Agent 和板端实测为准。
`legacy` 与 `stable` 的板端字节预算相同；stable 容器仅增加可选 manifest 元数据。

## 6. PC 缩放对照

输入视频仍按比例缩放并居中补黑边至 320x180。CLI 支持独立于调色板 profile 的
`--resize-filter legacy|area|lanczos`：`legacy` 保留 PyAV 原有默认行为；`area`
用于面积重采样对照；`lanczos` 用于轮廓细节对照，需同时观察振铃和色块量化后的误差。
默认仍为 `legacy`，Studio 既有编码调用保持原行为。

```powershell
python -m pynq_multimodal_game.video_cli encode input.mp4 area.s2v --quality-profile spatial-resident --resize-filter area
python -m pynq_multimodal_game.video_cli encode input.mp4 lanczos.s2v --quality-profile spatial-resident --resize-filter lanczos
python -m pynq_multimodal_game.video_cli verify area.s2v
python -m pynq_multimodal_game.video_cli verify lanczos.s2v
```

该选项只改变 PC 源帧缩放，继续沿用现有色块修复、palette residency 与 packet 格式，
逻辑像素数、帧率和 FPGA 输出模式保持不变。编码摘要记录 `resize_filter`；对照时保存
摘要及源文件哈希。具体素材的清晰度收益和 HDMI 观感需另做 A/B，当前测试验证滤波
调用、真实无损源视频缩小、重复解码一致性与既有格式兼容。

## 7. 错误行为

reader 在返回任何可播放帧前校验 manifest schema、版本、固定参数、entry 路径、
长度、CRC32、SHA-256、frame/generation 连续性以及 packet ABI。任一失败使容器
整体无效，不更新 active 视频。

板端 stage 完成全部 chunk 与文件 SHA-256 校验后才能 activate。错误 BUILD_ID、
ABI、重复冲突 chunk、中断上传、generation 缺口、DMA/renderer error 或超时均保持
上一 active 视频。VIDEO mode 与 GAME mode 互斥，切换必须等待当前 DMA 和 renderer
边界。