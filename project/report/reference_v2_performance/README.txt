性能与资源报告
chapter.html 为可编辑正文；data/ 保存数值与来源，figures/ 保存图表。
从 project 目录运行：
python -m pip install reportlab beautifulsoup4
python report/render_reports.py
输出两份性能 PDF；使用 Windows Microsoft YaHei 字体，可通过 --font-dir 指定字体目录。
编译后检查页面布局。各表的阶段配置和测量范围随原始数据保留。
