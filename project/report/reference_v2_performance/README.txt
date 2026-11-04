阶段性能与资源对照资料

当前集成系统的三配置优化、完整构建命令和板测结果：../gpu_optimization.md
本目录保留 2026-10 的阶段实验，表内配置和测量范围随数值给出。
chapter.html 为可编辑正文，PDF 由该正文生成；data/ 保存数值和来源，figures/ 保存配图。
data/source_manifest.json 将每项数据对应到 evidence/ 内的报告或技术摘要。

从 project 目录执行：
python -m pip install reportlab beautifulsoup4
python report/render_reports.py
输出两份阶段性能 PDF；字体默认使用 Windows Microsoft YaHei，可通过 --font-dir 指定字体目录。
