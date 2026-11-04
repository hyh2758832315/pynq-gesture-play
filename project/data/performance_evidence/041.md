# 灵巧手持续运行候选与只读复查（2026-10-25）

本轮将真实串口 owner 从固定30秒验证会话扩展为随视觉会话持续运行。修改仅在独立候选和手侧自有源码中；未将新候选部署到板端，未使能或移动实体手。另做了一次旧手树的只读实板复查，设备错误仍存在，见下文。

## 持续运行合同

`--hand-serial-actions` 仍须显式启用、通过完整只读启动门禁，并提供三段已复核的动作等待时间。默认不设整段运行时限；新鲜视觉来源存续期间，沿用同一 Controller 和 enable epoch。若需要限时验证，增加 `--hand-serial-seconds 30`；零、负值、NaN、Inf及脱离串口模式的时限参数均被拒绝。Mock/shadow诊断模式原有时限不变。

持续运行没有移除10秒启动预算、0.5秒视觉来源新鲜度、5秒Controller租约或串口交易/退出的有界等待。持续输入只续租，不重复自检或使能；失活、撤销、来源身份变化或显式关闭仍取消、卸力并关闭，不自动重连或重新使能。保持四态策略和动作期间丢弃旧分类、完成当前动作后再处理最新帧；只保存最近32条请求诊断。持续持力的真实温升、机械跟随与延迟仍没有实物验收证据。

## 离线验证

- 手侧 [continuous-owner-offline-20261025.json](../../subprojects/pynq_usb_hand/build/continuous-owner-offline-20261025.json)及同名日志：**182项通过**、117个冻结文件一致、禁止真实串口与网络connect。新增连续模式重复旧帧最终过期卸力、非法可选时限拒绝；已有有限时长测试保留。
- PS候选、shadow/mock及最新帧回归：**35项通过**，含新时限参数拒绝规则。
- [continuous-owner-integration-20261025.log](../../build/continuous-owner-integration-20261025.log)：**4项通过**，持续入口、有限时入口、未退出串口子进程不得被terminate、完整OFF收据校验。
- [35秒原始驻留回执](../../build/r24-serial-continuous-soak-20261025.json)：`elapsed=35.297...`、`max_seconds=null`，35秒驻留期间父进程持续检查ACTIVE，跨过原30秒边界；撤销来源后 Controller 为 CLOSED/error=null，17颗OFF确认、端口关闭。该测试使用真实本机UDP、生产父/子入口和控制器、冻结SDK及生产编解码，但用线程替代进程启动、用内存设备替代物理串口，明确 `hardware_tested=false`。

复核命令（项目根目录）：

```powershell
subprojects/pynq_usb_hand/.venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/test_hand_serial_session.py -v
subprojects/pynq_usb_hand/.venv/Scripts/python.exe -B build/run_r24_serial_continuous_soak_20261025.py
subprojects/pynq_usb_hand/.venv/Scripts/python.exe -B subprojects/pynq_usb_hand/tools/verify_offline.py --output subprojects/pynq_usb_hand/build/continuous-owner-recheck.json
```

输出为驻留JSON、完整回归JSON及同名日志。驻留脚本运行约35秒；它不验证物理温升或动作到位时间。

## 当前候选

[部署清单](../../build/ps-ui-r24-hand-continuous-20261025-offline-package/deployment_manifest.json) SHA `4799896DDF5E6B4A36226C21DAAC41F50883F6C52975070232EF5B09F2DBF01B`，445文件，`board_pending=true / release_ready=false`。串口源清单SHA为 `9085B69FA529D525CD6C608CAAFF51EE82CE5AB5D4CA33C6F5FF262C40AC0BCD`。持续和限时两种完整参数的 `--check-only` 均通过。

该包包含上一轮的手页状态与原DMA退出修复；它替代 serial-hand-ui 包作为当前离线候选。板端旧手树不包含这个新owner，后续部署必须建立新目录并满足新源清单，不能直接对旧目录启用动作。

```powershell
.venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/build_deployment_candidate.py --output build/ps-ui-r24-hand-continuous-recheck
.venv/Scripts/python.exe -B build/ps-ui-r24-hand-continuous-20261025-offline-package/start_board_test.py --check-only --hand-readonly-root subprojects/pynq_usb_hand --hand-readonly-python subprojects/pynq_usb_hand/.venv/Scripts/python.exe --hand-readonly-port /dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00 --hand-serial-actions --hand-stage-waits 0.1 0.2 0.3
```

这里只是预检；`0.1 0.2 0.3` 是语法/身份检查参数，没有经过机械验证，不作为真实动作等待时间。限时预检可在命令后增加 `--hand-serial-seconds 30`。

## 实板只读 r02

SSH确认没有Agent/手侧进程、串口无人占用后，用原隔离手树的probe执行一次READ。仍返回1号电机 `communication=0, device_error=1`；退出码1、`READ_ONLY_STOPPED`、`motion_authorized=false`、`port_closed=true`。原始报告为 [hand-readonly-r24-recheck-20261025-r02.json](../../build/hand-readonly-r24-recheck-20261025-r02.json)，精确命令及结果已立即补入 [R24实板事实记录](2026-10-25_r24_board_validation.md)。结束后再次fuser无串口owner。

下一步是现场核对独立供电/接线、排除该错误，再进行新的完整只读检查与分阶段真实动作验证。全目标仍未完成：机械阶段等待、持续持力温升、视觉到动作时延及各HDMI页面现场观察均待验证。
