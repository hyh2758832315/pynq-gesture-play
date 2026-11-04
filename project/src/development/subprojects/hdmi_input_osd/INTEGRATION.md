# 接入合同：所有产品 HDMI 界面的独立输入提示

这是独立候选的接入材料，当前未执行接入、未部署。目标 PYNQ-Z2 / `xc7z020clg400-1` / Vivado 2026.1。主线 r15 仍由 Copilot 推进。

## 硬件位置与时序

在当前源码中，`board/pynq_z2/scripts/build_c4m3.tcl:461` 起四条连线为 `core/vid_* -> rgb2dvi/vid_p*`。新硬件应替换成：

```text
游戏 / 默认菜单 / 图片 / 视频 / 暂停 framebuffer
    -> 原有 GPU palette scanout
    -> input_osd_axi（独立于 Scene、VVG 与游戏 tick）
    -> RGB2DVI -> HDMI

视觉早发布观察 ──┐
                ├─ 仅观察的最新快照 -> 小寄存器 mailbox -> 帧边界原子生效
音量已有本地缓存 ┘
```

OSD 不增加 framebuffer、DMA、AXI-Stream FIFO 或回传图像。像素时钟原样 74.25MHz，输入 RGB/DE/HS/VS 一起经过三个寄存器级；持续吞吐每时钟一个像素。像素被首次采样至输出为两个后续上升沿，三个寄存器级的接口延迟应按整体流水线在集成时核对，不将其称为端到端识别延迟。寄存器快照只在输入正极性 VS 上升沿生效；与背景是否更新无关。无 VS 的非法/停止视频源不属于持续 HDMI 扫描合同。

默认颜色打包沿用现有 `{R,B,G}`，不能误设成 RGB。`RGB_PACKED=1` 仅用于明确 RGB 的新父级。圆环外半径12像素、内半径10像素，中心3×3点；握拳时外/内半径8/6像素，整体红色。半径不依赖检测框面积。坐标超界隐藏，贴边自然裁剪；音量条始终位于最上层，不受游戏 camera_x 影响。

## 寄存器 ABI（仅 OSD，不是 GPU ABI）

AXI-Lite 32bit、7bit 局部地址，唯一软件 writer，AW/W 独立握手，支持字节写和 B/R 背压。只访问下表地址；父互联分配4KiB孔径时，上层地址高位截断可能形成地址别名，不把整个4KiB视为不同寄存器。驱动只借用这一个专用窗口。

| Offset | 用途 |
|---|---|
| `0x00` | 只读 ID `0x4F534401`，与平台 BUILD_ID 分开 |
| `0x04` | bit0 BUSY；提交后一直保持到新配置在 VS 生效并返回确认 |
| `0x08` | bit0写1提交；忙时返回 SLVERR，绝不覆盖正在传递的快照 |
| `0x10` | flags：bit0启用；bit1位置有效；bit2当前握拳；bit3音量健康 |
| `0x14` | X bits10:0；Y bits25:16，物理1280×720显示坐标 |
| `0x18` | 当前音量条高度 bits9:0；SOFT刻度高度 bits25:16 |
| `0x1C` | LOUD刻度高度 bits9:0；手位置剩余帧数 bits23:16；音量剩余帧数 bits31:24 |
| `0x20` | 单调更新的手观察身份32bit；0保留，回绕跳过0 |
| `0x24` | 单调更新的音量观察身份32bit；0保留，回绕跳过0 |

音量高度0..240；默认量程0..2×LOUD，使用与源分类器同单位的数值与实际门槛。SOFT/LOUD两条刻线固定，禁止随当前峰值自动缩放。QUIET只参与源重武装，不作为第三条玩法门槛。源失效后保留灰色槽和暗刻线，区别于健康安静。

两个身份各有独立的帧数看门狗，默认上限手15帧、音量6帧。每次 VS 减1，只有新的相应源身份可重装；音量持续更新不能续期旧手坐标。相同帧号重复查询、状态心跳、游戏重画均不能续期。剩余帧数由原始源时间戳计算，低于一帧就提前隐藏；从提交到下一VS的等待仍可能带来约一帧的显示过期量化误差。这些是提示层显示预算，完全不改变玩法100ms、硬件ACK50ms或采集TTL。

任一外部 reset 都复位两个 OSD 时钟域，独立同步释放，防止 request/ack toggle 不一致后显示旧快照；未提交前默认不叠加。重置 OSD 不得通过重置共享 GPU/相机/音频来实现。

## PS 数据来源：只观察、非阻塞

`osd_publisher.py` 无 PYNQ、网络和游戏依赖，只接受 caller 提供的 `read/write` 窗口。默认30Hz，一次最多1次 BUSY读取、6字影子写和1次提交；不忙等，忙时丢弃旧待显示项、保留最新观察。210次32bit写/秒加30次读/秒是事务预算，不是已测ARM CPU占用。观察调度必须独立于游戏循环；可以由 Agent 单独的有界低优先级观察调度调用，不能阻塞音频worker或在识别回调中等待帧边界。

视觉观察入口应在 `vision_async_runtime.py` 的早发布路径取得 `observed.centroid`、`bbox`、源run/config_epoch/frame_id及原始结果时刻。当前位置可靠性与手势分类分开：有可靠位置、尚无分类照样画绿色；只有同一新鲜帧确认 FIST 才画红色。不能用量化LEFT/CENTER/RIGHT替代连续坐标，也不能调用 `sample*()` / `consume()` 取得显示数据，因为它们可能消费动作。识别输出坐标已经旋转/镜像，适配时只转换为屏幕归一化坐标，不再次镜像。现有质心是选定皮肤像素面积中心，并非严格掌心。

音量使用自治worker已产生的**同一份已解码缓存**中的统计量、配置门槛、producer_run/epoch/sample_count和原始 observed_ns。不得为 OSD 再运行 monitor/event/ACK、发 RPC、拷贝整页诊断环，或根据PC接收时间续期。异常或陈旧应局部变灰，不向游戏输入注入故障或修改 reservation。

`HandObservation` 与 `AudioObservation` 是显式合同；PS/游戏不必引用这个模块，未来统一观察层可提供同等字段。显示用序号由观察适配器对源身份做映射；源切换/重启/配置变化必须有新 producer identity。原时间戳须来自板端同一 monotonic 时钟。

## 新父级接入步骤

1. 从已封存硬件源建立全新候选工程、目录及独立平台 BUILD_ID，保留父级bit/HWH和清单。当前运行的 `0xC0060C00` 身份不可复用。
2. 添加本目录4个RTL；预留一个未连接的 GP0 AXI-Lite master，审核新的空闲寄存器孔径。不要让本任务自动扩主线 SmartConnect 或改其时钟/复位。
3. `tools/attach_new_parent.tcl` 只定义函数，source本身不修改BD。显式调用时传入新工程根、专用master、核准地址、父BUILD_ID与已分配新BUILD_ID。函数检查项目目录、身份、地址不重叠、旧四条连线，再插入OSD。它尚未在完整父BD上执行，属**待集成验证脚本**，禁止当已通过的部署入口。

   ```tcl
   source <OSD_ROOT>/tools/attach_new_parent.tcl
   # Five caller-supplied, verified values; no default production address or BUILD_ID.
   attach_input_osd $new_candidate_root $dedicated_master_pin $approved_osd_base $parent_build_id $new_build_id
   ```

4. 综合后按实际完整层级设置 `::osd_scope` 为 OSD wrapper内 `impl/` 的路径，再 source `constraints/osd_cdc.tcl`。不能对整个两时钟域使用 asynchronous clock_groups，覆盖握手数据的10ns max_delay/bus_skew。必须审阅135条CDC-15及握手保持时序，不能自动豁免或把warning当签核。
5. 先做整机综合、布局布线、内部/外部时序、DRC/CDC/bus_skew及配对制品审阅。现有融合父级仅6ps setup裕量，独立 OOC 正裕量不能推定整机通过。
6. 后续整机空闲窗口才装新候选，测菜单/游戏/暂停/图片/视频、停止游戏继续移动手、停源隐藏、禁用叠加逐像素等价。对照提示开关前后的实际present、视觉源年龄、音频max_poll_gap/ACK余量、CPU/RSS和 source→HDMI延迟。软件目视与示波/高速摄影等端到端测量另记，HDMI60Hz不代表识别60Hz。

新硬件、完整观察接口接入、板端验收均未在本轮执行。独立实现和证据用于下一次受控合入。
