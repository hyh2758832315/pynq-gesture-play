# 灵巧手被动接入：双进程通道验证

本文记录2026-10-24的 PC 通道原型和边界验证，采用内存执行后端。当前整机部署、可恢复跟随及实物验证见[设计报告](../../../../report/design_report.md)和[验证报告](../../../../report/validation.md)。

后续影子入口已经实现：`run_agent_shadow.py` 用两个显式manifest SHA核验冻结游戏和手侧源码，校验实际模块来源，在PYNQ Python3.10/root/显式boot门禁下运行原Agent；只有独立发布线程和观察子进程增加到该候选。默认未安装，支持纯PC `--check-only`。`shadow_session.py`复用单槽数据报合同，在独立手解释器运行 `shadow_receiver.py`；后者不导入串口、PYNQ或ORCA，也不构造Controller，不能驱动实物。启动前没有游戏就不产生子进程。

`b09-shadow-lifecycle.json` 证明冻结真实游戏取样→发布线程→独立影子解释器的完整PC链路：三手势、暂停撤销、生产者停止后的过期退出，以及尚未开始游戏时关闭均通过；`b10-regression.json`重新通过168项与117冻结校验。b07首次因为Windows venv启动器PID与解释器子PID不同而拒绝握手，原失败保留；之后同时核验launcher/child父子关系、session/game及地址，POSIX解释器路径保留venv符号链接，避免误选基础环境。

最终 `b13-shadow-candidate.zip`（源码根source-bridge-r03）有173项哈希，SHA256 `f330e8ae5f3a32b3b501f8682dec01ba162f02cd4127b6c881d2583a6ca7a726`。b14在独立解包目录完成实际入口check-only、错误manifest拒绝、PC误启动板端拒绝，以及解包后的真实双进程全链路复验；173项前后SHA不变。b11/b12为前一候选及通过记录，最终入口另外保证hook卸载异常也执行影子进程清理。ARM和实板观察仍待板卡恢复。

最终候选手侧manifest SHA为 `f591a3164b9099b980fb4d78cc9099ccb0e67350dbcc6ac8bd38fa63a94dbe34`，与b14-restore-check.json实值相同；启动入口同时要求R21 manifest SHA及当次新boot，不沿用历史boot/PID。

## 实现

`game_bridge.py` 在显式安装时包裹游戏 `_sample_live_input`：原方法只调用一次，返回对象原样交还游戏；只复制同 tick 的手势和来源收据。渲染线程仅投递到 try-lock 单槽，不进行串口、socket、JSON 编码或等待慢消费者。独立低频工作线程通过非阻塞数据报发布单槽快照。

接收端每轮最多32个、每包最多2048字节，绑定显式 channel session 与 game run；原始视觉 run/config/frame 和采集年龄继续校验。重复或倒序帧不能刷新时间；积压超过预算、过期、格式错误、来源改变均锁存停用。该通道只适用于**同一主机**的两个进程，使用同一单调时钟，不能直接延伸到 PC→PYNQ 网络。

暂停、停止、测试回放、切换游戏/视觉来源或卸载 hook 都撤销当前会话；恢复游戏不会自动使能手。接入方仍须创建并显式 arm 独立 Controller，绑定来源后才可创建 GestureConsumer，通道停止时调用 consumer.stop 并确认 Controller 的最终卸力状态。本模块没有自动安装、服务启动、真实手入口或隐式 arm。

## 验证

- `build/bridge-20261024/b01-regression.json`：168项离线测试通过、117冻结文件通过、Python3.10 AST 通过、真实串口打开0。新增8项覆盖单槽竞争、暂停丢包、重复帧、身份变化、格式/未来时间/超量队列、回放隔离和 hook 恢复。
- `b02-frozen-game.json`：使用哈希核过的 R21 marker-r02 实际 `PackagedGameRuntime` 和 `GameVisionInputProvider`，一次取样→hook→数据报协议内存替身→接收器→GestureConsumer→真实冻结 SDK 内存后端，paper/rock/scissors 与暂停卸力通过。返回对象身份不变，provider调用数等于样本数；正常播放全是位置写包，无寄存器READ。该项不是物理机械模拟。
- `b05-processes-host.json`：两个真实独立 PC 进程经私有127.0.0.1数据报通道传三类合成手势；暂停撤销与源停止后的过期停用通过。此项未构造 actuator，没有电机操作，不是 ARM 性能或实物证据。
- b03 首次尝试在沙箱内传递socket句柄，Windows named-pipe资源共享失败，原源码另存。改为两进程各自创建socket后，b04沙箱回环传输仍超时；相同实现经宿主执行的b05通过。b03/b04 保留为环境诊断记录，双进程协议结论由 b05 的完整结果支持。

## 复验命令

在仓库根目录运行：

```powershell
subprojects/pynq_usb_hand/.venv/Scripts/python.exe -I -B subprojects/pynq_usb_hand/tools/verify_bound_bridge.py --candidate deliveries/c6i-pl-vision-volume-osd-r21-marker-r02-20261023 --output subprojects/pynq_usb_hand/build/bridge-recheck/frozen.json
subprojects/pynq_usb_hand/.venv/Scripts/python.exe -I -B subprojects/pynq_usb_hand/tools/verify_bridge_processes.py --output subprojects/pynq_usb_hand/build/bridge-recheck/processes.json
```

预期输出为 JSON/日志、FROZEN_GAME_HAND_BRIDGE_PASS 和 TWO_PROCESS_PASSIVE_BRIDGE_PASS。输出路径须为新文件。第二条只需允许本机回环，不访问外网或板卡。

下一步先恢复板卡并定位 R21 完整启动失联，完成整机门禁；再在独立候选目录复跑 ARM 回归/双进程验证，安装明确身份绑定的观察器并做无动作影子测试。真实阶段等待、轨迹、持力温升、拔线和卸力确认仍需现场实物验收。该阶段结果用于后续整机集成验证。
