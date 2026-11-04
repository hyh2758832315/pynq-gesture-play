# PYNQ-Z2 C0 最小 Overlay

C0 使用 PYNQ v3.1 官方 Pynq-Z2 Base Overlay 的 PS7 DDR/MIO 参数，构建以下最小数据通路：

```text
PS7 M_AXI_GP0 -> SmartConnect -> AXI GPIO <- 0xC0010001
```

AXI GPIO 地址为 `0x41200000`，数据寄存器偏移为 `0x0`。

## 构建

在仓库根目录运行：

```powershell
.\board\pynq_z2\scripts\build_c0.ps1
```

首次运行会从固定提交 `19ed17d4fd4ea71f95a97d30f8ccd0d62b8dbaaa` 下载 PYNQ v3.1 的 `base.tcl`，校验 SHA-256 后提取 PS7 配置。生成文件位于：

```text
board/pynq_z2/output/c0_overlay.bit
board/pynq_z2/output/c0_overlay.hwh
board/pynq_z2/output/c0_overlay.xsa
board/pynq_z2/output/build_manifest.txt
board/pynq_z2/output/reports/
```

## 板端验证

将 `c0_overlay.bit`、`c0_overlay.hwh` 和 `verify_c0.py` 放在 PYNQ-Z2 的同一目录，然后运行：

```bash
sudo env XILINX_XRT=/usr \
	/usr/local/share/pynq-venv/bin/python \
	./verify_c0.py ./c0_overlay.bit
```

脚本连续加载 Overlay 10 次，每次读取 BUILD_ID。通过标志为：

```text
C0_VERIFY_STATUS=PASS (10/10)
```

该验证应在 PYNQ v3.1 启动完成后执行，板卡地址为项目约定的 `192.168.2.99`。PYNQ-Z2 上的 Overlay 下载和 SLCR 映射需要 root 权限。

## SSH 免密登录

本机使用专用密钥 `~/.ssh/pynq_z2_ed25519`，SSH 配置为：

```sshconfig
Host pynq-z2
	HostName 192.168.2.99
	User xilinx
	IdentityFile ~/.ssh/pynq_z2_ed25519
	IdentitiesOnly yes
```

配置后可直接运行：

```powershell
scp .\board\pynq_z2\output\c0_overlay.bit `
	.\board\pynq_z2\output\c0_overlay.hwh `
	.\board\pynq_z2\verify_c0.py pynq-z2:~/

ssh -t pynq-z2 "sudo env XILINX_XRT=/usr /usr/local/share/pynq-venv/bin/python /home/xilinx/verify_c0.py /home/xilinx/c0_overlay.bit"
```

SSH 登录已经免密；本实验板的摄像头阶段已验证 `sudo -n` 可用。其他开发板需先核对各自的 sudo 策略，勿直接沿用本板权限设置。

## OV5640 双 Pmod 直插原型

当前隔离实验包已实现 OV5640 1280x720 镜头帧、独立 HDMI 显示帧与 PC/Studio MJPEG 预览；受监护 690 秒对照中四轮 PC 解码累计 4777 帧，黑帧 0。当前使用 `capture_camera_direct_plug.py --live` 的隔离缓冲路径，不加载旧 Camera v2/v3/v4；针位、板端 bit/HWH 哈希、临时在线服务和算法交接门禁详见 `docs/ov5640_pynq_z2_integration.md`，完整原始记录在 `docs/bringup/2026-10-01_pynq-z2_camera_direct_plug.md`。HDMI 目视、30 分钟门槛与长期 2.8 V 接口适配仍待验收。

### 最后成功的双路软件链路：复现步骤

数据路径：OV5640 DVP -> demosaic -> VDMA S2MM/DDR -> 独立 MM2S 帧提交 HDMI；同一采集帧的 CPU 快照 -> JPEG/MJPEG -> PC 浏览器或 Studio Vision 页。PC 与 HDMI 提交在同一进程内并行，`--live` 默认使用隔离缓冲；不要使用有原生段错误风险的 `--shared-live` 诊断路径。HDMI 输出配置为 1280x720@60，60 Hz 不是已测相机新帧率；隔离版 HDMI 实屏持续动态仍需队友现场目视确认。

板子目前已由用户为控制温度断电。下列步骤仅供完成供电、温度和 2.8 V IO 电平检查后的现场复现，不代表建议长期直插运行。使用用户修正的双 Pmod 针表与板端隔离目录 `/home/xilinx/voice-view-game/camera-corrected-hdmi-prototype/`，确认其中的 bit/HWH SHA-256 分别为 `8380CAC58E89F33528895FAD14EAC3C16A4D072D00591B855BA4D6B91CB86006` / `3F0A264110E0B71FF452D511E86471DD3114B6F634DB98B407C23480872EE94B`。重新上电后先确认 C6I `voice-view-shell.service` 未运行、8088 未被占用；相机实验 Overlay 与游戏 Overlay 不能并发管理 PL。

在 PC PowerShell 中开启单独终端，运行以下已验证的 75 秒限时启动方式，保持终端打开直到监护器退出：

```powershell
ssh pynq-z2 'sudo -n timeout --signal=TERM --kill-after=10s 75s /usr/bin/python3 -u /home/xilinx/voice-view-game/camera-corrected-hdmi-prototype/run_camera_live_guarded.py /home/xilinx/voice-view-game/camera-corrected-hdmi-prototype/capture_camera_direct_plug.py /home/xilinx/voice-view-game/camera-corrected-hdmi-prototype/camera_direct_plug_corrected_hdmi_prototype.bit /home/xilinx/voice-view-game/camera-corrected-hdmi-prototype/camera_replay.ppm --live --bind 192.168.2.99 --port 8088'
```

出现 `CAMERA_IIC_CHIP_ID_STATUS=PASS`、`CAMERA_DIRECT_PLUG_CAPTURE_STATUS=PASS`、`CAMERA_HDMI_COPY_STARTED_AT` 和 `CAMERA_MJPEG_LISTEN_AT` 后，在 HDMI 显示器观察画面是否持续变化；同时在 PC 打开 `http://192.168.2.99:8088/camera.mjpg`，或在 Studio 的 Vision 页连接该 URL。板端 MJPEG 当前是单连接 `HTTPServer`，浏览器与 Studio 只能轮流使用，切换前先关闭前一个客户端。需要保存逐帧到达率、尺寸、黑帧和哈希数据时，可在 PC 运行：

```powershell
.\.venv\Scripts\python.exe board/pynq_z2/scripts/measure_camera_mjpeg.py http://192.168.2.99:8088/camera.mjpg board/pynq_z2/build/camera_replay.csv --seconds 15 --clients 2
```

75 秒超时正常结束的远端退出码为 124；监护器应打印子进程 `-15` 和两路 `CAMERA_VDMA_GUARD_STOP=(69633,69633)`，然后确认 8088 停止监听。如提前出现 `-11`、泵错误、全黑帧、温升异常或 HDMI 异常，停止实验并保存日志，不重复加载旧 bit。本次下电发生在 SSH 停机回读之前，该轮 DMA 末态未被证实；上述 75 秒门禁的正常停机证据属于先前独立试验。已归档的 PC 长测逐帧 CSV 位于 `board/pynq_z2/evidence/camera_isolated_5min_a.csv`、`camera_isolated_5min_b.csv`，短时默认入口数据在 `camera_default_live_15s.csv`；它们证明 PC 回传 1280x720 连续图像，不能代替 HDMI 实屏目视、30 分钟热稳定性或视觉算法验收。

### 已停用：旧 Camera Overlay

Camera v2/v3/v4 是旧杜邦线接法的历史试验，不是当前双 Pmod 直插版本。v4 `BUILD_ID=0xC00A0004` 虽通过芯片 ID 和局部 DVP 观测，实板采集未产生完整真实镜头帧或 PGM，按出图目标判定为失败。以下命令仅保留历史操作记录，当前装配不得执行其 `LoadOnly`、`Xclk`、`ChipId` 或 `Dvp` 阶段，也不得加载旧 bit；原 bit/HWH、哈希和日志保留供复核。

Camera Overlay v2 连接 XCLK、SCCB 和完整 8 位 DVP 输入，BUILD_ID 为 `0xC00A0002`。PCLK、VSYNC、HREF 和 D0-D7 在实现后均固定为 `INPUT / LVCMOS33`，状态寄存器提供同步信号电平和饱和边沿计数。先验证本地产物与脚本：

```powershell
.\board\pynq_z2\scripts\deploy_camera_overlay.ps1 -LocalOnly
```

确认相机供电稳定、无明显发热且杜邦线符合 `docs/ov5640_pynq_z2_integration.md` 后，先执行仅加载门禁：

```powershell
.\board\pynq_z2\scripts\deploy_camera_overlay.ps1 -Phase LoadOnly -ConfirmWiring
```

脚本强制从 `192.168.2.1` 直连，核对 PYNQ 身份、冻结 bit/HWH 哈希和板端四个文件的 SHA-256，并停止、禁用 C6I 服务以取得 PL 独占权。断电接入 XCLK、重新上电并再次完成 `LoadOnly` 后，执行 250 ms 隔离时钟测试：

```powershell
.\board\pynq_z2\scripts\deploy_camera_overlay.ps1 -Phase Xclk -ConfirmWiring
```

XCLK 阶段通过并安全下电后再接入 SCCB，重新执行 `LoadOnly`，然后读取一次 `0x300A/0x300B`：

```powershell
.\board\pynq_z2\scripts\deploy_camera_overlay.ps1 -Phase ChipId -ConfirmWiring -Reads 1
```

一次读取通过后再执行：

```powershell
.\board\pynq_z2\scripts\deploy_camera_overlay.ps1 -Phase ChipId -ConfirmWiring -Reads 100
```

完整 DVP 交叉线接入后，重新执行 `LoadOnly`，再验证三路同步信号出现边沿：

```powershell
.\board\pynq_z2\scripts\deploy_camera_overlay.ps1 -Phase Dvp -ConfirmWiring
```

Camera 验收期间 C6I 保持跨重启禁用。拆除相机信号线后恢复游戏服务：

```powershell
ssh -b 192.168.2.1 pynq-z2 "sudo systemctl unmask voice-view-shell.service; sudo systemctl enable --now voice-view-shell.service"
```

## C2 无显示输入闭环

C2 在 C0 基线上增加 `input_gpio`：低 4 位为 `BTN0-3`，高 2 位为 `SW0-1`，地址为 `0x41210000`；BUILD_ID 更新为 `0xC0020001`。构建前必须先将已验证来源的 PYNQ-Z2 BTN/SW 约束写入 `constraints/c2_buttons_switches.xdc`，构建脚本会在缺少该文件时停止：

```powershell
.\board\pynq_z2\scripts\build_c2.ps1
```

在板端创建 `/home/xilinx/c2_overlay`，将整个 `python/pynq_multimodal_game/` 包、`c2_overlay.bit`、`c2_overlay.hwh`、`verify_c2.py`、`c2_headless.py` 和 `data/replays/c1_demo_controls.jsonl` 部署到该目录。先执行 Overlay 和实体输入验证，再执行固定 golden replay：

```bash
cd /home/xilinx/c2_overlay
sudo env XILINX_XRT=/usr /usr/local/share/pynq-venv/bin/python \
	./verify_c2.py ./c2_overlay.bit --exercise-inputs \
	--evidence ./c2_input_evidence.json
sudo env XILINX_XRT=/usr PYTHONPATH=/home/xilinx/c2_overlay \
	/usr/local/share/pynq-venv/bin/python \
	./c2_headless.py ./c2_overlay.bit ./c1_demo_controls.jsonl \
	--report ./c2_headless.report.json
```

固定 replay 只有在 330 tick、`WON`、40 分、最终状态哈希和首末帧 CRC 全部匹配 C1 golden 时才输出 `PASS`。首次板端操作前创建 C2 bring-up 记录。

### C2 受限免密 sudo

普通 sudo 验收完成后，可安装仅允许 C2 验收包装器的免密规则：

```bash
sudo /bin/sh /home/xilinx/c2_overlay/install_c2_nopasswd.sh
```

该脚本将运行基线复制到 root-only 的 `/opt/voice-view-game/c2`，仅允许以下命令免密运行：

```bash
sudo -n /usr/local/sbin/voice-game-c2-verify
sudo -n /usr/local/sbin/voice-game-c2-replay
```

前者仍需要操作者完成 BTN/SW 提示；两条包装器忽略额外参数，证据写入 root-owned 的 `/var/lib/voice-view-game/c2`。

## C3 HDMI G0

C3 在独立 Overlay 中增加 74.25 MHz 像素域、1280x720p60 时序、320x180 逻辑坐标、诊断色条、单 Sprite 和 TMDS 输出。构建前会从 PYNQ v3.1 固定提交下载 `rgb2dvi:1.2` 的最小文件集，并逐文件校验 SHA-256：

```powershell
.\board\pynq_z2\scripts\build_c3.ps1
```

成功标志为 `C3_BUILD_STATUS=PASS`，产物为：

```text
board/pynq_z2/output/c3_overlay.bit
board/pynq_z2/output/c3_overlay.hwh
board/pynq_z2/output/c3_overlay.xsa
board/pynq_z2/output/c3_overlay_manifest.txt
board/pynq_z2/output/reports/c3/
```

本地仿真和实现证据记录在 `docs/bringup/2026-09-26_pynq-z2_c3.md`。板端使用独立目录部署：

```powershell
ssh pynq-z2 "mkdir -p /home/xilinx/c3_overlay"
scp .\board\pynq_z2\output\c3_overlay.bit `
	.\board\pynq_z2\output\c3_overlay.hwh `
	.\board\pynq_z2\verify_c3.py `
	pynq-z2:/home/xilinx/c3_overlay/
```

连续加载 10 次并读取 `0x41200000` 的 BUILD_ID `0xC0030001`：

```bash
cd /home/xilinx/c3_overlay
sudo env XILINX_XRT=/usr /usr/local/share/pynq-venv/bin/python \
	./verify_c3.py ./c3_overlay.bit
```

通过标志为 `C3_VERIFY_STATUS=PASS (10/10)`。随后使用支持 1280x720@60 的显示器或采集卡检查八条竖向彩条、居中 Sprite 和颜色通道，并连续观察 30 分钟。

## C4M2 CLEAR/FILL Renderer

C4M2 复用 HP0 + AXI DMA 数据面和两颗 4 KiB command bank，在 100 MHz PL 时钟域执行 `CLEAR`、`FILL_RECT` 与 `END_FRAME`，输出确定性的 framebuffer 写请求流。构建命令：

```powershell
.\board\pynq_z2\scripts\build_c4m2.ps1
```

成功标志为 `C4M2_BUILD_STATUS=PASS`，产物为 `c4_clear_fill.bit/.hwh/.xsa` 和 `c4_clear_fill_manifest.txt`。主要 MMIO 地址：

| 地址 | 内容 |
| --- | --- |
| `0x40400000` | AXI DMA MM2S |
| `0x41200000` | BUILD_ID `0xC0040200` |
| `0x41210000` | upload CRC / bytes |
| `0x41220000` | completed / accepted packet count |
| `0x41230000` | accepted sequence / command bank status |
| `0x41240000` | rejected count / upload error flags |
| `0x41250000`、`0x41260000` | command bank debug address/data |
| `0x41270000` | render sequence / completion count |
| `0x41280000` | render trace CRC / write count |
| `0x41290000` | last / maximum render cycles |
| `0x412A0000` | renderer busy/error/index status |

部署并执行 10 次独立重载：

```powershell
ssh pynq-z2 "mkdir -p /home/xilinx/c4m2_overlay/pynq_multimodal_game"
scp .\board\pynq_z2\output\c4_clear_fill.bit `
	.\board\pynq_z2\output\c4_clear_fill.hwh `
	.\board\pynq_z2\verify_c4m2.py `
	pynq-z2:/home/xilinx/c4m2_overlay/
scp .\python\pynq_multimodal_game\*.py `
	pynq-z2:/home/xilinx/c4m2_overlay/pynq_multimodal_game/
ssh pynq-z2 "cd /home/xilinx/c4m2_overlay && sudo -n env XILINX_XRT=/usr PYTHONPATH=/home/xilinx/c4m2_overlay /usr/local/share/pynq-venv/bin/python verify_c4m2.py c4_clear_fill.bit --iterations 10"
```

通过标志为 `C4M2_VERIFY_STATUS=PASS (10/10)`。Canonical 场景固定产生 57,608 writes、trace CRC `0xB62CC96A` 和 57,644 cycles；首轮同时覆盖 unsupported 与 malformed renderer errors。

### 开发板免密 sudo

该板卡为单用户隔离开发环境时，可一次性开放 `xilinx` 用户的全部 sudo 命令。首次部署安装器，并手动输入一次板端 sudo 密码：

```powershell
scp .\board\pynq_z2\install_pynq_dev_nopasswd.sh pynq-z2:/home/xilinx/
ssh -tt pynq-z2 "sudo /bin/sh /home/xilinx/install_pynq_dev_nopasswd.sh"
```

安装后，自动化命令统一使用非交互模式：

```bash
sudo -n env XILINX_XRT=/usr /usr/local/share/pynq-venv/bin/python \
	/home/xilinx/c3_overlay/verify_c3.py \
	/home/xilinx/c3_overlay/c3_overlay.bit
```

该配置写入 `/etc/sudoers.d/xilinx-development-nopasswd`，内容为 `xilinx ALL=(ALL:ALL) NOPASSWD: ALL`。它适用于无其他用户访问的隔离开发板；任何以 `xilinx` 身份运行的进程均可取得 root 权限。