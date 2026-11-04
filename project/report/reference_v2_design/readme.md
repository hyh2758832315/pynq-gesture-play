# GESTURE PLAY v2.0 初级组系统设计报告

本文按官方自主选题指南的初级组重点编写，包含设计原理与功能框图、软硬件划分依据与接口设计。正文展示已实现功能、模块设计与实板验收；版本及测试口径集中于附录。

## 阅读与编辑

- `gesture_play_v2_junior.pdf`：正式阅读版，19 页，含封面、目录、五张可编辑矢量框图和详细接口表。
- `main.tex`：主文档，直接编译即可；无需先运行 Python。
- `sections/design.tex`：正文，可直接修改。
- `figures/*.tex`：TikZ 框图，可直接修改模块、连线和文字。
- `report.md`：正文的 Markdown 阅读副本。
- `evidence_index.json`：源码、实现报告和验收证据的路径与 SHA-256 索引。
- `sources/open_topic_guide.md`：2026-10-30 从用户指定官方 Gitee 仓库读取的指南。

## 编译

在本目录运行以下任一方式：

```powershell
tectonic main.tex
```

或使用 TeX Live / MiKTeX 的 XeLaTeX 连续编译两次：

```powershell
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex
```

预期输出 `main.pdf`。首次编译需要完整 TeX 环境，或允许 Tectonic 下载缺失宏包。文档使用 ctexart、Fandol 字体、TikZ、longtable、hyperref 与 xurl；没有系统绝对字体路径和外部图片依赖。

Codex 中直接打开本项目目录，可使用内置 LaTeX 编辑器与 PDF 预览。直接修改 `sections/design.tex` 后重新编译即可查看结果。

## PDF 文本检索

当前 Tectonic 0.17.0 导出的部分 Fandol 字体缺少 Unicode 映射。交付阅读版已补齐中文文本映射，页面外观保持一致。如本地重新编译后也遇到搜索或复制中文异常，可用附带工具：

```powershell
python tools/repair_pdf_unicode.py main.pdf gesture_play_v2_junior.pdf
```

依赖 Python 包 `pypdf` 和 `fonttools`；工具复用自本仓库 `report/gpu_midterm/tools/repair_pdf_unicode.py`。可传入 `--font-dir` 指向 Fandol 字体目录。预期输出为可搜索中文的正式 PDF，随后检查页面与目录。

## 来源与范围

硬件基线为 R23b2、BUILD_ID 0xC0061000，软件为封存 v2.0 与 R09 灵巧手运行时。证据索引中的项目路径相对于原工程根目录；源码压缩包提供报告编译所需材料，工程源码和原始实测记录由原项目交付。

官方指南：https://gitee.com/Vickyiii/fpgachina26-amd/blob/master/tracks/open-topic/GUIDE.md

`tools/compose_report.py` 为原工程中的编稿辅助程序，依赖原报告和冻结发布目录，故不纳入独立 LaTeX 源码包。独立包中已经包含完整生成后的正文；不需要运行此程序。

## 本次检查

- Codex 内置 LaTeX 编译器和本地 Tectonic 均成功编译。
- 检查 19 页渲染结果、五张框图、跨页表格、页眉页脚和目录。
- 无 overfull 排版溢出或缺字；保留一项不影响内容显示的 underfull 段落告警。
- 正文所引用 E01–E25、R01 均有证据索引。

报告写作和编译仅操作本报告目录，未触发板卡动作、Overlay 重载或其他综合实现任务。
