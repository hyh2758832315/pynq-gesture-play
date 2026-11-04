# 独立双门槛声音子项目 VOL1

## 身份与边界

目标PYNQ-Z2 / xc7z020clg400-1 / Vivado2026.1 / Zynq-7000 PS7。
独立profile `VOICE_VOLUME_ONLY_V1`，BUILD_ID `0xC00C0001`，magic `0x564F4C31`，schema `0x00010000`。
当前停在离线上板候选，`BOARD_PENDING / release_ready=false`；不继承视觉800、融合900/B00身份。
V0视觉包、GPU、游戏、SDK及旧声音交接原件保持只读。后续用户授权仅在Studio Audio页增加独立VOL1观察入口，详见文末；不改其他平台硬件ABI。PL无音频DMA、HP/DDR master、FFT、FIR抽取或分类器。

## 输入与数值合同

- 100MHz FCLK0为总线和算法稳定时钟；PS7 DDR/MIO源为官方PYNQ v3.1提交19ed17d4fd4ea71f95a97d30f8ccd0d62b8dbaaa的已存板级配置。
- 自由11位计数器输出BCLK=100MHz/32=3.125MHz，LRCLK=100MHz/2048=48.828125kHz；I2S slave codec，32位slot、左低、一位延迟、上升沿采样、24位最高16位进入判定。
- MCLK=10MHz；codec PLL使用整数R5得到50MHz，ADC及serial使用1024分频，与LRCLK一致。PLL写块`00 00 00 00 28 01`，最后字节lock位只读。
- codec IIC地址strap为11，7bit地址0x3B；PS IIC1 EMIO。pin/source合同来自只读交接XDC；实际电气/连接与Linux总线号由S06核准，不假定板载麦克风。
- 单声道来自模拟MIC接口；差分增益21dB/boost20dB沿官方PYNQ基线，0x4011=0关闭ALC选择、0x4014=0关闭noise gate；输出路径静音。实际声源电平和增益适宜性待板测。
- 样本有符号16位。DC用25位有符号Q8状态：`next_dc = dc + ((sample*256-dc) >>> 10)`；`y=(sample*256-next_dc) >>> 8`。算术右移向负无穷取整，无舍入补偿。固定合法参数下DC状态、18位y/abs无溢出，不做隐藏饱和。差分/DC更新/累加分3拍，入口间隔至少3周期，忙时重入fault bit7；实际I2S间隔2048周期。
- 窗N=977，有效样本使能累加，约20.00896ms。使用33位中间和、32位保存；最大单样本幅值65535，977点上界64027695；溢出直接FAULT。阈值配置为`T*N`预乘和，不在数据通路除法/乘法。
- `0 <= quiet_sum < soft_sum < loud_sum`；默认值仅占位，启动disable。低档3窗，高档连续2窗优先，候选总长3窗。候选中一次未确认高档扰动则放弃该声，不降猜SOFT。
- 一声最多一个事件。持续声、尾音、后续慢升不追加；5个有效安静窗及ACK后重武装。缺采样不是安静。
- 单事件槽未ACK不覆盖；事件年龄按100MHz计数，100ms到期失效并FAULT；10ms无有效采样FAULT。窗内超过32个正/负满量程样本作为严重削波FAULT。
- 配置commit产生新epoch、清部分窗/DC/计数/故障及旧事件；epoch耗尽拒绝commit。sequence从1起，事件绑定源sample/window，ACK同时匹配epoch+sequence。设备/PL复位后必须重新建立独占session，旧session令牌全部作废。

## 寄存器

单个4KiB AXI-Lite从设备，已实现基址0x43C00000。所有写必须32位对齐且WSTRB=0xF；无效地址、部分写、非法配置返回SLVERR。AW/W分别拥有，接受后不超过2个稳定总线周期产生BVALID；AR接受后1周期RVALID；背压时保持响应。音频停/未配置不影响总线完成。

| 偏移 | 含义 |
|---|---|
| 0x00/04/08 | magic / BUILD_ID / schema，只读 |
| 0x10 | live status：enable0、pending1、fault2、MCLK locked3、ACK错误4、FSM[10:8] |
| 0x14/18/1C | fault bits / config epoch / N，只读 |
| 0x20/24/28/2C | shadow soft/loud/quiet和、shadow enable(0或1) |
| 0x30 | 命令：1=commit，2=抓取快照，4=ACK；只写 |
| 0x34/38 | ACK epoch / sequence暂存 |
| 0x3C | 快照代数，只读 |
| 0x40/44/48 | snapshot status / faults / epoch |
| 0x4C/50/54/58 | snapshot sample low/high、window count、L1 |
| 0x5C/60/64 | event sequence / epoch / {pending位2, kind位1:0}，kind1=SOFT、2=LOUD |
| 0x68/6C/70/74 | event sample low/high、source window、snapshot时event age(100MHz ticks) |
| 0x78/7C/80 | snapshot active soft/loud/quiet和 |
| 0x84 | snapshot_valid；commit/ACK/disable/fault失效 |

故障位：0配置非法、1缺样本、2严重削波、3和溢出、4事件到期、5计数耗尽、6帧错/音频clock未锁、7入口样本间隔违规。故障清除必须显式合法commit。ACK错误另有粘滞标志，不释放事件。
快照为同域同拍抓取，不是多位逐位同步。独占PS读者先发snapshot，再读代数/valid/17字及live状态，再复查代数/valid/epoch；本地耗时加快照age必须小于100ms。任何fault、epoch变更或pending丢失均丢弃。100ms是初始有效期，不是端到端实测延迟。

## 最小平台与来源

PS7 GP0 -> 单口AXI协议转换 -> VOL1；另有proc_sys_reset与10MHz Clocking Wizard。控制/状态不以音频时钟或MCLK lock复位；MCLK lock只决定音频有效性。
接收代码按交接`voice_i2s_rx.sv`合同独立重写并加入帧长度检查；旧codec_ctrl/40MHz/FIFO/重算法顶层不带入候选。
PLL整数模式核验来源：Linux v6.6 `sound/soc/codecs/adau-utils.c`，R=out/in、M=N=0、byte4=R<<3；ALC与noise gate区分来源同版本`adau1761.c`。初始化地址/输入路由/增益参考PYNQ v3.1 `pynq/lib/_pynq/_audio/audio_adau1761.{cpp,h}`。

## 门禁与运行

事实、命令、失败和复验统一追加[2026-10-19_voice_volume_offline.md](bringup/2026-10-19_voice_volume_offline.md)。
离线必须依次完成：核心/整数黄金/AXI/I2S/链路自检、完整最小top综合、route、100MHz setup/hold/pulse/DRC/CDC、资源、bit/HWH/XSA、SHA及实际包恢复。
S06另授权后：先独占身份及停音频AXI，再IIC地址/PLL锁定/寄存器回读，再真实采样频率/格式/有效静音，再固定增益标定双门槛、持续/慢升/噪声/削波/缺时钟/ACK失效/停启；实测误触发、延迟、ARM负载和释放。复位/重载不能自动当恢复手段。

## 离线候选及恢复

候选：`deliveries/voice-volume-only-v1-offline-20261019.zip`，同名目录含58项SHA清单、RTL/测试/构建脚本、最小PS库和bit/HWH/XSA。验收回执及后续事实位于本仓库上述事实文档与results目录，不回写已封存ZIP。整top1210 LUT/1975FF、0 DSP/0 BRAM；判定core388LUT/505FF。100MHz布线WNS+0.444ns、WHS+0.058ns，setup/hold/pulse失败均0。异步SDATA首级局部例外保留，真实外部有效窗待S06。

Vivado2026.1 TCL中，从实际恢复目录调用`board/pynq_z2/scripts/run_voice_volume_build.tcl`。先设未占用的`VOLUME_BUILD_ROOT`、`VOLUME_SIM_ROOT`、`VOLUME_EVIDENCE_ROOT`、`VOLUME_EXPORT_ROOT`；按`VOLUME_STAGE=regress/prepare/synth/route/bit/export`分阶段source。prepare创建工程，synth/route/bit保持同一工程并各自等待run结束；route后open_run impl_1并source包内report_voice_volume_candidate.tcl生成新报告。默认短根属于本次构建，应始终用环境变量覆盖，避免碰旧证据。

`package_voice_volume.py verify --root <恢复根> --zip <原ZIP>`校验清单、ZIP字节、7模块、地址、XSA内bit和原报告。`python -B sim/voice_volume/test_control.py`执行8项无板控制测试。Linux最低Python3.10已在显式WSL Ubuntu环境复验，Windows为3.13.2。

PS库voice_volume_control.py只接收已确认独占的backend工厂；工厂在ProcessTransport的spawn子进程内提供read32/write32/codec_read/codec_write/close。S06须在确认真实Linux IIC设备、0x3B、电气及复位连续性后绑定，库不猜设备索引、不自动加载Overlay。先disable配置，再一次codec初始化及回读，再以实板标定门槛enable；退出前configure(enable=False)停止采样判定，然后close transport。异常session隔离，恢复必须另行授权。PS仅传小状态字和ACK，不搬运PCM、不运行特征计算；实际延迟及ARM负载待S06实测。

## 子项目回传Studio

当前源码已提供VOL1小状态服务与原生Audio页，独立软件增量包为`deliveries/voice-volume-studio-monitor-v1-20261019.zip`，它是当前Studio工程的源文件增量，需使用本工作区既有Studio依赖与模块；不是完整安装包，也不含新bit/HWH。旧硬件封包原字节保留，未包含本节新增功能。当前控制测试为11项，旧硬件ZIP内仍是原8项。

无板模拟，在仓库根运行（此模式仅生成带明确标签的模拟幅值）：

```powershell
.\.venv\Scripts\python.exe -I -S -B python/pynq_multimodal_game/volume_monitor.py --fixture --host 127.0.0.1 --port 8771
```

另一个终端直接打开Audio页：

```powershell
$env:PYTHONPATH="$PWD\python"
.\.venv\Scripts\python.exe -B -m pynq_multimodal_game.studio.app --volume-monitor http://127.0.0.1:8771/status
```

也可通过既有`启动Studio.bat --volume-monitor http://127.0.0.1:8771/status`进入；显式VOL1参数优先于启动器原有camera-preview，不会同时启动摄像头。常规Studio中进入Audio，选择“独立VOL1 / 音量”，填写状态URL和可选直连源IP，点播放；停止只关闭Studio观察，不停止子项目采样或本地ACK。

经另行S06授权、完成真实backend/IIC及codec回读和门槛标定后，板端用Python3.10+直接执行`volume_monitor.py --control-factory authorized_module:create --host <板端数字IP> --port 8771`。工厂必须返回管理式上下文，进入时提供已建立独占、有界访问的VolumeControl；退出时正常disable及close。服务不加载Overlay、不初始化codec、不猜IIC号、不复位或自动恢复。CLI保持标准库依赖，直接文件入口避免导入PC游戏包。该实际板端工厂及端到端采样仍待S06绑定验证，当前仅假寄存器整链验证通过。

Studio地址为`http://<板端数字IP>:8771/status`；需要直连时另加`--volume-source-address 192.168.2.1`。仅接受数字IP、HTTP状态路径；不提供公网认证/TLS，限定受信任的隔离直连网络。服务默认只监听127.0.0.1，远程监听须显式指定host。网络端只有缓存GET，没有ACK、配置或复位接口。

服务每轮间隔50ms（最高约20Hz，读取与本地ACK另计耗时），保存单槽状态和最多8条当前epoch历史事件；GET不触硬件。Studio约200ms轮询，HTTP正文最多8192字节、请求总期限500ms。producer_run/epoch变化清历史；新源窗才续新鲜度，重复JSON或断流超过500ms转历史，幅值置`--`。fault、失钟、未使能、无完整窗同样显示`--`，有效静音显示0。SOFT/LOUD只作历史诊断，不注入游戏输入。

趋势为去直流后`L1/977`窗均值，阈值是寄存器预乘和除977，均为相对采样幅值，非分贝。显示源标签“模拟夹具 / 控制接口 / 来源未核”；“控制接口”表示工厂通道，不代表实板验收通过。事件在本地owner重新核epoch/sequence/kind后精确ACK，与Studio连接无关；采样失败停止后台轮询并保留错误缓存，手工诊断后重新建立会话，绝不自动重配硬件。

软件验收：Windows Python3.13.2相关116项及26子测试、Windows原生1440x900/1080x700两截图；真实WSL Ubuntu Python3.10的HTTP12项及控制11项通过，均为离线数据/假backend。实板接收幅值、延迟、ARM负载、真人声学标定与释放验收保持`BOARD_PENDING / release_ready=false`。失败原文、字体修复与复验见事实记录R22a。