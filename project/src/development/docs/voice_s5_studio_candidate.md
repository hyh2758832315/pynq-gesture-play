# S5 Studio 声视融合离线候选

身份：0xC0060900 / C6I_VISION_VOICE_S3。runtime_registered=false、board_pending=true、release_ready=false。

Windows Python3.13.2相关15模块357项通过；Linux x86_64 Python3.10.21无GUI10模块279项通过。真实TCP/Qt/合成视觉/fake GPU/有限合成PCM/真实CPU子进程验证四候选部署、切局、观察与清理；原生Windows Qt6.11.2/363字体、1440x900及1080x700验收通过。截图中的PCM为合成显示fixture，Scene为离线fake GPU完成回执。

## PC 入口

解包后在包根创建`.venv`，安装`PySide6>=6.7,<7`和`numpy>=1.21,<3`；纯Python基础依赖已在python目录内携带。运行`start_studio_900.bat`，默认没有主机地址，不连接板卡、不自动订阅相机。原800启动脚本未变。

也可设置PYTHONPATH为包根python目录，再运行：

```powershell
.\.venv\Scripts\python.exe -B -m pynq_multimodal_game.studio.app --agent-build-id 0xC0060900
```

实际连接在取得独立板测授权后，通过PYNQ设置显式选择900候选与主机/source address；融合视觉控制跟随主Agent端口，相机为8081。HELLO与回执须匹配900/profile/声音schema，原默认视觉入口继续拒绝900。

## 观察与门禁

- Audio只发送STATUS，最新PCM保留240个int16点、每4点抽样；波形20ms，频谱标为0-6kHz抽样诊断，真实采样率待板测。
- Qt观察单槽latest-wins；重复PCM不续新鲜度，换epoch清旧图，停止或断线保留历史。观察跳包与采集丢包分开；年龄由板端计算，无跨机单调时钟相减。
- 停止观察/关闭Studio不隐式停止板端声音或视觉；线程未确认退出保留引用并延后切连接/关窗。
- Game显示声音识别、策略批准、实际游戏效果及同整数tick/有效SHA的Scene确认，分别判断。声音候选按manifest.vision_mapping校验视觉能力，完成回执仍保留已验证候选包身份。
- schema3时间线完整保留VOICE事实、健康、seed及显式tick时间；回放与现场输入隔离。
- 900游戏生命周期请求预算75秒，是60秒准备、10秒清理及余量的等待上界，不是实测响应时间。STATUS和观察保留短超时，700/800行为保持；超时不自动重试或推断板端停止。

## 板端边界

`start_board_test.py --check-only`仅验证本包SHA/合同，默认入口拒绝硬件操作。包中四VVG均为900目标、双构建/断言黄金验证。bit/HWH/XSA/DCP及CPU33源保持冻结身份。

本轮没有SSH、Overlay加载、实际reset、录音、Vivado运行或生产发布。S4真实声音/视觉/HDMI、ARM、DMA释放、实际48k/20ms及识别新鲜度/时延，S5断PC运行及S6长期稳态均需独立实板证据；game3真实pitch仍待交付。