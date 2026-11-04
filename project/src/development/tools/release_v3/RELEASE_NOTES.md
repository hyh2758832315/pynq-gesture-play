# 完整版 v3.0 · Studio–PYNQ

整合原生粉色 Studio、四游戏/PC 示例、双默认视频、画布与临时相册、灵巧手跟随和 0–9＋比心展示。冻结 R23b2 PL（BUILD_ID 0xC0061000）、R15b PS 运行包及配对 R16 灵巧手。

本次重点：统一“启动／连接项目”，区分 SSH 板卡连接与 Agent 就绪；开机检查占用启动锁时等待并接管连接，避免 Errno 11 和重复启动。板卡上电自动加载已安装项目、默认启用灵巧手；无需先打开 Studio。优化最新手势接续、回传时资源分配、视频和菜单恢复及释放交接。

169 项本轮启动/Studio 自动化回归通过；随包保留此前 R15b 运行回归、标准安装和实板视频/回传恢复收据。真实重启后的自启动实例已由新统一入口连接，确认 already_running，不重复启动。锁竞争以离线模拟验证，本轮未再完成全部机械姿态及所有游戏真人验收。

下载 **voice-view-full-v3.0.zip**，先执行 `python -B verify_release.py`，再按 README 启动 Studio。大文件由包内校验块离线重建；完整源码、配对硬件产物、证据和 SHA 清单随包提供。默认视频来源/第三方许可证保留。不含 SD 镜像和虚拟环境。

[完整源码和使用说明](https://github.com/HH-bit-dev/pynq-audiovisual-diagnostics/tree/v3.0/releases/v3.0)。v1.0、v2.0 历史版本保留。
