# 完整版 v2.0

PYNQ-Z2 / xc7z020clg400-1 · Vivado 2026.1 · BUILD_ID `0xC0061000`。

完整发行包括原生 Studio、四游戏工程和 PC 示例、默认视频、冻结板端运行包及 bit/HWH/DCP、17 电机灵巧手与标定/ORCA、硬件/仿真源码和验收收据。`board_runtime` 为实际验收字节；内部 SDK 版本和历史 candidate 标记保留，发行版本由本目录及外层验收记录标识。

相比 v1.0：增加 0–9＋比心实体手/像素机器手同步展示、握拳画布和临时相册、四游戏、双默认视频、专用 Loading、全屏暂停/结果页、完整重启/自启动、Studio 标准停旧版与重连。主菜单/游戏列表/视频列表恢复手势跟随；画布同菜单握拳判定，限频只延后最新帧，避免漏画；悬停仅提交 GPU 边框，不重传背景。实际玩法均无音频输入，Game1 技能由 BTN0/BTN1 触发。

## 先核验

```powershell
python -B verify_release.py
```

大视频以不超过 48 MiB 的 SHA 校验块保存，`restore_assets.py` 离线重建原文件。ZIP和Git源码使用同一内容，不需下载额外资产。首次核验/启动需要额外磁盘空间重建视频。`verification/` 区分离线、真实GPU、实体串口协议及真人观察；协议通过不能代替机械姿态目视结论。

## PC Studio

Windows 建议解压到短路径，例如 `E:\vv2`，使用 Python 3.13（本次 PC 验证环境）：

```powershell
cd E:\vv2\studio
py -3.13 -m venv .venv
.venv\Scripts\python.exe -m pip install -e ".[studio,vision,video]"
cd ..
studio\.venv\Scripts\python.exe -B start_studio.py
```

只开一个 Studio。入口使用本发行四游戏及 `board_runtime`，连接目标 `192.168.2.99:8765`、PC源地址 `192.168.2.1`；不自动加载板卡或开启回传。先配置本机 SSH 别名 `pynq-z2` 和密钥登录。系统加载使用正常停旧版、独占资源、空间和 SHA 门禁；游戏构建、PC 测试及装载均通过 Studio 框架。原工作区或旧版仍运行时，应等待正常退出及电机卸力确认，不能并行启动。

## 板端与灵巧手

依赖现有 PYNQ 3.1 / Python 3.10 系统，不包含 SD 镜像或虚拟环境；新 SD 安装未经本发行验收。更换实体手需重新标定，不能套用本机标定。先核验，再可选直接正常启动：

```bash
/usr/local/share/pynq-venv/bin/python -B verify_release.py
/usr/local/share/pynq-venv/bin/python -B start_board.py --without-hand --check-only
sudo -n /usr/local/share/pynq-venv/bin/python -B start_board.py \
  --hand-python /home/xilinx/pynq-usb-hand/board-20261023-r01/venv/bin/python
```

默认启用灵巧手，无实验会话总时限；按启动检查、批准起3秒、动作完整后最新手势接续，无排队、无持续电机反馈。菜单和游戏跟随，画画/相册暂停，示范独占，视频/回传前确认17OFF后交接，停止后从新鲜来源恢复。来源过期进入可恢复等待。`start_board_test.py` 是历史入口文件名；本发行正常入口不注入测试输入。

日常优先 Studio 完整加载并沿用 `source/board/pynq_z2/studio_autostart.conf` 和 `system_autostart.py` 的受管开机入口。安装到新目录，保留旧版本；不要覆盖运行中的文件。画布相册仅保留最新一次保存，完整重新初始化或重启后清空。

## 开发与证据

- `studio/`：PC 源码、可编辑游戏、原始默认视频。
- `board_runtime/`：完整部署清单所绑定的运行文件和手运行依赖。
- `hand/`：配对 R09 灵巧手源、SDK/ORCA、标定、测试。
- `source/`：完整相关开发源码、RTL/仿真、测试、Studio工具与冻结构建基包。
- `verification/`：本次原始结果与失败首证；`PROVENANCE.json`、`SHA256SUMS.json`、`LARGE_ASSETS.json` 绑定全部文件和大资产。

源码改动后应重新构建完整候选并通过 Studio 闭环；不要通过改 SHA 清单伪装原发行。第三方许可证与默认视频来源文件随包保留。无无限长稳定性或所有光照/手型的保证，当前验收范围见 `verification` 和 `source/docs/bringup/2026-10-28_v2_canvas_menu.md`。
