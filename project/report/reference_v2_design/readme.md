# GESTURE PLAY 系统设计报告

正文介绍视觉流水线、帧生命周期、Scene2D、HDMI 覆盖及灵巧手接口。当前运行与部署入口见 [工程 README](../../README.md)，验证汇总见 [验证结果](../validation.md)。历史性能及功能实验保留原测量日期和配置。

- `gesture_play_v2_junior.pdf`：系统设计阅读版；文件名沿用现有链接。
- `main.tex`、`sections/design.tex`、`figures/*.tex`：可编辑 LaTeX 源文件与五张 TikZ 图。
- `report.md`：技术正文阅读副本。
- `evidence_index.json`：历史证据编号；包内定位见 [证据映射](../../data/reference_evidence_index.json)。

在本目录执行 `tectonic main.tex`，或连续执行两次 `xelatex -interaction=nonstopmode main.tex`，输出 `main.pdf`。文档使用 ctex、TikZ 及 Windows 中文字体；其他系统可将 fontset 改为其已安装的中文字体方案。编译后将 main.pdf 复制为阅读版，并检查中文显示与搜索。正文和图片由源文件生成，不使用 PDF 字体映射后处理。
