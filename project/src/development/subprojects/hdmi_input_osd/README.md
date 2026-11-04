# HDMI input OSD — isolated candidate

Target: PYNQ-Z2 / xc7z020clg400-1 / Vivado 2026.1. This directory is owned by the independent OSD task. It does not modify the running r15 candidate, shared tests, build scripts, bit/HWH, or Studio. No board connection or deployment is part of this offline stage.

The OSD belongs after the **final GPU palette scanout** and before RGB2DVI, after any display-source mux. It takes the existing continuous RGB/DE/HS/VS stream, adds a fixed three-cycle pipeline, and never stalls it. Menu, image, video, game, and paused framebuffer therefore share the same overlay. This requires a new hardware candidate; existing deployed hardware cannot gain this feature through a VVG update.

状态：独立实现已完成，整机接入及实屏待验。接口与边界见 [INTEGRATION.md](INTEGRATION.md)，原始失败、修正与验收结果见 [PROGRESS.md](PROGRESS.md)。

## 已实现

- 所有经过同一最终HDMI输出链的默认菜单、游戏、暂停、图片和视频共享一个OSD；不依赖Scene更新。
- 有位置、未知手势时固定绿色圆环与中心点；确认握拳后红色小一档圆环，位置和中心点不随检测框缩放。
- 右侧8像素宽、240像素高音量条，两个真实门槛刻线；失效显示灰槽。
- 独立的源身份与过期看门狗、帧边界原子切换；重复读取不会刷新旧数据。
- PS观察适配器只读现有快照，默认30Hz、最多1读7写/次；忙时跳过，无队列、无事件消费。

## 独立复验

以下是Windows PowerShell命令；Python3.10+、Vivado2026.1。`--bin`及`--vivado`替换为本机已核准路径。输出目录必须未占用，原失败记录不能覆盖。

```powershell
python -B subprojects/hdmi_input_osd/tools/run_xsim.py --bin D:/Xilinx/Vivado/2026.1/Vivado/bin --output subprojects/hdmi_input_osd/build/xsim-new --full-hdmi
python -B subprojects/hdmi_input_osd/tools/run_synth.py --vivado D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat --output subprojects/hdmi_input_osd/build/synth-new
python -B subprojects/hdmi_input_osd/tools/verify_offline.py --xsim subprojects/hdmi_input_osd/build/xsim-new --synth subprojects/hdmi_input_osd/build/synth-new --output subprojects/hdmi_input_osd/build/verify-new
python -B subprojects/hdmi_input_osd/tools/package_release.py --verification subprojects/hdmi_input_osd/build/verify-new/verification.json --output subprojects/hdmi_input_osd/deliveries/hdmi-input-osd-new.zip
```

预期输出：XSim三阶段日志/源SHA/唯一PASS、OOC综合DCP及utilization/timing/CDC/DRC/bus_skew报告、观察适配器测试日志、verification.json、逐成员SHA与CRC复核后的独立ZIP及外部SHA回执。工具不访问板卡，也不启动Studio。

`tools/synthesize.tcl`也可在本子项目build目录用 `vivado -mode batch -source ../tools/synthesize.tcl -tclargs <NEW_DIRECTORY>` 单独运行；推荐上方Python入口保存源身份及完整stdout。`attach_new_parent.tcl`的执行方式、所需新父工程及输出见INTEGRATION.md，当前仅作待验合入材料。

下一步：等主线窗口允许后，在新硬件父级接入模块与只读观察接口，完成整机时序及所有界面实屏验收。当前发布状态始终 `release_ready=false / board_pending=true`。
