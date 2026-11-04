# Voice View Studio 阶段与验收

## 2026-10-02：游戏设计、测试与部署框架

产品路径沿用 `GamePlugin -> Scene -> .vvg -> PackagedGameRuntime`，Game SDK 1.1、
GPU ABI 1.0、C6I BUILD_ID 和硬件产物保持冻结。

- 共享 `game_validation.py` 统一时间线、逻辑时间、seed、逐 tick 证据和 JSON 报告，支持脱离 Qt 的命令行回归。
- 用例 tick 范围为 `0..max_ticks`，最多 4096 帧；越界断言、越界事件和重复事件 ID 在准备阶段拒绝。
- Studio 双构建核对包身份；安装及装载前在后台运行当前用例，失败或取消时停止上传。
- 部署使用验证包快照，并核对当前包身份；实际对照运行与部署预检报告保持独立。
- PC/PYNQ 使用同一回放实现；测试模式隔离实时采集，手动注入明确标为交互调试。
- 对照从最终帧扩展为逐 tick 输入/状态/Scene 指纹及预算比较，保留首个分歧 tick。
- 自动保存 `.reports/<game_id>/*-pc.json`、`*-pynq.json` 和 `*-compare.json`，绑定包与用例哈希。
- 零断言标为 `smoke`，黄金玩法验收使用断言；缺失远端报告保持 PENDING，升级完整 Agent 软件后再对照。
- 所有自动报告的 `hardware_acceptance` 为 PENDING；本轮使用本机和 fake sink，无物理板部署或 HDMI 验收。

命令行入口：`python -m pynq_multimodal_game.game_validation game.vvg case.json --report report.json`。
将示例路径替换为实际构建包与用例；通过退出码 0，失败退出码 1。
专用 Skill 源位于 `xilinx-skill/plugins/voice-view-game-design/skills/voice-view-game-design/`，
通过 `install.ps1 -Skills voice-view-game-design -SkipAgentInstructions` 定向同步并校验 SHA-256。

本轮执行证据：

- 全仓 `python -m pytest tests -q`：`378 passed, 4 subtests passed`。
- Game2 `signal-sprint-golden.json` 经正式命令行入口运行：`passed`，76 tick，`coverage=asserted`；报告为 `results/game-validation/game2-golden.json`。
- 正式 Studio `--smoke-test` 启动退出成功；修改文件编辑器诊断与补丁空白检查通过。
- 专用 Skill 定向安装后全部文件 SHA-256 一致；其他 Skill 与全局 AGENTS 身份保持不变。
- fake sink 跨端逐 tick 对照、首个分歧、失败阻断上传、取消验证和双构建失败保留旧包均有回归覆盖。

## 2026-10-02：PYNQ 控制台 UI 重构（PC 验收 PASS）

Studio 以 PYNQ 上位机控制和后台读取为主场景，保留现有五页和 PC 辅助功能。
顶栏常驻设备地址、连接状态与实际握手 BUILD_ID；底部常驻当前会话 RX、
独立 HTTP 相机状态、任务反馈及最近板端回读时间，详细日志按需展开。

Game 默认进入控制与回读视图，板端运行摘要和执行记录优先，HDMI 输出提示收紧；
Video 优先显示上传与播放操作，明确区分 PC 解码预览和最近命令快照；
Vision/Audio 标明 DATA topic、source/channel/seq 与当前会话计数；PL GPU 为静态能力清单。
断线保留历史画面与回读标签；Agent 重新连接时重建 UI 有界缓冲区，接受新会话的序号。
板端任务忙碌时保留原连接配置；Video 编码、上传、控制及完成到线程清理间隙统一互斥。

设计使用 design-taste-frontend 的审计与一致性原则、emil-design-eng 的克制反馈、
Impeccable Operate 的原生操作布局。未运行下载引擎、自动钩子或 Web 检测器。
设计文档角色以内联方式执行，独立复核使用默认代理，未调用官方具名角色。
最终规则见 [DESIGN.md](../DESIGN.md)，侧车为 [.impeccable/design.json](../.impeccable/design.json)。

本次执行证据：

- 七个 Studio 测试文件：`51 passed`，涵盖 UI、Game、Video、capabilities、device、game_worker、game_replay。
- 正式入口 `python -m pynq_multimodal_game.studio.app --smoke-test` 成功启动并退出。
- 原生 Qt 平台 `windows`，实际 DPR 1.5（150%），逻辑 DPI 96。
- 1080x700、1280x800、1440x900 的五页两轮截图；关键控件边界检查零越界，中文标签可读。
- localhost Mock Agent 切页收包、断线重连、重启序号归零、连续更换两个 Agent、忙碌换设备门禁通过。
- localhost HTTP 503 相机连接失败 30 轮，全部回收线程并恢复控件，无原生进程崩溃。
- 默认代理独立只读复核；两项忙碌交互发现经修复与专项断言后均评为 resolved，评分范围为这两项。

截图位于 `results/studio/studio_final_<page>_<width>x<height>.png`，
`studio_final_pc_reference.png` 为真实 Game1 PC 回放帧。
本次使用本机 Mock 服务，无物理板端访问或部署；视频持续轮询、source 3 UI 接入、
远端 HDMI 捕获与其他 DPI 保留原范围。GPU、RTL、Overlay 与 320x180 逻辑分辨率保持冻结。

## S0：事实与能力冻结

目标：建立三层架构、能力矩阵和软件 bring-up 记录。

验收：每项能力属于已验证、PS 软件、尚待实现或未来 RTL；README 不再把计划写成事实。

## S1：Studio Shell 与 Simulator

目标：实现 PySide6 工作台、四工作区、模拟设备、日志和 C1 replay 预览。

验收：

1. `pip install -e .[studio]` 和 `voice-view-studio` 启动成功。
2. 四工作区切换 100 次无异常。
3. C1 replay 可播放、暂停、单步，330 tick 最终为 WON/40。
4. 预览 RGB 长度、首末帧 CRC 和最终状态与现有回归一致。
5. `QT_QPA_PLATFORM=offscreen` 测试通过，退出后无活动计时器。
6. 未安装 `studio` extra 时，基础包与基础测试不导入 Qt。

## S2：本机游戏设计

目标：项目树、素材导入、Scene 画布、属性检查、资源预算、受限 Game IR 和 `.s2game` 构建。

验收：相同输入两次构建字节一致；超 16 Sprite、128 command、32 KiB Asset 或 4 KiB Tilemap 时拒绝；非确定性和越权 API 被拒绝。

## S3A：算法无关协议与 Mock Agent（PASS）

目标：版本化 TCP framing、localhost Mock Agent、原子 staging/激活、幂等运行控制、有界返回队列、Studio QThread 接收和通用 fixture 显示。

验收结果：错误 CRC/ABI/BUILD_ID 被拒绝；失败不改变 active artifact；断线重连不重复提交；Agent 同端口重启后 Studio 自动恢复；fixture 视觉/声音画布可见；C1 330 tick 回归和全仓 `135 passed, 4 subtests passed`。

## S3B：PYNQ Render Agent 与 C6I Backend（PASS）

目标：将同一标准库 Agent 部署到 PYNQ，实现 C6I Overlay ownership、HP2/S2MM receive、deadline、状态遥测和安全停止。

验收结果：`C6IReturnSource`、source 3 publisher、CLI 启动门禁和失败传播通过 fake-PYNQ 与真实 PYNQ-Z2。独立部署哈希 33/33 一致；64 B、4 KiB、64 KiB 直接 DMA smoke、source 3 网络订阅、错误 BUILD_ID、第二实例、10/10 冷重启均通过；600 秒运行验证 6,000×64 KiB、393,216,000 字节，payload/CRC 完整一致且零跳号。Agent 正常退出并释放端口/锁，冻结 C4M7 随后恢复 330/330、约 59.6 FPS；全仓 `168 passed, 4 subtests passed`。

验收记录：`docs/bringup/2026-09-29_pynq-z2_studio-s3.md`。BUILD_ID、产物哈希、错误门禁、10 次 Agent 重启、持续运行、C4M7 恢复、项目事实记录和 Skill 源/部署 SHA-256 均已闭合。

## S4：游戏部署闭环

目标：Studio 完成构建、上传、校验、激活、运行和回滚。

验收：本地/板端哈希一致；5 次部署和回滚通过；10 分钟运行无 DMA、renderer 或 generation 错误；关键帧与 PC reference 一致。

后续子阶段在 PYNQ HDMI 上提供主界面，枚举并选择已部署游戏。主界面不承担
视频文件选择或视频播放控制；VIDEO 由上位机显式接管，停止后进入 `IDLE`，
待主界面完成后由 `IDLE` 返回主界面。

## S5：S2V1 视频

目标：由上位机完成视频选择、S2V1 编码、上传和播放控制；PYNQ Agent 负责
校验、调度和状态，上板复用冻结 C6I/C4M7 输出 320x180@30 fps CFR、20x12 个
16x16 Tile、INDEX4 Atlas 视频。PYNQ 本地界面不提供视频选择入口。

验收：每个三槽 Asset bundle 小于 32 KiB；Tilemap 启动时上传一次；每帧仅 CLEAR/DRAW_TILE_LAYER/END_FRAME；代表性视频连续播放无 packet drop 和 renderer error。画质门限依据固定测试集实测后冻结。

当前状态：PC 编码器、容器、CLI、硬件等价解码和 Studio 编码/预览已完成；
真实 C6I 直接播放、磁盘型分块上传、断线续传、Studio 后台上传以及 Agent VIDEO
runtime 的 upload/activate/run/stop 控制闭环已完成。首次 HDMI 目视使用高时变多色
fixture，现场观察为全屏闪烁马赛克和锯齿；随后使用低色、低时变的三色带与黄色移动方块
fixture 完成现场 HDMI 目视，显示正常。Studio 已实现远端播放、暂停、帧定位和停止控件，
并通过完整 PC 回归与真实 PYNQ run/pause/seek/resume/stop 验收；STATUS 返回当前帧、总帧数、
已呈现帧数、循环数和最后错误。PC 编码器新增连续空间 bank、加权 median-cut 与跨 GOP
palette residency；真实 HDMI 依次完成 `stable`、`spatial-resident`、`spatial-shared` 和
`spatial` 同板 A/B。现场确认 `spatial-resident` 相比原方案改善显著，现已设为 Studio 默认
profile；180 秒、5,400 帧长视频通过完整解码和真实 C6I 持续播放，板端 packet、DMA、RTL
和带宽保持不变。source 3 并行仍待独立验收，阶段保持 `IN PROGRESS`。

## S6：视觉与声音插件

目标：视觉多视图、声音波形/FFT/频谱和事件时间线。先使用 fixture/mock，队友交付后增加 adapter。

验收：暂停、乱序、过期、断流和重连状态明确；显示线程不阻塞数据源；录制输入可复现；实际算法结果符合队友测试向量。

## S7：发布与 Skill 闭环

目标：统一安装包、项目格式迁移、诊断包和兼容矩阵。

验收：每个发布能力都有项目事实；经跨项目复验的 PYNQ 通信、部署、DMA 和资源门禁经验进入 Skill 源，并完成源/部署 SHA-256 一致性检查。