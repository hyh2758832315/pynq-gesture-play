# C 负责人实施规划

## 1. 目标与边界

本规划面向 2026 AMD FPGA 创新设计竞赛自主选题赛道。目标平台为 PYNQ-Z2（`xc7z020clg400-1`），板端系统基线为 PYNQ v3.1，工程工具采用 Vivado/Vitis 2026.1。

C 负责从标准控制事件到正式游戏画面的完整链路：

```text
KEYBOARD / BUTTON / REPLAY / REAL
                  |
           ControlSourceMux
                  |
        60 Hz PS game engine
                  |
      scene descriptors + commit
                  |
       PL Scene2D command GPU
                  |
       1280x720@60 HDMI output
```

正式游戏逻辑运行在 PS Python，SceneCompiler 将通用场景降级为固定 ABI 命令，PL 在 100 MHz 域将命令光栅化到片上双 framebuffer，74.25 MHz 像素域完成 palette 查询、4x 扫描和 HDMI 输出。Python CommandRenderer 定义命令级像素行为并服务于 RTL 对照。

## 2. 展示拓扑

| 链路 | 用途 | 运行依赖 |
| --- | --- | --- |
| PYNQ HDMI Out -> 大屏 | 正式游戏画面 | 必需 |
| PYNQ Ethernet -> 电脑 | 配置、遥测、日志和后续后台 | 辅助 |
| PYNQ USB -> 电脑 | UART/JTAG、恢复和可选键盘输入 | 调试 |

旁边电脑的完整后台界面安排在 A/B 接入后。当前先固定 JSONL/CSV 遥测格式，网络断开时游戏仍在板端运行。

## 3. 冻结接口

### 3.1 ControlState

```text
tick_id, timestamp_ns,
gesture_source, gesture_seq,
hand_valid, hand_x, hand_y, direction,
fist_score, fist_event,
voice_source, voice_seq,
audio_valid, low_voice_active, high_voice_event,
low_confidence, high_confidence,
stale_flags
```

- `direction` 与 `low_voice_active` 为持续状态。
- `fist_event` 与 `high_voice_event` 只维持一个游戏 tick。
- `gesture_seq` 与 `voice_seq` 单调递增，供跨时钟域事件检测。
- 手势源和声音源可以分别选择 `KEYBOARD/BUTTON/REPLAY/REAL`。
- 切换来源后的首个有效快照用于建立基线，事件脉冲从下一次有效变化开始产生。

### 3.2 Scene

首版固定参数：

| 项目 | 规格 |
| --- | --- |
| 逻辑画面 | 320x180 |
| HDMI 输出 | 1280x720@60 |
| 放大方式 | 4x 最近邻 |
| 命令 bank | 双 4 KiB，64 B Header + 最多 128 条 32 B Command |
| Framebuffer | 双 320x180x8-bit BRAM，token 高 4 位为 palette bank |
| 素材 | INDEX4，偶数 X 在低半字节，透明索引为 0，64 B 对齐 |
| 合成 | 命令顺序覆盖，无 Alpha blending |
| 提交 | inactive command bank 写入；完成帧在垂直消隐期切换 |

场景至少包含 `frame_id/camera_x/TileLayer/SpriteDescriptor/HudState`。这些游戏无关的高层对象只存在于 PS 侧；RTL 只识别稳定的 Scene2D Header、Command、资产描述符、Tilemap 和 Palette ABI。

## 4. 阶段与门禁

| 阶段 | 前置 | 实现目标 | 自动验收 | 人工验收 | 下一阶段条件 |
| --- | --- | --- | --- | --- | --- |
| C0 环境 | 板卡、工具安装包 | 最小 Overlay 与版本兼容烟测 | BUILD_ID/MMIO、重复加载 10 次 | 断电启动后 SSH/Jupyter 可达 | `.bit/.hwh` 在 PYNQ v3.1 可稳定加载 |
| C1 参考模型 | PC Python | 控制、游戏、重放、Scene、golden renderer | 单元测试、状态哈希、像素 CRC | 键盘完成一局 | 固定回放可重复，软件接口冻结 |
| C2 PS 闭环 | C1、PYNQ | headless 游戏、板载按键、场景协议 | 30 min、deadline miss < 1% | BTN/SW 驱动全部动作 | 网络断开仍可运行 |
| C3 HDMI G0 | C0 | 720p60 时序、测试图、单 Sprite | 仿真、WNS >= 0、TNS = 0 | 大屏连续显示 30 min | 彩条、坐标和 Sprite 正确 |
| C4 Renderer G1 | C1、C3 | 命令光栅器、资产读取、双 framebuffer | RTL/golden CRC、命令周期预算 | 滚动与重叠无撕裂 | 随机场景首差异可定位 |
| C5 板端 MVP | C2、C4 | 模拟输入完整通关 | replay 哈希/CRC、2 h 稳定性 | 键盘和按键各通关 | A/B 只需替换输入源 |
| I1 接口就绪 | C5、A/B 寄存器表 | 真实适配器、失效和热切换 | 合成快照与故障恢复测试 | 声音/手势逐路接入 | 双路 `REAL` 稳定运行 |

## 5. 分阶段执行

### C0：环境和最小 Overlay

1. 安装并启动 Vivado 2026.1，确认 `vivado -version`。
2. 固定 PYNQ-Z2 官方 PS7 参数来源和版本。
3. 创建 PS7 + AXI GPIO 或自定义 BUILD_ID 寄存器工程。
4. 生成配对的 `.bit/.hwh`，导出 `.xsa` 和构建报告。
5. 在 PYNQ v3.1 中通过 `Overlay` 加载并读写 MMIO。
6. 连续加载 10 次，归档版本、日志和板卡编号。

2026-09-25 C0 已通过：Vivado 2026.1 使用 PYNQ v3.1 固定提交中的官方 Pynq-Z2 PS7 DDR/MIO 参数生成 `c0_overlay.bit/.hwh/.xsa`；板端 PYNQ 3.1 连续加载 10 次，均从 `0x41200000` 读得 BUILD_ID `0xC0010001`。完整证据见 `docs/c0_acceptance_2026-09-25.md`。

### C1：Python 行为参考

当前已完成：

- 不可变 `ControlState` 和枚举值；
- 键盘/板载模拟输入语义、事件边沿和方向仲裁；
- 手势源与声音源独立选择的 `ControlSourceMux`；
- `ControlState` JSONL 写入和确定性 replay；
- 整数状态的 60 Hz 游戏内核；
- 移动、跳跃、护盾、攻击冷却、胜负和状态哈希；
- 五轨道固定关卡、9 块石头、11 个敌人刷新点、12 枚金币和双方弹丸；
- 跳跃越障、落石后自由移出、弹丸/敌人撞石、敌人一击击败并加 5 分、金币加 10 分；
- 敌人 15 tick 首发延迟和 45 tick 连射间隔；
- 玩家受伤、护盾抵挡、跳跃躲避敌方飞行物、30 tick 无敌时间和 4 tick 闪烁；
- `Scene/TileLayer/SpriteDescriptor/HudState`；
- 视口剔除和 16 Sprite 固定预算；
- 320x180 golden renderer、palette、透明、优先级、翻转、裁剪和 4x 放大；
- 固定关卡 PC 键盘演示和带 `SCORE` 数字分数的顶部状态栏。
- 无界面 replay 运行器：控制输入 SHA-256、最终状态 SHA-256、首末帧 CRC、P50/P95/P99/max tick 耗时和状态差事件 JSONL；
- 固定答辩控制预设 `data/replays/c1_demo_controls.jsonl` 及其正式归档 `results/replays/c1_demo.report.json`、`results/replays/c1_demo.events.jsonl`；预设 330 tick 通关，最终分数 40，状态哈希 `af10ca2b7564ad16fb59b0ed8bc730335975e618dfc47b3c950de553ac2abd86`。

当前自动检查为 48 项单元测试。运行方式：

```powershell
$env:PYTHONPATH = (Resolve-Path '.\python').Path
python -m unittest discover -s tests -v
```

C1 后续实现顺序：

1. 冻结 C1 的 `ControlState`、`GameState`、`Scene`、replay JSON schema 与 golden 基线；
2. 进入 C2：实现 PYNQ PS 无显示运行器、BTN/SW 输入适配与场景描述符输出；
3. 以固定 replay 验证 C2 的最终状态哈希与首末帧 CRC。

### C2：PYNQ PS 无显示闭环

板载映射：

| 输入 | 动作 |
| --- | --- |
| `SW1=0`，`BTN0/1` | 左/右 |
| `SW1=1`，`BTN0/1` | 上/下 |
| `BTN2` 按下沿 | 跳跃 |
| `SW0` 有效 | 护盾 |
| `BTN3` 按下沿 | 攻击 |

按键进行 10 至 20 ms 去抖。游戏主循环作为 Python 模块或服务运行，Notebook 只负责启动、停止和查看结果。

当前已完成本地 C2 软件准备：

- `PynqButtonAdapter` 接收 6-bit BTN/SW 原始位图，按连续两次稳定采样去抖，并复用 `ControlState` 的方向仲裁与边沿语义；
- `headless_runner` 以 60 Hz 执行固定 replay，记录 tick 耗时、deadline miss、最终状态哈希和首末帧 CRC；
- C2 Vivado 派生脚本、BUILD_ID `0xC0020001`、`input_gpio` 地址 `0x41210000`、板端 Overlay 验证脚本和 golden replay CLI 已就绪；
- PYNQ-Z2 BTN/SW 约束已从 Xilinx/PYNQ 固定提交 `19ed17d4fd4ea71f95a97d30f8ccd0d62b8dbaaa` 的 `base.xdc` 提取；来源 Git blob、SHA-256 与端口重命名记录在 `board/pynq_z2/reference/c2_buttons_switches_source.md`；
- `board/pynq_z2/scripts/build_c2.ps1` 已在 Vivado 2026.1 完成 C2 的 `.bit/.hwh/.xsa` 离板构建。最终报告为 WNS `3.928 ns`、TNS `0.000 ns`、WHS `0.106 ns`、THS `0.000 ns`，DRC 为 0 项检查；
- 首次真实 Overlay 部署前创建 `docs/bringup/2026-09-25_pynq-z2_c2.md`，按项目上板记录模板归档构建、部署和验收事实。

### C3：HDMI G0

Vivado 工程采用脚本重建，包含 PS7、AXI-Lite BUILD_ID、时钟复位、720p60 timing、测试图、内部帧计数和 HDMI TX。构建输出包括：

```text
c3_overlay.bit
c3_overlay.hwh
c3_overlay.xsa
c3_overlay_manifest.txt
reports/c3/utilization.rpt
reports/c3/timing_summary.rpt
reports/c3/clock_utilization.rpt
```

像素时钟为 74.25 MHz，AXI 控制时钟暂定 100 MHz。每个时钟域均具有明确复位与 CDC 处理。

2026-09-26 本地门禁已通过：720p 整帧仿真与测试图像素仿真通过；Vivado 2026.1 完成 `c3_overlay.bit/.hwh/.xsa` 构建，WNS `3.755 ns`、TNS `0.000 ns`、WHS `0.026 ns`、THS `0.000 ns`，DRC 为 0 项检查。官方 PYNQ-Z2 HDMI 引脚和 `rgb2dvi:1.2` 均固定到 PYNQ v3.1 提交并执行逐文件哈希校验。板端 BUILD_ID、物理显示和 30 分钟稳定性进入下一轮验收。

### C4：PL Renderer G1

RTL 按以下顺序增加能力，每次增加后执行仿真与实现：

1. 双 4 KiB command bank 与 Header/Command 校验；
2. `CLEAR`、`FILL_RECT` 光栅操作；
3. INDEX4 `BLIT`、透明索引和裁剪；
4. Tilemap、`camera_x` 与通用 HUD primitive；
5. 双 320x180x8-bit framebuffer 与 Palette scanout；
6. command commit、render done 和垂直消隐期 framebuffer 切换。

光栅器运行在 100 MHz 域，并以整帧命令周期预算为门禁；scanout 运行在 74.25 MHz 域，保持每输出像素一拍。两个域通过双时钟双口 BRAM、bank ownership 和 XPM 单比特握手跨域。Python 和 RTL 共用命令 bank、资产、Tilemap、Palette 与 framebuffer CRC 向量。

### C5：模拟输入板端 MVP

PS 以 60 Hz 更新游戏状态并提交不超过 4 KiB 的命令 bank，PL 将命令渲染到 inactive framebuffer 并连续输出 720p60。键盘、板载按键与 replay 只改变 `ControlState` 来源，游戏、SceneCompiler 与 GPU ABI 保持同一实现。

验收记录包含：

- 完整通关录像；
- 最终状态哈希和场景 CRC；
- scene commit/ack 超时计数；
- 输入到显示延迟 P50/P95/P99/max；
- 2 h 稳定性日志；
- post-route 资源和时序报告。

## 6. 硬件加速证据

PL Renderer 的加速结论由五类证据共同支撑：

| 证据 | 采集内容 |
| --- | --- |
| 功能 | PL 完成命令解析、裁剪、光栅写入、透明合成、palette、缩放和 HDMI 时序 |
| 正确性 | 固定与随机场景相对 golden 的 CRC、像素差异数和首差异坐标 |
| 吞吐 | 光栅命令周期、74.25 Mpixel/s scanout、1 output pixel/clock、稳定 720p60 |
| 系统收益 | PS CPU、命令提交字节率、延迟与软件全帧 renderer 基线 |
| 实现 | LUT/FF/BRAM/DSP、WNS、TNS 和功耗报告 |

1280x720 RGB888 单帧约 2.64 MiB，60 fps 单向完整帧流量约 158 MiB/s。该数值用于设计预算，答辩结论使用板端实测数据。

## 7. A/B 交付检查表

A/B 每路交付：

- 接口版本；
- AXI-Lite 寄存器表；
- 完整快照读取规则；
- 单调事件序号及回绕规则；
- valid、stale、故障计数；
- golden vectors 和独立测试程序；
- IP 源码、综合报告和时钟要求。

C 使用合成寄存器快照先验证超时、序号变化、热切换和故障恢复。逐路接入时，另一模态继续使用模拟源。

## 8. 14 天建议

| 天 | 单一可演示结果 |
| --- | --- |
| 1 | `ControlState`、Mock、Mux 和事件测试 |
| 2 | 固定 tick 游戏动作与状态哈希 |
| 3 | Scene 与 golden renderer CRC |
| 4 | 障碍、敌人、弹道和碰撞 |
| 5 | 键盘完成预设关卡 |
| 6 | 2026.1 安装与 PYNQ board files |
| 7 | C0 BUILD_ID bit/hwh |
| 8 | PYNQ Overlay/MMIO 烟测 |
| 9 | 板载按键 headless 游戏 |
| 10 | 720p60 timing 仿真 |
| 11 | HDMI 彩条上板 |
| 12 | 单 Sprite BRAM 仿真 |
| 13 | 单 Sprite HDMI 移动 |
| 14 | C0-C3 报告和一键复现检查 |

## 9. 目录目标

```text
python/pynq_multimodal_game/   PS package and golden model
tests/                         Python unit and replay tests
src/rtl/                       Renderer and HDMI RTL
sim/                           RTL testbench and shared vectors
board/pynq_z2/                 Board constraints and overlay scripts
data/assets/                   Original game assets and manifests
data/replays/                  Deterministic control logs
docs/                          Architecture and execution documents
metrics/                       Runtime, latency and comparison results
build/                         Generated local outputs
report/                        Competition report materials
skill/                         Reproduction skill package
```

最终提交前统一检查仓库目录与文件名为英文，生成物与源码分离。

## 10. Definition of Done

- 2026.1 工程可由脚本从空构建目录生成 bit/hwh/xsa；
- PYNQ v3.1 可重复加载 Overlay 并通过自检；
- 模拟、板载、replay 和真实输入共享 `ControlState`；
- 同一 seed 与 replay 的最终状态哈希和场景 CRC 一致；
- PL Renderer 达到 720p60、1 pixel/clock、WNS >= 0、TNS = 0；
- golden/RTL 随机场景像素一致；
- 大屏完整通关且连续运行 2 h；
- 性能、资源、正确性、稳定性与复现材料归档完整。