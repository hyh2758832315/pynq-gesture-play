# R30 回传空闲唤醒优化

> 后续R31补齐上层异常清理，149项离线、ARM软件故障及从活动Game1直接正常退出通过，板卡已释放，见[R31记录](2026-10-26_r31_upper_cleanup.md)。本文保留R30独立版本及空闲计数原始证据。

项目事实记录：`docs/bringup/2026-10-26_r30_preview_idle.md`，Voice View，2026-10-26，PYNQ-Z2/xc7z020clg400-1，Vivado2026.1。使用已加载的xilinx-suite（pynq_render_agent/board_bringup_record_template）及voice-view-game-design合同，Skill根 `C:/Users/developer/.agents/skills/`。本轮保持R23b2/BUILD_ID `0xC0061000`，不改Overlay、ABI、识别算法、手侧源码或时效门槛。

## 问题与针对性修复

- 原codec即使无新快照仍每100ms扫描两slot；relay每10ms检查结果管道，Async备用编码线程也每100ms醒来。新测试先得到2FAIL/1PASS（`build/r30-idle-red.xml`）及Async单项FAIL（`build/r30-async-red.xml`），确认是实际周期等待路径。
- codec改为进程Event无限等待；新快照与stop显式唤醒，Event合并忙碌期间通知，避免计数信号量累积过期token。先清通知再读受锁保护slot；只有可选codec会等待slot，识别写端仍try-lock，不等待可选编码。
- relay等待结果管道、单token任务通知管道和codec退出sentinel，新任务/结果/进程退出即唤醒。仅保留1秒本地端点异常检查，不扫快照、不调用demand；不新增线程/子进程。
- deferred通知在已有锁内合并，最多一个未读小token；关闭显式唤醒，线程退出后才关闭新增端点。slot仍2个、pending仍latest-only，debug/video的codec_busy及手回传OFF门禁保持。
- Async备用路径也改为无超时Event等待，submit/close已有显式通知。

## 离线验证与候选

- 当前合并回归 `build/r30-combined-r01.xml`：164PASS/8deselected/4subtests PASS，17.32秒，涵盖真实spawn、重连、首次deferred唤醒、slot暂时争用后无需下一帧也交付、共享内存所有权、错误/强制结束/保留重试及HTTP与手回传互斥。
- 完整根预览套件新源码121PASS/7FAIL，未修改R19对照同样121PASS/7FAIL；原件 `build/r30-preview-suite.xml` / `build/r30-preview-baseline.xml`。失败都是混合根board脚本与隔离包导致spawn导入旧 `_process_preview_loop` 不接受 `codec_busy`。未修改产品合同换绿；合并回归排除相关8个参数化用例（7个既有失败与1个同组startup负例）。当前隔离运行时另有真实spawn/重连覆盖。
- `build/r30-preview-current.xml`30PASS/4subtests含4个重复收集项，不能与后续164项叠加报总数；最终以去重合并回归为准。
- 独立候选 `build/ps-ui-r30-preview-idle-20261026-board-candidate-r20`：448个manifest文件/28项源码delta/3游戏1默认视频；manifest SHA `6F8DF0D66D816E25187F8A058A175E3B85BDF471417C012979CCFFDECBED8034`。
- 相对R19只改变 `python/pynq_multimodal_game/vision_preview.py` 及candidate_delta；PC原生check-only和Python3.10语法PASS。硬件/游戏包/手源保持字节一致。

构建与预检：

```powershell
.venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/build_deployment_candidate.py --output build/ps-ui-r30-preview-idle-20261026-board-candidate-r20
.venv/Scripts/python.exe -B build/ps-ui-r30-preview-idle-20261026-board-candidate-r20/start_board_test.py --check-only
```

板端核同boot `9ca66e06-4fb7-4054-ad02-a227684c8274` 且无项目owner后，独立上传R20。压缩包40,505,661 B，PC/板SHA `CC0B1813DBEF58E9199DF12A9FBEB1FBFB0C518879A4BF3127C098E165E2FDEF`；真实PYNQ Python原生check-only PASS。没有改系统时间或旧目录。

## ARM无硬件对照

辅助脚本 `build/verify_r30_arm_idle.py` 只创建自己的编码进程/relay，固定4秒、前后各一次读取这些自有任务的/proc计数，不扫描其他程序、不读取硬件、不与真人/舵机测试并行。相同PYNQ Python、相同脚本，分别以各包manifest核身份。

| 版本 | 实际空闲窗口 | codec主动切换增量 | relay主动切换增量 | codec/relay CPU tick增量 |
|---|---:|---:|---:|---:|
| 未改R19 | 4.0078s | 40 | 391 | 0 / 9 |
| R20 | 4.0074s | 0 | 4 | 0 / 0 |

两轮都在同一codec PID内依次断开/开启并收到frame1/2/3，随后cleanup=CLEAN，result=PASS。说明该组件空闲周期唤醒显著减少；CPU tick有采样粒度，不称实际CPU绝对为零，也不推导整机百分比。原件已回收 `build/r30-arm-idle-r19.json`、`build/r30-arm-idle-r20.json`。

## 真实回传与最终退出

R20原生无动作入口正常启动，相机0x5640检查PASS、监听正常，原素材库从R19保留复制。脚本 `build/verify_r30_http.py` 在菜单、game1/2/3、SUNSET中各做两次真实MJPEG连接/关闭/重连，每次限定3张JPEG后关闭。结果 **PASS**，原件 `build/r30-board-http.json`：10条流/30张640×360 JPEG正常解码、9条常规模式控制全部无错；全过程同codec PID2408、同真实视觉run `3361524b15e24e7fa8411bd5e49fe627`，各次关闭后health仍RUNNING。无手会话、无输入注入，未在此测试期间运行计数脚本或额外探针。

最终正常SIGINT退出PASS，原件 `build/r20-final-for-r30.json`：唯一主PID2397退出，原前台SSH会话exit0；视觉6000帧、error/diagnostic_error均null、cleanup_confirmed=true。仍使用既有 `CAPTURE_PACKET_DMA_STOP_MODE=reset-after-halt-timeout`，回执仅声明软件生命周期，不替代独立硬件签核。退出后一次进程检查无应用、手owner、验证脚本或multiprocessing.spawn/resource_tracker残留。板卡已释放。

关键命令/输出：

```powershell
# 板上无硬件组件对照，ROOT/REPORT/SHA分别绑定R19与R20：
ssh -b 192.168.2.1 pynq-z2 '/usr/local/share/pynq-venv/bin/python -B /home/xilinx/voice-view-game/verify_r30_arm_idle.py /home/xilinx/voice-view-game/ps-ui-r30-preview-idle-20261026-board-candidate-r20 /home/xilinx/voice-view-game/r30-arm-idle-r20.json 6F8DF0D66D816E25187F8A058A175E3B85BDF471417C012979CCFFDECBED8034'
# 原生入口无手参数启动后，真实回传验证：
.venv/Scripts/python.exe -B build/verify_r30_http.py
# 正常停止并保存最终回执：
ssh -b 192.168.2.1 pynq-z2 'sudo -n /usr/bin/python3 /home/xilinx/voice-view-game/finish_r20_for_r30.py'
```

本轮结论：**OFFLINE_PASS / ARM_COMPONENT_PASS / BOARD_HTTP_RECONNECT_PASS / NORMAL_CLEANUP_PASS**。这不包含R20实体手联合、长OFF后恢复、长稳态或游戏1/3人物间歇不响应根因闭环。转发线程仍有1秒本地故障检查；编码进程保持已初始化并睡眠以便低延迟重连，未实现按需销毁进程/RAM。上层视觉/OSD关闭故障矩阵和真人联合验收仍待推进，整体目标保持active、release_ready=false。
