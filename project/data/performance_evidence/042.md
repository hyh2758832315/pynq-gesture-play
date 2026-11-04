# 工程观察与验证摘录

项目 `E:/projects/fpga/voice-view-game` 已满盘，后续证据暂存此获准目录和板端。不要为腾空间删除其他项目或历史资产。项目 `build/board_hand_source_age_20261025.py` 是满盘写入留下的零字节文件，不可执行；完整工具在本目录。

## 联合 r03 失败与回收

另跑原生产probe：17颗/85READ全部成功，torque全0、错误0、电压5.0–5.2V、温度19–24°C、port_closed=true。视觉停机frames1395/cleanup_confirmed=true；DMA halt及BD=0已核，子退出、fuser无owner。仅在这些证据齐全后，对确切故障父5482发KILL以释放锁，不伪装成正常进程退出。

原始证据：本目录 `r24-hand-motion-r03.json`、`r24-hand-parent-r03.json`、`r24-hand-stop-r03.json`、`r24-post-r03-readonly.json`。此前接收边界修复未解决全部实板过期原因，不得宣称根因修复成功。

## 无动作来源年龄 r01

运行本目录 `board_hand_source_age_20261025.py` 的板端副本。正常入口只把动作工厂替换为显式observation-only线程；原85READ门禁保留，不构造SDK动作后端，无使能。50ms记录一次真实provider副本，80秒后正常SIGINT退出。

无动作r01正常退出0，既有packet DMA reset-after-halt-timeout清理出现，之后只读确认两条DMA halt、BD=0。视觉单独运行未复现过期，下一步r02仅增加同一手venv/ORCA初始化与原85READ probe并发负载，不使能，比较年龄和更新间隔。

## 无动作来源年龄 r02 已启动

完整工具为本目录 `board_hand_source_age_r02_20261025.py`，已部署到板端同名文件。输出新目录为候选 `var/hand-source-age-r02`；trace.json和parallel-readonly.json/log待回收。线程观察期间启动独立原probe，仍由READ-only packet guard约束。不要把此实验当成真实手势动作验收。

r02已正常退出0。1445样本、age最大0.400659秒、p99为0.318517秒、超0.5秒0次，poll间隔最大0.102626秒，gesture均none。并发probe退出0、17颗/85READ通过、port_closed=true、5.858秒。原始证据回收到本目录hand-source-age-r02.json及hand-source-age-r02-readonly.json。随后DMA halt/BD=0再次确认。

## 无动作生产通道 r03

一次10.011秒的实际手侧/proc窗口：单核CPU约1.498%，RSS24145920字节（约23.0MiB）；窗口内包含何种动作占比没有独立标注，不能作为峰值、纯空闲、纯动作或相对旧版收益。

本目录原始回执：r24-hand-motion-r04.json、r24-hand-parent-r04.json、r24-hand-channel-audit-r04.json、r24-hand-stop-r04.json、r24-hand-result-r04.json；6个STATUS采样为r24-hand-vision-status-r04.json，frame1144→1718均ACTIVE/error=null。
