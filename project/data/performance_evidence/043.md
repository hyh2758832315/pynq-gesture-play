# Studio 播放/停止与板端实际回传需求验证（2026-10-25）

项目级上板事实记录，voice-view-game，PYNQ-Z2/xc7z020clg400-1，Vivado2026.1，`0xC0061000`。Skill源/部署参考分别为 `xilinx-skill/plugins/xilinx-suite/references/board_bringup_record_template.md` 与 `~/.agents/skills/xilinx-suite/references/board_bringup_record_template.md`。当前结果：图像回传需求/编码控制PASS，诊断PC收尾权限错误已单独修正并完成正常退出；整项目仍待真实手及HDMI验收。

## 范围与身份

生产包不变，使用上一轮手姿态候选 `ps-ui-r24-hand-pose-ui-20261025-board-candidate`，部署清单SHA `0218B961074078794E6A23F4450DE9BC24EE15F4A20FF240F62D57DD5737A435`。本轮不启用串口owner或实际手动作，不修改生产包、RTL、MMIO探针或识别算法。

一次性 `build/board_preview_demand_probe_20261025.py` 在正常backend.open后，每0.5秒读取现有对象中的HTTP客户端数、需求模式、JPEG生成序号和编码器统计，写独立var目录，最多120秒；不读DMA图像或额外MMIO，也不制造预览需求。PC使用真实Studio按钮执行两轮播放/停止，采样之间仍处理Qt事件。停止后要求两次采样均无客户端/需求、pending=0、编码与JPEG序号不增长，同时视觉源帧继续增长。

上传前SSH枚举无Agent/诊断/spawn/手侧进程，SCP脚本到 `/home/xilinx/voice-view-game/board_preview_demand_probe_20261025.py`，退出码0。板端沿用 `/usr/local/share/pynq-venv/bin/python` 3.10.4；无新手侧源码部署。

## r01播放/停止与诊断关闭标记错误

正常启动摄像头ID0x5640 PASS，Agent监听8765。真实Studio初始两次采样clients=0/encoded=0/pending=0；第一轮播放clients=1/encoded=8，停止后两次采样encoded均9、clients=0/pending=0；第二轮播放clients=1/encoded=15，停止后两次采样encoded均16、clients=0/pending=0。图像控制断言全部通过，PC原始JSON已保存。

PC脚本最后执行普通用户 `touch .../var/preview-demand-r01/finish.request` 失败（Permission denied），因此脚本整体退出码1。原因是诊断目录由sudo启动的板端进程创建；这是一次性诊断关闭请求的权限遗漏，不能把脚本整体报为PASS，也不是生产预览停止失败。生产包未改。板端监视进程仍在运行，下一步用 `sudo -n touch` 发送同一个正常SIGINT结束请求，再核对停止回执。

### 收尾修正与原始证据

补发 `ssh pynq-z2 'sudo -n touch /home/xilinx/voice-view-game/ps-ui-r24-hand-pose-ui-20261025-board-candidate/var/preview-demand-r01/finish.request'`，退出码0。板端随后输出 `CAPTURE_PACKET_DMA_STOP_MODE=reset-after-halt-timeout`，诊断结果为reason=pc_finished/error=null/agent_exit=0，共221个采样。PC脚本已改用相同sudo命令，并在收尾失败时将结果记录为FAIL；本轮没有重跑整套PC脚本，保留原退出码1的事实。

原始文件：[Studio八次采样](../../build/r24-studio-preview-demand-20261025.json)、[板端221次采样](../../build/r24-preview-demand-board-r01/history.json)、[板端最终结果](../../build/r24-preview-demand-board-r01/result.json)、[退出回执](../../build/r24-preview-demand-board-r01/stop_receipt.json)。PC JSON中的PASS指图像控制断言，不能替代上述脚本收尾记录。

| 阶段 | 视频客户端 | 已编码帧 | 待处理 | 视觉源帧 |
|---|---:|---:|---:|---:|
| 默认关闭a/b | 0/0 | 0/0 | 0/0 | 756/820 |
| 第一次播放 | 1 | 8 | 0 | 845 |
| 第一次停止a/b | 0/0 | 9/9 | 0/0 | 900/965 |
| 第二次播放 | 1 | 15 | 1 | 985 |
| 第二次停止a/b | 0/0 | 16/16 | 0/0 | 1044/1099 |

两次停止后的需求模式均为空；停播初期允许已提交的一帧完成，所以计数从8到9、15到16，然后保持。最后一次视频客户端消失且待处理清零后，连续约68.994秒编码数和JPEG生成序号不再增加；同期间视觉源帧增加1619。这证明PC停止后，板端停止新增预览编码/推流，同时采集识别继续供HDMI/游戏使用。预览编码进程仍保留待命，不把“进程还在”解释为继续回传。

最终退出回执为2615帧、`cleanup_confirmed=true`、error/diagnostic_error均null。结束后无诊断/Agent/spawn进程、8765/8081无监听；frame DMA `0x00010002/0x00011001`，moments DMA `0x00010002/0x00010009`，当前与尾BD均零。板卡已释放；本轮没有启用实体手。

## 复核与后续

板端运行命令：

```text
sudo -n /usr/local/share/pynq-venv/bin/python -B /home/xilinx/voice-view-game/board_preview_demand_probe_20261025.py /home/xilinx/voice-view-game/ps-ui-r24-hand-pose-ui-20261025-board-candidate
```

PC运行命令：

```powershell
$env:QT_QPA_PLATFORM='windows'
.venv/Scripts/python.exe -B build/studio_preview_demand_probe_20261025.py
```

诊断r01目录是一次性原始证据，禁止直接重跑覆盖。需要复核时应先给两个脚本选择新的诊断目录，再确认板卡空闲。本文验证范围是相机JPEG回传，不替代物理手、HDMI实屏、手势停留返回或整项目时延验收；无须为本次成功的回传控制修改生产代码。
