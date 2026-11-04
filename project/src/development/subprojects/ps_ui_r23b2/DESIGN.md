---
name: "PYNQ Gesture Play HDMI Shell"
description: "320×180 手势设备的粉色像素界面；适用于板端 shell，不适用于 PC Studio。"
colors:
  pynq-pink: "#E8377E"
  feedback-teal: "#30776D"
  shape-yellow: "#FCCB58"
  shape-blue: "#528BEA"
  shape-green: "#399F6D"
  shape-coral: "#E45465"
  warm-background: "#FFF4F8"
  paper-white: "#FFFFFF"
  header-pink: "#F7D8E5"
  edge-rose: "#D6A9BE"
  ink-plum: "#3F2737"
  caption-plum: "#805B70"
  disabled-mist: "#EDE5EB"
  return-cyan: "#26C4D6"
  return-cream: "#F5F1E0"
  return-track: "#383D44"
  return-progress: "#6FCD66"
  return-label-bg: "#12161C"
typography:
  display:
    fontFamily: "PYNQ 3x5 bitmap (_MENU_GLYPHS)"
    fontSize: "20px"
    letterSpacing: "4px"
  headline:
    fontFamily: "PYNQ 3x5 bitmap (_MENU_GLYPHS)"
    fontSize: "15px"
    letterSpacing: "3px"
  title:
    fontFamily: "PYNQ 3x5 bitmap (_MENU_GLYPHS)"
    fontSize: "10px"
    letterSpacing: "2px"
  label:
    fontFamily: "PYNQ 3x5 bitmap (_MENU_GLYPHS)"
    fontSize: "5px"
    letterSpacing: "1px"
components:
  home-entry:
    backgroundColor: "{colors.paper-white}"
    textColor: "{colors.ink-plum}"
    typography: "{typography.title}"
    width: "132px"
    height: "45px"
  library-row:
    backgroundColor: "{colors.paper-white}"
    textColor: "{colors.ink-plum}"
    typography: "{typography.title}"
    width: "264px"
    height: "34px"
  library-row-disabled:
    backgroundColor: "{colors.disabled-mist}"
    textColor: "{colors.caption-plum}"
    typography: "{typography.title}"
    width: "264px"
    height: "34px"
  action-button:
    backgroundColor: "{colors.paper-white}"
    textColor: "{colors.caption-plum}"
    typography: "{typography.label}"
    width: "80px"
    height: "54px"
  shape-choice:
    backgroundColor: "{colors.paper-white}"
    width: "52px"
    height: "28px"
  size-control:
    backgroundColor: "{colors.paper-white}"
    textColor: "{colors.ink-plum}"
    width: "26px"
    height: "20px"
  header-band:
    backgroundColor: "{colors.header-pink}"
    textColor: "{colors.ink-plum}"
    width: "320px"
    height: "48px"
---

# Design System: PYNQ Gesture Play HDMI Shell

## Overview

**Creative North Star: "可玩、可创作的粉色 PYNQ 设备"**

此文档记录 `subprojects/ps_ui_r23b2` 已实现的 HDMI shell：玩家用手位置识别选项，用新的一次握拳确认，以连续停留返回。视觉世界来自 [PRODUCT.md](PRODUCT.md) 与 [方向合同](design/BOARD_UI_BRIEF.md)，实现证据优先于早期设想。暖白纸面、浅粉分区、深梅文字和粉色反馈保持小尺寸可辨认；像素图形让游戏、视频、手势演示和画布成为同一台设备的入口。

品牌资产采用完整 AMD/PYNQ 组合标，保留官方字形与比例。AMD 深梅、PYNQ 粉色是用户指定的项目内颜色适配，并非官方发布的新配色。玩家界面名为 GESTURE PLAY；本项目没有声音玩法，不以 Voice、声音或音量描述功能。此文档的边界是板端 shell；仓库根 DESIGN.md 属于 PC PYNQ Studio，不受此文件覆盖。游戏内部、PL Overlay 与 ABI 也不在这次视觉系统的改版范围。

**Key Characteristics:**

- 固定逻辑分辨率、像素字与有限调色板。
- 粉色指明当前选择，深梅承担主要文字和动作轮廓。
- 大动作图标配短标签，持续操作有可见进度。
- 静态资源复用；交互状态变化才提交，动态创作页限制频率。

**证据边界：**记录于 2026-10-27，依据 `shell_theme.py`、`shell_pages.py`、`startup_ui.py`、`creative_pages.py`、`pause_menu.py`、`menu.py`，并核对 `return_button.py`、`scene_compiler.py` 和 `agent/c6i_shell.py`。视觉证据为仓库 `build/r45-shell-preview/contact.png` 及 18 张单页；它们由实际 GPU 命令的 PC 渲染器产生。独立审查交接的本批 4 项修正为 resolved，disposition 为 ship，适用范围仅为这组 PC GPU 命令渲染与修正项。实板显示、现场手势操作、Studio 实际加载与设备资源时序仍需单独验收。没有独立 QUALITY BAR 卡或用户批准的视觉 comp，不能把当前图集称为批准稿。

## Colors

浅暖底色承载内容，深梅提供字形与图标轮廓，玫粉提供选择和品牌识别；形状工具用固定四色区分操作。

### Primary

- **PYNQ 玫粉**（`pynq-pink`，shell 索引 7）：PYNQ 字标、当前选项边框、加载填充、部分动作图标细节。
- **反馈青绿**（`feedback-teal`，索引 10）：手势演示机械细节、阶段进度和画布对话框停留反馈。不要把它提升为另一套主品牌色。

### Secondary

- **形状黄、形状蓝、形状绿、形状珊瑚**（`shape-yellow / shape-blue / shape-green / shape-coral`，索引 3–6）：依次绑定三角、方形、圆形、星形。颜色与形状共同编码，不只靠颜色识别。
- **形状珊瑚**也用于启动失败文字和失败进度条；失败同时有 `START FAIL`、失败阶段与 `CHECK STUDIO` 文案。

### Neutral

- **暖白背景**（`warm-background`，索引 1）：页面底色。
- **纸白**（`paper-white`，索引 2）：卡片和画纸。
- **浅粉分区**（`header-pink`，索引 11）：标题带、画布工具架、列表编号底。
- **玫灰边线**（`edge-rose`，索引 12）：细边界、加载槽和现有面板底边。
- **深梅墨色**（`ink-plum`，索引 9）：标题、选项名、动作图标主体。
- **柔梅说明色**（`caption-plum`，索引 8）：短说明、操作提示、禁用文字。
- **灰粉禁用底**（`disabled-mist`，索引 13）：不可用列表项；也用于示意手的内侧平面。

### System control exception

共享返回控件读取系统 palette bank 15，与 shell 的 bank 0 分开。`return-cyan`、`return-cream`、`return-track`、`return-progress`、`return-label-bg` 分别对应系统索引 5、10、4、7、1。这解释了预览中青色返回按钮和绿色环形进度；它们不是新的 shell 索引，也不是把全部前置 token 塞进同一张 16 色图。

**The Fixed Palette Rule.** shell 光栅只使用 `shell_theme.PALETTE` 的 16 个既定索引；透明掩模值 0 不作为可见黑色品牌 token。未在本轮 shell 复用的槽位不建立新设计角色。sidecar 的色阶仅用于文档面板展示，不是运行时可用颜色。

## Typography

**Display / Body / Label Font:** 所有动态文本使用源码 `menu._MENU_GLYPHS` 的 3×5 位图字形；不是操作系统字体，不存在系统字体回退。官方组合标独立使用图像掩模，不由此字库拼写。

字形为大写英文、数字、连字符与空格。每字符占用 `4 × scale` 的水平步进，可见字形宽 `3 × scale`；长度为 n 的文本可见宽为 `(4n − 1) × scale`。字体 token 中的大小指可见字形高度，并非浏览器字号换算。未知字符会留空，因此后续文案不能未经字库扩展直接使用中文、标点或小写专用字形。

### Hierarchy

- **Display**：scale 4，可见字形高 20 像素；用于 LOADING、START FAIL 和画布返回页标题。
- **Headline**：scale 3，可见字形高 15 像素；用于页标题、暂停/结果标题。
- **Title**：scale 2，可见字形高 10 像素；用于主入口、列表、启动阶段、画布标题。
- **Label**：scale 1，可见字形高 5 像素；用于 PLAY / RETRY / MENU、操作提示和辅助说明。关键操作仍由图标或更大的选项名表达。

**The Pixel Type Rule.** 保持整数倍放大和像素对齐，不以抗锯齿字体近似替换运行时字形。5 像素辅助说明是现有约束下的次级文字，不作为未来主操作文字的尺寸标准。

## Layout

固定逻辑坐标为 320×180。HDMI 输出或 PC 预览可以放大，但不重排逻辑布局；当前 1280×720 单页是四倍预览，不是另一套断点。没有移动端或响应式断点。尺寸单位均为逻辑像素。

| 模式 | 当前实现 |
| --- | --- |
| 主菜单 | 顶部约 48 高标题带；完整字标在左、GESTURE PLAY 在右；四入口中心为 (86,83)、(234,83)、(86,139)、(234,139)，视觉卡片 132×45，命中框 132×46。 |
| 游戏列表 | 三条 264×34 的宽行，中心 x=160，y=66/107/148；与主菜单入口位置不同。 |
| 视频列表 | 0 项显示空态；1–4 项为 264×26 行，中心 y=58+32i；超过 4 项时每页 2 条 264×34 行，中心 y=70/114，底部两个 110×24 分页按钮。 |
| 暂停 / 结果 | 暂停三项中心 x=64/160/256、y=94；结果两项中心 x=96/224、y=94；动作卡片 80×54。 |
| 画布 | 左侧 256 宽绘图区与右侧 64 宽工具架；实际可绘纸面 x=8…247、y=26…171。四个 52×28 形状按钮中心 y=31/66/101/136，底部两个 26×20 大小按钮。 |
| 返回 | 固定左上 24×24，中心 (12,12)，半径 12 的圆形命中区域；不是整个左上角任意位置。 |

标题带、卡片、纸面以有限的横向和纵向分区组织内容。这里不定义虚构的通用间距标尺；新增组件应复用同类页面的实际尺寸、文字步进和目标框，不按网页栅格重新排版。

## Elevation & Depth

没有模糊、玻璃、渐变或实时阴影。分层来自浅粉标题带、纸白内容面、玫灰边线及像素轮廓。当前多数面板在 y+2 处先画玫灰底，再画白色正面，形成两像素底边；这是现有光栅的实现事实，不把它提炼成跨页面通用的硬偏移阴影 token，也不要求新表面继承该做法。

加载、暂停、结果和画布返回选择都使用完整页面替换；不在运行中的游戏上叠加透明模糊弹窗。层级变化由可辨认标题、动作集合与输入门禁承担。

## Shapes

基础面板由横向和纵向矩形合成，每个角保留 3 像素方形缺口，形成像素切角。它不是圆角矩形，因此 frontmatter 不虚构 border-radius 值。普通边线宽 1 像素；选中边框宽 2 像素。图标来自明确的像素几何，不使用字符图标或 emoji。

圆、星、三角、方形是画布的实际工具几何。形状掩模在整数尺寸下缓存。标识不可重画为字体、裁去 AMD、拉伸或随意改变内部比例。

## Components

### Official lockup

完整组合标的运行时尺寸为 104×50，`wordmark()` 只缓存一个已校验掩模。它用于启动和主菜单，并在进入内容的加载页重复出现。原资产与来源登记在 [provenance.json](design/assets/provenance.json)，来源为 [Xilinx/PYNQ logo.png](https://raw.githubusercontent.com/Xilinx/PYNQ/master/logo.png)，原图 SHA-256 为 `0e688b32953ca08f597254d21e563b5182b253b518192e5b5e1494fa6551aae1`。颜色适配的声明应与资产一起保留；不得声称为官方配色规范。

### Home entries and library rows

主菜单是图形加名称的四入口；列表用编号、名称和箭头。常规状态为纸白面、深梅文字；disabled 状态为灰粉底、柔梅文字，并从命中候选中排除。选中反馈由 `highlight_frame()` 追加四条粉色 GPU 矩形实现，保持原光栅资产不变。源码中的 `render_shell_page(selected=...)` 支持直接画边框，但实际 shell 路径不借此为每次悬停重打包图集。

菜单默认三次稳定采样后显示 hover。握拳确认后禁用下一次确认，换页提示从 `POINT THEN FIST` 变为 `OPEN HAND THEN FIST`，重新确认须有效新松手/握拳序列。直接松手判定要求不同新帧、至少 80 ms，已提供新握拳边沿的输入可由其上游确认机制重新武装。UNKNOWN、过期帧、重复轮询不能把持续握拳变成跨页连点。跟踪失效清除悬停和停留计时。

### Shared return control

青色像素圆和浅色返回箭头始终占用固定位置。停留满两秒触发，离开或失去有效跟踪即重置；不依赖握拳。进度环为 24 个离散步骤，约每 83 ms 一次可见变化，旁边显示 2S。环和提示文字由 GPU 命令补入，禁止为它们重做整张页面资产。该控件跨页面复用，进度可以变化而底图不变。

### Startup and content loading

启动加载页面包含完整组合标、大号 LOADING、进度条和当前初始化内容。检查顺序为 GPU、LIBRARY、VISION、HAND；每个检查转换前后发布状态，首个错误显示失败并停止。启动进度是模拟视觉值，只有全部检查进入 OK 或允许的 HAND SKIP 才显示完成；动画绝不授权离开启动。其填充随时间渐近，点状提示每秒两次变化，细亮条用已缓存资源移动。

进入游戏/视频的 `content_loading()` 是独立全屏页，文案为 STARTING / OPENING 加内容名；它的固定填充是一种加载状态，不是测量百分比。游戏准备开始前先提交此帧。资源交接必须保持原有互斥和失败恢复路径，不能为了动画增加硬件读取或和游戏首帧并发渲染。

### Pause and result actions

播放、环形重试、房屋三个大像素图标承担主要意义，短标签分别为 PLAY、RETRY、MENU。暂停三项，结果只有 RETRY 与 MENU。结果标题为 YOU WIN、TRY AGAIN 或 DRAW；不把旧的未使用文案常量当作屏幕事实。

所有动作通过两秒停留触发，切换目标重置计时。悬停显示粉色边框，目标下方的 48 像素进度条用 GPU 命令更新。返回按钮在暂停页恢复游戏，在结果页回主菜单。进入结果页后必须先离开动作区才能开始新停留，防止上一轮操作直接触发结果按钮。

### Canvas and tools

空态用短句引导先选形状。右侧四个形状将颜色绑定为黄三角、蓝方形、绿圆、珊瑚星；粉色边框表示当前选择。统一的减号/加号按钮调整大小，档位为 8、12、16、22、30、40；默认 16。在有效新手势序列上握拳选择工具，剪刀只盖一次，握拳连续绘制。重复帧不能再次盖章，UNKNOWN 抖动不重新武装剪刀。

笔画合并进固定 256×180 字节缓冲，不累计对象；鼠标式预览只合成在副本，不写进作品。连续刷印节流约 15 Hz，移动距离不足不补点；大跳变或失去跟踪不连出长桥。返回停留完成后显示 CONTINUE / CLEAR / MENU 全屏选择，各项仍需两秒停留；清空须完成 CLEAR 停留，不能点返回就清除。

### Hand demonstration

HAND SHOW 显示由既有几何参数生成的像素手、当前姿态、阶段与进度。数字 6、9、指心等图形体现已有 curls、bases、spread 与对掌参数，属于示意渲染，不是测量得到的实体手姿照片。真实演示的逐项回 default、权限独占、返回时卸力并确认 OFF 合同继续有效；视觉状态不能代替机械完成信号。

### Submission, caching and asset budget

**The Change Only Rule.** 没有可见状态改变就不提交新页面；相同底图只更新必要命令。不得让轻量 hover、返回环或暂停进度重新上传整张光栅。

`_base` 缓存最多 24 个页面/目标/标签组合，`content_loading` 与 `pause_page` 各最多 12 个，形状掩模最多 24 个，返回环最多 25 个状态。画布与手势演示的 scene 提交上限为 15 Hz；状态键相同仍跳过提交。返回菜单时游戏或视频可能已替换 GPU 资源，必须恢复资源并使已呈现状态失效，不能因页面相同误跳首次显示。

320×180 的 INDEX4 像素面为 28800 字节。资产连同字体等内容必须用真实打包器验证不超过 32768 字节。当前 [budget.json](../../build/r45-shell-preview/budget.json) 的 18 页样本最大 payload 为 29363 字节（启动页），最大完整 asset packet 为 29475 字节；普通像素页 payload 为 28979 字节。payload 与 packet 不是同一量，不能把两者混用。预览样本命令数为 8–20；这不包含所有返回环进度组合，不是全场景命令上限。predicted_cycles 是编译器预测，不是实板耗时或帧率结论。

## Do's and Don'ts

### Do:

- **Do** 以本子项目实际调色板、位图字库和逻辑坐标为准，保留 AMD/PYNQ 完整标识与资产来源。
- **Do** 让大图标、短动作词、明确选择边框与停留进度一起传达操作。
- **Do** 在换页后要求新有效确认，跟踪失效时重置悬停与停留。
- **Do** 用真实打包器检查包含字体的资产预算，并保持静态缓存、命令增量和 15 Hz 创作页上限。
- **Do** 将 PC 命令渲染证据、独立审查结论与实板验收分别记录。

### Don't:

- **Don't** 把项目粉色适配称为官方品牌配色，或裁剪、拉伸、字体重做组合标。
- **Don't** 在玩家界面加入 Voice、声音玩法或音量能力的宣传。
- **Don't** 为 hover、返回环或暂停进度反复上传不变的整屏资产。
- **Don't** 用持续握拳、UNKNOWN、重复或过期观测触发跨页连点。
- **Don't** 将 sidecar 色阶、浏览器演示焦点态或桌面字体当作板端新增运行时功能。
- **Don't** 把预览 ship 结论扩展为实板、机械动作或 Studio 上板流程已通过。

