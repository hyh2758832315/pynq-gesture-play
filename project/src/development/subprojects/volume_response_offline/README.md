# 人声音量响应：证据与数字边界验证

当前约束（2026-10-24）：板卡交给另一对话，本任务仅离线仿真，禁止包括只读 SSH/STATUS 在内的任何板端访问。用户允许配置必要的本机仿真环境。最新闭环工作见 [完整数字链路仿真记录](../../docs/bringup/2026-10-24_volume_full_cosim.md)；此前“板卡已释放”均为历史事实，不是当前使用许可。

新增保存数据复核：`analyze_codec_ab_events.py` 在 A13 项目 Codec 配置近讲原始 PCM 上推演出窗口228的一次 LOUD（4.563秒）；同一状态机推演器与 A11 冻结 RTL XSim 的10个事件窗口/种类完全一致，见 `build/volume-response/codec-ab-events-r03/receipt.json`。这说明“项目 Codec 配置必然无声”不成立；A13未装载 R20 PL，不能据此断言集成版 SDATA/PS/HDMI 正常，也不能将短促越线窗等同技能事件。详细定位分叉记于事实记录 A24。

更贴近现场音源的闭环：A13 项目 Codec 配置近讲原始 PCM 已在 `cosim-production-project-human-r03` 经原数字链得到 1 次硬件事件/驱动 ACK 和可见的 HDMI 音量条；39111 样本、40 窗、48 帧及 172800 像素断言全部通过。此处“硬件事件”指 XSim 中的原 RTL，不是实板观察。r01 的 XSim 编译失败和 r02 的测试台误断言均保留，r03 核相同 RTL SHA 复用已通过的编译快照；详见完整数字链路记录的新 A13 小节。生产代码/位流仍未更改。

轮询相位界限：`analyze_poll_visibility.py` 把 r03 的80.036 ms连续LOUD窗口与历史安静菜单最大38.218 ms轮询间隔对照；在同样间隔且事件处理<61.782 ms、OSD不中断的条件下，该声音既应ACK又至少有一帧可见。收据 `poll-visibility-r01/receipt.json`。这不是近讲时真实负载的测量，具体判别见事实记录A26。

历史实板对照见事实记录A21–A22：R20真实PL在Codec ADC -48dB时约6→0.5，PGA 21→35.25dB时约6→18；官方Base原始PCM计算也约5.9→18.1→5.9。增益/采样链有响应，但当时远处电脑刺激在两者中都没有明显声音响应。不可直接增益拉满：安静底噪18已超过SOFT16。当轮板卡已释放，近讲R20测试尚未完成，生产配置未修改；当前板卡由另一对话使用。

新增独立工具：`verified_speaker.py`验证本进程/主音量及数字端点峰值；`isolate_codec_pl.py`在原R20仅开启音量通路做8阶段诊断；`isolate_base_pcm.py`用官方Base录制三阶段原始PCM；`analyze_base_pga.py`离线对比频带；`reboot_audio_isolation.py`核同一完成收据与无owner后发一次正常重启。每个文件docstring包含命令和产物，输出目录必须唯一，板端入口需要新门禁。

现场近讲专用入口已准备但尚未运行：

```powershell
.venv/Scripts/python subprojects/volume_response_offline/isolate_codec_pl.py --gate <新的空闲门禁.json> --output build/volume-response/codec-pl-human-a01 --human-voice --run
```

该模式只保持原增益/门槛，30秒采样并记录硬件事件/ACK，单次短提示后PC静音。它不会验证游戏技能或HDMI覆盖；需要有人近讲并留停顿，不能把自动远处外放当作同等输入。去掉`--run`只检查源码，不访问硬件。

本目录包含独立的离线仿真、官方Base采样、受门禁保护的板端测试、只读STATUS观察脚本；各脚本权限不同，不能把整个目录当成纯离线工具。生产源码和冻结R20交付包保持不变。目标板为PYNQ-Z2 / xc7z020clg400-1，Vivado2026.1。板端owner/boot与预约状态必须以[板卡预约记录](../../docs/bringup/2026-10-23_pynq-z2_board_reservation.md)最新条目为准，不能沿用旧PID。

事实记录：[volume_response.md](../../docs/bringup/2026-10-23_pynq-z2_volume_response.md)。目标是区分模拟声路弱、幅值/单位错误、连续窗与重武装资格、游戏消费四类问题。数字仿真不能证明耳麦采到有效人声。

## 运行

工作区根目录PowerShell：

```powershell
.\.venv\Scripts\python.exe subprojects/volume_response_offline/audit.py --output build/volume-response/audit-r01
.\.venv\Scripts\python.exe subprojects/volume_response_offline/run_xsim.py --bin D:/Xilinx/Vivado/2026.1/Vivado/bin --baseline build/volume-response/audit-r01 --output build/volume-response/xsim-r02
.\.venv\Scripts\python.exe subprojects/volume_response_offline/replay_human_i2s.py --root build/volume-response/acoustic-a03-human --output build/volume-response/human-i2s-r03 --bin D:/Xilinx/Vivado/2026.1/Vivado/bin
```

以上输出目录已存在，复跑应使用新的轮次目录，不覆盖原证据。audit只读冻结R20源码/manifest及既有R14/R20 JSON，生成audit.json与音频RTL源码副本；该副本与c0d导入源码相同，不是R20位流等价证明。run_xsim只使用冻结副本和本目录testbench，生成step-0/1/2.log及绑定SHA的receipt.json。

## 当前实跑结果

审计通过；R14原30次播放中仅1次试验累计ACK增加，旧灵敏度验收本已待定。R20保存的实时game1-volume-v1窗口多为低幅值，无实时技能消费证据。

XSim r01在沙箱内生成C编译失败，原失败保留；相同源码/参数在经审批的本机环境r02运行通过8项：弱信号不过线、中幅SOFT、100/640/3000Hz强信号LOUD、单个20ms窗越线不触发、背景过quiet阻塞重武装、quiet恢复后再次触发。真人原始PCM另经冻结R20 I2S接收器按实际位时钟分频仿真，1954采样逐字通过，见`human-i2s-r03/receipt.json`。全部属于数字源表征；无模拟Codec、耳麦或物理延迟验收。

## 下一步

官方Base近讲真人声在原始PCM中有大量SOFT/LOUD越线窗口；相同PCM经原RTL数字核离线回放可产生事件。官方Base对远处电脑扬声器无明显响应；当前R20默认菜单的PL窗口→PS page→OSD/STATUS活跃，但真正100%电脑扬声器刺激仍只呈低噪声。详见事实记录A11–A17及`build/volume-response/integrated-r20-control-a01/speaker-max-a02.json`。电脑音频API播放完成不等于麦克风有足够声压。下一步为相同耳麦近讲时R20的连续窗口→事件→ACK→游戏消费测量；用户暂不在场时优先离线检查串行I2S与Codec边界。现有VOL1不提供PCM出口，不能在运行的R20上另起Base采集；未定位输入幅值前不盲调生产门槛或增益。
