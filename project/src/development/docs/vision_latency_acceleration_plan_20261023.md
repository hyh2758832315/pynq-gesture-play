# 视觉延迟加速实施方案

**后续新授权：用户已要求尝试MCP修复PL下沉时序并实现加速。当前独立C0E研发恢复，进展见 [时序修复记录](bringup/2026-10-23_pynq-z2_pl_timing_repair.md)。下文停止状态为上一轮交接快照；R1仍保留，C0E未通过完整门禁前不切换。**

**2026-10-23 07:45 最终状态：用户要求仅保留约2.5%的R1并交接，停止本方案新增实施。以下为历史方案，不构成继续授权。C0E route-r01时序失败（WNS−0.574ns/TNS−55.828ns/356端点），无配对部署包、未上板；已有Explore/负例仿真收尾快照仍running，最终结果未知。以 [FINAL_HANDOFF](bringup/2026-10-23_pynq-z2_osd_FINAL_HANDOFF.md) 为准。**

日期：2026-10-23；项目：Voice View Game；目标：PYNQ-Z2 / xc7z020clg400-1，Vivado 2026.1。
文档类型：项目级可行性与离线自主实施方案；状态：实施中，候选融合与完整板验待完成，`release_ready=false`。
本文件最初按只读材料编制，现随主代理现场实施更新。以下方案与验收标准保持完整；最新轮次原始证据见 [实施记录](bringup/2026-10-23_pynq-z2_visual_latency.md)。

**最新现场更新（R11）**：Copilot 仍停在 turn214/r15 交付点。R1 八条真实 GPU 黄金（`vl21`）、模式/暂停（`vl25`）、两分钟及十分钟 ABBA/稳态（`vl27/33`）通过；十分钟 OSD27.5717Hz/2.44275%单核，无fault/ACK错误。关闭历史 C0C Studio 后黄金整组通过，不代表任意并发客户端已安全。独立C0E完成9接口/49标量网、23参数和旧地址核查；BGR语义修正后全帧数值、24个包的生产解码、8+17+255软件回归、五包双构建及八PC黄金均通过。BGR新综合已完成，impl_1正从固定DCP执行默认完整实现；真实BD/PS7VIP安全reset-r02同时复验中（r01为testbench inout连reg的错误，原FAIL保留）。新候选启动前有阻断，尚未导出配对或上板；R1保持运行。

## 1. 结论与证据边界

推荐从 C0D R1 冻结版本派生独立候选，复用已有 PL 双 mask 流式前处理，替换旧 SKN6 上传/回读及 PS 形态学。
保留 PS 轮廓、质心选择、凸包缺陷、三态投票、现有 VOL1、R1 OSD、GPU 和三游戏玩法。
可行性为“有条件”：已有 RTL、接口和离线数值依据；整机 route、真实启动/首帧、安全 STOP 与同工况收益均须独立通过。
代码存在、PC 模型、ARM check-only、OOC 综合均只证明对应层级；不能代替真实 AXI、连续采集或整板验收。
本轮不开展 PL 全轮廓/CCL/分类器、新模型、旧 PCM/FFT 声音栈复活、R2 批写或大规模控制树优化。

## 2. 确切 R1 基线与当前状态

选定包为 `deliveries/c6i-vision-volume-osd-r16-20261022.zip`，41,429,189 字节，558 清单项 / 559 ZIP 成员。
ZIP SHA256：`2e49d7fc2cb1f60a89ffd69b6d9510278d99897bdc06d609604f581e5a8fbb67`。
身份：BUILD `0xC0060D00`，profile `C6I_VISION_VOLUME_V1`，SDK 1.3 / schema4 / GPU ABI 1.0。
板端历史根目录 `/home/xilinx/voice-view-game/c6i-vision-volume-osd-r16-20261022`，日志 `var/osd-live-r02`。
历史 boot `b40bc22c-b967-4418-a6fb-f614f37376cf`，Agent 921 / start_ticks 29986；这些仅为追溯值，接手须重新核身份。
bit SHA256：`043297126616fd7fb1b3e8d0be531b1266b721f86306b897a6b65e90ac2b57e0`。
HWH SHA256：`3acc9b92e56632c11f3e31e8547e5d1b2fe79db187f53f208f12116f2f0e2db0`；只使用已配对的优化设计产物。

G21 约 10.065 秒窗口：OSD 线程占一个 ARM 核的 2.47960994%，提交 26.9245 Hz，视觉源 5.5637 fps，音量监测 49.7756 Hz。
同窗口 fault=0、ACK error=0；最大 OSD tick 年龄 48.065348 ms，最大音频源年龄 64.972954 ms。
2.48% 不是双核全机占比，也不是已通过同工况 A/B 证明的总 CPU 增量；用户接受该 R1 取舍。
历史 G21 因自定 `<1%` 断言而 FAIL，原报告保持；新验收器应采用明确 R1 口径，保留测量值与真正故障门禁。
已完成本地/ARM 合同、包恢复/清单/AST、八条 PC 黄金、OSD 邮箱/刺激/TTL，以及限定范围实现签核。
前两轮黄金在第三例 STOP 后分别出现线程创建失败、超时，原 FAIL 保留。后续正常重启并关闭历史 C0C Studio 后，`vl21` 八例 GPU 黄金及每例 STOP 全部 PASS；这证明特定无 Studio 工况恢复通过，不等于服务端任意客户端并发问题已根治。
R2 未选用；工作树 integration 中部分 runtime/backend 原型属于 R2，候选软件须从 R1 冻结件恢复，避免混入。

## 3. 当前延迟路径与可证伪假设

当前控制链：camera/demosaic → RGB DDR capture → 全帧复制/resize/方向处理 → SKN6 BGR 上传与 mask 回传 → PS 黄金比较/形态学 → 轮廓/分类/投票 → 发布 → provider → GameInput/Scene → GPU/HDMI。
OSD 从观察结果独立发布并在帧边界提交；HTTP/Studio 预览不是本地游戏控制环，但会竞争 CPU、内存和 DDR。
5.5637 fps 仅表示视觉源新结果更新，平均间隔约 180 ms；它既非单阶段处理延迟，也非手势或光子到光子延迟。
三帧一致投票要求多个新观测；其墙钟等待需逐次测量，不能直接将平均间隔乘固定帧数当完整端到端结果。
局部假设：RGB 搬运、SKN6 往返和 PS 形态学占有可消除成本，流式前处理可提高有效新观测频率并缩短相同投票等待。
最便宜的反证检查是现有计时点分段剖析；若主耗时在采集等待、PS 轮廓或调度，先报告占比，再调整本候选边界。
延迟收益必须伴随分类/位置等价、轻量资源与可靠收尾；低 CPU 片段或更快 OSD 刷新不能单独证明视觉加速。

### R10 实测阶段依据

`vl36-r1-stage-timing.json` 通过现有 `/result.json` 只读采样60.101秒，没有JPEG订阅。300个不同frame、frame跨度377、未采到78个源frame；不能作为无损全帧记录。现场300帧均为NO_HAND，不能外推复杂手轮廓耗时。

| 原路径阶段 / ms | p50 | p95 | p99 | max |
| --- | ---: | ---: | ---: | ---: |
| color_mask（含SKN6与CPU同帧参考） | 66.94 | 74.39 | 79.48 | 99.39 |
| PS morphology | 32.23 | 36.43 | 38.70 | 41.75 |
| input_prepare | 19.87 | 25.70 | 27.04 | 28.64 |
| contours_select | 4.52 | 8.70 | 9.56 | 10.20 |
| shape_stats（该NO_HAND现场） | 0.029 | 0.033 | 0.036 | 0.089 |
| SKN6事务 total_ms（color_mask的子集） | 25.19 | 29.31 | 31.81 | 36.51 |

按每一帧配对相加 `input_prepare+color_mask+morphology`，实测分布为p50 119.09 / p95 128.70 / p99 135.85 / max151.21ms；这里使用配对样本，不是相加分位数。color_mask减去其SKN6子阶段的差值p50 41.86ms，包含CPU参考及该阶段其他开销，不能全称为可省的硬件事务。

这支持继续实施流式双mask：可替换阶段在本现场明显大于轮廓阶段。上述119ms不是加速收益预测，新的S2MM/缓存/等待仍有成本；HTTP观测、NO_HAND工况、采集前等待及真实稳定握拳墙钟延迟均为边界。生产关闭全mask参考比较必须有独立数值验收和协议健康检查，不以关掉正确性验证单独冒称PL加速成功。

`vl37` 只读核实同一boot/owner、Python3.10.4、rotate180/mirror=false、BGR、全视野640x360、`pl_skin_mode=validate`。历史run_config把SharedVisionHardware默认profile/BUILD静态写为VISION/0800；这不是本轮实际Overlay身份，实际C0D身份由配对SHA及Agent HELLO证明。后续新候选应修正自己的run_config来源，不能把这条旧元数据错误误报为Overlay回退。

## 4. C0D 资源、总线与预算

| C0D postRoute 项 | 使用 / 总量 | 约束解释 |
| --- | --- | --- |
| LUT / FF | 28746/53200；44000/106400 | 余量不能换算为可布局 Slice |
| Slice | 12532/13300，94.23% | 仅余 768 个物理站点 |
| BRAM Tile / DSP | 87.5/140；14/220 | 需核 banking、FIFO、对齐及位宽 |
| MMCM / control sets | 3/4；1873 | 时钟、复位、使能组合影响合法打包 |
| WNS / WHS | +0.004 ns / +0.050 ns | setup 仅 4 ps；TNS/THS=0 |

135 条 CDC-15 与父版 I2C/PCLK/方法学警告保留逐项范围复核；既有签核不扩展为通用外部 IO 发布签核。
本轮双mask capture组件OOC综合为1918 LUT / 1460 FF / 4 BRAM Tile / 4 DSP；旧skin_kernel在C0D postRoute层次为566 LUT / 581 FF / 1 BRAM36 / 4 DSP。其他新增生命周期/互联/SG变化仍须计入。顶层综合报告包含尚未链接的OOC黑盒，0 LUT不是整机资源为0的证据，必须以实现link后的报告评估实际可放置Slice和时序。

R11 已有整机 **placed** 报告：33433 LUT、49429 FF、**13113/13300 Slice（98.59%）**、89.5 BRAM Tile、20 DSP、2077 control sets；原件及SHA封存于 `integration/evidence/latency-placement-r01`。相对R1 postRoute多581 Slice、2 BRAM Tile、6 DSP，但两个报告阶段不同，最终增量应在route后重算。当前结论是“该替换链已能放置，routing/时序仍待”，不能称完整实现通过。仅余187 Slice站点，当前不再叠加全PL轮廓/CCL/分类器；先把本次占主耗时的前处理上板量化，保留PS原分类和三帧确认，资源/控制树深度优化后再评估更多下沉。
旧 0900/A00/B00 的资源及层次行只用于理解来源，不得作为 C0D 剩余资源或候选可回收 Slice 的证明。
从 R1 实际 HWH/BD/地址表核查 PS GP/HP、时钟、互联和 DMA 启用方向；不采信“GP0 还剩很多”的无证据结论。
优先替换/重配置旧 `skin_kernel`、`moments_dma` 的 MM2S/S2MM 与 HP3 互联，评估复用 S2MM；不叠加第二套完整算法子系统。
保留 RGB capture/HP1 预览兼容路径；关闭预览订阅不等于原 RGB DMA 自动停止写 DDR。
固定保留 VOL1 `0x43C10000`、OSD `0x43C20000` 及 GPU 既有地址/功能；新增控制地址须按实际映射审计。
新 BUILD/profile/能力标识须查现有注册与占用后分配，不预定值，不复用 800/900/A00/B00/C0C/C0D 身份。

| 逻辑 payload 项 | 字节/帧 |
| --- | ---: |
| 保留的 1280×720 RGB8 DDR 写入 | 2764800 |
| 旧 CPU RGB 读取最低 payload | 2764800 |
| 旧 SKN6 输入含头 / 输出含尾 | 691220 / 230432 |
| 上述旧四项逻辑合计 | 6451252 |
| 新 640×360 双 uint8 mask / metadata | 460800 / 64 |

以上不是实测 HP/DDR 带宽或净节省；新 mask 的 PS 读、cache line、拷贝、burst padding、GPU、音频和预览须另列。
容量预算使用实际槽数、对齐、SG 描述符及 RGB 池计算，记录 CMA 分配前后与峰值；不能只用 payload 作为内存上限。
11520 字节仅为既有分析的行存储示例下界，未含 raw 对齐 FIFO、中间精度、端口复制和元数据，不是 BRAM 预测。
60 fps 对应输入 55.296 Mpixel/s、缩小后 13.824 Mpixel/s；100 MHz 单像素算术预算不构成时序/吞吐保证。

## 5. 替换链与不可变合同

候选链：1280×720 camera stream → 精确 2×2 area 至 640×360 → 现有 HSV 阈值 → raw binary 与四次膨胀等效 9×9 + Gaussian 5×5 sigma=100 → 同帧双 mask/metadata S2MM → 原 PS 轮廓/投票。
**已实施的语义纠正**：C0E的mask支路按R1 `capture_order=BGR` 对相同DMA字节的解释处理，去掉旧RGB前端额外的R/B交换；fork到RGB DDR的字节不变。77项SHA核实的ARM4.5.4参考只置换输入通道字节，raw/filtered黄金不改，已通过全帧前端及capture数值仿真。原RGB源码/B00原件保留。HSV配置必须由识别器lower/upper交错派生为 `(h_lo,h_hi,s_lo,s_hi,v_lo,v_hi)`；本配置是 `(0,20,20,255,70,255)`。旧B00工厂的 `(0,20,70,20,255,255)` 会使S下界超过上界，不可复制；新工厂拒绝倒置/非整数/越界门槛。
raw 仅允许 0/255，filtered 为 uint8 灰度；两路共享 frame_id、epoch、配置/阈值快照、尺寸和有效性，不能用灰度包冒充 SKN6 二值回复。
保留全视野、rotate180/mirror、肤色边界、raw 像素统计、质心/多 blob 选择、三态/未知/丢手中性语义及三帧一致投票。
缩放取整、Gaussian 核/舍入/边界以目标 ARM OpenCV 4.5.4 为参考；常见二项式核或 PC OpenCV 版本不能替代证明。
方向变换仅在逐像素交换等价已证实时后移；180° RGB 倒序不是无需帧存的免费行操作。
AXI video TUSER/SOF、逐行 TLAST 须转换为完整包边界；核行列计数、raw/filtered 延迟对齐、尾部 drain、短长帧与背压。
沿用有界三槽 token、借用/归还和连续 frame_id；生产者/消费者率失配须显式统计与 fault，不默认 latest-wins 或悄悄丢帧。
若未来确需丢整帧，先独立定义 acquired/dropped/consumed 序号和回归；本轮默认不引入该协议变更。
CPU 全 mask 黄金比较可分离到显式诊断/数值验收模式；生产保留长度、序号、CRC（协议已有时）、阈值、状态和健康检查。
保留 run/epoch/config/frame/tick 绑定、sealed/drained/source-quiescent、过期拒绝、故障传播、RETAINED 及在用缓冲保护。
VOL1 固定门槛 11/16/28，事件 TTL 100 ms、ACK 50 ms、观察 500 ms；quiet/rearm、STALE、REARM_NOT_READY 原规则保留。
OSD 手位置 TTL 250 ms、音量 TTL 100 ms，独立发布/帧边界提交；不消费玩法事件、不新增音频 ACK，不将测试刺激送入玩法。
新 backend 将 observed 结果接回 R1 ObservationHub；provider 方向/手势/边沿与 OSD 位置同源，VOL1 保持独立单源只读缓存。
正常STOP在pool证明sealed/drained并停止DMA后，额外回读两个独立DMA已Halted且无错，再断言moments_reset=0并核独立GPIO读回，才释放lease；这样下一fresh worker/epoch可再次启动。未证明排空、DMA仍运行或读回失败一律RETAINED。对应五个故障/顺序合同已PASS；真实首帧/停启仍待现场证明。
`sample`、`sample_with_receipt`、`sample_for_game` 保持一致；preview 异常按既有策略降级，不阻塞 ACK 或游戏控制。

## 6. 真实复位与启动合同

B00 证据：moments_reset `0x413D0000` 默认 0，经 reset AND 门使 control `0x413F0000`、status `0x41410000` 持续复位。
被复位接口的 ARREADY/RVALID 无法完成该次读；Python MMIO 返回后的 deadline 无法保护一次永不返回的 AXI 事务。
已有软件修复顺序：安全独立 DMA 静止/无错 → moments_reset fresh=0 → TRI=0/DATA=1 → readback=1 → 才访问 capture status/control → IIC/配置 → 缓冲/SG → ARM → 首帧。
静止核查包括实际启用方向、RS/Reset 清零、Halted、错误位与 SG 能力；不写 0 脉冲，不对运行中 DMA 强制 reset。
这些地址来自旧 B00 诊断，不直接硬编码进新 C0D 派生候选；新 HWH 须重新证明复位连线与安全先读对象。
真实 BD/PS7VIP 仿真先证明“保持复位时不响应、释放读回后可访问”，再覆盖运行/STOP/重启；普通假 MMIO 通过不等于真实 AXI 证明。
旧 B00 入口要求物理冷启动凭据；软件 reboot、PS reset、删除 cold marker/global metadata 均不能冒充断电上电。
无可证实电源冷态时旧 B00 试验为 BLOCKED；R715 的 111 项回归与 ARM check-only 不证明 SSH 失联已实板修复。
新候选可另建可证明的 warm-start 合同：正常系统重启后官方 Base/clear 服务完成，状态/锁/journal/DMA 经新 boot 审计，再单次加载。
warm 合同须经过真实 BD、实际首次启动及正常停启/异常恢复证据；不是把旧 B00 的 cold 参数改成 false。

## 7. 拟改模块与功能等价检查

下列为后续隔离候选中的拟改/复用范围，本次未修改；冻结包、handoffs/vendor 和 R2 原件保持。
| 已存在模块 | 最小职责与近邻检查 |
| --- | --- |
| [vision_async_runtime.py](../board/pynq_z2/scripts/vision_async_runtime.py) | SharedVisionHardware/Worker 计时、SharedDualMaskHardware.start、双 mask tracker；保留 R1 observer 与原分类/投票 |
| [vision_dma_pool.py](../board/pynq_z2/vision_dma_pool.py)、[dual_mask_packet.py](../board/pynq_z2/dual_mask_packet.py)、[vision_capture_control.py](../board/pynq_z2/vision_capture_control.py) | 三槽 token、包解码、epoch/收尾；坏包、重复/断序、过期、STOP/overflow |
| [axis_rgb_dual_mask_capture.sv](../rtl/vision_streaming/axis_rgb_dual_mask_capture.sv) | 缩放/HSV/双 mask 及对齐；逐像素、边界、背压、尾部 drain |
| [control](../rtl/vision_streaming/axi_vision_capture_control.sv)、[status](../rtl/vision_streaming/axi_vision_capture_status.sv)、[lifecycle](../rtl/vision_streaming/vision_capture_lifecycle.sv)、[drain](../rtl/vision_streaming/vision_capture_drain.sv) | 真实复位、配置快照、fault、sealed/drained/source-quiescent |
| [build_c6i_volume.tcl](../board/pynq_z2/scripts/build_c6i_volume.tcl)、[add_shared_vision_bd.tcl](../board/pynq_z2/scripts/add_shared_vision_bd.tcl)、[CDC 约束](../board/pynq_z2/constraints/vision_capture_cdc.xdc) | 短根派生、替换旧路径、实际 HP/地址/复位核查 |
| [prepare_hardware.tcl](../subprojects/hdmi_input_osd/integration/prepare_hardware.tcl)、[attach_new_parent.tcl](../subprojects/hdmi_input_osd/tools/attach_new_parent.tcl) | 沿用 OSD 父版接入约束，先去除候选入口的旧 root/BUILD 硬绑定 |
| [board_acceptance.py](../subprojects/hdmi_input_osd/integration/board_acceptance.py)、[board_probe.py](../subprojects/hdmi_input_osd/integration/board_probe.py)、[board_common.py](../subprojects/hdmi_input_osd/integration/board_common.py)、[recover_board.py](../subprojects/hdmi_input_osd/integration/recover_board.py) | R1 CPU 口径、身份/root 参数化、全新标签；不重放历史 attempt |
| [vision_input.py](../python/pynq_multimodal_game/vision_input.py) 与 R1 冻结 backend/输入 OSD | 能力选择与 ObservationHub/provider 同源；保留 VOL1/OSD/SDK 合同 |

已分配候选 `deliveries/c6i-pl-vision-volume-osd-r17-20261023`，BUILD `0xC0060E00`、profile `C6I_PL_VISION_VOLUME_OSD_V1`；从558项SHA全核的冻结R1恢复。新工厂为该候选 `python/pynq_multimodal_game/agent/pl_volume_factory.py`，板端/PC身份严格同包；18处配对身份变更、新工厂和必要STOP修复均未覆盖R1。`candidate_stage.json` 为SOURCE_ONLY_HARDWARE_PENDING时，入口在任何硬件导入/下载前拒绝，须完整硬件配对、包和预检后才解除。新游戏在候选 `games/pl-c0e-r01`，八PC结果不能替代C0E实板GPU结果。
沿用现有 test_vision_preview 的 dual_mask_borrower 八分支及 owner/guard/fusion、packet、capture budget、volume 和邻近 RTL 测试，不新建大型框架。
数值矩阵含正常/全黑/全白/肤色阈值两侧、手边缘、多 blob、旋转镜像、坏帧、背压、连续配置、reset/stop/overflow。
每个局部改动后先最便宜可证伪窄测试，随后邻近回归；111 项等历史结果仅作参考，不能替代本轮运行。

## 8. 分阶段实施与出口

1. A 接手：等待主代理结束独占并交接；核 R1 ZIP/manifest/bit/HWH、dirty 状态、boot/PID/start_ticks/cmdline、官方服务、锁/journal/maps/端口与 HELLO。先修独立验收器口径和历史 root，拒绝错误版本；不触动运行时 R2 原型。
2. B 基线闭合：保存 STOP 线程故障原件并完成局部诊断/复验；八条真实 GPU、模式、同工况 A/B 与长测分别出报告。B 未闭合时只能并行离线 C，不并发占板。
3. C 延迟/资源门：分段计时验证假设，审计真实 C0D HWH/HP/地址/层次/control sets；形成替换清单与预算，确认精确数值合同。
4. D 复位/隔离门：真实 BD/PS7VIP 验证复位、首帧、连续包、STOP；旧 B00 仅在真实冷态且适合隔离时试 vision_gpu_only，不创建旧声音服务。
5. E 融合候选：从 R1 恢复独立短根，分配新身份，移植双 mask/生命周期并组合 VOL1 与 R1 OSD；逐次窄回归后完成整机综合、place/route。
6. F 上板/交付：包恢复、PC/目标 Python 3.10/ARM check-only 后，按已证明启动合同依次验身份、相机 IIC、双 mask、provider、GPU、VOL1、OSD、Studio、八黄金与长测，最后验证正常停止/恢复。

E 出口要求 setup/hold/pulse 非负、TNS/THS=0、route 完整、无 blackbox；审查新增 CDC/DRC/methodology、外部 IO 和最差路径。
禁止 waiver、假路径或放宽原相机/HDMI 时钟换 PASS；仅允许本候选必要 pipeline/control set/互联修正，不扩展优化范围。
bit/HWH/XSA 必须同一设计 SHA 配对并恢复校验，生成/导出成功不自动等于部署许可或板验成功。
实施环境先核 Vivado 2026.1、PC .venv、目标 Python 3.10/ARM、明确 WSL 发行版、SSH 源绑定、sudo 非交互能力与 XRT；本文未检测或安装。
缺工具/依赖须先记检测命令、错误原文、所需版本、来源/路径、影响、修复及复验，不以跳检查或放宽全局权限替代。

## 9. 端到端测量与验收矩阵

复用 measure_processing、processing_timing、last_read_timing、recognizer.timing_ms；观测默认关闭、有界缓存，常态少写日志，单列采样开销。
分段记录：采集等待 → RGB copy/resize → SKN6 往返/CPU 参考 → 形态学 → contour/shape_stats → 稳定投票 → 发布 → 本地采样 → Scene 提交 → GPU 完成 → OSD commit/vblank。
候选对应记录流式 SOF/帧完成、mask 可用与 PS 消费；移除阶段标为“已替换”，不以零耗时掩盖 DMA/等待转移。
同板 monotonic 统一时间，绑定 run/epoch/config/frame/tick；现 timestamp 若是发布时刻只能量发布后源龄。
新增 SOF 计数/锁存需 RTL 与 PS 映射验证；跨机时钟不直接相减，屏幕可见/光子到光子须物理光学或 HDMI 测量另验。
每段与完整可观测链均报样本数、窗口、p50/p95/p99/max、重复范围及缺失计数；阶段分位数不可相加冒充端到端 p99。
保持相机/肤色/方向/投票/音频/预览配置一致，对比 R1 与候选；同时记录视觉新结果频率和稳定分类墙钟等待。
60 Hz 是原逻辑目标，16.67 ms 为对应预算；分别报告 tick deadline miss、视觉 fps、GPU/render/present、OSD Hz 及未达缺口。

八条真实 GPU 用例以 [R1 verification.json](../subprojects/hdmi_input_osd/integration/evidence/g15-restored/games/osd-c0d-r03/verification.json) 为准：
- game1-volume-shield-attack（60 tick）、game1-hold-volume（60）、game3-volume-male-win（754）、game3-volume-female-win（754）。
- game3-hold-jump-release（141）、c1-golden（330）、kingdom-princess-win（801）、rps-win（959）。
每次唯一 request_id，安装后回读长度/SHA，同 VVG/seed/用例逐 tick 对 PC 保存完整 GPU 报告；旧 r15、PC 或本轮前三条不能替代整组。
黄金期间隔离真人/时间线；另开无 test_case_json 的实时 provider 检查手势、位置、边沿确实进入 GameInput/Scene，不以黄金输入证明真人链。
模式覆盖菜单、三游戏 live、pause/resume、返回菜单、视频播放/暂停；玩法暂停时视觉/音量/OSD继续独立更新，图片入口保持既有占位。
长测按 2 分钟冒烟 → 10 分钟 → 60 分钟递进，覆盖无 Studio、视频、debug 订阅、三游戏、暂停及 PC 断连重连。
记录 OSD 线程/Agent 进程家族 CPU、双核全机与每核热点、线程数、RSS/PSS、MemAvailable/CMA、源龄/monitor 间隔、fault/ACK与 STOP 尾延迟。
开关按 False/True/True/False 重复同工况；显示关闭未必停止发布线程，差值只表开关成本，不冒称完整 OSD 生命周期成本。
验收要求 mask/确定性位置分类等价，p95/p99 延迟与投票等待收益超过同工况波动，CPU/内存保持轻量且无持续增长，VOL1/GPU/OSD/三游戏无回归。
不预言资源或速度，不新增 `<1%` 等任意阈值；若收益不可区分或尾延迟/可靠性恶化，保留 R1，候选继续实验状态。

## 10. 失败、恢复与现场 pending

每项错误立即保留命令/错误原文、boot/owner/阶段、原日志/资源采样、根因证据、进度影响与拖延原因、修复和同入口新回执；原 FAIL 不覆写。
历史 STOP `can't start new thread` 原因尚未完全定位；当前无 Studio 工况整组回归通过。不得仅以事后线程数猜测故障瞬间根因；须保留前两轮失败与资源采样失效的事实，客户端并发可靠性另验。
独占 owner/Overlay；任何停止、复位或接管前重新绑定 boot、candidate、PID/start_ticks、锁/journal 与当前包 SHA，历史 PID/收据不作授权凭据。
同 boot+candidate 只允许一次加载/同一恢复动作；再次尝试先有新证据、明确局部改动或新 boot，不原样循环、不盲发第二次 STOP。
异常按原合同 RETAINED，保留借用者/缓冲；仅证实 sealed/drained/source-quiescent、DMA 静止及释放计数后释放，禁止在用缓冲 free。
正常 service/game stop 与正常系统重启优先；等待官方 Base/clear 自然完成并读证据，历史约 140 秒不是固定 sleep 成功判据。
禁止强杀未知进程、删锁/journal/metadata/attempt、裸 MMIO 接管、运行中 DMA 强制 reset 或修改供电接线；不复用旧 load/Base-stop/recovery attempt。
SSH失联先保 transport/UART/最后阶段，只有已授权且目标可证明的恢复通道才可用；JTAG需专项身份审计，无可达通道则 BLOCKED，不能假装远程断电。
回退使用冻结 R1 配对包，在新身份审计和安全停止/必要正常重启后单次恢复；R1 preview retained 风险保留，R2 关闭修复未获选用。
现场仍 pending：客户端并发导致 STOP 故障的根因及专门回归、更长稳态与阶段计时、实时 provider 到 Scene、候选完整实现/首帧/安全停启与延迟收益。R1 八 GPU 整组、模式与两分钟 A/B 已有通过证据，十分钟复验进行中。
真人手势、SOFT/LOUD 真实声学越阈/quiet/rearm、物理 HDMI 可见效果与光子到光子独立标 PHYSICAL_PENDING；播放完成或寄存器读回不能替代物理刺激证据。
交付须含独立 ZIP/manifest、恢复/check-only、资源/时序、数值/逐 tick/GPU、性能矩阵、最新 boot/owner/root/log、事实记录及 R1 回退步骤。
机器项与物理项分列 PASS/FAIL/PENDING/BLOCKED；所有阶段出口有证据后才更新发布状态，用户离线或设备缺失时如实保留 pending。
