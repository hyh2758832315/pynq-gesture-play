# OV5640 与 PYNQ-Z2 安全接入方案

当前状态（2026-10-02）：`DIRECT-PLUG-PROTOTYPE-PC-10MIN-PASS / HDMI-VISUAL-PENDING / ELECTRICAL-FINAL-PENDING`。正确直插针位的独立相机原型已读取 OV5640 ID `0x5640`，输出 1280x720 实际镜头画面，经隔离帧缓冲同时提交 HDMI 并向 PC/Studio 提供 MJPEG。受监护 690 秒长测中 PC 四次连接解码 4777 帧、黑帧 0、每段帧哈希不同，成功到达率约 7.93..7.98 fps，退出后 MM2S/S2MM 均 Halted；这不是传感器原始帧率或 HDMI 实屏目视验收。当前直插版仍是独立实验 Overlay，与 C6I 游戏 Overlay 互斥，原理图所示 2.8 V IO 域的 XCLK/SCCB 3.3 V 接口还需长期电气适配。30 分钟与 HDMI 实屏持续动态、视觉算法接入留给后续阶段；操作和完整证据以 `docs/bringup/2026-10-01_pynq-z2_camera_direct_plug.md` 末尾轮次为准。

2026-10-01 用户重新核对实物并纠正两排方向；以本页最新24针表为准，撤销此前照片/PDF方向换算的直插接线指导。`direct/D1` 和 `remap/D2` 是此前实验布局，冻结 Camera v4 与旧直插 bit 均不适配最新实物直插。以下 2026-10-01 的“仅 ID/离线验证/无镜头帧”段落保留为当时阶段证据，不代表当前原型状态；后续禁止依据历史段落加载旧 bit 或复接旧线。用户已反复确认 GND/3V3 对位，后续不使用万用表或接触式探测。

## 团队交接：相机链路与视觉算法边界

再次上电后的交接使用顺序：先检查温度/供电与电平接口，再 `ssh pynq-z2 'systemctl show vvg-camera-preview.service -p ActiveState -p SubState; ss -ltn'` 核对服务与 8088；只有现场明确重新启动受监护相机实验服务并确认 8088 监听后，才能在浏览器打开上述 URL，或先关闭浏览器页再在 Studio Vision 页连接相同 URL。板端日志用 `ssh pynq-z2 'sudo -n journalctl -u vvg-camera-preview.service -n 40 --no-pager -o cat'` 读取。停止直播须执行 `ssh pynq-z2 'sudo -n systemctl stop vvg-camera-preview.service'`，检查监听退出和双路 VDMA Halted；重新运行或更换 bit 前先确认 C6I Shell 与摄像头服务均未占用 PL，并沿用上板记录中的守护启动方式。临时 systemd unit 的完整命令和观察到的运行状态见上板记录末尾；网页连接仍在时不要启动第二个 MJPEG 客户端。

交给视觉算法同事的输入当前是解码后的 1280x720 RGB 镜头画面，MJPEG 为有损传输；板端 CPU 快照是隔离显示帧后的副本，不等于 OV5640 Bayer 原始采样。算法验证先明确需要 RGB 预览还是传感器 RAW、时间戳与实际帧率口径、延迟/同步和多客户端吞吐目标，再在独立消费者中接入，不改变当前 HDMI/VDMA 所有权。现有约 8 fps 是单客户端 PC 完整解码到达率，未测得传感器新帧率；处理泵无客户端时约 24.1 次/秒也不是光学新帧率。后续验收还包括 HDMI 实屏连续画面、30 分钟运行、推荐工作范围内的 XCLK/SCCB 2.8 V 接口适配，以及与 C6I 的 Overlay 共存/切换方案；这些完成前沿用独立实验原型和当前实物针位，不将旧 bit 当作正式产品包。

旧 Camera v2/v3/v4 按真实镜头出图目标归档为失败尝试：局部芯片 ID、彩条信号和构建通过均未转化为完整帧/PGM。保留旧产物及原始上板日志供审计；此前整排直插时，隔离诊断 bit 在板端用 ILA 捕获首笔写入：SCL 发出 100 kHz 时钟和 `0x78` 写地址，第九拍 SDA 高电平，传感器在地址阶段 NACK，后续寄存器字节尚未发送。五线 GPIO 复验结果如下，真实镜头帧尚未取得。详见 `docs/bringup/2026-10-01_pynq-z2_camera_direct_plug.md`。

## 当前直插：用户修正后的完整针表

这里的1–12为用户核对的实际 PMODA/PMODB 位置，逐位对应 JA/JB；不再沿用此前对 PDF J2/J3 两排方向的推断。

| 位置 | PMODA / JA 信号 | FPGA pin | PMODB / JB 信号 | FPGA pin |
| --- | --- | --- | --- | --- |
| 1 | NC | Y18 | D7 | W14 |
| 2 | PCLK | Y19 | D5 | Y14 |
| 3 | HREF | Y16 | D3 | T11 |
| 4 | SCL | Y17 | D1 | T10 |
| 5 | GND | 固定地 | GND | 固定地 |
| 6 | 3V3 | 固定电源 | 3V3 | 固定电源 |
| 7 | NC | U18 | D6 | V16 |
| 8 | XCLK | U19 | D4 | W16 |
| 9 | VSYNC | W18 | D2 | V12 |
| 10 | SDA | W19 | D0 | W13 |
| 11 | GND | 固定地 | GND | 固定地 |
| 12 | 3V3 | 固定电源 | 3V3 | 固定电源 |

最小 ID 包使用 `corrected` 布局、BUILD_ID=`0xC00A00D3`：XCLK=JA-8/U19、SCL=JA-4/Y17、SDA=JA-10/W19。其余 DVP 不接入该最小工程，只读芯片 ID，不初始化或采帧。若用五线而非整排直插，另接 JA-6/3V3、JA-5/GND，总共仍为五根；改线须断电，按对应信号接到相机，禁止将此前错误的相机编号当作当前接点。

此前工程将 XCLK=JA-2/Y19，按新实物表该位置是相机 PCLK 输出；SCL=W19/SDA=Y17 与相机 SDA/SCL 相反。这是明确的约束与实物映射不一致；正确映射包读回0x5640，支持该映射错误是此前首地址NACK的主因。

## 当前结果与完整回传构建

正确最小包 `camera_id_gpio_corrected.bit/.hwh` 已通过实际IO/上拉、DRC无Error、WNS+3.886ns、WHS+0.046ns并部署至板端 `/home/xilinx/voice-view-game/camera-id-gpio-corrected/`；一次load-only通过。随后不重新下载，核对FCLK0=100MHz、BUILD_ID=0xC00A00D3、控制0、采样3后，单次严格ACK读回 `0x300A=0x56`、`0x300B=0x40`、ID=0x5640；退出码0，清理控制0。未初始化传感器或取得镜头帧。

当前ID复验入口（须已加载匹配的正确包）：在上述板端目录执行 `sudo -n timeout 20s env XILINX_XRT=/usr /usr/local/share/pynq-venv/bin/python -u verify_camera_id_gpio_direct.py camera_id_gpio_corrected.bit --no-download --pin-layout corrected`。实际本轮load和ID原始日志分别为 `board/pynq_z2/build/camera_id_gpio_corrected/load_20261001_214011.log`、`id_20261001_214100.log`，哈希及完整证据见上板记录第43轮。

完整回传采用独立 `CAMERA_CORRECTED_PINS=1` profile，工程名 `camera_direct_plug_corrected`，使用 `board/pynq_z2/constraints/camera_direct_plug_corrected.xdc`，修正全部14个信号。复用现有 DVP -> AXI4-Stream -> demosaic -> VDMA S2MM -> HP0/DDR 的链路；维持原PCLK 10ns、输入延迟0–4ns建模，实际传感器视频时序另行验收。36项定向回归、BD、demosaic独立综合和顶层综合已通过；完整逻辑的非专用PCLK离线放置/路由完成，实际14针与DRC/建立保持检查通过，WNS+0.544ns、WHS+0.050ns。尚无完整工程新bit或镜头帧验收。

构建入口均须设置 `CAMERA_CORRECTED_PINS=1`：`scripts/build_camera_direct_plug.tcl` 综合/放置，`scripts/report_camera_direct_plug_placed.tcl` 配合 `CAMERA_ROUTE_PROBE=1` 从placed DCP路由，`scripts/package_camera_direct_plug.tcl` 核验14针、DRC Error和setup/hold后打包至独立输出目录。常规时钟放置实际报Place30-574；器件查询Y19=`IO_L17N_T2_34`、IS_CLK_CAPABLE=0。离线评估采用显式 `CAMERA_PLACE_PROBE=1 CAMERA_ROUTE_PROBE=1`，从optimized DCP使用已有 `CLOCK_DEDICATED_ROUTE FALSE` 探测约束，保留PLCK-12告警，仅输出检查点/报告。包检查必须用 `CAMERA_PACKAGE_CHECK_ONLY=1`，结果=`OFFLINE_MODEL_ONLY`；打包器已实测拒绝从该离线检查点生成bit/HWH。原始旧工程及产物保留，板端暂维持ID包的总线释放/XCLK关闭末态。

首次长目录综合在demosaic HLS必需RTL导入时报IP_Flow19-1670；文件实际存在但路径长260字符。保留失败工程证据，三阶段入口同时设置 `CAMERA_BUILD_ROOT=E:/vvgc` 使用独立短目录；相同逻辑/IP/针表的HLS导入和完整逻辑综合随后通过。正式视频包下一步需选择适配普通PCLK输入的结构或单独授权调整PCLK接线；本轮未修改实物接线、未下载离线视频包或取得镜头帧。详细错误、查询、路由和打包保护证据见上板记录第44轮。

## 历史结果：五线 GPIO 芯片 ID

2026-10-01，用户改为仅五线并重新上电；独立 `camera_id_gpio_direct.bit/.hwh`、BUILD_ID=`0xC00A00D1`，严格 ACK 读取首次加三次重复均为 `0x300A=0x56`、`0x300B=0x40`，合计 4/4 返回 `0x5640`，0 次 NACK，每次清理控制为0。FCLK0 读回 100 MHz，复用 RTL 除8，XCLK 预期12.5 MHz；软件请求半周期50 us，不宣称实测 SCCB 线速。

| 功能 | 当时已加载 GPIO 包的 PYNQ 端 |
| --- | --- |
| 3V3 | JA-6 |
| GND | JA-5 |
| XCLK | JA-2 / Y19 |
| SDA | JA-4 / Y17 |
| SCL | JA-10 / W19 |

当时记录为五线、PMODB 和其余信号断开。4/4 成功及 GPIO 的 FPGA 针位是日志事实；此前对相机端 PMODA-2/XCLK、PMODA-4/SDA、PMODA-10/SCL 的编号解释已被用户新表撤销，无法从成功日志反推当时相机端实际针位。保留日志供追溯，不据此重新指导当前实物接线。

历史读取命令：在板端 `/home/xilinx/voice-view-game/camera-id-gpio-direct/` 运行 `sudo -n timeout 20s env XILINX_XRT=/usr /usr/local/share/pynq-venv/bin/python -u verify_camera_id_gpio_direct.py camera_id_gpio_direct.bit --no-download`。此命令及旧包仅供历史追溯，不在最新实物直插上执行。该轮末态为 SCCB 释放、XCLK 关闭，摄像头供电未由软件切断。

本结果确认五线 GPIO ID 通信，未验收视频或 AXI IIC。相对整排直插失败时，物理连接与重新上电同时变化，具体额外信号/电源连接或冷启动作用仍待单变量对照；不将 ID 通过解释为所有功能及电气条件已验证。详细命令、产物哈希和原始日志见上板记录第41轮。

## 原理图复核与历史方向纠正

`PMOD扩展板/pmod-camera-v1.0.pdf` 第 1 页的 J2/J3 符号和可选中文本经放大交叉核对，均为每列左右两针的排列：J2 左列从上到下为 12..7，右列为 1..6；J3 相同。照片上的板名和信号丝印与此 PDF 的 PMOD-CAMERA v1.0 相符，但缺少实物反面的铜线/针 1 照片，PDF 与手头实物完全同修订仍需确认。

| 相机连接器 | 同列信号，从远离电源端向电源端 | 电源列 |
| --- | --- | --- |
| J2 / PMODA | `1/12=NC/NC`，`2/11=XMCLK/PCLK`，`3/10=VSYNC/HREF`，`4/9=SDA/SCL` | `5/8=GND/GND`，`6/7=3V3/3V3` |
| J3 / PMODB | `1/12=D6/D7`，`2/11=D4/D5`，`3/10=D2/D3`，`4/9=D0/D1` | `5/8=GND/GND`，`6/7=3V3/3V3` |

此前按照片推断的 PDF J2/J3 到 Pmod 换算混淆了两排方向，已撤销其接线指导；PDF 原始网名与实物 Pmod 位置是两套编号。当前使用用户最新实物表，不再据旧方向判断 PCLK 处于 U19。

**时钟范围：**旧 Camera v4 的 PCLK=U19/N侧 DRC 问题是旧线束/旧约束的历史事实。最新实物 PCLK=JA-2/Y19、XCLK=JA-8/U19；U19 在最小 ID 工程中仅作输出，旧单端时钟输入 DRC 不适用于该输出。ID和完整逻辑综合已通过；Y19经实际查询为普通IO，完整回传的专用时钟放置失败、非专用离线路由模型通过，实际视频时钟方案与镜头帧仍待验收。

**电平与启动阻断：**PDF 显示 3V3 经 U1/U2 生成相机 2.8 V IO 与 1.5 V 内核电源，没有板载 XCLK 电平转换或 SCCB 2.8 V 上拉；冻结 XDC 的 `camera_xclk` 是 3.3 V 主动输出，SDA/SCL 使用 FPGA 内部 3.3 V 弱上拉。按本文引用的 OV5640 推荐输入上限 3.0 V，这些配置不能直接用于持续直插运行。PDF 显示 R6（10 kohm）将 CAM_RESET 上拉至 DOVDD_2V8，R7（10 kohm）将 CAM_PWDN 下拉至 DGND；两脚均未接到 J2/J3。上游 BD 的 vid_rst=1、vid_pwd=0 与这一板载偏置一致，缺少这两个直插端口本身不构成已证实的启动故障。无接触验证只能结合现有照片、板级资料和历史日志；资料不足时保留阻断状态。旧版本 bit 和上游项目 bit 均不得加载到当前插装。

历史 AXI IIC 诊断约束曾移除内部上拉，但其对应针位有误，ILA 数字高电平不能证明相机端 SCCB 正确。GPIO ID 对照复用开漏与内部上拉条件，用户已接受临时实验风险；记录不等同于长期电气合规。后续接口适配的 XCLK 线路按最新表为 JA-8/U19，SCL=JA-4/Y17、SDA=JA-10/W19；相机 DOVDD_2V8 未引到 J2/J3，具体电平适配仍按板级原理图设计。

下文 J2/J3 的旧针号、外接线和板端操作步骤仅用于追溯历史试验；当前直插以页首用户修正针表与新布局的阶段验收为准。

## 停用历史方案：原结论与交叉接线

以下直至文末均为原杜邦线试验记录。原文把 J2 1/12 的空针误标成 XMCLK/PCLK，并据此推导出“直插电源与信号冲突”；2023-07-04 的 PMOD-CAMERA v1.0 PDF 原图实际把 J2 5/8、6/7 分别接到 GND、3V3。下列针表、杜邦线步骤和板端操作不用于当前装配，不得据此重新接线、上电或加载 Overlay。

`PMOD扩展板/pmod-camera-v1.0.pdf` 中的 J2/J3 使用 2x6 外形，但针脚定义不是 Digilent 标准 Pmod 排列。J2-12/J2-11 分别为 `DVP_PCLK`/`DVP_HREF`，J3-12/J3-11 分别为 `D7`/`D5`；PYNQ-Z2 标准 Pmod 的 12/11 位是 3.3 V/GND。直插或 1:1 排线会造成电源与相机输出冲突。

正式接入采用以下边界：

- 相机板与 PYNQ-Z2 之间使用逐根交叉线，不使用直插或 1:1 排线。
- 相机板由外部 3.3 V 限流电源单点供电，PYNQ 的 JA/JB 3.3 V 位保持悬空。
- 相机板与 PYNQ 共地；每组高速信号旁保留地回流。
- DVP 输出直接进入 PYNQ；XCLK 做 3.3 V 到 2.8 V 单向转换；SCCB 使用 2.8 V 上拉的开漏接口。
- DVP 输入先在独立 Camera Overlay 验收，再评估与冻结 C6I 合并。

只有模块和杜邦线时，可采用本文“杜邦线临时模式”完成短时读 ID 与首帧验证。该模式将 3.3 V 控制信号直接送入 2.8 V IO 域：OV5640 表 8-1 的绝对最大输入为 `VDD-IO+1 V=3.8 V`，所以 3.3 V 未越过损坏边界；表 8-3 的推荐工作上限为 `3.0 V`，所以该模式不用于长期运行或最终装载。

## 原理图事实

相机扩展板含两路 LDO：

| 位号/器件 | 输出轨 | 用途 |
| --- | --- | --- |
| `U1 / ME6211C28M5G-N` | `VDD_2V8` | 经 R1/R2 分配到 OV5640 模拟与数字 IO |
| `U2 / ME6211C15M5G-N` | `VDD_1V5` | 经 R3 分配到 OV5640 内核 |

电源网络为：

- `3V3 -> U1 pin 5 -> VDD_2V8`
- `VDD_2V8 -> R1(0 ohm) -> AVDD_2V8`
- `VDD_2V8 -> R2(0 ohm) -> DOVDD_2V8`
- `3V3 -> U2 pin 5 -> VDD_1V5`
- `VDD_1V5 -> R3(0 ohm) -> DVDD_1V5`

ME6211 Ver07 数据表给出的工作输入范围为 `2.0~6.0 V`；`ME6211C28` 在 `VIN=VOUT+1 V` 条件下额定最大输出电流为 `450 mA`。本板从 3.3 V 生成 2.8 V，实际压差余量小于该额定测试条件，因此最终电流能力以板端电压和输入电流实测为准。

J2 原理图针脚：

| J2 针脚 | 网络 | 方向（相对相机） |
| --- | --- | --- |
| 1 | `XMCLK` | 输入 |
| 2 | `DVP_VSYNC` | 输出 |
| 3 | `I2C_SDA` | 双向开漏 |
| 4 | NC | - |
| 5 | GND | 电源 |
| 6 | 3V3 | 电源输入 |
| 7 | 3V3 | 电源输入，同一网络 |
| 8 | GND | 电源 |
| 9 | NC | - |
| 10 | `I2C_SCL` | 输入，主控开漏时钟 |
| 11 | `DVP_HREF` | 输出 |
| 12 | `DVP_PCLK` | 输出 |

J3 原理图针脚：

| J3 针脚 | 网络 | J3 针脚 | 网络 |
| --- | --- | --- | --- |
| 1 | `D6` | 12 | `D7` |
| 2 | `D4` | 11 | `D5` |
| 3 | `D2` | 10 | `D3` |
| 4 | `D0` | 9 | `D1` |
| 5 | GND | 8 | GND |
| 6 | 3V3 | 7 | 3V3 |

J2/J3 的 3V3 均属于同一板级输入网，供电只使用其中一个针脚。

OV5640 Product Specification v2.03 表 8-3 给出 `VDD-IO` 工作范围 `1.71~3.0 V`。本板 `DOVDD_2V8` 决定 DVP 输出约为 2.8 V；Zynq-7000 DS187 表 9 给出 `LVCMOS33 VIH(min)=2.0 V`，因此 DVP 数据与同步信号可直接进入 PYNQ 3.3 V SelectIO Bank。

## 杜邦线临时模式

该模式无需电平转换模块和外部电源，只使用 PYNQ-Z2、相机板和逐根杜邦线。PYNQ-Z2 R12 原理图显示 JA/JB 电源脚连接全板共享的 `VCC3V3`；3.3 V 调节器额定 1.6 A，该数值不是 Pmod 独享额度。测试时优先使用 DC 圆口给 PYNQ 供电，并停止其他 Pmod/Arduino 外设。

### 电源

| PYNQ-Z2 | 相机板 | 说明 |
| --- | --- | --- |
| JA-6（3.3 V） | J2-6（3V3） | 唯一 3.3 V 连接 |
| JA-5（GND） | J2-5（GND） | 公共地 |

`JA-12`、`JB-6`、`JB-12` 与相机其余 3V3 脚均不连接。外部 3.3 V 电源不得同时接入。

相机板的 J2-6、J2-7、J3-6、J3-7 已在板内并到同一 `3V3` 网络，只接 J2-6 即可完成供电；增加 3V3 杜邦线不会生成新的电源轨，也不作为当前方案的一部分。J2-5、J2-8、J3-5、J3-8 同属 GND：仅接 J2-5 足以完成供电、XCLK 和 SCCB 芯片 ID 验证；接入 PCLK/VSYNC/HREF 和 D0-D7 前，应在断电状态补接 `J2-8 -> JA-11`、`J3-5 -> JB-5`、`J3-8 -> JB-11`，为两组 DVP 信号提供更短的回流路径。

### 控制信号

- `JA-1 -> J2-1/XMCLK`：直接连接；Camera Overlay 初始保持低电平，启动时先输出 `6 MHz`，XDC 使用 `DRIVE 4`、`SLEW SLOW`。这些设置降低驱动强度和边沿速度，不会把高电平从 3.3 V 降到 2.8 V。
- `JA-3 <-> J2-3/SDA`、`JA-4 -> J2-10/SCL`：直接连接；RTL 只允许开漏输出，XDC 启用 PYNQ 内部弱上拉，SCCB 先降到 `10 kHz`。没有 ACK 时停止，不得改成推挽高电平。
- VSYNC、HREF、PCLK、D0-D7 按下文交叉表直接连接并固定为 FPGA 输入。

### 使用边界

1. 只在独立 Camera Overlay 下连接；冻结 C6I bitstream 的 JA/JB 方向未按相机接口定义，不直接试接。
2. 全部接线在 PYNQ 断电状态完成，逐针核对后再上电。
3. 首次只接电源和地。PYNQ 重启、3.3 V 下跌或相机发热时立即断电并拆除电源线。
4. 供电稳定后依次接 XCLK、SCCB、同步信号、D0-D7，每一步均断电插拔。
5. 完成芯片 ID 与首帧验证后断电；连续运行前增加 XCLK 分压和 SCCB 2.8 V 上拉。

Camera bring-up 期间由 `deploy_camera_overlay.ps1` 停止并禁用 `voice-view-shell.service`，同时对当前启动添加 runtime mask，确保 C6I 与 Camera 不并发管理 PL。断电重启后 C6I 仍保持禁用；全部 Camera 验收结束并拆除相机信号线后，使用 `sudo systemctl unmask voice-view-shell.service && sudo systemctl enable --now voice-view-shell.service` 恢复游戏基线。

## 交叉接线

PYNQ-Z2 管脚来自 Xilinx/PYNQ commit `19ed17d4fd4ea71f95a97d30f8ccd0d62b8dbaaa` 的 `boards/Pynq-Z2/base/vivado/constraints/base.xdc`，源文件 SHA-256 为 `05D99C9032CEB21B2F6850955DD897A14A30D77EBDA21D57867DAA65CAEF2D3B`。

### J2 到 JA

| 相机板 | 信号 | PYNQ-Z2 | FPGA pin | 处理 |
| --- | --- | --- | --- | --- |
| J2-1 | XCLK | JA-1 | Y18 | 3.3 V 到 2.8 V 单向电平转换 |
| J2-2 | VSYNC | JA-2 | Y19 | FPGA 输入，建议源端 33 Ω 串阻 |
| J2-3 | SDA | JA-3 | Y16 | 开漏，4.7 kohm 上拉到 2V8_REF |
| J2-10 | SCL | JA-4 | Y17 | 开漏，4.7 kohm 上拉到 2V8_REF |
| J2-11 | HREF | JA-8 | U19 | FPGA 输入，建议源端 33 Ω 串阻 |
| J2-12 | PCLK | JA-7 | U18 | FPGA 时钟输入，建议源端 33 Ω 串阻 |
| J2-5 | GND | JA-5 | - | 共地 |
| J2-8 | GND | JA-11 | - | 共地 |
| J2-6 | 3V3 | 外部 3.3 V | - | 唯一供电点 |

J2-4、J2-7、J2-9 悬空；JA-6、JA-12 悬空。

Camera v4 起必须在断电状态交换原接法的两根线：将 J2-12/PCLK 的 JA 端从 JA-8 移至 JA-7，将 J2-11/HREF 的 JA 端从 JA-7 移至 JA-8。Vivado 2026.1 器件查询确认 U18 为 `IO_L12P_T1_MRCC_34`、U19 为 `IO_L12N_T1_MRCC_34`；原 PCLK 接 U19 触发单端时钟 `DRC PLIO-9`。换位前不得加载 v4；电源、地、XCLK、SCCB 和数据线无需增减。

### J3 到 JB

| 相机板 | 信号 | PYNQ-Z2 | FPGA pin | 相机板 | 信号 | PYNQ-Z2 | FPGA pin |
| --- | --- | --- | --- | --- | --- | --- | --- |
| J3-1 | D6 | JB-1 | W14 | J3-9 | D1 | JB-7 | V16 |
| J3-2 | D4 | JB-2 | Y14 | J3-10 | D3 | JB-8 | W16 |
| J3-3 | D2 | JB-3 | T11 | J3-11 | D5 | JB-9 | V12 |
| J3-4 | D0 | JB-4 | T10 | J3-12 | D7 | JB-10 | W13 |
| J3-5 | GND | JB-5 | - | J3-8 | GND | JB-11 | - |

J3-6、J3-7 悬空；JB-6、JB-12 悬空。相机板已从 J2-6 供电，不再增加第二个 3.3 V 注入点。

## 电平接口

### DVP：相机到 PYNQ

PCLK、VSYNC、HREF、D0-D7 由相机以 2.8 V 电平输出，可直接接 PYNQ 3.3 V Bank 输入。XDC 设为 `LVCMOS33` 和纯输入，不继承 Base XDC 的 `PULLUP true`。线长控制在 10 cm 内，优先信号/地成对布线；需要改善振铃时在相机 J2/J3 源端串联 `22~47 ohm`，该电阻不承担电平转换。

### XCLK：PYNQ 到相机

推荐使用 `SN74AXC1T45` 或等效双电源单向器件，A 侧 3.3 V、B 侧 2.8 V，方向固定为 PYNQ 到相机。相机侧 `2V8_REF` 从 `U1 pin 5` 取得；焊接前用通断档确认该点与 R2 的 `VDD_2V8` 侧、C8/C9 的电源侧相通。

仅用于短线 bring-up 的离散替代：

```text
PYNQ JA-1/XCLK ---- 100 ohm ----+---- 相机 J2-1/XMCLK
																|
															620 ohm
																|
															 GND
```

空载分压约为 `2.84 V`。连接相机前先用示波器确认 24 MHz 相机端高电平不超过 `3.0 V`，并满足 OV5640 表 8-5 的时钟边沿要求。

### SCCB：开漏直连

PYNQ 的 SCL/SDA 只在低电平时主动驱动，高电平时切换为高阻；两根线各用 `4.7 kohm` 上拉到相机板 `2V8_REF`：

```text
2V8_REF ---- 4.7 kohm ---- SCL ---- PYNQ JA-4 / 相机 J2-10
2V8_REF ---- 4.7 kohm ---- SDA ---- PYNQ JA-3 / 相机 J2-3
```

PYNQ 可可靠识别 2.8 V 高电平。XDC 不启用 3.3 V 内部上拉。若使用现成转换板，选 `PCA9306` 或明确支持 2.8 V/3.3 V 开漏总线的器件，LV 侧接 `2V8_REF`、HV 侧接 PYNQ 3.3 V。SCCB 不得上拉到 5 V，也不得在相机侧上拉到 PYNQ 3.3 V。

## 分阶段上电门禁

### 0. 断电检查

1. 相机与 PYNQ 完全断开。
2. 万用表确认 J2-6、J2-7、J3-6、J3-7 互通；J2-5、J2-8、J3-5、J3-8 互通。
3. 测量 3V3 到 GND 的静态电阻，等待输入电容充电后的读数稳定。稳定值低于 10 Ω 时停止上电并检查短路、FPC 方向和焊接。
4. 通断档逐根核对交叉线，重点确认 J2-12/J2-11 与 JA-12/JA-11 没有 1:1 连接，J3-12/J3-11 与 JB-12/JB-11 没有 1:1 连接。

### 1. 相机独立供电

1. 仅连接外部电源到 J2-6 和 J2-5，不接 PYNQ 信号。
2. 电源设为 3.30 V、50 mA 限流，短时上电排查硬短路或局部发热。
3. 初检通过后将限流提高到 300 mA；记录启动峰值和稳态电流。持续限流、输入电压明显下跌或器件发热时立即断电。
4. 测量 LDO 输出，2.8 V 和 1.5 V 均应在标称值 ±5% 内。

### 2. 共地与时钟

1. PYNQ 与相机断电后接地线和 XCLK 电平转换器。
2. Camera Overlay 将全部 DVP/SCCB 管脚设为输入或高阻，XCLK 初始保持低电平。
3. 两端供电稳定后启用 24 MHz XCLK；示波器在相机侧确认高电平不超过 3.0 V，且无明显振铃。

### 3. SCCB

1. 接入 2.8 V 上拉的开漏 SCCB，保持 DVP 数据线断开；使用 PCA9306 时再按器件要求连接两侧上拉。
2. 先检查 SDA/SCL 空闲高电平：直连方案约 2.8 V；PCA9306 方案 PYNQ 侧约 3.3 V、相机侧约 2.8 V。
3. 读取 OV5640 芯片 ID 并重复 100 次；记录 NACK、总线恢复和平均事务时间。

### 4. DVP 时序

1. 先接 PCLK、VSYNC、HREF，使用计数器/ILA 验证频率、极性和帧行关系。
2. 再接 D0-D7，抓取固定测试图或小分辨率帧。
3. 完成输入时序约束与实现后时序检查，再进入 DMA/帧缓冲联调。

### 5. 系统集成

独立 Camera Overlay 完成供电、芯片 ID、同步计数和小帧抓取验收后，再定义相机帧进入 Studio/C6I 的软件合同。冻结 C6I bitstream 保持为游戏验收基线，Camera Overlay 使用独立 BUILD_ID 和独立上板记录。

## 验收记录

每次实板接线或上电在 `docs/bringup/` 记录：

- 电源型号、限流值、3.3/2.8/1.5 V 实测值和启动/稳态电流；
- 接线照片、J2/J3 到 JA/JB 的通断表；
- Overlay BUILD_ID、bitstream/XDC SHA-256、Vivado 版本；
- XCLK 幅值与频率、SCCB 芯片 ID、100 次读取统计；
- PCLK/VSYNC/HREF 计数、ILA 截图与首帧摘要；
- PYNQ Linux、Agent 和 HDMI 基线是否保持稳定。

## 证据分级

- `pmod-camera-v1.0.pdf` 的 J2/J3 针号、U1/U2 位号及板级网络：raw-file verified。
- OV5640 的 VDD-IO、电流、XCLK 和 SCCB 规格：datasheet-verified，依据 Product Specification v2.03 表 8-1、8-3、8-5、8-6。
- ME6211 的输入范围、压差和输出能力：datasheet-verified，依据 ME6211 Ver07 第 1~4 页。
- PYNQ-Z2 JA/JB package pin：raw-file verified，依据文首固定 commit 的官方 `base.xdc`。
- Zynq LVCMOS33 输入阈值：datasheet-verified，依据 DS187 表 9。
- 旧接法掉电由针脚错位或反灌触发：高可信推断；旧线束通断表、故障电流曲线和各电源轨波形是最终闭环证据。
