# 板端启动与回退

适用于已经部署摄像头工程的PYNQ-Z2。新板环境先看DEPENDENCIES_AND_LICENSES.md。
不要关机、重启、kill -9，或在另一个程序占用DMA时加载overlay。

## 1. 首次部署

将 releases/camera_host_v61_test.zip 上传到Jupyter根目录。

```bash
ps -ww -eo pid,ppid,stat,args | grep -E 'project1_live|capture_camera|run_camera_live|run_accel_guarded|verify_skin_dma|verify_dma'
```

只有grep本身才继续；旧程序还在运行时，在它自己的终端Ctrl+C，等正常清理。

```bash
cd /home/xilinx/jupyter_notebooks
unzip -n camera_host_v61_test.zip -d camera_host_v61_test
cd camera_host_v61_test
/usr/local/share/pynq-venv/bin/python3 verify_package.py
/usr/local/share/pynq-venv/bin/python3 -m unittest discover -s . -p 'test_*.py'
```

预期PACKAGE_PASS、82 tests、OK。测试包含故意触发参数冲突的错误提示和模拟采集；这些不是真实摄像头运行或速度。

## 2. 仅上位机运行

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

看到PROJECT1_READY后打开 http://192.168.2.99:8088/ 。采集和处理运行60秒，overlay/传感器启动时间不计入60秒。
仅上位机模式日志为HOST_ONLY、HDMI_ENABLED=0、PROJECT1_HDMI_SKIPPED。
CSV的display_write_ms=0、hdmi_enabled=False、pl_osd_applied=False；性能模式same_frame_exact=null不是错误。
等待PROJECT1_STOPPED和ACCEL_CHILD_EXIT=0。输出 results/project1_results_*/frames.csv、run_config.json、control_config.json、latest_debug.jpg、latest_overlay.jpg、latest_mask.png；不录AVI。
调试六宫格最多1Hz，不是每个推理帧都刷新。实时JPEG编码节拍最多约5Hz，不等于推理或摄像头原生帧率。

## 3. 验证/回退

- 同帧对照：将performance改validate；每帧额外计算PS黄金掩码，不用于净性能比较。
- HDMI回退：删除 --host-only，加入 --pl-osd，并换日志文件名。--host-only和--pl-osd互斥。
- PS前端基线：删除 --pl-skin 和 --pl-skin-mode performance，保留host-only与其余设置。沿用同一bit进行比较。
- 同一时间只能一个摄像头/DMA所有者。运行时长1..600秒，不是永久服务；游戏联调可明确改--duration 300。

## 4. 停止与异常

在当前终端Ctrl+C并等正常清理。guard会在必要时停DMA；身份不明或DMA停不下来时可能保留暂停子进程及映射缓冲区，先保存日志，不自行kill或重启。
正常退出后偶见ACCEL_GUARD_SKIP表示父进程无法确认当前overlay身份而不冒险访问MMIO；它不等于已由父进程确认DMA halt，需同时查看子进程清理是否完成。
没有视频时先查READY、端口、板子IP和浏览器网络，不要改掉已跑通的传感器表或重刷系统。
