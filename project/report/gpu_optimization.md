# 二维 GPU 优化与验证

GPU 在 PL 内执行 Scene 指令，PS 保持原有资源上传、命令提交及完成握手。优化不改变寄存器映射、指令编码、BUILD_ID `0xC0061000` 或图像格式；每份硬件以配套 bit/HWH/XSA 和文件摘要区分。

## 三种可重建配置

| 构建配置 | 描述符缓存 | Blit/Tile 像素流水线 | 条件双像素写入 |
| --- | --- | --- | --- |
| `baseline` | 关 | 关 | 关 |
| `cache_pipeline` | 开 | 开 | 关 |
| `cache_pipeline_pair` | 开 | 开 | 开 |

三种配置的上传/渲染重叠均关闭。条件双像素包括 Tile、Blit 及 Clear/Fill；不满足对齐、边界或有效像素条件时按单像素路径处理。透明像素使用独立写入掩码，裁剪、翻转、奇数尾像素和资源更新语义保留。

优化按数据复用、阶段并行、写入吞吐三个层次展开：

1. **描述符缓存**：同一 Tile 内复用描述符，省去逐像素重复取数与解析；每次新绘制命令使缓存失效，保证后续资源更新可见。
2. **像素流水线**：将请求坐标、索引选择和目标地址随有效位传递，使取数、解析与写入阶段连续推进。
3. **条件双像素**：利用索引色的相邻像素打包形式，在对齐且未跨越边界时并行提交两个像素；透明像素分别控制写使能，奇数尾像素沿用单像素路径。

三层设计共同减少核内等待，同时沿用原有帧缓冲拥有权和帧边界提交机制。PS 软件与 HDMI 输出时序共用，便于在相同应用下更换 GPU 配置。

## 相同输入的周期比较

Vivado XSim，100 MHz，实际发布 RTL、相同测试台与相同输入。下表单位为周期；乘 0.01 得到微秒。全部13组对照的输出 CRC 和像素写入数量一致，测试台同时检查预期输出。

| 场景 | 原配置 | 缓存＋流水线 | 再加条件双像素 | 原配置/三项优化 |
| --- | ---: | ---: | ---: | ---: |
| 小型 Blit | 97 | 44 | 40 | 2.43× |
| Blit 混合指令 | 138 | 90 | 87 | 1.59× |
| Tile 更新场景，第0帧 | 301 | 205 | 197 | 1.53× |
| 32×16 Tile，不透明 | 4653 | 813 | 557 | 8.35× |
| 32×16 Tile，透明掩码 | 4653 | 781 | 525 | 8.86× |
| 320×180 清屏/矩形/Blit，第0帧 | 58929 | 57909 | 28974 | 2.03× |

32×16 不透明 Tile 的核内耗时由 46.53 μs 降至 5.57 μs，减少 **88.03%**；320×180 混合光栅场景由 589.29 μs 降至 289.74 μs，减少 **50.83%**。缓存和流水线对描述符密集的 Tile 场景收益突出，条件双像素进一步改善大面积写入。

计时范围为 GPU 从绘制开始到完成的核内周期。相机、PS 调度、上传与显示等待由系统运行另行测量。完整逐帧数据见 [measurements.csv](../data/gpu_optimization/measurements.csv)，各组 CRC、写入数和仿真完成标记见同目录的六份文本记录。

## 完整实现资源与时序

PYNQ-Z2 / xc7z020clg400-1，Vivado 2026.1，控制时钟100 MHz。

| 配置 | LUT | FF | Slice | BRAM36等价 | DSP | WNS / WHS（ns） |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 原配置 | 32570 | 47672 | 13136 | 89.5 | 20 | +0.011 / +0.050 |
| 缓存＋流水线 | 32268 | 47402 | 13145 | 89.5 | 20 | +0.002 / +0.032 |
| 再加条件双像素 | 32860 | 47464 | 13178 | 87.5 | 20 | +0.001 / +0.050 |

三项优化相对基线增加 290 个 LUT（0.89%），减少 208 个 FF 和 2 个 BRAM36 等价块，DSP 保持 20。表中为完整系统布局后的用量，包含视觉、渲染、接口及控制模块。

三种配置均完成布线，布线错误为 0，DRC 无 Error／Critical Warning；已约束路径的 TNS、THS 均为 0，WPWS 均为 +0.538 ns。三项配置的 Slice 占用为 99.08%，WNS 为 +0.001 ns。原报告保留异步控制、I/O 延迟等检查项，后续扩展可据此评估布局及约束。

[完整实现报告](../build/reports/gpu_optimization/)提供三配置的资源、时序、布线、DRC 和总线偏斜报告；[资源表](../data/gpu_optimization/resources.csv)可直接用于作图。报告仅清理本机标识与绝对输出路径，数值、路径分析和警告保留；`provenance.json` 记录原件与发布件摘要。

## 复现

从 project 目录执行：

```powershell
python -B sim/gpu_optimization/generate_vectors.py
vivado -mode batch -source sim/gpu_optimization/run_compare.tcl -tclargs build/output/gpu_comparison_01
python -B sim/gpu_optimization/summarize.py build/output/gpu_comparison_01
vivado -mode batch -source build/scripts/build_hardware.tcl -tclargs build/output/gpu_pair_01 cache_pipeline_pair
python -B tools/check_hardware.py build/output/gpu_pair_01/result
python -B sim/evidence/gpu_optimization/replay_pc.py --out build/output/game_compare_01
```

把构建参数改为 `baseline` 或 `cache_pipeline` 可重建其余配置。每次使用新的输出目录。构建按所选参数重新生成 BD、全量综合和实现，再从通过检查的布线结果导出 bit/HWH/XSA。三配置的相同输入仿真已从独立源码包再次运行，13 组周期和图像校验结果与首次实验一致。

## 板端验证

两种优化配置均通过 Studio 标准安装和启动，内容库保持完整，灵巧手正常初始化。真人短测覆盖菜单握拳选择、游戏移动／跳跃、返回与灵巧手三态连续切换；两轮反馈均为“操作、画面和灵巧手均正常”。真人测试期间关闭回传，未注入测试输入。

三项配置另完成四个游戏的 PC／PYNQ 同包、同输入回放：

| 游戏 | 一致的逻辑 tick | 通过断言 | 结果 |
| --- | ---: | ---: | --- |
| Game1 | 181 | 4 | 通过 |
| Game2 | 959 | 12 | 通过 |
| Game3 | 150 | 4 | 通过 |
| Game4 | 301 | 4 | 通过 |
| 合计 | 1591 | 24 | 通过 |

回放核对逐 tick 状态与场景输出；HDMI 画面和实体动作由上述真人验收确认。测试结束后通过 Studio 正常停止：视觉资源已释放，串口已关闭，17 个电机均确认卸力。

[板测摘要](../sim/evidence/gpu_optimization/board_acceptance.json)保存硬件及运行包摘要、启动、真人验收与停止结果；[回放摘要](../sim/evidence/gpu_optimization/game_replay_summary.json)关联原始 PC／PYNQ 报告、输入与实际测试包。随附 `fixtures/` 为当次已安装的四个小型源码游戏包，可用上面的 `replay_pc.py` 在本机重新比对已记录的板端输出。
