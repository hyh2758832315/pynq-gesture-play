# GESTURE PLAY 工程说明

本目录包含系统源码、Vivado 工程、Studio、板端运行程序与复现资料。平台为 PYNQ-Z2 / xc7z020clg400-1，Vivado 2026.1，BUILD_ID `0xC0061000`。[PYNQ 技能包](skill/README.md)提供 PL 行为保持校验与集成排错方法；材料索引见 [官方要求对照](report/submission_checklist.md)。

## 目录对照

| 官方推荐用途 | 本目录 |
| --- | --- |
| 设计源码 | src/studio、src/hand、src/development；当前硬件实际输入在 build/hardware/c6_latency |
| 仿真与验证 | src/development/tests、src/development/sim、sim/evidence |
| 可复现构建、实现报告 | build/scripts、build/hardware、build/reports |
| 上板工程、脚本、实测 | board/runtime、sim/evidence/gpu_optimization；基线见 sim/evidence/v3_release |
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

## GPU 配置与硬件重建

描述符缓存复用图块信息，像素流水线重叠取数与写入，条件双像素合并相邻有效像素的写入。相同输入下，32×16 图块场景由 4653 降至 557 周期；320×180 光栅场景由 58929 降至 28974 周期。三个配置输出 CRC 与写入数一致，完整集成的 DSP 数量均为 20。详见 [优化机制、对比与板测](report/gpu_optimization.md)。

| 配置参数 | 描述符缓存 | 像素流水线 | 条件双像素 |
|---|---|---|---|
| `baseline` | 关 | 关 | 关 |
| `cache_pipeline` | 开 | 开 | 关 |
| `cache_pipeline_pair` | 开 | 开 | 开 |

`board/runtime` 默认采用三项优化。三个配置共用当前 PS/Studio 软件、命令 ABI 与 BUILD_ID；上传与渲染重叠均关闭。`build/rebuilt` 和 `frozen_*` 报告保留基线实现，最新三配置结果位于 `build/reports/gpu_optimization`。

在 Vivado 2026.1 的命令环境中，从本目录选择一个配置完整重建，输出目录须不存在：

```powershell
vivado -mode batch -source build/scripts/build_hardware.tcl -tclargs build/output/baseline baseline
vivado -mode batch -source build/scripts/build_hardware.tcl -tclargs build/output/cache_pipeline cache_pipeline
vivado -mode batch -source build/scripts/build_hardware.tcl -tclargs build/output/cache_pipeline_pair cache_pipeline_pair
```

脚本应用所选参数，重新生成 BD，执行全量综合和实现，再从通过检查的布线后设计导出配套产物。输出各目录下 `gesture_play/gesture_play.xpr` 和 `result/`。包内 `build/hardware/c6_latency/c6_latency.xpr` 可直接查看集成结构；构建时以上述显式配置为准。

将重建硬件与板端程序配对，再通过 Studio 安装（以三项配置为例）：

```powershell
python -B tools/prepare_runtime.py --hardware build/output/cache_pipeline_pair/result --profile cache_pipeline_pair --out build/output/runtime_pair
$env:PYNQ_RUNTIME=(Resolve-Path build/output/runtime_pair).Path
python -B tools/start_studio.py
```

准备脚本检查时序、布线、DRC、配置负载、软件地址映射与实际 GPU 参数，生成新的完整性清单，并执行启动预检。预期输出 `RUNTIME_PACKAGE_VERIFIED`；它只准备文件，安装和启动由 Studio 完成。其余配置对应修改三个路径/配置参数。

相同输入的三配置周期与输出对照：

```powershell
python -B sim/gpu_optimization/generate_vectors.py
vivado -mode batch -source sim/gpu_optimization/run_compare.tcl -tclargs build/output/gpu_compare
python -B sim/gpu_optimization/summarize.py build/output/gpu_compare
```

预期六组仿真通过、13 组 CRC/写入数相同，输出 `measurements.csv/json`。周期数据衡量 GPU 内部执行工作；系统交互效果由独立板测确认。

## 离线回归

```powershell
.venv\Scripts\python.exe -B tools/run_offline_tests.py
```

使用本机 TCP/HTTP 回环，不连接实体板卡。结果写入 build/output/tests/normalized_studio.xml。板端软件依赖 PYNQ 3.1 / Python 3.10 和配套灵巧手环境，见 [部署说明](board/README.md)。

当前灵巧手实现位于 `src/hand`，板端封装位于 `board/runtime`；`src/development` 保留开发参考。灵巧手软件单元验证使用内存/模拟后端，不驱动实体：

```powershell
python -m pip install -e src/hand pyserial PyYAML ftservo-python-sdk==2.0.0
$env:PYTHONPATH=(Resolve-Path src/hand/src).Path
python -B -m unittest discover -s src/hand/tests -q
```

RTL 可复现自检入口：`vivado -mode batch -source sim/run_frame_owner.tcl`，默认输出 `build/output/frame_owner_01`。已有输出不会被覆盖，重复运行通过 `-tclargs 新的英文输出路径` 选择新目录。当前结果见 [验证记录](report/validation.md)。

## 报告及许可

[设计报告](report/design_report.md) 介绍系统设计与实现，优化数据保留测量版本与实验条件。项目自有源码与文档采用 [MIT](LICENSE)，署名留空；第三方范围见 [许可说明](report/licensing.md)。工程验证范围见 [检查清单](report/missing_items.md)。

## 提交材料

[官方逐项对照](report/submission_checklist.md) · [报告图稿与数据](report/report_materials.md) · [官方 Word 模板](report/templates/official_report_template.docx) · [PYNQ Skill](skill/README.md)。运行 `python -B tools/check_submission.py` 核对本次补充材料，完整性清单包含这些新文件。

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

[完整参考资料](report/references.md)列出赛事指南、PYNQ-Z2 产品资料、PYNQ 3.1、PG021、UG903、UG906，以及图像、相机、AXI 流和灵巧手相关项目。
