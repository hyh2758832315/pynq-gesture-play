# 视觉先行的 Studio–PS–PL 分阶段接入方案

## 目标与范围

- 日期：2026-10-05；文档类型：设计及实施计划，首批离线实施已验证，板端阶段验收待执行。
- 当前优先级：视觉先行，声音暂缓；保留声音2026.1交接和现有语音字段，首轮声音输入禁用。
- 视觉来源：E:/projects/fpga/gesture_vision_v61，只读冻结；集成改动放在主工程或独立候选中。
- 目标平台：同一块PYNQ-Z2、Vivado2026.1、PC Studio；复用现有游戏/Agent/GPU合同。
- 最终闭环：Studio部署与控制PS视觉服务，PS使用PL采集/肤色前端，语义结果驱动PS游戏，PL GPU呈现HDMI；状态、图像和消费证据回读Studio。

## 2026-10-06 当前融合状态

V3本地语义输入、共享Overlay生命周期、Studio融合身份/live启动及消费回执已实现；V4完整主综合、route、Explore、bit/HWH/官方XSA已完成离线候选。候选BUILD_ID为0xC0060800，setup/hold裕量0.002/0.050ns，34控制地址段；源帧关联游戏tick、Scene提交和sink完成后才回报Studio。最终同板验收仍待执行，下方B1/B2状态和拟修改表保留为历史阶段记录，以本节和最新事实记录为准。

用户明确当前OV5640无需额外电平适配器，相机及PCLK以队友代码为准。沿用冻结交付的直连针位、capture/config/driver、10ns PCLK和0..4ns输入延迟模型；不增加转换器、重新接线、超采样或先行示波器记录作为阻断。队友VALIDATION.md记录168/187/312帧、每组约60秒、错误帧0；这是原独立方案功能证据。融合后的DDR并发、启停、真实输入控制HDMI和长稳态在统一上板中验收，保留非专用PCLK警告及报告。

正式Agent入口接受`c6i-vision-package-v1`、`C6I_VISION`、字符串`0xC0060800`、严格布尔`timing_pass=true`及`release_ready=true`，同时验证bit/HWH SHA和冻结运行时身份；check-only在session、监听器及输出目录创建之前拒绝不符包。离线候选使用不同schema `c6i-vision-offline-candidate-v1`，保持`release_ready=false/board_pending=true`，14份产物哈希和XSA配对核验不自动提升发布身份。

真实候选只读核验命令：

```powershell
& './.venv/Scripts/python.exe' -B './board/pynq_z2/scripts/verify_vision_integration_sources.py' --reference 'E:/projects/fpga/gesture_vision_v61' --candidate-dir 'E:/vvgvi/20261005/output/offline_complete'
```

受控测试包已补闭合：显式`--vision-board-test`接受完整未改写的离线候选回执，重验14件及XSA配对，保持release_ready=false/board_pending=true；默认正式发布路径不变。打包器重跑同包带断言黄金回放、冻结133身份、Python3.10语法及导出目录check-only。真实TCP整链与实际部署副本整链均通过，12文件联合347项通过；硬件夹具不计实板PASS。

下一出口仅为接板后的环境/owner预检与统一实板验收，完整部署与启动步骤见[统一上板合同](c6i_vision_board_acceptance.md)。完整事实见[融合实施记录](bringup/2026-10-05_pynq-z2_vision_v3_v4.md)。

## B1 当前实施状态

B1 诊断健康与故障隔离已离线完成：编码器提供不可变整体健康与独立进程存活字段；无订阅退出、relay 断裂及发布失败均可见。候选每帧健康门控停诊断、继续提前控制发布，HTTP 图像降级503/断流、结果仍可读取并附可选 preview_health。关闭结果真实区分正常/非零退出/强制/超时，诊断回收与 DMA 清理分列，原始判断异常和硬件失败时 buffer 引用保留。

真实 terminate 注入发现跨进程 Event 通知等待死亡等待者确认的关闭挂起，已改为 Semaphore 唤醒/启动握手、父本地 stop 与单写者子 stop，并保留原注入回归。B1当轮联合73项/23.50s通过，133项冻结哈希不变，原识别器/Tracker AST一致；过程工具及MCP错误均在[事实记录](bringup/2026-10-05_pynq-z2_vision_v0_v1.md)保存。B1当轮未操作板卡、声音、RTL、guard/Agent；实际性能、3.10实机、DMA停止和真实10分钟仍为BOARD_PENDING。

## B2-A/B2-B 当前实施状态与剩余距离

独立候选 [run_vision_guarded.py](../board/pynq_z2/scripts/run_vision_guarded.py) 已完成离线底座：固定入口与白名单参数、相机SHA和冻结SKN6身份预检、已知owner扫描、共享C6I租约、PID/session首帧就绪、重复启动保护、DMA halt/退出确认及FAULT保留。候选清理失败保留buffer并原子写原始异常/清理回执。最终监督/预览/结果/Studio及冻结guard联合103项/24.06s通过，冻结133项哈希保持；错误和MCP修正、最终源码身份见 [B2事实记录](bringup/2026-10-05_pynq-z2_vision_v2.md)。

B2-B已接通Studio→版本化TCP Agent→独立guard控制面：VISION_ONLY能力发现、幂等启停/状态、独立CLI和只读预检、异步控件及关窗退出确认。最终九文件联合166项/33.86s通过，正式Studio烟测及两尺寸原生截图通过，冻结133项身份保持。相机HTTP/判断观察独立，未派发GameInput；完整入口、SHA和工具/测试失败见上方B2事实记录。

当前为观察接入加受控生命周期离线闭合，完整融合仍有四类门禁；依赖存在交叠，不按数量推算完成百分比或工期：

| 剩余门禁 | 当前缺口 | 下一出口 |
| --- | --- | --- |
| V2 受控运行 | 控制面已离线闭合；完整安装/部署制品、相机许可/副本与目标3.10/PYNQ依赖待补 | 保留固定仓库布局完成部署预检，再10次实板启停及真实观察 |
| V3 游戏语义 | 视觉结果尚未派发GameInput | 方向消费、事件去重、超时释放及live/replay隔离 |
| V4 单Overlay | 视觉与GPU仍为互斥bit，DMA/reset地址冲突 | 隔离集成候选的地址/HP/时钟/资源/时序及同帧合同验收 |
| V5/V6 同板与稳定性 | 摄像头→游戏→HDMI整链及并发/长稳态尚待真实证据 | 实板闭环、故障恢复、结果间隔和CPU/DDR压力验收 |

最大结构性剩余项是V4单Overlay，继续PS接线不会自动解决两套bit互斥。下一出口为受控部署及实板V2验收；无板期间可推进V3纯语义合同和V4隔离集成准备，分别验收。本轮新增Studio按钮和Agent能力，未创建GPU session、派发GameInput或更换硬件制品；声音继续延后。

## 已核实基线

### 首批实际实施状态

Studio已增加左侧六画面选择栏：输入与ROI、肤色阈值、膨胀与高斯、候选与选中轮廓、凸包/缺陷/中心、方向与死区。复用队友debug.jpg的960x360三列两行拼图，每格320x180；本地切换不增加请求。实时MJPEG与处理图订阅互斥，处理图回读上限可设1..30Hz，默认1Hz兼容冻结服务；这不是算法或实际输出FPS。

独立运行候选为[vision_async_runtime.py](../board/pynq_z2/scripts/vision_async_runtime.py)，共享编码实现为[vision_preview.py](../python/pynq_multimodal_game/vision_preview.py)。默认spawn独立编码进程、两槽共享内存、非阻塞写槽与latest-wins；只在有订阅且到生产节拍时生成诊断快照。host-only把标注/拼图/JPEG迁出判断主循环；HTTP线程只读不可变JPEG。编码进程不持有Overlay/DMA，OpenCV线程数1、Linux nice +5。判断主循环保持原PL/PS算法及控制提前发布；逐帧CSV、诊断图保存默认关闭，停止后写有界性能统计。

候选视频/处理图生产上限默认10/5Hz，可分别设0..30；0关闭对应生产。配置提高上限不会生成额外推理结果，也不保证实际FPS。推理按自身最大速度运行，诊断忙时舍弃旧快照，诊断异常留在状态中；共享快照序列化/复制和DDR/CPU竞争仍须实板计时，不能称零影响。

历史离线证据：冻结包82项原生测试通过；候选81项可复用合同通过，单列排除原同步无订阅JPEG发布断言，并用新按需入口/编码回归替代；完整附近Studio/异步回传79项通过。V1独立结果身份worker、B1故障隔离、B2-A监督底座及B2-B控制面均已离线完成；B1联合73项、B2-A联合103项、B2-B联合166项为有重叠的分轮证据，133项交接哈希保持。详见[首批事实记录](bringup/2026-10-05_pynq-z2_vision_v0_v1.md)及上方B2记录。本轮未访问板卡或更换bit；V1真实10分钟观察、V2完整部署/目标依赖与V0相机许可/副本仍待验。

实时性优先门禁：诊断off、仅结果、MJPEG、六处理图分别测结果间隔p50/p95/p99/最大值、capture_to_result、快照提交耗时、CPU/RSS/DDR压力及游戏tick抖动；不以HTTP刷新率或提前发布单帧时间代替持续处理率。高帧率优化按这些实测结果推进PL输入准备/形态学等候选，逐步同帧mask/质心/控制对照；保留Gaussian非二值语义与冻结回退，不先承诺PL提速倍数。

v6.1默认host-only：OV5640→PL demosaic→frame_dma S2MM→PS复制及BGR/旋转/镜像/缩放→moments_dma→PL SKN6肤色前端→S2MM紧凑mask→PS形态学/轮廓/质心/控制。moments_dma是继承名称，实际使用SKN6协议。host-only关闭的是相机HDMI显示MM2S，采集与算法DMA仍工作。

现有/result.json、/camera.mjpg、/debug.jpg分别提供控制最新值、640×360标注预览、至多1Hz调试图。控制schema为gesture-control-v1，run_id/frame_id/事件序号用于身份和去重；server_age_ms与本地新帧计时均需验证，初次连接及run_id改变建立事件基线。

原交接记录：host-only312帧/60.036s，约5.197FPS；capture_to_result平均135.447ms从readframe返回开始，未包含曝光、网络或游戏显示。原完整布线WNS/WHS为0.037/0.052ns。这些是已有记录，不是新集成结果或延迟/准确率保证。

当前视觉bit与游戏GPU bit互斥。上位机观察或PC手势演示是中间里程碑；同板正式HDMI闭环采用单Overlay候选，保持唯一硬件所有者。

## 阶段路线

| 阶段 | 最小实施 | 验收出口 | 依赖 |
| --- | --- | --- | --- |
| V0 基线冻结 | 核验交接哈希、运行依赖、82项运行测试与6项接收示例；记录实际板端所有者、地址/时钟及资源 | 可追溯基线和回退步骤；缺项明列 | 无 |
| V1 Studio视觉观察 | 异步接收原HTTP最新值、JPEG和调试图，独立设备/会话状态；先不控制硬件 | 真源图像/结果/健康正确关联，GUI不阻塞；失联/重启不显示为有效 | V0 |
| V2 Studio–PS受控运行 | 增加VISION_ONLY设备profile，复用Agent命令/部署机制管理单一视觉worker；start/status/stop/参数均有确认 | Studio启动→PS→PL处理→结果回读→安全停止与恢复，真实运行验收 | V1 |
| V3 手势语义验证 | 方向映射和握拳候选事件适配器、来源与会话隔离；先用PC或软件sink验证游戏消费 | 移动按游戏tick消费，动作至多一次，超时释放及录制回放；不作同板HDMI结论 | V2 |
| V4 单Overlay候选 | 以冻结GPU为基线加入必要相机/肤色前端，使用唯一HDMI后端；保留SKN6、审计地址/HP/时钟/资源 | 新身份、独立路由及图像同帧回归；DMA安全和并发检查 | V0/V2/V3 |
| V5 真实同板闭环 | PS直接将视觉语义送入live游戏，Studio仅控制与观察；正式HDMI回读关联消费/呈现 | 真实摄像头→PS/PL→游戏→HDMI，断PC网络仍按明确策略运行，暂停/停止有界清理 | V4 |
| V6 稳定性及优化 | 长时与故障回归、诊断订阅压力、按实测优化复制/解码/调度 | 保留控制质量、时序及安全；新旧同输入A/B | V5 |

声音接入在V5闭环和V6初步稳定后另行评审；V0–V6不增加声音DMA、Codec或语音识别worker。

## 初始安全合同

结果无效、非法字段、HTTP/JSON错误或会话失配立即释放方向。沿用原1200ms最长新鲜度保护作为初始兼容合同，同时记录其交互延迟风险；重复frame_id不能刷新本地新帧计时。更短阈值由实际结果间隔和故障测试定型，避免凭约5.2FPS预设可靠性。

持续方向采用latest-valid；握拳候选事件按run_id/action_event_seq去重，不补播旧动作或把序号跳增当事件历史。先验收方向，握拳→跳跃另有使用者确认和误触评估；启发式RPS标签独立待验。

游戏tick与算法更新率分离；首轮方向用于game1左右移动，垂直方向的用途独立配置。Game SDK字段保持，REAL来源和模型/会话身份走诊断旁路。test/replay与live严格分开，原测试模式不混入实时输入。

单Overlay所有者管理下载、MMIO、DMA、相机时钟和buffer。PS视觉热路径不等Studio、不持有网络发送锁；HTTP/网络只取得不可变快照，DMA停止确认后释放buffer。GUI主线程只绘图，接收、解码、控制和校验走有界worker。

## 分项证明

V1证明观察接入，V2证明Studio控制现有视觉PS–PL链，V3证明输入语义，V4证明硬件集成，V5证明真实同板HDMI闭环；每项分别保存证据。

时间记录包括run/frame、readframe返回、算法完成、语义接受、游戏tick和呈现身份；PC/PYNQ单调时钟不直接相减。结果年龄、网络RTT、板端延迟和PC绘图延迟分列，曝光到HDMI的整链延迟用校准时标或同步拍摄另测。

实施过程遵循先局部接口回归、再场景和整机回归；构建/上板错误先追加项目事实记录，再修复复验。冻结交接、原GPU发布身份和现有游戏回归保留，不自动上板、不改板卡网络或重启。

## 当前实施起点

先做V0及V1：确认交接依赖，在Studio加入只读视觉设备观察入口和接收适配层，保持板端冻结服务；之后才增加受控PS生命周期。硬件合并与算法性能优化属于后续隔离候选。
方案制定时的只读复验：指定交接目录verify_handoff.py返回HANDOFF_HASHES_PASS files=133，配对hash/address map检查通过；接收示例6项unittest全部通过。首批新增实施与82项runtime离线复验见上方实际状态；真实板端验收及外部相机模块可验证副本仍待补齐。
初版guard负责异常退出后的DMA收尾，运行时先复用原算法并从不可变结果快照获取数据。V4在集成副本中为驱动传入外部共享Overlay/受限DMA句柄；视觉worker停止只关闭自身资源，不关闭共享GPU session。算法模块不再自行调用Overlay下载。
本表描述拟实施边界，VISION_ONLY、视觉backend和真实DATA decoder尚未实现。真实视觉与fixture分配不同source/schema，能力发现返回实际producer身份，不能把source1 fixture或source3 opaque测试流直接改标为REAL。

## 实际代码边界与实施方式

| 拥有者 | 已有行为 | 最小拟修改 |
| --- | --- | --- |
| Studio workspaces.CameraPreviewWorker | MJPEG接收/解码在worker，take_latest有界取图 | 复用其停机和线程边界；补结果worker、调试图限频及统一会话关联 |
| Studio game_workspace._validated_deploy | PC用例预验收后安装，当前启动始终带test_case_json | 保留预验收；运行按钮明确选live或replay，live运行省略test_case_json |
| Agent cli.main | c6i-shell/c6i-video及C6I return模式在监听前session.open加载GPU | 新增VISION_ONLY profile与真实视觉生命周期backend，明确不创建C6I session；mock仅作本地测试 |
| 视觉 project1_live_ov5640.main | 自己Overlay(bitstream)、相机配置、DMA和HTTP服务 | V2先以已有guard监督独立进程，避免直接把main作为库调用；V4再分離Overlay下载与算法worker |
| PackagedGameRuntime.update/_run | 无test_case时可更新live control；SDK支持有效位置与一次拳事件 | 加入有界视觉语义provider，在tick取快照/消费事件；仍不使用inject_test_input作REAL路径 |
| 游戏GameInput/Game1InputAdapter | hand_x/hand_y、fist_sequence/fist_event已有；game1 jump直接消费fist_event | 保持SDK，REAL方向映射需经过适配；未确认RPS分类不填HandGesture分类字段 |

本表描述拟实施边界，VISION_ONLY、视觉backend和真实DATA decoder尚未实现。真实视觉与fixture分配不同source/schema，能力发现返回实际producer身份，不能把source1 fixture或source3 opaque测试流直接改标为REAL。

V1只读观察可复用已存在的CameraPreviewWorker，不需要先重新实现整个视觉页面。V2控制backend复用现有Agent TCP framing、request/session ID和幂等结果机制，新增视觉命令而不改变已有游戏命令语义。视觉backend只提供实际可用能力，VISION_ONLY下GPU run/upload激活应明确拒绝，而非响应虚假的游戏运行状态。

### V2运行状态与所有权

拟状态机为IDLE→STARTING→RUNNING→STOPPING→IDLE；初始化/采集/子进程故障进入FAULT并保留清理状态。重复start同参数返回当前会话，不产生第二个Overlay owner；STOP确认应包含进程退出、DMA停止和资源回收结果。cleanup失败保持FAULT/owner，不能假报IDLE或自动下载另一bit。

先沿用冻结runtime参数、--host-only/--pl-skin与当前guard，start命令使用白名单配置，不允许PC提交任意shell。可验证配置包括摄像头依赖路径、bit/HWH SHA、肤色阈值及旋转/镜像profile；更改影响坐标或语义的参数时建立新的config_revision/epoch并释放旧方向和动作基线。

初版guard负责异常退出后的DMA收尾，运行时先复用原算法并从不可变结果快照获取数据。V4在集成副本中为驱动传入外部共享Overlay/受限DMA句柄；视觉worker停止只关闭自身资源，不关闭共享GPU session。算法模块不再自行调用Overlay下载。

### 预览、结果与动作

V1结果轮询50–100ms沿用交接建议；/debug.jpg最多1Hz，MJPEG的下载/解码单独有界。图像、JSON和调试图不同速率且现接口不保证原子同帧配对；默认分别展示frame/session/age，有精确同帧快照需求时新增显式关联出口，不把最新框强行画到另一张旧图上。

预览latest-wins、结果latest-valid、离散事件有界且一次消费；队列溢出显式失效，不无限补播。板端游戏直接消费PS视觉结果，Studio收到的HTTP/TCP副本用于观察；正式控制不走PS→PC→PS往返。

game1左右方向应映射到经过滞回的已决策direction，而非绕过方向逻辑把原始u作为运动。SDK适配可以输出hand_x=-1/0/+1、hand_y=0，invalid时hand_valid=false；保留原始/平滑坐标供分析，UP/DOWN首轮不派发。拳事件只在连续有效会话的新seq增长时生成一次jump候选，不补放初次连接/重启时旧事件。声输入tone=None、audio_valid=false，独立测试回放保留原声音事件但不与live混合。

游戏暂停先释放实时动作，恢复重新建立事件基线；重连、设备profile切换、换游戏和参数epoch变化同样处理。明确STOP始终停服务；PC断线策略分开规定：V2独立视觉继续或停机由启动policy明确，V5默认板端游戏和视觉继续运行，重新连接Studio只恢复观察，不补播网络断开期间旧动作。

## 单板资源、地址与带宽可行性

首轮GPU选冻结C6I 0xC0060700，而非同时切入P4优化实验。集成新BUILD_ID及vision capability独立分配，保持Scene ABI1.0/Game SDK1.1；游戏包兼容检查显式识别新profile，不能通过伪造旧BUILD_ID绕过核验。

| 资源 | 冻结GPU完整设计 | 视觉完整设计 | 简单合计 | Z020容量 |
| --- | ---: | ---: | ---: | ---: |
| LUT | 14025 | 15227 | 29252 | 53200 |
| FF | 22845 | 20631 | 43476 | 106400 |
| BRAM Tile | 62 | 25 RAMB36+8 RAMB18=29 | 91 | 140 |
| DSP | 2 | 12 | 14 | 220 |

GPU依据gpu_ai_optimization_p0_p4_summary，视觉依据指定交接hardware/reports/utilization.rpt。合计是容量初筛，未计集成增量、未扣重复PS/互联/显示逻辑，也不是routed预测。Slice、MMCM/PLL、BUFG、Bank电气、管脚及布局拥塞须补实际清单；两份正WNS并不能相加为新设计时序。单Overlay候选需WNS/WHS非负、TNS/THS零、bus-skew及CDC/DRC/methodology按范围签核。

初始拓扑保留GPU HP0命令和HP2回读合同。摄像头frame_dma和SKN6 MM2S/S2MM按实际master数量评估HP1/HP3及专属互联；这些是候选，最终以BD地址和并发测量冻结。SKN6输入TLAST为DMA包尾，与相机AXIS视频EOL语义不同，两个协议不直接拼接。

视觉现地址：算法DMA0x40400000、reset GPIO0x41200000、frame_dma0x43000000、camera_iic0x41600000、demosaic0x43C00000、hand_osd0x43C10000。其中前两项与GPU冲突；为视觉MMIO重排后以新HWH注册驱动，SKN6魔数/尺寸/状态布局保持。hand_osd及相机显示MM2S在新设计中剥离，HDMI只用GPU后端；如驱动REQUIRED_IP强依赖旧显示IP，先在候选驱动明确host-only所需集合并做mock/实板回归，不能直接删IP再沿用旧相机模块。

PS跨域统一单调时间基准。PL保持相机采集、demosaic和SKN6实际时钟/复位；GPU render100MHz/pixel74.25MHz合同保留，不从单个skin_kernel II=1推断端到端FPS。

| 数据 | 每帧payload估算 | 核验边界 |
| --- | ---: | --- |
| 1280×720紧凑24bit采集 | 2764800B | 实际VDMA stride、传感器帧率及持续写DDR速率需实测 |
| 640×360 SKN6输入 | 20B头+691200B BGR=691220B | cache flush/对齐/DDR读写与PS复制另计 |
| SKN6输出 | 230400B mask+32B状态=230432B | invalidate、检查、解码和形态学另计 |

5.197Hz识别更新不能代替摄像头持续写入率；DDR总负载还含GPU、网络编码与内存复制。PS初期保留原串行算法语义，视觉worker与游戏tick/网络诊断分离；实际CPU/RSS、环形保留帧、VDMA缓存、JPEG编码、Qt缓冲逐项测量。预览首轮降频/降低质量属于观察配置，不宣称算法加速；调试六宫格仅按订阅启用。

## 逐阶段门禁与交付

- V0：资料SHA校验；外部已跑通capture_camera_direct_plug.py及导入依赖、传感器表、许可/哈希补齐；本机/板端Python、PYNQ/XRT/OpenCV版本、原HWH绑定和运行所有者登记。已有6项接收示例本轮复验PASS；82项完整runtime及板端环境按实际依赖另验，不能以6项替代。
- V1：用本地HTTP fixture测试200无结果、非法JSON、重复帧、过期、重启、半包、JPEG坏帧；Qt断开/重连/切页/关窗无残留worker。已有真实板端服务上进行至少10分钟观察，保存原数据身份和实际结果率，状态不以HTTP200判定RUNNING。
- V2：10次start/stop、重复start/重试命令、启动失败和采集故障；监听端口/锁可回收，DMA状态/进程退出有证据，原已加载GPU所有者被安全停机。后续才评估自动启动，不修改板端网络或未经确认重启。
- V3：方向反转/IDLE/丢手/贴边、seq回绕/跳增、暂停/恢复、断网仍旧JSON、run_id改变和错误字段；PC/live和录制回放分开。握拳跳跃单独统计触发与误触，RPS按其准确率材料决定是否启用。
- V4：先复建原视觉工程并核对IP/供应商依赖，再建立隔离合并候选；相同SKN6向量及同帧mask对照、VDMA帧完整性、GPU原回放/资源CRC、地址/HWH核验、时序和DMA停止。摄像头持续写DDR与GPU/肤色处理真实并发压力，不只测两条单DMA。
- V5：至少10分钟真实手势game1 HDMI运行及10次启停/恢复；记录run/frame/event→接受→消费tick→Scene seq→实际present，迟帧/无手按合同释放。显示60Hz与游戏实际missed deadline分别测量；预览启停/断PC网络不成为板端控制必要条件。
- V6：至少1小时稳态及限时故障矩阵；比较预览off/on、debugoff/on和内容上传负载下的结果间隔p50/p95/p99、最大年龄、游戏jitter、CPU/RSS、水位与恢复。数值时延门槛依据V2/V5实测及交互目标确认，不虚设5.2FPS或精度保证。

各门禁中的时长/次数是拟验收要求，当前尚未执行；遇到真实板卡访问/依赖缺失时保留对应PENDING并继续可独立的离线接口工作。最终V5通过才称“视觉Studio–PS–PL同板闭环完成”。

## 实施切片与回退

### 当前离线实施状态

V1 的结果观察切片已落地：纯接收器负责严格身份/类型合同、1200ms 新有效帧期限、同帧 valid=false 立即释放及事件基线；Studio 的独立 HTTP worker 至多10Hz串行查询 result.json，响应限262144B，socket IO超时0.1s、连接后请求deadline0.8s。等待200、坏JSON、图像503、重复帧过期、新run及断开重连均有本地HTTP/Qt测试。年龄由本机新帧时刻和服务端报告预算分别判定，重复回包不会重置首帧预算；JPEG与JSON保持独立身份。

右侧读数已加入结果HTTP可达性、判断状态、run/源帧、方向、本机新有效帧年龄及服务端最近报告年龄。图像失败保留结果观察，停止确认失败保留线程引用并延后关窗；新会话等待旧worker清理后才能建立，因此旧worker不会覆盖新会话。观察器只读，未派发 GameInput。

V1当轮相邻三文件回归61 passed / 14.33s；1440x900与1080x700原生fixture截图确认通过；冻结交接133文件哈希通过。该证据不代替真实帧率或板端十分钟观察。后续B1诊断健康、B2-A独立guard和B2-B控制面离线完成，最新状态见文首；V0相机依赖、V1 BOARD观察、V2完整部署/实板、V3语义控制、V4单Overlay及V5/V6同板/稳态继续待验。

1. 首切片为V0+V1：复用workspaces.py，新增独立视觉结果适配/worker及原附近测试；不修改冻结runtime或默认Agent启动。
2. 第二切片为V2：Agent命令/CLI加入vision-only，外部guard监督与受控配置；Studio设备生命周期操作连接真实状态，不先重写视觉算法。
3. V3在游戏适配边界补一次消费的语义provider和live启动选择；复用现有确定性测试门禁，不删除_test_case分支。
4. V4才改BD、HWH驱动绑定及外部Overlay注入；保留源快照，失败关闭新候选并回到配对视觉bit/HWH或原GPU，不能自动覆盖冻结制品。
5. V5/V6建立真实闭环记录，再决定声音接入、PS复制优化或PL形态学。每次优化单变量并保持同帧算法语义，Gaussian非二值处理不替换为近似二值操作。

相关代码：[Studio预览](../python/pynq_multimodal_game/studio/workspaces.py)、[部署运行选择](../python/pynq_multimodal_game/studio/game_workspace.py)、[Agent启动](../python/pynq_multimodal_game/agent/cli.py)、[游戏运行时](../python/pynq_multimodal_game/agent/game_runtime.py)、[Game SDK](../python/pynq_multimodal_game/game_sdk.py)。现有基线合同和资料见[视觉交接说明](gesture_vision_v61_handoff.md)。
