# PYNQ Preflight 初版证据库存

## 身份与范围

- 日期：2026-10-06；类型：离线来源库存与规则提炼记录；包版本 0.2.0。
- 自有源入口：[SKILL.md](../skill/pynq-preflight/SKILL.md)；规则：[证据卡](../skill/pynq-preflight/references/evidence-cases.md)；固定输入：[evals.json](../skill/pynq-preflight/evals/evals.json)。
- 原始记录、第三方包、用户部署副本与冻结硬件/算法全部保持只读；未启动 Vivado、SSH、Overlay、MMIO 或 DMA。桌面 CSV 未用作本次来源。
- 完整库存覆盖 bringup 的35份 Markdown、1份启动日志、14份会话 JSON、13份备份与原始 MCP 历史。所有库存文件已完整载入计算身份、扫描标题和末轮；规则采用的声音/视觉/融合章节及代表原始命令另作详细核对。其他历史文档仅完成库存与终态线索检查，未逐条重新审计所有错误与附件。
- 原始文件存在不等于证据内容通过；静态包校验与 Agent 行为、跨板支持、相对 ROSS 收益分别验收。

## 原始 MCP 来源

原始调用库已经定位，无需手工导出 CSV。只读 SQLite URI 使用 `mode=ro`，读取当前 VS Code 工作区 `state.vscdb` 的 `ItemTable`，键 `AMD.vivado-ai-extension`，内部字段 `vivadoToolCallHistory`。数据库所在目录由当前工作区实际存储位置确认，不能跨工作区套用路径。

该数组共675条，保留 `id/tool_name/arguments/outcome/success/tcl_exit_code/duration_ms/result_bytes/result_preview/timestamp/session_id` 等字段。时间范围为 2026-10-03 13:59:06.752 至 2026-10-06 02:46:20.785（UTC+08）。时间戳为 epoch 毫秒；耗时单位为毫秒，与会话历史 `elapsed` 秒分开。

历史数组的规范 UTF-8 JSON 身份：`json.dumps(history, ensure_ascii=False, sort_keys=True, separators=(',', ':'))`，1188311字节，SHA-256 `9E18C502ADEBB70C92C94E2D8B5322DFD8C90EACF9611C6CC038AF250D0A35C0`。采用数组内容身份，避免把其他会自动更新的编辑器状态字段误作历史变化；没有把整库或私人参数复制入源包。

| 工具 | 调用记录数 |
| --- | ---: |
| vivado_start | 13 |
| vivado_todos | 134 |
| vivado_execute | 417 |
| vivado_status | 91 |
| vivado_stop | 11 |
| vivado_history | 1 |
| vivado_client_info | 1 |
| vivado_list_sessions | 6 |
| vivado_log_messages | 1 |

原始 outcome 为 `success=637 / tcl_error=37 / error=1`；工具层 `success=true=674 / false=1`，退出字段 `0=638 / 1=37`。37条 Tcl 失败的工具层 success 仍为 true，唯一工具层 error 是任务计划身份错误。各计数保留其字段口径，不计算预检故障率或已测节省率。

- `tc-muuz563l-e`：todos 向 global 更新 task2/active，`no plan found`，outcome error、success false、tcl_exit_code0。之后同会话更新成功，见声音 E02。
- `tc-muv2v2rs-o`：声音阶段判重，outcome success、success true、tcl_exit_code0，duration_ms2；实际命令历史 id52 的 elapsed0、SKIPPED 不代表 route 执行。
- 工作区扩展 `toolCalls/` 保留167份完整工具回执文件；按文件 stem 对应历史 id 得到166份关联、509条完整回执缺失、1份待关联孤立文件。166份关联文件全部可按 JSON 对象解析；结果字段自身仍可能 `output_truncated`，完整工具回执不等于完整 Tcl 执行日志。
- Header 失败回执 `tc-muvdx8cx-b.txt`：18356字节，SHA `0FDD2C010A2FA29A538A2C7427715C1AD84F1BC368414AFE77C77136830F1322`；声音首次 Fatal 回执 `tc-muuzhucd-m.txt`：5864字节，SHA `8B28B33831A868F0307BE5781745B271AABDA425D653CF75494C2F838D34D86B`。判重与 global 错误的完整文件已缺失，其历史字段/预览和项目台账仍可追溯。
- Copilot 原始 JSONL 的开始/结束事件按 toolCallId 关联得到730次请求：675次上述 MCP 加55次文档搜索；截止点为 2026-10-06 11:00:00 UTC+08。730次可解析请求全部匹配结束事件，但结束仅含 toolCallId/success，不能代替领域结果。标准 JSON 解析也确认第18799与21042行无效；保留原文不修改，统计仅针对可解析事件子集。

## 会话库存

来源为用户原始 `.vivado-ai/data/sessions/`，共14份、419条命令；非零退出41条、SKIPPED8条、显式 output_truncated35条。会话执行范围从10月2日烟测至10月6日融合；419条不是419次独立实验，也不是675次工具请求的同口径总数。原始 log_file 对应文件14/14存在，未声称每份日志均完成逐段审核。

按 `session_id + 原 command 文本` 的多重集合关联，Dashboard的417次vivado_execute全部精确匹配命令历史，execute-only为0。另2条history-only为10月2日烟测id1/version，以及融合会话id24/wait_on_run（source chat、code0、elapsed68.257秒、输出带running和截断）。后者没有独立Dashboard执行请求可匹配，来源/最终完成按各层继续追溯，不虚构调用ID或合并为新增实验。

| 会话 | 命令 | 非零 | SKIPPED | 截断 | 文件 SHA-256 |
| --- | ---: | ---: | ---: | ---: | --- |
| vivado-20261002-181705-1dee9e6b | 1 | 0 | 0 | 0 | 49CDB896DA26371CC25FF3E8FB5A9AEC76A841133934451B247372BA8EA4F0FD |
| vivado-20261003-135855-fd02a631 | 15 | 2 | 1 | 2 | 71EE2AB3C4F70B25B51BBE0B5BF69CBB9AAC754491307D216F4336B2C3B60E53 |
| vivado-20261003-142801-d125834a | 2 | 0 | 0 | 0 | FDAEA0F3074192D314F9828F2BF296BD89664F142BF5383FB17E3759DAD5BB33 |
| vivado-20261003-150111-be85d26e | 20 | 3 | 0 | 2 | 933317764262F0B3A29C096BBEC14C4227CC415F777437B4BC04FEF56EE2A3F9 |
| vivado-20261003-162823-07e9566b | 23 | 1 | 1 | 4 | 3E81519A6A348A7120F53815B67CAAC4CDCFFCB15FD249207C04948968392401 |
| vivado-20261003-171137-c507365a | 6 | 0 | 0 | 1 | DAC9CA1A9AD02D9BACFADA84FEE37991E525A3151CF4B93E387153EE65074ED4 |
| vivado-20261003-180830-f618d688 | 54 | 7 | 1 | 8 | C5CDC453C82D0719409E615826BF2D499C042595C73D43AE5D9B89DA3C324FE8 |
| vivado-20261003-183736-037e8c1f | 16 | 2 | 0 | 1 | F7667E55F762151545EA665567C78C1760BC423DAECFEA24612E55C471083087 |
| vivado-20261003-203314-8e9ef160 | 30 | 0 | 2 | 5 | 128F7F9A23E3D12AFA6FC7E746B3B004C3DCB883D4CE07EF398D8ADC8BB68229 |
| vivado-20261003-210134-423d7501 | 15 | 1 | 1 | 0 | 4592CF971CB16AFF3FE87EF8F636736B276EFAD7B1EDC58A72B850B53F3DA15A |
| vivado-20261003-230743-067479f3 | 43 | 6 | 1 | 3 | 9B7CB91AB2429F4BE7FF3B5C828E77A3CA7C0E17AF9F733E92D98F1C48141E06 |
| vivado-20261003-235540-383c86bc | 25 | 0 | 0 | 2 | A6296EA644F4D13FF5C132213691BE7375EEA1EFA5A701B932A1590B265AF3B8 |
| vivado-20261005-161228-97c3f3ba | 78 | 7 | 1 | 2 | 169D4750E9291162F3BC235EB455696A1AB802725F2DD5E06E97C09388C06E72 |
| vivado-20261005-225852-e6d60b6f | 91 | 12 | 0 | 5 | E4D851DE328C3B0879400985FAD717659405F196F8CDDF1CBFD1FF49710C83C2 |

`backups/sessions/` 的13份 .bak 均已结构化读取；command_history 与对应现文件的前缀完全一致，且各少最后一条，因此不计新增命令/实验。文件整件 SHA 不同是旧快照身份差异。archive 空。历史 is_running 不用于判断当前进程是否存活。

## Bringup 完整库存

以下为本轮只读快照。内容/终态线索以最后章节和后续更正为准，不将摘要重复计数或自动提升为正式验收。正文位置按原文件章节追溯；行数仅用于复验快照身份。

| 文件 | 字节 | 行 | SHA-256 | 内容与终态线索 |
| --- | ---: | ---: | --- | --- |
| [2026-09-25_pynq-z2_c2.md](bringup/2026-09-25_pynq-z2_c2.md) | 6900 | 126 | 4B5DB5A340F51AC27E993A246CB9EEC7B80F3506DA51B81A6F9DEB450D3B3858 | C2装载/输入/回放；两组30分钟稳态待验 |
| [2026-09-26_pynq-z2_c3.md](bringup/2026-09-26_pynq-z2_c3.md) | 17418 | 123 | AB6C387C21ADE2FBC7FA1C24B0CE0814C4EDABF81C4A2BC96209E6AC4002524C | C3实屏彩条通过；30分钟稳定待验 |
| [2026-09-26_pynq-z2_c4m1.md](bringup/2026-09-26_pynq-z2_c4m1.md) | 9035 | 142 | 04C8D5A8ABDA41F590B145BA292581F2348CBB952486181270346FC7D60A140E | 命令上传/BRAM、当前状态及经验同步 |
| [2026-09-26_pynq-z2_c4m2.md](bringup/2026-09-26_pynq-z2_c4m2.md) | 7960 | 132 | DC0E8E34AFED77A8A5B5733F26B6447149B1D14D7EDDE0C0AF206049089BDCE5 | CLEAR/FILL、watchdog/仿真状态与路径 |
| [2026-09-26_pynq-z2_c4m3.md](bringup/2026-09-26_pynq-z2_c4m3.md) | 4090 | 87 | 8F828E58DEAF31A1296FCBDF39521B759C39CF9936D830BA8632C6985C47A34E | 实现与10轮重载通过 |
| [2026-09-26_pynq-z2_c4m4.md](bringup/2026-09-26_pynq-z2_c4m4.md) | 9225 | 136 | 15DCDC3B0DD958A2E7984254C2802963D047557BE2957839EF538B7EC46A7883 | BLIT闭环；早期xsim日志已覆盖 |
| [2026-09-26_pynq-z2_c4m5.md](bringup/2026-09-26_pynq-z2_c4m5.md) | 5147 | 87 | 3437D8E136604E277F66BDEA78CE2A7DE918773C9D3D984459C4793BB49D4375 | Palette与generation/ownership，10轮通过 |
| [2026-09-26_pynq-z2_c4t.md](bringup/2026-09-26_pynq-z2_c4t.md) | 5984 | 129 | 59D9C2975D568490B39771EDEBCD3FDDEA007D3B85BF314FEA2693903424CBA1 | HP0传输、CRC/吞吐；版本采集引号错误 |
| [2026-09-27_pynq-z2_c4m6.md](bringup/2026-09-27_pynq-z2_c4m6.md) | 6170 | 119 | C6D6963AE33FD868EB61D04615A524845CC091FCC003DDA640641073FBC9B39E | Asset bundle重载通过；有限slot边界 |
| [2026-09-27_pynq-z2_c4m7.md](bringup/2026-09-27_pynq-z2_c4m7.md) | 22196 | 157 | 443BDA2C360AE653E0A275F601C0D52C2823C13B982695C17E457E75E12A834F | 冻结/10轮通过；依赖、终端中断、DMA有界等待 |
| [2026-09-27_pynq-z2_c5.md](bringup/2026-09-27_pynq-z2_c5.md) | 4518 | 63 | 74DCA8E218D3CB624E15E281AEB62F7FD756F089396661FFDE6D1AF0F034919F | 构建暂停，无有效发布制品；主线转Studio |
| [2026-09-28_pc-studio_s0.md](bringup/2026-09-28_pc-studio_s0.md) | 4551 | 67 | C94163D467F16A37D23BD1B5FC96FF253B6DC068673D091685A9E0AA88806125 | S0/S1 PC框架、模拟/replay边界 |
| [2026-09-28_pynq-z2_c6i.md](bringup/2026-09-28_pynq-z2_c6i.md) | 10385 | 111 | 21BE2A54816FED8C9B4677D82F9BAC1F61328E09F9A353F7C444BEB6F00B57FE | 双向DMA/权限/依赖；长任务输出边界 |
| [2026-09-28_pynq-z2_c6t-return.md](bringup/2026-09-28_pynq-z2_c6t-return.md) | 8036 | 91 | EBBBAA90CF649C440376E69CEC52450BFF8C52C61F4CE5C02F9A0A9D2CD84FA4 | 返回传输与参考计算耗时分离 |
| [2026-09-29_pc-studio_s3.md](bringup/2026-09-29_pc-studio_s3.md) | 7738 | 91 | C23A8AC02F35D1285243132CB486D69F16D08973A9AB5E30ABCDD9686E222521 | Mock协议、DATA等待、Qt worker停止 |
| [2026-09-29_pc-studio_s5.md](bringup/2026-09-29_pc-studio_s5.md) | 17257 | 122 | 27C9111907C14F13D902464A634DC3DFE3C3333ECDBAA62945403AC5B25BBE4B | S2V1软件合同；真实复验分层 |
| [2026-09-29_pynq-z2_studio-s3.md](bringup/2026-09-29_pynq-z2_studio-s3.md) | 70891 | 1020 | BDFEF93666B957F5A4B94E53D9218A78CC5BF7996C9101FF217CD4D94194AB75 | 多轮门禁；末轮后台启动失败中止，部分NOT_RUN |
| [2026-09-29_pynq-z2_studio-s5.md](bringup/2026-09-29_pynq-z2_studio-s5.md) | 35161 | 196 | FB7D912713464DA1683FB6406DB9432A282662D210D8BDFA2928A2198A3C9E73 | shared session/短fixture通过；并行长稳态待验 |
| [2026-09-30_pc-game2.md](bringup/2026-09-30_pc-game2.md) | 1825 | 37 | 2BA68B0DD7D0E7B8FD17D88243A51CAA014934067FC8DC15BADFC47ACEC06CA1 | PC跨游戏通过；板端门禁独立 |
| [2026-09-30_pynq-z2_game1.md](bringup/2026-09-30_pynq-z2_game1.md) | 10559 | 135 | 667BB12B794FCFCD8B1833ED5E42607FF2168A1169BDF91830ADBE968C6677A6 | SDK1.1原生运行/持久身份；现场HDMI待验 |
| [2026-09-30_pynq-z2_ov5640.md](bringup/2026-09-30_pynq-z2_ov5640.md) | 10000 | 179 | E15FDB446E19FE4A8E1EC91C78D314D5F4491CD467628E7D6C5CA1AA7FD021AF | 旧独立相机离线；后续接线/验收须看更正 |
| [2026-09-30_pynq-z2_studio-s5-spatial.md](bringup/2026-09-30_pynq-z2_studio-s5-spatial.md) | 9817 | 91 | 1C7448ACEF71EF63B0B531334211578AA90C6EE026FBC697B54C59FBEE24EADD | 实屏与长视频两循环通过；source3并行另验 |
| [2026-09-30_pynq-z2-shell.md](bringup/2026-09-30_pynq-z2-shell.md) | 6027 | 69 | D9DB8ADD82ADABBC838F5D8BEE89A66431F22E3BB18601954676CD5F18947A75 | 菜单/Library与现场四入口；结构化测试输入 |
| [2026-10-01_pynq-z2_camera_direct_plug.md](bringup/2026-10-01_pynq-z2_camera_direct_plug.md) | 154597 | 782 | 942B3BDF50EFE1287CD597197130BFA6A95EAC82ED239272B1B898C11AF4B1A6 | 针表、共享帧/守护停机；最终下电停机回执缺失 |
| [2026-10-01_pynq-z2_ov5640.md](bringup/2026-10-01_pynq-z2_ov5640.md) | 43675 | 543 | 53306ECDF3A48DECE7B08BB278F85CDA9595059F2F4A91D5B3FFAFF6F5B1C0E4 | 单变量曝光试验未恢复同步，已撤回写入 |
| [2026-10-03_pynq-z2_gpu_parallel_optimization.md](bringup/2026-10-03_pynq-z2_gpu_parallel_optimization.md) | 74709 | 542 | 31A5813DCC5F267CBCB7B87EDF6845FB1FDE09030DECFBA102FA65EFA5E0885F | P1/P2离线；XSA配置体与头部身份分开 |
| [2026-10-04_pynq-z2_gpu_upload_overlap_p4.md](bringup/2026-10-04_pynq-z2_gpu_upload_overlap_p4.md) | 10496 | 96 | CF1F37F2100ECEE213C23B2A616330F17D27D6DA06BF905011A284C46613EAB4 | P4离线闭合；实板并发/Studio端到端另验 |
| [2026-10-05_pynq-z2_vision_v0_v1.md](bringup/2026-10-05_pynq-z2_vision_v0_v1.md) | 26525 | 168 | A036811E0A8B282AB635A1C608413BAEF1B67B16AB3F7F49BDEEA379B8D78FB7 | PC观察、类型与栈取证；BOARD_PENDING |
| [2026-10-05_pynq-z2_vision_v2.md](bringup/2026-10-05_pynq-z2_vision_v2.md) | 18850 | 150 | 116B342F67E6FEB5D8154A69ED7386975CCB43B66FDD21DF228DE40F96422BA2 | 控制面离线；真实owner/DMA与稳态待验 |
| [2026-10-05_pynq-z2_vision_v3_v4.md](bringup/2026-10-05_pynq-z2_vision_v3_v4.md) | 59147 | 295 | E43386853028157745E4BE5E088F1B0C61039A71DE6E5D78A666307495362BE1 | 完整离线候选；header/缓存/IP/run/签核错误与复验 |
| [2026-10-05_pynq-z2_voice_p0.md](bringup/2026-10-05_pynq-z2_voice_p0.md) | 8342 | 106 | B8A92A73997E87F41902FCC7E299A84080DDA20509C018D41D5B87643BBA0CFD | SSH认证前关闭；P1已启动，P0现场仍阻塞 |
| [2026-10-05_pynq-z2_voice_p1.md](bringup/2026-10-05_pynq-z2_voice_p1.md) | 33165 | 251 | 9F774D55278008157AB9E70872E17CF1D0377EDA5D36EEBCDAEA049FDD730237 | 原生迁移/便携交接通过；数值/跨版/警告/实板待验 |
| [2026-10-05_voice_2026_upload.md](bringup/2026-10-05_voice_2026_upload.md) | 3890 | 36 | ACA7E439EAD7205A0F7ACFA745F523A099E5F49DFCFC712B4185C05832F43A79 | 上传身份已签收；Git身份只在隔离克隆配置 |
| [2026-10-06_c6i-vision-r2-agent-start.log](bringup/2026-10-06_c6i-vision-r2-agent-start.log) | 1880 | 17 | A6FCCFCE287100E99FABF6DCF1A1A863C6C4E0228074ACF06481B58FC02E1198 | r2真实初始化失败原文 |
| [2026-10-06_pynq-z2_vision_fusion_board.md](bringup/2026-10-06_pynq-z2_vision_fusion_board.md) | 34140 | 185 | 65A6175EFD7D27470CD026106B6E1C2393F45FC49EFF823BB9C63CE161AA4681 | 最新r8真实回传与GPU票据；真人/HDMI/稳态待验 |
| [2026-10-06_vision_fusion_upload.md](bringup/2026-10-06_vision_fusion_upload.md) | 5329 | 45 | D8C4F1A5B485A446CD507AE189465F6416B2D06ADF8A0B74FBA2EA939E4805FC | 完整交付/回归与正常合并；发布许可不提升 |

相机旧轮次与10月6日基线更正分开：当前融合沿用队友冻结直连/PCLK模型，撤销额外电平适配器阻断；旧记录仍保存其历史身份，不把旧接线猜测写成所有工程的门禁。当前融合以第20-22节 r8 为准，不停留在r2/r3故障状态。

## 其他直接文档入口

以下20份顶层文档已完成目录盘点，角色为设计、阶段计划、格式或验收合同；未作为本版每条历史故障的直接事实来源，全文语义审计留待对应任务。

- [amd_2026_self_selected_scoring.md](amd_2026_self_selected_scoring.md)、[amd_2026_skill_analysis.md](amd_2026_skill_analysis.md)、[amd_2026_track_guide.md](amd_2026_track_guide.md)：竞赛范围与评分。
- [c0_acceptance_2026-09-25.md](c0_acceptance_2026-09-25.md)、[c6i_vision_board_acceptance.md](c6i_vision_board_acceptance.md)、[c_role_implementation_plan.md](c_role_implementation_plan.md)：阶段验收合同。
- [game_development_workflow.md](game_development_workflow.md)、[gesture_vision_v61_handoff.md](gesture_vision_v61_handoff.md)、[gpu_ai_optimization_p0_p4_summary.md](gpu_ai_optimization_p0_p4_summary.md)：来源与开发阶段。
- [ov5640_pynq_z2_integration.md](ov5640_pynq_z2_integration.md)、[s2v1_video_format.md](s2v1_video_format.md)、[same_board_multimodal_studio_integration_analysis.md](same_board_multimodal_studio_integration_analysis.md)：接口与整合设计。
- [scene2d_gpu_architecture.md](scene2d_gpu_architecture.md)、[scene2d_gpu_register_map.md](scene2d_gpu_register_map.md)、[vision_first_studio_ps_pl_plan.md](vision_first_studio_ps_pl_plan.md)：架构/寄存器/视觉计划。
- [voice_2026_handoff.md](voice_2026_handoff.md)、[voice_first_integration_plan.md](voice_first_integration_plan.md)、[voice_native2026_improvement_plan.md](voice_native2026_improvement_plan.md)：声音交付与待验方向。
- [voice_view_studio_architecture.md](voice_view_studio_architecture.md)、[voice_view_studio_stage_plan.md](voice_view_studio_stage_plan.md)：Studio架构与阶段。

## 关键附件与缺口

以下9件本轮核存在、字节和SHA；只取必要原文/标记，未重新运行原始实验。

| 附件 | 字节 | SHA-256 | 本轮核查范围 |
| --- | ---: | --- | --- |
| results/voice-p1-20261005/native26_vivado_raw.log | 31657023 | 564A14B3139272B59DC7299DC6D4F3D7EF6B7FD5C1008210B6785DB84BA84005 | route终端标记存在；SKIPPED只在调用层 |
| results/voice-p1-20261005/native26_artifacts.json | 3220 | 86FF3BC768AAFEF3871FA3510069345C1BEC1B7712B48A0288E68502E713D5FF | 迁移制品清单身份 |
| results/voice-p1-20261005/simulate_attempt1_watchdog_fail.log | 1420 | 5B361AEC026A482C5F8B19E2613E6C70616229751E9B6BC651EF75D2FBAC3332 | Fatal/watchdog原文存在 |
| results/voice-p1-20261005/prepare_vivado_raw.log | 35595 | 2B3202A1DA20A55468A613AAB7856BA6786D72ECD04CF85AFB14D2C33CB0401C | 关键警告来源身份 |
| docs/bringup/2026-10-06_c6i-vision-r2-agent-start.log | 1880 | A6FCCFCE287100E99FABF6DCF1A1A863C6C4E0228074ACF06481B58FC02E1198 | 原初始化异常 |
| artifacts/studio/20261006_fusion/r8-full-view-game-receipt.json | 4796 | F46F4BB2D5A4B51B533D03C85F66D8F4FEE2242533B68E0535736D2EF9FC0396 | r8真实状态来源 |
| artifacts/studio/20261006_fusion/r8-pc-only-game1-direction-contract.json | 1371 | 6B21F7BF893564A16A3615E304CC2A7B05CDA4D7E1AAE5B7CDD47582AAE5DF67 | PC合成方向，不计真人 |
| artifacts/studio/20261006_fusion/r8-studio-real-http-receipt.json | 996 | 94C0FAFB93C1A99DB1B4A393763ACB3E85ED5CC849B5D204EA1930CBF46F5F98 | 原生HTTP来源身份 |
| artifacts/studio/20261006_fusion/r8-shortcut-native-real-camera.png | 456708 | 4ED4D6B7A0197D4ED67B1865D2C266836A013B4F00B844712E9D555A56B62606 | 原生入口截图身份，未作新版UI验收 |

完整执行日志按 session.files/full_output_path 发现，不猜默认目录。关联的执行日志/journal/代理文件用于交叉核验，未复制入包。原始r2启动日志带UTF-16 BOM，身份按原字节计算，行数按实际编码解析。旧C4M4被覆盖的xsim、2行无效JSONL、509条缺失完整工具回执、1份待关联回执均保留为覆盖缺口，禁止补造。

## 规则与评测完成度

- R01-R04：MCP判重、分层结果、真实会话身份与版本能力；R05-R06：文件注册、缓存/传播和制品合同；R07-R12：解析器/IRQ/冷启动/依赖/owner/部署证据。
- 保留原9例，增加7例，合计16例；直接历史输入、派生边界和近似反例分列。固定数据不执行日志命令，Agent评阅状态PENDING。
- OOC无法写入C与降低并行/环境变化后成功保留为实例关联，唯一根因待验；RTL/数值/时序修复进入专项流程，不扩展为自动预检修复器。
- 源包和项目库存各自维护：包内仅10件自包含文件，库存不成为独立包运行依赖；用户级安装、硬件复验、commit/push和with/without收益评测本轮均不执行。
- 静态验证通过：10件源包/14个包内链接、12组证据/15个来源绑定、16个场景、36件库存字节/行数/SHA及14会话SHA。独立临时副本10件SHA一致；逐件缺失、坏SHA/绑定/null/fixture、假PASS/版本、变更授权及现存包外链接等26项拒绝门禁通过，临时目录已清理。PowerShell语法、显式12文件编辑器诊断与源包私人路径/凭据/行尾空白扫描通过。
- 上述验证不执行fixture中的命令，也不运行Agent或业务硬件；评测/报告模板仍为PENDING。静态测试期间的BOM读取、测试计数作用域及URL误判已在测试检查中纠正，原始文件保持不变。