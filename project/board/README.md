# PYNQ-Z2 部署

发行配置：PYNQ 3.1 / Python 3.10，PL BUILD_ID 0xC0061000。板端运行包在 runtime/；PC 使用 src/studio。

## 环境准备

1. 使用 PYNQ-Z2 对应的 PYNQ 3.1 镜像准备 SD，完成首次启动及网络设置。基础步骤见 [PYNQ 文档](https://pynq.readthedocs.io/en/latest/getting_started.html)。
2. 项目默认直连板卡 192.168.2.99、PC 192.168.2.1，SSH 别名 pynq-z2。用本机 SSH 配置设置 HostName、User xilinx 及个人密钥；密钥不放进工程。
3. 相机与 HDMI 接口按 `runtime/board/pynq_z2/constraints/camera_direct_plug_corrected.xdc` 和对应接线文档连接。相机型号 OV5640；修改接线须同步约束及重建硬件。
4. 板端应用解释器为 `/usr/local/share/pynq-venv/bin/python`，需要 pynq、cv2、numpy、tomli；collision 1.2.2 已随包校验。通过 Studio 上传后，先执行包内 `start_board_test.py --check-only` 核对包与依赖。
5. 灵巧手使用独立环境 `/home/xilinx/pynq-usb-hand/board-20261023-r01/venv/bin/python`，依赖见 `runtime/hand-runtime/vendor/orca/pyproject.toml`。其中 NumPy >=2.2.6 的 ARMv7 安装方式需按目标环境验证；PC wheel 不能用于板端。标定文件仅适用于原手，换手须重新标定。

## Studio 标准操作

在 project/ 按 README 安装并启动 Studio，选择“安装完整项目”，候选目录为本目录 runtime/。部署客户端在停止旧实例、检查完整性和释放资源后安装，随后显示初始化和 READY。“启动／连接项目”连接已启动实例，或启动已安装项目。

已配置受管服务的板卡上电后自动加载。服务入口为 `src/studio/python/pynq_multimodal_game/studio/system_autostart.py`；已有安装的自启动配置工具为 `src/development/tools/install_studio_autostart.py`，使用时显式指定 `--candidate board/runtime`。该工具要求基础服务已存在，不能用作空白 SD 的完整安装器。

## 验收顺序

加载页、主菜单、游戏及暂停/返回、画布与相册、视频与回传恢复、手势展示与跟随。机械动作前清空活动范围并现场观察。结束用 Studio 正常停止，检查设备卸力和资源释放结果。

发行环境的实测材料在 sim/evidence/v3_release/。空白 SD、不同相机接线和新灵巧手需各自完成上述环境与标定验证。
