# 默认视频 SUNSET

项目原创像素海景：夕阳、帆船、云和水面微动；无外部素材和音轨。6 秒无缝循环，320×180、30 fps、180 帧。固定全片调色板，使用既有 S2V1/INDEX4 播放路径，板端只读预编码 packet，不运行 MP4 解码器或素材生成器。

文件：`default-sunset.s2v`，6,435,242 B，SHA-256 `b299cf0a2d58af811a93ea8def4c84307344dc7911bb903f4b19e1ad8bc0dff0`。

在仓库根目录重建：

```powershell
.venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/build_default_video.py --preview build/default-sunset-preview.mp4
```

PC 需要已有 NumPy；可选 MP4 预览需要 PyAV。生成 `.s2v` 后运行 `build_deployment_candidate.py --output build/<新候选目录>`；部署 manifest 包含完整素材 SHA。正常启动只补装缺失的 `default-sunset`，保留兼容的用户替换；`--check-only` 只校验、不创建素材库。素材损坏或同 ID 合同不匹配时报告错误，不覆盖。

进入 HDMI 的 VIDEO 页，选择 SUNSET 并握拳开始循环；现有左上返回按钮停留 2 秒退出。未播放时只有磁盘占用，没有新增后台线程。当前物理 HDMI 观感单独验收。
