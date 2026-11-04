# PYNQ PL Preserve

署名：

在优化或重构 RTL 时，复用现有测试台，对照冻结原版检查所有输出的周期行为。
适用于单时钟、独立完整的行为级叶模块。包内含模型入口、校验脚本、配置说明
和可直接运行的正／负示例；无需 Voice View 项目或它的历史工作目录。

## 快速运行

准备 Python3.11 与可用的 Vivado／XSim。实际验证环境为 Vivado2026.1、
xc7z020clg400-1；示例不进行综合、下载或上板。
在解压后的本目录执行，输出目录必须尚不存在：

```powershell
python -X utf8 -B scripts/preserve.py build examples/config.json --out outputs/example_good
vivado -mode batch -source outputs/example_good/run.tcl
python -X utf8 -B scripts/preserve.py verify outputs/example_good
```

将 `vivado` 替换为本机正确的启动命令；也可在自己创建的空闲 Vivado Tcl
会话中 `source` 生成的 run.tcl。不要与其他任务共享正在执行的会话。
成功时最后一条命令输出 PRESERVATION_UNDER_SUPPLIED_STIMULUS_PASS，
并生成 outputs/example_good/verified.json。完整原始日志保留在 simulation/。
这个计数器例子只演示工具使用，不代表资源优化收益。

再运行故意错误的复位例子：

```powershell
python -X utf8 -B scripts/preserve.py build examples/config_bad.json --out outputs/example_bad
vivado -mode batch -source outputs/example_bad/run.tcl
python -X utf8 -B scripts/preserve.py verify outputs/example_bad
```

此时应看到 PRESERVE_OUTPUT_MISMATCH，最后的 verify 应以非零退出，且没有
verified.json。这正是负例的预期结果。Vivado 命令退出0不等于验证通过。

## 用于自己的题目

1. 在改动前保留原版源文件；选择已有的、输入在采样边沿附近稳定的测试台。
2. 按 [配置说明](references/configuration.md)列出当前源文件、原版、顶层和待比较
   实例的层级路径，明确全部参数、时钟／复位、正常结束标志和足够的采样下限。
3. 先用未修改 RTL 校准绑定，再对改动版使用新输出目录构建、运行和验证。
4. 核对已有激励是否覆盖改动边界，补充缺失场景，并分别完成原功能、资源和
   时序检查。生成器不代写激励，不把原版本身当作算法正确性依据。

模型使用时读取 [SKILL.md](SKILL.md)。脚本只需标准库，源码路径相对配置文件
解析；生成文件和清单包含实际本机路径，不依赖作者原来的项目路径。搬迁后
重新 build 并运行，不能把旧目录中的历史收据当作新目录的验证结果。

## 适用边界和失效条件

- 当前支持一个时钟域、独立完整的叶模块，显式 ANSI 标量／打包 wire、logic、
  reg 端口和简单整数参数。支持常见 Xilinx 端口属性。
- 不支持子 IP、接口／结构体／非打包端口、复杂层级、包、共享头文件／宏、
  编译单元全局声明、DUT 文件／环境／随机依赖。明确拒绝这些输入，避免原版
  参考和改动版共用已变化的依赖而误报。源码扫描不是完整编译器或符号解析器。
- 检查所有声明输出，包括复位、空闲和 VALID 为低时的数据；只适合要求这些
  行为保持不变的任务。功能／接口有意变化时，应选择与新合同相符的验证方法。
- 结果限于列出的实例、实际激励和边沿后采样。不是形式等价、CDC／毛刺、
  整 Overlay 时序或实板验收。外部测试数据与工具环境不由 HDL 清单自动认证。

拒绝输入表示该检查器不适用，不代表工程无法实现。应继续使用合适的冻结参考
和验证流程完成任务，不能删除检查或修改受保护输入来制造通过。

## 已验证效果与来源

本工具从 PYNQ PL 开发中重复编写参考实例、端口比较和仿真结果检查的工作中提炼。
复用已有激励，自动检查复位、空闲和有效传输期间的全部输出，并保存源文件摘要与运行收据。

独立使用者使用包内说明完成了实际上传模块的配置和运行：正确变体通过，复位值
错误在 5.001 ns 被定位到 completed_crc32；原有包完成测试均通过。
包内计数器正例和故障例、实际返回源优化后的完整验证也已运行。
完整提交目录的 report.md 与 validation/ 给出实验方法、日志和一键复现入口。

许可见 [LICENSE](LICENSE)：MIT。署名留空。该许可用于本技能包，
工程验证素材的来源与许可范围见提交目录 validation/README.md。
