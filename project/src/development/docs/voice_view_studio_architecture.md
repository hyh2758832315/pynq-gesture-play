# Voice View Studio 架构

## 2026-10-27 当前工作流

Studio 现分为按需手势回传观察、PC 内容创作/测试、统一内容加载。`AuthoringGameWorkspace` 复用游戏编辑器与沙盒，只有 PC 目标，持有平台输入配置但不持有远程控制 session；`LocalVideoWorkspace` 使用有界最新帧缓存和单个解码 worker，支持多个素材、预览/暂停/停止和完整解码测试。旧 GameWorkspace/VideoWorkspace 保留作兼容组件，不接入默认 Studio 工作流。

`ContentLoadWorkspace` 是唯一默认部署入口，`content_pipeline.load_content` 先验证全部包，再顺序调用现有 RemoteDeviceSession 安装接口并核对 Library 身份。游戏发布包与 PC 沙盒缓存分离；视频冻结源文件后转换；每批写独立 receipt、测试报告和产物。取消或断线保存部分完成情况，正在安装但回读未确认的项标为 unconfirmed。没有自动 LIBRARY_RUN 或硬件初始化。

Game/Video 切页停止本地工作，Vision 切页释放 HTTP 订阅，加载期间三者互斥。连接替换、关闭窗口都以线程退出确认作门禁，超时保留 owner。顶栏连接经真实本机模拟 Agent 验证，物理板卡未在本轮访问。当前操作说明与证据见 [闭环记录](bringup/2026-10-27_studio_content_closure.md)；下文保留早期 C6I 架构背景，目标选择和分散上传界面已由上述流程替代。

## 文档状态

2026-10-08 选择性接入补记：融合 `0xC0060800` 候选的控制路径为相机/PL → PS worker → 本地游戏 provider → 原生打包运行时 → GPU/HDMI。Studio 负责配置、监控、部署及验收，HTTP 结果用于观察，不成为板端游戏控制依赖。通过显式 `--vision-game-input` 按已验证 manifest.game_id 映射 game1 四向/跳跃、game2 稳定三态、game3 左右/确认/跳跃；旧入口默认不变。相关离线软件与现场验收分别记入 [选择性同步记录](bringup/2026-10-08_selective_board_vision.md)。本文下方早期 C6I 能力表保留其原阶段边界。

| 字段 | 内容 |
| --- | --- |
| 文档类型 | 长期软件架构与能力边界 |
| 日期 | 2026-09-29 |
| 状态 | IN PROGRESS |
| 硬件基线 | C6I / BUILD_ID `0xC0060700`，内部冻结 C4M7 GPU |
| ABI | Voice View TCP `1.0` / Scene2D `1.0` |

本文定义 PC Studio、PYNQ PS Render Agent 和 C6I PL 的职责边界。C6I 保留冻结 C4M7 GPU，并增加已验收的 HP2/S2MM 返回数据面。任何计划能力只有通过对应阶段验收后才能写成已实现。

声音先行接入的专项设计见 [声音先行融合方案](voice_first_integration_plan.md)，覆盖队友 Vivado 2024.1 基线向 2026.1 迁移、单 Overlay 合并、MANUAL 视觉输入与 REAL 声音控制、Studio 分析及实时性门禁。该方案为待实施设计，保留本文的已验证能力边界。

## 1. 真实能力边界

### 1.1 已验证

- 320x180 INDEX4 双 framebuffer，4x 最近邻输出 1280x720p60。
- `CLEAR`、`DRAW_TILE_LAYER`、`BLIT_INDEX4`、`FILL_RECT`、`END_FRAME`。
- 128 条命令、最多 16 个 Sprite。
- 3 槽 Asset bundle、4 槽 Tilemap、256 色 Palette，均使用 generation/ownership。
- AXI DMA MM2S over HP0、render completion 和 vblank present。
- C1 330 tick 严格回放、10/10 Overlay 重载和约 59.9 FPS 实时播放。
- C6I HP0/MM2S 与 HP2/S2MM 同 Overlay 双向并发，150/150 reload soak 和 49,500 MiB 返回完整性。
- Voice View TCP `1.0` framing、CRC、拆包/粘包、Mock Agent、幂等状态机、有界返回队列和 localhost 自动重连。
- Studio QThread 异步接收以及 `fixture.frame2d/series/spectrum` 通用显示。
- 真实 PYNQ Agent 独立部署、C6I source 3 网络发布、错误 BUILD_ID/第二实例门禁、10/10 冷重启和 6,000×64 KiB 持续运行；payload/CRC 完整一致且零跳号。

### 1.2 已实现的软件框架

- 固定 48 字节大端 envelope、8 MiB payload 上限和增量 TCP decoder。
- `HELLO/COMMAND/SUBSCRIBE/DATA/TELEMETRY/PING/ERROR` 通用消息。
- artifact SHA-256/ABI/BUILD_ID 校验、原子激活和 request ID 幂等缓存。
- 按 source/channel 的 latest-wins 队列及 dropped/stale/out-of-order 统计。
- localhost Mock Agent、远端 DeviceSession、断线自动重连和 fixture 显示。
- 算法无关 `C6IReturnSource`、跨进程 Overlay ownership、持久 S2MM buffer、共享绝对 deadline 和 source 3 opaque 发布；PC fake-PYNQ 与真实 PYNQ-Z2 均已验证。
- S2V1 V1 确定性编码、容器校验、硬件等价解码、CLI 和 Studio 编码/预览；默认
  `stable` palette profile 在 PC 端稳定 GOP 颜色槽，板端 packet 与资源预算不变；
  C6I 直接播放器已通过 fake MMIO/DMA 与真实 PYNQ 连续播放测试。
- 磁盘型 artifact begin/chunk/commit/abort/status、逐块与完整 SHA-256、S2V1
  commit 校验、断线续传和 Studio 独立连接后台上传。
- 单进程 `C6IOverlaySession`、C6I VIDEO runtime 与 `c6i-video` CLI；真实 PYNQ
  已完成 fixture upload/activate/run/pause/seek/stop 到 `IDLE`、网络视频 HDMI 目视
  和 C4M7 恢复。

### 1.3 尚待实现

- `.s2game`、Game IR、上传回滚和真实板端运行控制。
- PYNQ HDMI 主界面及已部署游戏选择。
- S2V1 stable profile 的真实 HDMI A/B、source 3 并行与长时播放。
- 视觉和声音数据的实际 adapter。

### 1.4 需要未来 RTL 或保持 unsupported

- C4M7 PL 不消费 `FRAME8` packet；Python packer 的存在不代表硬件支持。
- 通用 RGB 视频、旋转、任意缩放、Alpha、三角形和 Shader 不属于冻结 GPU。
- 新视频/音频采集硬件由未来阶段和队友接口决定。

## 2. 三层架构

```text
PC Voice View Studio
  project / reference renderer / async client / stream views
        |
        | Voice View TCP 1.0: control, subscription, opaque DATA
        | USB-UART: log and recovery only
        v
PYNQ PS Render Agent
  validate / stage / activate / runtime / bounded queues
        |
        | HP0/MM2S Scene submit + HP2/S2MM return
        v
C6I PL Overlay
  frozen C4M7 GPU / return transport / HDMI 720p60
```

PC 不直接 MMIO，Render Agent 不运行任意上传的 Python，PL 不解释上位机项目格式。三层之间通过版本化契约连接。

## 3. Studio 工作区

| 工作区 | S1 | 后续 |
| --- | --- | --- |
| 视觉 | 有界 stream、fixture RGB 与矩形叠加 | 原图/滤镜/边缘/mask/真实检测 adapter |
| 声音 | 有界 stream、fixture waveform/频谱 | 真实波形/FFT/频谱/事件 adapter |
| 游戏 | C1 replay、reference renderer、状态遥测 | 项目树、Scene、Game IR、构建与部署 |
| 视频 | S2V1 stable 编码、硬件等价预览、后台分块上传、播放/暂停/seek/停止、板端状态 | 固定质量集、source 3 并行与长稳态 |

视觉和声音工作区在队友交付前使用 `fixture.*` topic，不定义采集设备、业务字段、事件语义或 golden 格式。真实 adapter 只注册 source/topic decoder，不改变 TCP envelope 和线程模型。

## 4. 运行模式

Render Agent 后续提供互斥模式：

- `IDLE`：保持最后有效 HDMI framebuffer。
- `GAME`：60 Hz 游戏逻辑与 Scene 提交。
- `VIDEO`：按编码时间戳提交 S2V1 帧。
- `DIAGNOSTIC`：只运行冻结 replay 和硬件诊断。

切换模式必须停止旧任务、等待当前 DMA/renderer 边界、再原子启用新任务，避免两个生产者同时提交 Scene。
视频仅由上位机显式进入；PYNQ HDMI 主界面只选择已部署游戏。VIDEO 停止后
进入 `IDLE`，主界面实现后由该状态恢复主界面，不自动恢复被接管的游戏。

## 5. 资源事实

C4M7 最终 routed utilization：

| 资源 | 占用 | 器件总量 | 使用率 |
| --- | ---: | ---: | ---: |
| Slice LUT | 11,617 | 53,200 | 21.84% |
| FF | 19,384 | 106,400 | 18.22% |
| Slice | 6,106 | 13,300 | 45.91% |
| BRAM Tile | 60.5 | 140 | 43.21% |
| DSP | 2 | 220 | 0.91% |
| BUFG | 5 | 32 | 15.63% |
| MMCM | 2 | 4 | 50% |

视觉和声音硬件共享门限内余量。任何单模块预算都不能把同一余量重复分配。

## 6. 证据规则

- PC 软件事实记录在 `docs/bringup/YYYY-MM-DD_pc-studio_<stage>.md`。
- 真实板卡部署记录在 `docs/bringup/YYYY-MM-DD_pynq-z2_studio-<stage>.md`。
- 普通 UI 修复保留在项目记录；PYNQ/Overlay/DMA/部署的跨项目复验经验才进入 Xilinx Skill。
- README 只引用通过阶段，计划和估算保留在本文及阶段计划中。
- S3A PC Mock 事实见 `docs/bringup/2026-09-29_pc-studio_s3.md`；PYNQ backend 状态保持 PENDING，直至独立板端记录通过。
