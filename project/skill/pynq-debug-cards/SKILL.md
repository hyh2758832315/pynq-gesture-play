---
name: pynq-debug-cards
description: Diagnose recurring PYNQ/Zynq project failures using symptom-based experience cards. Use for Vivado/MCP execution mismatches, stale bit/HWH exports, parser errors, startup and connection problems, shared-resource handoff, or latest-input consumption failures.
license: MIT
metadata:
  version: '0.1.0'
---

# PYNQ 问题定位卡片

从当前症状选一组卡片，核对适用条件后执行其定位与处理路径。
先核对项目身份、工具版本、当前状态和操作范围。

| 当前症状 | 按需读取 |
| --- | --- |
| SKIPPED、工具成功但领域失败、会话/参数错误 | [工具调用](references/tools.md)：E01–E04 |
| include 失败、HWH 陈旧、XSA/IRQ 解析异常、导出错版 | [构建与制品](references/artifacts.md)：E05–E08、H20 |
| 冷启动超时、缺依赖、真实入口不同、锁忙或 GUI 卡住 | [启动连接](references/startup.md)：E09、E10、E12、H13、H14 |
| 释放超时、页面失活、提交不呈现、MMIO 阻塞 | [资源交接](references/handoff.md)：E11、H15、H16、H19 |
| 忙结束后漏最新手势、边缘位置误清分类 | [实时输入](references/input.md)：H17、H18 |

每张卡含症状、核对与处理、完成条件、适用条件及本包来源。
按任务读取相关组，sources/ 技术摘要提供原始观察与结果。
将案例步骤适配到当前工具接口；硬件地址、超时和状态字段按实际项目取值。
同一 owner 下采用可恢复重试，资源释放成功后续接正常操作。

卡片用于组织当前任务的定位与验证：先核对触发条件，再选择处理分支，
最后通过与改动相关的检查确认目标功能恢复。
遇到纯 RTL 行为保持问题，使用同包 [PL 校验 Skill](../pynq-pl-preserve/SKILL.md)。
