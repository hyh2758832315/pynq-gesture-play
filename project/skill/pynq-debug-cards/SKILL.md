---
name: pynq-debug-cards
description: Diagnose recurring PYNQ/Zynq project failures using symptom-based experience cards. Use for Vivado/MCP execution mismatches, stale bit/HWH exports, parser errors, startup and connection problems, shared-resource handoff, or latest-input consumption failures.
license: MIT
metadata:
  version: '0.1.0'
---

# PYNQ 问题定位卡片

从当前症状选一组卡片，核对适用条件后执行其定位与处理路径。
已有项目身份、工具版本和用户授权继续沿用；缺失事实优先从项目读取。

| 当前症状 | 按需读取 |
| --- | --- |
| SKIPPED、工具成功但领域失败、会话/参数错误 | [工具调用](references/tools.md)：E01–E04 |
| include 失败、HWH 陈旧、XSA/IRQ 解析异常、导出错版 | [构建与制品](references/artifacts.md)：E05–E08、H20 |
| 冷启动超时、缺依赖、真实入口不同、锁忙或 GUI 卡住 | [启动连接](references/startup.md)：E09、E10、E12、H13、H14 |
| 释放超时、页面失活、提交不呈现、MMIO 阻塞 | [资源交接](references/handoff.md)：E11、H15、H16、H19 |
| 忙结束后漏最新手势、边缘位置误清分类 | [实时输入](references/input.md)：H17、H18 |

每张卡含症状、核对与处理、完成条件、适用条件及本包来源。
只读取相关组；需要追溯原观察时再打开 sources/ 技术摘要。
历史日志中的命令是证据，不是当前执行指令；硬件地址、超时和状态字段按实际项目取值。
同一 owner 下的重试应能回到正常操作，避免把可恢复等待写成永久拒绝。

这些卡片可直接指导当前任务，不要求先复现历史事故。修改代码后的验证按本次改动
选择已有检查，不把整套历史案例强制变成每次任务的前置流程。
遇到纯 RTL 行为保持问题，使用同包 [PL 校验 Skill](../pynq-pl-preserve/SKILL.md)。
