# 工程观察与验证摘录

# PYNQ-Z2 R20 实板与 Studio 回传

文档类型：项目级上板事实记录。路径：`docs/bringup/2026-10-23_pynq-z2_r20_board_test.md`。
项目 Voice View Game；PYNQ-Z2 / xc7z020clg400-1；Vivado 2026.1；日期 2026-10-23。
关联 Skill 源：`xilinx-skill/plugins/xilinx-suite/references/board_bringup_record_template.md`、`pynq_render_agent.md`；部署副本：`~/.agents/skills/xilinx-suite/references/`。

## 产物及执行入口

- R20 r03 ZIP：47,330,834 bytes，SHA256 `d64e5e7a553f13ef7db04305ea9df902def279b35dbe06c4f7a4427b695cb6d4`。
- bit SHA256 `ddab12d94487c01b4b526ed1e73e3bf12efe42301bcce1c0da543e60d6709106`，BUILD0xC0060E00；644 项 manifest。250 个运行时文件与 R19 相同。
- WNS +0.002ns / WHS +0.049ns；离线签核与270测试见 R20 preparation。真实帧率、CPU、停采恢复、GPU 共存与物理延迟仍待验。
- 命令：`.venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/deploy_latency_admission.py ACTION`，依次 stage、arm、base、start、ready。输出独占 r20-bNN JSON 原始证据及板端 `var/pl-admission-r20-b01` 日志。
- 新目录部署，不覆写旧包；每次正常 base STOP/加载前使用既有 boot、锁、DMA/metadata 身份门禁。禁止强杀、清锁或盲目重载。

当前结果：PARTIAL / R20_FIRST_BOARD_PARTIAL_PERFORMANCE_LIMIT。上板、原生Studio回传、各模式OSD及8例GPU对照通过；回传负载下识别下降、真实满槽长暂停/恢复、最终sealed STOP与物理延迟仍待验，不将启动或离线结果当作全部加速验收。

## B02/B03 独立部署与 ARM 校验

`r20-b02-stage-create/upload/restore.json` 全部返回0，解包644项SHA一致；无硬件加载。`r20-b03-arm-preflight.json` 完整manifest/AST、正常及禁音量采样 check-only 均通过；`r20-b03-arm-cpu-contract.json` 两套15项纯CPU合同通过，未映射硬件。使用板端既有 `/usr/local/share/pynq-venv/bin/python`，未安装/升级依赖或修改灵巧手目录。

## B04 base 正常停止门禁

`r20-b04-hand-free.json` 实时确认无 board_buttons/pynq_usb_hand 进程、无 ttyUSB/ttyACM 持有；`r20-b04-base-normal-stop.json` 返回0，同boot、官方base bit/HWH/metadata身份、三服务、两锁及硬件映射门禁通过。video VDMA已halt，两个trace S2MM经普通run位清除并读回halt；保存板端base-stop.json，没有reset/强杀/删锁或重启。

## B05–B09 R20 首次加载与持续帧

`r20-b08-first-frame` 实际STATUS为RUNNING/frame741；`r20-b09-menu-observe` 10.18秒/33样本通过，默认菜单下视觉18.268fps、OSD24.947Hz、OSD单核2.202%、音量49.698Hz，audio_valid_fraction=1，last_error=null，capture持续推进（末1611捕获/1433交付、pending1、replaced177）。尚不能据此宣称端到端物理延迟或严格同工况加速比。

## Studio 入口及初次超时

### r02 实际回传通过

r02可见Qt窗口实PID97780，10/20/30/40秒相机计数25/52/78/102，Agent READY、Camera connected；原生Qt截图 `build/hosd/c0e/r20-studio-r02/studio-020.png` 确认真正的640x360相机画面。相机JPEG约2–3fps，不等同于识别帧率；截图中结果年龄也不是物理输入到HDMI延迟。r01超时窗口保留，未强制结束其他窗口。

`r20-b10-studio-observe` 在HTTP回传订阅期间10秒持续检查通过，OSD23.59Hz、单核2.093%，严格2.5%门槛通过。板端R20和r02 Studio保持运行，真实物理HDMI验收与端到端延迟仍独立待验。

### 性能限制：回传开启时识别下降

B10同时测得识别仅4.777fps（B09无JPEG订阅为18.268fps），手结果发布年龄中位262.7ms/p95 364.5ms，不能把OSD寄存器23.59Hz写入速度当成新识别结果速率。两窗口Agent观察与HTTP诊断增加了系统负载；具体归因尚需剖析，不能直接断言GPU冲突或JPEG单因果。整体实时性能保持PARTIAL，不放宽门槛或修改R20包。

B12只读47个不同帧：PL颜色mask阶段0ms、形态学中位0.008ms，ARM轮廓中位21.08ms/p95 83.99ms，输入准备中位19.84ms/p95 39.57ms；这些分位不能相加推算端到端延迟。B14同boot/start_ticks只读2.09秒：Agent120.67%单核/RSS134032KB/92线程，编码子进程1754约14.84%、另一子进程1866约14.84%，两子进程仍运行，服务stderr空/未退出。不是长期CPU或同工况因果对照。

源码核查发现明确的待验证耦合：冻结 `board/pynq_z2/vision_latest_capture.py:136/154` 在preview demand为真时，识别消费者拒收无RGB的最新mask、等待带同token RGB的帧；`vision_async_runtime.py:519` 同一识别线程在发布控制后仍同步进行diagnostic RGB准备（约1350–1393行）。因此“仅下沉mask算法”并不保证回传不拖慢下一次识别；GPU并非此条件的参与者。此处是代码路径事实和性能归因线索，尚未以单变量实验量化影响。后续应独立候选验证mask消费者不等待预览、诊断单槽按同源身份允许丢弃，同时保留CRC/owner/STOP；当前R20冻结包及板端运行时没有修改。

## B11 游戏/视频及暂停共存

## B13 八用例 GPU 逐 tick 对照完成

## B16 最终状态与交接

`r20-b16-final-menu-observe.json` 回放后默认菜单10秒复验PASS：OSD25.11Hz、单核2.254%，继续通过2.5%门槛。视觉RUNNING、last_error=null、OSD enabled/thread_alive、test_active=false，音量与真实采集继续推进。当前R20服务保持运行，未做VISION_STOP或Overlay卸载，不把游戏/视频STOP算成视觉sealed STOP。

B16识别实测回升为21.183fps，末识别frame10767/捕获14886，因此B10的4.777fps不是已证明的持续现象，后续须结合场景/订阅/游戏负载做单变量隔离，不宣称回传必然固定掉速。最终订阅只读探针第一次在本地PowerShell命令解析处失败（Missing type name after '['），未发起SSH；改用已有脚本文件参数入口，避免嵌套引号。

新增 `probe_preview_subscription.py`，命令 `.venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/probe_preview_subscription.py`，输出独占 `integration/evidence/r20-b18-preview-subscriptions.json`。只读核本boot/Agent start_ticks，三次ss -tinp及编码CPU，前后各一次/result.json；不请求camera.mjpg/debug.jpg、不操作Studio、不启停服务或访问MMIO。

冻结源码停止语义：workspaces.py stop_camera将camera/debug/result三个HTTP worker置stop，CameraPreviewWorker在读帧循环退出/异常后finally关闭response/connection；不发送VISION_STOP。板端MJPEG handler在连接写失败/退出后video_clients减一，demand在无视频客户端且debug请求超过3秒后为空，encoder不提交新任务，但HTTP监听与编码子进程可继续驻留。正常停止可能有当前读帧/发送/已提交编码任务的收尾，不能仅靠进程存在判定未停止。右上角断开PYNQ只断主Agent连接，切换工作区也未调用stop_camera，不等价于关闭相机HTTP。
