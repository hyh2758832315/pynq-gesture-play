# 声音部分 Vivado 2026.1 交接

交付日期：2026-10-05。目标：PYNQ-Z2，xc7z020clg400-1。
本包是独立声音部分的原生2026.1可复建源码和验收证据，供队友继续开发；P1整体仍待完成，声音/GPU合并另行实施。

改进方案与P0-P8阶段计划见[声音改进计划](docs/IMPROVEMENT_PLAN.md)，原详细方案全文保留在metadata/voice_first_integration_plan_source.md。

## 最新状态

| 项目 | 本轮实际结果 |
| --- | --- |
| 原生2026.1 IP/BD生成 | PASS；无需版本绕过开关 |
| 完整硬件综合、路由 | PASS；零黑盒 |
| 已约束路由时序 | WNS 2.654ns，WHS 0.015ns，TNS/THS 0 |
| PCM启动 | 6 PCM，375.525us，12B输入、零记录；两轮PASS |
| 原打包/批次协议 | 485记录、3880字、31040B，2735背压；PASS |
| 前端性能探针 | 原FIFO/DC/FIR连接；6入/1出、精确零输出；两轮PASS |
| 空闲feature core探针 | 单轮PASS；仅用于成本定位 |
| 完整PCM数值验收 | 3456静音/3记录及96000方波/485记录仍待完成 |
| 2024.1逐整数等价 | 独立参照待提供 |
| DDR/I/O/CDC警告签核 | 待完成；详见evidence中的报告和事实记录 |
| 原生2026.1 bit/HWH/XSA | 尚未生成或发布 |
| 新候选实板 | Codec/LRCLK/DDR/驱动/HDMI待验 |
| 交接包独立路径复建 | prepare 68.336s/exit0；解压副本真实生成485条配置 |
| 解压副本打包协议复验 | capture 26.668s/exit0，31040B及确定性SHA一致 |

只对候选BD创建脚本移除GP0/HP0两处2026.1只读频率属性赋值；实际ACLK均为100MHz。原交接76项身份保持，算法、系数、模型和协议保持。原README及身份清单留在metadata，仅作历史追溯；请以本页最新状态为准。

## 目录

- hardware/rtl、hardware/vivado、hardware/third_party：独立声音源码、IP/BD创建脚本、XDC、Codec和板文件及原许可证。
- runtime：原分类器和冻结模型；其中voice_hybrid_2s.bit/.hwh明确为2024.1回退基线，绝非本轮2026.1产物，游戏共享Overlay运行时禁止另行加载。
- integration：原声音采集/输入桥组件和测试；GameSDK合同测试仍依赖原voice-view-game仓库，独立包未重新宣称47项通过。
- board/pynq_z2/scripts：原生2026.1 prepare/simulate/build入口及统一voice_p1_handoff.tcl入口。
- sim/voice：自检测试台与性能探针。
- evidence/checkpoints：实际2026.1综合/路由DCP；用于复核，不是板端发布制品。
- evidence：路由报告、原始日志、源/产物身份、打包输出与阶段记录。日志内原机器绝对路径仅作历史证据，不是新机器运行入口。
- HANDOFF_SHA256SUMS.json：本包逐文件清单；verify_handoff.py校验本包及冻结runtime身份。SHA清单用于完整性校验，不是签名。

未打包Vivado生成工程、缓存、工具安装库、训练声音、个人原始录音、登录信息或GPU/Agent/Studio源码。AMD IP由接收方合法Vivado2026.1环境重新生成；保持第三方来源及许可证。

## 解压与复建

解压到本地短路径，例如E:/voice26/voice_native2026_20261005。在**解压后的包根目录**运行。Python校验仅用标准库：

```powershell
python -B verify_handoff.py
vivado -mode batch -source board/pynq_z2/scripts/voice_p1_handoff.tcl -tclargs prepare
vivado -mode batch -source board/pynq_z2/scripts/voice_p1_handoff.tcl -tclargs smoke
vivado -mode batch -source board/pynq_z2/scripts/voice_p1_handoff.tcl -tclargs capture
vivado -mode batch -source board/pynq_z2/scripts/voice_p1_handoff.tcl -tclargs synth
vivado -mode batch -source board/pynq_z2/scripts/voice_p1_handoff.tcl -tclargs route
```

vivado必须是2026.1并可在终端调用；否则使用本机vivado.bat的完整路径。若环境里设置了VOICE_P1_ACTION，先删除它，避免覆盖-tclargs。入口自动定位解压路径，无需原E:/vvgvoice目录或voice-view-game仓库。prepare仅用于新目录，已有xpr会拒绝覆盖。每条命令使用独立batch会话；synth先于route。上述流程保留发布阻断，不导出bit/HWH/XSA。

两个有界测量入口：

```powershell
vivado -mode batch -source board/pynq_z2/scripts/voice_p1_handoff.tcl -tclargs profile_frontend
vivado -mode batch -source board/pynq_z2/scripts/voice_p1_handoff.tcl -tclargs profile_feature
```

完整数值测试入口是-tclargs full。完整链375.525us短测运行约11-13秒，完整2秒测试可能耗时很长；这个短测速率不能视为完整帧负载的实测时长。测试台watchdog为2.2秒**仿真时间**，不是墙钟时限。必须取得VOICE_P1_PCM_PROTOCOL_PASS、192000B方波PCM和31040B特征，且无Fatal/Error；退出码0、packer PASS、startup PASS均不能替代完整链验收。

## 接着做什么

1. 补齐每阶段墙钟/CPU测量和低频进度，保持原48kHz/40MHz节拍、背压及断言，完成静音和96000PCM整链。
2. 用队友授权的2024.1同刺激、同ROM/model配置输出逐记录8个uint64精确比对；2026输出不自作跨版golden，模型不重训。
3. 先查TIMING-18四个I/O延迟，再查TIMING-24三条被异步clock_groups覆盖的max_delay；CDC-15的57项XPM FIFO警告逐类核查。DDR负DQS preset保留并核对来源，不盲目清零或降低severity。
4. 核查BRAM复位/访问与重复capture/停止路径；有证据的局部修复后重跑相关回归及独立路由签核。
5. 数值/跨版/路由门禁满足后再生成匹配bit/HWH/XSA和新身份清单，最后实板验证。P2流式及合并Overlay不在本包已完成范围。

原独立声音使用HP0，DMA/GPIO/Codec地址分别0x40400000/0x41200000/0x43C00000。算法40MHz、AXI100MHz、MCLK10MHz；48kHz PCM抽取6到8kHz，512点窗/32步进，2秒485条，每条64B。wrapper默认985，复建入口显式485。不得直接套用默认wrapper或将本包当声音/GPU合并工程。

错误与修正按evidence/2026-10-05_pynq-z2_voice_p1.md追加轮次记录，MCP的SKIPPED重复保护不算实际执行。原始报错保留，修复需同检查复验。