# GESTURE PLAY v3.0 参赛整理版

这是 GESTURE PLAY v3.0 的独立工程包。平台为 PYNQ-Z2 / xc7z020clg400-1，Vivado 2026.1，BUILD_ID `0xC0061000`，板端 R15b、灵巧手 R16。Skill 已补充 PL 行为保持校验工具与复现实验，见 [技能包](skill/README.md)。发布检查见 [官方要求对照](report/submission_checklist.md)。

## 目录对照

| 官方推荐用途 | 本目录 |
| --- | --- |
| 设计源码 | src/studio、src/hand、src/development；当前硬件实际输入在 build/hardware/c6_latency |
| 仿真与验证 | src/development/tests、src/development/sim、sim/evidence |
| 可复现构建、实现报告 | build/scripts、build/hardware、build/reports |
| 上板工程、脚本、实测 | board/runtime、sim/evidence/v3_release |
| 测试数据、参考结果 | data、report/reference_v2_performance/data，以及各游戏测试工程 |
| 设计报告、协作记录 | report/design_report.md、report/ai_collaboration.md、两份 reference_v2 报告目录 |
| Skill | [skill/README.md](skill/README.md) |

各复现入口均以本目录为基准。第三方源码及 Vivado 文件的约定大小写见 data/naming_exceptions.json。

## 快速核验与 PC Studio

在本目录运行，Windows 使用 Python 3.13；依赖安装需要联网：

```powershell
py -3.13 -m venv .venv
.venv\Scripts\python.exe -m pip install -e "src/studio[studio,vision,video]" pytest
.venv\Scripts\python.exe -B tools/verify_package.py
.venv\Scripts\python.exe -B tools/check_runtime.py
.venv\Scripts\python.exe -B tools/start_studio.py
```

启动器选择本目录 board/runtime 和本目录游戏；不自动上传、开启回传或驱动灵巧手。默认板卡 `192.168.2.99`，电脑直连地址 `192.168.2.1`，SSH 别名 `pynq-z2`，使用用户配置的密钥。Studio 中“安装完整项目”上传此包；“启动／连接项目”沿用板端默认策略。已配置自启动的板卡上电自动加载，无需先打开 Studio。

## Vivado

直接打开 `build/hardware/c6_latency/c6_latency.xpr`。当前构建目标为 `synth_button_r23` / `impl_button_r23`；旧运行标签是工程历史，不应改用旧音频或旧增量构建。

本次全新构建的最终产物在 `build/rebuilt`。工程 `.runs` 内的 bit 是定点时序收敛前中间结果；应使用脚本最后输出的 result/产物，并运行 `check_hardware.py`。Studio 使用发行版硬件；默认视频为可再生成的测试动画，历史收据路径已脱敏。

从源码新建并完整构建，输出目录必须尚不存在：

```powershell
vivado -mode batch -source build/scripts/build_hardware.tcl -tclargs build/output/rebuild_01
.venv\Scripts\python.exe -B tools/check_hardware.py build/output/rebuild_01/result
```

只重建工程、不启动综合：在一个空的工作目录中 source `build/scripts/recreate_project.tcl`；脚本通过自身位置找到包内硬件源文件。仅查看原发行的最终报告可运行：

```powershell
vivado -mode batch -source build/scripts/report_frozen.tcl
```

冻结板端 bit/HWH/XSA/DCP 保持原发布 SHA。新综合的产物独立输出；即使重新构建成功，也必须检查接口、时序和软件配对，不能直接覆盖原板端清单或声称 bit 字节必然相同。

## 离线回归

```powershell
.venv\Scripts\python.exe -B tools/run_offline_tests.py
```

使用本机 TCP/HTTP 回环，不连接实体板卡。结果写入 sim/evidence/normalized_studio.xml。板端软件依赖 PYNQ 3.1 / Python 3.10 和配套灵巧手环境，见 [部署说明](board/README.md)。

RTL 可复现自检入口：`vivado -mode batch -source sim/run_frame_owner.tcl`，默认输出 `build/output/frame_owner_01`。已有输出不会被覆盖，重复运行通过 `-tclargs 新的英文输出路径` 选择新目录。当前结果见 [验证记录](report/validation.md)。

## 报告及许可

[设计报告](report/design_report.md) 为当前整理入口，优化数据保留测量版本与实验条件。项目自有源码与文档采用 [MIT](LICENSE)，署名留空；第三方范围见 [许可说明](report/licensing.md)。公开前的工程检查见 [检查清单](report/missing_items.md)。

## 提交材料

[官方逐项对照](report/submission_checklist.md) · [报告图稿与数据](report/report_materials.md) · [官方 Word 模板](report/templates/official_report_template.docx) · [PYNQ Skill 0.2.2](skill/README.md)。运行 `python -B tools/check_submission.py` 核对本次补充材料，完整性清单包含这些新文件。

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

[完整参考资料](report/references.md)列出赛事指南、PYNQ-Z2 产品资料、PYNQ 3.1、PG021、UG903、UG906，以及图像、相机、AXI 流和灵巧手相关项目。
