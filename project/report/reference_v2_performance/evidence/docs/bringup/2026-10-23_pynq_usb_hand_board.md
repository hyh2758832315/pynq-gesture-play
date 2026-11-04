# 工程观察与验证摘录

# PYNQ USB灵巧手独立上板记录

- 文档类型：项目级上板事实记录。
- 当前路径：docs/bringup/2026-10-23_pynq_usb_hand_board.md。
- 项目：subprojects/pynq_usb_hand，17颗SCS225右手、USB单总线、PS Linux。
- 日期：2026-10-23；阶段：H2 ARM环境 / H3 USB只读准备。
- 结果：BLOCKED_SSH，BOARD_PENDING，release_ready=false。
- 关联Skill源：xilinx-skill/plugins/xilinx-suite/references/board_bringup_record_template.md；部署副本：C:/Users/developer/.agents/skills/xilinx-suite/references/board_bringup_record_template.md。

## R01 范围与基线

## R02 首次连接阻塞

- 时间：2026-10-23T01:17:18.008032+00:00。
- 检测命令：ssh -b 192.168.2.1 -o BatchMode=yes -o ConnectTimeout=8 pynq-z2 "sudo -n /usr/bin/python3 -B -"；stdin为标准库只读USB/sysfs/proc/解释器元数据采集代码。
- 原始错误：`ssh: connect to host 192.168.2.99 port 22: Connection timed out`，SSH returncode=255；外层终端exit1。stdout为空。
- 证据：subprojects/pynq_usb_hand/build/board-20261023/h01-usb-environment.json，含时间、精确argv、采集源码SHA、stdout/stderr和原returncode。
- 根因证据：连接在SSH建立前失败；无法据此判断板端USB枚举、串口驱动、权限或ARM依赖，亦未执行sudo。旧IP/网口/板卡状态待核。
- 进度影响：H2/H3实际采集均未开始，无设备写入、串口打开、依赖安装或PL操作。
- 下一动作：仅检查PC直连网卡/IPv4/路由及邻居状态，不扫描任意网络、不重试机械动作、不用旧游戏恢复入口。
- 复验：PENDING。

## R03 PC直连网络定位

只读Get-NetAdapter/Get-NetIPAddress/Get-NetRoute/Get-NetNeighbor完成，终端exit0。完整输出为subprojects/pynq_usb_hand/build/board-20261023/h02-pc-network.json（PowerShell Tee原始编码保留）。

### R04a 本机证据读取与模板定位

## R05 当前链路与替代入口复核

h04原件按BOM用Get-Content -Raw | ConvertFrom-Json解析成功。2026-10-23T01:20:57.7729540Z采集：以太网ifIndex14仍Up/1Gbps，本机192.168.2.1/24及直连路由保持；192.168.2.99邻居StateName明确为Unreachable，MAC全0。ssh -G确认user=xilinx、hostname=192.168.2.99、port=22，未发现目标别名误配证据。PC串口仅蓝牙COM3/COM4，没有枚举到历史PYNQ调试串口，不能使用旧COM7继续取证。此结果不等于PYNQ USB Host未识别灵巧手；两条USB链路的观察位置不同。

模板定位恢复：file_search找到并成功读取工作区真实源 `xilinx-skill/plugins/xilinx-suite/references/board_bringup_record_template.md`，R04a路径错误已纠正；未改Skill。网络回执解析成功，文档诊断无错误。旧失败回执全部保留。

历史事实：2026-09-29 studio-s3文档记录Clash/TUN接管导致伪TCP22连通；2026-10-01 ov5640记录使用user@IP绕过pynq-z2专用密钥而认证失败；2026-10-14 voice_s4_board R12成功路径为Windows OpenSSH、pynq-z2别名、-b192.168.2.1、StrictHostKeyChecking，配置无ProxyCommand/ProxyJump，源绑定TCP收到Ubuntu SSH banner。没有已发现的跳板或特殊设备通信协议要求。

新证据：2026-10-23T01:25:01.0567537Z，未限定源地址的Find-NetRoute选择Clash/ifIndex26、源198.18.0.1、128.0.0.0/1路由、NextHop198.18.0.2/metric0。R03/R05仅证明直连路由存在，尚未证明实际连接选路，不能排除TUN影响；本证据也不能单独证明已带-b的SSH实际走Clash。下一步核对限定源地址的选路及已有显式接口实现，不修改VPN/网卡或绕过主机身份验证，电机/PL仍零操作。

## R07 源地址约束的选路判别

h06-source-route.json采集exit0：Find-NetRoute -RemoteIPAddress 192.168.2.99 -LocalIPAddress 192.168.2.1返回以太网/ifIndex14、192.168.2.0/24、NextHop0.0.0.0。它与R06未约束源地址时选择Clash的结果不同，证实源地址约束对当前选路有意义；不能把未约束源地址的结果直接用于判定已带-b的SSH路径。当前直连接口地址Preferred且路由存在，但目标仍未取得有效MAC，完整SSH仍未恢复。

## R09 重启后的SSH恢复

h08-post-reboot-banner.json：2026-10-23T01:34:51.780220+00:00源绑定TCP取得 `SSH-2.0-OpenSSH_8.9p1 Ubuntu-3`，耗时0.2856692秒；随后一次严格主机身份校验的SSH成功returncode0、stderr空，hostname=pynq、user=xilinx、boot_id=3696016e-d285-41eb-b97a-eb4aad3eb9d4、uptime98.97秒、Linux6.6.10-xilinx-v2024.1/armv7l。相较历史0dd40186启动已变化，确认当前重启身份。h07原始失败保留，不改判PASS；未二次重启/改网络/改密钥即自然恢复，但不能据此断言具体启动服务或USB供电为早先失联根因。

## R10 USB与ARM环境只读前检

h09-usb-environment.json：SSH/sudo-n退出0，仍同boot，uptime140.11秒。USB Host枚举唯一外设VID1a86/PID55d3、product=USB Single Serial、serial=5B79030971、speed12Mbps；cdc_acm驱动产生/dev/ttyACM0（0660/root:dialout）。稳定身份为/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00，物理路径/dev/serial/by-path/platform-ci_hdrc.0-usb-0:1:1.0。/proc/fd只读检查无串口占用者；没有打开串口或发送电机读写。本结果仅证明USB枚举，不证明设备下游17颗ID或机械保护通过。

环境：系统和/usr/local/share/pynq-venv均Python3.10.4/32位，NumPy版本原始探测输出 `"numpy": "1.21.5"`，低于冻结ORCA要求>=2.2.6,<3。原探测按distribution名称简单小写映射，SDK等null仅是候选缺口，后续须用metadata.version规范查询排除连字符/下划线命名误差。gcc/g++/make/pkg-config/python3/pip3/lsusb均找到，不是编译器缺失证据；未运行pip安装或修改公共PYNQ环境。H2 ARM依赖门禁尚未通过，独立环境和ARM兼容来源待核准；不会使用Windows wheel或静默降NumPy约束。

## R11 ARM依赖缺口规范复核与本次复测结论

h10-canonical-dependencies.json：同boot下使用/usr/local/share/pynq-venv/bin/python及importlib.metadata.distribution逐包规范查询，SSH退出0、stderr空、platform=linux-armv7l。orca_core、ftservo-python-sdk、dynamixel-sdk、pyserial、fastapi、uvicorn均 `"installed": false`，排除R10探测名称映射差异。NumPy1.21.5、PyYAML5.4.1均来源/usr/lib/python3/dist-packages；pip22.0.2/setuptools59.6.0来源公共PYNQ venv。该结果只针对所检查环境，不宣称全板所有目录均无独立环境。

所需版本按冻结vendor/orca/pyproject.toml：ORCA0.4.3、ftservo-python-sdk2.0.0、dynamixel-sdk>=3.7.31,<4、pyserial>=3.5,<4、PyYAML>=6.0.2,<7、fastapi>=0.115.12,<1、uvicorn>=0.34.2,<0.35、NumPy>=2.2.6,<3。后续安装来源须使用冻结ORCA源码及正常依赖解析/PyPI或经验证的ARM包；路径为子项目自己的独立新venv（当前未创建），禁止复用Windows wheel或覆盖公共PYNQ环境。修复动作尚未执行，ARM完整依赖安装/离线回归为PENDING，未放松约束。

## 验收边界

## R12：独立安装前置检查与板端 DNS 阻塞

- 原始回执：`subprojects/pynq_usb_hand/build/board-20261023/h11-install-preflight.json`，UTC 2026-10-23 01:44:02；严格 SSH、源地址 192.168.2.1，远端 `/usr/bin/python3 -B -`，返回0，同 boot `3696016e-d285-41eb-b97a-eb4aad3eb9d4`。
- 实测 Python3.10.4/linux-armv7l；磁盘空闲10,473,799,680字节，MemAvailable383348kB，SwapFree524284kB；gcc/g++/gfortran/cmake/pkg-config及 `/usr/include/python3.10/Python.h` 存在。独立目录 `/home/xilinx/pynq-usb-hand/board-20261023-r01` 尚不存在。
- 缺失工具证据：`shutil.which` 对 rustc/cargo/meson/ninja 均返回null。尚未证明四项全部是必需项；NumPy2.2.6构建后端至少需要合适的Meson及Ninja，最终版本须按官方sdist元数据解析；Rust是否需要取决于Pydantic依赖的ARM wheel。拟从官方PyPI下载构建依赖到专用环境，避免修改公共PYNQ环境。安装路径、实际版本和复验仍PENDING。
- 实际网络错误：对 `https://pypi.org/pypi/numpy/2.2.6/json` 使用 `urllib.request.urlopen(..., timeout=8)`，返回 `URLError(gaierror(-3, 'Temporary failure in name resolution'))`。证据支持板端域名解析失败，不支持推断TLS或ARM wheel失败。影响：直接联网pip安装受阻；改由PC正常TLS下载、保存来源与SHA256、SSH传输后离线安装，复验PENDING。不修改板端DNS/网卡/代理。
- 附带探测错误原文：`cat: /sys/firmware/devicetree/base/model: No such file or directory`，子命令返回1；这是可选型号节点路径探测失败，不推断板卡型号改变，不阻塞既有身份下的软件准备。保留原文，未改设备树。
- `bootpy.service` 与 `clear_pl_statefile.service` 均实测inactive、MainPID0、Resultsuccess。未重载PL、未改服务、未打开串口、未写电机。
- 下一步：创建唯一独立载荷/venv，按原ORCA依赖约束解析ARM包，完成 `pip check` 与禁止串口打开的离线回归；真实电机与动作阶段仍PENDING。

## R13：载荷落板与目标 Python 条件依赖补齐

- `h12-source-materials.json`：当前源码载荷145文件、冻结117项全部SHA通过；载荷SHA256 `09a9378f71eda2c21b44cb480bf3a7a64e2039a67cc0e10f9a40a555657ee6c1`。不包含PC环境、旧发布wheel或游戏源码。官方NumPy2.2.6 sdist SHA256 `e29554e2bef54a90aa5cc07da6ce955accb83f21ab5de01a62c8478897b264fd`，官方PyPI该版本无ARMv7 wheel；后续计划原生单任务构建，不修改版本约束。
- `h13-arm-build-dependencies.json`：PC pip按CPython3.10/ARMv7平台下载构建wheel返回0。实际下载走现有USTC HTTPS镜像；每项均另外用官方PyPI JSON逐文件匹配SHA256，来源URL和镜像日志同时保留。不是板端联网成功。
- `h14-independent-environment.json`：SSH/SCP均0，板端 `/home/xilinx/pynq-usb-hand/board-20261023-r01` 新建成功；两个ZIP SHA、145源码条目复核通过；`venv/pyvenv.cfg` 为Python3.10.4、`include-system-site-packages = false`。
- 首次venv构建工具安装返回1，原文：`ERROR: Could not find a version that satisfies the requirement tomli>=1.2.2; python_version < "3.11" (from hatchling) (from versions: none)`；`ERROR: No matching distribution found for tomli>=1.2.2; python_version < "3.11"`。远端原回执 `h14-environment.json` 和本机封装完整保留。
- 根因证据：PC宿主Python3.13下的pip跨平台参数已选中ARM/Python3.10 wheel，但未把环境marker的Python版本切换为3.10，导致Hatchling在目标解释器下额外要求的tomli未进入材料包。此时仍处解析阶段，未进入NumPy编译，也未修改公共PYNQ环境。
- 修复动作：针对目标Python3.10/Linux/ARM环境解析wheel METADATA的有效Requires-Dist，补齐漏项，新增唯一补充材料和回执，再重跑同一venv安装。tomli从PyPI HTTPS来源取得并核官方SHA；具体版本与复验PENDING。
- 保持H2进行中、H3/H4-H6 PENDING；无串口打开、无电机写入、无PL/服务变更。

## R14：构建工具补齐复验通过

- `h15-target-markers.json` 显式按Python3.10.4/Linux/armv7l检查材料wheel的Requires-Dist，补包前仅缺tomli，补包后有效依赖缺口为空。新增tomli2.5.0的官方PyPI SHA256 `32a7b79ac57a2e83670ce329ccf675798bc5a2094783a63676866b70503f2e2b` 已核。
- `h16-build-tools-recheck.json`：严格SCP/SSH均0；新补充ZIP核SHA后仅添加先前不存在的材料。重跑同一venv安装返回0，`pip check` 返回0、`No broken requirements found.`。
- 实际工具安装于 `/home/xilinx/pynq-usb-hand/board-20261023-r01/venv`：pip26.2.2、setuptools84.2.1、Hatchling1.32.4、meson-python0.22.1、Meson1.12.1、Cython3.3.0、ninja distribution1.11.1.4。各自版本命令均0；Ninja可执行版本输出 `1.11.1.git.kitware.jobserver-1`，保留原文，不与distribution版本混淆。
- 此次pip升级/卸载仅发生在新建、不继承系统包的venv内，未修改公共PYNQ环境。Rust/cargo仍未安装，尚未证实需要。
- 接下来用已核原始sdist编译NumPy2.2.6，禁止联网解析，限定Ninja单任务并降低进程优先级；成功与否以原始构建日志和生成wheel复验为准，不以工具就绪推断构建通过。

## R15：17颗电机真实只读通信通过

## R16：完整运行依赖的 PyYAML ARM wheel 缺口

- `h23-runtime-materials.json` 保存PC对冻结ORCA依赖的CPython3.10/ARMv7官方PyPI下载命令。NumPy单独由正在运行的原生构建提供，最终安装仍要求原始完整依赖约束。
- 实际返回1，原错误：`ERROR: Could not find a version that satisfies the requirement pyyaml<7.0.0,>=6.0.2 (from versions: none)`；`ERROR: No matching distribution found for pyyaml<7.0.0,>=6.0.2`。
- 证据只证明此次指定CPython3.10/ARMv7平台和官方索引下没有匹配的二进制wheel，不能推断PyYAML源码无法构建。未修改冻结元数据，未用系统PyYAML5.4.1代替原约束。
- 影响：完整ORCA环境还需额外提供合规的PyYAML包；已完成的17颗只读通信事实不受影响。下一步核官方PyYAML6.0.2源码及其可选C扩展开关，构建标准纯Python wheel或受控原生wheel，保持官方源码原字节并正常解析安装。来源、SHA、构建入口和复验PENDING。

## R17：PC完整回归与PyYAML归档检查脚本错误

## R18：PyYAML重建、运行依赖闭包及ARM安装复验

- `h25b-pyyaml-pure-wheel.json`：新目录 `pyyaml-build-r02` 从官方6.0.2 sdist重建，完整stdout/stderr已封存，构建/后置检查返回0。实际条目为 `pyyaml-6.0.2.dist-info/WHEEL`，标准 `py3-none-any`、无SO/PYD/DLL；wheel SHA256 `39736b94bb66763f0e8641203703250c4c650f838dba28e657d0beb97d160133`。原始sdist SHA256 `d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e`，h26再次向官方PyPI JSON核对一致；R17检查脚本错误已复验闭合，首次产物保留。
- `h26-runtime-materials-recheck.json`：正常解析冻结依赖原约束（NumPy仍由h17单独构建），共19个wheel。PC3.13的跨平台下载再次遗漏目标Python<3.11的exceptiongroup，按目标3.10.4/Linux/armv7l解析各包METADATA并补齐后缺口为空；该问题在传板前查出。18个下载wheel逐个核官方PyPI SHA，另1个为上述官方源码构建PyYAML。pydantic-core已有官方cp310/ARMv7 wheel，无需安装Rust。归档 `h26-runtime-materials.zip` SHA256 `08c8487730f81cc5c9cd9141466bb2893a7a8867413ca524034129f79fd4e7b4`。
- `h27-arm-runtime-install.json`：SCP/SSH均0、同boot、归档及19包原字节核对后，仅在 `/home/xilinx/pynq-usb-hand/board-20261023-r01/venv` 正常解析安装，无 `--no-deps`。pip check返回0，板端32位进程实际导入PyYAML6.0.2（libyaml=false）、FastAPI0.161.1和pydantic-core，并成功safe_load。未改公共PYNQ环境、未开串口或触动PL。此时尚未安装ORCA/自有包，pip check不代表完整ORCA依赖已闭合。
- h27附带构建状态：h17尚未生成完成回执，NumPy进度262/438；原日志保留32位 `scalartypes.c.src:3274` 的 `warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'Py_ssize_t' {aka 'int'} [-Wformat=]`，未改上游，不能凭进度或warning判构建成功/失败。等待原构建终态，禁止重放或删除构建目录。

## R19：Skill同步与PS负载问询快照

## R20：测试就绪状态复核

## R21：NumPy构建包装器超时

## R22：NumPy续编及ARM wheel成功

- `h33-numpy-resume-ssh.json`（PC UTC 2026-10-23T03:07:03.844526+00:00）：SSH0，原28项增量ninja及随后pip wheel均返回0，累计949.425761817秒。保留首次超时材料和新两份完整日志。R21包装器超时已通过原目录续编闭合，未改上游源码或依赖版本。
- 产物 `numpy-2.2.6-cp310-cp310-linux_armv7l.whl`，6043657字节，SHA256 `dbd1fe1484ba9fafe681761330694655bc2d15430b72412befb692c6e0a59f35`；h34安装前再次核SHA一致。构建成功不替代安装、数值导入或控制回归；编译warning原日志保留。

## R23：完整安装时源码构建目录权限阻塞

## R24：完整ARM环境及57项回归通过

## R27：布、剪刀、石头逐项实物闭环通过

| 项目 | 原始回执 | 动作耗时（秒） | 完整反馈样本 | 目标写批次（含上力对齐） | 续租次数 | 最后三帧最大归一化误差（每帧相同） |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| paper（布） | h40-gesture-paper-ssh.json | 14.57570277800005 | 59 | 44 | 29 | 0.028806583786424637 |
| scissors（剪刀） | h41-gesture-scissors-ssh.json | 13.454634121000709 | 53 | 43 | 26 | 0.02489711934156365 |
| rock（石头） | h42-gesture-rock-ssh.json | 14.562638194000101 | 59 | 44 | 29 | 0.020781893004115093 |

## R29：间歇及变慢的离线时间线诊断

| 项目 | 单次完整扫描中位数（ms） | 动作期扫描累计（秒） | 扫描占动作时间 | 步进反馈间隔中位数（ms） | 对应节奏（Hz） |
| --- | ---: | ---: | ---: | ---: | ---: |
| default | 170.201 | 4.2568 | 63.31% | 239.000 | 4.1841 |
| paper | 170.207 | 9.5532 | 65.54% | 239.002 | 4.1841 |
| scissors | 170.219 | 8.5157 | 63.29% | 239.007 | 4.1840 |
| rock | 170.216 | 9.5403 | 65.51% | 239.004 | 4.1840 |

## R30：轻量控制候选实施与PC/ARM离线回归

## R31：连续READ实物兼容及同板ABBA性能通过

## R32：历史精简方案复核与定位更正

## R33：超时复用对照脚本错误及修复

- h50-timeout-readonly-abba-ssh.json原错：`TypeError: super(type, obj): obj must be an instance or subtype of type`。脚本将旧BoundedPortHandler.writePort作为unbound方法调用到新类实例，旧函数内部super绑定旧类身份，触发Python类型约束；不是SDK响应或控制实现失败。候选连接的只读预检完成，计时blocks为空，异常后端口已关闭；无寄存器写、无使能/卸力/运动。
- 影响：本次未获得CPU/时延对照，原失败回执保留。修复只针对审计脚本：旧分支按已读源码的三步调用（设置remaining超时、PortHandler.writePort、事后remaining检查）执行，不跨类调用含super的方法；严格READ包守卫保留，另存h51复验。产品代码不因此修改。

- h51复验READ_ONLY_ABBA_PASS：同一48字节反馈/17笔READ、每组10扫描；旧超时配置170/170次，新2/4次。旧CPU0.3222/0.3104秒，新0.2772/0.2782秒，均值约降12%；各组扫描中位50.646/50.710/50.693/50.695ms，未证明扫描时延改善。总697READ（含连接17笔）、0寄存器写、全OFF、关口确认；RSS22984kB、1线程。h50失败与h51成功原件均进入h56封存，错误已闭合。

## R34：精简候选四动作与资源实测

| 回执/姿态 | 旧→新耗时秒 | CPU秒/单核比例 | 反馈帧旧→新 | 下发间隔中位/最大ms | 末三帧最大归一化误差 |
|---|---|---|---|---|---|
| h52 default | 6.7236→2.4779 | 0.9093 / 36.70% | 28→17 | 59.653 / 85.162 | 7.965% |
| h53 paper | 14.5757→5.3108 | 2.0094 / 37.84% | 59→36 | 59.574 / 90.020 | 9.825% |
| h54 scissors | 13.4546→4.9196 | 1.7912 / 36.41% | 53→31 | 61.576 / 85.777 | 7.910% |
| h55 rock | 14.5626→5.4526 | 2.0388 / 37.39% | 59→39 | 59.125 / 85.835 | 9.228% |

## R35：离线两秒目标优化，禁止板端访问

## R36：responsive本地候选回归完成，实物两秒目标待验

## R39：responsive-r01独立部署及ARM离线回归

## R42：responsive短时使能及立即卸力通过

## R43：responsive首轮动作实测与2秒差额

## R44：rock完成，首轮四动作功能通过、两项性能未达

## R46：首轮封存与新写入热路径局部候选

- h76在专用根封存实际h66–h74报告/日志及候选source_manifest，共16文件加ZIP内manifest；严格SCP后整包长度41763B/SHA256 `f2d381c045e6831b4e0924c4a67fc78b8024175c726442bb19aff938f8e51b7d`、每成员长度/SHA及8组板端JSON/PC SSH stdout对象一致通过。封存时boot仍一致、候选149项SHA未漂移，串口持有者为空。PC原件`h76-responsive-first-board-evidence.zip`及`h76-responsive-first-evidence-verification.json`；保留h67失败，不将`performance_target_all_met=false/release_ready=false`改成通过。
- 本地只改自有orca_backend.py与test_orca.py：responsive已量化目标直接调用同一SDK `WritePos(id,raw,0,speed)`，避免原入口重复round/NumPy标量clip；保留完整标定范围验证、逐电机事务/ACK、设备错误、取消、缓存失效和OFF全量对齐，默认audit不变。16项OrcaTests先通过0.554秒，h77完整73项通过2.941秒、117冻结/384waypoints/6528等价目标/32协议场景/serial_open0通过；两文件编辑器诊断0。未改冻结ORCA、SDK或资产。
- h78在ARM内存中执行新旧代码ABBA，各100批/1700颗假ACK，总6800次，禁止serial.Serial.open，真实电机写0、未部署新源码。原版两轮0.933046233/0.930094467秒，新代码0.431152577/0.432646012秒，耗时比0.4636249903；所有SDK raw/时间0/速度500参数序列逐项一致。该收益只适用立即假ACK的软件调用，不含协议编码、USB、机械或完整请求，不能声称完整动作降53.6%或rock已低于2秒。
- h78候选源码SHA `ed99623aa73aa40cbc12a22daae7fb4bd2bf9f1228b9c279dae5b12aa5cc66ee`；PC回执`h78-fast-ack-arm-memory-abba-ssh.json`、板端只新增审计数据`h78-fast-ack-arm-memory-abba.json`，旧source-responsive-r01运行代码仍原149项。新候选完整ARM回归/实物尚待验证，未上调speed500、未删路径或确认帧。下一步先确认此前“speed500与PC一致”的显式约束是否允许调整，再安排独立新候选及逐项实测。

## R47：速度确认待回复与增量准备取源阻塞

## R50：可调速度候选ARM及600档短使能门禁通过

## R51：600档逐项完整请求实测

- h86/paper：600档完整请求2.173128200秒，`GESTURE_PASS`但2秒目标未达，差额0.173128200秒；阶段default1.199279875秒、paper中点0.332322972秒、paper目标0.640071205秒。起点来自此前rock终态、两轮之间卸力，不能把不同起点的旧500档paper1.746秒作为同工况提速对照。
- 运动位置ACK481笔，实际SDK包全部duration0/speed600、COMM/device_error0；末三帧最大ROM误差0.08070175/0.03508772/0.02880658。单核CPU52.8057%、RSS22916kB、2线程。显式release及close两轮均确认17OFF，最终CLOSED/error=null、port_closed=true；原始`h86-speed600-paper-ssh.json`及板端同名报告独立保存。未放宽路径、温压或到位判据，继续同600档其他两项以完成本档取证。
- h87/scissors：完整1.962139868秒，低于2秒；default0.837356042秒、scissors1.123778848秒，运动位置ACK457笔。h88/rock：完整2.660236347秒，超目标0.660236347秒；default1.179254570秒、中点0.590426307秒、目标0.889096011秒，ACK525笔。两项均全部速度编码600/时间0/COMM与设备错误0、GESTURE_PASS，显式release及close均17OFF、CLOSED/error=null、关口。
- 600档三项完整耗时2.173128200/1.962139868/2.660236347秒，布和石头性能未达；不因功能通过抹去差额、不重试筛选最快值。下一档只加100到700，继续相同路径/到位判据，原始h86–h88保留。

## R52：700档逐项完整请求实测

- h89/paper：完整2.239269363秒，性能超目标0.239269363秒；default1.190278139秒、中点0.404790424秒、目标0.642671057秒，位置ACK481笔，全部实际速度700/时间0/COMM与设备错误0。功能GESTURE_PASS，显式release及close两轮17OFF，CLOSED/error=null、关口。
- 与600档布的起点类型均为前次rock终态，但卸力后微小漂移/反馈收敛和调度仍可能不同；单次完整耗时未随编码速度上升而单调下降，不以原生速度数值推断真实加速比例。先完成本档另外两项，不改步数或三帧判据，原始h89保留。
- h90/scissors：完整1.982355646秒，default0.835953181秒、目标1.145324792秒，运动位置ACK454笔，低于2秒。h91/rock：完整2.680592064秒，超目标0.680592064秒；default1.146932909秒、中点0.614168110秒、目标0.917963715秒，ACK526笔。各项实际包均速度700/时间0/COMM与设备错误0，功能GESTURE_PASS，显式release及close两轮17OFF、CLOSED/error=null、关口。
- 本档三项2.239269363/1.982355646/2.680592064秒，布和石头未达；最低动作反馈电压4.7V、最高5.3V、温度19–24℃，均在已确认保护范围，未改阈值。单次数据尚未分离通信/机械/调度贡献，继续只加100至800，不重复同档筛选最快结果。

## R53：800档逐项完整请求实测

- h92/paper：完整2.154890982秒，超目标0.154890982秒；default1.189633413秒、中点0.343829895秒、目标0.620003169秒。运动位置ACK472笔，真实包均速度800/时间0/COMM与设备错误0，末三帧最大ROM误差0.05964912/0.02880658/0.02880658。功能GESTURE_PASS，显式release及close两轮17OFF、CLOSED/error=null、端口关闭，电压4.9–5.3V、温度19–24℃。原始h92保留，继续本档另两项。
- h93/scissors：完整1.877962213秒，default0.760856922秒、目标1.116052570秒，ACK452笔，低于2秒。h94/rock：完整2.658658740秒，超目标0.658658740秒，default1.163931180秒、中点0.599469298秒、目标0.893845783秒，ACK526笔；运动反馈电压最低4.6V、最高5.3V，温度19–24℃，既有保护范围内未改阈值。
- 两项真实包均speed800/duration0/COMM与设备错误0，GESTURE_PASS，两次卸力均确认17OFF、CLOSED/error=null、关口。800档三项2.154890982/1.877962213/2.658658740秒，布和石头未达；600–800档石头完整时间约2.66–2.68秒，已呈速度编码上调收益有限，仍按计划只加100到900，首轮到1000即停止并分析，不继续无界提速。

## R54：900档逐项完整请求实测

- h95/paper：完整2.161862606秒，超目标0.161862606秒，default1.186544958秒、中点0.356822529秒、目标0.616730227秒，运动位置ACK472笔。真实包均speed900/duration0/COMM与设备错误0，最后三帧ROM误差0.08070175/0.03157895/0.02880658。GESTURE_PASS，两次卸力均17OFF、CLOSED/error=null、关口；电压4.9–5.3V、温度19–24℃。较800档布未见明显完整耗时改善，保留原始h95，先完成本档另两项，不改变判据或挑最快重试。
- h96/scissors：完整1.907569228秒，default0.776667599秒、目标1.129854700秒，运动ACK456笔，低于2秒。h97/rock：完整2.592861178秒，超目标0.592861178秒，default1.153814442秒、中点0.533411193秒、目标0.903951832秒，ACK526笔。两项真实包均speed900/duration0/COMM与设备错误0，GESTURE_PASS，显式release与close各确认17OFF、CLOSED/error=null、关口；电压4.6–5.3V、温度19–24℃。
- 900档完整三项2.161862606/1.907569228/2.592861178秒，布和石头未达。石头相对800档缩短约0.066秒，仍缺0.593秒；单次对比不作稳态加速承诺。保留h96/h97，下一档1000完成后即停止提速封存，不越过既定首轮上限。

## R55：1000档逐项完整请求实测

## R56：分档证据封存与安全退出

- h101只读封存既有板端h83–h100报告、日志、增量ZIP及source-speed-r01清单/3项源附件，共29项原件；未开串口、无新增电机写或运动。当前boot仍2817d7c9-de8a-4015-911d-99e2b53d685f，封存时149项候选SHA全符、串口持有者为空；不停止或干预Codex/视觉进程、公共环境或PL。
- 板端及PC原字节包`h101-speed-board-evidence.zip`：189098字节，SHA256 `3df688b7a0b8f70b886a4f0b00932788af67fc5efdca0ba76a90ea37ce6477b8`。沿用源地址192.168.2.1及严格主机校验SCP，返回0；PC回执`h101-speed-evidence-seal-ssh.json`、`h101-speed-evidence-scp.json`和`h101-speed-evidence-verification.json`位于子项目build/board-20261023，均独占新建，不覆盖旧证据。
- PC结构化复算：整包及29成员长度/SHA通过、18组板端JSON与PC SSH stdout对象相等；15完整请求/40阶段的末3个不同新鲜帧，按冻结真实姿态/ROM以及实际default末帧构造的中点逐一重算，误差均≤0.10。全部真实WritePos速度为选定600/700/800/900/1000、duration0、COMM及设备错误0；30次卸力均17颗确认，共510颗次OFF读回，最终各项CLOSED/error=null/端口关闭。PC当前后端及测试SHA与封存候选一致。
- 独立复算结果`EVIDENCE_PASS_PERFORMANCE_TARGET_NOT_MET`：15项功能PASS，5项剪刀低于2秒、10项布/石头性能未达。完整三手势实测秒数如下，不混入不同起点的旧500档作为同工况基线：

| 速度 | default→paper | default→scissors | default→rock |
|---|---:|---:|---:|
| 600 | 2.173128200 | 1.962139868 | 2.660236347 |
| 700 | 2.239269363 | 1.982355646 | 2.680592064 |
| 800 | 2.154890982 | 1.877962213 | 2.658658740 |
| 900 | 2.161862606 | 1.907569228 | 2.592861178 |
| 1000 | 2.258204046 | 1.936687093 | 2.589634052 |

## R57：文档验收脚本编码错误与复验

```text
Traceback (most recent call last):
	File "<stdin>", line 12, in <module>
AssertionError
Command exited with code 1
```

## R59：独立子项目的编辑器导入路径告警

## R60：增量准备的旧ZIP附件前缀错误

- h105真实只读核验成功：仍boot2817d7c9-de8a-4015-911d-99e2b53d685f、ARMv7/Python3.10.4、原149项SHA完整、串口无人持有，未开串口、无电机写。随后h106增量准备首次在PC来源核验阶段退出1：

```text
File "<stdin>", line 14, in <module>
KeyError: "There is no item named 'evidence/offline-verification.json' in the archive"
Command exited with code 1
```

## R61：固定500优化候选独立ARM门禁

- h106从source-speed-r01派生新source-efficient500-r01，只替换orca_backend.py、motion.py、两个邻近测试文件和README五项，原候选/冻结文件/依赖不改。部署前boot与h105一致、串口无人持有，149项基线全SHA核验，候选前后149项SHA全符；manifest标注speed500/release_ready=false。
- 依赖pip check、冻结校验、真实候选CLI help、完整离线门禁四步均返回0；ARM Python3.10.4下79项、errors=failures=0、117冻结、384waypoints及32真实SDK内存场景通过，所有模拟位置包speed500。全程serial_open=0、真实电机写0，无依赖安装、无服务/PL/公共环境或Codex变更。
- h106-efficient500-arm-deployment.json、h106-efficient500-arm-offline.json、四步原日志及自动生成的离线.log保存在板端独立根；PC完整SSH脚本/回执h106-efficient500-arm-offline-ssh.json与SCP回执保留。下一步仅先做ARM软件同输入ABBA，再按原保护复验固定500完整手势，不能将离线PASS写成实物提速通过。

## R62：ARM同输入双向转换ABBA

- h107真实ARM Python3.10.4，旧source-speed-r01模型与新source-efficient500-r01模型使用同一冻结资产和输入，初始化及全程patch禁止serial.Serial.open。每轮先核逐值完全相同，17颗映射与149项候选SHA完整，speed500；无真实串口或电机写。
- 前向336输入/每轮1344次：旧2.297954895/2.306891793秒，新0.395254689/0.383378067秒，新旧合计比0.169089833。反向101输入/每轮404次：旧0.444159396/0.443099778秒，新0.039686972/0.039945249秒，比0.089750800。ABBA两对保留，不筛最小值；CPU秒与墙钟接近，仅说明对应转换函数软件开销下降，不外推完整动作降幅。
- 板端h107-efficient500-arm-abba.json及PC同stem的-ssh.json含原脚本、输入范围、各轮耗时、源码SHA和零串口证据。下一步按已确认40℃/age2/lease5/每0.5秒续租/45秒预算，先全手只读及speed500短使能卸力，再完整三手势各一次；旧speed500起点不同的首轮数字不作为严格同工况收益基线。

## R63：固定500候选只读及短使能门禁

## R64：固定500完整三手势逐项实测

- h110/paper：完整submit→最终reached2.014631043秒，性能超目标0.014631043秒；default1.113817530秒、中点0.305553668秒、目标0.593765451秒，运动位置ACK504笔，真实包全部speed500/duration0/COMM0/device_error0。末三帧ROM误差0.09122807/0.04912281/0.02807018，GESTURE_PASS，显式release及close两轮17OFF、CLOSED/error=null、关口。动作含审计单核CPU54.2813%、RSS22844kB、2线程；电压4.8–5.2V、温度19–24℃。
- h110首次终端只回显脚本定义、未内联显示动作输出，不能凭回显判PASS或原样重发。随后只读Test-Path确认原h110回执已存在、脚本变量完整；仅PC解析原returncode=0及板端JSON，恢复上述功能/真实速度/两轮OFF证据，没有新增SSH、没有重试运动。属于输出可见性问题，真实执行和安全终态由原件核实，非手势失败或RELEASE_UNKNOWN。
- 布仍差约15ms，保留未达原值，不同档/不同起点旧数字不计算严格收益；先完成同候选500档另两项，保护和完整计时范围保持。
- h111/scissors：完整1.738765185秒，default0.677672996秒、目标1.059940983秒，运动位置ACK451笔，低于2秒。h112/rock：完整2.650706882秒，超目标0.650706882秒；default1.073922965秒、中点0.599239058秒、目标0.975987051秒，ACK527笔。各实际包均speed500/duration0/COMM0/device_error0，功能GESTURE_PASS，各显式release及close均确认17OFF，最终CLOSED/error=null、关口。
- 三项动作含审计单核CPU54.2813%–54.4803%、RSS22844–22948kB、2线程，电压4.8–5.3V、温度19–24℃。正反映射计算已证等价且局部开销下降，但各一次不同起点的实物数字不能直接换算总体收益；当前布和石头性能仍未达，不宣称全部两秒。最后h112后17OFF/端口关闭/动作SSH进程退出，接下来只拆解原回执，不重试筛最快值、不改保护或升速。

## R65：既有500回执分阶段占时分析

## R67：本地交接验证及终端短入口恢复

- 本地终端两次长入口（here-string定义紧接管道）仅回显脚本定义并返回提示符，没有Python输出、PASS或可核退出结果，原回显保留，初次结果均记UNKNOWN；未据此宣告验证完成。证据表明该终端入口没有可靠给出尾部执行回执，未发现Python异常；不将其归为源代码或板端故障，具体终端内部原因未推断。
- 分别改用短命令调用同一个已定义的纯本地脚本后，取得`HANDOFF_MOCK_PASS requests=3 torque_off=true closed=true`及`HANDOFF_EXAMPLE_VALIDATED board_access=false serial_opened=false`；JSON结构核查取得`LOCAL_EVIDENCE_STRUCTURE_PASS board_access=false`，确认h104字段、h106的149项候选清单及三手势原件均可解析。过程中仅Mock及PC磁盘读取，无板卡访问或真实动作重试。
- 本次四份Markdown编辑器检查均无错误。交接页示例验证三请求reached、实际状态匹配、调用者0.5秒续租、有限预算及Mock卸力关口；不将Mock结果用于替代新的实物门禁。最终原件一致性/SHA和链接结果封存在本地h114-handoff-local-verification.json；此h114编号是纯本地文档验证，非R65已取消的板端READ剖析。

## R68：本地交接校验的计数字段类型修复

## R69：低CPU接入本地评估，保持Codex及板端不动

## R70：本地READ语法校验器修复，不修改运行代码

## R72：h116离线通过后的静态类型与SDK覆盖遗漏修复

## R73：三步离线实现闭合，h117完整门禁通过

## R76：正常重启请求成功，首次SSH重连超时

- h124-authorized-normal-reboot-ssh.json记录先核旧boot及PID999完整命令，再仅发送一次SIGTERM；正常systemctl reboot返回0、SSH返回0，未用force。板端h124-authorized-normal-reboot.json在操作前flush/fsync保存原身份。
- h125-buttons-post-reboot-ssh.json首次重连返回255，原文`ssh: connect to host 192.168.2.99 port 22: Connection timed out`；远端脚本未执行，尚未得到新boot、启动服务或BTN读值。发生在正常重启后首次连接，启动窗口为候选解释，当前不推断内核/PL/网络根因。影响为板前检延后；不重复发重启、不套地址、不把空stdout当通过，先完成PC闭环检查后再独立只读重连留新回执。当前没有灵巧手串口打开或使能。
- h126真实Controller线程加MockBackend四态闭环通过，request_id为1/2/3/4，四次reached、OFF和最终CLOSED/error=null，真实串口0。h127第二次SSH返回0，新boot为f56e80d1-0222-4c57-8308-162e279eb32f，无硬件mapper；官方base HWH明确btns_gpio/C_BASEADDR=0x41210000/C_GPIO_WIDTH=4/C_ALL_INPUTS=1，输入网络连接外部btns_4bits_tri_i。bootpy当时仍activating/MainPID232，门禁继续阻止MMIO或手动加载；不把SSH恢复当启动完成。首连超时已由自然启动后只读重连恢复，无第二次重启。

## R77：官方base就绪，只读通过，审计器速度字节序误拒绝

## R80：四物理键首尾模式通过，动作CPU仍约半核

| 按键/状态 | accepted至reached秒 | CPU秒 | 单核占比 | 位置写尝试 | 反馈READ尝试 |
| --- | ---: | ---: | ---: | ---: | ---: |
| BTN0/default | 1.0761 | 0.6346 | 58.97% | 311 | 119 |
| BTN1/paper | 1.3879 | 0.7103 | 51.18% | 222 | 204 |
| BTN2/scissors | 1.5931 | 0.8942 | 56.13% | 457 | 170 |
| BTN3/rock | 2.5432 | 1.4211 | 55.88% | 523 | 425 |

- h143纯本地复算：按采集器motion段合计wall=6.600283166秒、CPU=3.654565627秒、55.369830886%单核；arm段0.748051753秒/55.9885%；hold_release段8.348834240秒/5.6073%；idle_off段51.310117996秒、CPU=0.544696345秒、1.061576871%。CPU为整个进程process_time/monotonic wall，单核100%，含按键源、worker、审计/打印；事件表CPU与分段CPU起止读取顺序略异，按各自原口径保存，不强行抹平差异。
- 卸力等待无周期健康串口读取。Counter快照与worker非原子同步，段边界有1笔arm/motion READ前移，不能把idle段边界的arm包当作空闲轮询；每请求表也只是accepted/reached快照差。Counter统计尝试数，成功还由SDK/反馈/状态独立证明。全程motion反馈READ1054笔，其中请求窗口918笔，持力健康读取136笔；位置写1513笔，另有arm当前位置对齐68笔。保持原插值，未放开真实stage_targets/SyncWrite，未宣称这些包计数直接证明CPU瓶颈或优化比例。
- 末端各状态最后3个不同sequence的ROM最大误差均<=0.10，h143再次独立断言；全采样温度最高25摄氏度、电压4.8至5.3V。峰值RSS23248KB；仅本次短时观测，不等同长期资源门禁。
- h141自动在四态完成、最后卸力且额外3秒OFF等待后结束。四次动作各17OFF加finally显式release和close各17OFF，共六轮、102笔OFF写/102笔回读，全部failed_ids=[]；最终CLOSED/error=null/enable_epoch=null/port_closed=true/cleanup_confirmed=true。h142独立只读确认serial_owners=[]、active_button_processes=[]，当前无驻留测试或续租源。
- h142按原字节base64/SHA回收h141报告及调用等5份原件，h143逐项核长度/SHA与安全/末端判据，FOUR_BUTTONS_ANALYSIS_PASS。h141报告SHA256为85c2d4cd437dfd8300bf15a253406f8e6ffda92bfef72838a56be2f8820b1e8a；h142回执SHA256为eb50d512b8707090246cb7ccea71c92c464143dd6e5612f7ec3bda85ff0e615d。h143-buttons-cpu-analysis.json保留完整分项与原件索引，旧失败/暂停原件不覆盖。
- 结论：本次四物理键触发与首尾模式动作、CPU分项及安全收尾通过；每态仅一次、起点各异，未与历史约54%单核做同起点/同配置ABBA，故不计算或宣称CPU收益。当前动作CPU仍约半核，后续真实减写、原生轨迹/碰撞与故障矩阵/长期门禁仍独立待验，release_ready=false。测试已结束，不自动重启或恢复游戏。

## R82：三项省交互完整门禁、独立部署与四键实物闭合

## R83：逐项精简非必要CPU工作，PC候选与夹具首错

## R85：新版隔离部署，首次ARM门禁失败待定位

- h156独占新包148项源码，SHA256=e53a72e472e816c7fbcf0c76dc22bcd457afe859af17d45eda1bb31b12640238。h157-lean-destination-check确认新目标未占用，SCP返回0；板端ZIP与148源码SHA/Python3.10 AST检查、pip check通过，新目录为/home/xilinx/pynq-usb-hand/board-20261023-r01/source-lean-r01。未停止r20、重启、下载PL或打开真实舵机串口。
- 首次ARM离线回归失败，原文“File <stdin>, line 23 ... AssertionError: ('offline', 'Runtime port override ... unittest ...')”“AssertionError: h157-lean-arm-deployment”，SSH_RETURN=1；原件h157-lean-arm-deployment-ssh.json包含完整脚本/stdout/stderr，板端h157-offline.log及验证器同名原日志保留。工具长行展示截断，当前只确认offline非零，具体失败用例和根因待提取；不根据长行省略猜测SDK或硬件故障。
- 进度影响：上传/解压完成，ARM门禁未过，禁止称部署验收通过；立即只读提取失败明细后决定局部修复。失败目录/日志不覆盖，物理测试仍受R84现有硬件任务与离场门禁阻止。
- 结构化展开原SSH stderr获得完整失败：Ran119 tests in41.814s / FAILED(errors=1)，仅test_missing_ack_waits_instead_of_spinning(test_orca.BoundedCodecTests)在transport.py readPort -> _remaining抛“TimeoutError: Serial transaction deadline exceeded”；用例通过loop://实际阻塞等待缺ACK，其他118项包括原SDK同一用例通过。证据支持100ms事务保护命中，当前r20并发+nice19的调度延迟为待验证假设，不据此宣称生产解析器错误或确定根因；不放宽100ms/取消/健康期限。

## R87：新版轻量四键实物通过，原件回收与CPU分析

## R88：峰值主要耗时只读诊断

## R89：一次自检、持续使能与固定动作播放的设计梳理

## R90：固定播放实现与PC离线门禁
