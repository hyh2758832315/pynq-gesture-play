# PYNQ USB Hand

本目录提供17电机 SCS225 灵巧手的控制源码、ORCA Core 0.4.3 快照、许可证及配套标定资产，支持 Python 3.10 及以上版本。整机由 Studio 部署并管理手势跟随与示例播放，运行期采用最新状态消费和阶段目标播放；详见[当前设计](../../../../report/design_report.md)和[整机验证](../../../../report/validation.md)。

下文介绍独立四键接口，以及2026-10-23至24日的通信与动作调度实验。各节数据对应其所列模式和输入；反馈验证模式与整机固定播放模式分别配置。[固定播放验证](PLAYBACK_OFFLINE.md)和[双进程通道验证](BRIDGE_CANDIDATE.md)提供设计演进与复现方法。

## 安装

在本目录建立自己的环境，避免使用其它项目的虚拟环境：

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install .\vendor\orca .
.\.venv\Scripts\python.exe -B run.py verify
.\.venv\Scripts\python.exe -B tools\verify_offline.py
```

Linux对应使用`.venv/bin/python`。ORCA的原始依赖约束保留，初期未裁剪强制依赖；`requirements-host.txt`固定本次PC验收环境，版本和平台见`evidence/offline-verification.json`或本地`build/offline-verification.json`。交付包中的`wheelhouse`只适用于标注的Windows CPython平台；ARMv7需要在目标平台重新核准依赖，尤其NumPy>=2.2.6,<3及Python兼容性。

同平台无网络重建可使用包内wheelhouse，安装器仍会正常解析全部依赖：

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install --no-index --find-links wheelhouse -r requirements-host.txt pynq-usb-hand orca-core
```

主推荐入口为`run.py`，它显式绑定本目录src和资产。安装的`pynq-usb-hand`命令需传`--root`为本目录绝对路径，避免site-packages位置被误当资产根。`verify`只使用标准库校验冻结文件；姿态重建和完整验证需要安装ORCA依赖。

## 四键操作

```powershell
.\.venv\Scripts\python.exe -B run.py keys
```

启动为`CONNECTED_OFF`。`a`明确使能，`r`取消并卸力，`s`查看缓存，`q`或Ctrl+C退出并清理。使能是异步操作，可通过`s`确认`READY`后再按动作键。默认后端为`MOCK_SYNTHETIC`，只用于软件交互验证。

| 电脑键 | 四位输入 | 目标 | 动作路径 |
|---|---|---|---|
| 1 | bit0 | default | default |
| 2 | bit1 | paper | default到位 → 五指中点到位 → paper到位 |
| 3 | bit2 | scissors | default到位 → scissors到位 |
| 4 | bit3 | rock | default到位 → 五指中点到位 → rock到位 |

三个手势每次都先回默认，包括重复同手势；运动时其它普通请求返回busy，不排队。默认阶段失败后不进入手势。默认与布来自新采姿文件position_rad；剪刀和石头采用原构造器，腕保持新默认。五指先行及石头thumb_abd提前路径沿用交接规则。

四位输入使用`keys --input masks`：标准输入每行`单调秒数 四位mask`，例如`0.04 0`或`0.10 0x2`。上电先稳定松键30ms，稳定单键只发一次，长按不连发，组合键须完全松开后重武装。控制命令a/r/s/q单独成行。该接口可独立接入未来经过核验的板载四键采样器；本包不载入Overlay、不访问MMIO、不复用其他副本的按键IP。

终端空闲时阻塞等待，无HTTP、GUI、网络遥测或样本历史环。当前实验分支仍按健康间隔回读电机，控制源不续约时租约到期自动取消卸力；状态查询不续租。CLI首版使用有界会话，默认Mock租约60秒；到期后需明确重新使能。生产常驻租约/心跳由后续独立控制源接入时核准。

## 有限离线回放

```powershell
.\.venv\Scripts\python.exe -B run.py poses
.\.venv\Scripts\python.exe -B run.py demo --real-poses --fast
```

三轮请求为paper/scissors/rock重复3次，每次自动前置default，共18终态、24阶段、384个全手waypoint，相当于6528个逐电机位置目标。此为真实资产驱动的Mock结果，输出标明`MOCK_REAL_POSES`；它没有向电机发送6528条命令。`--fast`仅作用于Mock。

## 真实硬件门禁

Linux运动入口必须显式选择唯一`/dev/...`串口，核对Host/驱动、单总线1Mbps、17颗ID、资产对应机械手、独立动力供电/反灌/共地及可切断动力的急停。还须提供已核准温度上限、完整扫描有效期和持力租约；参数缺失时在模型/串口连接前拒绝启动。

入口为`keys --hardware --port ... --confirm-safety --max-temperature ... --max-scan-age ... --lease-seconds ...`，参数按对应机械手的标定和现场检查结果填写。只读connect核查17颗OFF状态且不发送位置/扭矩/参数写；`a`才授权OFF目标对齐、speed500及全手使能确认。缺标定、过期反馈、范围、协议error、原生限力偏差、低压/温度异常及超时锁存故障，不自动重放。正常动作不修改EEPROM限力；仍需板端核实设备保护配置与SDK超时边界。

单worker持有串口，取消检查覆盖waypoint及逐电机事务前后。软件取消/卸力时延取决于当前SDK事务，尚无实测最坏值；断线或卸力失败报告`RELEASE_UNKNOWN`，关闭端口不证明动力已切断。安全预检失败不会暗中卸力写入。首版故障恢复采用关闭进程、现场核查后新会话，不自动reset或重新上力。

### 单次只读探测

独立探测入口不经过交互控制器的卸力清理，只允许本手配置ID的指定寄存器READ包。选择不唯一、串口已占用、协议错误、非OFF、电压或限力不符合原约束时停止，保留已有读回并仅关闭端口。温度为原始读值，不代表温度保护策略已核准；该入口不使能、不移动、不发送卸力，也不授予运动许可。

```bash
.venv/bin/python -B -m pynq_usb_hand.probe \
	--root /absolute/path/to/hand/source \
	--port /dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00 \
	--output /absolute/path/to/new-readonly-report.json
```

报告路径必须不存在。此入口需要完整模型依赖，原始电机raw读取不替代标定机械范围或现场急停验收；上板记录中的最小SDK诊断单独标注 `full_orca_environment_verified=false`。

## 串口低负载优化

2026-10-23精简候选已完成PC/ARM各65项回归和四手势各一次实物闭环测试。原版板端`install-source-r01`和第一候选`source-lite-r01`保留；该轮已验代码位于独立`source-lite-r02`。其后的responsive首轮上板结果见下一节，与r02分开留证。使用对应目录的`run.py`绑定源码，单独给旧安装命令传`--root`只会换资产路径，不会切换已安装代码。

本轮实现三项优化：17颗反馈由85笔逐字段读取合并为17笔连续READ；步进周期扣除当步通信时间，超期不补发；复用仍满足剩余期限的串口write_timeout，避免逐笔重配置。无新依赖、后台服务或额外串口线程，speed500/native_limit1000及资产不变。

`keys --waypoint-feedback-interval 0.1`显式选择本次实测的100ms步进反馈间隔，必须搭配既有硬件确认/端口/温度/有效期/租约参数。默认0仍逐waypoint回读；非零必须小于`--max-scan-age`。它是启动下一次扫描的检查间隔，不是硬实时采样上限，实际还包含串口及调度时间。每次扫描仍校验全部17颗的位置、电压、温度、扭矩及限力；阶段起点、指尖中点与三帧到位回读保留，READY健康扫描也保留。两次扫描之间的异常检测存在延迟，不等价于逐步监测，更不是H8无位置反馈模式。

| 动作（非default均含先default） | 旧版秒 | 精简候选秒 |
|---|---:|---:|
| default | 6.72 | 2.48 |
| paper | 14.58 | 5.31 |
| scissors | 13.45 | 4.92 |
| rock | 14.56 | 5.45 |

同板只读ABBA：完整扫描中位约171ms降至51ms；相同扫描工作CPU时间约下降75%。在同为17笔连续READ的条件下，超时复用将每10扫描的串口重配置170次降至2–4次，CPU时间再降约12%，扫描时延基本不变。该比例只用于相应只读对照，不外推成完整动作CPU下降比例。原始报告及错误修复均见[上板记录R30–R34](../../docs/bringup/2026-10-23_pynq_usb_hand_board.md)。

当前工作树使用项目自有`BoundedPortHandler`接入原SDK解析器，保留逐电机ACK、校验和设备error，不修改冻结ORCA或第三方SDK。等待ACK采用有限阻塞读取，按单调时钟计算剩余整包窗口、事务上限和租约；取消在每次有限读取前后检查，不依赖额外收包线程。输出队列采用有界等待，写入设置剩余超时；异常退出清理SDK busy标记，后续卸力使用不继承已取消令牌的独立事务。

当前软件默认读取切片10ms、单笔事务上限100ms，SDK原接收窗口约50ms仍保留。它们是离线实现参数，操作系统调度及驱动调用可推迟返回，不是已经在PYNQ上核准的最坏时延承诺。到包超过剩余窗口会被拒绝，取消也不证明物理卸力成功；板端需验证真实USB、故障恢复、总卸力时延及CPU/RSS。

动作之间保持串口打开，未使能时沿用Condition休眠，READY仍保留实验版健康扫描。当前没有逐动作重开口、自动重连、持力期间关口或未经验收的开环control切换；长闲置关口策略仍需结合独立安全卸力/重新接入流程核准。

本次改动属于旧封存ZIP之后的工作树版本，旧包不含此优化且未覆盖。独立验收命令如下，保留原报告：

```powershell
.\.venv\Scripts\python.exe -I -B tools\verify_offline.py --output build\ack-wait-verification.json
```

报告包含完整测试、冻结SHA、三轮Mock和原SDK/新适配器的5次无响应内存回环对照。回环的进程 CPU 秒用于 PC 软件机制对照；短区间读数受计时分辨率影响，PYNQ 运行负载另行测量。

## 两秒目标快速候选

```powershell
.\.venv\Scripts\python.exe -B run.py keys --motion-profile responsive
```

快速候选取消固定1秒终态保持，最小步进周期10ms、步进反馈检查间隔200ms；通信超期不补发追赶。已使能会话内，仅跳过raw位置和速度均与上次成功ACK一致的目标；变化目标仍逐颗ACK。失败、取消、重新连接/使能、卸力和关闭清空目标缓存，OFF对齐不跳过。该缓存记录已确认发送的目标，实际到位由位置反馈判断。

同一次请求的相邻阶段，可复用刚完成三帧到位检查的最新新鲜反馈作为起点；过期或跨请求重读。非default仍先default，paper/rock仍经五指中点，步数不变；每阶段仍要求三次不同新鲜帧、10%ROM误差阈值。保留speed500、native_limit1000、温压检查、租约、取消和卸力；200ms是扫描检查间隔而非硬实时上限，故障检测时延需要重新实测核准。该模式不是关闭位置反馈的H8。

真实SDK配合内存串口，遍历四起点×四目标×去重开关共32场景，以每笔位置写/ACK2ms、整块READ3ms近似历史通信开销。启用去重后的最差模拟值如下：

| 动作 | 模拟秒数 | 距2秒余量 |
|---|---:|---:|
| default | 1.078 | 0.922 |
| paper | 1.682 | 0.318 |
| scissors | 1.998 | 0.002 |
| rock | 1.949 | 0.051 |

范围为`Motion.run`入口至最终reached，非default包含先default；不含控制器请求派发、连接、使能及卸力。内存电机立即更新位置，未模拟机械跟随、负载、Python计算和OS抖动。因此这是通信调度预算，不是实物两秒达标；尤其scissors仅2ms、rock仅51ms余量，无法支持真实动作全部低于2秒的承诺。旧报告h58至h61的`request to reached`标签也应按此函数级范围理解，后续报告已明确字段。

responsive-r01已完成PC/ARM各71项检查、117冻结和离线协议门禁。接电后17颗只读健康、短使能/立即卸力通过；四项实物各一次结果如下，speed500/native_limit1000保持：

| 完整请求 | 实物秒数 | 低于2秒 |
|---|---:|---|
| default | 1.365 | 是 |
| default→paper | 1.746 | 是 |
| default→scissors | 2.171 | 否 |
| default→rock | 2.896 | 否 |

写入热路径候选先通过PC/ARM各73项检查：responsive复用已验证raw，直接调用同一SDK WritePos及逐颗ACK，避免重复标量NumPy裁剪。独立`source-fast-ack-r01`保留；ARM内存ABBA的软件调用耗时比0.464，SDK参数完全一致、未开真实串口，该比值对应软件调用开销，完整实物动作单独计时。随后按每档100的速度增量构建`source-speed-r01`完成PC/ARM各75项检查、117冻结校验、149项候选SHA及离线协议门禁，再通过全手只读、600档短使能/立即卸力和以下实物分档测试。

`OrcaBackend(..., speed=...)`支持审计调用者显式指定速度，默认500不变；CLI未新增调速开关。构造器仅接受1至32767的整数，实际速度范围由机械手标定与实物验证确定。现场本轮以1000为停止上限，限力仍1000、40℃上限/2秒反馈有效期/5秒租约/每0.5秒调用者续租及其余保护不变。

| 速度 | default→paper秒 | default→scissors秒 | default→rock秒 |
|---|---:|---:|---:|
| 600 | 2.173 | 1.962 | 2.660 |
| 700 | 2.239 | 1.982 | 2.681 |
| 800 | 2.155 | 1.878 | 2.659 |
| 900 | 2.162 | 1.908 | 2.593 |
| 1000 | 2.258 | 1.937 | 2.590 |

真实位置包均按所选速度下发、COMM/device error为0；每项显式release及close各确认17颗OFF、CLOSED/error=null且端口关闭。动作含审计时单核CPU51.3%–54.6%、RSS22660–22944kB、2线程，电压4.6–5.3V、温度19–24℃。最后实物h100后已卸力关口、动作进程退出；这是末次已知状态。h101证据包逐SHA及18组报告对象一致，15请求共40阶段的末三帧重新按冻结姿态/ROM核验通过，30次卸力共510颗次OFF确认。各档仍为单次，重复范围、故障矩阵和长期资源待验，`release_ready=false`。

### 固定500的后续候选

responsive到位扫描按起点计20ms周期：扫描已超周期时直接进入下一次新扫描，快扫描仅等待剩余周期，audit默认后置等待保持不变。完整default、paper/rock中点、原步数、三次不同新鲜帧、10%ROM及其余保护不变，无新增后台线程或依赖。PC/ARM各79项、117冻结、149项候选SHA及32场景协议门禁通过。ARM正反转换ABBA比0.1691/0.0898，仅代表对应计算函数，完整动作不按此比例推算。

上板分阶段门禁和回退见[BOARD_PREP.md](BOARD_PREP.md)，其中等待通知是h63/h64历史准备状态；最新授权、完整请求实测、失败恢复及原始SHA证据见[上板记录](../../docs/bringup/2026-10-23_pynq_usb_hand_board.md)。

## 复建与验收

`tools/verify_offline.py`运行全部子项目unittest、禁止串口打开、复验68目标及三轮Mock，并输出JSON和原始测试日志。`tools/package_release.py`封包后逐ZIP字节核对清单。`.venv`、缓存、外部绝对运行路径及主工程代码不进入交付。

H2的ARM安装、H3只读USB、H4短时使能/卸力及H5四个单动作已有实测记录；H6三轮与异常保护、持续资源、板载按钮绑定仍待独立验收。H7已有上述单次精简对照，当前没有新增RTL、PL IP或比特流。稳定后按资源第一原则再实施H8定时操控出口，单独验收关闭位置反馈后的行为，禁止用发送成功替代真实到位。
