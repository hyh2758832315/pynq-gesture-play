---
name: PYNQ Studio
description: PYNQ 上位机控制与后台读取的原生 PySide6 工作台
colors:
  app-background: "#18151a"
  toolbar-background: "#241b23"
  panel-background: "#272128"
  control-background: "#302630"
  accent: "#e8377e"
  accent-hover: "#f26199"
  accent-text: "#201018"
  text: "#f4f7f8"
  muted-text: "#aeb8bd"
  border: "#604454"
  success: "#9edb9a"
  waiting: "#efc078"
  error: "#ff9687"
typography:
  body:
    fontFamily: "Bahnschrift, Microsoft YaHei UI, Noto Sans CJK SC"
    fontSize: "10pt"
  heading:
    fontSize: "18px"
    fontWeight: 700
  metric:
    fontFamily: "Cascadia Code"
    fontSize: "14px"
    fontWeight: 700
rounded:
  button: "4px"
  input: "3px"
spacing:
  compact: "6px"
  group: "8px"
  panel: "12px"
components:
  button-primary:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.accent-text}"
    rounded: "{rounded.button}"
    padding: "7px 12px"
  button-disabled:
    backgroundColor: "{colors.panel-background}"
    textColor: "{colors.muted-text}"
    rounded: "{rounded.button}"
---

# Design System: PYNQ Studio

## Overview

面向 PYNQ 连接、部署、控制和后台数据读取的原生操作工作台。
采用中性石墨灰、PYNQ 粉色操作强调和独立语义状态色，保留 PC 模拟、参考预览与编辑功能。
视觉源为 [theme.py](python/pynq_multimodal_game/studio/theme.py)，字体入口为
[qt_app.py](python/pynq_multimodal_game/studio/qt_app.py)。

## Colors

PYNQ 粉色用于主操作、选择与焦点；成功绿、等待琥珀、错误浅红用于真实状态。
应用、工具栏、内容和输入控件使用不同中性层级；文字背景透明。
普通按下与选中沿用PYNQ 粉色，错误和危险信息单独使用错误色。

## Typography

正文及原生标签使用 10pt，标题 18px，读数 14px。
中文通过 Microsoft YaHei UI 或 Noto Sans CJK SC 回退。
代码和读数沿用 Cascadia Code；长字段使用省略或表格滚动，完整内容保留 tooltip。

## Layout

窗口默认 1440x900，最低 1080x700；顶部设备条 88px，左导航 144px。
当前手势按键平台（`0xC0061000`）五页顺序为 Vision、Game、Video、PL GPU、加载到 PYNQ，默认进入 Game 的 PC 创作视图；不创建 Audio 工作台，不展示声音输入、声音回读或声音测试事件。手动用例显示“手势测试 / 未保存”。历史有声平台才动态加入 Audio 页，并恢复对应声音工具。

2026-10-27 工作流：Game 仅提供 PC 试玩、测试及源代码/时间线编辑；没有执行目标选择、板端运行或独立 VVG 构建按钮。Video 维护本地素材列表，提供 PC 播放、暂停、停止和整段解码测试。统一加载页勾选游戏和视频，后台先构建并验证所有内容，再串行安装、回读长度和 SHA。游戏试玩内部沙盒缓存不作为发布包；加载时重新确定性构建。加载完成后由 HDMI 菜单选择内容，不自动运行游戏或灵巧手。

顶栏“连接 PYNQ”分别表达板卡连接与程序就绪：Agent 不可用时，后台以已配置的 SSH 主机进行身份认证、核对 IP，并读取已安装项目及进程记录；SSH 可连接不冒充 HELLO READY。程序就绪后不再追加 SSH 轮询。底部 HTTP 回传状态独立，关闭回传不影响部署。加载页提供“安装完整项目”和无需本机系统包的“启动已安装项目”，均不依赖 Agent 已运行；首次安装不要求历史项目目录。一键内容加载在 Agent 未就绪时先通过 SSH 启动已安装项目（未安装则使用所选完整包），再构建、验证并上传内容。普通启动无实验倒计时，启用实体手沿用现场确认与唯一 owner/正常释放检查。回传按需开启，离开 Vision 停止订阅；切页停止 PC 游戏/视频，加载期间暂停预览并锁定编辑和目标切换。线程停止未确认时保留引用并拒绝关闭或替换会话。失败批次保存已安装、未确认和未上传项，不伪称原子回滚。操作和证据见 `docs/bringup/2026-10-30_studio_board_bootstrap.md` 和 `docs/bringup/2026-10-27_studio_content_closure.md`。
R23桌面入口默认打开独立的 `games_gesture/` 可编辑手势工程，名称与板端SKY RUN、RPS、HAND QUEST一致；模板与板端种子包共用源码准备函数。已有工程修改与显式配置的工程根目录都保留，避免界面显示手势模式却重建旧声音玩法。
Game 使用可调三栏和分行控制；Video 使用可调双栏与滚动属性区，历史 Audio 页也使用双栏。
Vision 使用左侧画面单选栏、中央等比例画布和右侧滚动读数；保留实时预览与六个处理画面。
底部接收、相机、任务及最近回读摘要常驻，详细日志可展开，保留 300 条。

## Elevation & Depth

层级由中性底色、薄边线、间距与原生 splitter 表达，使用平面工作区。
动态画面保留实际内容及宽高比，空输出提示使用紧凑区域。

## Shapes

按钮圆角 4px，输入圆角 3px，工作区分区不作浮动圆角卡片。
顶栏与窗口使用已有 AMD/PYNQ 字标几何，透明背景、PYNQ 粉色，随 Python 包分发。操作图标沿用统一 Qt QStyle 标准图标；短图标按钮具有稳定尺寸和 tooltip。

## Components

- 设备身份来自当前 DeviceSnapshot，BUILD_ID 来自成功校验的 HELLO；模拟器标为 SIM。
- RX 来自已有后台 DATA 信号，显示当前会话包数与本机最近接收时间。
- Game 摘要来自板端命令及条件状态查询的快照，空摘要字段显示 `--`。
- Video 播放读数为最近命令快照；大画布为本机 S2V1 参考预览。
- HTTP MJPEG 相机拥有独立状态，画面尺寸来自解码后的 QImage。
- Vision 六处理图来自 debug.jpg 的三列两行拼图，每格320x180；本地切换缓存，图像与控制结果的帧身份分别处理。
- 实时预览与处理图订阅互斥；不提供 Hz 输入框，按新帧自动接收，右侧只读显示实际接收帧率。等待/断流后保留明确历史状态。
- 开启图像回传进入独占观察：HDMI 一次提交专用暂停页，原独立 PL OSD 手势圈继续同步；同一灵巧手 owner 保持跟随。菜单输入、游戏 tick/绘制、视频解码/绘制暂停，关闭回传后恢复此前页面和暂停状态。中断手势展示时先完成 default/OFF 交接，结束观察返回主菜单。PC 仍显示原摄像头识别几何画面（白字在右栏），不替换为 HDMI 手势圈画面。图像回传不再触发旧版“灵巧手卸力暂停”分支，视频恢复仍须 17 OFF 收据。
- 暂停页使用共享sink最近成功ACK的palette/asset/tilemap generation，不猜测菜单或游戏身份，不使用默认0；只绘矩形也需满足GPU资源身份条件。
- 回传断流自动重连；独立编码器故障先释放旧实例再退避重建，不停止识别，未知释放禁止第二owner。GPU poisoned请求受控完整重新初始化，必须确认相机、手、借用线程和DMA缓冲释放后才可同PID重新执行全部启动检查。关闭门禁防止页面自切换清除外部停止请求。
- Vision 的 result.json 观察独立于图像订阅；HTTP 可达、判断状态、run、源帧、方向和两种年龄分别显示。重复源帧不续期，失效方向回到 IDLE；长身份按字体宽度省略并保留完整 tooltip。
- 图像失败后结果观察继续；显式断开停止三个 worker，线程退出未确认时保留引用并延后关窗。结果观察为只读，游戏输入接入另行验收。
- Vision保留独立VISION_ONLY/8766和融合C6I_VISION/800两种严格能力身份；融合端口跟随主Agent，32px Qt启停/查询图标和状态读数不变。网络在worker、请求互斥，1s轮询保留真实STARTING/RUNNING/STOPPING/FAULT占用及完整回执tooltip。HTTP图像/判断观察独立；服务启动不自动订阅相机，也不等于游戏或HDMI验收。
- Game区分确定性回放和实时视觉。实时路径保持PC黄金预检、同包安装/身份回读，VISION_START确认RUNNING后无测试JSON启动；方向/动作只来自PS本地provider，注入/逐tick控制禁用。配置平台身份决定离线目标包，HELLO决定设备READY；800产物独立命名，源项目与700包保留。
- 三游戏候选通过板端显式开关启用本地映射，由已验证manifest.game_id路由：game1四向/一次跳跃、game2同帧稳定三态、game3左右/确认/跳跃。PC Studio保留配置、监控、部署和验收职责，HTTP结果不进入板端控制路径；默认旧入口不变。
- Agent STATUS中的vision_consumption为对应Scene完成时保存的原子采样回执，含源run/frame/epoch、采样tick/年龄/动作、同帧游戏状态/Scene SHA和sink完成计数。排队中或失败的Scene不提前公布，最新HTTP结果与已消费源帧分别显示；该回执支持软件关联审计，真实HDMI仍需实屏证据。
- Studio live装载在工作线程先读取VISION_STATUS，要求融合800身份及input_capabilities的local-game-vision-v1/games与目标game_id，再启动视觉和游戏。旧模式、缺能力及不支持游戏显式拒绝。Game读数区显示实际消费源分类/方向、run/epoch/frame、采样/Scene tick、年龄/动作及确认SHA；长值省略保留tooltip，断线保留历史标记。新连接可从消费快照恢复live输入隔离。预览页纵向滚动，数值输入独立行保证1080x700读数可见。
- 关窗取消本地控制请求和轮询，不隐式停止板端视觉。握手完成后检查取消门禁；线程退出未确认保留引用并推迟关窗，底层退出确认后回收。请求已被板端接受后以重连查询回执确认实际状态。
- 能力页显示静态冻结 C4M7 配置；资源预测周期保持估计值身份。
- 断线后已有回读标为历史；恢复连接等待新数据，不将旧值改标为最新。
- 控制任务执行及完成到线程清理的间隙保持互斥；改设备前检查板端任务。

- 900/C6I_VISION_VOICE_S3为显式候选，视觉跟随主Agent；默认旧视觉入口继续拒绝900。SDK目标包独立命名，声音候选按manifest视觉映射检能力，Scene回执保留候选包身份。
- Audio只读STATUS，32px Qt观察/停止图标及波形/抽样频谱选择；240点最新PCM、单槽合并队列、重复包不续新鲜度，换epoch清旧图、断线保留历史。停止观察不停止板端，未确认线程退出阻断关窗/切设备。来源年龄待实测，0-6kHz抽样频谱保留诊断身份。
- Game声音识别、策略批准、游戏效果及同整数tick/有效SHA的声音Scene确认分别显示；schema3时间线保留声音事实、健康、seed与显式tick时间。900生命周期控制使用独立有界等待，STATUS/观察仍为短轮询。

## Do's and Don'ts

- 长时系统任务的 worker 使用独立 QObject/run 槽，避免覆盖另一 worker 已注册的同名 Qt 槽。原生验收必须同时检查工作线程身份、GUI 定时心跳、取消响应和任务结束后的线程回收，不能只以最后加载成功作为界面无卡死的证据。等待显示本机经过时间和不定进度动画；远程提交后的取消保持既有回执与资源释放合同。

- C0C/C6I_VISION_VOLUME_V1为显式双音量候选，沿用主Agent8765、相机8081；外层整机身份与内层VOL1组件快照分开校验。Audio的C0C来源仅观察唯一poller缓存，缓存年龄参与新鲜度，停止观察不停止板端；disabled无幅值，fault与过龄保留历史。
- schema4时间线保留VolumeSignal全部字段、seed和tick时间，SOFT/LOUD菜单仅编辑离线回放，不成为live注入。音量包按volume_inputs.vision_mapping启动原视觉语义；采样/poller/lease与有效缓存通过门禁后再安装运行。
- Game的音量源事件、ACK/消费/执行、游戏效果和Scene确认使用独立volume_consumption，绑定当前game_id/run/tick/SHA，不占用旧audio字段。每个回执身份只审计一次，STATUS观察不当作完整事件流；离线合成源与fake GPU截图保持软件验收身份。
- Do 保持设备身份、数据接收与操作回执三种事实分别可见。
- Do 保留原生控件、输入坐标 320x180 与现有 Worker 生命周期。
- Do 以来源标签区分 PC、Agent DATA、HTTP 相机和静态配置。
- Don't 从 Agent 在线推断游戏运行、相机在线或 HDMI 实况回传。
- Don't 添加未经后端提供的温度、功耗、GPU 利用率或实时视频进度仪表。

现有 `eyebrowLabel` 和菜单内部分英文为兼容保留，不作为新页面的标题模板。

## Gesture Controls

- 握拳、剪刀、布使用互斥的原生分段选择，稳定高度 30px、单段最小宽度 52px；注入命令使用 Qt 标准箭头图标及 tooltip。
- 坐标输入与手势选择独立，game1 所有手势均可控制方位，握拳边沿单独触发跳跃。
- 选择值、待消费提交和实际消费分别显示；PC 时间线、PC 手动与 PYNQ 软件调试来源明确，视觉尚未接入时保留等待状态。
- 时间线中文显示名称与内部 canonical 值分离，取消、复位、禁用和断线反馈沿用既有状态色与任务互斥。
- 界面经验源维护在项目自有 `voice-view-studio-design` Skill，第三方设计 Skill 保持独立。

## Studio PYNQ 品牌与无字回传（2026-10-29）

PYNQ 粉色 #e8377e 用于操作、焦点和选择，深梅灰工作区保留现有布局与语义状态色。顶栏复用现有 AMD/PYNQ 字标遮罩，透明背景。相机与六处理图的新版 JPEG 只绘几何标注，不写文字或遮挡图像的标题条；来源、状态、识别数值放到右侧可滚动信息栏。result.json 与 JPEG 独立取样，结果详情明确标注自己的源帧和历史状态，不声称同帧；不增加轮询或推理。旧板端已烘焙的文字须经 Studio 标准加载新版运行包后消失，PC 不裁切/遮盖旧图。
