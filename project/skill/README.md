# PYNQ 开发技能包

技能包版本：0.2.3
署名：

本目录面向 PYNQ/Zynq 的 PL 开发验证与 PS/PL 集成排错，提供校验脚本和按症状
查阅的工程经验卡片。整体复制到新工程的 `skill/` 即可阅读与调用。

## 项目与适用范围

| 项目 | 官方形式 | 适用场景 | 输入与输出 |
| --- | --- | --- | --- |
| [pynq-pl-preserve](pynq-pl-preserve/README.md) | 校验脚本、配套工作流 | 单时钟自包含 PL 叶模块的等行为重构或优化 | 冻结原版、改动版、已有测试台和实例配置 → 全输出监视器、Vivado 脚本、日志与收据 |
| [pynq-debug-cards](pynq-debug-cards/README.md) | 踩坑清单 | PYNQ 工具、制品解析、启动连接、资源交接及最新数据消费 | 当前症状、版本和已有记录 → 核对路径、处理步骤及完成条件 |

## 目录对照

```text
skill/
  README.md
  report.md
  inventory.json
  format_check.json
  pynq-pl-preserve/
    SKILL.md
    README.md
    LICENSE
    scripts/
    references/
    examples/
  pynq-debug-cards/
    SKILL.md
    README.md
    LICENSE
    origins.json
    references/
    sources/
  validation/
    README.md
    run_validation.py
    verify_files.py
    inputs/
    evidence/
    provenance.json
```

SKILL.md 是模型入口；references/ 按任务读取；sources/ 是来源技术摘要；
validation/ 保存 PL 实验输入、原始日志与复现入口。

## 使用方法

### PL 校验

需要 Python 3.11 和 Vivado/XSim；实测 Vivado 2026.1、xc7z020clg400-1。
脚本使用 Python 标准库，可在配置好 Vivado/XSim 的开发环境独立运行。
从 `skill/` 执行，输出目录必须不存在；vivado 可替换为本机完整启动路径：

```powershell
python -X utf8 -B pynq-pl-preserve/scripts/preserve.py build pynq-pl-preserve/examples/config.json --out outputs/example_good
vivado -mode batch -source outputs/example_good/run.tcl
python -X utf8 -B pynq-pl-preserve/scripts/preserve.py verify outputs/example_good
```

成功时输出 PRESERVATION_UNDER_SUPPLIED_STIMULUS_PASS，并生成 verified.json。
故障检测示例及自己模块的配置步骤见 [使用说明](pynq-pl-preserve/README.md)；
实际上传模块的一键复现实验见 [验证入口](validation/README.md)。

### 排错经验卡片

进入 [卡片索引](pynq-debug-cards/SKILL.md)，根据症状选择工具、制品、启动、交接
或实时输入的一组卡片，核对条件后按处理步骤执行，以卡片的完成条件收口。
模型读取 SKILL.md 后按症状加载相关组，人工也可直接阅读。卡片将已有工程
观察整理为条件核对、处理步骤和完成检查，使用者据此验证当前工程。

### 与 AMD ROSS 联合使用

ROSS 提供 Vivado 会话与工具执行接口，本包提供与任务相关的诊断、行为比对和结果验收方法。按 [联合工作流](pynq-debug-cards/references/ross_workflow.md)核对会话与阶段、读取完整日志、验证输出和正式制品。增加流水等有意改变延迟的优化采用同输入有序输出/CRC 检查；保持周期行为的自包含叶模块使用 `pynq-pl-preserve`。各方法依据工程改动选择，工具调用与设计结果分别核验。

## 失效条件与适配

| 项目 | 不适用或需要适配的条件 | 处理方式 |
| --- | --- | --- |
| PL 校验 | 接口/周期行为有意改变，多时钟、子 IP、共享宏/include、复杂层级或不支持的端口类型 | 按新规格建立预期结果，或选择支持对应结构的验证方法；语法范围见配置说明 |
| PL 校验 | 激励未覆盖改动，或原版本身有算法错误 | 补充激励和算法参考；本工具检查指定实例及实际边沿采样，资源、时序和实板按对应流程验证 |
| 卡片 | 当前工具/驱动版本、owner 或症状与案例条件不同 | 核对当前源码和回执，选择匹配分支；地址、超时、IRQ 和进程身份采用当前工程值 |
| 卡片 | 多种因素可能产生相同症状 | 按诊断分支逐项收集证据，确定修复对象后验证 |

## 已验证效果

| 项目 | 可核查结果 | 证据 |
| --- | --- | --- |
| PL 校验 | 实际上传模块正确变体通过，复位值错误在 5.001 ns 定位到 completed_crc32；补充包完成断言之外的复位检查 | [报告](report.md)、[原始记录](validation/evidence/consumer) |
| PL 校验 | 独立使用者完成配置；目录迁移后六次仿真均符合预期 | [搬迁结果](validation/evidence/delivery_replay/result.json) |
| PL 校验 | 实际返回源优化完成 28,761 次附加全输出比较，并保留资源与时序报告 | [返回源证据](validation/evidence/return_source) |
| 卡片 | H13 复用已运行实例，H15 通过幂等释放恢复交接，H17/H18 修正最新帧消费与输入语义边界 | [卡片处理效果](pynq-debug-cards/README.md)、[逐卡来源](pynq-debug-cards/origins.json) |

## 提炼来源与迁移

PL 校验来自重复编写参考实例/端口比较，以及包完成断言漏检复位输出、工具正常
退出但日志包含运行错误等观察。卡片沿用 E01–E12，并归纳 H13–H20 后续工程经验，
共 20 张，来源技术摘要与文件校验值随包保存。详细方法与提炼过程见 [report.md](report.md)。

换题目时，PL 校验替换源码、测试台、参数和器件配置；卡片按实际工具版本、
部署入口、驱动与资源 owner 适配，不依赖游戏素材、固定 IP 地址或机械动作编号。

## 完整性、许可与官方格式

运行 `python -B validation/verify_files.py` 核对文件摘要。两个自有技能包均采用
MIT，LICENSE 在各自目录，署名留空。验证素材的来源与许可范围见
[验证说明](validation/README.md)。

依据 [官方自主选题指南](https://gitee.com/Vickyiii/fpgachina26-amd/blob/master/tracks/open-topic/GUIDE.md)
的“技能包”要求，逐项提供适用范围、用法、失效条件、效果和来源，采用推荐的
skill/README.md 入口，子目录按能力组织。
目录采用英文命名；README.md、SKILL.md、LICENSE 沿用工具与许可文件的标准名称，
完整命名清单见 [format_check.json](format_check.json)。

本包自有代码、文档及验证素材统一采用 [MIT](LICENSE)，第三方内容保留原许可。
