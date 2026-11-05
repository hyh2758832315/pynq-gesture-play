# 技术报告、数据与图稿入口

完整正文见 [设计报告与大模型协作记录](设计报告与大模型协作记录.md)，统一给出设计、数据、协作、Skill 与复现步骤。下表提供专题材料和可编辑图稿。[官方 Word 模板](templates/official_report_template.docx)提供报告排版格式。

| 内容 | 材料 |
| --- | --- |
| 设计与协作完整正文 | [设计报告与大模型协作记录](设计报告与大模型协作记录.md)，含当前 GPU 三配置对照和完整复现步骤 |
| 系统专题材料 | [系统概要](design_report.md)、[架构专题 PDF](reference_v2_design/gesture_play_v2_junior.pdf)、[技术报告 PDF](PYNQ的多模态GPU渲染游戏技术报告.pdf)；PDF 对应各自所载的配置和实验条件 |
| 当前 GPU 三配置优化、资源与板测 | [二维 GPU 优化与验证](gpu_optimization.md)、[逐帧周期对比](../data/gpu_optimization/measurements.csv)、[完整实现资源](../data/gpu_optimization/resources.csv) |
| 视觉 PL 加速与识别帧率 | [核内计时与板端窗口](vision_acceleration/README.md)，含冻结 RTL、计时测试台、原日志摘录及帧号／时长数据 |
| 阶段性能与机制对照 | [2026-10 性能报告](reference_v2_performance/performance_resource_report.pdf)、[GPU 阶段实验报告](gpu_ai_preparation/gpu_optimization_report.pdf)，保留各阶段输入与测量条件 |
| PL/PS 完整系统图 | [中英文可编辑母图](figures/pl_ps_v3/README.md) |
| 灵巧手驱动与低负荷通信 | [时序、逐字节协议、对比数据、重绘源](figures/hand_communication_handoff/START_HERE.md) |
| 视觉识别与双路跟随 | [算法、DMS1 包、OSD 与最新状态消费](figures/vision_dual_follow_handoff/START_HERE.md) |
| GPU 缓冲与呈现时序 | [缓冲身份、握手、指令编码与存储对照](figures/gpu_buffer_timing_handoff/START_HERE.md) |
| Skill 章节 | [当前报告](../skill/report.md)、[使用说明](../skill/README.md)、[原始实验](../skill/validation/README.md) |
| 测量表与证据引用 | [阶段指标 CSV](../data/report_metrics.csv)，每行列出单位、配置/测量范围和原始证据路径（相对 project 根目录）；最新 GPU 数据由上面的三配置入口提供 |
| 视频、报告、海报共用规划 | [录制及可视化规划](presentation_plan/README.md) |
| ROSS 使用经验与 Skill 联合流程 | [报告正文](设计报告与大模型协作记录.md#ross-tools)、[真实 MCP 案例](../skill/pynq-debug-cards/sources/ross_mcp_cases.json)、[可复用工作流](../skill/pynq-debug-cards/references/ross_workflow.md) |
| 验证与协作过程 | [验证记录](validation.md)、[协作记录](ai_collaboration.md) |

当前配对硬件和运行程序见 board/runtime，GPU 配置及文件摘要见 [优化报告](gpu_optimization.md)。三个配置共用 BUILD_ID 0xC0061000，上传/渲染重叠均关闭。720p60 表示 HDMI 扫描刷新率；17 表示电机数量；灵巧手调度时序图统一使用 t。各优化表保留所列输入、配置和测量范围，便于对应到可复现命令。
