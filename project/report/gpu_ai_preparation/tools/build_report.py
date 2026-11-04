"""Extract archived evidence and build the AI-assisted GPU report chapter.

Run with a Python containing reportlab and pypdf:
  python build_report.py --plot-python PATH_TO_PYTHON_WITH_MATPLOTLIB
Outputs: PDF, editable HTML, six PNG/SVG figures, CSV/JSON, evidence and ZIP.
Next: merge chapter into the AI report and perform the proposed board A/B study.
No hardware build, deployment, RTL edits or network activity is performed.
"""
import argparse
import csv
import hashlib
import html
import json
import re
import shutil
import subprocess
import zipfile
from pathlib import Path
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.pagesizes import A4
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, Image, PageBreak, KeepTogether

BASE = Path(__file__).resolve().parents[1]
ROOT = BASE.parents[1]
DATA = BASE/'data'
FIG = BASE/'figures'
EVID = BASE/'evidence'
SOURCES = {}

def source(path):
    p=ROOT/path
    if not p.is_file(): raise FileNotFoundError(p)
    key=p.relative_to(ROOT).as_posix()
    if key not in SOURCES:
        raw=p.read_bytes()
        SOURCES[key]={'path':key,'sha256':hashlib.sha256(raw).hexdigest(),'bytes':len(raw)}
    return p.read_text(encoding='utf-8',errors='replace')

def line(path, pattern):
    txt=source(path)
    for n,s in enumerate(txt.splitlines(),1):
        if re.search(pattern,s):
            SOURCES[str(Path(path).as_posix())].setdefault('excerpts',[]).append({'line':n,'text':s})
            return s
    raise ValueError(f'Missing evidence {pattern} in {path}')

def writecsv(name, rows):
    with (DATA/name).open('w',encoding='utf-8-sig',newline='') as f:
        w=csv.DictWriter(f,fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)

def extract():
    for p in [DATA,FIG,EVID]: p.mkdir(parents=True,exist_ok=True)
    stages=[('P0','C0060700','reports/c6i'),
            ('P1','C0060710','gpu_cache_experiment/reports/c6i_tile_cache_p1'),
            ('P2a','C0060720','gpu_blit_experiment/reports/c6i_blit_pipeline_p2a'),
            ('P2b','C0060730','gpu_tile_pipeline_experiment/reports/c6i_tile_pipeline_p2b'),
            ('P3a','C0060740','gpu_tile_pair_experiment/reports/c6i_tile_pair_p3a'),
            ('P3b','C0060750','gpu_raster_pair_experiment/reports/c6i_raster_pair_p3b'),
            ('P4','C0060760','gpu_upload_overlap_experiment/reports/c6i_upload_render_overlap_p4')]
    resources=[]
    for stage,bid,folder in stages:
        prefix='board/pynq_z2/output/'+folder
        util=prefix+'/utilization.rpt'; timing=prefix+'/timing_summary.rpt'
        row={'stage':stage,'build_id':bid}
        for name,label in [('LUT','Slice LUTs'),('FF','Slice Registers'),('Slice','Slice'),('BRAM','Block RAM Tile'),('DSP','DSPs'),('MMCM','MMCME2_ADV')]:
            s=line(util,r'^\|\s*'+re.escape(label)+r'\s*\|')
            row[name]=int(s.split('|')[2].strip())
        txt=source(timing)
        pos=txt.index('WNS(ns)')
        match=re.search(r'^\s*(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+(\d+)\s+(\d+)\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+(\d+)',txt[pos:],re.M)
        if not match: raise ValueError(timing)
        row['WNS']=float(match[1]); row['WHS']=float(match[5])
        row['TNS']=float(match[2]); row['THS']=float(match[6])
        row['setup_fail_endpoints']=int(match[3]);row['hold_fail_endpoints']=int(match[7])
        row['resource_source']=util;row['timing_source']=timing
        resources.append(row)
    assert (resources[0]['LUT'],resources[-1]['LUT'])==(14025,14966)
    assert all(r['WNS']>=0 and r['WHS']>=0 and r['TNS']==0 and r['THS']==0 for r in resources)
    writecsv('resources.csv',resources)
    ablation=[]
    for c in [0,1]:
        for p in [0,1]:
            for q in [0,1]:
                path=f'results/gpu-tile_pair-verify-1791023235581/tile_pair_matrix_{c}_{p}_{q}.log'
                s=line(path,'name=size_16_flip_xy_transparent ')
                m=re.search(r'writes=(\d+) baseline=(\d+) cached=(\d+) fetches=(\d+) error=(\d+)',s)
                assert m and int(m[1])==1440 and int(m[2])==13860 and int(m[5])==0
                cycles=int(m[3])
                ablation.append({'cache':c,'pipeline':p,'pair':q,'cycles':cycles,'time_us':cycles/100,
                    'writes':int(m[1]),'descriptor_fetches':int(m[4]),'speedup':13860/cycles,
                    'cycle_reduction_pct':(1-cycles/13860)*100,'source':path})
    writecsv('tile_ablation.csv',ablation)
    blitpath='results/gpu-blit-pipeline-1791010899500/blit_unit_matrix.log'
    s=line(blitpath,'name=long_opaque ')
    m=re.search(r'off=(\d+) on=(\d+) writes=(\d+)',s); assert m
    blit=(int(m[1]),int(m[2])); assert blit==(1281,261)
    tile0='results/gpu-tile_pair-verify-1791023235581/core_pair_0.log'
    tile1='results/gpu-tile_pair-verify-1791023235581/core_pair_1.log'
    tlines=[line(x,'C4M7_PAIR_FRAME=PASS.*mask=0') for x in [tile0,tile1]]
    pair=tuple(int(re.search(r'cycles=(\d+)',s)[1]) for s in tlines); assert pair==(813,557)
    raster0='results/gpu-raster_core_unit-verify-1791031504609/core_raster_0_0.log'
    raster1='results/gpu-raster_core_unit-verify-1791031504609/core_raster_1_1.log'
    rlines=[line(x,'C4M7_RASTER_FRAME=PASS frame=0 ') for x in [raster0,raster1]]
    raster=tuple(int(re.search(r'cycles=(\d+)',s)[1]) for s in rlines);assert raster==(57909,28974)
    assert all('writes=57873 crc=0cd1ab1a' in s for s in rlines)
    raster_rows=[]
    for blit_flag,solid_flag in [(0,0),(1,0),(0,1),(1,1)]:
        path=f'results/gpu-raster_core_unit-verify-1791031504609/core_raster_{blit_flag}_{solid_flag}.log'
        s=line(path,'C4M7_RASTER_FRAME=PASS frame=0 ')
        assert 'writes=57873 crc=0cd1ab1a' in s
        cycles=int(re.search(r'cycles=(\d+)',s)[1])
        raster_rows.append({'blit_pair':blit_flag,'solid_pair':solid_flag,'cycles':cycles,'writes':57873,'crc':'0CD1AB1A','source':path})
    assert [r['cycles'] for r in raster_rows]==[57909,57781,29102,28974]
    writecsv('raster_ablation.csv',raster_rows)
    perf=[]
    specs=[('P1 Tile 缓存','Tile 缓存',13860,9540,'Tile 单元；缓存 off/on；流水及 pair 关闭',ablation[0]['source']+';'+ablation[4]['source']),
           ('P2a Blit 流水','Blit 流水',*blit,'Blit 单元；256 次不透明有效写入；流水 off/on',blitpath),
           ('P2b Tile 流水','Tile 流水',9540,2340,'Tile 单元；缓存固定开启；流水 off/on',ablation[4]['source']+';'+ablation[6]['source']),
           ('P1+P2b 累计','Tile 缓存与流水',13860,2340,'与 P1 同一 Tile 负载；不含 pair',ablation[0]['source']+';'+ablation[6]['source']),
           ('P3a Tile 双像素','Tile 双像素',*pair,'核心长 Tile；其余优化固定；pair off/on',tile0+';'+tile1),
           ('P3b 栅格双像素','栅格双像素',*raster,'核心普通不透明帧；Tile/cache/pipeline 固定开启',raster0+';'+raster1)]
    for name,short,b,o,scope,src in specs:
        perf.append({'name':name,'short_name':short,'before':b,'after':o,'before_us':b/100,'after_us':o/100,
                    'speedup':b/o,'cycle_reduction_pct':(1-o/b)*100,'scope':scope,'source':src})
    writecsv('performance.csv',perf)
    overlap=[]
    for flag in [0,1]:
        path=f'results/gpu-stage4-verify-1791042086109/upload_overlap_{flag}.log'
        s=line(path,'SCENE2D_UPLOAD_OVERLAP=PASS')
        m=re.search(r'overlap=(\d+) beats=(\d+) writes=(\d+) clear_crc=(\w+) fill_crc=(\w+)',s)
        assert m
        overlap.append({'enabled':flag,'overlapped_beats':int(m[2]),'writes':int(m[3]),'clear_crc':m[4].upper(),'fill_crc':m[5].upper(),'source':path})
    assert [r['overlapped_beats'] for r in overlap]==[0,520]
    assert all(r['writes']==57602 and r['clear_crc']=='A0708AC3' and r['fill_crc']=='3094986A' for r in overlap)
    line(overlap[1]['source'],'SCENE2D_UPLOAD_BOUNDARIES=PASS')
    writecsv('overlap.csv',overlap)
    for path in ['docs/gpu_ai_optimization_p0_p4_summary.md','docs/bringup/2026-10-03_pynq-z2_gpu_parallel_optimization.md',
                 'docs/bringup/2026-10-04_pynq-z2_gpu_upload_overlap_p4.md','docs/scene2d_gpu_architecture.md']:
        source(path)
    gate_source='results/gpu-p3a-board-budget-fail-1791026983004/scene2d_draw_tile_layer.sv'
    line(gate_source,r'issue_pair = TILE_PIXEL_PAIR_ENABLE && TILE_PIXEL_PIPELINE_ENABLE')
    line(gate_source,r'TILE_DESCRIPTOR_CACHE_ENABLE && descriptor_cache_valid')
    # Preserve the small, exact evidence files needed to reproduce the tables.
    for path,meta in SOURCES.items():
        dst=EVID/path; dst.parent.mkdir(parents=True,exist_ok=True); shutil.copyfile(ROOT/path,dst)
    (DATA/'source_manifest.json').write_text(json.dumps(list(SOURCES.values()),ensure_ascii=False,indent=2),encoding='utf-8')
    return resources,ablation,perf,overlap

def build(resources,ablation,perf,overlap):
    pdfmetrics.registerFont(TTFont('ReportSans','C:/Windows/Fonts/msyh.ttc'))
    pdfmetrics.registerFont(TTFont('ReportBold','C:/Windows/Fonts/msyhbd.ttc'))
    pdfmetrics.registerFontFamily('ReportSans',normal='ReportSans',bold='ReportBold')
    styles={
        'title':ParagraphStyle('title',fontName='ReportBold',fontSize=25,leading=34,spaceAfter=10,textColor=colors.HexColor('#18344A')),
        'h':ParagraphStyle('h',fontName='ReportBold',fontSize=17,leading=25,spaceAfter=12,textColor=colors.HexColor('#18344A'),keepWithNext=True),
        'body':ParagraphStyle('body',fontName='ReportSans',fontSize=10.5,leading=17.5,spaceAfter=9,wordWrap='CJK'),
        'small':ParagraphStyle('small',fontName='ReportSans',fontSize=9,leading=14.2,spaceAfter=8,wordWrap='CJK',textColor=colors.HexColor('#465867')),
        'cell':ParagraphStyle('cell',fontName='ReportSans',fontSize=8.8,leading=13.5,wordWrap='CJK'),
        'caption':ParagraphStyle('caption',fontName='ReportSans',fontSize=8.8,leading=13.3,spaceAfter=10,textColor=colors.HexColor('#526675')),
        'tabletitle':ParagraphStyle('tabletitle',fontName='ReportBold',fontSize=9.2,leading=14.5,spaceBefore=4,spaceAfter=6,keepWithNext=True,textColor=colors.HexColor('#18344A')),
        'metric':ParagraphStyle('metric',fontName='ReportBold',fontSize=22,leading=29,textColor=colors.HexColor('#176B8D')),
        'metriclabel':ParagraphStyle('metriclabel',fontName='ReportSans',fontSize=8.7,leading=13,textColor=colors.HexColor('#465867')),
    }
    story=[]; sections=[]; current=[]
    table_titles=iter(['阶段方案与验证目标','统一对照条件','评价指标与计算方法','Tile 八组合完整结果',
        '各绘图路径的周期对照','代表性用例与输出等价检查','累计版本的整机资源',
        '失败反馈与修复复验','P4 输出与协议边界检查','主要结论的证据范围','板端配对补测方案','写作教程与使用方法'])
    table_no=0
    def text(s,style='body'):
        story.append(Paragraph(html.escape(s),styles[style]));current.append(f'<p class="{style}">{html.escape(s)}</p>')
    def heading(s):
        story.append(Paragraph(html.escape(s),styles['h']));current.append('<h2>'+html.escape(s)+'</h2>')
    def table(headers,rows,widths=None):
        nonlocal table_no
        table_no+=1
        title=f'表 {table_no}  '+next(table_titles)
        story.append(Paragraph(title,styles['tabletitle']))
        current.append('<p class="tabletitle">'+html.escape(title)+'</p>')
        values=[[Paragraph(('<b>'+html.escape(str(v))+'</b>') if ri==0 else html.escape(str(v)),styles['cell']) for v in row] for ri,row in enumerate([headers]+rows)]
        if widths: widths=[v*507/490 for v in widths]
        t=Table(values,colWidths=widths,repeatRows=1,hAlign='LEFT')
        t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#EAF1F6')),
            ('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),6),('RIGHTPADDING',(0,0),(-1,-1),6),
            ('TOPPADDING',(0,0),(-1,-1),5.5),('BOTTOMPADDING',(0,0),(-1,-1),5.5),
            ('LINEBELOW',(0,0),(-1,0),.7,colors.HexColor('#91A5B4')),
            ('LINEBELOW',(0,-1),(-1,-1),.5,colors.HexColor('#B8C5CF')),
            ('ROWBACKGROUNDS',(0,1),(-1,-1),[colors.white,colors.HexColor('#F7F9FA')])]))
        story.extend([t,Spacer(1,9)])
        current.append('<table><thead><tr>'+''.join('<th>'+html.escape(str(v))+'</th>' for v in headers)+'</tr></thead><tbody>'+''.join('<tr>'+''.join('<td>'+html.escape(str(v))+'</td>' for v in row)+'</tr>' for row in rows)+'</tbody></table>')
    def metrics(items):
        cells=[]
        for value,label in items:
            cells.append([Paragraph(value,styles['metric']),Paragraph(html.escape(label),styles['metriclabel'])])
        t=Table([cells],colWidths=[507/len(items)]*len(items))
        t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,-1),colors.HexColor('#EFF5F8')),('VALIGN',(0,0),(-1,-1),'TOP'),('TOPPADDING',(0,0),(-1,-1),11),('BOTTOMPADDING',(0,0),(-1,-1),11),('LEFTPADDING',(0,0),(-1,-1),12)]))
        story.extend([t,Spacer(1,12)])
        current.append('<div class="metrics">'+''.join('<div><strong>'+value+'</strong><span>'+html.escape(label)+'</span></div>' for value,label in items)+'</div>')
    def figure(name,caption,width=507):
        img=Image(str(FIG/(name+'.png')));h=width*img.imageHeight/img.imageWidth
        story.append(KeepTogether([Image(str(FIG/(name+'.png')),width=width,height=h),Paragraph(html.escape(caption),styles['caption'])]))
        current.append(f'<figure><img src="figures/{name}.svg" alt="{html.escape(caption)}"><figcaption>{html.escape(caption)}</figcaption></figure>')
    def page():
        sections.append('\n'.join(current));current.clear();story.append(PageBreak())

    text('AI 辅助 Scene2D GPU 优化','title')
    text('优化过程、同负载对照与工程验证','h')
    text('PYNQ-Z2  ·  Vivado 2026.1  ·  实验 2026.10.03—04  ·  修订 2026.10.26','small')
    text('在 PYNQ-Z2 上，我们围绕 Scene2D 命令式二维 GPU 的描述符访问、像素执行和跨帧上传开展四阶段优化。AI 辅助提出局部方案、改写 RTL、分析失败并组织复验；效果由 XSim 黄金对照和 Vivado 实现报告判定。固定 100 MHz 渲染时钟后，代表性 Tile 缓存加流水场景加速 5.92 倍，Blit 流水加速 4.91 倍，核心栅格双像素场景约加速 2 倍。')
    metrics([('5.92×','Tile 缓存与流水；同一 Tile 单元负载'),('4.91×','Blit 流水；256 次不透明写入'),('2.00×','栅格双像素；代表性核心场景')])
    figure('01_optimization_route','图 1  四阶段优化与验证闭环。P2、P3 分别细分为两条实施路径；箭头表示累计功能，不表示加速比相乘。来源：S1—S3。')
    table(['阶段','AI 辅助的分析与实施','验证关注点'],[
        ['P1','识别同一 Tile 描述符的重复读取；复用寄存器并加入 tag 和有效位','缓存失效、素材更新、翻转、透明与裁剪'],
        ['P2','将请求、返回和写入组织为浅流水；提前锁存源原点和边界','valid 对齐、末请求排空、错误前缀'],
        ['P3','扩展为条件性双写；保留独立 lane 掩码及有序 CRC','奇偶地址、行尾、透明 lane、时序'],
        ['P4','复用双命令 bank 预上传；加入 READY、hold/release 与代次栅栏','bank 所有权、反压、呈现与资源更新']],[36,247,207])
    text('资源代价为整机 LUT 增加 941 个（6.71%）、FF 增加 529 个（2.32%），BRAM Tile 从 62 降至 60。P4 最终 WNS/WHS 为 0.029/0.052 ns。以上为离线功能与实现结果；板端 P0/P4 同场景端到端性能、功耗和开发工时收益需要独立测量。','small')
    page()

    heading('1  前后对比标准与测量边界')
    text('前后对比采用两套互补口径：资源与时序比较 P0 和 P4 整机实现；性能比较同一负载下优化开关关闭与开启的 RTL 执行周期。不同测试负载的加速比各自报告，不能相乘作为整机加速比。')
    table(['控制项','本次采用的固定条件与判据'],[
        ['器件与工具','PYNQ-Z2 / xc7z020clg400-1；Vivado / XSim 2026.1，Windows'],
        ['版本身份','P0 BUILD_ID C0060700；P4 BUILD_ID C0060760；P4 是独立实验产物'],
        ['时钟与画布','render 100 MHz，pixel 74.25 MHz；320×180；4 倍最近邻输出 1280×720p60'],
        ['功能与容量','Scene ABI 1.0、GameSDK 1.1；INDEX4 素材；双 framebuffer，每 bank 57,600 字节'],
        ['同负载配对','保持输入命令、素材、尺寸、透明/翻转/裁剪条件一致；仅改变表中指定开关'],
        ['正确性等价','有序写入地址和值、count、trace CRC、错误前缀与取消重试；核心另检查真实 XPM 读回'],
        ['周期口径','归档 TB 中执行区间的 cycle 计数；按具体模块/核心分别解释；不含主机、网络和显示器延迟'],
        ['资源与时序','最终 post-route 整机报告；LUT/FF/Slice/BRAM/DSP/MMCM；保持原时钟与约束意图'],
        ['重复与统计','归档为确定性 RTL 用例和单次版本实现；不构造方差、误差线、置信区间或显著性检验']],[96,394])
    table(['指标','公式与解释'],[
        ['加速比 S','S = C关闭 / C开启。1.00 倍表示无加速。'],
        ['周期减少率 R','R = (C关闭 - C开启) / C关闭 × 100%。'],
        ['渲染时间','100 MHz 下 t(微秒) = C / 100；仅换算该执行区间。'],
        ['资源相对变化','(N_P4 - N_P0) / N_P0 × 100%；器件占用率另以器件容量为分母。']],[96,394])
    text('720p60 表示扫描输出模式。局部像素吞吐峰值、GPU 绘制时间、游戏呈现 FPS 和输入到屏幕延迟是不同指标。本节的周期减少不能直接换算成整机 FPS 增幅。','small')
    page()

    heading('2  Tile 消融与优化机制')
    text('固定 size16、3×2 Tile、XY 翻转和透明处理用例，八种开关组合均完成 1,440 次有效写入且 error=0。图 2 同时展示有效改进和收益较小的组合，使优化归因能够由同一负载直接验证。')
    figure('02_tile_ablation','图 2  相同 size16 / 3×2 Tile 用例的八组合对照，数值为周期及相对全关闭的局部加速比。双像素路径依赖缓存、流水同时开启；开关置 1 不一定激活该路径。来源：S5、S9。')
    table(['缓存 / 流水 / 双像素','周期','时间 微秒','描述符读取','相对全关闭'],[
        [f"{r['cache']} / {r['pipeline']} / {r['pair']}",f"{r['cycles']:,}",f"{r['time_us']:.2f}",f"{r['descriptor_fetches']:,}",f"{r['speedup']:.2f} 倍"] for r in ablation],[145,65,85,90,105])
    text('单独启用流水仅减少 0.69% 的周期；缓存将描述符读取从 1,536 次降至 96 次，减少 93.75%。缓存与流水共同开启后降至 2,340 周期，说明重复描述符访问是本用例的重要限制。再启用双像素后为 1,572 周期，相对全关闭加速 8.82 倍。','small')
    text('双像素路径要求 cache、pipeline 同时开启，并满足描述符有效、行内边界和地址对齐条件。因此 001、011、101 与对应 pair=0 组合周期相同，属于前置条件未满足时的兼容路径；八组合结果不能按三个独立主效应相加解释。8.82 倍仅适用于本 Tile 单元负载。','small')
    page()

    heading('3  不同绘图路径的配对性能结果')
    text('图 3 分别检验 Blit 流水、核心 Tile 双像素和核心栅格双像素。每项保持输入和前置优化一致，只切换被检验的路径。不同子图采用独立周期刻度，表 5 汇总完整数值。')
    figure('03_workload_comparisons','图 3  三条绘图路径的周期对照。右图另拆分仅 Blit 双写、仅实色双写与全部开启；实色指 CLEAR/FILL。上方加速比对应全关至全开。来源：S6。')
    table(['同负载测试','关闭 → 开启 周期','减少','加速比'],[
        [r['name'],f"{r['before']:,} → {r['after']:,}",f"{r['cycle_reduction_pct']:.2f}%",f"{r['speedup']:.2f} 倍"] for r in perf],[152,160,89,89])
    text('P2b 与累计 P1+P2b 复用图 2 的 Tile 负载；其余项使用各自专用负载。周期来源和开关背景见 performance.csv。','caption')
    table(['用例','负载和正确性证据'],[
        ['Blit 流水','256 次不透明有效写入；1281→261 周期，即 12.81→2.61 微秒；合法连续段达到 1 像素/拍。'],
        ['核心 Tile 双像素','cache/pipeline 等前置优化固定；有效写入 513，CRC 88CEA2AB 保持；813→557 周期。'],
        ['核心栅格双像素','Tile/cache/pipeline 固定开启；普通不透明帧有效写入 57,873，CRC 0CD1AB1A 保持；579.09→289.74 微秒。']],[98,392])
    text('同一栅格负载中，仅 Blit 双写为 57,781 周期，仅实色双写为 29,102 周期，两者同时开启为 28,974 周期；四组写入数和 CRC 均相同。该用例的主要收益来自 CLEAR/FILL，不宜据此声称所有精灵场景均加速 2 倍。双像素路径仍受对齐、源 byte、行界和透明 lane 条件限制。','small')
    page()

    heading('4  资源成本与容量占用')
    text('P0/P4 的直接资源对照取自整套 PL 设计的实现后报告，包含 GPU、DMA、HDMI、控制与回传配套。图 4 左侧以器件容量统一为百分比，右侧展示相对 P0 的累计资源变化。')
    figure('04_resource_tradeoff','图 4  P0/P4 容量占用及累计资源轨迹。容量分母为 LUT 53,200、FF 106,400、Slice 13,300、BRAM 140；各类占用率分别解释。来源：S4。')
    table(['累计版本','LUT','FF','Slice','BRAM Tile','BUILD_ID'],[
        [r['stage'],f"{r['LUT']:,}",f"{r['FF']:,}",f"{r['Slice']:,}",r['BRAM'],r['build_id']] for r in resources],[65,78,82,75,78,112])
    metrics([('+6.71%','LUT +941；FF +529（+2.32%）'),('-2 Tile','BRAM 62→60；容量合同保持'),('2 / 2','DSP / MMCM；各阶段保持不变')])
    text('P4 相对本轮预算 15,110 LUT / 23,844 FF 还剩 144 LUT / 470 FF。该数值是实验预算余量，与器件剩余容量不同。P1 整机 LUT 从 14,025 降至 13,982，包含工具映射与布局变化，不能据此断言缓存本身节省逻辑；同配置局部 OOC 记录的缓存增量为 +27 LUT / +25 FF。BRAM 的下降来自 framebuffer 组织调整，容量合同保持。','small')
    page()

    heading('5  失败反馈与时序修复体现 AI 辅助过程')
    text('各累计版本最终均满足同目标时钟下的 setup/hold 门槛。图 5 给出整机结果；表 8 用局部失败和复验说明修改如何收敛。OOC 指模块独立实现，其余量与整机结果分别解释。')
    figure('05_timing_margin','图 5  各累计版本的最终整机 WNS/WHS，渲染与像素时钟保持 100/74.25 MHz。P4 为 0.029/0.052 ns，setup 余量较 P0 减少 0.028 ns。来源：S4。')
    table(['问题与原始反馈','AI 辅助定位与修改','复验结果与层级'],[
        ['Tile 流水定位与尾界组合链过长；首轮 OOC 开启版 WNS -0.981 ns','提前锁存 descriptor 源原点和水平终点，缩短逐像素定位链','同负载黄金保持；最终 Tile 流水 OOC 0.281/0.121 ns'],
        ['Blit 双像素局部 OOC WNS -1.539 ns；首次修复又在 negative_xy 触发 watchdog','拆分 source/pair/step/rowend 链；使用 Blit 自身候选坐标判断尾部','原独立 oracle 复验；最终 Blit pair OOC 1.701/0.159 ns'],
        ['P4 开启版核心 OOC 默认布线 WNS -0.006 ns','保留失败 DCP；同钟同 RTL 同约束执行后布线 AggressiveExplore','开启版 OOC 0.070/0.100 ns；整机另为 0.029/0.052 ns'],
        ['P4 busy 撤销至 hold 锁存间隙可能启动 READY','在 renderer_start 条件中增加 !renderer_done，关闭完成边界窗口','off/on 写入与 CRC 保持；520 次重叠握手及边界测试通过']],[169,163,158])
    text('来源：S2、S3。AI 辅助解释反馈并形成可检验修改；独立黄金和工具报告决定该轮是否通过。案例中前后 OOC 数值仅在对应模块与轮次内比较。','caption')
    text('P4 整机 TNS/THS、setup/hold 失败端点和内部未约束端点均为 0；时序报告仍保留 4 个输出无 delay 的既有缺项，质量报告也存在原有 warning/info。应表述为“满足本轮既有门禁”，不能写成零告警或所有 I/O 时序完全签核。','small')
    page()

    heading('6  上传渲染重叠及输出一致性')
    text('P4 使用双命令 bank，在当前 Scene 渲染期间预上传同资源代次的下一 Scene，最多保留一个 READY。renderer 读 bank 被锁定，完成结果保持到呈现及软件 release；资源更新先 drain，再等待 generation 实际提交。')
    figure('06_overlap_correctness','图 6  同一两 Scene 测试中的重叠行为与输出等价。520 为 renderer_busy 期间下一 Scene 的核心内部上传握手数。来源：S7。')
    table(['检查项','关闭重叠','开启重叠'],[
        ['busy 期间下一 Scene 内部握手','0','520'],['两 Scene 有效像素写入','57,602','57,602'],
        ['CLEAR trace CRC','A0708AC3','A0708AC3'],['FILL trace CRC','3094986A','3094986A'],
        ['队列满、提前 release、资源栅栏','基础对照','full_queue=1 / early_release=1 / resource_fence=1'],
        ['generation 拒绝、半包复位、末字节','基础对照','generation_rejects=3 / partial_reset=1 / last_byte=11']],[196,100,194])
    text('握手计数证明下一 Scene 已在当前渲染期间推进。调度收益来自利用这段原本等待的时间；其大小仍由上传耗时、渲染、vblank 与软件退休共同决定。本计数既不等于外部 DMA 总 beat 数，也不足以计算端到端节省时间。','small')
    text('本轮 18 份最终仿真日志覆盖 off/on、完整画布扫描、命令 bank、绘图/掩码/错误前缀及资源更新。软件的 128 个测试与 4 个子测试、后续关闭安全增量 87 个测试来自归档事实记录，两轮范围有重叠，不相加宣称为互不重复的总用例数。','small')
    page()

    heading('7  可支持的结论与后续补测设计')
    table(['拟写入报告的结论','证据状态','适用范围'],[
        ['缓存与流水降低了代表负载的执行周期','原始 RTL 日志已复核','明确具体负载、开关和测量模块'],
        ['P4 以少量 LUT/FF 增量保留原存储容量合同','实现后报告已复核','整套 PL 设计；不同于 GPU 核心净面积'],
        ['P4 预上传可与当前渲染真实重叠','原始握手和输出对照已复核','指定两 Scene 确定性仿真'],
        ['P4 完整游戏 FPS、尾延迟或功耗更优','本次归档不支持量化结论','需要同板同 Scene 端到端配对实测'],
        ['AI 缩短开发工时或提高人工效率若干倍','无对照工时记录','不填写节省百分比或 AI/人工效率倍数']],[207,126,157])
    text('建议补测方案如下。表内次数为后续计划，不属于已完成实验；在执行前固定版本和负载，按固定顺序记录所有成功、失败与超时。')
    table(['设计项','建议执行标准'],[
        ['版本与环境','同一 PYNQ-Z2、相同镜像与驱动配置；分别核验 P0/P4 bit/HWH/manifest 和 BUILD_ID；相同 HDMI 模式、资源和 Scene 序列'],
        ['负载矩阵','全屏 CLEAR/FILL、透明/翻转/裁剪精灵、size16 Tile、混合实际游戏；另测静态资源与每帧资源更新两组'],
        ['运行设计','建议每组 5 次配对运行，按 P0/P4 与 P4/P0 交替；每次预热 300 帧、计入 3000 帧；重载过程不混入稳态'],
        ['时延与帧率','以相同单调时钟记录 submit 至 displayed_seq 确认的每帧时延；报告 P50/P95/P99、帧数、超时和漏帧；FPS 以唯一确认序号计数'],
        ['正确性与统计','同一输入序列核对黄金结果和逐帧身份；以运行而非相邻帧作为重复单位；公布逐运行结果及配对差值'],
        ['扩展指标','DMA/上传/渲染/等待 vblank 分段计时；输入到屏幕需额外外部同步测量；功耗需相同供电点和空闲基线'],
        ['AI 效率评估','如需评价 AI，预先定义相同任务、质量门禁、参与者和工具；记录人工活跃工时、工具等待与返工，不用构建耗时替代工时']],[88,402])
    text('AI 辅助披露可用正文：本项目在目标和接口约束下使用 AI 辅助分析 GPU 瓶颈、提出缓存与流水等优化方案、生成局部修改和验证脚本，并根据仿真及实现反馈修复边界问题。设计效果由独立黄金、XSim、Vivado 报告和产物身份检查确认。AI 输出均需经过工程验证；本阶段未测量 AI 相对于纯人工开发的工时收益。','small')
    page()

    heading('附录  写作方法与证据索引')
    text('所附 Lucas–Kanade 报告可借鉴“AI 提示词—修改过程—实现解释”的叙事结构。本章节将其压缩为“问题—建议—修改—证据—适用边界”，将篇幅主要留给消融、性能、资源和时序图表。光流算法内容及其中的数值不作为 Scene2D GPU 的实验数据。')
    table(['教程或 skill','本报告如何采用'],[
        ['墨尔本大学 Technical reports [W1]','先交代问题、目标和主要结果；图表编号、正文引用、自包含图题；详细证据放附件。'],
        ['Michael Ernst 技术论文写作教程 [W2]','围绕要证明的结论组织材料；每个结果解释意义；只保留能解释取舍的失败案例。'],
        ['Nature research figure guide [W3]','标清坐标与单位；使用可区分配色、清晰标签；保留矢量图和可编辑文字。'],
        ['本机 paper-buddy skill','已使用 figures-and-rigor 与 structure-and-writing 的图表选型、实验分析、数字一致性与主张证据核查。'],
        ['本机 pdf skill 与 xilinx-suite','前者用于 PDF 读取、排版与视觉核查；后者用于理解实现报告、阶段记录和 FPGA 验证边界。']],[191,299])
    text('复用提示词示例 以下是根据工程记录重构的建议写法，不是历史对话原文。','small')
    text('“目标为 PYNQ-Z2 / xc7z020clg400-1，Vivado 2026.1，100 MHz render 与 74.25 MHz pixel。保持 Scene ABI、素材容量、绘制顺序和错误语义。请根据同一负载的日志识别瓶颈，提出一个可关闭的局部优化，明确假设、资源预算、边界和独立黄金验证；失败时保留证据，并在相同约束下复验。不得将局部吞吐推算为整机 FPS。”','small')
    text('证据索引：S1 优化总结；S2 10 月 3 日逐轮记录；S3 10 月 4 日 P4 验收；S4 各阶段 utilization/timing 原报告；S5 Tile 八组合日志；S6 Blit 与核心 pair/raster 日志；S7 P4 上传与边界日志；S8 GPU 架构；S9 P3a 归档 RTL 中的双像素前置条件。完整路径、SHA-256 和抽取行号见 data/source_manifest.json，原文件副本见 evidence/。','small')
    for label,url in [('[W1] University of Melbourne','https://students.unimelb.edu.au/academic-skills/reading-writing-and-referencing/reports/technical-report-writing'),('[W2] Michael Ernst','https://homes.cs.washington.edu/~mernst/advice/write-technical-paper.html'),('[W3] Nature research figure guide','https://research-figure-guide.nature.com/figures/preparing-figures-our-specifications/')]:
        story.append(Paragraph(f'{html.escape(label)}  <link href="{url}" color="#0072B2">访问原文</link>',styles['small']))
        current.append(f'<p><a href="{url}">{html.escape(label)}</a></p>')
    text('以上网页访问日期为 2026 年 10 月 26 日。教程用于写作和制图规范，性能数据均来自本项目归档。引用、数值和结论应由团队在合并终稿时复核，AI 辅助情况按提交要求披露。','small')
    sections.append('\n'.join(current))
    def footer(c,d):
        c.setFont('ReportSans',7.5);c.setFillColor(colors.HexColor('#69808E'))
        c.drawString(44,25,'Scene2D GPU  /  AI 辅助优化')
        c.drawRightString(A4[0]-44,25,f'{d.page:02d}')
    pdf=BASE/'Scene2D_GPU_AI_优化过程与效果.pdf'
    doc=SimpleDocTemplate(str(pdf),pagesize=A4,rightMargin=44,leftMargin=44,topMargin=36,bottomMargin=40,title='AI 辅助 Scene2D GPU 优化过程与效果',author='Voice View project')
    doc.build(story,onFirstPage=footer,onLaterPages=footer)
    css='''body{font-family:"Microsoft YaHei",sans-serif;color:#213747;max-width:980px;margin:46px auto;padding:0 28px;line-height:1.9}section{margin-bottom:64px}h1,.title{font-size:32px;font-weight:700;letter-spacing:-.5px}h2,.h{font-size:25px;font-weight:700;color:#18344a}.metrics{display:flex;background:#eff5f8;padding:18px 8px;margin:20px 0;gap:16px}.metrics>div{flex:1;padding:0 14px}.metrics strong{display:block;font-size:32px;color:#176b8d}.metrics span{display:block;font-size:13px;line-height:1.6}.tabletitle{font-size:15px;font-weight:700;margin-bottom:6px}table{border-collapse:collapse;width:100%;font-size:14px;margin:8px 0 20px}th,td{text-align:left;vertical-align:top;padding:10px;border-bottom:1px solid #d5dfe5}th{background:#eaf1f6}tr:nth-child(even){background:#f7f9fa}img{width:100%;height:auto}figure{margin:20px 0}figcaption,.small,.caption{font-size:13px;color:#526675}a{color:#176b8d}@media(max-width:640px){.metrics{display:block}.metrics>div{padding:10px}.title{font-size:26px}table{font-size:12px}}@media print{section{break-after:page}body{margin:0;max-width:none}}'''
    (BASE/'chapter.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>AI 辅助 Scene2D GPU 优化过程与效果</title><style>'+css+'</style><body>'+''.join('<section>'+s+'</section>' for s in sections)+'</body></html>',encoding='utf-8')
    return pdf

def main():
    p=argparse.ArgumentParser();p.add_argument('--plot-python',required=True)
    a=p.parse_args()
    rows=extract()
    subprocess.run([a.plot_python,str(BASE/'tools/plot_figures.py'),'--data',str(DATA),'--output',str(FIG)],check=True)
    pdf=build(*rows)
    readme='''交付内容与运行方式 美化修订版 v2

Scene2D_GPU_AI_优化过程与效果.pdf：可直接纳入 AI 辅助报告的九页章节。
chapter.html：可编辑的同内容 HTML，浏览器可打开，也可复制文字和表格到 Word。
figures/：六组 300 dpi PNG 和保留文本的 SVG 图，可单独插图。
data/：五张 UTF-8 BOM CSV、带 SHA-256 与抽取行号的证据清单。
evidence/：对应原始日志、实现报告和项目记录的精确副本。
tools/：可重复执行的提取、验证、绘图与排版脚本。

已完成实验：2026-10-03 至 2026-10-04 的 PL GPU P0–P4 离线优化。
整理日期：2026-10-26。本轮读取归档并核对、绘图，未重跑 Vivado/XSim 或访问板卡。
注意：九页中的板端 A/B 次数和 AI 效率评测均为后续建议，不是已完成实验。

重建命令（在原项目下运行，PowerShell）：
& 'C:\\Users\\developer\\.cache\\codex-runtimes\\codex-primary-runtime\\dependencies\\python\\python.exe' -X utf8 'E:\\projects\\fpga\\voice-view-game\\report\\gpu_ai_preparation\\tools\\build_report.py' --plot-python 'C:\\Users\\developer\\.cache\\codex-runtimes\\codex-primary-runtime\\dependencies\\python\\python.exe'

依赖：主运行时需要 reportlab；绘图运行时需要 matplotlib/numpy。
本机绘图依赖位于 .plot_deps 独立目录，不修改系统环境；ZIP 不包含该可再安装目录。
迁移后可执行 python -m pip install reportlab matplotlib numpy，再用该 Python 执行重建命令。
脚本读取当前项目归档并重建本目录 PDF/HTML/PNG/SVG/CSV/JSON/ZIP；原始工程不修改。
如迁移到其他机器，应保留本目录在 report/ 下的相对位置，安装上述依赖，并修改解释器路径。
下一步：合并章节；按第 7 节执行同板同负载 P0/P4 回放，补齐 FPS、尾延迟和功耗。
'''
    (BASE/'README.txt').write_text(readme,encoding='utf-8')
    qa={'source_files':len(SOURCES),'checks':['all resource reports parsed','all stage setup/hold margins nonnegative','TNS/THS zero','eight paired Tile cases same writes and zero error','Blit/pair/raster counts match archived results','P4 overlap counts, writes and CRC checked'],'limits':['archival read-only verification; no new hardware measurement','single deterministic examples; no empirical uncertainty estimated','visual QA recorded separately']}
    (DATA/'verification.json').write_text(json.dumps(qa,ensure_ascii=False,indent=2),encoding='utf-8')
    bundle=BASE.parent/'Scene2D_GPU_AI_报告准备材料.zip'
    with zipfile.ZipFile(bundle,'w',zipfile.ZIP_DEFLATED) as z:
        for f in BASE.rglob('*'):
            if f.is_file() and not any(x in f.relative_to(BASE).parts for x in ['qa','.plot_deps','__pycache__']):
                z.write(f,Path(BASE.name)/f.relative_to(BASE))
    print(json.dumps({'pdf':str(pdf),'bundle':str(bundle),'source_files':len(SOURCES)},ensure_ascii=False))

if __name__=='__main__': main()
