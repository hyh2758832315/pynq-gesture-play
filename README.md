# GESTURE PLAY

单块 PYNQ-Z2 完成摄像头手势识别、HDMI 交互、二维渲染和 17 舵机灵巧手控制。PL 加速视觉前处理与像素绘制，PS 完成轮廓分类、场景逻辑和动作调度；同一份最新手势结果同时服务屏幕交互与实体手跟随。PC Studio 提供内容构建、测试和部署，板端可独立运行。

平台：PYNQ-Z2 / xc7z020clg400-1；Vivado 2026.1；PYNQ 3.1 / Python 3.10；PC Python 3.13。PL BUILD_ID 为 0xC0061000。

## 关键设计与结果

优化围绕两条实时路径展开：视觉前端把逐帧搬运和处理改为采集侧连续流；二维 GPU 通过描述符复用、像素流水和条件双像素写入减少绘制等待。灵巧手采用单总线阶段目标控制，运行时复用会话、跳过不变目标。

| 优化对象 | 已记录的变化 | 验证方式 |
| --- | --- | --- |
| 视觉识别结果更新率 | **6.11 → 18.27–21.18 fps** | 板端历史菜单窗口，按新结果帧号增量计量 |
| 32×16 不透明图块绘制 | **46.53 → 5.57 μs，耗时减少 88.03%** | 相同输入、100 MHz RTL 对照 |
| 320×180 混合光栅场景 | **589.29 → 289.74 μs，耗时减少 50.83%** | 相同输入、100 MHz RTL 对照 |
| 灵巧手目标写入通信量 | **5814 → 3819 B，减少 34.31%** | 同用例离线 SDK 对照，含 TX 与 ACK |

视觉原路径窗口为 600.25 s，下沉后两次窗口为 10.18 s、10.20 s，输入场景与并发负载按各次记录保留；GPU 对照检查输出 CRC、像素写入数量与预期结果。测量原件与详细分析见[完整设计报告](project/report/设计报告与大模型协作记录.md)。

## 目录

| 用途 | 路径 |
| --- | --- |
| 源码与 PC Studio | project/src/ |
| 完整 Vivado 工程、构建及实现报告 | project/build/ |
| 板端运行包与部署说明 | project/board/ |
| 仿真与实测 | project/sim/ |
| 测量数据 | project/data/ |
| 通用 PYNQ Skill | project/skill/ |
| 设计报告、协作记录及官方模板 | project/report/ |

## 开始使用

在短英文路径克隆仓库，Windows 建议启用 Git longpaths。以下检查只读文件，不连接硬件：

```powershell
python -B project/tools/verify_package.py
python -B project/tools/check_runtime.py
python -B project/tools/check_submission.py
python -B project/skill/validation/verify_files.py
```

Studio 安装、离线测试与硬件重建命令见 [工程 README](project/README.md)。完整工程为 `project/build/hardware/c6_latency/c6_latency.xpr`；从源码重新生成并构建使用 `project/build/scripts/build_hardware.tcl`。

默认视频为两段自制测试动画，生成入口为 `project/tools/generate_demo_media.py`。可在 Studio 中换成有权使用的素材。

## 视觉 PL 加速

颜色阈值、形态学和双掩码对齐直接在采集侧 PL 完成，PS 接收掩码后进行轮廓与手势判定，省去识别链中的 RGB 往返处理。行缓冲使邻域计算随像素流推进，原始与滤波掩码保持同帧对应，位置发布独立于手势稳定判定。

在 100 MHz、640×360 连续输入的 XSim 测试中，颜色掩码核与形态学／双掩码对齐核的每帧处理跨度分别为 **2.304 ms、2.372 ms**；两帧计数与输出检查均通过。该计时覆盖核内首输入到末输出，板端识别吞吐另由上表的实际窗口计量。

[阶段数据、仿真条件与复现](project/report/vision_acceleration/README.md) · [视觉处理与双路跟随设计](project/report/设计报告与大模型协作记录.md)

## GPU 优化与复现

提供基线、描述符缓存＋像素流水线、再加条件双像素三种完整构建配置。13 组同输入对照的输出 CRC 与写入数保持一致；独立源码包复跑得到相同周期和校验结果。三项优化在完整系统中增加 **290 个 LUT（0.89%）**，减少 208 个 FF 和 2 个 BRAM36 等价块，DSP 数量保持不变。

三种配置均完成全量综合和实现，已约束路径的 TNS、THS 均为 0。默认运行包采用三项优化，两种优化配置均通过 Studio 安装和现场菜单、游戏及灵巧手交互验收；同一 PS 软件可配合三种硬件配置运行。

[机制与性能/资源对照](project/report/gpu_optimization.md) · [三配置构建和安装命令](project/README.md#gpu-配置与硬件重建) · [验证结果](project/report/validation.md)

## Skill 与报告

[PYNQ Skill](project/skill/README.md) 提供 PL 行为保持校验和 20 张诊断卡片，包含可运行示例、适用条件及验证结果；[ROSS 联合工作流](project/skill/pynq-debug-cards/references/ross_workflow.md)说明如何组织 MCP 任务、核对日志与验收设计结果。

[设计报告与大模型协作记录](project/report/设计报告与大模型协作记录.md) · [关键协作对话](project/report/ai_collaboration.md) · [官方要求对照](project/report/submission_checklist.md) · [第三方及许可](project/report/licensing.md)

项目自有源码、文档及自制测试动画采用 [MIT](LICENSE)，第三方范围见 [许可说明](THIRD_PARTY_NOTICES.md)。

## 项目作者

[hyh2758832315](https://github.com/hyh2758832315) · [Cui-Peiqi](https://github.com/Cui-Peiqi) · [HH-bit-dev](https://github.com/HH-bit-dev)

## 参考项目与致谢

感谢以下开源项目提供的实现基础、硬件方案和设计参考。

| 参考项目 | 采用或参考的内容 | 本项目实现 |
| --- | --- | --- |
| [KPTKleist/Pynq_Gesture_Detect](https://github.com/KPTKleist/Pynq_Gesture_Detect) | OpenCV 手势识别参考实现，相关代码保留 MIT 声明。 | 相机接入、全画面定位、视觉算子 PL 下沉，以及手势与界面、游戏和灵巧手的联动。 |
| [Xilinx/PYNQ-ComputerVision](https://github.com/Xilinx/PYNQ-ComputerVision) | OpenCV 算子在 PYNQ 上进行 PL 加速的公开方法。 | 颜色掩码、形态学等 RTL 模块及帧数据对齐与管理。 |
| [PainterEngine_embedfpga](https://gitee.com/bambridge/PainterEngine_embedfpga) / [PainterEngine](https://github.com/matrixcascade/PainterEngine) | 指令分发、参数锁存、状态处理和流水线控制的架构参考。 | 独立实现 Scene2D 指令与资源上传、片上索引色缓冲、光栅化和帧边界呈现。 |
| [orcahand/orcahand_hardware](https://github.com/orcahand/orcahand_hardware) | 灵巧手机械结构与装配方案。 | 将实体手接入 PYNQ 手势交互系统，实现动作与 HDMI 显示同步。 |
| [orcahand/orca_core](https://github.com/orcahand/orca_core) | 手部模型、校准和控制 SDK。 | PYNQ 端启动检查、动作调度与设备权限交接。 |
| [N-B-Studio/orca_core](https://github.com/N-B-Studio/orca_core)，含 [SCS-225](https://github.com/N-B-Studio/orca_core/tree/main/SCS-225) | Feetech SCS225 / ST3215 系列舵机适配分支及改装资料。 | 单总线接入、播放期间无持续反馈轮询的动作控制、最新手势消费与恢复逻辑。 |

引用代码保留各自版权与许可；结构设计、参考方案和商标遵循原项目条款。具体组件范围见许可说明。

[完整参考资料](project/report/references.md)列出赛事指南、PYNQ-Z2 产品资料、PYNQ 3.1、PG021、UG903、UG906，以及图像、相机、AXI 流和灵巧手相关项目。
