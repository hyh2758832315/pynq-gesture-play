# 工程观察与验证摘录

# C0E PL 视觉加速时序修复

文档类型：项目事实记录；路径：docs/bringup/2026-10-23_pynq-z2_pl_timing_repair.md。
项目voice-view-game；PYNQ-Z2 / xc7z020clg400-1；Vivado2026.1；日期2026-10-23。
使用技能：本机 `C:/Users/developer/.agents/skills/{vscode-tool-bridge,xilinx-suite,vivado-timing-methodology-checks}/SKILL.md`，对应仓库xilinx-suite源位于 `xilinx-skill/plugins/xilinx-suite`。不修改部署技能副本。

71000的reset负例r02 exit1/767.207s：脚本选择blocked，但原始simulate.log仍执行SAFE分支并输出safe PASS，未获得负例证明。compile/elaborate/simulate/WDB已保留；分类为测试参数/编译快照选择问题待查，不计DUT负例PASS，不改判定器。

AMD文档核实：UG904 Physical Optimization说明post-route会自动更新布线，UG949 Iterative Flows说明无需再显式route；同一物理优化每次只处理部分最差路径，基于实测改善可评估下一轮，而非随机重跑。

## T02 已封存r02，启动一次有依据的AggressiveExplore

完整r02 summary确认310个setup失败端点，hold/pulse均通过，全部route状态另存。40条路径首位已从原owner计数链转为vision_gp0_slice→GP0 SmartConnect地址解码：11级，7.682ns布线/10.227ns数据路径（75.1%）；HSV计算也在失败集合。原失败路径和新失败路径不应混为一谈。

`capture_latency_postroute_r02.tcl`成功47.104s，保存真实DCP和全部报告。报告命令中旧`-nets`选项触发工具deprecated Critical Warning（Vivado12-1569），属于报告调用，不是设计DRC；原文保留，后续报告删除该冗余选项。未放宽约束。

基于上一轮改善且不同瓶颈已成为最差路径，依据UG904 Using Directives进行一次`phys_opt_design -directive AggressiveExplore`，使用其不同算法/更积极目标。理解记录 `build/hosd/c0e/postroute-r03/agent.log`；输入为已封存r02优化态，输出必须新目录。任何命令成功仍须完整时序通过；若收益不足，转RTL/实现架构分析，不随机循环指令。

reset负例r02的直接证据：生成elaborate.bat/xelab命令完全缺少BAD_READ覆盖，虽然fileset GENERIC已设置，实际仍跑默认参数0。修复测试驱动显式传文档化`-generic_top BAD_READ=1`，并在运行前核实生成命令、运行时打印实际参数；DUT、断言和超时不变，旧FAIL保留。

reset-blocked-r03在设置仿真选项时立即失败：Common17-170把以连字符开头的值`-generic_top BAD_READ=1`解析为set_property选项，未进入仿真。源快照/receipt保留。用`set_property -dict`封装值，选择新r04输出，不修改DUT/断言。

## T03 后布线优化无新增收益，转布线前优化

postroute-r03终端164.443s、exit0，但优化网数0、WNS/TNS无改善，前后checksum均2003fcff3，原r02 DCP即该同一状态。receipt保留，不把命令PASS当时序PASS，不继续随机重跑后布线指令。

检查实际impl Tcl确认原流程已包含默认postplace phys_opt，不能声称未运行。新r04从原placed DCP工作区独立副本出发，用更积极的布线前AggressiveExplore，再用route Explore/tns_cleanup；该阶段比postroute有更大调整空间，依据UG904文档，不改功能/时钟/接口。输入 `build/hosd/c0e/preroute-r04/input_placed.dcp`，脚本 `integration/route_latency_r04.tcl`，理解记录在该run的agent.log。输出checkpoint/完整报告必须另存；无bit生成或自动上板。

r04输入placed DCP的SHA256：`1ac61656a4d25bcd11bb7100786459f2c2140c6e31fad659c5b83b315a86d7fd`。08:12:05建立副本，原始project run不改写。r04使用非工程session6044，main session71000仅独立复位负例，不向同一会话并发发命令。

新增独立`audit_latency_timing.py`只抽取完整STA/route/有效约束比较及SHA，不把C0D旧135条CDC白名单套用C0E，不宣称完整硬件签核。以真实失败r02作负对照，正确拒绝并输出310失败端点、所有75075可布线网已路由、0routing error；该结论保存`evidence/timing-r02-audit.json`。后续即使STA通过，仍必须CDC/bus-skew/DRC/资源/配对/板验。

补充现有方法学事实：r02有DPIR-1×128（budget常数乘法的异步reset寄存器妨碍DSP寄存器吸收，属性能/面积建议，未改reset语义）；PDRC-190×32来自moments_dma lite_rdata链。实际生成C0E HWH核实DMA三时钟s_axi_lite/m_axi_sg/m_axi_s2mm均连接同一ps7_0_FCLK_CLK0/100MHz，`C_PRMRY_IS_ACLK_ASYNC=0`，不能误将其当作尚未配置同步时钟而反复改IP。该物理放置警告仍保留，需最终设计时钟和完整CDC印证。ULMTCS-2×1控制集2077偏高，XDCB-5×1为继承rgb2dvi查询效率，TIMING-18×4为原I2C端口延迟缺失；没有创建waiver或补猜测I/O约束。

08:17:33 r04已完成布线前优化并写出`postplace_aggressive.dcp`和完整timing。估计setup WNS+.003/TNS0，但估计hold WHS−.247/THS−6.445（212端点），这是布线前状态，不是最终签核，必须让router处理hold并检查实际布线结果。路由进入Initial Routing，尚无最终结论。复位r04源命令超300s RPC观察超时，但同一71000句柄明确仍running（496s），没有重发/重启。

## T04 复位测试选择问题已定位，改结构参数绑定

reset-blocked-r04 terminal：xelab仍无BAD_READ覆盖且launch按默认1000ns运行，驱动严格检查后exit1，未执行负例证明。只读实际状态为`active_simset sim_1`，而请求集c0e_reset_sim的GENERIC=BAD_READ=1、xelab.more_options=-generic_top BAD_READ=1、runtime=0ns均已正确保存；说明指定-simset未使活动集切换，不能只看被请求集属性。正常close_sim后完整logs/WDB已保存，不声称DUT负例失败或成功。

新r05驱动显式`current_fileset -simset c0e_reset_sim`并检查读回；TOP改为独立`tb_c0e_reset_blocked`，其唯一实例以SV结构参数`BAD_READ(1)`绑定原测试体，移除对启动器generic选项的依赖。运行前检查xelab确实选择该top，运行时仍要求BAD_READ=1和原阻塞断言PASS；DUT、1000周期观察、100有效AR阻塞周期门槛和无响应判定均未改变。脚本`simulate_latency_reset_blocked.tcl`和wrapper，证据新目录reset-sim-blocked-r05。

## T05 新布线把失败端点降至34，进入针对性后布线优化

`timing-r04-audit.json`记录全部数字及有效XDC比较；新流程使用同一约束，不使用C0D专用签核器。基于现在只剩34个失败端点，在这个不同的新route上进行一次postroute Explore，符合UG904对较少失败路径更适合物理优化的指导；旧r03零收益发生在不同r02route，不等于新输入无机会。新run `build/hosd/c0e/postroute-r05`，不改RTL/ABI/时钟/故障隔离语义。之后必须全新collect_reports，不仅看WNS。

r04 routed DCP SHA256：`c9352b6fe8f0a23542c42481d863c49e62ad881f423dda4548f6d1141d7fbbc3`。r04 audit确认有效约束前后一致。

## T06 真实BD复位负例r05通过

负例r05完整366.812s、exit0，活动集已为c0e_reset_sim，实际结构top=tb_c0e_reset_blocked，runtime明确BAD_READ=1。实际PS7VIP对0x41410000读，在capture reset held条件下观察1000周期，其中ARVALID且ARREADY=0共990周期，无读完成；原断言门槛≥100周期，终端`TEST_PASS C0E_RESET_HELD_READ_BLOCKED blocked_cycles=990`，44030ns结束。全compile/elab/sim日志、elaborate.bat、约20MB WDB和源快照保存，receipt已写。

唯一相关末尾Warning为AXI4_ERRS_RLAST_ALL_DONE_EOS：负例故意在被阻塞读仍outstanding时结束，对应所证明的阻塞状态；未禁用checker，警告原文保留，未预期ERROR/Fatal为0。它与此前安全释放三轮正例共同证明“不得在释放capture reset前读该AXI接口”的真实BD约束，不代替板端首帧/STOP验证。

自有Vivado6044 idle、327.427s Explore-r05 exit0。实际内存design读回setup+.003ns/hold+.051ns，原生日志TNS/THS均0，物理优化19网、WNS改善.435ns；未改RTL/约束。`collect_reports.tcl`完整83.925s，输出 `build/hosd/c0e/postroute-r05/signoff`，封存candidate.dcp、全STA/route/DRC/methodology/CDC/busskew/例外/资源/有效XDC。

初读全部4个bus-skew组通过：96位budget slack8.588ns，两个10位组8.904/9.122ns，135位OSD8.354ns；CDC无Critical，新增1组96位CDC-6必须做稳定payload/握手复核，不能套R1签核器。资源33538LUT/49444FF/13124Slice（98.68%）/89.5BRAM/20DSP，时序裕量窄且Slice余量小，签核范围需明确。

DRC默认报告出现CHECK-3：REQP1839/1840各只报20项，不能据此声称完整复核。依据AMD AR73290，仅读取并临时将报告计数参数drc.maxLimitREQP1839and1840从20设为−1以展开全部问题，报告后恢复，不禁用/降级任何规则。另收all_checks_per_endpoint CDC和DMA实际时钟证据；脚本collect_latency_extended.tcl，新目录extended。

## T08 完整实现范围复核通过，进入离线导出

extended报告38.462s/exit0，全部DRC展开190项（RAM异步控制72+48），无Critical/Error；all-check CDC也无Critical，报告计数参数恢复20。同一时钟DMA源/目的寄存器实际clk_fpga_0读回已保存。96位budget握手源在quiescent锁存并保持，目的两级payload/三级request及额外接收边沿，max_delay/skew10ns覆盖，实测skew1.412ns；CDC-6保留而非waiver。异步reset RAM警告按丢弃当前epoch、重新扫描初始化窗口的有限恢复合同复核，不声称reset时RAM内容保持；真实STOP/start/同帧数值仍待板验。

独立审计 `audit_latency_signoff.py`通过并写 `evidence/latency-signoff-r05.json`，精确验证完整STA/route/四组skew/两类CDC/方法学/展开DRC/有效约束逐条一致/数值测试源SHA和当前综合源对应/资源。详尽警告、理由、边界在signoff/METHODOLOGY_RESOLUTION_REPORT.md。结果是 `C0E_TIMING_ROUTE_AND_SCOPED_REVIEW_PASS`，不是硬件加速板验或完整发布PASS。

## T09 离线配对与恢复成功；共享板卡等待

bit导出37.762s/exit0，bitgen前DRC0Errors；XSA导出6.782s/exit0，已有平台metadata覆盖Warning保留，不改ABI。verifier完整HWH38段地址/GP0五通道/identity通过，XSA内c6v_candidate.bit及主c6v.hwh与外部文件逐字节相同。HWH导出后metadata变化产生新SHA，以本次实际配对值为准，不复用早期8136973摘要。

bit SHA256 `27b16dbee4509ffa5fbf08bd626c50145a1b08be78a6db02e6d6699364f7fa7f`；HWH `1ef6ab3e7a5f40ce94742befcb6e13d15180186851215c41119eb772811257e6`；XSA `03e22fef3dbba79ce352e3d24f64d8e4645393ef24d65e507ad9a7bea9b14c2f`。verifier未放宽。

finalize_latency_candidate.py封存r17独立包、594项manifest、595成员，46,081,851bytes；ZIP SHA256 `1ee6753e96d6fd8a8ba759646a01f4c5d991dfec43b126e3cd70ef8ed83f80d1`。独立恢复 `build/hosd/c0e/package-restore-r01`；原树/恢复树完整SHA及各两种check-only（普通/关闭volume采样）共4次PC预检通过。实际目标仍release_ready=false/board_pending=true，仅stage提升为PAIRED_PREFLIGHT_READY。未上传或加载板卡。R1 ZIP SHA未变，证据latency-pair-r01.json及latency-package-r01.json。

先运行只读c0e-b01-readonly-handover，刷新实际boot/进程/端口/MMIO映射/锁；旧R1的PID760身份仅历史不可直接用于停止。后续只操作独立C0E目录；不强杀owner或删除锁，所有失败先记记录。离线最后20项/18subtests复验PASS（latency-final-contract-r02.log），R1和C0E归档保持冻结。

交接快照boot=3696016e-d285-41eb-b97a-eb4aad3eb9d4，无游戏/视觉进程和硬件映射，三个boot/清状态/shell服务inactive，volume journal不存在。原R1日志为旧boot仅历史，不停旧PID。独立deploy_latency_board.py各阶段绑定该boot；c0e-b02创建新目录、上传/恢复595成员、594 SHA通过；b03真实PYNQ Python3.10双check-only与全部Python3.10 AST通过，未访问硬件。

b04按原已验证官方Base正常停止流程执行：先核对当前官方Base metadata/bit/HWH及独占锁、服务与映射，再只对已证明Base的DMA正常halt，不强制reset；回执PASS，未加载候选/未触碰codec。现在准备b05首次C0E加载，唯一load.attempt和独立supervisor日志var/pl-live-b01；不自动重试Overlay下载。

b05启动前门禁FAIL：新部署驱动错误地从包根读base-stop.json，而原Base流程将其写在var/pl-live-b01；FileNotFoundError发生在load.attempt/worker创建之前，没有加载Overlay。原回执c0e-b05-agent-start保留；修正为读取同一log下实际Base回执，保留已存在Base日志目录并拒绝已有load.attempt。新b05r02仅重试尚未发生的启动门禁，不重跑Base或覆盖历史。

b05r02启动/b06ready通过；实际新owner PID5847/start_ticks879150、supervisor5840，boot3696016e-d285-41eb-b97a-eb4aad3eb9d4。Agent HELLO BUILD_ID=0xC0060E00/profile=C6I_PL_VISION_VOLUME_OSD_V1，摄像头芯片0x5640通过，证明正确硬件已加载。b09首次observe真实FAIL：frame_id0、RuntimeError capture pool epoch status rejected，vision FAULT/cleanup未确认。独立VOL1正常50Hz、fault0/ACK0，OSD线程仍发布，不能称视觉加速已成功。

诊断软件d01准备途中SHA门禁拒绝：read_text将原CRLF归一化，导致拿归一化字符串哈希与原manifest字节SHA比较失败，尚未生成ZIP或上板。原不完整目录保留不使用；后续诊断分支必须用原始bytes验证，只修改错误路径快照，不改任何合同判断。

## T12 仅增加错误快照的d02已独立恢复，正常回收retained启动

诊断包d02 SHA256 `fde5af827707c6b9c2cfc6cad779f3137222eb1b1747f5d71d465a9111466c59`，46,086,957bytes/594 manifest项；原r17 ZIP和R1 ZIP不变。独立恢复 `build/hosd/c0e/diagnostics-restore-d02`，全部SHA、Python3.10 AST、两种PC check-only通过；与父包manifest比较唯一代码差异是`board/pynq_z2/vision_dma_pool.py`。bit/HWH/XSA逐字节相同。错误分支通过原owner已有句柄读capture/owner和两个DMA状态，保留全部原拒绝条件；没有创建第二MMIO owner、执行写操作或功能修复。回执latency-diagnostics-package-r02和latency-diagnostics-restore-r02。

真实BD ARM仿真RPC超过300秒，但原Vivado71000仍运行、queue0，未重发。当前已进入XSim运行阶段，尚无终端PASS/FAIL。视频inactive的范围不能替代真实视频首帧测试。

ARM真实BD仿真最终452.782s/exit0，`TEST_PASS C0E_ARM_NO_VIDEO_STABLE reads=52 writes=8`，147845ns结束；10轮flags均00000001，epoch0x12345678，capture faults/owner fault均0。receipt `latency-arm-sim-r01.json`保存源/日志/WDB SHA；断言与逐次读回已检查，WDB已保存但未独立解码。该PASS仅排除本刺激下的静态ARM失败，未启用视频/运行DMA，板端首帧错误尚未复现。

postboot首两次SSH不可达回执完整保留（r01 timeout、r02 Unknown error），未重复reboot。r03已连接新boot `e4eb70c7-fb17-4f54-b18f-1fcf5cffa805`，无owner/MMIO映射、journal为空，但bootpy.service仍activating，因此recovery_ready=false，尚不加载任何候选。等待系统自身完成启动，不停/修改系统服务。

## T13 d02实板取得具体故障，排除“视频与游戏同时消费”的前提

d09首个STATUS真实FAIL：runtime_mode=menu、presented_frames=0、frame_id0、active_sha256=null，没有播放视频或运行游戏。错误路径快照：expected_epoch=actual epoch=1492218772，ready=true/sealed=false/faults=5，pool_state=RUNNING；owner flags0x8=1、status0x4c=8、granted0x5c=1、released0x60=0、owner_causes0x64=1；RGB DMACR0x10003/DMASR0x10000、packet DMACR0x10003/DMASR0x11008。两个DMASR各自既有错误mask均为0。faults bit0为源视频overflow，bit2包含owner/fence关联故障；owner cause1为上游故障。只能据此定位故障链，尚不能断言overflow的根因或先后时刻。

新定速仿真`simulate_latency_video_rate.tcl`/`tb_c0e_video_rate.sv`使用真实生成video_in/demosaic、生产capture/lifecycle，100MHz AXI/74.25MHz视频、1280/1650像素行、32行前缀，两个输出sink始终ready，排除该用例中的DDR/GPU竞争。记录首次overflow的像素计数及逐级握手/背压，并检查故障签名或无overflow前缀；这不是完整720p帧/真实DDR验收。Vivado71000已启动，DUT/阈值/时钟约束不改。依据AMD PG043 Buffer Requirements/Throughput：时钟足够不等于下游可持续吞吐足够，须实测stall与缓冲需求；不凭该通用规则直接增大FIFO或降低帧率。

## T14 视频定速仿真复现与针对性预热修复

video-rate-sim-r01在展开失败：独立top直接实例化BD内生成IP时，编译顺序裁剪了video_in/demosaic模型。原compile/elaborate/prj封存，并非DUT运行失败。改用已通过ARM真实BD的精确编译库独立副本，保留855项cache SHA、原生成命令及mem/dat；不改生产工程、IP模型或源逻辑。r02已编译展开但Windows反斜杠Tcl路径被转义，未运行刺激；保留FAIL。r03统一Tcl正斜杠后真实复现：129.569us、line5、sent7485、bayer6455、RGB1287、stalls1385，随后faults5/owner1/granted1，sink始终ready。

r04补充内部信号再次复现：dilation active1/scan_row2/column90、skin valid1/ready0。VCD独立解析：115.695us首次skin背压，115.715us传播至RGB，129.555426us输入FIFO overflow，129.595us capture faults5，129.605us owner cause1。溢出前仍在顶部4×648零填充扫描，尚未接收第一个skin像素。video_in生成配置FIFO深度1024；该突发背压足以在输入流不可暂停时溢出。此仿真证明一种与实板签名一致且无需GPU/DDR竞争的因果路径，不把模拟相位等同实板波形。

同刺激prewarm-r01完成32行/40960输入像素/RGB35840（demosaic未完成帧尾）/RGB入口stall0/无overflow、fault。独立VCD解析通过`latency-prewarm-ab-r01.json`；内部skin短暂背压仍可存在但未传播为RGB stall，不宣称各级永不背压。完整旧ARM4.5.4 gold前端和封包数值回归`build/hosd/c0e-prewarm-numeric-r01/receipt.json`全部5阶段PASS，来源SHA和所有gold保留，DUT37前端帧/24捕获帧合同未放宽。额外两个完整720p连续帧定速仿真正在运行，真实DDR/新综合时序/上板仍待验证。

d02正常VISION_STOP同样返回retained；精确身份正常SIGTERM后d12确认保留，未强杀/重载。当前自有板端owner PID953/boot e4eb…，后续需正常恢复新boot才能加载任何新bit。R1、r17、d02归档均保持不变。

## T15 两个完整720p帧通过，修复源进入独立综合

`build/hosd/c0e-video-rate-prewarm-full-r01`通过两个完整连续720p帧：sent/RGB均1843200、packet frames2、words230432、RGB输入stall0，无overflow/owner/capture faults。原生WDB/VCD已保存，独立VCD解析无上述故障/背压，回执 `latency-prewarm-full-rate-r01.json`。仍仅always-ready sink，不代替真实DDR/板端。完整numeric-r01的37前端帧/24捕获帧与旧ARM gold逐字节合同均PASS，源码SHA c2a60d34…固定。

`install_latency_prewarm.tcl`208.347s/exit0，23/23需求、BD验证通过，仅替换膨胀模块源绑定；旧冻结RTL、signed DCP和归档不改。创建独立synth_prewarm_r01/impl_prewarm_r01，目录 `build/hosd/c0e/prewarm-r01`保留替换前后BD/源/project XML。新run采用布线前AggressiveExplore、route Explore、布线后Explore；依据UG912/UG904设置显式增量参考，复用已签核r05物理结果而仍对新设计重新签核。参考DCP SHA `af0db359703c500ae049b9ea6b9b2ae77e1b4db0ac71b962bb0c10996f24ed9c`，独立复制并加入utils_1。

配置增量参考的首次调用在AUTO_INCREMENTAL_CHECKPOINT=false处报bad lexical cast，未进入运行；完整errorInfo指向该属性，2026.1该属性使用数值0，修正后读回0/新参考路径正确。原执行脚本副本保留false及失败证据，工作脚本已改0；没有因配置错误改DUT。`launch_runs synth_prewarm_r01 -jobs 8`66.178s/exit0后单独执行wait_on_run，当前综合运行中。原setup+.003ns结果不代表修复版时序。

c0e-p00已按d12当前boot/PID953/start_ticks30850、volume journal和全部三个owner进程身份重新核对并正常systemctl reboot返回0，保存before快照。未强杀/删锁/复位活DMA。后续再次等新boot空闲门禁再上板，灵巧手文件/串口/会话不操作。

c0e-p01新boot `8edb03b4-ad47-44a2-9a21-ae66abbcccf7`已recovery_ready=true、进程0/MMIO映射0。新综合wait101.942s/exit0，主综合完整302Warnings/0Critical/0Error；实际capture OOC在12:47:54重新综合，日志明确读取workspace中新膨胀源（不是旧缓存）。OOC+main日志/Tcl/新synthesis DCP封存在prewarm-r01，SHA回执latency-prewarm-synthesis-r01。

实现首次to_step=post_route_phys_opt_design被2026.1拒绝，尚未启动；工具列出的实际枚举为`phys_opt_design (Post-Route)`，按该值12:51:11启动成功，随后单独wait_on_run。增量日志明确采用默认RuntimeOptimized，覆盖显式place/post-place/route指令；先前AggressiveExplore/Explore是run配置值，不代表实际采用。原300s RPC观察超时但71000仍running/queue0，正在应用参考DCP物理优化，没有重发。新STA仍待最终实际route报告，不能沿用r05裕量。

13:05已完成69项参考physical优化应用；增量报告Cells matched99.93%/current reuse99.92%（95222），Nets matched99.94%/reuse99.69%（73355），Pins reuse99.73%。进入增量placer；13:07 post-placement估计WNS−4.356ns/TNS−1787.972ns，属于route前阶段，尚未通过。实际runme.log阶段优先于MCP启发式“Running routing”标签，必须等router/postroute STA；不提前导出、不放宽任何约束。

## T16 新run遗漏父post-opt hook，按真实路径/约束差异修复

impl_prewarm_r01最终wait1325.478s/exit0，但原始postroute日志WNS−5.323ns，命令Complete不等于签核PASS，没有导出bit。6044旧设计已封存后正常close，独立打开完成写出的routed快照（未取仍在写的文件）；原始routed完整STA最差−5.395ns，mailbox[66]→pending_cfg[66]被普通时钟关系0.034ns检查。新run创建只复制strategy，漏了impl_1的STEPS.OPT_DESIGN.TCL.POST（build/hosd/c0d/postopt_osd.tcl），XPR和生成run Tcl均证明缺失。是本次运行配置遗漏，不是预热逻辑制造OSD跨域路径。

新旧实际生效XDC仅差7行：既有135位OSD mailbox/pending的10ns datapath_only/maxskew及req/ack首级与reset assertion端点例外。恢复原父hook后，全部1322行active XDC与旧r05逐条完全一致；仍不设clock_groups、不放宽100MHz或任意新增例外。恢复后的routed快照STA为WNS−2.417ns/TNS−766.334/1489setup失败，WHS+.051/THS0/WPWS+.538；40条最差路径39条来自rst_fclk0 ACTIVE_LOW_PR_OUT_DFF，驱动260负载、最差连线10.741ns（从X99Y89到X7Y14），另一条来自capture reset。原失败run日志/Tcl/报告/最终DCP另存failed-implementation-r01，回执latency-prewarm-implementation-r01。

已修正工作版install_latency_prewarm.tcl，未来创建run显式继承父post-opt hook；原执行副本及失败历史不覆盖。没有继续盲改滤波器算法或采用尚无证据的RTL替代方案。

依据UG949与工具help尝试仅对上述已确认复位网络force_replication；2026.1实际报Vivado_Tcl4-265：此选项不支持post-route，命令在修改网表前被拒绝，reset-fanout-r01保留FAILURE.txt且无after_force.dcp。改用已完成的c6v_wrapper_placed.dcp独立快照，在布线前恢复父hook并做同一目标优化，脚本repair_latency_prewarm_placed_reset.tcl，目录placed-reset-repair-r01。当前自有6044正在执行该脚本；71000已idle。仍无新bit/上板，当前板boot8edb…空闲，无owner/映射。修复源c2a60d34…保持不变，数值与两个完整帧PASS仍有效。

## T17 预热修复版重新实现/完整审计通过

placed-reset-repair-r01成功101.635s；实际在布线前完成定点复位驱动复制，增加10个FF，无功能/复位周期修改。恢复后的placed XDC仍1322行与r05逐条相同。随后reset-route-r01185.786s/exit0：WNS−.404/TNS−19.806/142setup失败，WHS+.051/THS0/pulse+.538，75187/75187网/0错误。剩余主要是budget processing_reset及capture_control→owner granted CE路径，不再是跨芯片原260负载根复位。

postroute-reset-r01 Explore149.567s/exit0，实际STA：WNS+.003/TNS0/setup失败0，WHS+.051/THS0/hold失败0，pulse+.538；75190/75190网/0routing errors。四组skew slack8.588/8.904/9.122/8.810ns。完整collect119.147s保存新signoff/candidate.dcp和extended，原r05结果不复用为修复版结论。

latency-prewarm-signoff-r01真实PASS：全部展开DRC种类/数量与r05相同，无Error/Critical；CDC无Critical，保留1组96位CDC6和135位CDC15的原握手范围复核，32个DMA链仍同clk_fpga_0。资源33538LUT/49453FF/13135of13300Slice（98.76%）/89.5BRAM/20DSP。对新综合源逐项匹配prewarm-numeric-r01 SHA，包括膨胀模块c2a60d34…；新METHODOLOGY_RESOLUTION_REPORT.md明确预热、物理复制、等价约束和仍待板验/真实IO的边界。

## T18 配对r18冻结并开始板端预检

同一审计设计导出bit35.103s/exit0，bitgen DRC0Error；主项目显式选synth_prewarm_r01/impl_prewarm_r01作为平台载体，仅把实际审计bit放入其预期文件路径，不运行原负时序run的write_bitstream。XSA3.940s/exit0，metadata覆盖Warning保留。bit SHA `5912cb641fadbc566505fde90b01eeb925c5293cb312262330ef1a9ead7aa0f9`；HWH `91bb5953f1af96feb98181b57d0c0eee4829dfb63f5a8f16a3273784ca0db32c`；XSA `9368859a5eb946aa2e1fc07e1a6abb241cfe276efd260f2adfd5cebe8538d1b8`。verifier38地址段/GP0五通道及XSA成员与外部bit/HWH逐字节配对PASS。

从不可变d02软件基线生成独立 `deliveries/c6i-pl-vision-volume-osd-r18-prewarm-20261023.zip`，SHA `7619be5d51043b3289906784c1d8add6d11601840c9897c462c5b9b27c097a8b`，46,268,764bytes/601 manifest项/602成员；独立恢复build/hosd/c0e/prewarm-package-restore-r01，全SHA、原树/恢复树4次PC预检PASS，release_ready=false/board_pending=true。runtime Python与已ARM测试的d02完全相同，硬件/源码/报告更新；R1、r17、d02归档不改。ZIP内进度文档为冻结时T16历史快照，最终新签核文件及verification回执在包内；本外部bringup记录继续保存后续板验，不能把冻结旧进度段当作最新结论。

deploy_latency_prewarm.py沿用原部署门禁，文件计数从已冻结manifest取601，精确绑定p01空闲boot8edb…，独立板端目录r18-prewarm/var/pl-prewarm-p01，不覆盖d02。p02上传/602成员/601 SHA通过，p03真实ARM双预检进行中。base/start额外要求新的约束门禁单元回执及其审计代码SHA一致；没有更改硬件拒绝条件或创建第二MMIO owner。

## T19 r18首帧成功后再次溢出，转向采集与识别解耦

p10仅CPU、无/dev/mem或/dev/uio映射的同包OpenCV4.5.4/threads2测试：空图冷57.29ms，12轮热图中位25.596ms；480个小分量的8轮中位40.527ms。表明仅预热CPU不能保证30Hz变场景消费。CPU测试不替代相机/DDR吞吐验收。原始证据c0e-p08-first-frame.json、c0e-p09-first-result-readonly.json、c0e-p10-cpu-only-cold-warm.json。

## T20 最新帧软件候选与离线合同

独立r19-latest从r18冻结ZIP完整SHA恢复，复用同一已签核硬件，新增LatestCaptureHardware；唯一borrower的start/read/stop及asyncio loop都在同一采集线程。每一帧先由原pool复制、验证及释放token，再检查连续编号/epoch/config/thresholds；CPU副本只读化，单槽缓存覆盖未使用的旧副本，识别消费的对象必须由mailbox原样交付且只能验证一次。RGB只在识别等待预览快照时申请；正常STOP排空仍检查每个编号，但不调用耗时识别。任何采集/排空失败均保留borrower，不清锁、重置或自动释放。

扩大回归r01为261 PASS/9 FAIL：两项Windows临时路径过长、五项缺少test_game_voice_policy导入路径、两项确实发现旧路径多一次monotonic_ns调用。保留原失败日志，修复默认分支的多余时钟调用，测试使用短独立目录并补全夹具路径。r02同断言完整270 PASS/4 subtests PASS，24.60s；证据latency-latest-contract-r02.json固定四个候选Python源SHA及完整日志。此结论仅PC，真实ARM线程/吞吐、实板持续采集/STOP/共存仍待验。

## T21 r19独立冻结，正常回收r18故障owner

r19 ZIP `deliveries/c6i-pl-vision-volume-osd-r19-latest-20261023.zip` SHA256 `98d7dfc5d9b91fe07a53fe5733f10c937623fab68b2090c51be74c515888ee97`，46,280,855bytes/605 manifest项/606成员；独立恢复latest-package-restore-r01、完整SHA/配对、原树及恢复树4次PC check-only PASS。附带15项纯CPU ARM合同脚本，保留断言，仅修改来源根路径及夹具模块名。release_ready=false/board_pending=true，硬件仍r18签核bit/HWH/XSA；配对和包回执latency-latest-pair-r01、latency-latest-package-r01。

## T22 r19解耦生效但仍溢出，保留FAIL并测量取帧预算

q01-r01新boot `2817d7c9-de8a-4015-911d-99e2b53d685f`，bootpy仍activating；q01-r02所有服务inactive、无owner/映射、锁及journal门禁通过。q02独立上传/恢复606成员/605 SHA PASS；q03真实Python3.10双check-only和15项纯CPU合同PASS（10项0.184s、5项0.853s），保留get_event_loop DeprecationWarning。q04官方Base正常halt、q05r02唯一load.attempt、q06监听通过。

q08真实FAIL：menu/presented_frames0，识别结果frame1；capture captured2/delivered1/pending1/replaced0，证实CPU第1帧处理期间采集线程已完成第2帧，不再是原串行调度。然而epoch2219228177一致/ready=true/faults5，owner granted5/released2/status0x4c=10/cause1，仍有三个占用槽，两个DMA仍无既有错误mask命中。只能证明线程解耦有效而未消除溢出；当前证据不足以区分取帧解码/缓存维护成本、CPU/GIL调度或硬件credit交接时序。

## T23 取帧CPU成本与板卡让出后的离线约束

交接前完成的纯CPU证据 `c0e-q09-cpu-decode-r02.json`：同包ARM/OpenCV4.5.4，640×360 DMS1解码30轮中位19.07750ms/最大21.06889ms；与识别并发40轮中位26.55241ms/最大40.89056ms；460864字节包复制中位1.48157ms。这些数字包含完整解码，不可全部归因于CRC；不含真实DMA缓存维护和MMIO成本。r01因HTTP地址使用127.0.0.1而连接失败，原FAIL保留，r02使用实际绑定地址。脚本未映射/dev/mem或/dev/uio；这项测量发生在本次暂停板端操作之前。

本地源审阅确认：vision_frame_owner将未释放grant限制为3；vision_source_admission没有空闲槽/credit输入，RUNNING期间持续axis_enable。因此快算法只能降低满槽概率，不能保证任意CPU停顿安全。下一离线验证先用预热修复后的实际生成IP重现第四帧无释放时的背压，再评估在帧边界预留槽、无槽跳过完整输入帧的方案。旧R1底层PYNQ DMA环覆盖语义尚未核实，暂停期间不为此访问板卡。冻结R1/R18/R19归档保持不变。

## T24 离线整帧准入设计与容量模型

新设计文档 [frame_admission_design](2026-10-23_pynq-z2_frame_admission_design.md)明确在视频帧开始前预留槽，无槽时跳过完整输入帧；CPU释放成功后才返还容量，已接受帧继续严格校验。通过AMD文档MCP核实PG043 Common Interface：axis_enable同步视频域、控制FIFO写入，不是AXI输出消费开关。仍须真实IP验证重新放行及SOF/TLAST完整性。

`verify_latency_admission_model.py`本机穷举800状态/3152转换PASS，回执 `build/hosd/c0e-admission-model-r01.json`。容量3/模8模型包含源预留、下游grant、联合完成、CPU claim/release、无限次暂停自环、延迟或跳跃释放观察、close及全部计数回绕；无超额预留/覆盖CPU持有槽，已预留帧不会因owner容量而等槽。下游恢复响应后，关闭状态最多12次协议动作排空。它依赖正确有序CDC与完整帧抽象，不是RTL/CDC/STA证明。

独立 `tb_c0e_credit_starvation.sv`保持真实video_in/demosaic、100MHz/74.25MHz、预热修复和输出sink始终ready，只把输入延长到4个完整720p帧、CPU始终不claim/release。要求恰有3完整RGB帧及3个完整packet后，第四帧出现faults5/owner1/granted3；任何首帧故障或计数差异均FAIL。该用例PASS代表复现缺陷，绝不代表修复。

仅通过本机旧记录和公开源码补充旧版解释：g16日志报告PYNQ3.1，冻结R1 open_frame_dma直接实例化AxiVDMA，fallback只换等待器；官方v3.1 S2MM start开启循环模式，readframe时替换交付槽，没有新DMS1逐身份release合同。这支持旧CPU慢主要降低识别fps、新三槽协议则会形成背压的解释。板上实际驱动SHA未复核，旧驱动还清除部分错误位，因此不把“旧版没有观察到”升级为“旧版绝无溢出”的结论。全过程未连接板卡。

r02完整运行保留FAIL：50.098525ms首次RGB背压，已接收2764800像素、granted3/credit0、三个packet完整、axis_enable仍1；50.112360662ms源overflow，随后faults5/owner1。独立VCD解析 `build/hosd/c0e-credit-starvation-r02/waveform-analysis.json`固定波形SHA `64efcd4e5d0c47e9d5b51979ab2c99abd85457732b4510f01646a43abc775d55`。此波形直接支持满槽后入口仍放行的因果链。

## T25 独立准入RTL候选与单元通过

独立目录 `subprojects/hdmi_input_osd/latency_rtl/admission_r01`新增3文件：修改版vision_source_admission、vision_capture_lifecycle及新增vision_release_credit_cdc。视频域在安全VSYNC处按模8预留计数减去已同步release计数决定整帧接收；满槽时整帧axis_enable关闭，已接收帧不在中途停。3位release Gray码源端注册、目标域三级同步后注册解码；只接原owner成功released_frames，未放宽CPU身份、fault或owner合同。外部生命周期端口和寄存器ABI不变。新Gray路径物理约束/共同reset审核和新综合STA均待完成；不能凭单元通过宣称CDC签核。

`build/hosd/c0e-admission-unit-r01/receipt.json`真实XSim PASS：三种视频半周期6.734/11.137/3.917ns（处理域仍100MHz），18个epoch，105个物理源帧；实际admission、release CDC及closure budget模块参与。覆盖三槽满后连续5帧跳过、跳过帧中release不接收后半帧、恢复、20次逐个释放及回绕、连续3次释放、接收帧/跳过帧中STOP、未打开STOP、打开但零像素STOP、关闭不可重开、非法release和VSYNC/DE重叠负例。源Gray多位跳变断言开启。未使用真实视频IP/DDR，也不等于对owner板端行为验收。

新 `tb_c0e_admission_video.sv`复用真实生成video_in/demosaic与原capture，改用候选lifecycle。5个720p物理帧中接受1/2/3、满槽跳过4、正常claim/release一个身份后接受5，最后请求barrier并正常释放全部剩余身份。三个完成计数由always-ready输出模型生成，非真实DMA。要求四个接受帧、编号1..4、精确字数/像素预算、无入口背压/fault、owner/pipeline drained及epoch seal；保存accepted-packets.hex供冻结DMS1解码器检查CRC/上下文及重复输入的掩码一致性。`build/hosd/c0e-admission-video-r01`已启动；runner先逐SHA核对单元通过的3个RTL源。没有将候选绑定到生产Vivado工程或生成新bit。

旧缺陷r03独立VCD审计 `evidence/latency-credit-starvation-r01.json`通过，精确确认背压→overflow→capture fault→owner fault的次序，且背压/overflow时granted3、credit0、axis_enable1、完成packet3。`build/hosd/c0e-admission-negative-r01`仅在测试副本旁路slot_available，原断言在首个应跳过帧以 `FRAME_SELECTION_CHANGED selected=0 actual=1`拒绝；状态ADMISSION_NEGATIVE_CONTROL_REJECTED，不当作候选正常PASS。候选RTL未被负例修改。

通过AMD文档MCP核对UG903 Gray bus skew例与UG949单独CDC路径规则，准备未执行的 `postopt_latency_admission.tcl`：先继承完整原post-opt hook，再只给3位source_gray→gray_meta设置10ns datapath_only与10ns bus_skew，验证3端点/ASYNC_REG/实际clk_fpga_0与vid_pclk均保持原10ns约束。没有增加clock_groups或通用false path，也未把该待执行脚本视作生效/签核。

集成运行期间只读取已完整输出的第一个包用于评估刺激：raw有12个非零像素、filtered有1143个非零像素，并非全零/全一图；后处理将要求四个包均非退化、CRC/上下文正确，且相同物理输入的raw/filtered逐像素一致。该中途读取不替代最终完整PASS，完整运行尚待结果。

经VS Code bridge确认workspace/trusted，Vivado自有71000会话存活idle/queue0，执行一次只读source/run属性检查，回执 `latency-admission-project-readonly-r01.json`：生命周期仍绑定E:/vvl/c0e/latency-r02/rtl，模块IP为c6v_capture_lifecycle_0，候选尚未进入工程。现有impl_prewarm_r01的post-opt hook仍为空（历史失败run配置），即使状态显示Complete也不可作为合格实现基线。后续新run必须显式绑定包含原父hook与新增Gray约束的新hook，不能继承该空值，也不能把该run的旧负时序DCP当作最终签核DCP。正时序基线仍为此前独立prewarm-r01/signoff/candidate.dcp及对应审计。

## T26 完整视频恢复仿真通过，独立综合及优化完成

`verify_latency_admission_gates.py`安装前逐SHA绑定单元/负例/模型/完整视频回执、121项父综合源及正时序父DCP。`install_latency_admission.tcl`创建独立synth_admission_r01/impl_admission_r01，将3个RTL快照绑定工程；保存原项目/BD/RTL与完整继承hook。显式绑定新增3位Gray约束hook，不继承旧run空hook；增量参考只用已签核prewarm DCP。生成/BD门禁23项通过，ABI不变，未生成bit。

新综合实际完成，源身份回执 `evidence/latency-admission-synthesis-r01.json` PASS；主综合0Critical/0Error、302 Warning保留。生命周期OOC 676 LUT/869 FF/0 BRAM/2 DSP，仅作该阶段资源记录，不与父post-route直接计算增量。实现运行到opt_design完成，0Critical/0Error、9 Warning，实际执行原两组hook和新增 `C0E_ADMISSION_RELEASE_GRAY_CDC_BOUND_3_BITS`。尚未布局布线，不能据此称时序通过。

首次opt报告收集脚本在创建输出目录前失败：`optimization not complete`。只读核对发现Vivado在完成opt、尚未place时返回STATUS=`Not started place_design`、PROGRESS=33.33%，runme.log及opt DCP证明opt已完成；脚本原先只接受`opt_design Complete!`。修改报告前置检查以接受这个明确状态，并额外要求`.opt_design.end.rst`标记；不重跑/重置设计、不修改RTL或约束。后续报告核对结果另行追加。

opt-review-r01报告收集随后在`open_run impl_admission_r01`处失败：Common17-69 `Run ... has not been launched. Unable to open`；opt-only运行的项目状态不允许open_run。保留r01脚本快照，改用独立r02报告目录直接open_checkpoint已生成的opt DCP；这只是报告打开方式，不重跑设计或改变约束。

opt-review-r02收集成功35.025s/exit0。六处旧reset选择器在当前opt DCP重新逐一证明相同且唯一，证明绑定当前DCP SHA，不复用旧设计对象。`audit_latency_admission_opt.py`输出 `evidence/latency-admission-opt-r01.json` = ADMISSION_OPT_CONSTRAINT_DELTA_PASS：父1322条有效XDC除6处已证等价序列化外原样保留，只增加release_credit/video_reset的3行scope与3位Gray的max_delay/bus_skew两条（合计1327）。三位实际timing path REQUIREMENT均10ns/ASYNC_REG=1；CDC无Critical，新增一组3位CDC-6与一个同步reset CDC-9，原96位budget及135位OSD握手保留。五组skew端点96/10/10/135/3；当前为opt估算，不作物理skew签核。

16:24本机独立impl_admission_r01继续到`phys_opt_design (Post-Route)`，随后单独wait_on_run；未生成bit或访问板卡。正时序父DCP作为增量参考，Vivado提示增量RuntimeOptimized会覆盖部分place/route指令，原提示保留；最终只按真实post-route报告判断，不以策略名称或run完成状态代替签核。

## T27 准入候选首轮物理实现未达标，保留失败证据

wait_on_run的桥接观察在300秒超时；随后状态确认原Vivado命令继续执行，未重新启动或终止。最终863.236秒/exit0完成，16:38:49写出c6v_wrapper_postroute_physopt.dcp。运行完成不等于时序通过：route阶段WNS−1.266/TNS−218.676/460个setup失败、WHS−.007/1个hold失败；post-route Explore后WNS−.918/TNS−124.125/457个setup失败、WHS−.007/THS−.007/1个hold失败，pulse+.538。候选明确禁止导出部署，不生成R20发布包。

当前最终最差setup为vision_gp0_slice AW payload[31]→gp0_smc地址分发m_vector[7]，11.081ns数据延迟中8.416ns为布线；其次frontend context_read→packet payload_word CE（−.830ns）。hold为AW payload[55]→gp0_smc skid buffer，−.007ns。不能把这些归因为新增Gray CDC，也不能套用旧reset根因盲目复制复位。完整physical-r01报告收集进行中，随后读取QoR建议和具体路径，原r01结果保留。

physical-r01完整收集197.834秒/exit0结束。最终候选DCP SHA `de2af7b925632d57da37f894b80ed6886ebcf66c8ca1f41ec9c0c835497fedc9`；75234/75234网络全部布线、0 routing errors。新签核脚本按真实STA拒绝并保存 `evidence/latency-admission-physical-r01.json` FAIL，绑定全部报告/日志/DCP SHA及审核脚本SHA，没有改阈值或覆盖失败回执。

独立调用约束审核确认全部1327条有效XDC相对于已审核opt只有6处reset选择器的已证等价序列化差异。新增Gray三位max-delay slack分别8.241/8.197/8.431ns；9个同步寄存器ASYNC_REG=1/vid_pclk；五组skew端点96/10/10/135/3，slack8.565/8.904/9.122/8.810/8.904ns。它们通过不替代整机时序失败。资源33547 LUT/49475 FF/13129 Slice/89.5 BRAM/20 DSP；相对父签核整机净增9 LUT/22 FF，Slice少6，后者包含布局打包差异，不是纯模块面积变化。

展开DRC无Error/Critical，原数量保持，唯一新增差异PLBUFGOPT-1从1变2：FCLK BUFG又增加了一级`FCLK_CLK_0_BUFG_replica_1`级联，必须继续审查，不直接豁免。方法学规则数量与父版本一致。QoR报告建议RQS_TIMING-3与RQS_TIMING-59，具体为关键路径驱动复制/高扇出负载分散，涉及frame_completion、capture_status、gp0_smc和voice_volume；报告明确这些建议不是incremental-friendly。7系列不支持其ML策略推荐；没有强行套用其他器件的ML策略。下一轮先提取建议的精确网络、核查新增时钟级联来源，再选择独立物理修复实验；不按旧reset根因盲改、不降低频率、不放宽时序检查。

## T28 精确物理诊断与QoR定点实验

下一独立physical-r02实验从同一已审核opt DCP开始，不重新综合或修改RTL/ABI/时钟周期，先严格绑定建议的读指针网络并实施定点扇出约束，再做独立Explore布局。布局完成后按实际存在的驱动及路径选择物理优化，随后完整route/STA/CDC审核；未完成时不宣称修复通过。

physical-r03布局338.506秒/exit0完成。桥接300秒观察超时后同一session状态确认正常完成，没有重复执行。布局前后1327条时序约束逐条相同；placed估计WNS−.503/TNS−44.456、WHS−4.349，尚未route，因此不能与r01最终STA作为同阶段性能比较。当前最差setup为capture_write_pair RGB byte_count的64位计数/条件链。原6个QoR输出pin中5个在新placed设计唯一存在，第6个event_sample_comp不存在，明确不执行该失配对象。下一步仅对5个已解析网络执行工具建议的定点驱动复制，再执行Explore物理优化，保存各阶段DCP与报告后再route。

optimization-r01共198.287秒/exit0、0Error/3Warning；5网络定点复制后WNS−.503/TNS−49.295，随后Explore物理优化达到布线前WNS+.009/TNS0/0setup失败。WHS−4.349仍是布线前估算；不能签核。两阶段DCP/报告、targets清单和原session.log均保留，优化后1327条时序约束与输入逐条完全相同。开始独立route-r01，以真实布线结果决定是否还需post-route优化。

定点优化实际结果补充：5个目标中completed_frames网络未被工具复制，其余4个网络分别复制8/1/2/1次，共12个新实例；不把“调用5网络优化”误写成5个网络都产生了副本。

route-r01耗时496.691秒/exit0，观察超时后确认原命令正常完成。真实WNS−.478/TNS−11.930/101个setup失败，WHS+.049/THS0/0hold失败，pulse+.538；75205/75205网完整布线、0routing error，1327条时序约束仍逐条相同。相比首轮最终−.918/−.007有所改善，但依然未满足setup，明确保留为待修复。下一步从这个真实routed DCP执行post-route Explore，只有出现实际负hold时才调用hold_fix；不改时钟周期或约束范围。

physical-r03完整报告收集187.542秒/exit0，最终signoff/candidate.dcp SHA `ca7097fc86e206e3b6347fabf5a96f7feab104182634c1ec5f0f3771dbafda07`。独立签核脚本再次按真实setup拒绝，`evidence/latency-admission-physical-r03.json`保存FAIL及全部文件SHA，原r01失败回执不变。新脚本增加输入opt DCP与opt审核回执的身份匹配；r01原审核脚本已恢复到auditor-original.py并核对其SHA与原失败回执完全相同，r03使用的脚本另存auditor.py。

分项复核：最终1327条时序约束与opt逐条相同，无需序列化例外；三位Gray max-delay slack8.195/7.745/8.265ns，五组skew slack8.437/8.989/9.052/8.565/8.830ns。CDC汇总仍25个CDC-3、2组CDC-6、7个CDC-9、135个CDC-15，无Critical；展开DRC无Error/Critical，PLBUFGOPT-1仍为2（相对父版多1，尚不能按原父版完整门禁直接签核），其余数量与父版一致，methodology数量不变。

## T29 同一RTL的TimingClosure增量收敛实验

增量读取/回放完成后的reuse_before_place.rpt确认Incremental Directive=TimingClosure、Target WNS=0.0；95210 cells/73480 nets/361073 pins/161 ports全部100%匹配/复用。参考记录WNS−.195/WHS+.049。before_place_timing.xdc独立复核1327条与opt逐条相同，脚本前置门禁通过后已开始place_design；不是凭命令字符串假设模式生效。

place阶段连同增量回放490.728秒/exit0完成；观察超时后确认原任务正常结束。placed估算WNS−.230/TNS−3.950/49个setup失败，hold为NA（仍需实际route），不与参考最终STA直接作同阶段比较。after_place_timing.xdc再次逐条相同，未降低时钟目标。保存placement-session.log及placed时钟拓扑，继续从这份placed DCP做独立TimingClosure route。

TimingClosure route68.031秒/exit0，实际仍WNS−.195/TNS−3.897/48setup失败、WHS+.049、75208网全部布线/0错误，与参考最终结果相同。本实验没有带来进一步时序改善；保留reuse/STA/route/session证据，不再重复同一策略。

读取最差路径及实时驱动负载：AR payload[23] Q网络8负载、首段路由1.305ns；路径上的AR gen_endpoint.r_range[0]由LUT6驱动、11负载、路由.762ns；次差AW payload[27] Q网络2负载。两FF驱动未设置DONT_TOUCH。下一定点实验仅针对这三个已核对的数据网络尝试工具支持的驱动复制；不复制时钟、复位或未核实的carry输出，也不假设每个目标都能合法复制。

targeted-r01在48.133秒以明确工具错误终止：Vivado_Tcl4-265 `Option -force_replication_on_nets is specified but not supported yet for post-route physical synthesis`，随后Common17-39。三个目标的primitive/负载检查均已通过，但命令在执行优化前拒绝，因此没有after_force DCP，也未改变输入检查点。保留r01脚本/targets/失败日志，不把本次当作已实施优化。按工具实际支持范围改为从physical-r04/placed.dcp在布线前执行同一三个数据网络复制，使用独立targeted-r02，再重新route；不尝试绕过工具阶段限制。

targeted-r02在46.559秒被输入STA核对拒绝，未进入复制：重开placed.dcp后实际WNS为−.195，而刚完成place时报告估算为−.230。只读查询确认current_design=checkpoint_placed/part正确，文件SHA `965577553cbb505ff4a5fc727268e2df65bd52164ee4907bf88c96bc0317c0d6`。此增量检查点本身保留参考布线，因此不能按文件名“placed”判断可调用的优化阶段，也不能以阶段估算STA当作输入身份。保留原失败日志；后续改用固定SHA绑定，并按UG835官方route_design -unroute清除本机实验内存中的布线后，再在受支持的预布线阶段复制。原DCP文件和板端均不改动。

进一步从本session历次BD验证原日志确认gp0_smc和vision_control_smc明确为Low-Area Mode，与PG247依赖条件吻合；此模式不能靠打开MMU_REGSLICE自动修复，官方建议按接口时序采用外部寄存器切片，当前设计已有vision_gp0_slice，仍需针对译码内部路径评估。新IP配置尚未应用，不能报告已参数化或已通过。

targeted-r03用SHA绑定r04/placed输入，按UG835执行本机route_design -unroute后，三个网络的预布线复制命令及报告阶段88.090秒/exit0完成；没有再次触发post-route选项拒绝。1327条时序约束仍与opt完全相同。after_force为清除布线后的实验DCP，STA为预布线估算，不与−.195ns真实routed结论混用；下一步必须重新route并测完整setup/hold/CDC/DRC。原r01/r02失败证据保留，板卡未访问。

定点复制实际结果补充（targeted-r03/session.log）：三个请求目标中，仅AR gen_endpoint.r_range[0]的LUT6驱动复制1次，新增1个实例；AR payload[23]与AW payload[27]两个FF驱动均未被工具复制。不能把命令成功写成三个网络均已复制，更不能将预布线STA当作真实收敛。当前仍以r03最终−.195ns/48个setup失败为最佳真实布线结果；后续须重布线验证该单LUT实验。

## T30 定点译码复制后的独立重布线

route-r02执行前独立审核before_route_timing.xdc：1327条与opt基线逐条完全相同；输入实际75209条可布线网全部未布线（单LUT复制新增1网）。桥接300秒观察超时后原71000仍running，未重启。原生日志先完成route/连通检查，再在Phase12执行Incr Placement Change并进入第二轮路由：清除物理布线不等于清除增量TimingClosure元数据。−.383ns等中间结果不作为最终签核。

官方后备结构方向只读评估：PG247 Low-Area Mode记载2026.1新增Ultralite，要求无SI/MI级联、地址aperture≤64、32位Lite、无exclusive及稀疏连接。当前冻结BD SHA620af4aafabe39fcf9dee94b4ea4ed6fbdf5bb07dc8de2b5db5a23fd03c73385存在gp0 M29→vision_control_smc级联；静态提取PS GP0恰有38地址段，均2次幂对齐且不重叠，扁平叶接口31−1+8=38。只能说明地址数量/对齐满足该项条件，尚未证明全部接口资格、工具会实际选择Ultralite或时序会改善；未改BD/IP。依据https://docs.amd.com/r/en-US/pg247-smartconnect/Low-Area-Mode 。当前route-r02仍运行，先等待真实结果。

route-r02耗时567.769秒/exit0；75209网全部布线、0routing errors，前后1327条有效XDC与opt逐条完全相同。最终最差setup−.182ns，最差路径已转为core/tilemap_store bank_0_tile_size→rejected_packet_count CE（11级逻辑、7.025ns布线占72.48%），不再是原GP0 AR译码首位。当前仍setup失败，不能导出部署。保存原生session.log和完整阶段报告后，从明确指定的route-r02/routed.dcp继续单次post-route Explore；不读取旧route-r01。

时钟诊断官方依据补充：AMD AR64289（https://adaptivesupport.amd.com/s/article/64289?language=en_US ）明确phys_opt_design可能串接多个BUFG平衡偏斜，并要求检查最后插入分支loads的from/to路径，区分真实同步关键路径与缺失例外。UG949 Cascaded Clock Buffers另要求审查级联布局/专用路由。新增报告收集按当前DCP逐一保存小分支实际负载及双向min/max路径，不添加false-path、不设DONT_TOUCH来掩盖问题，PLBUFGOPT仍保留。官方说明不等于本设计已审查通过。

postroute-r01耗时377.306秒/exit0，观察超时后确认同一任务正常完成。单次Explore最终WNS+.002/TNS0/0setup失败、WHS+.049/THS0/0hold失败、pulse+.538；hold_fix分支未执行。75210条网全部布线、0routing errors；1327条有效XDC仍与opt逐条完全相同，100MHz未降低。最差路径现在为RGB byte_count[4]→byte_count[0]/CE的64位链（19级逻辑，含17个CARRY4），+.002ns仅2ps，不能夸大裕量。保存优化DCP/全部原始日志；下一步完整独立签核及新增BUFG分支审核，尚未签核、未生成bit、未打包或上板。

## T31 新增时钟级联的DCP绑定专项审核

clock-review-r01事实收集58.198秒/exit0；三处实际级联分别CTRL13_O→FBG_OUT13→CTRL14_I0、14→15、15→0，均在CLK_BUFG_TOP_R_X87Y53专用资源内。全部4输出ROUTED、无CLOCK_DEDICATED_ROUTE覆盖，19个小分支顺序单元均FDRE/clk_fpga_0；三分支各20条from和20条to样本（120条）皆MET，最小slack依次.071/.276、.030/.221、.036/.183ns。全局STA覆盖全部受约束路径、XDC仍1327条完全相同。限定SHA的独立clock审核PASS，另有错DCP、FALSE路由覆盖、fabric替代、异时钟、未知第五BUFG五个负例均正确拒绝。此审核不创建waiver，只允许完整auditor显式携带该回执时核验这份固定DCP的精确DRC变化；默认仍要求原父版DRC数量完全相同。原FAIL回执/原auditor不覆盖，继续完整源身份、CDC、资源门禁。

完整reviewed-r01审核在OSD CDC索引门禁失败（audit_latency_admission_physical.py:119，set(indices)!=range(135)），新FAIL回执latency-admission-physical-r04-reviewed-r01.json及当轮auditor快照保留。已通过STA/route/约束/固定DCP时钟审核不替代此后半段失败，尚未导出bit。下一步只读比较父版与本候选135条OSD mailbox→pending_cfg路径的索引/冻结RTL，判定是否为工具合法裁剪或真实遗漏；不直接改成只检查数量。

CDC失败根因已由真实父版/本候选/冻结RTL交叉确认：OSD mailbox/pending_cfg为192位六个字，不是135位向量；像素器只使用flags[3:0]、x[42:32]、y[57:48]、level[73:64]、soft[89:80]、loud[105:96]、TTL与身份[191:112]。综合保留135位、裁剪57个保留位；父版与候选135对索引完全相同且无重复/错配。错误是新auditor假设索引连续0..134；修复改为精确字段集合+与已签核父CDC逐端点相同，并绑定父CDC SHA及4份OSD RTL和原OSD OOC DCP的SHA不变。不是只改计数门槛，不改RTL或CDC约束，原FAIL保留。

完整审核reviewed-r02输出ADMISSION_PHYSICAL_AND_SCOPED_REVIEW_PASS，仍固定DCP SHAd9355390…/WNS+.002/WHS+.049，所有setup/hold/pulse零失败。包含控制3源与既有数值模块身份、122个综合输入的当前SHA、135位OSD精确端点和5组skew、DMA同钟及资源门禁；clock审核只作用本DCP，原DRC3条告警保留。OSD审核另有保留位替代、错配目标、缺端点、缺max-delay四负例均正确拒绝，audit-reviewed-r02.py快照与回执SHA相符。位流导出前verify_latency_admission_export.py逐SHA重验完整回执文件/全部综合输入/两组负例/clock回执，ADMISSION_BIT_EXPORT_PREFLIGHT_PASS；独立export-r01只生成本机候选bit，不改变原失败impl运行或板端。

export-r01在位流生成前的Python复验处失败：子进程从Vivado路径加载tkinter并受TCL_LIBRARY影响，Python侧Tcl8.6.14与Vivado init.tcl要求8.6.13冲突。未进入open_checkpoint或write_bitstream，没有生成bit。原导出/审核脚本、preflight及完整原生日志保存在export-r01。下一独立export-r02仅隔离Python子进程环境：-E忽略PYTHONHOME/PYTHONPATH，导出verifier进程内清除TCL_LIBRARY/TK_LIBRARY/TCLLIBPATH后再导入只做数据解析的Tcl；不改父Vivado环境、系统安装或设计/审核门槛。原完整签核及固定DCP保持不变。

export-r02完成83.102秒/exit0，Python环境隔离生效，write_bitstream前实际STA仍+.002/+.049ns/10ns，Bitgen Completed Successfully且DRC0 Errors。导出bit为4045766字节，SHA256 ddab12d94487c01b4b526ed1e73e3bf12efe42301bcce1c0da543e60d6709106；导出后逐SHA复验原物理签核/全部源输入/clock回执及负例再次PASS，pre-bit有效XDC仍1327条完全相同。evidence/latency-admission-bit-export-r02.json=ADMISSION_REVIEWED_DCP_BIT_EXPORT_PASS，绑定原DCP、bit、preflight、导出脚本及原生日志。新METHODOLOGY_RESOLUTION_REPORT.md在本候选signoff目录列明全部保留告警、固定DCP的时钟审查及2ps裕量。

## T32 上板准备文件（完全离线）

恢复工程时open_project返回Coretcl2-101：E:/vvl/c0e/c6_latency.xpr already open。原checkpoint临时project关闭后可能已露出保留的原工程，不能据此重复打开或关闭其他会话；下一步只读查询当前project/BD及run并复用正确上下文。没有触发构建或导出。

原工程实际已保留，复用后REQ:OK23/23、BID0xC0060E00、synth_admission_r01无NEEDS_REFRESH、GP0/vision MI31/8。platform-r01导出5.264秒/exit0；仅暂存精确已签核bit供UG835 project-mode XSA读取，导出后把该新暂存副本移入独立证据目录，原impl的负时序DCP/报告未变且run bit路径恢复不存在。Project1-971关于platform元数据版本覆盖的Warning原样保留，未改变硬件ABI。

r03准备完成：从固定SHA的R19归档沿用250个运行文件，从固定r06归档仅补两个原测试辅助函数；原目录270项/4子测试24.28秒通过，独立还原目录270项/4子测试24.80秒通过。两目录各完成完整性/配对检查、正常采样check-only、关闭音量采样check-only、全部CPU合同回归，共8条成功命令；仅在主机使用回环Mock服务，无板端访问。

R20 Agent正常监听8765/8081，OV5640 ID通过；首读真实frame741，默认菜单10.18秒视觉18.268fps、OSD24.947Hz/单核2.202%、音量49.698Hz，last_error=null。原生Studio显式BUILD0E00，首相机订阅早于Agent就绪而超时，证据保留；另开r02后READY/Camera connected，120秒307帧并留原生截图。Computer Use helper初始化缺路径，未进行任何窗口输入。

回传期间OSD23.59Hz/单核2.093%通过2.5%门槛，但识别4.777fps、手结果年龄中位262.7ms/p95 364.5ms；因此整体性能仅PARTIAL。B11游戏、游戏暂停、返回菜单、视频、视频暂停及稳定暂停OSD约20.96–23.82Hz、单核1.805–2.134%，暂停合同/位置握拳/TTL夹具通过，测试注入已清除。B13真实GPU黄金回放在运行，结果以最终收据为准，不提前宣布全部通过。

源码确认预览需求仍令mask识别消费者等待带同token RGB的帧，且识别线程在发布控制后同步准备诊断RGB；这是后续性能归因线索，不依赖GPU消费。R20运行时保持冻结，未在线盲改算法；物理输入至HDMI时延、显式满槽长暂停/恢复与最终STOP闭合仍待验。完整执行命令/原始失败与结果见 `docs/bringup/2026-10-23_pynq-z2_r20_board_test.md`；当前板卡由R20占用，预约页已同步，不得覆盖活跃Overlay。

T33末次性能澄清：B16视觉实际21.183fps；B17同boot/owner结果frame12548继续推进、无stderr/退出，三次8081及8765持续连接均在。前述4.777fps是阶段性观测，不能定论为回传固定瓶颈或GPU冲突。最新汇总 `r20-first-board-summary-r02.json` 绑定B17并保留r01，后续性能门禁为负载/场景单变量隔离、吞吐波动与预览等待耦合验证；服务和Studio继续运行。
