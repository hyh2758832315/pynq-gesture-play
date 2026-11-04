# PYNQ-Z2 P4 上传与渲染重叠离线验收

## 文档标识

| 字段 | 内容 |
| --- | --- |
| 文档类型 | 项目级离线构建与复验事实记录 |
| 当前文件路径 | docs/bringup/2026-10-04_pynq-z2_gpu_upload_overlap_p4.md |
| 所属项目 | voice-view-game |
| 板卡/器件 | PYNQ-Z2 / xc7z020clg400-1 |
| 阶段/日期 | P4 / 2026-10-04；构建于2026-10-03开始 |
| 最终结果 | PASS：功能、软件、同钟核心OOC、整机与产物身份离线闭合 |
| Skill源 | xilinx-skill/plugins/xilinx-suite/references/vivado_guide.md |
| 部署副本 | C:/Users/developer/.agents/skills/xilinx-suite/references/vivado_guide.md |

## 目标与边界

同Palette/Asset/Tilemap generation的一帧Scene预上传与当前渲染重叠，最多一个READY；复用两份4KiB命令bank及原framebuffer，无新增素材存储或绘图引擎。完成结果保持到present及软件release后再启动后帧。Scene ABI1.0、GameSDK1.1及原MMIO地址保持；P4 profile使用配套驱动，默认关闭硬件选项。资源更新先drain并等待generation实际提交，VIDEO每帧asset更新保留串行。

本轮为离线门禁，未上板、未commit/push。同板实时视觉、声音、游戏及Studio最终端到端验收独立进行。

## 基线与配置

P3b C0060750：14610 LUT、23044 FF、7421 Slice、60 BRAM、2 DSP、2 MMCM，WNS/WHS=0.073/0.052 ns。

P4 C0060760：render=100MHz、pixel=74.25MHz；六P3开关及UPLOAD_RENDER_OVERLAP_ENABLE=1；Performance_ExplorePostRoutePhysOpt、后布线AggressiveExplore、jobs=1。预算15110 LUT、23844 FF、60 BRAM、2 DSP、2 MMCM，WNS/WHS均须非负。保留原DRC/methodology/CDC和内部未约束路径边界。

独立脚本：board/pynq_z2/scripts/build_c6i_upload_render_overlap_p4.tcl。独立输出：board/pynq_z2/output/gpu_upload_overlap_experiment。overlap_control_gpio=0x413C0000/64KiB：ch1偏移0 bit0 release toggle；ch2偏移8 bit0..7为credit/READY/FILLING/hold/presented/consumed_toggle/resource_idle/generation_reject，31:8=0。

## 已通过门禁

- 原始失败及修复逐轮保存在2026-10-03_pynq-z2_gpu_parallel_optimization.md；CLEAR保留字段、NBA前握手及router核心末拍接受判据修复已复验。
- done边界修复仅P4 renderer_start增加!renderer_done，阻止busy撤销到hold锁存间隙启动READY；原默认关闭条件保持。
- results/gpu-stage4-verify-1791042086109：实际410.718秒/exit0，18份独立日志，无Fatal/Error/watchdog。off/on完整320×180扫描、bank锁定、CLEAR/FILL/Blit/Tile/掩码/错误前缀及资源更新通过。
- 重叠黄金：两模式均57602写，CLEAR CRC=A0708AC3、FILL CRC=3094986A；off=0拍/on=520拍真实上传与renderer_busy重叠。full_queue/early及repeat release/resource_fence/三类generation拒绝/partial reset通过，最后字节读回11次。
- 软件选定10文件最终128 passed、4 subtests passed、38.98秒；随后新增DMA未停时Shell保留sink引用，四相关文件87 passed/3.92秒。sink票据有界、计数回绕/重复seq及错误关闭保持。
- 真实Shell默认仅经BUILD_ID/HWH/manifest能力确认后开启流水；工作线程存活时保留共享sink，已退出时继续清理并保留首异常，sink.close失败同样保留引用。
- 旧20个bit/HWH/XSA/manifest SHA逐项与冻结值相同。第一次核验的P3a manifest期望手录63字符已按原冻结表修正；增加期望64字符检查后20/20通过，产物未修改。
- GPIO C_DOUT_DEFAULT={0}真实配置失败，PG144要求十六进制；改{0x00000000}后当前BD真实读回1/1/0x00000000/1/1/32通过，随后重跑整机。

## 执行与失败证据

主session vivado-20261003-230743-067479f3，日志results/.vivado-ai/vivado_40063068_4c48b71a.log。第二轮整机source实际2141.532秒/exit0，已导出四产物；不使用阻塞watcher或Sleep循环。额外收尾查询引用已关闭设计的对象报Common17-53 No open design；保留原查询失败，改用保存的setup_wns/hold_whs/drc_failures/resource_limits读取，实际0.029/0.052、DRC_FAILURES=0、METHODOLOGY_CRITICAL=0及原预算，P4参数已消费，BUILD_ID/P4_ENABLE实际C0060760/1，无重跑构建。

辅助session vivado-20261003-235540-383c86bc，日志results/.vivado-ai/vivado_42940250_73a05fa0.log；OOC输出results/gpu-p4-core-ooc-1791043285582。两模式均六P3参数为1，100MHz及13.468ns像素时钟（Vivado 1ps精度），使用原异步时钟组意图；HD.CLK_SRC缺失警告为OOC边界，整机时钟树另行签核。

| OOC阶段 | WNS/WHS(ns) | 结果与证据 |
| --- | --- | --- |
| off默认route | 0.028/0.096 | 7263 LUT/7218 FF/3261 Slice/57 BRAM/2 DSP；off_*报告及off_routed.dcp，无DRC Error/Critical、内部未约束0 |
| on默认route | -0.006/0.100 | setup负余量8端点，尚未通过；on_pre_physopt_*报告及on_pre_physopt_routed.dcp保留 |
| off后布线AggressiveExplore | 0.028/0.096 | netlist未改，off_post_physopt_timing/utilization报告及DCP保留 |
| on后布线AggressiveExplore | 0.070/0.100 | 7422 LUT/7225 FF/3252 Slice/57 BRAM/2 DSP，on_*正式报告及on_routed.dcp保留；相对off +159 LUT/+7 FF，BRAM/DSP不变 |

on原始负路径为core/renderer/fill_x_reg[2]到core/renderer/command_index_reg[0]/CE，既有renderer控制路径；route命令exit0不等于时序通过。先保存失败证据，再执行后布线优化。所有重试保留原始报告，不覆盖失败DCP。

AggressiveExplore实际4.782秒/exit0，关键逻辑变换改善setup 0.076ns，无新增/移除单元；正式报告WNS/WHS=0.070/0.100。off同directive4.047秒/exit0，正余量使工具跳过优化，netlist保持。时钟、RTL、例外和预算均未改变。aux任务已全部完成。差异检查首轮仅sink新增EOF空行导致exit1；两次CRLF末尾补丁仍保留空行，已有autopep8仅W391定向修正后git diff --check通过，不改代码行为或其他格式。

## 产物及收尾

整机最终14966 LUT、23374 FF、7538 Slice、60 BRAM、2 DSP、2 MMCM；相对P3b +356 LUT/+330 FF/+117 Slice，BRAM/DSP/MMCM不变。预算余量144 LUT/470 FF；保持100MHz/74.25MHz，WNS/WHS=0.029/0.052 ns，TNS/THS和失败端点均0。无额外memory或绘图引擎，无约束/时钟/预算放宽。

六报告目录：board/pynq_z2/output/gpu_upload_overlap_experiment/reports/c6i_upload_render_overlap_p4；utilization/timing_summary/drc/methodology/cdc/clock_interaction.rpt均保留。DRC无Error/Critical，DPIP-1 Warning4、DPOP-2 Warning2、REQP-165/181 Advisory各2；methodology无Critical，TIMING-28 Warning1、TIMING-47 Warning2、XDCB-5 Warning1。CDC原6个CDC-3 Info，原UserIgnored/Asynchronous Groups保持；内部unconstrained0、原4个output缺delay保持。

生成BD和HWH实际身份：core=scene2d_c4m7_core，BUILD_ID=C0060760、七开关均1，GPIO dual/ch1输出1bit/default0x00000000/ch2输入32bit，地址413C0000..413CFFFF；release/status端点、FCLK0 100MHz及peripheral_aresetn连接一致。P4会话须指定expected_build_id=0xC0060760，旧默认C0060700保持。

严格bit解析先使用旧P3b完整4045564字节及配置体SHA F2524503D00416664B7F354E5230299B1301CAC3F1C57C43575125AF3EE9D07C校准。产物核验首个PowerShell直接传三引号代码解析失败/exit1；改内存base64包装、同验证器现有.venv python -c复验exit0。仅读取，无新增脚本或依赖；ZIP CRC/重复成员、主HWH与完整bit配置体、BD/HWH/manifest参数及地址/连线全部通过。

P4配置体完整4045564字节，外部与内嵌SHA均DC6D10430556126D8086D02E2E01AD919E4D22999F10E91C576ADBA0557B90ED；两份头部202字节，差异位192/194/195在时间戳字段，配置体包括末尾八字节逐字节一致。XSA共16成员、唯一主c6i.hwh和唯一c6i_upload_render_overlap_p4.bit；主HWH与外部逐字节一致，其他3个HWH为SmartConnect子系统。

| 身份 | 字节数 | SHA-256 |
| --- | ---: | --- |
| 外部bit | 4045766 | 250A6C9ECBD07CB4AC5199AF2A3B2C72BDC4C40BA584243F607DAD542BDF4E36 |
| 外部HWH | 1211925 | 53DB00B3E6F50FB1F5D69A24F6BA3611706F6FEEB82FF2F8B0E08F034D7E2550 |
| XSA | 1160854 | EF187CFD5F4223606BF02A359D08B05D6A8164EBD172DAB4EF00AFF4698AE999 |
| manifest | 1610 | B8C70003E7972F46222D57357232DEAFAC7C1DF39CE65195ABA9CB5A1057F155 |
| XSA内bit | 4045766 | 5ADC05DA12C558E63B21FB7185CE62F05EC047C90449AE739854BC099649D0B2 |
| 生成BD | 143646 | 4209E73D18699D2AB094ABC52FAA4B131D63F886E3B4C92C95DA96E4AEED4525 |

### 关键源码冻结

| 文件 | SHA-256 |
| --- | --- |
| rtl/scene2d_gpu/scene2d_command_upload.sv | 339CA98A837B92E3BE8A9F93C0930761EC1CB1F66D78291CBB02BB83862715D8 |
| rtl/scene2d_gpu/scene2d_c4m3_core.sv | A245921FE8F41100629B799D963F4CE87D3F4E0E0A4A25CAAB180FCBDF89D0FA |
| rtl/scene2d_gpu/scene2d_c4m7_core.sv | 5C6C3044EA52B6808CA3781B7C2C00CF371F9A0F72EC692D7615463568AE442B |
| sim/scene2d_gpu/tb_scene2d_command_upload.sv | CAADEA1EC954C25095103E371BB5B55CDA0842F6FB7F3A283E389DB69851B87C |
| sim/scene2d_gpu/tb_scene2d_c4m7_core.sv | EEA96DB202ECDB98498BFD2CD07A6486663A22A722D687F74B6244ED00A3D85D |
| sim/scene2d_gpu/verify_tile_cache.tcl | ED8C86272D42DB20870FAF7D202A7957FCDB7EAA165D07FE826B6C69095E9296 |
| board/pynq_z2/scripts/build_c4m3.tcl | 4368745B412E95399C685173478F8B9647209E63DF9C24F45F785AD920F184DA |
| board/pynq_z2/scripts/build_c6i_upload_render_overlap_p4.tcl | C6FAB8B5FFF13C44B0A6148D33D566D78C38C326504947019BC59E27DFCB6F79 |
| python/pynq_multimodal_game/agent/c6i_video.py | 672B67F6427B6C4FE3939A66AD5DBF2114289D77E6228A87BF75537127CF1516 |
| python/pynq_multimodal_game/agent/c6i_backend.py | A13C54BD8DF20A01A48BB4E152741BE9CC2AFFE30195421A3EA99A226943F19C |
| python/pynq_multimodal_game/agent/game_runtime.py | 2C1A246DCF0522313E59F4F36A836E47D7D4A579BC85FFB85BD53762703B3CFA |
| python/pynq_multimodal_game/agent/c6i_shell.py | DCAB06161C290B18CA65C01504AA5D9D45750C1AFA68CF5CB4A2DBD12E954539 |

通用经验已更新仓库Skill源，使用install.ps1 -Skills xilinx-suite -SkipAgentInstructions仅同步选定Skill。实际安装exit0，OpenClaw未检测；SKILL.md源/部署SHA均41D6D8511EDE06B6F26E58A810E81A9E9228E0C874BAC9F16920B52FFB62B73C，vivado_guide.md均260E8546677E51BF3782712A992E6B9DC06BF618EE8E95B7D839369D18D69656。辅助会话所有任务完成后已关闭；主会话在收尾任务完成后关闭。P4离线PASS，实际板端并发和Studio端到端另行验收。
