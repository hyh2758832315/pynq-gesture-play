# PYNQ-Z2 部署

目标环境为 PYNQ 3.1、Python 3.10、PL BUILD_ID `0xC0061000`。`runtime/` 是完整配对运行包；PC 使用 `src/studio/`。以下 PC 命令在 `project/` 的 PowerShell 执行，板端命令明确标为 Bash。首次 SD 准备、依赖安装完成后，系统与内容均通过 Studio 安装。

## 1. 首次准备板卡与网络

使用 PYNQ-Z2 对应的 PYNQ 3.1 镜像制作 SD，完成官方首次启动。镜像与联网步骤见 [PYNQ 入门文档](https://pynq.readthedocs.io/en/latest/getting_started.html)。默认直连地址：PYNQ `192.168.2.99/24`、PC `192.168.2.1/24`。在 PC 个人 SSH 配置中增加主机，配置本人的密钥登录；私钥不放入工程。

```sshconfig
Host pynq-z2
    HostName 192.168.2.99
    User xilinx
    IdentityFile ~/.ssh/id_ed25519
```

首次通过密码登录，将本人的公钥加入板端 `~/.ssh/authorized_keys` 后检查：

```powershell
ssh -b 192.168.2.1 pynq-z2 "hostname -I"
ssh -b 192.168.2.1 pynq-z2 "sudo -n true"
ssh -b 192.168.2.1 pynq-z2 "/usr/local/share/pynq-venv/bin/python -c 'import sys,pynq,cv2,numpy,tomli; print(sys.version)'"
```

预期地址含 `192.168.2.99`，无交互 sudo 返回 0，应用解释器为 Python 3.10 且所有导入成功。PYNQ、OpenCV 与 NumPy 使用镜像配套版本；若仅缺 `tomli`，在板端以该解释器安装 `tomli>=2,<3`。等待 `bootpy.service` 和 `clear_pl_statefile.service` 完成后安装项目。

## 2. 接线

断电接线。HDMI 接 PYNQ 的 HDMI OUT，网线接 PC，OV5640 接 JA/JB；灵巧手使用独立动力供电，USB 数据线接 PYNQ。相机模块的供电、电平与针位须与本项目模块一致，换模块时按其原理图核对。

| 相机信号 | PYNQ Pmod 位置 | FPGA 引脚 |
|---|---|---|
| PCLK / XCLK | JA2 / JA8 | Y19 / U19 |
| HREF / VSYNC | JA3 / JA9 | Y16 / W18 |
| SCL / SDA | JA4 / JA10 | Y17 / W19 |
| D0 / D1 / D2 / D3 | JB10 / JB4 / JB9 / JB3 | W13 / T10 / V12 / T11 |
| D4 / D5 / D6 / D7 | JB8 / JB2 / JB7 / JB1 | W16 / Y14 / V16 / W14 |
| GND / 3V3 | JA、JB 各自的 5、11 / 6、12 | 板端固定电源脚 |

硬件约束以 [camera_direct_plug_corrected.xdc](runtime/board/pynq_z2/constraints/camera_direct_plug_corrected.xdc) 为准；修改信号连接后须同步 XDC 并重建硬件。灵巧手的 17 个 ID 与机械标定由 `runtime/hand-runtime/assets/` 配套提供，换手须校准对应资产。

## 3. Studio 首次安装

按 [项目 README](../README.md) 建好 PC 虚拟环境后启动：

```powershell
.venv\Scripts\python.exe -B tools/start_studio.py
```

在“加载到 PYNQ”中选择完整系统包 `board/runtime/`，或 `tools/prepare_runtime.py` 生成的完整目录，点击“安装完整项目”。此入口先检查配对清单和 SSH 板卡身份，再正常停止旧实例、确认资源释放、上传、校验并启动；首次不存在旧项目时直接建立安装目录。等待 HDMI 加载页进入菜单、Studio 显示 READY。该安装入口不驱动实体手。

Studio 在内容工程目录 `.loads/<事务号>/receipt.json` 保存结果；板端安装身份在 `/home/xilinx/voice-view-game/.studio-system/active.json`。不要将单个 bit、HWH 或 Python 文件替换到已封装运行包中。重建硬件后使用配包工具重算清单。

## 4. 灵巧手独立环境

已使用本项目的板卡可复用原环境。全新板卡先在 PC 复制手控制源码：

```powershell
scp -r src/hand pynq-z2:/home/xilinx/pynq-hand-source
```

随后在板端 Bash 执行：

```bash
sudo apt-get update
sudo apt-get install -y python3-venv python3-dev build-essential gfortran libopenblas-dev pkg-config
mkdir -p /home/xilinx/pynq-usb-hand/board-20261023-r01
/usr/local/share/pynq-venv/bin/python -m venv /home/xilinx/pynq-usb-hand/board-20261023-r01/venv
/home/xilinx/pynq-usb-hand/board-20261023-r01/venv/bin/python -m pip install --upgrade pip
/home/xilinx/pynq-usb-hand/board-20261023-r01/venv/bin/python -m pip install /home/xilinx/pynq-hand-source/vendor/orca /home/xilinx/pynq-hand-source
/home/xilinx/pynq-usb-hand/board-20261023-r01/venv/bin/python -m pip check
/home/xilinx/pynq-usb-hand/board-20261023-r01/venv/bin/python -c 'import numpy,serial,yaml,orca_core; print(numpy.__version__)'
ls -l /dev/serial/by-id/
```

依赖约束见 [ORCA pyproject.toml](runtime/hand-runtime/vendor/orca/pyproject.toml)，包括 NumPy `>=2.2.6,<3` 和 `ftservo-python-sdk==2.0.0`。ARMv7 若无对应 wheel，pip 会从源码构建；应以板端 `pip check` 与导入通过为环境就绪依据，不能复用 Windows wheel。此步骤安装依赖，不发送电机命令。

原配手使用运行包中绑定的 USB 稳定标识与 17 电机标定。新板卡配原手时保留这些配置；不同机械手先完成机械标定。运动前核对 17 个 ID、独立电源和标定结果，在现场观察且活动范围清空时启用。

更换 USB 适配器属于设备身份移植：从 `ls /dev/serial/by-id/` 取得实际路径后，需要同步下列入口，再完整重封装。它不是单改 Studio 端口即可完成的设置项。

| 层次 | 需保持一致的位置 |
|---|---|
| Studio 与开机入口 | `system_board.py` 的启动、卸力证明校验；`system_autostart.py` 的设备存在检查。同步 `src/studio/python/` 与 `src/development/python/` 中的对应文件 |
| 运行包启动与串口子进程 | `runtime/python/pynq_multimodal_game/hand_startup.py`、`runtime/hand_child/serial_motion_receiver.py` |
| 运行包只读检查 | `runtime/hand-runtime/src/pynq_usb_hand/probe.py`、`runtime/hand-runtime/tools/power_feedback_readonly.py`；同步维护 `src/hand/` 中的对应源文件 |

在独立工作副本完成身份配置并运行相关离线测试，随后更新 `hand_startup.py` 中只读源码 SHA、`hand_shadow_bridge.py` 中串口子进程 SHA；若修改标定或被引用源码，还须更新冻结资产及串口源码清单和对应摘要。`tools/prepare_runtime.py` 以 `board/runtime/` 为软件模板，不会自动复制 `src/studio/`、`src/hand/` 的改动；因此模板和各层摘要准备好后再按项目 README 运行该工具，生成新的外层部署清单。重新启动 PC Studio，并在完整安装后重新配置自启动入口，使两者采用同一设备身份。新设备完成配对检查、17 电机只读检查与现场动作验收后投入运行。

## 5. 正常停止当前项目

关闭 Studio 窗口只断开 PC；“取消任务”只取消未完成的加载。正常停止使用 Studio 已有的板端交接接口。以下 PC PowerShell 命令读取当前受管实例身份，再发出正常停止请求，同时覆盖 GUI 安装启动和 systemd 自启动实例：

```powershell
@'
import json, subprocess
from pathlib import PurePosixPath
from types import SimpleNamespace
from pynq_multimodal_game.studio.system_loader import SystemLoader
raw = subprocess.check_output([
    'ssh', '-b', '192.168.2.1', 'pynq-z2',
    'sudo -n cat /home/xilinx/voice-view-game/.studio-system/active.json'])
record = json.loads(raw)
transaction = record.get('transaction') or PurePosixPath(record['root']).name.removeprefix('studio-system-')
device = SimpleNamespace(connection_settings=('192.168.2.99', 8765, '192.168.2.1', 0xC0061000))
result = SystemLoader(device).remote('stop', transaction, record['manifest_sha256'])
print(json.dumps(result, ensure_ascii=False, indent=2))
'@ | .venv\Scripts\python.exe -X utf8 -B -
```

预期 `running:false`、`owners:[]`；本次视觉释放记录的 `cleanup_confirmed` 为 true，启用过实体手时还须确认 17 电机 OFF 与串口关闭记录。此入口等待常规退出与清理，不强制结束硬件所有者。

## 6. 全新板卡建立自启动

先完成第 3 节安装，再按第 5 节正常停止。基础服务只需首次注册；以下步骤不启动进程、不覆盖已有服务。

PC：

```powershell
scp board/voice-view-shell.service pynq-z2:/home/xilinx/voice-view-shell.service
```

板端 Bash：

```bash
if ! systemctl cat voice-view-shell.service >/dev/null 2>&1; then
    sudo install -m 0644 /home/xilinx/voice-view-shell.service /etc/systemd/system/voice-view-shell.service
    sudo systemctl daemon-reload
fi
systemctl show voice-view-shell.service -p ActiveState
```

预期 `ActiveState=inactive`。回到 PC，用与第 3 节相同的候选目录安装启动入口：

```powershell
.venv\Scripts\python.exe -B src/development/tools/install_studio_autostart.py --candidate board/runtime --output build/output/autostart
```

预期输出 `result:PASS`，生成 `build/output/autostart/autostart-install.json`；安装器校验当前包身份、写入 boot 入口和 systemd drop-in、执行 `--check` 并启用服务。手环境及现场条件已就绪时，在同一命令增加 `--enable-hand`；增加 `--start` 才立即启动。采用自建包时将 `--candidate` 换成对应目录。

此后 PYNQ 上电自动从 SD 加载已安装项目，无需再次上传。Studio 的“启动／连接项目”会连接已有实例或启动已安装项目。正常停止后执行 `ssh pynq-z2 "sudo -n reboot"` 可验收重启流程；等待官方初始化和项目加载完成，再确认 READY。服务声明与启动入口的离线检查不代替该板卡首次实机验收。

## 7. 验收与结束

依次测试加载页、主菜单、游戏及暂停/返回、画布与相册、视频与回传恢复、手势展示与跟随。机械动作前清空活动范围并现场观察；真人操作时不并行运行自动输入脚本。结束按第 5 节正常停止并检查资源释放，随后可执行 `ssh pynq-z2 "sudo -n poweroff"`，等待系统完成关机后断电。

发行环境的实测材料在 [sim/evidence/v3_release/](../sim/evidence/v3_release/)。新 SD、不同相机模块和新灵巧手分别完成环境、接线、标定与现场功能验收。
