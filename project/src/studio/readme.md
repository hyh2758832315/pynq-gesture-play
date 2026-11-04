# 当前 PC Studio

本目录是 v3.0 发布的 PC 源码、媒体与游戏工作区。安装、启动使用顶层 `tools/start_studio.py`，该入口固定选择本包游戏目录和 `board/runtime`。

不要直接复制历史桌面快捷方式或开发机候选路径。游戏构建、PC 测试与板卡加载均在 Studio 内完成；具体命令及离线验证见 [总览](../../README.md)。本次原生窗口冒烟测试使用隔离 QSettings、离屏模式，没有启动板卡。
