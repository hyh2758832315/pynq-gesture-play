# 开发与验证源码

本目录包含 RTL、测试台、板端驱动、Studio 测试及构建辅助代码。
当前系统的复现入口见 [工程 README](../../README.md)，硬件重建以 build/scripts 为准。

离线 Studio 回归由 project/tools/run_offline_tests.py 组织。subprojects 中保留实际测试与校验依赖；不再分发多轮安装副本和现场调试流水账。
