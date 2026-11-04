# GESTURE PLAY v3.0

基于 PYNQ-Z2 的手势交互、灵巧手控制与二维渲染系统。视觉前端和渲染流水线在 PL，交互与动作调度在 PS；PC Studio 提供内容构建、测试、安装及连接入口。

平台：PYNQ-Z2 / xc7z020clg400-1；Vivado 2026.1；PYNQ 3.1 / Python 3.10；PC Python 3.13。PL BUILD_ID 为 0xC0061000。

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

## Skill 与报告

[PYNQ Skill](project/skill/README.md) 提供 PL 行为保持校验和 20 张诊断卡片，包含可运行示例、适用条件及验证结果。

[设计报告](project/report/design_report.md) · [大模型协作](project/report/ai_collaboration.md) · [官方要求对照](project/report/submission_checklist.md) · [第三方及许可](project/report/licensing.md)

本仓库为 GESTURE PLAY v3.0 公开发行工程。项目自有源码、文档及自制测试动画采用 [MIT](LICENSE)，第三方范围见 [许可说明](THIRD_PARTY_NOTICES.md)。

## 参考项目与致谢

感谢以下开源项目提供的实现基础、硬件方案和设计参考。

| 方向 | 参考项目 | 本项目中的关联 |
| --- | --- | --- |
| PYNQ / OpenCV 手势识别 | [KPTKleist/Pynq_Gesture_Detect](https://github.com/KPTKleist/Pynq_Gesture_Detect) | 早期 OpenCV 手势识别参考实现；相应来源代码保留原 MIT 声明。在此基础上完成相机接入、全画面定位、部分视觉算子 PL 下沉和交互整合。 |
| OpenCV 算子硬件加速 | [Xilinx/PYNQ-ComputerVision](https://github.com/Xilinx/PYNQ-ComputerVision) | PYNQ 中将 OpenCV 算子映射到 PL 的公开方法参考。当前工程的颜色掩码、形态学等硬件模块以仓库内 RTL 为实现入口。 |
| FPGA 2D GPU | [bambridge/PainterEngine_embedfpga](https://gitee.com/bambridge/PainterEngine_embedfpga) / [PainterEngine](https://github.com/matrixcascade/PainterEngine) | 参考指令分发、参数锁存、状态与错误处理、流水线有效信号对齐。Scene2D 在本项目中独立实现指令与资源上传、片上索引色缓冲和帧边界呈现。 |
| ORCA Hand 机械结构 | [orcahand/orcahand_hardware](https://github.com/orcahand/orcahand_hardware) | 灵巧手结构与装配方案来源。 |
| ORCA Hand 控制软件 | [orcahand/orca_core](https://github.com/orcahand/orca_core) | 手部模型、校准和控制 SDK 的上游。 |
| SCS225 舵机改装与适配 | [N-B-Studio/orca_core](https://github.com/N-B-Studio/orca_core)，含 [SCS-225](https://github.com/N-B-Studio/orca_core/tree/main/SCS-225) | 采用面向 Feetech SCS225 / ST3215 系列舵机的适配分支；本项目进一步完成 PYNQ 单总线接入、启动检查、零反馈动作播放和最新手势调度。 |

引用代码保留各自版权与许可；结构设计、参考方案和商标遵循原项目条款。具体组件范围见许可说明。

[完整参考资料](project/report/references.md)列出赛事指南、PYNQ-Z2 产品资料、PYNQ 3.1、PG021、UG903、UG906，以及图像、相机、AXI 流和灵巧手相关项目。
