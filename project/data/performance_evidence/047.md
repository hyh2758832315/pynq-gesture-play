# v2.0 画板输入与菜单灵巧手跟随

类型：项目事实记录；项目：voice-view-game；板卡：PYNQ-Z2 xc7z020clg400-1。
路径：docs/bringup/2026-10-28_v2_canvas_menu.md；日期：2026-10-28。
应用层修复，沿用 R23b2 / Vivado 2026.1 / BUILD_ID 0xC0061000；不修改 RTL、Overlay、DMA、ABI。
Skill：仓库 xilinx-skill/plugins/voice-view-game-design/skills/voice-view-game-design/SKILL.md；部署副本 C:/Users/developer/.agents/skills/voice-view-game-design/SKILL.md；同时沿用 xilinx-suite 上板记录门禁。

## 离线定位与修复

- 红圈但不画：画板独立分类快照会否决已被菜单 UI 接受的握拳，尤其 FRAME_EDGE。改为使用同一新鲜、已授权的 ControlState 握拳；分类快照只作来源帧身份去重。真实 provider 的边缘握拳及来源过期已覆盖。
- 限频丢帧：66.7ms 限频前提前消费帧 ID，导致下一次 UI 轮询仍不能落笔。改为真正接受后消费，只处理最新帧，不排队。
- 悬停图形/大小改为四条 GPU 边框命令，复用背景与资源；绘制变化仍为固定 46,080 字节合并栅格，预览不烙入画布。
- 同页修订复用字体/场景模板；IndexedImage 校验用 max 替代逐像素 Python 生成器，仍拒绝超出 INDEX4 范围的像素。
- HOME/GAMES/VIDEOS 请求已有 live owner；画板/相册 idle、视频播放 PAUSED/OFF、展示 demo 的交接与预览互斥保留。
- 新增六项首轮全部 FAIL，定向修复后通过。完整相关回归第二轮 101 PASS（build/v2-regression-r02.xml）；首轮失败保留（build/v2-regression.xml），其中旧菜单测试坐标仍是历史纵向列表，已同步当前四卡片坐标；GPU 悬停发现尺寸文字与星形边框重叠，文字下移2px后像素对照通过。
- 首次测试仅因沙箱临时目录权限失败，改用 workspace build 作为 TEMP/TMP/basetemp；手串口测试解释器缺 scservo_sdk，需使用手子项目现有依赖环境，未改产品依赖绕过。

## 板端与发布

结果：PENDING。当前原服务 R60 r09；后续使用 Studio 标准停旧版、空间门禁、完整安装、身份回读及隔离自动化验收，收尾恢复正常入口和默认灵巧手。
测试通过后独立发布快照到原仓库 releases/v2.0，保留 v1.0 和共享工作区未提交工作；发布前不能标记整机 PASS。

已完成：R60 stop 回执确认17 OFF、视觉cleanup、owners=[]。R59/R60同SHA只读文件硬链接释放602,189,824字节，已备份并核验的R60上传缓存释放86,712,320字节，所有视频及安装/回滚目录保留；free=4,038,418,432字节，未降低Studio原空间门槛。已开始标准Studio按钮加载候选r01（manifest 56EDBF8C3B2FC3EF49573F41E7D0925A4F527AEEEF04499DAC9E38F36A06BD46）。

离线补充：现有真实SDK/本机UDP内存后端22项 unittest PASS，无实体串口。首次用PC沙箱解释器启动导致环境/UDP失败，正确手子项目解释器并启用本机UDP后通过，产品代码未据此盲改。Studio89项中88PASS、1项测试就绪文件“存在但尚未写完”的竞争失败；测试改为原子发布就绪文件，单实例3项复验PASS。四游戏全部回放资源预算PASS，最大资产32513字节、命令36条，均在冻结容量内。

PC性能对照：同解释器且共享新版通用图像校验，120次悬停上传120→1，单帧中位1.897→0.080ms；绘制中位1.866→1.567ms。仅为PC耗时证据，不能代替ARM或真人感受。原始 build/studio-v2/canvas-benchmark.json。

### 首次完整安装：上传完成，安装启动未确认

Studio原生按钮收据 games_gesture/.loads/d44167e8388c493dbc3e830fd2d16509/receipt.json，原始FAIL保留。停旧版、空间、归档和上传步骤完成；install阶段SSH提示“Connection timed out during banner exchange”。尚未获得installed/start收据，不能称为安装PASS。先只读核实原事务及板端持久日志，不重复上传、重载Overlay或强制终止。

只读确认原install未执行且无新目录/进程后，校验上传归档SHA df7ccb2c74d6913d1ac00016a7b25886653759753c1782116d2e707dec07d1e0，使用同事务3aa08ebbbdff4550b2016cdd7a25e35e执行原Studio install步骤，Agent/身份回读PASS（build/studio-v2/recovery/receipt.json），未二次上传。新版PID8195。随后原生Studio六内容门禁和安装回读PASS，收据 games_gesture/.loads/b11ede72a372485d8561b33d26431de1/receipt.json。

### R02 开机首次主菜单边界

代码复核发现：真正的手owner晚于首次refresh_catalog附加；仅改_select_page会漏首次开机。补充_complete_startup_locked在全部真实初始化检查结束后授权当前菜单live，再显示正常菜单；新增晚附加owner用例，56项画板/资源/启动检查PASS（build/v2-startup.xml）。R01不作为最终发行身份，准备R02标准完整升级，未改bitstream/手源/游戏包。

最终R02：manifest 5F53D85D5BCDB8C871D387683CBF7B6B12C899B380B9370642C9BD2FF41E9D56，标准原生Studio按钮整包安装PASS，收据 games_gesture/.loads/6deaf90426b441b7b3986c5302ff8904/receipt.json，事务8bb5a78b7ba540f5aa6d72b1ba614c71。针对首轮实际握手超时，PC端SystemLoader的SSH/SCP建连等待8→20秒，操作总期限/身份/停止/空间门禁保持；未增加盲重试。最终89项Studio回归PASS。生命周期旧测试计数未计入切页Loading帧，修正测试基线后23PASS；产品未据旧测试改动。

最终与R60差异仅 c6i_shell.py、scene.py、creative_pages.py、candidate_delta.json；全部overlay和四游戏包SHA相同。发行目录独立导入87项Studio检查PASS，便携板端check-only及原生Studio smoke/默认配套路径PASS。当前开始四游戏16回放PC/PYNQ逐tick对照，随后隔离创作页及实体菜单跟随交接验证，最终服务与发布仍PENDING。

## 2026-10-29 跨日继续验收

四游戏全部16条真实板端断言回放及PC/PYNQ逐tick对照PASS，结果 build/studio-v2/installed-game-checks.json。均使用Studio已验证同SHA包及普通Agent入口，每条结束正常返回菜单，未注入到真人会话。

安装PID8561已正常停止。当前SDK内存手/真实GPU创作页全链测试PID10847，远端 /home/xilinx/voice-view-game/v2-r02-gpu-a01，禁止物理串口打开；本地 build/studio-v2/gpu，仍同boot421244e3-aa52-4570-9cbb-9ef0390bb400 / R02 manifest。此轮尚未完成，等待原测试及正常重启/释放回执。

PID10847 功能部分60/60 PASS，含全部画板/临时相册、11示范姿态顺序及每项前default、示范中途返回后LIVE、四游戏暂停交接、真实WON/LOST结果/重玩、视频返回、主菜单继续/完整重启。已看到 UI_RESTART_CLEANUP_CONFIRMED，等待同PID第二次UI_SESSION_READY及最终释放；尚不把完整重启和释放标PASS。

GPU完整结果：60项功能PASS、同PID实际exec/第二次READY/相册及画布清空PASS、owners=[]。SDK内存后端确认全部OFF/关闭且播放阶段0反馈读取，实体串口禁止打开。原件 build/studio-v2/gpu/{board-checks,restart-evidence,board-release,memory-hand-release}.json。接下来独立v2实体菜单跟随有限协议测试（无新增真人机械目视结论），输出 build/studio-v2/physical。

GPU阶段进程CPU原始指标：canvas 146.55%、demo147.60%、idle-menu159.73%，均为整个父进程（包含视觉等线程）、以单核100%计，双核上限200%；峰值RSS196712KiB。这不是画板单函数占用，没有同条件R60 ARM基线，不能用它宣称整机CPU下降；优化证据分别是输入漏检复现/修复、背景上传计数与PC对照。板端实际持续画笔、缓存不增长、交接及重启均已通过。

实体协议阶段PID14294已完成18/18功能检查：启动17电机只读门禁、首次HOME直接LIVE、HOME/PAPER/GAMES/FIST/VIDEOS/SCISSORS三页对应且同child、画板进入确认OFF、独立分类UNKNOWN时UI握拳正常落笔、连续最新帧画笔、返回HOME恢复、真实JPEG回传前17OFF及关闭后同owner恢复、视频暂停OFF/返回恢复、主菜单完整重启请求。result=AUTOMATED_PASS_OBSERVATION_PENDING（机械姿态未新增真人目视签核）；已实际exec，等待第二次READY与最终两次串口会话17OFF/CLOSED回执。

实体闭环完成：18项协议、实际exec同PID第二次READY、相册/画板初始化和最终owners=[]全部PASS。当前收集两次真实串口会话的17OFF/CLOSED原件，随后恢复r02正常默认service；不将协议验证改写为真人机械目视通过。当前新代码自主测试链未发生产品失败，前述首次安装建连超时原件保留。

两次真实串口会话最终均CLOSED/17OFF/无error，原件 physical/physical-release.json。实体联合画笔测试45次更新含40个不同位置和5个重复位置，实际40次有效栅格修订、固定46080字节，6.317秒；独立分类为UNKNOWN而菜单UI握拳有效时也已在真实GPU链路成功落笔。该时间含测试线程取得UI锁等待，不作为摄像头到屏幕延迟指标。

正常服务已READY：同R02完整root，默认 bundled hand、真实摄像头、无实验会话总时限、无测试输入、无回传。原件 normal-start.json/normal-ready.json。现仅完成一次原生Studio重连/加载按钮和桌面默认候选路径检查，随后关闭部署客户端；不保留额外观察程序。

## 最终验收结果

2026-10-29：自主闭环PASS（机械姿态目视仍单独未签）。16条四游戏PC/PYNQ逐tick对照、60项真实GPU创作/示范/结果/重启、18项实体串口菜单跟随/交接、两次实际exec及17OFF/CLOSED、正常服务恢复全部通过。原生Studio重连0.108秒READY、内容和整包加载按钮可用，桌面默认候选已持久化为 build/ps-ui-v2-canvas-menu-r02；窗口关闭、active_qthreads=[]，不保留探针或回传。

正常状态：menu、serial-fixed-playback ACTIVE、child16782、max_seconds=null、preview=false。验收入口 build/studio-v2/acceptance-summary.json；正式软件身份以上述R02 SHA及原件为准。封存完整 v2.0 快照到独立发布克隆 releases/v2.0，保留v1.0和共享工作区未提交修改；GitHub发布及资产摘要将单独回读确认。
