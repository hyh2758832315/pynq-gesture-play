# PYNQ PL Preserve

署名：

在优化或重构 RTL 时，复用现有测试台，对照冻结原版检查所有输出的周期行为。
适用于单时钟、独立完整的行为级叶模块。包内含模型入口、校验脚本、配置说明
和可直接运行的正确变体／故障变体示例，可独立用于其他 PL 工程。

## 快速运行

准备 Python3.11 与可用的 Vivado／XSim。实际验证环境为 Vivado2026.1、
xc7z020clg400-1；示例在开发 PC 上完成 RTL 仿真。
在解压后的本目录执行，输出目录必须尚不存在：

```powershell
python -X utf8 -B scripts/preserve.py build examples/config.json --out outputs/example_good
vivado -mode batch -source outputs/example_good/run.tcl
python -X utf8 -B scripts/preserve.py verify outputs/example_good
```

将 `vivado` 替换为本机正确的启动命令；也可在自己创建的空闲 Vivado Tcl
会话中 `source` 生成的 run.tcl，同一会话中的任务按顺序执行。
成功时最后一条命令输出 PRESERVATION_UNDER_SUPPLIED_STIMULUS_PASS，
并生成 outputs/example_good/verified.json。完整原始日志保留在 simulation/。
计数器示例展示配置和校验流程；实际 PL 优化的资源数据见技能包报告。

再运行复位值故障变体，验证差异检测能力：

```powershell
python -X utf8 -B scripts/preserve.py build examples/config_bad.json --out outputs/example_bad
vivado -mode batch -source outputs/example_bad/run.tcl
python -X utf8 -B scripts/preserve.py verify outputs/example_bad
```

预期出现 PRESERVE_OUTPUT_MISMATCH，verify 以非零返回值报告差异，保留完整日志。
校验结论由 verify 的输出、差异标记与日志共同确定；故障变体被检出即符合本例预期。

## 用于自己的题目

1. 在改动前保留原版源文件；选择已有的、输入在采样边沿附近稳定的测试台。
2. 按 [配置说明](references/configuration.md)列出当前源文件、原版、顶层和待比较
   实例的层级路径，明确全部参数、时钟／复位、正常结束标志和足够的采样下限。
3. 先用未修改 RTL 校准绑定，再对改动版使用新输出目录构建、运行和验证。
4. 核对已有激励是否覆盖改动边界，补充缺失场景，并分别完成原功能、资源和
   时序检查。生成器复用提供的激励；算法正确性通过功能规格与独立参考确认。

模型使用时读取 [SKILL.md](SKILL.md)。脚本使用标准库，源码路径相对配置文件
解析。迁移到新目录后重新 build、仿真和 verify，自动生成与当前源码及路径
对应的文件摘要和运行收据。

## 适用边界和失效条件

- 当前支持一个时钟域、独立完整的叶模块，显式 ANSI 标量／打包 wire、logic、
  reg 端口和简单整数参数。支持常见 Xilinx 端口属性。
- 不支持子 IP、接口／结构体／非打包端口、复杂层级、包、共享头文件／宏、
  编译单元全局声明、DUT 文件／环境／随机依赖。明确拒绝这些输入，避免原版
  参考和改动版共用已变化的依赖。涉及完整语言解析或符号求解时，采用对应的 HDL 工具。
- 检查所有声明输出，包括复位、空闲和 VALID 为低时的数据；只适合要求这些
  行为保持不变的任务。功能／接口有意变化时，应选择与新合同相符的验证方法。
- 检查范围为配置中的实例、实际激励和边沿后采样。形式等价、CDC／毛刺、
  整 Overlay 时序及实板功能分别采用对应检查；外部数据与工具环境另附身份记录。

遇到超出解析范围的输入，采用支持对应语言与依赖结构的验证工具，并保留独立
冻结参考、原始输入和同等检查目标。

## 已验证效果与来源

本工具从 PYNQ PL 开发中重复编写参考实例、端口比较和仿真结果检查的工作中提炼。
复用已有激励，自动检查复位、空闲和有效传输期间的全部输出，并保存源文件摘要与运行收据。

独立使用者使用包内说明完成了实际上传模块的配置和运行：正确变体通过，复位值
错误在 5.001 ns 被定位到 completed_crc32；原有包完成测试均通过。
包内计数器正例和故障例、实际返回源优化后的完整验证也已运行。
完整提交目录的 report.md 与 validation/ 给出实验方法、日志和一键复现入口。

许可见 [LICENSE](LICENSE)：MIT。署名留空。该许可用于本技能包，
工程验证素材的来源与许可范围见提交目录 validation/README.md。
