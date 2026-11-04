# 工程观察与验证摘录

# PYNQ-Z2 GPU 优化离线记录

## 文档标识

| 字段 | 内容 |
| --- | --- |
| 文档类型 | 项目级离线仿真与资源验证事实记录 |
| 当前路径 | `docs/bringup/2026-10-03_pynq-z2_gpu_parallel_optimization.md` |
| 项目 | voice-view-game |
| 板卡 / 器件 | PYNQ-Z2 / xc7z020clg400-1 |
| 日期 / 工具 | 2026-10-03 / Vivado、XSim 2026.1，Windows |
| 阶段 | P1：Tile 描述符缓存；P2a/P2b：Blit/Tile 单像素流水；P3a：Tile 双像素；P3b：Blit/CLEAR/FILL 双像素 |
| 当前结果 | P1/P2a/P2b/P3a/P3b/P4 离线 PASS；四阶段闭合，P4跨日最终证据见2026-10-04记录；上板与多模态并发待验证 |
| Skill 源 | `xilinx-skill/plugins/xilinx-suite/references/vivado_guide.md`、`board_bringup_record_template.md` |
| Skill 部署 | `C:/Users/developer/.agents/skills/xilinx-suite/`（由安装脚本同步，禁止直接编辑） |

## 基线与变更

冻结 C6I：BUILD_ID `0xC0060700`，整机 LUT 14025、FF 22845、BRAM Tile 62、DSP 2、MMCM 2，post-route WNS 0.057 ns、WHS 0.050 ns。基线报告保留原路径。

缓存默认关闭；复用已有描述符寄存器，新增有效位和完整逻辑地址标签。复位及接受新命令时失效，合法 descriptor miss 填入缓存，hit 跳过读取等待。尺寸、透明、翻转、裁剪、opcode、ABI、素材容量保持现有契约。参数沿 renderer、C4M3、C4M7 传播。

## 执行记录

### P4 实施入口与首片复验

P4最终离线PASS：第二轮整机source2141.532秒/exit0，14966 LUT/23374 FF/7538 Slice/60 BRAM/2 DSP/2 MMCM，WNS/WHS=0.029/0.052 ns；十八RTL矩阵、软件128+4及关闭安全增量87例、同钟核心OOC、六质量报告、新产物严格身份通过。旧20产物保持，经验Skill已同步SHA核验。完整结果及源码/产物SHA见[2026-10-04验收](2026-10-04_pynq-z2_gpu_upload_overlap_p4.md)。下列历史PENDING保留为当轮发生状态及失败证据。

P4整机首轮source实际11.514 s/exit1，原日志 `results/.vivado-ai/vivado_40063068_4c48b71a.log`：IP_Flow19-3478指overlap_control_gpio/C_DOUT_DEFAULT必须0x前缀，Common17-39 set_property失败，尚未进入综合/实现/产物导出。PG144 Default Output Value/User Parameters官方查询证实默认0x00000000。修复common仅将{0}改{0x00000000}，先在当前BD做真实参数读回复验，再重新source；不把代理dry-run当IP验证，复验PENDING。独立OOC代理因自身无tool_search未启动，未有报告，不计PASS，主另开会话执行。

完整320×180新增边界实际61.890 s/exit0，`results/gpu-upload_overlap_unit-verify-1791041904392/`，黄金写数/CRC与off一致、on520拍重叠，full_queue/early_release/resource_fence/三个generation_reject/partial_reset全PASS，last_byte=11。最终stage4兼容矩阵实际410.718 s/exit0（MCP已idle，queue0），包括off/on完整扫描与边界、命令bank、CLEAR/FILL/Blit/Tile/透明掩码/错误前缀及资源代次更新，不以软件fake代替RTL。

软件主执行选定10文件pytest实际114 passed/4 subtests passed/37.61 s。软件只读审计发现默认真实Shell工厂未传P4启用标志及drain异常会阻断共享sink安全close，代理局部修复后四文件86 passed/exit0；首轮85 passed/1 failed/exit1系新增关闭故障注入测试时序，修刺激不降断言后复验，原始细节以代理终端记录为准。Shell默认仅在session能力接口严格True时自动启用，显式False保留同步；线程仍存活则保留sink，已退出时保留首异常并继续安全清理。只读旧20产物检查代理遭^C中断，无可用核验结果，不计PASS，待主复核。

P4独立构建入口已新增 `board/pynq_z2/scripts/build_c6i_upload_render_overlap_p4.tcl`，BUILD_ID=C0060760，输出gpu_upload_overlap_experiment；common消费/unset新参数并读回CONFIG，仅P4新增0x413C0000双通道overlap_control_gpio，六P3开关及P4均1。保持100/74.25 MHz、Performance_ExplorePostRoutePhysOpt/AggressiveExplore/jobs1及15110/23844/60/2/2预算。代理Tcl8.6四配置内存dry-run通过（第一验证器索引断言修正后复验），实际Vivado整机及同钟OOC、20旧产物保护和新封装身份仍PENDING，未上板。

完成边界修复同场景实际50.589 s/exit0，目录 `results/gpu-upload_overlap_unit-verify-1791041255628/`。off/on均writes=57602、clear_crc=A0708AC3、fill_crc=3094986A；实际overlap beats分别0/520。前述三次失败的两处TB刺激/采样修复及done窗口修复均已复验通过；仍需新增边界与完整扫描、软件及独立整机资源门禁，尚未P4 PASS。

第三轮实际52.032 s/exit1，目录 `results/gpu-upload_overlap_unit-verify-1791041127992/`：off通过，on越过完整520拍并行判断，2 ms watchdog记录render=4/present=2/status=0。局部控制证据：renderer结束时busy先归零/done置1，core在下一posedge才锁存hold；READY帧在该边界满足旧start条件，早于hold启动并使两个frame_swap请求toggle可在像素侧确认前抵消。修复仅P4启动门控增加!renderer_done，保持旧模式条件；同场景复验PENDING。前轮核心末拍等待修复已越过原断言，保持520严格判据。

启用场景第二轮实际50.360 s/exit1，目录 `results/gpu-upload_overlap_unit-verify-1791040999298/`：off通过，on旧两帧黄金通过后56670 ns报next Scene upload did not overlap long render。TB在上游TLAST握手后立即检查核心累计计数；实际axis_demux有m_axis寄存和temp skid，核心末拍尚未消费。先记录，拟等待核心accepted_packet_count真实增加再判断完整520拍和当前渲染未完成，不降低断言或旁路router；复验PENDING。

command bank首片修复复验实际16.980 s/exit0，目录 `results/gpu-command_overlap_unit-verify-1791040140837/`，off/on黄金及on完整520拍读写隔离通过。软件代理首片未运行pytest，由主实际执行test_c6i_video_sink得到26 passed/0.95 s。核心集成后默认关闭4组raster_core_unit实际107.425 s/exit0，目录 `results/gpu-raster_core_unit-verify-1791040768488/`。

P4启用场景首轮实际28.833 s/exit1，目录 `results/gpu-upload_overlap_unit-verify-1791040918115/`，off旧两帧PASS后46975 ns报serial CLEAR completion mismatch；新TB共用CLEAR/FILL构包时将2×1尺寸写入CLEAR，违反原command_malformed要求CLEAR words2/3=0。先记录后仅修刺激尺寸，原RTL校验保持；on尚未运行，复验PENDING。首次集成patch曾因atlas_read_index实际4bit与上下文8bit不符被工具拒绝，修正context后应用成功，未把失败patch当编辑证据。

首片默认关闭command read bank覆盖、原上传TB扩不同bank数据和520拍读写重叠检查；runner scope command_overlap_unit。首次实际25.600 s/exit1，目录 `results/gpu-command_overlap_unit-verify-1791040083053/`；off通过，on未报数据错但Fatal concurrent read coverage=519（83655001 ps）。TB在NBA后读取upload_sink末拍更新后的tready，漏计真实末拍握手；先记录再将握手采样置于posedge前NBA窗口，数据仍NBA后比较。修复复验PENDING，未称P4完成。

### P3b 最终离线闭合

| 项目 | P3a | P3b | 增量 |
| --- | --- | --- | --- |
| LUT | 14550 | 14610（27.46%） | +60 |
| FF | 23005 | 23044（21.66%） | +39 |
| Slice | 7386 | 7421（55.80%） | +35 |
| BRAM Tile | 60 | 60（42.86%） | 0 |
| DSP / MMCM | 2 / 2 | 2 / 2 | 0 / 0 |
| WNS / WHS ns | 0.116 / 0.017 | 0.073 / 0.052 | 两项均满足 |

相对冻结C6I累计+585 LUT/+199 FF、BRAM减少2 Tile。P3b子预算15050 LUT/23517 FF/60 BRAM/2 DSP/2 MMCM与累计冻结上限15525/24845均满足。实际门禁变量复核exit0：WNS0.073、WHS0.052、DRC_FAILURES0、methodology无Critical、RESOURCE_LIMITS保持、CALLER_REMAINING为空。render100 MHz/pixel74.25 MHz及原实现/后布线策略保持，没有新增waiver、delay或时钟放宽。Slice及功耗余量分别评价，未据LUT增量推断多模态并发能力。

六报告保持原质量边界：DRC DPIP-1 Warning4、DPOP-2 Warning2、REQP-165/181 Advisory各2；methodology TIMING-28 Warning1、TIMING-47 Warning2、XDCB-5 Warning1；CDC六项CDC-3 Info、原User Ignored/Asynchronous Groups；clock interaction同域Clean。内部unconstrained endpoints=0，原四个输出缺delay保持。最终报告路径 `board/pynq_z2/output/gpu_raster_pair_experiment/reports/c6i_raster_pair_p3b/`。

功能证据沿用完整第二轮34份仿真及Blit正OOC，最后CLEAR解耦后实际追加6组renderer、4组核心窄回归和正裕量renderer OOC；没有宣称最后重新执行34组全矩阵。包含独立双lane mask、flipXY、裁剪/奇尾/stride、watchdog取消与立即重试、有序CRC/count、真实XPM两bank全帧及57599末字节读回。软件56 tests+4 subtests PASS。原57608写/CRC B62CC96A保持，renderer场景57644→28840周期；核心opaque场景57909→28974周期，CRC 0CD1AB1A/E33D5E52保持，mask CRC227A31F8保持。峰值2像素/拍只适用于配对条件满足的场景，单像素回退与任意合法游戏Scene合同保持，未据此推断实际FPS。

结构化最终核验实际exit0：BD/发布HWH/manifest六开关均1，BUILD_ID为C0060750。XSA主HWH与发布HWH逐字节一致；内外bit的a/b/c头及完整4045564字节配置体相同，配置体SHA `F2524503D00416664B7F354E5230299B1301CAC3F1C57C43575125AF3EE9D07C`。时间头分别22:03:51/22:04:25，内部整bit SHA `E13A4DE871081C0F46C871F933FB8F84C66E8CF6A9E4C445E3B580727EB90132`，时间头差异与配置一致性分开记录。

| 产物 | SHA-256 |
| --- | --- |
| c6i_raster_pair_p3b.bit | 78082396BEA0E9BA8C26CF496DD6ED7FEB42FC83E5A8D5478EC056586831B1D0 |
| c6i_raster_pair_p3b.hwh | DCBDA074ED2263BD9E73273E2E46EEC887FE617A42F736DA7541D72D9A5A7D79 |
| c6i_raster_pair_p3b.xsa | 105EC34E31E58E8D4524DD0FB8517C0C1DF7F79AD471A5E7C53BDB71BFB6A343 |
| c6i_raster_pair_p3b_manifest.txt | F1168A1726BE96514CECA3FBD8B867DAE16A4FE97195A67AE9C05EFDDC8E6A11 |

### 阶段三剩余双像素实施入口

终端结束事件监听首尝试也仅返回`^C`，没有WATCH_READY/terminal ID，因此未建立有效监听，不使用其等待/完成证据；整机继续保持原配置运行。后续取证通过已选解释器直接读取日志事件/原始报告，并以MCP last_completed_code核对真实结束。

取证恢复实际Pylance snippet exit0（选中原生解释器 `.venv\Scripts\python.exe`、workspaceRoot明确）：新BD/HWH的六flags均0x1、CONST_VAL=0xC0060750/CONST_WIDTH32、PS请求100/pixel74.250；BD SHA `1DEF436B72973ADFA1AAE248E8F0608C4D976A9B4EDD244C5402D823F8AD30C0`，生成HWH SHA `DCBDA074ED2263BD9E73273E2E46EEC887FE617A42F736DA7541D72D9A5A7D79`。最新guide源/部署实际均 `FA71D251AE794C128DCC29FB0B688692C53F10F56AB00AFC389CA38550E41B04`，主SKILL保持41D6D851原值；不把前轮未取得的installer返回值充作exit0。最终发布及XSA封装仍单独待验。

整机运行中只读身份/Skill同步探针取证失败：执行代理表示terminal结果文件无法读取，主terminal首复核仅返回`^C`；均不计同步/配置PASS。实际BD/HWH六flags、C0060750和最新guide源/部署SHA仍需重新取证，不修改RTL或整机门禁，整机本身继续运行。此取证失败与综合结果分开记录。

最终局部闭合组合：完整第二轮837.963 s/exit0保留34组黄金/新仿真，Blit off/on240/368 LUT、190/226 FF、WNS1.613/1.701、WHS0.177/0.159；当轮renderer on的-0.203仍拒绝。最坏fill_x_reg[1]→first_error_command_reg[6]/CE，17级9.914 ns（逻辑4.525/布线5.389），来自FILL资格经共享write_pixel_count串到CLEAR结束。只改CLEAR为编译常量1/2步长、直接比较57600-step末base和常量count（从0开始、偶帧长不跨尾），FILL/CRC/独立mask保持。修复后6组raster_pair_unit实际111.819 s/exit0，4组raster_core_unit实际107.079 s/exit0，两bank全帧/57599、原CRC/count/周期、取消重试保持。独立同频renderer全开OOC `results/gpu-p3b-clear-step-ooc-1791033987931/` 各命令exit0，2617 LUT/1613 FF/904 Slice/0 BRAM/3 DSP，WNS0.088/WHS0.148；比失败轮少15 LUT/1 FF，原OOC缺项保持。组合证据是“完整旧矩阵＋最后CLEAR局部回归＋最后同配置OOC”，没有把已拒绝的当轮负报告改称PASS。

主已实际执行独立整机 `source board/pynq_z2/scripts/build_c6i_raster_pair_p3b.tcl`，六flags1/C0060750/100及74.25 MHz/原后布线策略/jobs1；300 s handoff时正在串行IP综合。整机/最终产物身份仍PENDING，不向busy session execute；P4和上板后置。

阶段三经验仅更新仓库guide，再执行既有 `install.ps1 -Skills xilinx-suite -SkipAgent`，实际exit0；guide源/部署均SHA `7BBE9EB075AA85FAE870E105D6892EA262A1764AC40D76BD17176EB539E58A92`，主SKILL源/部署保持 `41D6D8511EDE06B6F26E58A810E81A9E9228E0C874BAC9F16920B52FFB62B73C`。辅助3/3 done后stop成功。当前主稳定完整轮目录 `results/gpu-stage3-verify-1791032876268/`。

整机前冻结14项源码SHA（含复用未改Tile/framebuffer及其TB），供最后身份复验：

| 文件 | SHA-256 |
|---|---|
| rtl/scene2d_gpu/scene2d_index4_asset_blit.sv | D0B6B2DF8A274FF813DE45267FA277321B59C85FB197A72145D2EFCC519BCFAC |
| rtl/scene2d_gpu/scene2d_clear_fill_renderer.sv | 0D4F4998DD7E7312777B2B29EFB1FBACEAE9B68FD4E44631D43CFE8BD4C92599 |
| rtl/scene2d_gpu/scene2d_c4m3_core.sv | 099310570EEE90E736CEAFEE9D58A092B624E1B1D3D77B20E35097F4F1B8DAB5 |
| rtl/scene2d_gpu/scene2d_c4m7_core.sv | 02C34EC8B17FF45740E1B887EA13A7D9F601607FE8B6F6584FA7AEA7CA7867DB |
| rtl/scene2d_gpu/scene2d_draw_tile_layer.sv | DB7217B0E882F2AAD5CCD649F6E747367711FC4C957A1767DAAFADE85F3DC366 |
| rtl/scene2d_gpu/scene2d_framebuffer.sv | 06E74BE9F61D03DA0FCCB9F53C7EB16D4B643CD7AA73468FDE0DCAFA28286A74 |
| sim/scene2d_gpu/tb_scene2d_index4_asset_blit.sv | AA0D987A2D64691CE6D7EEE9E2D1D3751E6E83434D7E1514A097A9C7C0D3BD0E |
| sim/scene2d_gpu/tb_scene2d_clear_fill_renderer.sv | 7D32ADBE498AE730A9E92C186D356076829D782EFC69A41D0BE3ECF39164D29C |
| sim/scene2d_gpu/tb_scene2d_c4m7_core.sv | 66336225EBFF762CDB1F4EBBE915FC903B94A09A10D45C37435CCB61E5DBA946 |
| sim/scene2d_gpu/tb_scene2d_draw_tile_layer.sv | DFB412517B1526D35930B528115B05F72853EA51B66197C57EB54D8C27D8532A |
| sim/scene2d_gpu/tb_scene2d_framebuffer_scanout.sv | 2E037A6F1D0349895D5737C507439DD83C8AD145F7569E6A9B022B366C411D8D |
| sim/scene2d_gpu/verify_tile_cache.tcl | B7CD8BE9D28BD25E99759F2E530254A9B348F4EDB936257E803E50E4FF3A04D6 |
| board/pynq_z2/scripts/build_c4m3.tcl | D11032EA49DEC730BA196F7CACE1F91C307AD2EFC0D924982439E2AE3C0A471E |
| board/pynq_z2/scripts/build_c6i_raster_pair_p3b.tcl | 4012CEBF0840E93E829E4D37B8DE20A1F3914FCFBA6B3F45EAA9C7A28F6954BA |

第二局部修复复验：同一blit_pair_unit实际10.716 s/exit0，四组合28例全部PASS。独立同配置100 MHz Blit pair1 OOC `results/gpu-p3b-blit-tail-ooc-1791032713172/` 全命令exit0，368 LUT/226 FF/133 Slice/0 BRAM/2 DSP，WNS1.701/WHS0.159 ns；相对原off240/190增128 LUT/36 FF，DSP/BRAM保持。最坏local_y_reg[0]→local_x_reg[15]/D，8.247 ns/14级；原IOdelay及HD.CLK_SRC缺项保持，DRC仅原7warnings。当前Blit源码SHA D0B6B2DF8A274FF813DE45267FA277321B59C85FB197A72145D2EFCC519BCFAC。主首完整轮实际825.804 s/exit0仅进程成功，renderer pair1也WNS-1.730/WHS0.098，17级runtime_blit同链，故首轮仍拒绝；其源码先后读取和负报告分开保留，不混为改后PASS。当前主已实际重跑完整stage3（等价路径引用避免duplicate跳过）；整机尚未启动。

Blit时序修复第一探针失败：辅助TCL session `vivado-20261003-210134-423d7501`，`blit_pair_unit` 实际17.126 s/exit1，目录 `results/gpu-blit_pair_unit-verify-1791032508068/`；前6例通过，negative_xy触发2 ms watchdog。原失败OOC最坏active_flip_x_reg→local_y_reg/CE，17级/11.250 ns（逻辑5.641/布线5.609），原因是source/second_bounds→pair→step→rowend链。首探针已将byte兼容/无溢出条件前移入口；其word级行尾误用了Tile的“local坐标偶”合同，Blit偶目标在奇dst/clip下可对应奇local，跨word尾时漏done。第二探针仅将尾判定改为已锁存width-1/width-2的直接候选坐标相等，继续原独立oracle验证，不给Blit加Tile幂次/偶local限制。修复尚PENDING，主旧轮仍运行，不混用源码版本作为一轮证据。

stage3第一完整轮的34份仿真transcript终端PASS且无Fatal/Error/watchdog；首两Blit OOC实际off/on分别240/323 LUT、190/193 FF、0 BRAM/2 DSP，WNS1.613/-1.539 ns、WHS0.177/0.132 ns。pair负setup裕量阻止整机推进，先保存原报告、DCP和Blit源码，再沿最坏Source/Destination局部修复，保持100 MHz和预算/约束；renderer OOC仍在运行，完整阶段PENDING。

软件入口复核实际 `.venv/Scripts/python.exe -m pytest -q` 指定7文件得到56 passed/4 subtests passed/36.70 s/exit0；game2等函数依赖pytest fixtures，前轮unittest发现零用例属于入口问题，软件源码未改。旧四阶段16产物以此前明确SHA逐项核对16/16 PASS，git diff --check exit0；代理首次未恢复全部期望SHA的unknown不算一致性证据。

并行软件检查首轮入口不一致：代理报告Python3.13.2；scene_compiler/raster_trace/gpu_abi分别9/6/6 tests exit0，game2 exit5/0 tests，后3文件未执行。原始测试入口及实际命令待核对，软件门禁PENDING；先记录后复核入口，保持软件源码及测试不变。完整stage3 runner当前仍运行 `results/gpu-stage3-verify-1791031754961/`，不向busy解释器执行新命令。

核心窄回归 `results/gpu-raster_core_unit-verify-1791031504609/` 实际109.891 s/exit0：Blit/solid四组合、每组三新帧、两bank完整320×180真实XPM读口逐字节匹配，末字节57599读回PASS。opaque普通/XY翻转57873写CRC0CD1AB1A/E33D5E52，mask57745写CRC227A31F8；all-off周期57909/57909/57908，all-on28974/28974/28973。Blit单开57781/57781/57780，solid单开29102/29102/29101；原Tile/cache/pipeline始终1，无软件ABI变化。新独立wrapper `build_c6i_raster_pair_p3b.tcl`，C0060750（先查现有scripts无冲突）、gpu_raster_pair_experiment，六优化flags1；整机与完整stage3/OOC仍PENDING。

会话 `vivado-20261003-203314-8e9ef160`，日志 `results/.vivado-ai/vivado_30794242_ab154be1.log`。Blit首片默认关闭BLIT_PIXEL_PAIR_ENABLE；仅pipeline开启、同源byte、偶目标且两像素同合法行内配对，按候选数推进，正反flip独立nibble掩码，末输出排空。首窄runner `results/gpu-blit_pair_unit-verify-1791030887250/` 实际15.623 s/exit0；四组合28例、原24例黄金、四掩码及2像素/拍通过。renderer集成及CLEAR/FILL局部验证待完成，阶段三仍PENDING。

### P3a 最终离线闭合

第二整机轮 `source board/pynq_z2/scripts/build_c6i_tile_pair_p3a.tcl` 实际exit0，1903.317 s，完成标记VSCEND:0；BUILD_ID `0xC0060740`。使用当前Tile消冗版本，100 MHz render/74.25 MHz pixel及原实现策略保持。

| 项目 | P2b | P3a | 增量 |
| --- | --- | --- | --- |
| LUT | 14110 | 14550（27.35%） | +440 |
| FF | 22968 | 23005（21.62%） | +37 |
| Slice | 7236 | 7386（55.53%） | +150 |
| BRAM Tile | 62 | 60（42.86%） | -2 |
| DSP / MMCM | 2 / 2 | 2 / 2 | 0 / 0 |
| WNS / WHS ns | 0.045 / 0.050 | 0.116 / 0.017 | 两项均满足 |

DRC保持DPIP-1 Warning4、DPOP-2 Warning2、REQP-165/181 Advisory各2；methodology保持TIMING-28 Warning1、TIMING-47 Warning2、XDCB-5 Warning1。CDC保持6项CDC-3 Info、原Asynchronous Groups/User Ignored；clock interaction同域Clean，render/pixel间原异步分组保持。内部unconstrained endpoints=0，原4个输出无delay缺项保留，无新增waiver或时钟放宽。

独立输出 `board/pynq_z2/output/gpu_tile_pair_experiment/`，报告在其 `reports/c6i_tile_pair_p3a/`。结构化核验实际exit0：BD、发布HWH及manifest四flags均1、CONST_VAL=0xC0060740/CONST_WIDTH=32；XSA主HWH与发布HWH逐字节相同，完整bit配置体均4045564字节，SHA `43D44A6C46765294F74ACA8D17EB0ACEC62F4F1EFC9A3E0454F66BA5BA7E59DD`。外部/内部bit仅时间头20:17:37/20:18:08不同，a/b/c头一致，内部整文件SHA `470C6D0F6DCC4EDCD98C10F18FC12F1217E05F7C4A6DC424FFD1F11E9C7D8775`。

| 产物 | SHA-256 |
| --- | --- |
| c6i_tile_pair_p3a.bit | 448BB4B4B52FB6642FC23821B848E3B4DA08807CC3E5E8CED509FCCC29C20D84 |
| c6i_tile_pair_p3a.hwh | A5AB73EFDA4EE7B40EAB4C4C697724A297935B35FCB77DB3077699A93781F94D |
| c6i_tile_pair_p3a.xsa | 9B7535E63F1B97B8322F314C494D76F332CDE22AE50EC315B15FBBEB60FE743A |
| c6i_tile_pair_p3a_manifest.txt | 73A0238FD7A772CD3680F096EC1F74AD74F60BC955560327BE27DB1BF8B0C356 |

源码身份沿用后文第一轮13项表，其中Tile当前SHA为DB7217B0E882F2AAD5CCD649F6E747367711FC4C957A1767DAAFADE85F3DC366、wrapper为D60316EAB4ECEB3232F9F8EE9A64564CA6756A29813CD5FC530891E4AB10143E，其余11项一致。旧前三阶段12产物SHA保持；监听通知包含历史只读核验ParserError，随后修正命令的实际12/12一致及returncode0已核实，历史错误与本次构建结果分开。

边界复用经验已追加仓库源vivado_guide并执行安装同步；guide源/部署SHA均 `3541C58AF909C9DBBE1CC43426705BA38143B6A27A1A05759FAD25FF6C0F0253`，主Skill均 `41D6D8511EDE06B6F26E58A810E81A9E9228E0C874BAC9F16920B52FFB62B73C`，安装exit0，OpenClaw未检测到。最终差异格式检查通过；工作区既有修改保留，未commit/push。

结果为P3a离线PASS；未上板，视觉/声音/游戏同板并发与Studio端到端验收、P3b及P4均后置。以下记录按轮次保存，PENDING描述代表对应历史时点。

### P3a 实施入口：双像素 framebuffer 判别

会话 `vivado-20261003-180830-f618d688`，日志 `results/.vivado-ai/vivado_22110205_468bf2d2.log`，隔离目录 `results/gpu-tile-pair-1791022157468/`。首片为 framebuffer 默认关闭的 16-bit 写 / 8-bit 读、独立字节掩码；原单像素接口和读延迟保持。原 scanout TB 扩四掩码、单独第二像素、偶奇单写、2046/2048 与 57598/57599 边界、两 bank 和 vblank/ack。开关 0/1 均有终端 `SCENE2D_FRAMEBUFFER_SCANOUT=PASS`，分别 1106/1050 ns 正常 finish，无 Fatal/Error；日志 `framebuffer_off.log`、`framebuffer_on.log`。

前三阶段 12 个输出文件 SHA256 与 P2b 记录一致，未覆盖旧输出。framebuffer OOC 基线综合映射 32 RAMB36、0 RAMB18；双写综合映射 30 RAMB36、0 RAMB18。基线 routed WNS/WHS 为 8.018/0.637 ns；独立 render/pixel clock 使用 10.000/13.468 ns、异步分组，未补接口 delay 或 HD.CLK_SRC，仅作局部比较。

工具跳过记录：双写综合后，MCP 对相同 `opt_design` 返回 `SKIPPED (duplicate)`，认为 91 秒前已执行。实际前次针对单写 design，故本次跳过不能作为双写实现证据。保存响应，使用合法显式 directive 区分新 design 命令后复验，结果待记录。

双写后端实际优化/布局/布线复验 PASS：195 LUT、16 FF、30 RAMB36，WNS/WHS 6.597/0.700 ns；单写为 35 LUT、10 FF、32 RAMB36。真实连续读地址延迟检查 PASS。Tile 初片 31 例及八种 cache/pipeline/pair 组合通过；长不透明段实际 2 像素/拍、256 写、230 周期，四掩码/翻转/奇数目标地址追加检查通过。renderer pair watchdog 在真实双写中取消，164 写前缀 CRC 与独立 oracle 一致，立即重提交 4 写、CRC `34B161C1`，旧 57608 写黄金保持。

P3a 核心首轮失败：`core_pair_first.log` 在 23541.001 ns 报 `C4M7 framebuffer readback bank=1 address=0 actual=00 expected=32`。新读回模型在 NBA 后采集读地址和 display_bank，和 XPM/输出寄存器的边沿前取样窗口不一致，bank 切换边沿尤为明显。先保存原始证据；拟仅调整 TB 为边沿前采集地址/bank、NBA 后检查上一拍数据，同 RTL 复验确认，尚未判为硬件数据缺陷。

读回采样修正复验：`core_pair_sampling_fix.log` 的旧六帧、四个 Tile 合法帧与 11 写错误前缀均 PASS，读回不再失败；Tile 合法帧为 197/195 拍、CRC 原黄金不变。新增 pair 资源阶段最终触发 2 ms watchdog，未出现 pair 帧 PASS，故整个核心仍 PENDING。仿真结束后查询参数化顶层路径返回 `No such HDL object`，未取得状态；追加 TB 状态诊断，保持上传校验及 RTL 不变。

资源诊断 `core_pair_resource_probe.log`：asset `00123500` 已提交、rejected=0/errors=000；Tilemap 保持 `00123470`，新包 rejected=1/errors=100。代码证据：resource_upload 保留最后 64-bit beat 的高 word 即使 keep=0；Tilemap 要求每 word keep=F，故 1×1 的 20-byte 测试包触发语义拒绝。本阶段保持原上传链路，只将新长段测试改为 2×1 两个 descriptor 的 24-byte 整拍包，同时扩大 TB 小扫描宽度以实际读回两个 Tile；这是测试刺激遵循现有接口边界，不扩大硬件合同。

整拍包复验 `core_pair_aligned_packet.log` 终端 pair PASS，全部旧 trace/CRC、错误前缀和真实扫描读回通过。`tile_pair_unit` 新 runner 完整执行 exit0（87.493 s），后端两模式、八组合31/34例及 Blit24例均 PASS。完整 runner 首轮在核心启动前失败：`Vivado 12-1501 Simulator ... tb_scene2d_c4m7_core is already running`（98.250 s），源自此前手工核心仿真直接 close_project 未先 close_sim，功能仿真未启动。官方 UG900 2026.1 Closing a Simulation 明确要求先 close_sim 再 close_project；只读进程检查未发现 xsim.exe，执行 close_sim -force 后会话关闭，未终止其他进程。新目录从头复验待记录。

完整 runner 第二轮目录 `results/gpu-tile_pair-verify-1791023235581/`。实际核心长 Tile 为 pair0/1：813/557 拍、CRC `88CEA2AB`；掩码帧 781/525 拍、CRC `822C709E`，有真实扫描读回（读回次数随仿真时长变化，不作性能指标）。软件 56 tests + 4 subtests PASS，36.25 s。Tile pair OOC1 为 1101 LUT、540 FF，WNS/WHS -1.387/0.146 ns；最坏 output_x_reg[1]→output_y_reg[0]/CE，11.098 ns、16级，逻辑4.640/布线6.458 ns。组合链经过 source_x、issue_pair、步长加法和行尾比较。此负裕量阻止推进整机构建；计划仅在已验证幂次/整分合同内移除重复配对源运算、锁存行/descriptor边界，同频同约束复验，预算不变。renderer pair0 OOC WNS/WHS 0.117/0.144 ns，pair1 尚未完整报告。

第二轮 runner 最终正常退出（703.154 s），功能仿真全部 PASS，但两项 OOC 负裕量，阶段仍 PENDING。renderer pair1 为 2518 LUT/1574 FF，对 pair0 2199/1555 为 +319/+19；WNS/WHS -2.842/0.110 ns，最坏 active_cycles_reg[27]→active_trace_crc32_reg[19]/D，12.787 ns、13级，逻辑2.068/布线10.719 ns，watchdog选择进入两笔级联CRC。拟将启用pair时固定4/8-byte CRC写成常量GF(2)掩码XOR归约、选择在输出端，保留默认关闭的原CRC及有效lane0→lane1顺序，先同真实取消/核心oracle复验，再同配置OOC；禁止新队列、降频或预算放宽。Tile边界锁存修复后八组合窄runner再次PASS（95.612 s），新leaf OOC执行中。

修复版完整 runner 在 `results/gpu-tile_pair-verify-1791024145063/` 复验。核心 pair0/1 长Tile仍813/557拍、CRC `88CEA2AB`，掩码仍781/525拍、CRC `822C709E`，真实XPM读回通过。运行中检查不能作为整轮结束证据；renderer OOC和整机仍PENDING。

修复版 runner 最终实际 exit0，677.643 s。Tile pair1 WNS/WHS为0.014/0.123 ns；renderer pair1为2541 LUT/1606 FF/925 Slice/0 BRAM/3 DSP，WNS/WHS为0.525/0.148 ns，最坏路径已移至Tile设置边界而非CRC。renderer pair0资源用于同配置对照，整机DSP限额仍为2，局部未裁剪配置的DSP数不代替整机资源门禁。脚本结束自动close_project，随后手工get_timing_paths查询返回Common17-53 No open project；该查询未取得新时序值，改读已保存routed报告，不将查询失败当报告失败或伪造实时读值。

已验证的XPM/读回/仿真关闭顺序经验同步到仓库vivado_guide，再执行 `install.ps1 -Skills xilinx-suite -SkipAgentInstructions`；guide源/副本SHA均为 `7A03F6E093805C7F1457AEF3EC89F22FC61CBFA657A95EC145B824C1A27ECE28`，主Skill保持 `41D6D8511EDE06B6F26E58A810E81A9E9228E0C874BAC9F16920B52FFB62B73C`，OpenClaw未检测到。P3a拟独立BUILD_ID `0xC0060740`，限定现有脚本/manifest检查无占用；整机门禁尚未执行。

构建入口窄检查：common及新wrapper Tcl完整性、pair默认0、传入1后消费unset均通过。隔离in-memory BD probe首次在create_bd_cell失败：filemgmt56-176/56-587，明确manual compile order不支持module reference，未取得BD参数读回。UG901/UG893 2026.1编译顺序文档确认自动管理模式；仅修正probe的source management，再同参数读回检查。common正常project流程保持不变，不因探针设置失败改RTL或整机约束。

probe切换 `source_mgmt_mode All` 后成功解析core和四个bit参数；默认值断言又失败。只读get_property明确返回pair/cache默认文本均为带双引号的 `"0"`，直接数值比较是探针解析错误。实际RTL默认0保持；拟仅将默认值外层引号去除后严格核对，再写入0x1核对numeric读回，common启用参数读回保持原逻辑。

默认值解析修正复验PASS：All模式下原始pair默认 `"0"`、归一化0、配置读回0x1。独立P3a整机于18:58启动，jobs1综合/实现与原策略保持，输出 `board/pynq_z2/output/gpu_tile_pair_experiment/`，预算硬门禁在bit之前执行。

最新完整24组sim transcript逐文件审计均有终端PASS，无Fatal/Error/watchdog expired。固定其他开关的Tile off/on为1030/1135 LUT、537/588 FF、335/366 Slice，WNS0.397/0.014、WHS0.145/0.123；renderer off/on为2236/2541 LUT、1552/1606 FF、846/925 Slice，WNS0.279/0.525、WHS0.122/0.148，BRAM0/DSP3均保持。renderer局部增量305LUT/54FF，整机资源仍待报告。相关RTL/TB/Tcl编辑器diagnostics无错误。

只读审计代理未完成指定12旧产物及13源码哈希核对，宽扫描输出不作为核对通过；随后限定12文件的约2KB PowerShell命令只返回 `^C`，未获得检查结果。此工具失败与已有终端经验一致，保留旧首次SHA检查事实，闭合前改用短命令取得实际哈希再逐项核对，不从空输出或传输结果推断PASS。

短命令实际返回P1/P2a/P2b全部12个SHA，逐项与既有表相同；旧产物保护复核PASS。首次源码SHA命令误用Bash花括号展开，PowerShell无输出，未取得源码SHA；改用既定目录的文件名正则筛选并核对数量。工具空输出不作核对成功，相关规则已记入终端经验。

源码短命令实际取得下列13个SHA。生成的P3a BD经JSON解析确认四开关均0x1、xlconstant CONST_VAL为0xC0060740。`vivado_status action=runs` 在主source忙时从历史日志推断synth Complete且has_project=false，未作为本次完成依据；当时本次run目录标志确认GP0/PS7等完成、后续IP串行执行、无error标志，主综合尚未启动。辅助会话3/3任务结束后close_project/stop成功。

CRC经验已追加仓库guide并再次安装，guide源/部署SHA均 `E273A056768324D741814DBEBA5BABD472F0329FA4471C01769EAD175B08C994`，主Skill SHA保持原值。P3a第一整机轮源码身份如下：

| 文件 | SHA-256 |
| --- | --- |
| `rtl/scene2d_gpu/scene2d_framebuffer.sv` | `06E74BE9F61D03DA0FCCB9F53C7EB16D4B643CD7AA73468FDE0DCAFA28286A74` |
| `rtl/scene2d_gpu/scene2d_draw_tile_layer.sv` | `D6D0D6A8C00BEBF21B073254F2E86AEE0CF31DCED335F5B2894F44A650FB96B8` |
| `rtl/scene2d_gpu/scene2d_clear_fill_renderer.sv` | `3BDDD25EEE89843A388E77376A06B76CEC428BF6C513BD2BBF76B4528A30A6F5` |
| `rtl/scene2d_gpu/scene2d_c4m3_core.sv` | `889C6D9B225E3C6BE618F2BFA74095A5061C0C5E2756BE2EF290C89D03E23EAB` |
| `rtl/scene2d_gpu/scene2d_c4m7_core.sv` | `CE9D01AFF2BEC96E35F455B688F1FA2815876E34DAFF0CEBBDA7ACBE5F13E528` |
| `rtl/scene2d_gpu/scene2d_index4_asset_blit.sv` | `A54F37AEE7227584A352696453685AE2EC53696EB7061B35A64A8B31AD074572` |
| `sim/scene2d_gpu/tb_scene2d_framebuffer_scanout.sv` | `2E037A6F1D0349895D5737C507439DD83C8AD145F7569E6A9B022B366C411D8D` |
| `sim/scene2d_gpu/tb_scene2d_draw_tile_layer.sv` | `DFB412517B1526D35930B528115B05F72853EA51B66197C57EB54D8C27D8532A` |
| `sim/scene2d_gpu/tb_scene2d_clear_fill_renderer.sv` | `180F70AACA55128E9CFBD3C34CA382EE6CEE00B09F1A46A642083ED473C4EB44` |
| `sim/scene2d_gpu/tb_scene2d_c4m7_core.sv` | `458462EEC7802FA11F4F87D6CAB8E362597D86E40AE5D4D81F535A06E6F5EA23` |
| `sim/scene2d_gpu/verify_tile_cache.tcl` | `EC4404945A5BC4599EE4EF12353241F0335EB7C5703DF8BA644D2ECE1F0AE2D0` |
| `board/pynq_z2/scripts/build_c4m3.tcl` | `4721E58708DA06772D9AF519B89C15FC7E97A9EDEB8B0734EE25AB3EB2A35D34` |
| `board/pynq_z2/scripts/build_c6i_tile_pair_p3a.tcl` | `1711C7C167EC79C0846502EDA6CDD8338512353B6CD86D1D890424EE36C83301` |

### P3a 第一整机轮：硬资源门禁拒绝

主source于18:56:48开始，19:27结束，实际exit1、1814.555 s；完成综合/布局布线/原post-route phys_opt后，硬门禁返回 `Slice LUTs used=14629 limit=14610`，超19 LUT，相对P2b增519 LUT。FF23037/Slice7289/BRAM60/DSP2/MMCM2，WNS/WHS0.093/0.051 ns；DRC Error/Critical0、methodology Critical0。所有报告已生成，bit/HWH/XSA/manifest导出尚未执行，不能称离线PASS。

失败轮完整证据归档 `results/gpu-p3a-board-budget-fail-1791026983004/`，含6项报告、post-physopt DCP、BD/HWH及当轮Tile源码。Tile消冗去除两组16bit尾界寄存器后，首个八组合/真实XPM/Blit窄runner实际exit0，97.601 s；完整核心及修复后整机待复验。

消冗后的完整runner `results/gpu-tile_pair-verify-1791027237217/` 实际675.017 s、exit0；24份顶层仿真日志均PASS且无Fatal/Error/watchdog timeout。核心opaque813→557周期、mask781→525周期，分别513写CRC88CEA2AB与257写CRC822C709E，真实XPM读回、11写源错误前缀及取消/重试保持。OOC Tile off/on分别1030/1093 LUT、537/556 FF、335/356 Slice，WNS0.397/0.224 ns、WHS0.145/0.168 ns；renderer off/on分别2233/2495 LUT、1555/1574 FF、812/886 Slice，WNS0.506/0.162 ns、WHS0.131/0.152 ns。Tile为0 BRAM/0 DSP，renderer为0 BRAM/3 DSP，均无增量。相对消冗前enabled Tile少42 LUT/32 FF、renderer少46 LUT/32 FF；局部量测与整机验收分开。旧12产物SHA及git diff --check再次通过。

整机复跑第一次source在create_project返回 `Coretcl 2-99: Project c6i_tile_pair_p3a is currently open`，exit1；当次未进入综合，实现与导出均未执行。完整runner退出码0与会话无当前project分别核对；先记录本次会话错误，再显式close_project后重试同一独立wrapper，保留原归档。

显式close_project exit0后，第二次整机source正常进入jobs1串行综合；当前待整机门禁。只读源码SHA核验首次错误地将字符串路径数组管道传入Get-FileHash，PowerShell5.1逐项ParameterBindingException，数量断言失败、exit1，未取得13项SHA；改用显式-LiteralPath数组后复验，避免从部分/空输出推断身份通过。

### 第一轮：最小对照

Vivado MCP Tcl 会话 `vivado-20261003-135855-fd02a631`，隔离工程 `results/gpu-cache-20261003/`。原五条黄金写入保持：`0:32, 1:46, 2:45, 320:34, 322:47`。

首轮结束时钟计数包含复位：62 → 56。后续统一使用从命令 start 到 done 的周期：59 → 53。

### 第二轮：边界与真实存储

22 个缓存开关双 DUT 用例通过；合法用例另与独立逐像素 oracle 比较。覆盖尺寸 1/2/4/8/16、负 X/Y、右下裁剪、翻转组合、透明、tilemap 跨行、连续命令换描述符与素材、保留位、源越界、部分写入后错误、完整地址 tag、缺失素材、形状错误和完全裁剪。

`full_address_tag` 是直接模块的地址截断对抗用例：要求地址 4 和 1028 各产生一次 descriptor fetch；用于标签检查，不作为超容量 tilemap 的板端合法上传证明。

| 负载 | 禁用周期 | 启用周期 | 验证 |
| --- | ---: | ---: | --- |
| 原黄金 | 59 | 53 | 5 次有序写入一致 |
| size=1，3×2 tiles | 60 | 60 | 零收益但行为一致 |
| size=16，3×2 tiles | 13860 | 9540 | 1440 次写入与 oracle 一致 |
| 真实 C4M7，两条连续 Tile 命令 | 156 | 138 | 两帧各 12 次写入、CRC `7622ED64` 一致 |

真实核心使用 Asset/Tilemap/Palette/Command/Framebuffer 的 XPM 模型，通过 AXI-Stream 上传资源与场景，等待实际 render/present。输出日志 `results/gpu-cache-20261003/core_cache_off.log`、`core_cache_on.log`。本测试验证写入、计数、CRC 和呈现握手，未覆盖实际 HDMI 输出或板端多模态并发。

### 第三轮：复跑脚本

入口：`source E:/projects/fpga/voice-view-game/sim/scene2d_gpu/verify_tile_cache.tcl`（Vivado Tcl 模式）。脚本使用唯一隔离结果目录，执行 Tile 单元、真实核心开关、原 renderer 回归及两个 100 MHz Tile OOC 布线探针；保存 transcript、DCP、资源和时序报告。OOC 探针用于局部增量测量，整机时序单独验收。

首次执行在 Tile 单元 PASS 后，第二个仿真复制已有向量文件时退出：`file already exists`。原因是多仿真共用生成目录；仅将生成目录中的向量复制改为 `file copy -force`。RTL、原向量与断言保持不变。第二次完整执行通过全部四组仿真，包含原 renderer 的 57608 次写入、CRC、透明和 watchdog 断言。

复跑结果目录：`results/gpu-tile-cache-1791007790970/`；耗时 188.182 s，源脚本正常退出。局部 OOC 布线报告：

| 指标 | 缓存关闭 | 缓存开启 | 增量 |
| --- | ---: | ---: | ---: |
| LUT | 950 | 977 | +27 |
| FF | 442 | 467 | +25 |
| Slice | 307 | 325 | +18 |
| BRAM / DSP / MMCM | 0 / 0 / 0 | 0 / 0 / 0 | 0 |
| WNS / WHS，ns | -0.057 / 0.110 | 0.111 / 0.144 | 仅局部参考 |

局部资源符合 P1 上限。OOC 未设置父级输入/输出延迟或 `HD.CLK_SRC`，存在 252 个缺输入延迟端口、53 个缺输出延迟端口；相关 timing/DRC 警告保留，基线负 WNS 明确标记，未修改周期或断言容差。该探针未运行整机 methodology/CDC，未作为整机时序或发布 PASS。下一轮运行完整独立 C6I 实验构建。

PowerShell 读取 MCP UTF-8 JSON 时默认编码导致 `ConvertFrom-Json` 未终止字符串；显式 `Get-Content -Encoding UTF8` 后完整输出解析通过。

### 测试刺激复核与软件回归

复核发现素材更新用例原来修改了未被 tile_id=3 读取的字节。改为修改实际读取的 byte 18 和 31，并断言写入数由 15 变为 16；独立 Tcl 会话重跑全部 22 用例 PASS。最终单元 transcript：`results/cache-unit-final-20261003/tile_unit_final.log`，该独立会话已关闭，主构建未被重配置。

```text
.venv/Scripts/python.exe -m pytest tests/test_scene_compiler.py tests/test_raster_trace.py tests/test_gpu_abi.py tests/test_game2.py tests/test_game_testing.py tests/test_video_codec.py tests/test_c6i_video_sink.py -q
56 passed, 4 subtests passed in 38.33s
git diff --check: PASS
修改 RTL/TB/Tcl 的编辑器 diagnostics: 无错误
```

### 源码身份

| 文件 | SHA-256 |
| --- | --- |
| `rtl/scene2d_gpu/scene2d_draw_tile_layer.sv` | `40A1912633F2F8A5A9E74629612C073F1494B0142B788553BB37D64C222043A0` |
| `rtl/scene2d_gpu/scene2d_clear_fill_renderer.sv` | `D5D8632BE9891DD9D189A3B8DAFD6FE656A7601B4AC89F51AFA536B5B50382D9` |
| `rtl/scene2d_gpu/scene2d_c4m3_core.sv` | `090302AD0A98D05895E83318FCF26B1E38B19C87C7143E3EBE765D5BFA9DE244` |
| `rtl/scene2d_gpu/scene2d_c4m7_core.sv` | `F8AB3B2B9E720B00E925558C3B48429F0333A2A86F5261631C4D4AFE56C3C054` |
| `sim/scene2d_gpu/tb_scene2d_draw_tile_layer.sv` | `910208E3A7DF5B94365D301C0829D7ACA5E66658ECAAAB6C9E5BCBE69C447A7D` |
| `sim/scene2d_gpu/tb_scene2d_c4m7_core.sv` | `276750CBEDAF4362ED2399FAE9B5A7311C7EF0EDE7F0A0E031FCDA1FF05A31C7` |
| `sim/scene2d_gpu/verify_tile_cache.tcl` | `DBEBE9FAF4741F17B083F3361E7452DF9A81F2B7CD1ADC30DD37978E6E2FCFDC` |
| `board/pynq_z2/scripts/build_c4m3.tcl` | `712CEFF40C4E18E1E751174FF3782DA9AAFCB0C396D1C75B25313875E2F262B5` |
| `board/pynq_z2/scripts/build_c6i_tile_cache_p1.tcl` | `A8899B67DC71682B8B7FFA5A99290114623D88B7D5C4DC3D5CDAADE50416F6D2` |

## 资源与时序门禁

### 第四轮：整机参数配置失败

独立入口 `source E:/projects/fpga/voice-view-game/board/pynq_z2/scripts/build_c6i_tile_cache_p1.tcl`，新 BUILD_ID `0xC0060710`，输出隔离于 `board/pynq_z2/output/gpu_cache_experiment/`。首次构建 16.593 s 后在 BD 配置阶段失败，尚未启动综合：`[IP_Flow 19-3450] Invalid Hexadecimal Value 'true'`。Vivado 将 SV `bit` 参数推断为 `bitString`，明确列出支持 `0x...` 写法。文档查询未命中该自定义参数；按 Vivado 本身的类型与合法值反馈，将配置修为 `0x1` 并增加读回等于 1 的断言。当前 BD 的独立参数复验成功，读回 `0x1`；完整构建 PENDING。未更改 RTL 参数类型或既有 IP 配置。

新缓存开关及实验输出目录采用一次性传入/消费，防止同一 Tcl 会话后续执行旧构建时沿用实验配置。旧 wrapper 保持原内容，默认输出仍为 `board/pynq_z2/output/`。

P1 建议增量上限：LUT ≤ 200、FF ≤ 256，BRAM/DSP/MMCM 无新增。整机 post-route WNS/WHS ≥ 0，沿用 DRC、methodology、CDC 门禁。局部 OOC 报告与整机报告分别标注，门禁完成前保持发布配置默认关闭。

### 第五轮：整机实验构建完成

修正参数后，同一独立入口于 14:17:09 启动，正常结束，耗时 1978.842 s。MCP 确认 `is_command_running=false`、`last_completed_code=0`；完整日志末尾明确输出 `C6I_TILE_CACHE_P1_BUILD_STATUS=PASS`。IP 综合按原脚本 `-jobs 1` 串行进行，核心综合日志四层实例均读到 `TILE_DESCRIPTOR_CACHE_ENABLE=1'b1`。

最终报告目录：`board/pynq_z2/output/gpu_cache_experiment/reports/c6i_tile_cache_p1/`，时序与资源报告来自 `Physopt postRoute` 状态。

| 整机指标 | 冻结 C6I | P1 实验 | 相对冻结值 |
| --- | ---: | ---: | ---: |
| LUT | 14025 | 13982 | -43 |
| FF | 22845 | 22870 | +25 |
| Slice | 7262 | 7250 | -12 |
| BRAM Tile | 62 | 62 | 0 |
| DSP | 2 | 2 | 0 |
| MMCM | 2 | 2 | 0 |
| WNS，ns | 0.057 | 0.029 | 均满足 ≥ 0 |
| WHS，ns | 0.050 | 0.014 | 均满足 ≥ 0 |

P1 资源门槛通过，时钟、素材和 framebuffer 容量保持原配置。整机 LUT/Slice 差值包含综合及物理优化映射变化，不能解释为缓存本身节省了 43 LUT；同配置局部增量仍以 +27 LUT、+25 FF 为证据。整机时序余量较小，后续流水仍须单独跑完整门禁。

独立实验产物与 SHA-256：

| 文件（位于 `board/pynq_z2/output/gpu_cache_experiment/`） | SHA-256 |
| --- | --- |
| `c6i_tile_cache_p1.bit` | `AD2E5429EBEC5794FF9EFC2D40F6B9A5957FE18CAA08145F113B9426A946208F` |
| `c6i_tile_cache_p1.hwh` | `7929A58DE27AE6A82A2A08B7CA01A2A9103D238F43CBEB24B5660A3F9B37A226` |
| `c6i_tile_cache_p1.xsa` | `203D7B9348E86E453C97CD4E3B87D3631DCF515368019485C55598700C9CC87D` |
| `c6i_tile_cache_p1_manifest.txt` | `0F8B094EE03141C723CAB588270350C54524F21DD3815C849EBE904928CE9131` |

Manifest 确认 BUILD_ID `0xC0060710`、缓存开启、双 framebuffer、320×180/4×输出、74.25 MHz pixel clock，以及最终 WNS/WHS。产物仅用于离线实验，当前未部署到板卡。

## P2a：Blit 单像素流水

独立 Tcl 会话 `vivado-20261003-150111-be85d26e`，结果目录 `results/gpu-blit-pipeline-1791010899500/`。旧路径原 8 条黄金 PASS，76 拍；第一次流水窄验证同一黄金 PASS，20 拍。扩展原 Blit TB 的 24 个双 DUT/oracle 用例 PASS，长不透明区间 256 次写入由 1281 拍降到 261 拍，实测连续写入 II=1。覆盖 odd 源坐标、宽度、非二次幂 stride、flipXY、裁剪、透明、非法参数、忙时 start、素材/palette 更新及中途复位。padded stride 仅为直接模块兼容测试，板端资源上传仍为紧凑 INDEX4 格式。

参数传播后，原 C4M7 两帧 Tile 用例仍 PASS，12 次写入、CRC `7622ED64`、138 拍。真实 XPM 新 BLIT 用例前两帧通过：generation `001234F0/F1`、每帧 11 次写入、44 拍，CRC 分别 `610C6A31/EC8497D3`。

混合 BLIT/Tile 场景第 3 个新增帧在 80235 ns 失败：`C4M7 BLIT count/CRC/error mismatch frame=2`，此前有序写入检查没有报错。完整失败 transcript 已保留 `core_blit_on.log`；当轮判定 PENDING，下一步同场景关闭流水进行判别，不修改黄金或放宽断言。当时尚未执行整机 P2a 资源/时序测量。

关闭流水的同场景对照也在 80235 ns 的相同新增帧失败，transcript `core_blit_off_probe.log`。前两 BLIT 帧的旧路径为 97 拍，写入与 CRC 同启用模式。该判别排除了流水开关独有回归；下一轮仅增加失败检查的实际 count/CRC/status 输出，定位测试参数或既有协议约束，断言条件保持不变。

增强诊断返回 `observed=1 expected=14 rendered=1 status=00010220`，定位第 1 号命令 malformed。原因是测试 helper 将 Tile 按 BLIT 的打包布局编码；Tile 应采用原黄金的独立 X/Y word、shape word 和 tile_size word。仅修正新增测试的 Tile 编码，同时按实际 core status 定义将错误检查由低 4 位加强到 `[11:4]`（last/sticky errors）。硬件、原黄金及断言期望保持原样；当轮待完整关闭/开启复验，修复后结果见下节。

### 局部门禁闭合

修复测试刺激后，关闭/开启流水的真实 XPM 六帧对照均 PASS，包含原两帧 Tile 黄金及以下四帧；有序 address/token、count、CRC 和 render error 检查全部保持。素材 generation 更新同时改变实际读取的素材字节，混合场景覆盖不同 slot。

| 新增帧 | 内容 | 写入数 | CRC | 关闭流水拍数 | 开启流水拍数 |
| --- | --- | --- | --- | --- | --- |
| F0 | 连续两条 BLIT | 11 | `610C6A31` | 97 | 44 |
| F1 | 连续两条 BLIT，素材更新 | 11 | `EC8497D3` | 97 | 44 |
| F2 | BLIT/Tile/BLIT，不同 slot | 14 | `C383C07C` | 132 | 100 |
| F3 | 混合序列，素材更新 | 14 | `BEA4A135` | 132 | 100 |

可重跑入口：先执行 `set gpu_verify_scope blit`，再独立 `source sim/scene2d_gpu/verify_tile_cache.tcl`。完整运行 173.584 秒，结果位于 `results/gpu-blit-verify-1791011812498/`。七组仿真为 Blit 24 用例、Tile 22 用例、原 core 缓存关闭/开启、原 renderer 默认路径、Blit core 流水关闭/开启；脚本检查完整 transcript 的明确 PASS 标记及 Fatal/Error/watchdog，全部通过。

同 part、100 MHz、相同接口约束的 Blit OOC 最终布线报告：

| 模式 | LUT | FF | Slice | BRAM Tile | DSP | MMCM | WNS/ns | WHS/ns |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 关闭 | 238 | 148 | 83 | 0 | 2 | 0 | 1.492 | 0.187 |
| 开启 | 262 | 186 | 90 | 0 | 2 | 0 | 2.144 | 0.147 |
| 增量 | +24 | +38 | +7 | 0 | 0 | 0 | - | - |

资源增量符合 P2a 局部门槛。OOC 有 160 个 input 和 42 个 output 缺 delay，工具提示缺少 `HD.CLK_SRC`；正 slack 仅为局部参考，整机闭合继续独立验证。

相关软件命令：`.venv/Scripts/python.exe -m pytest tests/test_scene_compiler.py tests/test_raster_trace.py tests/test_gpu_abi.py tests/test_game2.py tests/test_game_testing.py tests/test_video_codec.py tests/test_c6i_video_sink.py -q`，56 项通过，4 个子测试通过，37.09 秒。

### P2a 独立整机实验

入口 `board/pynq_z2/scripts/build_c6i_blit_pipeline_p2a.tcl`，project/report `c6i_blit_pipeline_p2a`，BUILD_ID `0xC0060720`，独立输出 `board/pynq_z2/output/gpu_blit_experiment/`。复用 P1 的 core、100/74.25 MHz 时钟、实现策略及 post-route phys_opt，显式开启 P1 Tile 缓存与 Blit 流水。公共构建入口默认关闭流水，开关一次性消费并 unset；BD 使用 `0x1` 且检查读回，manifest 记录开启状态。

15:22:11（UTC+8）通过当前 Tcl 会话启动完整构建，BD 两开关读回检查通过；生成的 `c6i.bd` 结构化解析确认两参数均为 `0x1`。命令正常退出，code 0、1931.337 秒，15:54:22 完成全部导出；原门禁变量结构化读回 `P2A_GATE_RECHECK PASS`，WNS/WHS 与报告及 manifest 一致。流水开关和实验输出 caller 变量均已 unset。旧 C6I/P1 入口和产物保留，当前未上板。

首请求的实际 NBA 对齐：READ 边沿 N 注册地址及 request context；N+1 的 XPM 更新返回字节，同时 response context 更新为该请求；N+2 使用更新前的 response context 和返回字节注册 write；父 renderer 在 N+3 采样该 write。持续请求使用同一对齐关系，nibble 选择取延迟上下文。最后不透明候选在父层采样后清 write_valid，drain 确认 request/response/write 均无效，再发 done。浅上下文共两级，每级 19 bit，未增加大块存储。

相关范围 `git diff --check` 通过。构建启动后的相关源及验证脚本 SHA-256（文档后续随门禁结果更新）：

| 文件 | SHA-256 |
| --- | --- |
| `rtl/scene2d_gpu/scene2d_index4_asset_blit.sv` | `A54F37AEE7227584A352696453685AE2EC53696EB7061B35A64A8B31AD074572` |
| `rtl/scene2d_gpu/scene2d_clear_fill_renderer.sv` | `A2A1FA6C0531CC0453AD06E4C9FC1103E1E21D8635B228A7E4F6E677C91A8BB2` |
| `rtl/scene2d_gpu/scene2d_c4m3_core.sv` | `4CDEF988F6AACA8C8F03F755ECBEF6805FC4DC776E18B734C50FE2F8F7575CBB` |
| `rtl/scene2d_gpu/scene2d_c4m7_core.sv` | `2C47285E33CD4FB3C468C9EFDDF2E845851697B03D1FDCD57B24387D2C38A343` |
| `sim/scene2d_gpu/tb_scene2d_index4_asset_blit.sv` | `B0CA5A12CE415E56AFC27CE35E5725A467CEF9FEA639FBDC6588E977902D75A8` |
| `sim/scene2d_gpu/tb_scene2d_c4m7_core.sv` | `1186539609D1C4968A386BD59DDFAB29F398C069BD01D1465697FB226286B2FE` |
| `sim/scene2d_gpu/verify_tile_cache.tcl` | `DFBF6DC9B9E639D048A5B70DF6CCF307E43E4FD50690558EDF39FC17C0EEA7FC` |
| `board/pynq_z2/scripts/build_c4m3.tcl` | `495B340FE8D10B748AD31B5BF00526862FDB5DDA11DC79FCDA5424D7AF04FFA7` |
| `board/pynq_z2/scripts/build_c6i_blit_pipeline_p2a.tcl` | `C1D684716140FED45F817B4A965C29A41EBD71445F99B80A60E09BD6FA26AE7F` |

### 整机门禁闭合与产物

最终 post-route phys_opt 报告位于 `board/pynq_z2/output/gpu_blit_experiment/reports/c6i_blit_pipeline_p2a/`：

| 指标 | 冻结 C6I | P1 | P1+P2a | P2a 相对 P1 |
| --- | --- | --- | --- | --- |
| LUT | 14025 | 13982 | 14005 | +23 |
| FF | 22845 | 22870 | 22908 | +38 |
| Slice | 7262 | 7250 | 7229 | -21 |
| BRAM Tile | 62 | 62 | 62 | 0 |
| DSP | 2 | 2 | 2 | 0 |
| MMCM | 2 | 2 | 2 | 0 |
| WNS/ns | 0.057 | 0.029 | 0.045 | +0.016 |
| WHS/ns | 0.050 | 0.014 | 0.053 | +0.039 |

P2a 整机子门槛 +500 LUT/+512 FF、BRAM/DSP/MMCM 无增量通过；累计相对冻结为 LUT -20、FF +63，满足 +1500 LUT/+2000 FF 上限。整机 LUT/Slice 的下降包含综合映射和布局差异，不归因为缓存或流水的因果资源节省；局部 OOC 增量独立保留。

DRC 无 Error/Critical Warning：DPIP-1 Warning 4、DPOP-2 Warning 2、REQP-165/181 Advisory 各 2；部分 DSP 寄存器实例名随流水改变，种类和数量与 P1 一致。Methodology 无 Critical Warning：TIMING-28 Warning 1、TIMING-47 Warning 2、XDCB-5 Warning 1。CDC 与 P1 相同六项 CDC-3 Info，原两方向 asynchronous clock groups/User Ignored 保留；clock interaction 的已计时关系为 Clean。未增设例外、豁免或改频率；原 4 个输出缺 delay 的范围边界保留，内部 unconstrained endpoints 为 0。

| 文件（位于 `board/pynq_z2/output/gpu_blit_experiment/`） | SHA-256 |
| --- | --- |
| `c6i_blit_pipeline_p2a.bit` | `47B4BF579BE75DEACFCC636096121004285120BD61073762C047B9EBC322E600` |
| `c6i_blit_pipeline_p2a.hwh` | `2AD2F0526BB440EEF260B7964BDEA40B6EB88896A70393AD0ADAA02BBD75B9FF` |
| `c6i_blit_pipeline_p2a.xsa` | `FDD115F02B13C6117146C85A3410AF3C1D4EBE9545C4C77581F1C21824EC840A` |
| `c6i_blit_pipeline_p2a_manifest.txt` | `58EA898BFE5047E02AD502C0B21BC22244283198CF5E3905B7D366E0176AD9D1` |

XSA 内主 `c6i.hwh` 与外部 HWH 逐字节一致。内部 `c6i_blit_pipeline_p2a.bit` 整文件 SHA 为 `66AF093235059D0E736A3301D52CCA84C8EA1A94887FFE4B1975E5528DE93A3D`，与外部 bit 不同；按二进制字段解析证明差异仅为头部时间 `15:53:37`/`15:54:11`，设计名、器件、日期相同。两份完整配置体均为 4045564 字节，SHA-256 `C025F16E3801B854C245ABE4CE0F4BEE1A63292DE87D3980B157C60BBC0973B3`。只读核验未修改产物，未执行的临时 PowerShell 脚本已移除。

## P2b：Tile 单像素流水实施

16:28 启动独立 Tcl 会话 `vivado-20261003-162823-07e9566b`，隔离结果 `results/gpu-tile-pipeline-1791016124056/`。原 Tile 22 例 baseline PASS/15.41 秒；新增默认关闭 `TILE_PIXEL_PIPELINE_ENABLE`，两级浅上下文携带目标地址、nibble、valid，descriptor 在整个水平 run 和 drain 保持稳定，跨 tile/行/错误先排空。首片原 22 例 PASS：黄金 P1 53→43 拍，size16 场景 9540→2340 拍，有序 trace 与错误前缀一致；尚未证明 II 或整机资源。

16:41 功能切片：31 例 Tile 测试在 cache/pipeline 的 00、01、10、11 四组合均通过。修正末像素透明刺激地址为 247 并新增实际写入数 255 断言后，四组合重新通过；缓存和流水开启时长不透明行的写间隔为 1 拍。默认关闭参数已传至 renderer、C4M3、C4M7，原真实 XPM 六帧通过：纯 Blit 44/44 拍，混合帧 90/90 拍，count/CRC 不变。

新增真实 XPM 四帧多行 Tile/Blit/Tile，每帧 27 次有序写，素材及 tilemap generation 与内容实际更新，覆盖两个合法 Tile slot、翻转和 palette 切换。流水开启为 205/203/205/203 拍，独立 trace/count/CRC/status 通过。renderer 长 Tile watchdog 前实际写入 106 次，取消后上下文清零；随后短 Tile 的 4 次有序写和独立 CRC `34B161C1` 通过，无残留写，旧 renderer 黄金检查同时通过。完整脚本回归、固定缓存 OOC 对照及整机资源/时序门禁待执行。

### 门禁与经验归档

BD JSON身份核验：三开关均为`0x1`。首次脚本错误假设BUILD_ID来自GPIO的`C_DOUT_DEFAULT`，触发KeyError；实际GPIO为`C_ALL_INPUTS=1`，BUILD_ID来自`build_id_constant.CONST_VAL`。按真实component/parameter解析后exit0，值`0xC0060730`、宽度32，三开关再次核验通过。此为只读验证脚本假设错误，未修改BD或硬件。经验：先核对GPIO方向和实际驱动源，身份字段以生成BD/HWH中的常量及连线为依据，不猜输出默认值。

17:30 身份与复核：P1/P2a各bit/HWH/XSA/manifest共8个SHA全部与已有记录相同。经验guide最新源/部署SHA为`C86AA9FC1563468EEC3B5183D798A49B1689A9864AC36DD646E236BEDE8BD633`，安装脚本全量校验通过；主SKILL SHA保持前述值。辅助仿真会话`vivado-20261003-171137-c507365a`已在完整runner退出0后关闭，主构建会话仍运行。

只读代理提出共享palette可能错位的推测，实际RTL在PIPE_DRAIN等待request.valid/response.valid/write_valid全部0才恢复READ_TILE，随后SAMPLE_TILE更新descriptor；已通过的2×2相邻descriptor palette/flip及真实混合场景覆盖该边界，推测未确认。原点OR/XOR在既有二次幂对齐合同和16bit截断下等价。cache0/pipeline1保留逐候选descriptor fetch是显式验证合同，未隐式启用缓存。代理建议仅作线索，以实际控制流和日志复验为依据。

| 文件 | SHA-256 |
|---|---|
| `rtl/scene2d_gpu/scene2d_draw_tile_layer.sv` | `1C2C03CF107E800C0E13BCA56D12F9DAD9F746B0312821FAB079B8B920D365F9` |
| `rtl/scene2d_gpu/scene2d_clear_fill_renderer.sv` | `13FA1C9CD9DF2AF9A5BBAAB2492C5D1984F3AABBA6CD90BAD801584194D654BD` |
| `rtl/scene2d_gpu/scene2d_c4m3_core.sv` | `32D520831AEE84357E4BFC013D076D101C37F28D31E5B9DE2B4FD5C42EB01153` |
| `rtl/scene2d_gpu/scene2d_c4m7_core.sv` | `148EB520E5A15CFFB2765D4B92C16F8E257337A25315A773E9F95EFD4B751DEA` |
| `sim/scene2d_gpu/tb_scene2d_draw_tile_layer.sv` | `DB97A59A1D9D28E5EEE63709CFF77BDE83E6BCDB43E581A144925CB25008F8B2` |
| `sim/scene2d_gpu/tb_scene2d_c4m7_core.sv` | `76F684D3862255EED577DB3BFA066C65B3A3BACDDF05D25F658BEE6092E69213` |
| `sim/scene2d_gpu/tb_scene2d_clear_fill_renderer.sv` | `12E813625F560218FDF98C50F0ADFB6F01F4E72F0350B50E5ABE8DEFAD0AE96F` |
| `sim/scene2d_gpu/verify_tile_cache.tcl` | `0D706DA49A22A0728E79A4AD023BF6C3A63018FE96FFA352E81F34B0EDE132D3` |
| `board/pynq_z2/scripts/build_c4m3.tcl` | `8CD9CA7D994C3F9BF192820B6FE3C985237F21FAE0D3B2912BA1AD7D1EE044B1` |
| `board/pynq_z2/scripts/build_c6i_tile_pipeline_p2b.tcl` | `C53D7A71623CBFE08AE6CD9036A3D3CC186D83EAA506FC8625A1C21E10213293` |

17:25 最新TB完整runner exit0/299.972秒，结果`results/gpu-tile_pipeline-verify-1791018965715/`，14次仿真含真实错误前缀均通过，OOC与第三轮一致。只读调度检查经历PowerShell ParserError和仅`^C`，均未作为成功；Pylance初次缺workspaceRoot、随后正斜杠pythonPath被绝对路径校验拒绝，查询PythonEnvironments取得编辑器实际`e:\projects\fpga\voice-view-game\.venv\Scripts\python.exe`后运行成功。使用明确workspaceRoot和该原生路径，`git diff --check`真实exit0。运行标志核验显示GP0 SmartConnect OOC于17:24:52仍更新且无error标志，PS7和主综合仍未启动；属于jobs1串行等待，当前没有恢复/停止/重启构建的证据。只读代理仅依据尚未启动run推测阻塞的说法未提升为根因。

17:03 第三轮完整 runner exit0/298.057秒，`results/gpu-tile_pipeline-verify-1791017828943/`。固定cache1的off/on为975/1031 LUT、458/529 FF、320/331 Slice：增量56 LUT、71 FF、11 Slice，BRAM/DSP/MMCM均0。on最终timing summary WNS **0.281 ns**、WHS **0.121 ns**，TNS/THS均0；OOC接口缺项保持，整机门禁独立执行。修复只新增浅派生寄存器，未增加FIFO、存储核或特定游戏限制。

独立构建入口 `board/pynq_z2/scripts/build_c6i_tile_pipeline_p2b.tcl`，BUILD_ID查现有分配后使用`0xC0060730`，输出`board/pynq_z2/output/gpu_tile_pipeline_experiment/`。缓存、Blit流水、Tile流水均1；旧入口Tile流水默认0。生成bit前硬门禁LUT≤14505、FF≤23420、BRAM≤62、DSP≤2、MMCM≤2；沿用100MHz/74.25MHz和P2a实现策略/phys_opt。17:03开始整机source，当前运行中。

17:12 真实核心增加合法height3资源的部分行后源越界：pipeline0/1均11次有效前缀、CRC `4EE0CF48`，错误标志malformed，后续Blit未执行；日志`core_error_off.log`/`core_error_on.log`保存在首隔离目录。软件现有相关集56 passed、4 subtests passed/36.12秒。

已验证经验归入仓库`xilinx-skill/plugins/xilinx-suite/references/vivado_guide.md`“浅流水验证与关键路径拆分”，使用`install.ps1 -Skills xilinx-suite -SkipAgentInstructions`同步并校验。Skill主文件源/部署SHA均`41D6D8511EDE06B6F26E58A810E81A9E9228E0C874BAC9F16920B52FFB62B73C`，guide均`3246699F8C9D1BDB3BFBFB1797D47A0BF7634B34F5F235AC293153582316D5A9`；OpenClaw未安装，SKIP。未直接修改部署副本。apply_patch单patch重复同一Update路径被工具拒绝后合并该文件的各hunk重新执行成功，此失败没有工程文件落盘。

16:55 源原点锁存后：窄四组合31例再次通过，完整14次回归 exit0/290.734秒，结果 `results/gpu-tile_pipeline-verify-1791017394081/`。on OOC WNS -0.512 ns、WHS 0.135 ns；最坏路径改为 output_x[8] 经 descriptor 地址计算/匹配至 output_x CE，仍13级、10.223 ns。下一局部修复为锁存已验证descriptor的水平run终点，保留READ_TILE完整32bit tag匹配，run内仅比较范围；利用二次幂tile源原点对齐性质将原点与局部像素偏移拼接，去除逐像素加法链。未更改时钟/约束，整机仍PENDING。

16:48 完整 `tile_pipeline` runner 返回 exit0/295.324 秒，14 次仿真 marker 均通过，产物 `results/gpu-tile_pipeline-verify-1791016975892/`。新核心对照 off 为 265/265/265/265 拍、on 为 205/203/205/203 拍，CRC 完全一致。OOC cache 固定 1，off/on 为 975/1045 LUT、458/497 FF、320/335 Slice，BRAM/DSP/MMCM 均 0；WNS 为 -0.211/-0.981 ns，WHS 0.119/0.183 ns。OOC 接口 252 输入/53 输出缺 delay，时钟缺 HD.CLK_SRC，仅局部参考；流水版关键路径从 active_tiles_per_row[3] 经源坐标/边界计算到 output_x CE，13 逻辑级、10.692 ns。整机尚未运行，先把 descriptor 源原点提前锁存到 descriptor 采样边界，再保持相同回归与 100 MHz OOC 重测。资源增量合门槛，时序当前 PENDING。

### P2b 最终离线验收

独立 wrapper 命令：`source board/pynq_z2/scripts/build_c6i_tile_pipeline_p2b.tcl`。主会话 source 正常 exit0，耗时1925.663秒；空闲后从原门禁变量复核得到`P2B_GATE_RECHECK PASS`，WNS 0.045 ns、WHS 0.050 ns、DRC Error/Critical 0、methodology Critical 0。三开关读回均`0x1`，BUILD_ID `0xC0060730`；cache/blit/tile/budget/output caller变量均已消费并unset。完整命令/日志保存于`results/.vivado-ai/vivado_16103123_eb5dfdc7.log`。

| 项目 | 冻结 C6I | P2a | P2b | P2b相对P2a |
|---|---:|---:|---:|---:|
| LUT | 14025 | 14005 | 14110 | +105 |
| FF | 22845 | 22908 | 22968 | +60 |
| Slice | 7262 | 7229 | 7236 | +7 |
| BRAM Tile | 62 | 62 | 62 | 0 |
| DSP / MMCM | 2 / 2 | 2 / 2 | 2 / 2 | 0 / 0 |
| WNS / WHS(ns) | 0.057 / 0.050 | 0.045 / 0.053 | 0.045 / 0.050 | 0 / -0.003 |

P1+P2累计相对冻结为+85 LUT/+123 FF，满足累计1500 LUT/2000 FF预算；P2b相对P2a符合500 LUT/512 FF子预算。Slice与LUT映射/布局差异含工具噪声，不将下降归因为优化面积节省。保持100 MHz render、74.25 MHz pixel、320×180双bank各57600byte、INDEX4和4×输出；ABI1.0、Game SDK1.1、素材容量和绘制顺序未改。

最终报告目录：`board/pynq_z2/output/gpu_tile_pipeline_experiment/reports/c6i_tile_pipeline_p2b/`。DRC为DPIP-1 Warning4、DPOP-2 Warning2、REQP-165/181 Advisory各2；methodology为TIMING-28 Warning1、TIMING-47 Warning2、XDCB-5 Warning1，与P2a一致。CDC仍仅6项CDC-3 Info，源/目标及深度相同，现有Asynchronous Groups保持；clock interaction同域Clean，跨域Ignored策略未改。4个输出缺delay及内部unconstrained endpoints0保持，无新增waiver或约束放宽。

独立产物位于`board/pynq_z2/output/gpu_tile_pipeline_experiment/`：

| 文件 | SHA-256 |
|---|---|
| `c6i_tile_pipeline_p2b.bit` | `E4A319E3C381A422CBFFE4C64E6706D115975092942CC4596A8455B50A98FD43` |
| `c6i_tile_pipeline_p2b.hwh` | `5C444F72F5C4325329414BB02D3042EC1E5237693F8FB26CCED1B09D1F1A5224` |
| `c6i_tile_pipeline_p2b.xsa` | `3608D7E6841D0CF45A4A4FAE2545E44B88752082BDAD3BE9CB2BE70606DCF970` |
| `c6i_tile_pipeline_p2b_manifest.txt` | `B8E7FCE54EE339F6074C3E412C665672B9B5A5B5D60EAB388F3C2C0A2DCE9393` |

XSA内bit SHA `AA54DCBDB34A7BC650CEEA363179F945E612004A388AA677D95D7E948418DB4D`。按bit a/b/c/d/e字段长度解析，外部与内部bit仅时间头17:35:14/17:35:48不同；完整4045564字节配置体逐字节一致，SHA `82C1CF732A6FE4623AF3EDF31A153040213C57E9368C5CAE7161CDD3B5441CB2`。XSA主HWH与外部HWH逐字节一致，XML核验三开关和常量BUILD_ID通过。未修改产物以对齐头部时间。P1/P2a原八产物保持。

最终经验guide源/部署SHA均`A40077D920E83CD53810919B10DAD4E33C1D38EF1582275D5E57D3348663E86A`，Skill主文件保持前述SHA；安装脚本全量校验通过，OpenClaw未安装SKIP。失败事实、未确认推测与已复验经验分别归档。

## 下一阶段

P1、P2a、P2b GPU离线门禁已闭合，发布入口三优化开关仍默认关闭，实验产物保持隔离。P3两像素路径和P4上传重叠按实测瓶颈与多模态余量准入，当前均未实施。板卡保持下电；同板视觉+声音+游戏并发、Studio数据回传与部署验收作为后续整合门禁，当前GPU PASS不等同于这些整机工作流已通过。
