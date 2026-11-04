# GPU 缓冲与呈现时序：技术说明

## 1. 基线与边界

图对应 `contest_v3/board/runtime` 的 R15b 运行时和 `build/hardware/c6_latency` 中实际导入的 RTL。现有 XPR 指定 XC7Z020CLG400-1 / Vivado 2026.1，部署 BUILD_ID 为 0xC0061000。来源及 SHA-256 见 `data/evidence.json`、`SOURCE_INDEX.json`。

当前 Block Design 的 core 未覆盖 `UPLOAD_RENDER_OVERLAP_ENABLE`，模块默认值为 0；软件能力查询也要求另一 BUILD_ID 才启用重叠。因此，本图中的标准 `submit_scene` 是串行完成提交。两个命令 bank 确实存在，但不意味着此版本在绘制第 n 帧时上传第 n+1 帧。

PS 执行应用逻辑和编译；PL 是命令驱动的二维光栅化器。图中“GPU”沿用项目命名。扫描在片上 BRAM 上进行，不等 AXI/DDR。上游尚未产生并完成新帧时，前台保持，HDMI 扫描继续；独立 OSD 可继续覆盖有效手圈观察。

## 2. 三层存储与各自所有权

| 层 | 当前实现 | 转交条件 |
|---|---|---|
| PS 上传暂存 | 一个 32,880 B PYNQ buffer | 填入 packet、flush；MM2S idle + wait 完成后可复用 |
| PL 命令 bank | 2 × 4,096 B，每 bank 128 条命令 | 完整 TLAST 包通过头部/长度等检查后 active bank 切换 |
| PL Atlas | 2 × 32,768 B 数据，三份描述符分别存储 | CRC/语义接受后，在 renderer_idle 提交 |
| PL Tilemap | 4 slots，每 slot 2 × 4,096 B | 各 slot 在 renderer_idle 提交 |
| PL Palette | 2 × 256 × 24 bit = 1,536 B RGB 数据 | 像素域 vblank 切换，ACK 后更新 committed_generation |
| PL Framebuffer | 2 × 320 × 180 × 8 bit = 115,200 B | render_done 请求，vblank 换前台，ACK 换后台 |

以上为逻辑容量，未计 FPGA 存储块取整、元数据、描述符和控制寄存器。调色板每次上传为 256 个 uint32（1,024 B payload），落入存储时每项保留 RGB24；传输容量与内部数据容量不同。

Atlas、Tilemap、Palette 与 Framebuffer 不能视为一个统一切换的 bank。素材内部的“调色板组 0–15”也不是物理双缓冲的 bank 0/1。

## 3. 一帧的提交顺序

1. `C6IVideoSink._transfer` 将 packet 拷入暂存 buffer，调用 `flush()`，提交 `axi_dma.sendchannel.transfer`，等待 DMA idle 和 `wait()`。
2. 上传器累计 packet；固定 Scene Header 和 Command bank 通过检查后，增加接受计数并更新命令 active bank。
3. core 检查 Palette / Asset / Tilemap 的有效标志与 generation 相等，且 renderer 不忙、没有待呈现帧，才启动光栅化。
4. 光栅化写入后台 token 图像；完成时 `renderer_done` 触发 render 计数并翻转 frame-swap 请求。
5. 请求经过像素域 2FF 同步；在 `vblank_start` 才翻转 `display_bank`，同时翻转 ACK。
6. ACK 经写侧 2FF 同步后，清除 `present_pending`、翻转 `write_bank`、产生 `present_done`，随后 core 增加 present 计数。
7. 驱动分别核对 render count/seq、present count/seq，再检查 render status 和读取 cycles；成功后 ticket 完成，`submit_scene` 返回。

`present_completed_seq` 在 **renderer_start** 就装载 accepted_seq；`present_completed_count` 才随实际 present_done 增加。因此“读到了目标 seq”不能单独证明新帧已上屏。内存后端构造了 seq 已更新、count 连续两次仍为旧值的场景，当前驱动继续等待第三次读取的正确计数。

### ACK 交接窗口

以初态显示 A、写 B 为例：

| 时段 | 显示指针 | 写指针 | 写入 |
|---|---|---|---|
| 绘制 B | A | B | B 可写 |
| B 完成，等 vblank | A | B | 停止 |
| 像素域已切换，ACK 尚在跨时钟 | B | B | 停止 |
| ACK 回来 | B | A | 后续帧可写 A |

不能用“两个指针始终不同”描述该设计；正确条件是在交接窗口停止写入。正常提交的 `present_pending` 阻止下一次 renderer_start。

图中 2FF 表示同步结构，未把检测逻辑或两个不同域的周期压成一个固定软件延迟；两域周期与相位不同。

## 4. 720p 扫描与未赶上边界

- 水平：1280 active + 110 front + 40 sync + 220 back = 1650 clocks。
- 垂直：720 active + 5 front + 5 sync + 20 back = 750 lines。
- 像素时钟 74.25 MHz，渲染/AXI 时钟 100 MHz。
- 周期：1650 × 750 / 74,250,000 = 16.6667 ms，配置刷新率 60 Hz。
- 垂直消隐 30 行，对应约 0.6667 ms。
- `vblank_start` 是 x=0、y=720；`scene2d_frame_swap` 名叫 `frame_start` 的输入实际接的是此信号。
- 逻辑坐标为输出坐标除以 4；一逻辑像素显示为 4×4 输出像素。

如果同步请求在本次 vblank_start 之后才可见，就等下一个 vblank_start。图的时间轴只表达因果，不使用未经测量的 DMA 或渲染时间。切换显示 bank 发生在消隐中，新图像到下一有效区才出现在 HDMI。

扫描包含前台 BRAM 读、token、Palette 查表、视频寄存、OSD 和 rgb2dvi。此组图不标单个像素的总流水线周期；逐级细节见 `scene2d_framebuffer.sv` / `scene2d_palette_scanout.sv`。core 的视频输出接 `input_osd_0` 再到 `rgb2dvi`，连接见 c6v.bd。

## 5. Scene 与像素编码

Scene 固定 4,160 B：64 B Header + 4,096 B 命令区，32 位字均小端。Header word 0 为 S2DG，word 2 为 frame_id，word 3 为 submit_seq，word 4 为 command_count；word 8/10/11 分别是 Palette/Asset/Tilemap generation。完整示例见 `scene_header.csv` 和 `scene_example.bin`。

每条命令 8 words = 32 B。Opcode 位于 word0 的低 8 位；BLIT flags 位于其后 8 位。当前命令支持 CLEAR(01)、DRAW_TILE_LAYER(02)、BLIT_INDEX4(03)、FILL_RECT(04)、END_FRAME(FF)。命令区最多 128 条，剩余字节补零。

FILL_RECT 示例（x=10，y=20，宽32，高16，token=F7）：

| word | 数值 | 字段 |
|---|---|---|
| 0 | 0x00000004 | opcode |
| 1 | 0x000000F7 | token |
| 2 | 0x0014000A | 低16位 x，高16位 y，有符号 |
| 3 | 0x00100020 | 低16位 width，高16位 height |
| 4–7 | 0 | 保留 |

word2 在线性字节流中的顺序是 `0A 00 14 00`。构造 Scene 依次执行 CLEAR、FILL_RECT、END_FRAME；未上传板卡。

素材 INDEX4 每像素 4 bit：偶数 x 放字节低半字节，奇数 x 放高半字节。因此 [1,2,3,4] 打包成 `21 43`。BLIT 源色号 0 透明、不改后台像素。

Framebuffer 每像素一个 token：高四位为逻辑调色板组，低四位为色号。F7 代表组编号15、色号7（均从0编号）。Palette 返回 24 bit RGB；扫描模块按现有视频口的 R/B/G 字段排列输出，勿把原始端口字节序当成通用 RGB888 文件格式。

Scene 上传器计算 CRC 用于观测，但 Scene Header 没有资源包式的预期 CRC 字段；不能给 Scene 图示加一个“末尾 CRC”。资源包另有 64 B Header，包含 payload CRC32，软件和 RTL均进行相应检查；`palette_example.bin` 为 1,088 B 构造资源包。

## 6. 资源、视频和页面切换

资源更新先 `drain()`，之后等 accepted 计数和 committed_generation。Atlas 与 Tilemap 以渲染空闲作为提交条件；Palette 自己跨时钟等待消隐并回 ACK。**Palette 和 Framebuffer 不通过同一握手原子交换**，Palette 可以先于随后 Scene 的图像换页生效。

当前视频路径是 S2V1：开始时上传 Tilemap，每帧按“需要时 Palette → Atlas → Scene”串行工作。每个 Scene 同样等待呈现。FRAME8 虽在软件 ABI 中定义，当前 c4m7 core 路由到 unsupported 分支，本图不将它当作现用视频通路。

视频目标为 30 fps，扫描为 60 Hz；若 DMA/渲染落后，播放循环重置过期的调度目标，不积压无限追赶提交。实际视频表现还受读包、上传、Palette 换页和 PS 调度影响，不能直接从 100 MHz 推出视频 FPS。

菜单、游戏、视频借用同一个 sink。应用切换通过停止旧 producer、等待线程结束、drain、恢复目标资源后再提交新页面。低层 sink 不提供通用的多线程并发提交队列；图中的单一所有者是运行时协议。回传暂停页可由 sink 提交，随后停止应用交互/绘制，手圈由独立 OSD 覆盖。

## 7. 图表数据口径

112.5 KiB = 2 × 320 × 180 × 1 / 1024；337.5 KiB = 2 × 320 × 180 × 3 / 1024。前者为当前逻辑双缓冲容量，后者是同分辨率 RGB888 的计算对照，不是历史版本实测。比例为 1/3，等价减少 66.67% 的像素存储字节。

另有 PS 暂存、命令、Atlas、Tilemap、Palette 数值见 storage.csv。此表不相加成“总 BRAM 利用率”：PS 暂存属于 DDR，其余数值也未计元数据及 BRAM 分配粒度。

没有添加实测 FPS、DDR 吞吐、GPU 占用、功耗或端到端输入延迟。后续有当前 BUILD_ID 的性能记录时，应另画有样本数、场景、统计范围和单位的对比图。

## 8. 关键源码定位与解说顺序

| 问题 | 文件与标识符 |
|---|---|
| 帧何时能启动 | scene2d_c4m3_core.sv / renderer_start、upload_enabled |
| 前后台如何交换 | scene2d_frame_swap.sv / request_toggle、acknowledgement_toggle |
| 真正的换页信号 | scene2d_c4m3_core.sv / .frame_start(vblank_start) |
| Framebuffer 存什么 | scene2d_framebuffer.sv / MEMORY_SIZE、write_token |
| 上屏如何完成确认 | c6i_video.py / _retire_scene |
| 为何当前没有 P4 重叠 | c6i_backend.py / supports_upload_render_overlap；c6v.bd / core |
| Palette 如何提交 | scene2d_palette_store.sv / commit_pending、committed_generation |
| 视频如何逐帧使用 GPU | video_runtime.py / _play |
| 同一个 GPU 怎样借给各页面 | c6i_shell.py / _BorrowedSink、_stop_menu、_drain_sink |
| 参数与编码 | gpu_abi.py / SceneHeader、GpuCommand、pack_index4 |

视频建议依次高亮：① PS 只提交命令与资源；② PL 在 B 绘制同时读 A；③ 完成后等消隐，换前台，再等 ACK；④ 8 bit token 查表成 RGB；⑤ 手圈在扫描后独立叠加。动画中让“绘制结束”和“用户看到新帧”成为两个独立节点。
