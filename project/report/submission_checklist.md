# 官方要求对照

核对日期：2026-11-04。依据 [自主选题指南](https://gitee.com/Vickyiii/fpgachina26-amd/blob/master/tracks/open-topic/GUIDE.md) 与 [完整指南](https://gitee.com/Vickyiii/fpgachina26-amd/blob/master/TRACK_GUIDE_2026.md)。

| 官方要求 | 对应内容 | 状态 |
| --- | --- | --- |
| AMD 器件与工具 | PYNQ-Z2 / xc7z020clg400-1，Vivado 2026.1 | 已声明 |
| 源码、工程、构建 | src/、build/hardware/、build/scripts/ | 已提供 |
| 仿真与验证 | sim/、skill/validation/ | 已提供 |
| 资源、时钟、性能对比 | build/reports/gpu_optimization/、data/gpu_optimization/、data/report_metrics.csv | 三配置同输入对照，完整实现资源与时序 |
| 上板工程、实测输出 | board/runtime/、sim/evidence/gpu_optimization/；基线见 sim/evidence/v3_release/ | Studio 安装、四游戏回放及真人交互验收 |
| PYNQ Skill | skill/README.md，两项能力、20 张卡片 | 已提供 |
| Skill 用法、失效条件、来源及效果 | skill/README.md、report.md、origins.json | 已提供 |
| 提示词、模型回答、自我纠错 | report/ai_collaboration.md | Markdown 关键思路摘录、决策与验证链接 |
| 设计报告 | report/design_report.md、report_materials.md | 已提供技术正文与官方模板 |
| 从零复现 | README.md、board/README.md | 已提供环境配置、依赖和运行步骤 |
| 开源与再分发 | report/licensing.md | 公开源码仓库；自有内容 MIT，第三方保留原许可 |
| 目录及命名 | README.md、data/naming_exceptions.json | 目录已映射，工具约定名称单列 |

仓库与平台单独上传的源码压缩包是两项提交物；平台 RAR 大小限制不替代工程、结果和 Skill 要求。

运行 `python -B tools/check_submission.py` 检查入口、模板、指标引用及 Skill 摘要。

## 评分项与核查入口

| 评分项 | 权重 | 本项目提供的设计与证据 |
|---|---:|---|
| 创新性与应用价值 | 30 | [设计报告](design_report.md)：单板视觉、独立 OSD、命令式 2D 渲染与实体手协同；统一内容创作、测试及部署 |
| 性能与资源优化 | 20 | [GPU 对照](gpu_optimization.md)：缓存、流水线、条件双像素的机制；同输入周期、CRC、资源与完整实现时序；既有视觉和通信数据见设计报告 |
| 功能正确性与完整性 | 20 | [验证汇总](validation.md)：RTL 自检、Studio 回归、四游戏 PC/PYNQ 比较、现场交互、启动及正常释放 |
| 大模型协作与技能包 | 15 | [关键对话](ai_collaboration.md)、[PYNQ Skill](../skill/README.md)：人工目标、模型方案、工具验证、修正，以及可迁移校验工具和诊断卡片 |
| 文档质量与可复现性 | 15 | [复现入口](../README.md)：三配置完整构建、同输入仿真、配套运行包生成、Studio 安装；文件与数据可逐项核验 |

协作记录按主办方确认采用 Markdown。Skill 保留适用范围、用法、验证效果、提炼来源和失效条件，供其他 PYNQ 项目直接复用。此表映射材料与评分项，具体评分由评审确定。
