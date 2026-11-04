# PC 实时手势可用基线 · 2026-10-07

本目录交付板端 v7 源码及原始 ZIP；配套 PC Studio 修补已进入本仓库 `python/` 主线。
不需要复制另一套 PC 工程。旧硬件、视觉/声音交接包保留不动。

## 已确认与边界

- PYNQ-Z2 / BUILD_ID 0xC0060800 / v7 performance 负责采集、识别。
- PC Studio 负责游戏运行及画面，输入模式实时视觉，不使用选中的测试回放。
- 游戏二三种猜拳手势、游戏三选角/移动/跳跃已由用户现场确认正常。
- 本轮未重新验收 PC 游戏一；没有量化提速、完整延迟、长稳态结论。
- 游戏三音频未接入，板端 HDMI `video sink is poisoned` 未解决。
- 以[当前版本报告](../../docs/bringup/2026-10-07_selected_pc_gesture_baseline.md)为当前操作依据。
  `runtime/README.md` 保留了最初板端候选操作说明，PYNQ 游戏运行部分是历史流程，不是当前推荐路径。

## PC 准备与使用

在仓库根目录打开终端，Python 3.10+：

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -e ".[studio,vision]"
```

安装后 Windows 双击根目录 `启动Studio.bat`。
默认板卡 192.168.2.99、PC 直连网卡 192.168.2.1；地址不同请通过配置/启动参数调整。
不要提交密码、令牌或 `.venv`。

1. 保持板端 v7 服务运行，Studio 连接 Agent，在 Vision 启动视觉识别。
2. Game 选择游戏二/三，执行目标 PC、实时视觉，点击 PC 试玩。
3. 用“停止 PC 试玩”退出 PC 会话再换游戏，板端视觉保持运行。
4. 图像回传可按需开启，游戏结果读取不依赖图像是否显示。

## 板端包与依赖

[camera_control_games_v7.zip](camera_control_games_v7.zip) 与用户现场使用包字节一致：

```text
SHA256 9EBBC82A879C42AEA1E32D21CF209D7506528320CFFF85044C843EDD386A5929
```

`runtime/` 是同包展开的 Python 启动器、适配器、测试和许可证，方便浏览。
ZIP 不包含冻结 r8 硬件/依赖，它依赖已部署的 r8。
完整 r8 入口仍见[融合交接](../vision_fusion_20261006/README.md)。

板端已经运行时，不要重复启动或重解压。首次接续且尚未部署 v7 时，上传 ZIP 到
`/home/xilinx/jupyter_notebooks`，在已有正确 r8 部署的板上先执行：

```sh
cd /home/xilinx/jupyter_notebooks &&
unzip -n camera_control_games_v7.zip -d camera_control_games_v7 &&
/usr/local/share/pynq-venv/bin/python -B \
/home/xilinx/jupyter_notebooks/camera_control_games_v7/start_games_board_test.py \
--mode performance --check-only
```

应输出 PREFLIGHT_PASS；这不加载硬件，也不等于板端游戏验收。
确认没有其他 Agent/Overlay owner 服务并完成原服务正常清理后启动：

```sh
/usr/local/share/pynq-venv/bin/python -B -u \
/home/xilinx/jupyter_notebooks/camera_control_games_v7/start_games_board_test.py \
--mode performance
```

预期监听 192.168.2.99:8765。不要强杀、自动重载或同时运行多个 owner。
此流程不产生新 bit/HWH；PC 点击试玩生成 `games/.build/*-pc-<uuid>.vvg`，
不覆盖旧包。这些临时游戏包、缓存和环境不纳入 Git。

## 验证

在仓库根目录（PowerShell）：

```powershell
.\.venv\Scripts\python.exe -m pip install pytest
$env:PYTHONPATH='python'
$env:QT_QPA_PLATFORM='offscreen'
.\.venv\Scripts\python.exe -m pytest tests/test_pc_vision_bridge.py tests/test_studio_game_worker.py tests/test_studio_game_workspace.py tests/test_vision_receiver.py tests/test_studio_single_stage.py tests/test_studio_ui.py tests/test_studio_game_replay.py -q
```

当前基线 121 项通过。包含 HTTP 结果到真实 PC 游戏进程、输入保护、独立游戏包、
PC 停止/解锁项目列表；与用户现场验证分别记录，不替代未完成项。

### 原始 v7 附带测试

这些冻结测试使用原始相对目录布局，不能直接在本交接目录运行。
首次直接运行得到 52 项通过、11 项失败（缺少原布局的游戏/r8 测试夹具）。
还原布局后 63 项全部通过；运行中生成的游戏 `__pycache__` 会被包构建器拒绝，
因此请使用干净游戏源码，并禁止测试写入字节码。此次仅清理了上传副本内的生成缓存，未改动原始包。

在仓库根目录准备本地夹具（只需一次，目录已被 Git 忽略）：

```powershell
New-Item -ItemType Directory -Path local_reproduction/control_games_v7,local_reproduction/r8_deployment -Force | Out-Null
Copy-Item -Path handoffs/pc_gesture_baseline_20261007/runtime/* -Destination local_reproduction/control_games_v7 -Recurse
Expand-Archive -LiteralPath handoffs/vision_fusion_20261006/deployment/c6i-vision-board-test-boarddeps-r8-20261006.zip -DestinationPath local_reproduction/r8_deployment
$env:PYTHONPATH='python'
$env:PYTHONDONTWRITEBYTECODE='1'
.\.venv\Scripts\python.exe -B -m pytest local_reproduction/control_games_v7 -q
```

预期 63 passed。这是主机侧逻辑/夹具测试，不是新增板端硬件验收。
