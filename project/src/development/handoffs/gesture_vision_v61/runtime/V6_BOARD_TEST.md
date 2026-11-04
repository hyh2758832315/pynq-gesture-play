# v6 PL BGR/HSV 肤色前端上板流程

PYNQ-Z2 / Vivado2026.1。新 bit/HWH 是 camera_hand_skin_v6，不能搭配旧 v2 HWH。
保留 HDMI/OSD、原摄像头配置和六宫格。只停止测试程序，不关机、不重启。
v6 使用紧凑 BGR 输入，PL 做 HSV/肤色阈值；形态学、选目标/凸包/RPS仍是PS。
选中目标质心仍使用返回skin_mask与选中轮廓交集，不能用全部肤色质心代替。

## 1. 检查所有者、解压和软件测试

在Jupyter终端：

```bash
ps -ww -eo pid,ppid,stat,args | grep -E 'project1_live|capture_camera|run_camera_live|run_accel_guarded|verify_dma|verify_skin_dma'
```

只有grep自己才继续。若还有摄像头程序，在它所在终端Ctrl+C并等正常清理；不要kill -9、卸载overlay或重启板子。DMA无法halt时保存日志再咨询，不继续加载新bit。

```bash
cd /home/xilinx/jupyter_notebooks
unzip -n camera_skin_v6_test.zip -d camera_skin_v6_test
cd camera_skin_v6_test
/usr/local/share/pynq-venv/bin/python3 verify_package.py
/usr/local/share/pynq-venv/bin/python3 -m unittest discover -s . -p 'test_*.py'
```

预期PACKAGE_PASS、实际测试数量大于0且OK。本地测试不能替代上板。

## 2. 合成输入 DMA 同帧对照（先repeat 1）

```bash
cd /home/xilinx/jupyter_notebooks/camera_skin_v6_test
set -o pipefail
/usr/local/share/pynq-venv/bin/python3 -X faulthandler -u verify_skin_dma.py \
--bit "$PWD/camera_hand_skin_v6.bit" --repeat 1 \
2>&1 | tee skin_dma_minimal.log
echo "TEST_PIPESTATUS=${PIPESTATUS[*]}"
```

预期每项SKIN_DMA_SAME_FRAME_PASS、最后SKIN_DMA_BOARD_GOLDEN_PASS、TEST_PIPESTATUS=0 0。
异常或缺最后标记时发完整日志，不继续摄像头。通过后改--repeat 10再跑，日志另存skin_dma_repeat.log。
旧verify_dma.py针对HSV/gate协议，禁止用于此包。

## 3. 摄像头完整对照模式

```bash
cd /home/xilinx/jupyter_notebooks/camera_skin_v6_test
set -o pipefail
timeout --signal=INT 150s /usr/local/share/pynq-venv/bin/python3 -u \
"$PWD/run_accel_guarded.py" "$PWD/project1_live_ov5640.py" \
"$PWD/camera_hand_skin_v6.bit" "$PWD/first_frame.ppm" \
--live --tracking --pl-osd --pl-skin --pl-skin-mode validate --debug-view \
--capture-order bgr --rotate 180 --duration 60 --no-record \
--results-dir "$PWD/results" --bind 192.168.2.99 --port 8088 \
2>&1 | tee camera_skin_validate.log
echo "TEST_PIPESTATUS=${PIPESTATUS[*]}"
```

浏览器http://192.168.2.99:8088，HDMI须接好电源。此模式每帧仍执行PS黄金HSV及掩码比较，不能用其FPS证明净提速。
CSV pl_skin.same_frame_exact必须为true，任何掩码不一致立即停机；先发日志和CSV确认。
没有手的帧也验证PL前端。观察框、白色质心十字、六宫格肤色掩码、贴边释放控制。

## 4. 对照通过后才测性能

上述命令只把--pl-skin-mode改为performance、日志改camera_skin_performance.log。
此模式明确跳过重复PS HSV计算和旧第二次moments DMA；仍检查包长、魔数、帧ID、尺寸、像素数、状态、掩码值与padding。
pl_skin.same_frame_exact=null表明这一帧未软件对照，不是true、也不是失败。
使用同一动作流程比较inference_ms、capture_to_result_ms、pl_skin.total_ms和整体FPS。
更严格对照：在同一个v6 bit上去掉--pl-skin和--pl-skin-mode，用PS前端跑相同原始输入或动作流程，得到PS基线。两者均保持HDMI、六宫格、时长和画面尺寸相同；不要拿旧PL矩核全量验证的重复开销当作单独新核的加速比。
这些都不是曝光到游戏收到事件的真实端到端延迟。HDMI写入仍可能约90ms；不承诺仅换核即可达到30FPS。

文件输出results/project1_results_*/frames.csv、latest_debug.jpg、latest_overlay.jpg和run_config.json。
这次不用录AVI；测试后发日志和CSV即可。
