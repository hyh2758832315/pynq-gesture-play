# 手势图像处理交接包 v6.1

当前稳定基线：PYNQ-Z2（xc7z020clg400-1）、OV5640、Vivado 2026.1、PYNQ Python 3.10、板上 OpenCV 4.5.4。
默认交接运行方式为 **仅上位机预览 + PL 肤色前端性能模式**；HDMI 回退模式保留。
用户已确认浏览器画面、框、白色质心十字、六宫格正常更新。游戏端尚未接入。

## 队友先读

1. [板端启动与回退](docs/QUICKSTART.md)：在已有摄像头环境运行，不要重启板子。
2. [游戏控制接口](docs/GAME_INTERFACE.md)：从 `/result.json` 读取方向；超时、失联必须释放控制。
3. [性能与验收](docs/VALIDATION.md)：实测约5.20 FPS，但不是游戏端到端延迟或准确率承诺。
4. [处理流程与硬件资料](docs/ARCHITECTURE.md)：PL/PS边界、AXI包协议、可复现性限制。
5. [依赖、许可与发布范围](docs/DEPENDENCIES_AND_LICENSES.md)：全新板卡所需的外部摄像头脚本等。

## 目录

| 目录 | 内容 |
|---|---|
| runtime/ | 原样冻结的v6.1运行代码、82项测试、配对bit/HWH、原manifest及报告 |
| releases/ | 已上板验证的 camera_host_v61_test.zip，上传Jupyter用这个包 |
| scripts/ | 完整启动入口、资料校验工具 |
| examples/ | 队友侧轮询/超时/事件去重参考，无键盘注入、无游戏依赖 |
| evidence/ | 摄像头validate、HDMI performance、host-only performance原日志和CSV |
| hardware/frontend/ | 新PL前端RTL、测试平台、黄金向量生成器及独立综合脚本 |
| hardware/workspace/ | 摄像头Vivado工程源码快照、BD、约束、自定义IP依赖，不含实现缓存 |
| hardware/reports/ | 原完整布线的时序、资源、CDC、DRC、总线偏斜报告 |
| hardware/simulation/ | RTL通过日志及向量生成统计 |
| hardware/legacy_build/ | 原本机集成/构建脚本存档，含原绝对路径，不是跨机器直接执行入口 |

当前代码不修改外部游戏，不模拟键盘。方向/事件是识别模块输出，队友负责映射到自己的角色控制。
队友电脑运行接收示例：`python examples/control_receiver.py`。它输出方向和动作JSON，包含失联释放与事件去重；游戏应在自己的每帧更新中消费方向，而不是每收到一条消息移动固定距离。
HTTP仅适合可信局域网：无认证、无TLS、无跨域CORS头。不要直接开放到公网。

## 校验

在交接包根目录运行：

```bash
python scripts/verify_handoff.py
```

预期 `HANDOFF_HASHES_PASS`、runtime内manifest通过。资料校验不加载bit、不访问摄像头。
开发机依赖安装后可运行 `python -m unittest discover -s runtime -p 'test_*.py'`；PYNQ上按QUICKSTART使用专用Python。
接收示例单独验证：`python -m unittest discover -s examples -p 'test_*.py'`（6项，不计入板端82项）。重新生成资料ZIP：`python scripts/package_handoff.py`。

整理日期使用电脑日期2026-10-05。板子日志内时间为2026-09-26，不能据此判断录制先后或做跨设备时钟对齐。
此目录尚未上传任何GitHub仓库；提供仓库地址后再确认目标分支/目录并上传。
