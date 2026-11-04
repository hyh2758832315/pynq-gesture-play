# 工程观察与验证摘录

# 视觉延迟加速实施方案

## 1. 结论与证据边界

## 2. 确切 R1 基线与当前状态

选定包为 `deliveries/c6i-vision-volume-osd-r16-20261022.zip`，41,429,189 字节，558 清单项 / 559 ZIP 成员。
ZIP SHA256：`2e49d7fc2cb1f60a89ffd69b6d9510278d99897bdc06d609604f581e5a8fbb67`。
身份：BUILD `0xC0060D00`，profile `C6I_VISION_VOLUME_V1`，SDK 1.3 / schema4 / GPU ABI 1.0。
板端历史根目录 `/home/xilinx/voice-view-game/c6i-vision-volume-osd-r16-20261022`，日志 `var/osd-live-r02`。
历史 boot `b40bc22c-b967-4418-a6fb-f614f37376cf`，Agent 921 / start_ticks 29986；这些仅为追溯值，接手须重新核身份。
bit SHA256：`043297126616fd7fb1b3e8d0be531b1266b721f86306b897a6b65e90ac2b57e0`。
HWH SHA256：`3acc9b92e56632c11f3e31e8547e5d1b2fe79db187f53f208f12116f2f0e2db0`；只使用已配对的优化设计产物。

## 3. 当前延迟路径与可证伪假设

当前控制链：camera/demosaic → RGB DDR capture → 全帧复制/resize/方向处理 → SKN6 BGR 上传与 mask 回传 → PS 黄金比较/形态学 → 轮廓/分类/投票 → 发布 → provider → GameInput/Scene → GPU/HDMI。
OSD 从观察结果独立发布并在帧边界提交；HTTP/Studio 预览不是本地游戏控制环，但会竞争 CPU、内存和 DDR。
5.5637 fps 仅表示视觉源新结果更新，平均间隔约 180 ms；它既非单阶段处理延迟，也非手势或光子到光子延迟。
三帧一致投票要求多个新观测；其墙钟等待需逐次测量，不能直接将平均间隔乘固定帧数当完整端到端结果。
局部假设：RGB 搬运、SKN6 往返和 PS 形态学占有可消除成本，流式前处理可提高有效新观测频率并缩短相同投票等待。
最便宜的反证检查是现有计时点分段剖析；若主耗时在采集等待、PS 轮廓或调度，先报告占比，再调整本候选边界。
延迟收益必须伴随分类/位置等价、轻量资源与可靠收尾；低 CPU 片段或更快 OSD 刷新不能单独证明视觉加速。

### R10 实测阶段依据

按每一帧配对相加 `input_prepare+color_mask+morphology`，实测分布为p50 119.09 / p95 128.70 / p99 135.85 / max151.21ms；这里使用配对样本，不是相加分位数。color_mask减去其SKN6子阶段的差值p50 41.86ms，包含CPU参考及该阶段其他开销，不能全称为可省的硬件事务。

## 4. C0D 资源、总线与预算

| C0D postRoute 项 | 使用 / 总量 | 约束解释 |
| --- | --- | --- |
| LUT / FF | 28746/53200；44000/106400 | 余量不能换算为可布局 Slice |
| Slice | 12532/13300，94.23% | 仅余 768 个物理站点 |
| BRAM Tile / DSP | 87.5/140；14/220 | 需核 banking、FIFO、对齐及位宽 |
| MMCM / control sets | 3/4；1873 | 时钟、复位、使能组合影响合法打包 |
| WNS / WHS | +0.004 ns / +0.050 ns | setup 仅 4 ps；TNS/THS=0 |

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
