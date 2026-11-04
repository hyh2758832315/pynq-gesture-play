# 手势视觉 v6.1 仓库交接

本页记录 2026-10-05 的独立视觉归档边界。最新共享融合与原生 Studio 接续请先读[2026-10-06 融合交付](../handoffs/vision_fusion_20261006/README.md)，其候选 BUILD_ID 为 0xC0060800；本页以下的独立 bitstream 和 8088 合同作为冻结来源保留。

独立归档时仅保存已运行稳定的视觉版本，当时未实现游戏适配器或修改 Studio/GPU 主线。

2026-10-05最新接入优先级：视觉先行，声音延后；后续按[视觉Studio–PS–PL阶段方案](vision_first_studio_ps_pl_plan.md)开展观察、受控PS生命周期、语义验证及单Overlay闭环。原冻结交接和上述归档行为保持可追溯。

## 队友阅读顺序

1. [交接 README](../handoffs/gesture_vision_v61/README.md)。
2. [游戏控制 HTTP 合同](../handoffs/gesture_vision_v61/docs/GAME_INTERFACE.md)：方向、事件去重、断网/过期释放。
3. [启动与回退](../handoffs/gesture_vision_v61/docs/QUICKSTART.md)。
4. [验收与性能范围](../handoffs/gesture_vision_v61/docs/VALIDATION.md)。
5. [依赖与许可](../handoffs/gesture_vision_v61/docs/DEPENDENCIES_AND_LICENSES.md)。

队友电脑的最小读取示例（Python 3.10+，标准库，无键盘注入）：

```bash
python handoffs/gesture_vision_v61/examples/control_receiver.py --url http://192.168.2.99:8088/result.json
python -m unittest discover -s handoffs/gesture_vision_v61/examples -p 'test_*.py'
python handoffs/gesture_vision_v61/scripts/verify_handoff.py
```

输出为 direction/action_event JSON；游戏端自行映射，按游戏每帧时间更新运动。网络/无手/边界/过期必须停止移动。首次连接不重放旧动作。浏览器跨域接入需要代理或服务桥接，当前板端没有 CORS、认证或 TLS。

## 同板硬件边界

视觉发布使用 `camera_hand_skin_v6.bit`，游戏主线使用另一套 GPU 设计。PYNQ 的整个 PL 重配置会替换原设计，不能分别启动两个 Overlay 就当作同时运行。当前可交接的是板端视觉 → 上位机 JSON → PC 游戏接口；同板 PL 合并、地址/时钟/DDR 带宽与 PS 所有权协调属于后续独立工作，参见[已有同板整合分析](same_board_multimodal_studio_integration_analysis.md)。

不要为测试此交接资料自动关闭/重启板子；真实加载前先停止原硬件所有者，按板端说明操作。

## 保留原始身份

`handoffs/gesture_vision_v61/handoff_manifest.json` 校验冻结资料。该目录使用 Git `-text`，避免检出换行转换破坏哈希。包含原始部署 ZIP 和验证日志，不包含开发环境、工具安装、视频媒体或凭据。源码工程快照的可复现性限制详见架构文档；未宣称全新电脑无依赖即可重建。

仓库已有 `board/pynq_z2/capture_camera_direct_plug.py`，但本次未证明它与既有板端摄像头模块逐字相同，不能直接替换已经跑通的板端模块。先继续使用已验证环境。
