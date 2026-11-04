# C6I 视觉融合统一上板

本文档是已完成离线集成的板端验收操作合同。BUILD_ID=0xC0060800，Game SDK 1.1，GPU ABI 1.0；声音live关闭、握拳候选默认关闭。相机直连、初始化及PCLK沿用队友冻结代码。部署包保持release_ready=false/board_pending=true，显式--vision-board-test仅允许验收候选启动，默认正式门禁保持。

## 已接线链路

### 2026-10-08 三游戏选择性接入

新候选通过 `start_board_test.py --game-controls` 显式选择原生进程内 `GameVisionInputProvider`；旧启动参数继续使用默认水平控制、握拳关闭。worker 将同帧 stable/RPS 与 control 一起发布，运行时从已验证 VVG manifest 取得 game_id。相机判断直接供板端游戏采样；HTTP 与 PC Studio 仅提供诊断、监控、部署和生命周期控制。

| 游戏 | 映射 | 验收重点 |
| --- | --- | --- |
| game1 | 四向移动、张手到握拳一次跳跃 | 新帧失效释放、动作仅消费一次 |
| game2 | 同帧稳定 0/ROCK、2/SCISSORS、5/PAPER | 中心 IDLE 可出拳；未知/失效释放；方向与跳跃不进入猜拳 |
| game3 | 左右选角/移动、张手到握拳确认/跳跃 | 确认选角不同时起跳；上下不改变平台角色 |

三游戏使用同一冻结 BUILD_ID，声音 live 仍关闭。队友 performance、单阶段预览和准入时钟保留在来源归档，本轮原生候选保持 validation 路径；性能结论需独立实测。本轮同步及现场阻塞见 [选择性同步记录](bringup/2026-10-08_selective_board_vision.md)。

- OV5640 -> PL采集/肤色前端 -> PS视觉worker -> 本地VisionInputProvider -> 游戏tick；控制先于诊断发布。
- 游戏Scene -> GPU命令DMA -> render/present -> 唯一HDMI后端；共享唯一Overlay、flock和受限视觉borrower。
- Studio经Agent TCP 8765获取身份、生命周期、游戏状态及实际消费/Scene/sink完成回执；HTTP 8081提供相机、判断及处理图。回传为诊断与状态，GPU返回测试pattern不作为HDMI像素回传。
- Studio部署先做PC预检、安装并LIBRARY_LIST回读同包身份；live启动等待VISION_START=RUNNING后才运行游戏。live请求无test_case_json，PC黄金回放与live隔离。

### Studio 配套版本门禁

三游戏 live 需要本轮匹配版本的 Studio 与 Agent。Studio 先发只读 `VISION_STATUS`，严格核对融合身份以及 `vision.input_capabilities`：`schema=local-game-vision-v1`、`mode=games`、`games` 包含已验证 manifest.game_id。能力缺失、旧水平模式及不支持游戏在 `VISION_START` 前拒绝；启动故障保留显式停止/清理流程。使用 `--game-controls` 启动配套候选或原生 CLI 的 `--vision-game-input`，软件门禁通过仍保持现场验收身份。

Game 页显示同一已完成 Scene 的源分类/方向、run/epoch/frame、输入年龄、采样/Scene tick、动作和 SHA。确认显示要求同一非负整数 tick 及有效 Scene SHA；失效输入与 Scene 提交完成分别展示。Studio 新连接通过消费快照恢复 live 输入隔离；断线及查询失败保留历史标记，重连后等待新回执。原生两尺寸验收与真实 localhost 三游戏装载证据见 [本轮记录](bringup/2026-10-08_selective_board_vision.md)。

## 离线打包

```powershell
& './.venv/Scripts/python.exe' -B './board/pynq_z2/scripts/prepare_c6i_vision_board_test.py' --candidate-dir 'E:/vvgvi/20261005/output/offline_complete' --game './artifacts/studio/20261006_fusion/game1-C0060800.vvg' --test-case './games/game1/tests/replays/c1-golden.json' --output './deliveries/c6i-vision-board-test-ready-20261006'
```

打包器核验真实候选14件、官方XSA内外配对、冻结133文件，重跑同包带断言PC黄金用例，检查Python3.10语法，并从导出目录运行真实Agent check-only后才创建ZIP。目录/ZIP已存在则拒绝覆盖。

三游戏候选可重复使用 `--additional-game <VVG> <TEST_CASE>` 添加 game2、game3。每份游戏均须通过带断言的同包黄金用例，目标为 `0xC0060800` 且 game_id 唯一；部署清单分别记录 `games_sha256`。导出时执行默认与 `--game-controls` 两种 check-only。

## 接板后

1. 核对直连物理链路、192.168.2.1源绑定、ARP和192.168.2.99 SSH身份，再传ZIP至独立目录并核对归档SHA。解压保留完整目录布局；不覆盖现有业务目录或修改系统Python。
2. 用已确认的PID/服务停止旧相机及GPU所有者，等待原worker退出/DMA halt/锁释放；不以kill -9或直接重载代替清理。保留旧冻结制品作为回退。
3. 在解压目录执行只读预检：

```bash
/usr/local/share/pynq-venv/bin/python -B start_board_test.py --check-only
```

新三游戏候选另执行 `start_board_test.py --check-only --game-controls`。若 SSH 身份、唯一 owner 或旧 PYNQ 全局状态路径未核实，停留在只读预检阶段；先保留现场和回退身份，再按确认的原停机流程处理。`--repair-state` 属于旧交接显式修复入口，本轮不自动执行。

4. 使用原PYNQ Python3.10启动验收Agent，先记录numpy/OpenCV/PYNQ/XRT及依赖，不升级冻结环境：

```bash
sudo -n /usr/local/share/pynq-venv/bin/python -B start_board_test.py
```

三游戏控制候选启动命令增加 `--game-controls`，然后通过 Studio 安装包内同 SHA 的三游戏 VVG，并以 live 模式逐一运行。默认启动命令继续保留旧行为。

启动器校验全部部署SHA，检查旧camera owner，固定统一锁，显式设置stage PYTHONPATH和XILINX_XRT。绑定192.168.2.99、8765及8081；不同已有板端地址通过VVG_BOARD_HOST显式设置。首次启动保持前台、保存日志，不先安装开机自启服务。缺依赖/启动失败记录原文并保留现场；板端环境验证属于实板门禁。

5. PC启动现有Studio，在PYNQ设置选择C6I_VISION/0xC0060800，Agent为192.168.2.99:8765，Vision为http://192.168.2.99:8081；使用同一个game1-C0060800.vvg。选择live，确认视觉RUNNING、包SHA回读和游戏tick推进。
6. 实屏观察左右手势改变角色位置，丢手/迟帧释放；同时保存run/frame -> tick -> Scene seq -> present完成的STATUS。Studio断连后板端控制继续，重新连接恢复新鲜状态，不补播旧动作。
7. 验收至少10次启停/恢复、10分钟真实手势与PC断线、1小时稳态，记录帧率/间隔、游戏jitter、错误、CPU/RSS/DDR负载和停机双路DMA状态。HTTP图像与局部PASS保持诊断身份；现场HDMI与硬件回执共同签收后再单独生成正式发布身份。

## 停机

先通过Studio返回菜单并VISION_STOP，确认worker退出、采集与算法DMA halt及借用释放。然后在Agent前台Ctrl+C；关闭失败保持owner/FAULT、显式retry，避免自动重新加载。确认监听器退出及统一锁释放后才恢复旧Overlay。