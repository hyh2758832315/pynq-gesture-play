# 视觉识别、双路跟随与接口细节

## 1. 基线与职责

入口是 `agent/cli.py` 的 c6i-vision-button 分支，创建 `pl_button_factory.py` 中的 worker。BUILD_ID=0xC0061000。该工厂选用 `SharedDualMaskHardware`，再用 `LatestCaptureHardware` 包装；识别器为 `DualMaskFullFrameTracker(dilate_iterations=4)`，OSD 观察者为 `button_osd.ObservationHub.publish`。

图按这一实际路径绘制，不混用目录中仍保留的旧 RGB 上传识别或旧音频融合候选。手部后续动作机制沿用上一组交接图。

## 2. PL 像素处理

摄像头固定模式 1280×720；DVP 经现有采集/去马赛克通路得到三通道像素。`axis_rgb_dual_mask_capture` 分支提供原图 RGB DMA 和 mask 前处理。

### 2×2 区域缩减

三个字节通道分别计算 `out = (a+b+c+d+2) >> 2`，尺寸变为 640×360。图中的 BGR 表示当前冻结采集字节解释，不能以 RTL 名称带 rgb 推断 Python 数组的通道顺序。

### HSV 与双掩膜

当前识别器 lower=(0,20,70)、upper=(20,255,255)，工厂交错打包得到 `(Hlo,Hhi,Slo,Shi,Vlo,Vhi)=(0,20,20,255,70,255)`。H 使用 0..179 范围。

- 阈值结果 raw 为 0 或 255。
- 滤波分支先做 9×9 二值膨胀，再做 5×5 固定权重平滑；这实现原路径 dilation4 的对应前处理。
- `axis_binary_gaussian5` 是可分离定点权重实现，单轴整数系数 `[51,51,52,51,51]`、归一分母 256；二维输出含取整。不要替换成常见的 `[1,4,6,4,1]` 核去解释当前 RTL。
- raw 经 FIFO 与 filtered 按帧/像素对齐，打包 `{filtered[7:0],raw[7:0]}`。raw 用于保留观测像素，filtered 用于更连续的轮廓。

RGB 旁路仍通过 VDMA 写入 DDR；PS 在预览需要时才复制对应 RGB。不能由“识别只用掩膜”推出 RGB DMA 不运行。

## 3. 帧拥有权与最新帧

`VisionCapturePool.read` 领取完成帧 token，快照 DMS1 包、校验身份/CRC，需要时复制同 token 的 RGB；完成 rearm 和 release 后才交出 CPU 拥有的数组。

`LatestCaptureHardware` 的采集线程持续取帧、核对捕获 frame_id 连续及 epoch/config，保存普通内存快照。待处理槽 `_pending` 仅一个，新帧覆盖尚未被识别读取的旧帧。识别是这个槽的唯一读取者。

容量1指待处理槽；正在识别的快照与底层三槽DMA缓冲另计。

识别帧号是处理次序，包中的 `capture.source_frame_id` 是采集次序；允许识别跳过被替换的采集帧。不要把两个帧号写成始终相等。

来源年龄起点为采集线程拿到 CPU 快照的 `ready_monotonic_ns`。该时间不含传感器曝光和之前的 DMA 延迟，不能直接作为手到屏端到端延迟。

## 4. PS 轮廓与分类

掩膜进入统一显示方向后处理（默认旋转 180°，可选镜像）。在 filtered 上找外轮廓，候选面积至少 2000 px²，按面积保留至多 8 个。

存在上次目标时，当前候选评分为：

`score = A/Amax + 2·IoU(current_bbox, previous_bbox) + max(0,1−3d)`

d 为两框中心距离除以 `sqrt(640²+360²)`。无上一框时按面积项；算法始终选择本帧观测轮廓，没有用预测框替代观察。

几何量：A 为轮廓面积，Aₕ 为凸包面积，`r=(Aₕ−A)/A×100%`。合格凸缺陷满足夹角≤90°、深度大于 `30×clip(max(w,h)/300,0.5,1.5)` 像素；`n=缺陷数+1` 是形状特征。

| 条件 | 原始 code | 稳定后的 RPS |
|---|---|---|
| n=1 且 r<15% | 0 | ROCK |
| n=2 且 r≥15% | 2 | SCISSORS |
| 3≤n≤5 且 18%≤r≤55% | 5 | PAPER |
| 无合格候选 | NO_HAND | UNKNOWN |
| 其它形状/几何错误 | REPOSITION | UNKNOWN |

位置质心使用 raw ∩ 选中轮廓内部的像素矩：`cx=sum_x/N, cy=sum_y/N`。膨胀新增像素和 raw 中的空洞不贡献质心。该质心是分割区域中心，不是解剖学掌心。

最近 5 帧计票，当前 code 属于 0/2/5 且在窗内至少出现 3 次才确认。当前帧不一致时立即进入 PENDING，不沿用旧类别。无手清票；目标框完全不重叠且中心跳变超过 140 像素时也清票。

图 02 的构造输入 `0,0,0,2,2,2` 经生产 `FullFrameTracker` 的规则/投票方法得到 `PENDING,PENDING,0,PENDING,PENDING,2`。测试基类只提供预制的几何观察，未做图像准确率或光照鲁棒性测试。

## 5. 两路输出如何解耦

识别结果回调先给 input_provider 发布同帧结果，再给 OSD observer 发布位置观察，随后才进行可选预览处理。两路读取的是缓存状态，不是互相消费的事件队列。

### A：HDMI 手圈

`ObservationHub` 只要求 bbox/centroid 有效且在 640×360 范围内。握拳标志要求 stable='0' 且 rps='ROCK'。类别待定但位置有效时仍显示绿圈。

显示映射先归一化，恢复像素后等价于 `X=round(2cx+0.5), Y=round(2cy+0.5)`。示例 cx=319.5、cy=179.5 → X=640、Y=360；坐标已处于旋转/镜像后的显示方向。

独立 OSD 线程目标周期 33,333,334 ns；每轮读取最新快照，不等待游戏 tick。PL 覆盖位于最终扫描输出，像素数据/DE/HS/VS 同时通过 3 级寄存器。采用常量行半径查表绘制圆环，不读写额外帧缓冲。

真实 720p 圈：非握拳外/内半径 48/42 px，握拳 32/26 px；中心点条件为 |dx|≤4 且 |dy|≤4。颜色为亮绿/亮红；RTL 默认扫描字序是 `{R,B,G}`，因此其绿色常量数值不能直接当作常规 RGB 十六进制颜色。

### B：实体灵巧手

`peek_hand_classification()` 拷贝已识别的最新类别与 run/config/frame/source_at，不调用消费游戏/菜单事件的 sample。手部发布与独立进程 owner 读取这一状态，按 t 窗口执行，忙时只保留最新输入。

合格来源有手但类别暂未确认时 gesture=None，保持已有批准姿态；明确 NO_HAND 产生 default。来源过期或身份改变进入外层 owner 的恢复/交接逻辑。跟随是否可驱动还受当前页面权限、预览交接和 owner 生命周期控制，不能把图中的数据可达理解为所有页面都无条件驱动电机。

## 6. DMS1 字节布局

正常尺寸为 640×360，P=230400。负载字节数 `ceil(P/2)×4=460800`，尾部 64 B，合计 460864 B。

负载内存顺序：`raw0, filtered0, raw1, filtered1, ...`。每个原始值只能为 0/255，滤波值为 0..255。若像素数为奇数，末尾补零到 4 字节。

尾部按 `<16I` 小端 uint32 解码：

| word | 字段 | 当前示例 |
|---:|---|---|
| 0 | MAGIC | 0x31534D44，字节为 D M S 1 |
| 1 | VERSION_LENGTH | 0x00100001 |
| 2 | frame_id | 1 |
| 3 | config_id | 1 |
| 4 | epoch | 1 |
| 5 | height<<16 \| width | 0x01680280 |
| 6 | 像素数 | 230400 |
| 7 | payload_bytes | 460800 |
| 8 | status | 0 |
| 9 | Hlo,Hhi,Slo,Shi 四字节 | 0xFF141400 |
| 10 | Vlo,Vhi 两字节，其余0 | 0x0000FF46 |
| 11 | PAIR_FORMAT | 0x00010802 |
| 12–14 | 保留 | 0 |
| 15 | CRC32 | 示例 0x5B04B719 |

CRC32 覆盖负载与尾部前 15 字，不包括 CRC 字自身；RTL 反射多项式 0xEDB88320、初值0xFFFFFFFF、最终取反，与 Python zlib.crc32 对应。

构造样例 `dms1_example.bin` 首 8 字节 `FF FF 00 40 FF 80 00 00`，其余负载为 0。这是协议示例，不是摄像头实拍。已用生产 decode_dual_mask 解码；损坏 CRC 和错误 frame_id 均被拒绝。

## 7. OSD MMIO 与 CDC

基地址0x43C20000，范围4096字节。ID寄存器0x00=0x4F534401；0x04 bit0=BUSY；0x08 bit0=COMMIT。

| 偏移 | 字段 | 握拳中心示例 |
|---|---|---|
| 0x10 | FLAGS，bit0 enable，bit1 valid，bit2 fist | 0x00000007 |
| 0x14 | X低16位，Y高16位 | 0x01680280 |
| 0x18 | 保留 | 0 |
| 0x1C | TTL 放在 bit[23:16] | 0x000F0000 |
| 0x20 | HAND_SEQ | 1 |
| 0x24 | 保留 | 0 |

先读 BUSY；忙时直接跳过本轮，不写影子寄存器。空闲时写6字，再写COMMIT=1。AXI域将影子寄存器冻结到 mailbox 并翻转req；req经2FF同步到像素域，捕获pending_cfg；到帧边界才换active_cfg并回ACK；ACK经2FF回AXI域，BUSY清零。

TTL依据原始来源年龄：`min(15, floor((0.25−age_seconds)×60))`，非新鲜或无效位置为0。相同观察不会刷新源时间；硬件仅在HAND_SEQ变化时装入TTL，防止反复提交旧观察续命。TTL降至0隐藏手圈。

离线示例：source=1.0s时提交握拳中心，TTL=15；在1.1s重复读，原source与序号不变，提交预算为9；1.25s已无有效TTL。BUSY时写次数不增加。

## 8. 数据与示例验证范围

像素数、包字节数和窗口票数依据源码与格式；OSD 目标 30 Hz 与 HDMI 扫描 60 Hz 标注为配置值。板端 FPS、识别准确率、CPU 占用、机械延迟与手到屏延迟按各自工况采集，分别列出测量方法和结果。

本组离线示例覆盖源码对应、协议解码、独立规则/投票和内存 MMIO 行为。RTL 仿真、综合与板端验收属于独立验证层级，入口见[验证汇总](../../validation.md)。参考代码附来源索引与 MIT 说明。
