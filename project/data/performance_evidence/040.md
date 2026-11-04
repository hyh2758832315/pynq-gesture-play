# 灵巧手串口控制生命周期：离线接入（2026-10-25）

本轮是 PC 离线实现与验证，未 SSH/SCP、未打开物理串口、未加载 Overlay 或使能舵机。目标为 PYNQ-Z2、`xc7z020clg400-1`、Vivado 2026.1，沿用 `0xC0061000` Overlay。真实板端仍以 [R24 三轮实板记录](2026-10-25_r24_board_validation.md)为准；其中的灵巧手设备错误位 1 尚未获得现场排除证据。

## 接入变化

此前 PS 候选只能执行只读检查、被动观察或内存动作；真实串口 owner 尚未接通。本轮新增：

- 手侧 `actuator_owner.py`：只有拿到新鲜、有效、绑定 run/config 的来源后才创建唯一 Controller；连接、使能期间也持续检查来源。只使能一次；动作完成后处理最新帧；三种已识别手势以外的有效新帧请求 default。过期、撤销和来源切换走取消/卸力/关闭，不伪装成 default。
- 候选 `hand_child/serial_motion_receiver.py`：独立解释器下运行，核对唯一串口、设备占用、源文件 SHA 和冻结 ORCA/资产；保持 speed500、温度上限40°C、完整扫描预算2秒、5秒控制租约。通过连接与使能检查后才写 `active.json`。动作阶段沿用固定播放，无位置闭环；`played` 不能解释为机械到位。
- PS `hand_serial_session.py`：独立低频线程以本机 UDP 发布最新分类，渲染与游戏不等待舵机；退出撤销来源并等待子进程、完整 OFF 回执。串口子进程超时不执行 terminate/kill，仍存活或缺失有效回执就保留故障，不宣称释放。
- `--hand-serial-actions` 是新的显式候选模式，必须配齐三个只读手侧参数和 `--hand-stage-waits DEFAULT MIDPOINT TARGET`；与 shadow/mock 互斥。默认仍不开启实际动作。当前入口限制为30秒验证会话，尚不是持续运行版本。

阶段等待时间没有给出生产默认值。测试中的 `.001` 和预检中的 `0.1 0.2 0.3` 都是离线/语法检查参数，不能用于声称真实手已经完成每个动作。真实固定播放仍需现场确认各阶段机械跟随及持力温升。

## 证据

| 检查 | 结果与范围 |
|---|---|
| 手侧完整离线回归 | [serial-owner-offline-20261025.json](../../subprojects/pynq_usb_hand/build/serial-owner-offline-20261025.json)及同名 `.log`：180项，0失败/错误，117个冻结文件未改，禁止真实串口/网络连接；硬件未测试 |
| 新 owner 的9项回归 | 包含三手势→default、无来源不创建后端、连接/使能时撤销、运动中停止、17颗真实SDK内存包与OFF回读、温压/残留使能故障、单颗OFF回读故障 |
| PS/子进程入口集成 | [serial-owner-integration-20261025.log](../../build/serial-owner-integration-20261025.log)：3项通过。实际本机UDP、生产入口和owner、冻结SDK及生产串口编解码；进程启动替换为线程、OS设备检查替换为测试桩、串口替换为内存设备，不是物理测试 |
| PS现有候选回归 | `test_candidate.py`、`test_hand_shadow_bridge.py`、`test_hand_latest_integration.py`：30项通过；包含参数互斥、缺参、NaN/零/超限等待拒绝与已有mock/shadow行为 |
| 新候选预检 | 普通 `--check-only` 与带完整串口参数的 `--check-only` 均返回 `C6I_VISION_BUTTON_BOARD_TEST_PREFLIGHT_PASS`；未访问硬件 |

完整串口清理验证独立于子进程是否成功进入 ACTIVE：若已尝试使能，必须有 `backend_closed=true`、Controller `CLOSED/error=null`、最后一次release无失败ID/异常，以及完整1至17号确认列表。某颗回读失败即 `RELEASE_UNKNOWN`。记录保持 `mechanical_verified=false`、`release_ready=false`。

## 当前离线候选

[部署清单](../../build/ps-ui-r24-serial-owner-v3-20261025-offline-package/deployment_manifest.json) SHA-256 为 `2D02C32C708C7AE8C6E6DABBF1A65B0E717E39027234A56D2D519BF70DC77D13`，445个文件；`board_pending=true / release_ready=false`。串口源文件清单 SHA 为 `67EAC50E5E668D9B39D490456974749302A0EF497DE6AA7443A9A5F662270E8D`。v1、v2是本轮中间产物，不用于上板。已实板验证的DMA退出修复仍包含在新候选里，但不能把上一版三轮结果当作本版完整验收。

从项目根目录复核：

```powershell
subprojects/pynq_usb_hand/.venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/test_hand_serial_session.py -v
subprojects/pynq_usb_hand/.venv/Scripts/python.exe -B subprojects/pynq_usb_hand/tools/verify_offline.py --output subprojects/pynq_usb_hand/build/serial-owner-offline-20261025-recheck.json
```

构建/预检从项目根目录运行：

```powershell
.venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/build_deployment_candidate.py --output build/ps-ui-r24-serial-owner-recheck
.venv/Scripts/python.exe -B build/ps-ui-r24-serial-owner-v3-20261025-offline-package/start_board_test.py --check-only
.venv/Scripts/python.exe -B build/ps-ui-r24-serial-owner-v3-20261025-offline-package/start_board_test.py --check-only --hand-readonly-root subprojects/pynq_usb_hand --hand-readonly-python subprojects/pynq_usb_hand/.venv/Scripts/python.exe --hand-readonly-port /dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00 --hand-serial-actions --hand-stage-waits 0.1 0.2 0.3
```

构建输出是新目录中的445文件及清单，验证输出是指定JSON和同名日志。下一步先在现场排除手部供电/接线错误并重复只读检查，再用独立候选分阶段验证真实固定播放与退出OFF；尚未执行这些步骤。PS实屏返回键、实际2秒停留、手势到机械动作时延与持续运行也仍待验证。
