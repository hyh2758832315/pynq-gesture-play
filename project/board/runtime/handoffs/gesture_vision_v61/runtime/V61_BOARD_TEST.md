# v6.1 仅上位机预览

PYNQ-Z2 / Vivado 2026.1。沿用v6原bit/HWH，硬件设计未变。
新增 --host-only。默认仍为HDMI；两种模式均保留浏览器预览、六宫格、控制JSON、CSV与原始首帧。
host-only不获取/配置/启动HDMI写通道，不分配输出帧、不执行显示像素转换或写入。
PL OSD不初始化、不等待显示SOF；浏览器框和质心仍由PS绘制。--host-only 与 --pl-osd互斥。
不改变摄像头、PL肤色处理、旋转/镜像及控制安全策略。没有连接外部游戏、没有承诺实测提速。
guard仍会在清理时检查/停止两个DMA通道，这是安全收尾，不是启动HDMI。
旧v6版本保留。本包不自动重启、关机或修改网络配置。

## 1. 软件检查

先在原程序终端Ctrl+C，等待正常退出。不要kill -9或重新加载另一overlay。

```bash
ps -ww -eo pid,ppid,stat,args | grep -E 'project1_live|capture_camera|run_camera_live|run_accel_guarded|verify_skin_dma|verify_dma'
```

只有grep自己才继续。若仍有进程或DMA停止失败，先保存日志咨询。

```bash
cd /home/xilinx/jupyter_notebooks
unzip -n camera_host_v61_test.zip -d camera_host_v61_test
cd camera_host_v61_test
/usr/local/share/pynq-venv/bin/python3 verify_package.py
/usr/local/share/pynq-venv/bin/python3 -m unittest discover -s . -p 'test_*.py'
```

预期PACKAGE_PASS，82项测试OK。单元测试不等于上板速度。

## 2. 仅上位机性能测试

```bash
cd /home/xilinx/jupyter_notebooks/camera_host_v61_test
set -o pipefail
timeout --signal=INT 150s /usr/local/share/pynq-venv/bin/python3 -u \
"$PWD/run_accel_guarded.py" "$PWD/project1_live_ov5640.py" \
"$PWD/camera_hand_skin_v6.bit" "$PWD/first_frame.ppm" \
--live --tracking --host-only --pl-skin --pl-skin-mode performance --debug-view \
--capture-order bgr --rotate 180 --duration 60 --no-record \
--results-dir "$PWD/results" --bind 192.168.2.99 --port 8088 \
2>&1 | tee camera_host_performance.log
echo "TEST_PIPESTATUS=${PIPESTATUS[*]}"
```

打开 http://192.168.2.99:8088/，进行和上一轮相同动作。
预期HOST_ONLY、HDMI_ENABLED=0、PROJECT1_HDMI_SKIPPED。
CSV每帧hdmi_enabled=False、display_write_ms=0、pl_osd_applied=False；same_frame_exact=null为性能模式正常标记。
浏览器必须正常更新原画面/标注、六宫格和control；无手/贴边/过期应释放控制。
等待正常清理与ACCEL_CHILD_EXIT=0，发camera_host_performance.log和本轮results/project1_results_*/frames.csv。
记录帧率、inference_ms、capture_to_result_ms、cycle_to_log_ms；捕获计时不代表曝光到游戏端完整延迟。
实际速度需上板测试，六宫格/JPEG仍有CPU开销。需要黄金对照时把performance改成validate。

## 3. HDMI回退对照

使用同一命令，删除 --host-only，加入 --pl-osd，日志改camera_hdmi_compare.log。
不换bit，不重启。默认HDMI路径保留，但从上一程序退出后再启动。
