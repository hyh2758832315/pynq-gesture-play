# v7 三游戏手势接入候选

基线：用户已选定的 v6 performance；独立目录，不覆盖 v6/r8 或系统库。
目标：PYNQ-Z2 / PYNQ 3.1 / Vivado 2026.1 冻结硬件 / BUILD_ID 0xC0060800。
只改进程内输入适配，不改 bit/HWH、算法、DMA、门限、游戏源码或声控输入。

## 映射

- 游戏一：原 v6 四向移动、回中心停止、张手→握拳一次跳跃，完全保留。
- 游戏二：稳定 0/2/5 对应石头/剪刀/布；与同帧 RPS 标签一致才输出
  hand_gesture。PENDING/UNKNOWN/不一致/无手/过期不沿用旧出拳。
  保持手势供游戏采样；握拳是出拳，不要求先张手，也不转成跳跃。
  游戏原有稳定等待、倒计时、三局胜负规则不改。倒计时按游戏 tick 运行，
  实际 tick 率低于名义 60 Hz，不能承诺真实墙钟 3 秒结束倒计时。
- 游戏三：左右选男/女；稳定张手后握拳确认开始；之后左右移动、
  回中心停止、张手→握拳跳跃。确认动作不同时跳一下，由原游戏规则处理。
  结束后原规则等待至少 60 个游戏 tick，再以新张手→握拳返回选人。
  上下不控制平台角色；原声音机关/升降台仍需要声音输入，这次不接入音频。

分类通过 board worker 的 controller 在本地 provider 发布前携带，同一帧、
同 run/config epoch 原子采样；不读取 PC 预览或 HTTP 结果来控制游戏。
按已验证 VVG manifest.game_id 路由，未知游戏沿用原输入。
测试回放仍使用独立 replay 输入，不能将其成功计为真人手势通过。
v6 单阶段预览、准入时钟和 performance 策略保持不变。

## 第一步：上传并只预检（现有 v6 可继续运行）

上传 camera_control_games_v7.zip 至 /home/xilinx/jupyter_notebooks，然后执行：

```bash
cd /home/xilinx/jupyter_notebooks &&
unzip -n camera_control_games_v7.zip -d camera_control_games_v7 &&
/usr/local/share/pynq-venv/bin/python -B \
/home/xilinx/jupyter_notebooks/camera_control_games_v7/start_games_board_test.py \
--mode performance --check-only
```

预期 GAME_INPUT=...、VISION_MODE=PERFORMANCE、PREFLIGHT_PASS。
此步不启动服务、下载硬件、安装游戏或停止 v6。输出解压目录中的 Python
启动器、适配模块、测试、许可证及本 README，没有新硬件输出文件。

## 后续切换（收到指导并正常清理 v6 后）

回菜单、关闭两路回传、停止视觉并确认 cleanup_confirmed=true/owner_held=false。
核对监听 PID 后 SIGTERM，确认进程和 8765 端口释放；不要强杀或双实例。

```bash
/usr/local/share/pynq-venv/bin/python -B -u \
/home/xilinx/jupyter_notebooks/camera_control_games_v7/start_games_board_test.py \
--mode performance
```

预期 voice-view-agent listening on 192.168.2.99:8765；保持终端。
实际运行生成本包 persistent_pair_C0060800 的已核验 bit/HWH 副本及原运行日志。
不要删除旧 persistent_pair，PYNQ 全局状态可能仍引用它们。

Studio 重新连接、启动视觉；Game 执行目标 PYNQ、输入模式“实时视觉”。
选游戏二/三后点“装载并运行”，Studio 为融合 BUILD_ID 构建和安装包；
不要选测试回放作为输入。不需要修改 PC Studio。
只做一轮短确认：游戏二三种手势/无手释放，游戏三选人/确认/移动/跳跃，
再快速确认游戏一未回归。不重做 A/B/C/D 性能测试。

## 回退

正常完整清理 v7 后，重新启动原 v6：

```bash
/usr/local/share/pynq-venv/bin/python -B -u \
/home/xilinx/jupyter_notebooks/camera_control_preview_v6/start_scheduled_preview_board_test.py \
--mode performance
```

validation 仍是默认模式；performance 必须显式选择。PC 测试和预检不等于上板验收。
