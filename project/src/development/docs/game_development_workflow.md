# Voice View 游戏开发工作流

## 统一边界

Voice View 的统一编码覆盖 `GamePlugin` SDK、`Scene`、`SceneCompiler`、GPU ABI 和 `.vvg` 包格式。游戏业务逻辑保留多文件 Python 工程结构，在 PC 和 PYNQ PS 执行同一份代码；PL 通用 GPU 只接收既有 Scene/Asset/Palette/Tilemap packet，游戏更新无需重新综合 bitstream。

框架采用三层结构：Studio 负责设计、测试和装载编排；`pynq_multimodal_game.engine` 提供 PC/PYNQ 共用的无 GUI 确定性引擎；`games/<game_id>/src` 保存输入映射、关卡、资源、Scene 和 snapshot。共享引擎只消费玩法命令，不直接依赖 Qt、设备对象或具体传感器采集结构。

## 工程结构

新建游戏生成以下结构：

```text
game-id/
├── game.toml
├── src/
│   ├── __init__.py
│   └── main.py
├── assets/
└── tests/replays/
```

`game.toml` 固定游戏 ID、显示名、版本、入口、SDK、tick/render rate、逻辑分辨率、目标 BUILD_ID 和 GPU ABI。`src/main.py` 是最小入口；复杂游戏可在 `src/` 下增加多个模块。

入口工厂必须返回 `GamePlugin`，实现：

- `reset(context)`：按确定性 seed 初始化；
- `step(game_input)`：固定 tick 推进逻辑；
- `build_scene()`：返回当前 `Scene`；
- `assets()`：返回 sprite/tile atlas 与 palette；
- `snapshot()`：返回可比较的游戏状态；
- `close()`：释放游戏资源。

## Studio 操作顺序

1. 双击、快捷方式或 `voice-view-studio` 启动 Studio。游戏项目默认从仓库 `games/` 读取，不依赖启动工作目录；自定义项目库使用环境变量 `VOICE_VIEW_GAME_PROJECTS_ROOT`。
2. 游戏工作区默认选中真实 `game1`。左侧可新建、导入或刷新项目；新建时可选择空白 GamePlugin 或可直接运行的横版动作引擎模板，刷新会先保存当前源码并保留所选项目。
3. 在“游戏源代码”页编辑全部 `src/**/*.py`；`game_sdk.py`、`scene.py`、`engine/side_scroller.py` 位于“平台 API（只读）”分组。
4. 在“测试时间线”页新建、编辑、保存或删除用例，配置 tick 事件、最大 tick 和断言。用例保存到工程 `tests/replays/`。
5. 无板试玩时选择 `PC` 并点击“PC 试玩”。会话记录一次随机 seed，直接消费手动输入，持续运行至停止；复位复用同一 seed。点击“运行 PC 测试”则从 tick 0 执行当前时间线，按 `max_ticks` 结束并生成断言与完整报告。
6. 使用暂停、继续、单步、复位及握拳/剪刀/布三态选择、坐标和音调控件调试 PC 运行。状态区区分待消费提交与 PC 实际消费，底部审计台记录构建、测试、输入和断言事件。
7. PYNQ 可用时在顶栏“PYNQ 设置”填写 Agent 地址和端口并连接；选择 `PYNQ` 或 `PC + PYNQ 对照` 后点击“装载并运行”。Studio 自动上传、安装、Library 回读校验并携带同一测试 JSON 启动。

所有设备安装、运行、输入和状态查询均在 Qt 后台任务中执行。命令执行期间相关按钮进入门禁状态，失败原因写入结构化审计表。

安装完成以 `LIBRARY_LIST(game)` 回读相同 game ID、VVG 长度和 SHA-256 为准。上传进度、包身份和板端 item ID 显示在进度区与审计台。

## game1 参考实现

`games/game1` 是冻结 C1 的标准产品工程。它复用共享 `SideScrollerEngine`，并在 VVG 内自行持有输入适配、关卡、资源、Scene、snapshot 和 `GamePlugin` 组合。三类内置测试分别覆盖完整黄金通关、手动输入和暂停/单步/复位。

- 有效手部主轴超过 0.35 死区时映射上下左右，所有手势均可控制方位；
- 握拳边沿映射跳跃；
- 220 Hz 低音持续映射护盾；
- 1200 Hz 高音起始边沿映射攻击；
- 低音护盾与高音攻击重叠时，攻击首帧保留上一帧护盾锁存。

黄金用例覆盖 tick 0..329，最终状态为 `WON`、40 分，状态 SHA-256 为 `af10ca2b7564ad16fb59b0ed8bc730335975e618dfc47b3c950de553ac2abd86`。

## game2 像素猜拳

`games/game2` 的版本 2.0.0 为独立像素猜拳游戏。`main.py` 组合 `rules.py`、`input_adapter.py`、`assets.py`、`scene_builder.py` 和 `snapshot.py`，采用自己的确定性状态机。SDK 1.1、GPU ABI 1.0 和 BUILD_ID `0xC0060700` 保持冻结。

- 左侧人手消费 `hand_valid` 与显式 `hand_gesture`；握拳对应石头，剪刀、布各有像素姿态，未知输入显示空心轮廓。
- 每轮同一有效手势连续稳定 0.5 秒后进入 3 秒倒计时；变换姿态或丢失识别会清零稳定计数。稳定阈值由规则的 `stability_ticks` 配置。
- 倒计时用三态快轮换、柔和叠影和小幅抖动遮蔽双方选择；机器在本轮首次倒计时开始时由 `GameContext.random.choice` 均匀预承诺，动画保持随机流独立。
- 截止帧先消费输入，再锁定当帧的人手分类与机器承诺；揭示 1.5 秒内固定双方手势。截止帧未知则回到稳定等待，重试保持原机器承诺。
- 揭示后等待 0.5 秒，下一轮重新检测稳定。固定完成三轮，平局计回合，前两轮 2:0 后继续第三轮；终局比较胜局数为 `WON/LOST/DRAW`，score 为玩家胜局数。复位或再次试玩可重开。
- 文字、数字与双手均使用公开索引图集/Scene，`hud=None`；最多 16 精灵，资产与色板在会话中保持稳定。

60 Hz 且从 tick 0 连续保持有效手势时，第一轮稳定完成 tick 29，出拳锁定 tick 209；第二轮锁定 tick 538；第三轮锁定 tick 867；终局 tick 957。识别中断会推迟时序，时间线范围仍为包含末 tick 的 `0..max_ticks`。

四个 schema-2 回放覆盖胜、负、平局及稳定/截止帧边界。GameRunner、无 GUI 双跑、Studio 和软件 PackagedGameRuntime 已验证；同包同用例的软件运行时报告匹配 959 tick。真实三态视觉来源由队友 adapter 接入，PYNQ-Z2 HDMI 验收保留待验证状态。

旧 Signal Sprint 的全部七个文件位于 `tests/fixtures/signal_sprint`，仅承担隔离回归覆盖，Studio 项目库只发现正式 `games/` 工程。旧四项测试保持 `WON/30`、state SHA-256 `5896e5681f5a38b5dfd426bf35284e18286a0b2b1c287c16cbb2e4de9d54dab0` 和末帧 CRC32 `565955719`。

2026-10-04 验证：全仓 `467 passed, 4 subtests passed`；正式 Studio smoke 退出码 0；Windows 原生 1440x900 / 1080x700 的 PC、PYNQ、对照六组布局通过。回放报告、阶段像素图、姿态图与截图位于 `results/game-validation/game2/`，`rps-win-pc-report.json` 为完整 959 tick 的 PC 证据。

双构建包 `game2-2.0.0.vvg` 为 8989 字节，SHA-256 `a10a4dc68610a88b5beef017d8368d227651f6aa9f15bf08a37a5924330e8fbb`。软件报告中的 `hardware_acceptance` 保持 `pending`，此包与现场 HDMI 验收身份分别记录。

## game3 共鸣王国

`games/game3` 版本 1.0.0 将经典横版平台玩法与局部声音机关结合。入口组合 `level.py`、`input_adapter.py`、`rules.py`、`assets.py` 和 `scene_builder.py`；snapshot 由入口统一序列化。固定 1536 像素关卡、整数定点物理、分轴碰撞、巡逻敌人和音频 tick 计数与 Studio、无 GUI运行时共享。

### 角色与操作

- 开局状态 `SELECT`：有效手部向左选择男冒险者 LEO，向右选择女公主 ROSE，握拳边沿确认。确认帧只完成选角，下一次握拳边沿才跳跃。
- ROSE 使用原创金发、金色皇冠、粉色裙装与青绿宝石像素形象；LEO 使用橙色帽装和青绿上衣。两人都有待机、两帧行走、腾空与左右翻转，速度、跳跃和碰撞体一致。
- 游玩状态：有效手部水平位置超过 0.35 死区时左右移动，分类为握拳、剪刀、布或未知均支持方向；握拳边沿跳跃。角色选择在本局保持固定。
- 玩法包含加速/摩擦、6 tick 离地容错和跳跃缓冲、奖励砖顶撞、金币、落坑、踩敌反弹、3 点生命及 90 tick 受伤保护。到达高台终点获得 100 分。
- 胜负结算 60 tick 后，新握拳边沿回到角色选择；Studio 复位同样回到选择界面。

### 声音融合

音符机关位于门前，升降台位于高台前。声音起始时锁定最近的局部目标，水平距离上限 64 像素、垂直上限 48 像素；离开目标范围会使本次声音失效。界面显示局部声音进度条。

- 音符机关：持续 3..24 tick 的短音在释放时开门，即 60 Hz 下 50..400 ms；长音保留为升降台的动作语义。
- 升降台：连续声音累计 18 tick（300 ms）后，以每 tick 0.75 像素升高。停声后保持 120 tick（2 秒），随后以每 tick 0.375 像素下降。台面从 y=144 升至 y=64，支持载人，并在前方实体遮挡时停止，避免挤压。
- 每次声音使用 `ToneSignal.sequence` 去重，active 时长按逻辑 tick 累计。现有输入提供频率和活动状态，本关按时长与目标位置控制机关；真实人声的音量、音色及语音分类由后续声音 adapter 定义。

在 Studio 选择 `game3`、执行目标 `PC`，点击“PC 试玩”。手部控件分别提交左右位置与握拳边沿；“音调”控件可注入短音或持续音。完整通关测试使用 300 ms 短音开门，在台面持续约 2066 ms 后跳上高台；输入频率只作为注入载荷保存。

### 开源参考与依赖

研究参考了 [meth-meth-method/super-mario](https://github.com/meth-meth-method/super-mario) 的分轴碰撞、跳跃请求与踩敌结构，[mx0c/super-mario-python](https://github.com/mx0c/super-mario-python) 的地面/腾空状态划分，以及 [SuperTux](https://github.com/SuperTux/supertux) 的离地容错、跳跃缓冲和方向接触处理。代码与美术资源为本工程独立实现，公开项目作为只读机制参考；检索文件、版本和许可边界见 [game3 参考记录](../xilinx-skill/plugins/voice-view-game-design/skills/voice-view-game-design/references/game3_reference.md)。

碰撞后端复用 `collision==1.2.2` 的 `Poly.from_box` / `collide`，严格边界接触先由 AABB 排除。该依赖为 MIT、纯 Python，安装元数据未声明传递依赖，已加入根 `pyproject.toml`；安装完整项目后可由 PC 和 Agent 游戏 worker 导入。PYNQ/ARM 的依赖安装与性能需要板端验收。

### 验证证据

四个 schema-2 回放覆盖男女通关、落坑重选、选择与确认边界，均通过断言与双运行指纹检查。双角色完整玩法在 tick 791 通关，tick 800 保持 `WON`、200 分、3 生命；公主回放与软件 `PackagedGameRuntime` 逐 tick 匹配 801 帧，`hardware_acceptance=pending`。

游戏局部检查通过 19 项，Studio 项目发现与角色选择回放通过 1 项。全关横向取样的 Scene 编译、复位、升降台防挤压和完整软件运行时对照均覆盖。Windows 原生 1440x900、1080x700 的选择/游玩窗口及十张实际场景图已归档到 [game3 证据目录](../results/game-validation/game3/)。

双构建包 `game3-1.0.0.vvg` 为 11593 字节，SHA-256 `24b621c20ecae157da94a1b13a1572739004a73fdfbd92c963ef34963d8d95f7`；801 帧报告最高 14 条命令，最高预测周期 118240。周期属于编译器估计值，真实 60 Hz 板端性能、摄像头/麦克风 adapter 和 HDMI 实屏待现场验证。完整 PC 报告为 `results/game-validation/game3/princess-win-pc-report.json`。

2026-10-04：全仓回归 `487 passed, 4 subtests passed`，正式 `pynq_multimodal_game.studio.app --smoke-test` 退出码 0。截图发现的升降台进度条遮挡随后修复，游戏与 Studio 局部 20 项复验通过；最终包、PC 报告与截图同步重建为上述身份。

## 测试用例与断言

测试用例采用版本化 JSON，保存：

- `test_id`、名称、确定性 seed 和 `max_ticks`；
- schema 1 的 hand/fist/tone/cancel 旧事件，schema 2 的三态 gesture 事件及稳定 `event_id`；
- 指向 `GameSnapshot` 字段的比较断言。

PC worker 和 PYNQ runtime 都从 tick 0 开始，在首帧提交前应用事件，并在该帧生成后执行断言。`max_ticks` 表示最后执行的 tick；达到该 tick 后会话进入完成/暂停状态。手动对照输入在 PC 和 PYNQ 使用同一 input ID。

对照模式比较最终 tick、status、score、values、Scene SHA-256、命令数和 predicted cycles。PC 的 RGB/CRC 属于 GoldenRenderer reference 输出；Studio 的 PYNQ 页面显示运行状态和硬件遥测，真实 HDMI 像素仍由板卡 HDMI 端口输出。

## `.vvg` 包

`.vvg` 是确定性 ZIP。相同工程内容在同一工具版本下重复构建应得到相同 SHA-256。包内包含：

- `game.toml`；
- `package.json` 文件清单与逐文件 SHA-256；
- `src/**/*.py`；
- 可选 `assets/**`、`tests/replays/**` 和 `thumbnail.png`。

构建和安装拒绝绝对路径、`..`、反斜杠路径、重复路径、软链/特殊条目、未声明文件、哈希篡改、非法 Python、危险系统导入以及 SDK/ABI/BUILD_ID 不匹配。

Game SDK 1.1 提供共享横版引擎能力。runtime 保持同 major 下的 minor 向后兼容：1.1 runtime 可运行 1.0/1.1 包，声明 1.2 的包会在构建或安装前被拒绝。共享引擎升级未改变 Scene/GPU packet 时，GPU ABI 继续保持 1.0。

## PC/PYNQ 等价路径

PC 预览执行：

```text
.vvg -> GamePlugin -> Scene -> SceneCompiler + GoldenRenderer
```

PYNQ 执行：

```text
.vvg -> 低权限 game worker -> SceneCompiler -> C6I Agent sink -> 通用 GPU
```

PYNQ worker 关闭 RGB 软件渲染，只传输 GPU packet；Agent 保持唯一 Overlay/MMIO/DMA owner。首帧上传 asset、palette 和 tilemap，后续仅在资源 packet 哈希变化时重新上传。

## 输入语义

- 手势坐标：Studio 使用逻辑坐标 `x=0..319`、`y=0..179`，SDK 统一映射到 `[-1,1]`。
- 分类：`HandGesture.FIST/SCISSORS/PAPER` 保存当前手势，未知分类独立保留；`gesture_sequence/gesture_changed` 记录分类切换。
- 握拳：切入握拳时增加 `fist_sequence` 并产生单 tick `fist_event`；持续握拳保持状态，切到其他状态或取消后可再次触发。旧 FIST 事件保留逐事件触发语义。
- 方位：game1 仅检查 `hand_valid` 和坐标，握拳、剪刀、布及分类未知均可控制位置。
- 远程软件调试：HELLO 的 `input_schema_version=2` 表示支持三态注入与新版时间线；旧 Agent 明确提示升级完整软件包，Overlay 和硬件 ABI 保持不变。
- 输入报告：旧用例保持原输入哈希格式，新字段进入版本 2 指纹；报告对照先检查输入版本。
- 音调：保留 `frequency_hz`、active/start/end 和 sequence；持续时间按游戏 tick rate 向上取整。
- “清理状态”：停止当前 runtime、取消注入并回菜单，不删除 SD Library。
- “初始化”：回菜单、重扫 catalog 并恢复 Shell 状态，不重新加载 Overlay。

Agent 为 packaged game 提供独立的 `GAME_PAUSE`、`GAME_RESUME`、`GAME_STEP` 和 `GAME_RESET` 命令，避免与视频 runtime 控制混用。`RuntimeSnapshot` 返回 game tick、snapshot、Scene hash、命令预算、输入 accepted/consumed ID、断言统计和测试完成状态。

以上输入用于验证游戏消费的结构化事件。真实摄像头手势、麦克风采样和声音识别算法继续由各自 adapter 独立验收。

## 信任边界

首版只运行本机创建的受信任游戏。游戏逻辑在独立进程执行，且不直接持有 Qt、Overlay、MMIO 或 DMA 对象。允许第三方游戏前还需增加系统用户隔离、namespace/seccomp、文件与网络权限、CPU/RSS 配额以及签名信任链。
