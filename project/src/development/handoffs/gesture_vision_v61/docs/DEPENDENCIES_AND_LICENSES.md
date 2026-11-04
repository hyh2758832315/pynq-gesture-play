# 依赖与许可

## 板端外部依赖

当前运行代码复用板上既有目录：

`/home/xilinx/voice-view-game/camera-corrected-hdmi-prototype/capture_camera_direct_plug.py`

该模块提供REQUIRED_IP、WIDTH/HEIGHT、probe_chip_id、configure_sensor、open_frame_dma、save_frame等，包含已经跑通的传感器表与VDMA轮询回退。
此文件在当前本地资料中没有可验证副本，因此没有伪造或以近似脚本替换。现有板子可继续使用；迁移新板之前应从已跑通板子补充该模块及其导入依赖，核对许可和哈希。
可通过--camera-dir指定已验证副本目录。单独本包不能承诺从空白SD镜像完整部署。

板端Python：/usr/local/share/pynq-venv/bin/python3，Python3.10、PYNQ/NumPy/OpenCV4.5.4、XRT与匹配镜像。root用于MMIO/DMA；当前示例通过guard运行。
游戏队友侧参考接收器只依赖Python标准库，不需要安装PYNQ或进行PC端图像推理。

## 许可范围

- runtime/PROJECT1_LICENSE.txt保留原KPTKleist项目MIT声明，适用于其相应来源代码；它不是整包所有软硬件的统一授权。
- 供应商Vivado/IP/PYNQ、rgb2dvi和硬件参考源码须按各自版权声明及许可证使用。原文件注释保留，未擅自为整个仓库追加MIT许可证。
- 发布公开仓库前，应由项目所有者确认自有新增代码许可、第三方资料再分发条件，以及日志/画面是否可公开。
- 本包只放收到的测试日志/CSV，不放AVI、人像图片、账号token、SSH私钥、Vivado许可证、虚拟环境或工具安装。

## 已知界面文字

冻结的dashboard.html还保留“HDMI仍由PL绘制”这句旧说明；在host-only运行时以日志HDMI_ENABLED=0、CSV与run_config为准，网页这句不是硬件状态检测。本次整理未改动已验收运行代码。

## GitHub发布计划

当前没有执行git init、commit、push或创建远端仓库。
收到用户仓库URL后，先读取仓库结构、默认分支和已有文件，再确定本模块放置目录；不得覆盖队友游戏代码。
暂不将这份完整交接zip重复放入仓库，优先提交结构化源码/文档/配对产物。未纳入缓存和大体积可生成向量。
