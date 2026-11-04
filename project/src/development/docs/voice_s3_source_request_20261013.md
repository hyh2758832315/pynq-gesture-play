# S3 匹配音频源工程补交清单

## 最新接收状态（2026-10-13）

匹配的最小硬件源已补交并通过本地离线核验。来源commit fd998c9ddd9559bc89135fa4f273afe9119dd8e4，远端说明AUDIO_HW_SOURCE_20261013.md，源码ZIP SHA e3f3dbc36b8a3cedfbccdda53db796559605c2b758a49551e31754f5bc0b1a50。

独立接收根E:/projects/fpga/voice-view-game-audio-hw-source-20261013/source/audio_hw_source_20261013；50文件/49项清单SHA、7RTL、原生BD/13XCI、XDC及两项窄约束、项目设置与重建入口通过静态核验。原bit/HWH与原BD精确配对，10项DMA参数、5bit IRQ、地址及状态ABI一致。

“缺匹配源码”门禁已经解除；本地Vivado2026.1原生BD+XCI create已实际退出0，ERROR/Critical Warning均0，11条普通Warning保留。重开10项DMA/5bit IRQ、13XCI全部参数和BD六项结构等价核验通过，原来源SHA保持；当前门禁LOCAL_CREATE_VERIFIED_FULL_BUILD_PENDING。下一项为完整综合实现、融合设计及安全签核，本轮未上板。单独回放BD Tcl曾丢失IRQ传播参数，默认继续使用原生BD+XCI。详见[独立重建记录](bringup/2026-10-13_voice_s3_recreate.md)及[R08–R12接收记录](bringup/2026-10-13_voice_s3_source_audit.md)。

后续完整构建已通过：原build分支实际479.626秒/退出0，routed WNS1.847ns、WHS0.029ns，参考bit/HWH独立导出；生成13模块全部1745参数与原参考一致，源49SHA保持。最新门禁LOCAL_REFERENCE_BUILD_VERIFIED_SIGNOFF_PENDING，IIC/I2S物理时序及DMA布局/BRAM审查、融合和板端仍待各自验收。详见[完整构建记录](bringup/2026-10-13_voice_s3_build.md)。前段create门禁保留为历史过程。

以下原补交表及R06缺项作为历史核对要求保留。旧DCP和旧生成HWH路径仍不在原交接副本中，完整源重建可以重新生成；原42项测试追溯继续独立pending，已完成295项本地软件回归保持。

## 配对身份

用途：将已验证的音频采集加入独立视觉/游戏/GPU融合候选。现用制品和旧交付保持封存，收到源工程后先做离线身份与依赖核验，再按独立授权构建和上板。

- 板卡：PYNQ-Z2；器件：xc7z020clg400-1。
- 固定交接commit：9212bf04e12fe6bdf3e006858beb1f5f9b7ce942。
- 原导出脚本要求：Vivado2026.1；请给出完整版本/build及实际构建环境。
- 原bit：audio_only_capture_test.bit，4045766字节，SHA256 `1444680f37c5f2490a0ed382e5e44440bcff7db69bfb5ebbffb9087c61c3d2d0`。
- 原HWH：audio_only_capture_test.hwh，498286字节，SHA256 `cf7a0d3af42a507731d36bcf591d5384efaf5543d761f8477d5d126d719fc34f`。
- 原executed_export.tcl：1299字节，SHA256 `931e1f480f3530333dbd945171d1b333ae941f37806236725b52d39c63eb8aef`。

请提交与以上制品对应的源码commit及完整相对路径SHA256清单。若采用修订设计，请单独给出新的commit、bit/HWH身份、变更说明和验收报告，保留上述原基线。

## 必须补交

### 最小构建入口与配对参考

要启动同板融合，至少需要完整capture RTL及其下层/数据依赖、BD重建Tcl或工程（含IP参数）、全部XDC、器件和工具版本。以上构成可编辑、可重建的源依赖闭包。

下表同时列出期望的原制品配对材料。旧routed DCP和旧生成HWH用于原导出复现，有完整源工程时可重新生成；旧实现报告可作为对照，新候选必须自行完成时序/CDC/DRC/资源及安全停机签核。42项原测试用于追溯队友原报告，与硬件构建入口分别验收。

2026-10-13 R06已完整接收并列导出副本：原清单33项SHA通过，70个磁盘文件及6个递归归档视图没有可编辑RTL/BD/XDC/IP工程。较早原并列仓库只有20261005声音交接，仍需与20261011 PCM SG版本匹配的源。软件算法、游戏候选及Windows/Linux3.10相关295项验证保持既有完成状态，不要求重复补交或重做声音算法。详见[R06接收记录](bringup/2026-10-13_voice_s3_source_audit.md)。

| 材料 | 内容与核验要求 |
| --- | --- |
| 完整RTL | voice_i2s_dma_capture_axi顶层、实现状态ABI1.1的模块、I2S接收、CDC/FIFO、PCM封包/TLAST、所有下层模块及include/mem/初始化数据。提供综合顶层、宏定义、文件顺序。 |
| BD与重建入口 | 原c6v.bd或可复现BD的Tcl、项目创建/源添加/生成/综合实现脚本及wrapper。完整配置PS、SmartConnect、DMA、IIC、clock/reset/IRQ及HP连接，使用明确相对路径。 |
| XDC | 板级引脚/电压、输入输出时序、所有时钟/生成时钟、CDC约束及例外。覆盖Codec/I2S和MCLK物理输出；说明例外适用路径及依据。 |
| IP依赖 | 全部VLNV、版本及CONFIG参数；定制IP源/IP-XACT；XCI/生成Tcl及相关数据。外部依赖固定commit和SHA，确认版本/许可/可再生成条件。 |
| 构建环境 | Vivado完整版本/build、器件/board files、操作系统、项目属性、实际命令；干净目录可重建路径，列出生成文件与外部缓存要求。 |
| 原实现证据 | 与制品同轮的综合/实现日志、资源、max/min时序、未约束路径、时钟交互、CDC、DRC/方法学结果和相关waiver。日志/报告提供SHA，说明实际执行命令。 |
| 驱动合同 | PCM数据布局/TLAST/有效字节、status寄存器和快照握手、epoch/overflow、capture请求/停止ack、SG descriptor/cache/DDR协议、Codec profile/PLL/MCLK及故障停机。 |
| 制品配对 | bit/HWH/XSA（若当轮已生成）、源commit、报告、命令与SHA清单相互关联。DCP可附加用于核对，完整RTL/BD/XDC依赖仍须补齐。 |

## 导出脚本的已确认缺项

现交接的executed_export.tcl打开既有DCP并复制既有HWH，没有源工程重建步骤。它引用的两条输入在reference_capture根下均不存在：

1. audio_only_dmafix_route_20261011/routed_NOT_DEPLOYABLE.dcp。
2. audio_only_20261011/c6_vision_integrated.gen/sources_1/bd/c6v/hw_handoff/c6v.hwh。

补齐这两项可恢复原导出输入；融合设计还需要上表完整可编辑源码。旧20261005 voiceP1/hybrid特征路径缺少与本次PCM SG制品的配对证据，单独保留参考。

## 需保持或显式评审的接口

以下是原单声音HWH与冻结驱动的静态合同，融合后须重新用候选HWH和实际硬件核验：

| 模块 | HWH类型 | 原地址窗口 |
| --- | --- | --- |
| voice_pcm_dma | xilinx.com:ip:axi_dma:7.1 | 0x40430000..0x4043FFFF |
| voice_capture | xilinx.com:module_ref:voice_i2s_dma_capture_axi:1.0 | 0x413E0000..0x413EFFFF |
| voice_codec_iic | xilinx.com:ip:axi_iic:2.1 | 0x43C10000..0x43C1FFFF |

DMA驱动要求：c_include_mm2s=0、c_include_s2mm=1、c_include_sg=1、c_m_axi_s2mm_data_width=32、c_s_axis_s2mm_tdata_width=32、c_sg_length_width=16、c_s2mm_burst_size=16、c_addr_width=32、c_sg_include_stscntrl_strm=0、c_sg_use_stsapp_length=0。descriptor为64字节，数据为3840字节，每项独立根分配、64字节对齐、地址位于映射DDR内；cache操作含必要barrier。停止未确认时保留buffer强引用及owner。

PCM标称48kHz、960样本/包，signed16符号扩展到32bit；CPU副本960个float64即7680字节。请给出声道/符号/端序/TLAST和采样率测量方法。标称值与采样率实测、真实source_age、20ms稳态性能分别验收。

状态驱动要求magic=0x56535431、ABI=0x00010001；快照请求/序号/observed、accepted、dropped计数一致，capture状态及hardware_epoch在多字读前后稳定，任何drop或epoch变更撤销旧输入。请提供各寄存器语义、复位与跨时钟握手证据。

Codec驱动要求AXI IIC2.1和IIC地址0x3B，完整profile、回读、PLL/时钟及初始化/停机条件。原导出脚本检查MCLK物理输出周期100ns（10MHz）；40MHz域、复位、CDC及与PS/DDR的连接由完整源和报告签核。

现用视觉HWH SHA为 `db3a40cb875e11d78f62b9b3359ba83891cc39a36b0451a9124677783328309d`，54模块；原声音HWH13模块。融合须保持GPU ABI1.0和视觉/HDMI路径，采用独立BUILD_ID/profile及制品配对；HP3只作为待评审选项，不预先当作已签核连接。

## 接收顺序与边界

1. 校验来源commit、归档路径及逐文件SHA；完整列明外部依赖和生成文件。
2. 静态核对顶层/BD/IP/XDC、寄存器/PCM/Codec合同与现用地址占用。
3. 确认完整构建环境及独立构建授权，先重建单声音来源再评审融合候选；保存原始日志和配对身份。
4. 时序/CDC/DRC/资源及安全停机门禁通过后，另行受控上板，执行18秒/900包、动作/Scene/HDMI和释放检查。

42项原测试的源码、用例、命令与原日志另行补交，用于复核队友原报告，不以现有平台295项测试替代其身份。

本轮仅完成来源预检；board_pending=true，release_ready=false。PYNQ ARM、采样率、新鲜度、识别质量、真实时延、HDMI及长稳态保持各自验收状态。证据见[本轮记录](bringup/2026-10-13_voice_s3_source_audit.md)。