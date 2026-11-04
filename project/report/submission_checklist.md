# 官方要求对照

核对日期：2026-11-04。依据 [自主选题指南](https://gitee.com/Vickyiii/fpgachina26-amd/blob/master/tracks/open-topic/GUIDE.md) 与 [完整指南](https://gitee.com/Vickyiii/fpgachina26-amd/blob/master/TRACK_GUIDE_2026.md)。

| 官方要求 | 对应内容 | 状态 |
| --- | --- | --- |
| AMD 器件与工具 | PYNQ-Z2 / xc7z020clg400-1，Vivado 2026.1 | 已声明 |
| 源码、工程、构建 | src/、build/hardware/、build/scripts/ | 已提供 |
| 仿真与验证 | sim/、skill/validation/ | 已提供 |
| 资源、时钟、性能对比 | build/reports/、data/report_metrics.csv | 已提供，注明测量范围 |
| 上板工程、实测输出 | board/runtime/、sim/evidence/v3_release/ | 已提供发行环境结果 |
| PYNQ Skill | skill/README.md，两项能力、20 张卡片 | 已提供 |
| Skill 用法、失效条件、来源及效果 | skill/README.md、report.md、origins.json | 已提供 |
| 提示词、模型回答、自我纠错 | report/ai_collaboration.md | 真实摘录与对应验证 |
| 设计报告 | report/design_report.md、report_materials.md | 已提供技术正文与官方模板 |
| 从零复现 | README.md、board/README.md | 已提供环境配置、依赖和运行步骤 |
| 开源与再分发 | report/licensing.md | 公开源码仓库；自有内容 MIT，第三方保留原许可 |
| 目录及命名 | README.md、data/naming_exceptions.json | 目录已映射，工具约定名称单列 |

仓库与平台单独上传的源码压缩包是两项提交物；平台 RAR 大小限制不替代工程、结果和 Skill 要求。

运行 `python -B tools/check_submission.py` 检查入口、模板、指标引用及 Skill 摘要。
