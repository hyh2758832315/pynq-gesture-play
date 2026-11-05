# 官方要求对照

核对日期：2026-11-05。依据 [自主选题指南](https://gitee.com/Vickyiii/fpgachina26-amd/blob/master/tracks/open-topic/GUIDE.md) 与 [完整指南](https://gitee.com/Vickyiii/fpgachina26-amd/blob/master/TRACK_GUIDE_2026.md)。

| 官方要求 | 对应内容 | 状态 |
| --- | --- | --- |
| AMD 器件与工具 | PYNQ-Z2 / xc7z020clg400-1，Vivado 2026.1 | 已声明 |
| 源码、工程、构建 | src/、build/hardware/、build/scripts/ | 已提供 |
| 仿真与验证 | sim/、skill/validation/ | 已提供 |
| 资源、时钟、性能对比 | build/reports/gpu_optimization/、data/gpu_optimization/、data/report_metrics.csv | 三配置同输入对照，完整实现资源与时序 |
| 上板工程、实测输出 | board/runtime/、sim/evidence/gpu_optimization/；基线见 sim/evidence/v3_release/ | Studio 安装、四游戏回放及真人交互验收 |
| PYNQ Skill | skill/README.md，两项能力、20 张卡片 | 已提供 |
| Skill 用法、失效条件、来源及效果 | skill/README.md、report.md、origins.json | 已提供 |
| 提示词、模型回答、自我纠错 | [完整报告第 7 章](设计报告与大模型协作记录.md)、ai_collaboration.md | Markdown 真实对话、ROSS/MCP 调用与诊断、约束补充及修订复验 |
| 设计报告 | [设计报告与大模型协作记录](设计报告与大模型协作记录.md) | 独立成篇，覆盖原理、接口、优化、协作、Skill 与复现 |
| 从零复现 | [完整报告第 9 章](设计报告与大模型协作记录.md)、README.md、board/README.md | 环境、接线、三配置重建、配包、首次安装、自启动与正常停止 |
| 开源与再分发 | report/licensing.md | 公开源码仓库；自有内容 MIT，第三方保留原许可 |
| 目录及命名 | README.md、data/naming_exceptions.json | 目录已映射，工具约定名称与报告展示文件名已列出 |

公开仓库提供工程、验证结果和 Skill；平台源码压缩包按独立上传入口的 RAR 格式与大小要求准备。

运行 `python -B tools/check_submission.py` 检查入口、模板、指标引用及 Skill 摘要。

## 评分项与核查入口

| 评分项 | 权重 | 本项目提供的设计与证据 |
|---|---:|---|
| 创新性与应用价值 | 30 | [完整报告](设计报告与大模型协作记录.md)：单板视觉、独立 OSD、命令式 2D 渲染与实体手协同；统一内容创作、测试及部署 |
| 性能与资源优化 | 20 | [GPU 对照](gpu_optimization.md)：缓存、流水线、条件双像素的机制；同输入周期、CRC、资源与完整实现时序；既有视觉和通信数据见设计报告 |
| 功能正确性与完整性 | 20 | [验证汇总](validation.md)：RTL 自检、Studio 回归、四游戏 PC/PYNQ 比较、现场交互、启动及正常释放 |
| 大模型协作与技能包 | 15 | [关键对话](ai_collaboration.md)、[PYNQ Skill](../skill/README.md)：人工目标、模型方案、ROSS/MCP 工具记录与修正，以及可迁移校验工具、诊断卡片和联合使用流程 |
| 文档质量与可复现性 | 15 | [复现入口](../README.md)：三配置完整构建、同输入仿真、配套运行包生成、Studio 安装；文件与数据可逐项核验 |

协作记录按主办方确认采用 Markdown。Skill 保留适用范围、用法、验证效果、提炼来源和失效条件，供其他 PYNQ 项目直接复用。各评分项均提供设计说明、验证结果或复现入口，便于逐项核查。
