# 实际模块复现实验

在此目录运行（Python 3.11，Vivado/XSim 2026.1）：

```powershell
python -X utf8 -B run_validation.py --out C:/fpga_checks/upload_01 --vivado "D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat"
```

把输出位置和 Vivado 路径替换为本机路径。输出目录必须不存在，建议使用短英文路径。
脚本从自身位置寻找包内工具和输入，依次执行原版校准、A、B 的保持性检查和原数据包
测试，共六次仿真。无需板卡、VS Code、MCP、原作者工作目录或第三方 Python 库。

预期：原版及 A 通过，B 被定位为 completed_crc32 复位差异，三份原数据包断言均通过。
这些预期全部满足时 `result.json` 的 status 为 PASS，入口返回 0。检查每项结果、
原始日志和 `receipts.json`；B 的单项 verify 返回 1 正是故障检测成功。
每个 Vivado 命令最多等待 600 秒，单次实验按顺序执行，不连接硬件。

`evidence/consumer/` 保存独立使用者首次执行的原始记录；其中绝对路径是历史
执行位置。直接复现使用上面的入口，它会重新生成当前路径的配置与日志。
`evidence/return_source/` 是报告所述完整优化验证的实测结果和原始报告摘选。

`inputs/` 来自本项目 `rtl/scene2d_gpu/scene2d_upload_sink.sv` 及其测试台，
A 为内部命名改写，B 为用于检验检测能力的单点故障。各文件来源和 SHA-256
见 provenance.json。自有 Skill 代码与工程验证素材采用本包 [MIT 许可](../LICENSE)；第三方内容保留原许可。

## 交付目录验证

整份目录已复制到独立位置，用上述便携入口完成六次仿真；全部预期匹配，
记录见 [delivery_replay/result.json](evidence/delivery_replay/result.json)。
安装工具路径由命令行传入，输入和校验器均从新副本读取。

从 skill 目录运行 `python -B validation/verify_files.py` 可核对交付文件摘要。
该命令只读文件；实际 HDL 实验使用上面的 run_validation.py。
