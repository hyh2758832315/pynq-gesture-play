# 验证结果

## 公开前整理验证（2026-11-04）

| 检查 | 结果 |
| --- | --- |
| Studio 标准加载、连接、内容流、UI、自启动离线回归 | 169 项通过 |
| 发布候选板端文件摘要 | 651 项通过 |
| 指标数据引用与图稿检查 | 44 项指标、三个图稿包通过 |
| Skill 入口格式与完整性 | 两个入口、99 个文件通过 |
| 两段自制默认视频 | 各 90 帧完整解码通过 |
| 灵巧手目标参考提取 | 68 个电机目标一致；Mock 姿态播放通过 |

本次变更为公开材料整理、路径脱敏和默认媒体替换，硬件配置与运动算法保持原版本。验证使用本机离线环境，没有连接板卡。原始测试输出与计数由复现命令重新生成。

## 工程构建及发行验证

| 检查 | 结果与位置 |
| --- | --- |
| 空目录重建工程 | PASS；build/reports/recreate_check.txt |
| 全新非增量综合 | PASS；sim/evidence/hardware_session.log |
| 帧拥有权 RTL | 14 场景 / 184 检查；sim/evidence/frame_owner_result.txt |
| 冻结硬件时序 | WNS +0.011 ns，WHS +0.050 ns，WPWS +0.538 ns；build/reports/ |
| 最终硬件导出 | 配置负载及软件接口检查通过；build/rebuilt/hardware_check.json |
| 发行板测 | 安装、视频/回传恢复、启动连接；sim/evidence/v3_release/ |

最终产物在 build/rebuilt，重建脚本会执行 finish_timing.tcl。工程 run 内的较早 bit 属于定点收敛前中间结果；部署使用通过配对检查的 bit/HWH。配置负载 SHA256：4c3928bbf50a99aac9828c6f27cc1ca902a527a611e79f5e56ca6dc77398ef60。

来源索引保留历史摘要；脱敏或技术摘要的文件以当前 manifest 为准。历史板测仍绑定原发行环境；新默认媒体完成离线验证，全新 SD 与新机械标定另行验收。
