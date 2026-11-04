"""Build the expanded performance/resource report from archived evidence.
Run: bundled-python -X utf8 report/performance_resource/tools/build_report.py
Outputs: PDF, editable HTML, CSV/JSON, PNG/SVG and ZIP in report/.
Next: merge into the AI report; perform only separately authorized experiments.
Requires reportlab, pypdf; plotting uses the existing local matplotlib target.
"""
from pathlib import Path
import sys, os, json, csv, shutil, hashlib, re, io, zipfile
BASE=Path(__file__).resolve().parents[1]
ROOT=BASE.parents[1]
OLD=BASE.parent/'gpu_ai_preparation'
sys.path.insert(0,str(OLD/'.plot_deps'))
os.environ['MPLCONFIGDIR']=str(BASE/'qa/matplotlib')
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib import font_manager
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import SimpleDocTemplate,Paragraph,Spacer,Table,TableStyle,Image,PageBreak,KeepTogether
from reportlab.pdfgen.canvas import Canvas
from pypdf import PdfReader,PdfWriter

for d in ['data','figures','evidence','qa']: (BASE/d).mkdir(parents=True,exist_ok=True)
for sub in ['data','figures','evidence']:
    shutil.copytree(OLD/sub,BASE/sub,dirs_exist_ok=True)
manifest=json.loads((BASE/'data/source_manifest.json').read_text(encoding='utf-8'))
tracked={r['path']:r for r in manifest}
def src(path):
    p=ROOT/path; raw=p.read_bytes()
    target=BASE/'evidence'/path; target.parent.mkdir(parents=True,exist_ok=True); target.write_bytes(raw)
    tracked[path]={'path':path,'sha256':hashlib.sha256(raw).hexdigest(),'bytes':len(raw)}
    return raw.decode('utf-8-sig',errors='replace')
def jsrc(path):return json.loads(src(path))
def csvout(name,rows):
    with (BASE/'data'/name).open('w',encoding='utf-8-sig',newline='') as f:
        w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)

docs=[
'docs/vision_latency_acceleration_plan_20261023.md',
'docs/bringup/2026-10-23_pynq-z2_pl_timing_repair.md',
'docs/bringup/2026-10-23_pynq-z2_r20_board_test.md',
'docs/bringup/2026-10-23_pynq_usb_hand_board.md',
'docs/bringup/2026-10-25_serial_hand_owner_offline.md',
'docs/bringup/2026-10-25_hand_continuous_owner.md',
'docs/bringup/2026-10-25_hand_source_clock_audit.md',
'docs/bringup/2026-10-25_preview_demand_board.md',
'docs/bringup/2026-10-26_r30_preview_idle.md',
'docs/bringup/2026-10-28_r60_pure_live.md']
texts=[src(p) for p in docs]
release_doc=src('docs/bringup/2026-10-29_v2_release.md')
src('docs/bringup/2026-10-28_v2_canvas_menu.md')
accept=jsrc('build/studio-v2/acceptance-summary.json')
bench=jsrc('build/studio-v2/canvas-benchmark.json')
release=jsrc('build/voice-view-v2-github-release.json')
overlay=jsrc('build/v2-release-repo/releases/v2.0/board_runtime/overlay/board_test_manifest.json')
hwh=src('build/v2-release-repo/releases/v2.0/board_runtime/overlay/c6v_candidate.hwh')
src('build/v2-release-repo/releases/v2.0/board_runtime/overlay/timing.rpt')
assert accept['version']=='2.0' and accept['result']=='PASS'
assert overlay['build_id']=='0xC0061000'
assert hashlib.sha256((ROOT/'build/v2-release-repo/releases/v2.0/board_runtime/overlay/c6v_candidate.hwh').read_bytes()).hexdigest().lower()==overlay['sha256']['c6v_candidate.hwh'].lower()
for flag in ['BLIT_PIXEL_PAIR_ENABLE','BLIT_PIXEL_PIPELINE_ENABLE','TILE_DESCRIPTOR_CACHE_ENABLE','TILE_PIXEL_PAIR_ENABLE','TILE_PIXEL_PIPELINE_ENABLE','UPLOAD_RENDER_OVERLAP_ENABLE']:
    assert re.search(r'NAME="'+flag+r'" VALUE="&quot;0&quot;"',hwh),flag
final_rows=[{'metric':'120次悬停背景上传','before':120,'v2':1,'unit':'次','scope':bench['scope']},
{'metric':'悬停单帧中位耗时','before':bench['R60']['hover']['median_elapsed_ms'],'v2':bench['v2']['hover']['median_elapsed_ms'],'unit':'ms','scope':bench['scope']},
{'metric':'绘制单帧中位耗时','before':bench['R60']['paint']['median_elapsed_ms'],'v2':bench['v2']['paint']['median_elapsed_ms'],'unit':'ms','scope':bench['scope']}]
csvout('v2_final_comparison.csv',final_rows)
# Vision profile is explicitly a document transcription, not a new measurement.
vision=[{'stage':n,'p50_ms':a,'p95_ms':b,'p99_ms':c,'source':docs[0],'scope':'R1, 300 distinct NO_HAND frames, 60.101 s HTTP sample'} for n,a,b,c in [
('输入准备',19.87,25.70,27.04),('颜色掩码与CPU参考',66.94,74.39,79.48),('PS形态学',32.23,36.43,38.70),('轮廓选择',4.52,8.70,9.56),('形状统计',.029,.033,.036)]]
for r in vision: assert str(r['p50_ms']) in texts[0]
csvout('vision_stage_profile.csv',vision)
vr=[{'version':'C0D R1','LUT':28746,'FF':44000,'Slice':12532,'BRAM':87.5,'DSP':14,'WNS':.004,'WHS':.050,'source':docs[0]},
    {'version':'C0E reviewed-r02','LUT':33499,'FF':49451,'Slice':13144,'BRAM':89.5,'DSP':20,'WNS':.002,'WHS':.049,'source':docs[1]}]
assert all(str(r['LUT']) in texts[i] and str(r['Slice']) in texts[i] for i,r in enumerate(vr))
csvout('vision_resources.csv',vr)
hands=[];hr=[]
for tag,file in [('插值基线','h143-buttons-cpu-analysis.json'),('阶段目标','h150-minimal-analysis.json'),('轻量驱动','h164-lean-analysis.json')]:
    path='subprojects/pynq_usb_hand/build/board-20261023/'+file
    d=jsrc(path);m=d['phases']['motion']
    hands.append({'version':tag,'wall_s':m['wall_seconds'],'cpu_s':m['cpu_seconds'],'one_core_pct':m['single_core_percent'],'source':path,'comparison':'non-paired historical runs'})
    for req in d['requests']:
        hr.append({'version':tag,'state':req['state'],'wall_s':req['wall_seconds'],'cpu_s':req['cpu_seconds'],'one_core_pct':req['single_core_percent'],'position_write_attempts':req.get('position_write_attempts','not collected in lean'),'source':path})
csvout('hand_motion_runs.csv',hands);csvout('hand_pose_runs.csv',hr)
idle=[]
for version,name in [('周期轮询 R19','r19'),('事件通知 R20','r20')]:
    path=f'build/r30-arm-idle-{name}.json';d=jsrc(path);assert d['result']=='PASS' and d['cleanup']=='CLEAN'
    idle.append({'version':version,'window_s':d['idle_seconds'],'codec_switches':d['idle_deltas']['codec']['voluntary_ctxt_switches'],'relay_switches':d['idle_deltas']['relay']['voluntary_ctxt_switches'],'codec_cpu_ticks':d['idle_deltas']['codec']['cpu_ticks'],'relay_cpu_ticks':d['idle_deltas']['relay']['cpu_ticks'],'source':path})
csvout('preview_idle.csv',idle)
for p in ['subprojects/pynq_usb_hand/build/board-20261023/h170-fixed-playback-pc-offline.json','subprojects/pynq_usb_hand/build/board-20261023/h165b-lean-peaks.json','subprojects/pynq_usb_hand/build/continuous-owner-offline-20261025.json']:
    jsrc(p)

font_manager.fontManager.addfont('C:/Windows/Fonts/msyh.ttc')
plt.rcParams.update({'font.family':font_manager.FontProperties(fname='C:/Windows/Fonts/msyh.ttc').get_name(),'font.size':12,'axes.spines.top':False,'axes.spines.right':False,'axes.unicode_minus':False,'svg.fonttype':'none','pdf.fonttype':42,'text.color':'#243C4D','axes.labelcolor':'#243C4D'})
BLUE='#0072B2';GRAY='#9BA9B2';TEAL='#009E73';ORANGE='#D55E00'
def save(fig,name):
    fig.tight_layout()
    fig.savefig(BASE/'figures'/(name+'.png'),dpi=300,bbox_inches='tight')
    fig.savefig(BASE/'figures'/(name+'.svg'),bbox_inches='tight');plt.close(fig)
fig,ax=plt.subplots(figsize=(8.5,3.5))
y=range(5); ax.barh(y,[r['p50_ms'] for r in vision],color=[GRAY,BLUE,BLUE,GRAY,GRAY],height=.55)
ax.set_yticks(list(y),[r['stage'] for r in vision]);ax.invert_yaxis();ax.set_xlim(0,87);ax.set_xlabel('阶段耗时中位数（ms）')
for i,r in enumerate(vision):ax.text(r['p50_ms']+1,i,f"{r['p50_ms']:.3f}" if i==4 else f"{r['p50_ms']:.2f}",va='center')
save(fig,'07_vision_profile')
fig,axs=plt.subplots(1,2,figsize=(8.5,3.5))
names=['LUT','FF','Slice','BRAM'];caps=[53200,106400,13300,140]
for k,r in enumerate(vr):
    vals=[r[n]/c*100 for n,c in zip(names,caps)]
    bars=axs[0].bar([i+(k-.5)*.36 for i in range(4)],vals,.35,label=r['version'].split()[0],color=[GRAY,BLUE][k])
    for b,v in zip(bars,vals):axs[0].text(b.get_x()+b.get_width()/2,v+1,f'{v:.1f}',ha='center',fontsize=9)
axs[0].set_xticks(range(4),names);axs[0].set_ylabel('器件占用（%）');axs[0].set_ylim(0,116);axs[0].legend(frameon=False)
axs[1].axis('off')
for y,label,value in [(.85,'Slice 剩余站点','768 → 156'),(.54,'最差 setup 余量','4 ps → 2 ps'),(.23,'DSP 使用量','14 → 20')]:
    axs[1].text(.05,y,label,fontsize=12);axs[1].text(.05,y-.14,value,fontsize=19,color=BLUE)
save(fig,'08_vision_resource_budget')
fig,axs=plt.subplots(1,2,figsize=(8.5,3.65))
for ax,key,title in [(axs[0],'one_core_pct','动作段单核等效占用（%）'),(axs[1],'wall_s','动作段合计墙钟时间（s）')]:
    vals=[r[key] for r in hands];bars=ax.bar(range(3),vals,color=[GRAY,BLUE,TEAL],width=.6)
    ax.set_xticks(range(3),[r['version'] for r in hands],fontsize=10);ax.set_ylabel(title);ax.set_ylim(0,max(vals)*1.22)
    for b,v in zip(bars,vals):ax.text(b.get_x()+b.get_width()/2,v+max(vals)*.03,f'{v:.2f}',ha='center')
save(fig,'09_hand_resource_observations')
fig,ax=plt.subplots(figsize=(8.5,3.1))
for k,r in enumerate(idle):
    bars=ax.bar([i+(k-.5)*.35 for i in range(2)],[r['codec_switches'],r['relay_switches']],.34,color=[GRAY,BLUE][k],label=r['version'])
    for b in bars:ax.text(b.get_x()+b.get_width()/2,b.get_height()+6,str(int(b.get_height())),ha='center')
ax.set_xticks([0,1],['编码进程 codec','转发线程 relay']);ax.set_ylabel('主动上下文切换增量（次）');ax.set_ylim(0,480);ax.legend(frameon=False)
save(fig,'10_preview_idle_wakeups')
fig,axs=plt.subplots(1,3,figsize=(8.5,3.4))
for ax,r in zip(axs,final_rows):
    bars=ax.bar([0,1],[r['before'],r['v2']],color=[GRAY,BLUE],width=.6)
    ax.set_xticks([0,1],['R60','v2.0']);ax.set_title(r['metric'],fontsize=11)
    ax.set_ylabel(r['unit']);ax.set_ylim(0,r['before']*1.28)
    for b,v in zip(bars,[r['before'],r['v2']]):ax.text(b.get_x()+b.get_width()/2,v+r['before']*.04,f'{v:.3f}' if r['unit']=='ms' else str(int(v)),ha='center',fontsize=10)
save(fig,'11_v2_final_comparison')

pdfmetrics.registerFont(TTFont('Sans','C:/Windows/Fonts/msyh.ttc'));pdfmetrics.registerFont(TTFont('Bold','C:/Windows/Fonts/msyhbd.ttc'));pdfmetrics.registerFontFamily('Sans',normal='Sans',bold='Bold')
styles={k:ParagraphStyle(k,fontName='Bold' if k in ['title','h','th'] else 'Sans',fontSize=size,leading=lead,spaceAfter=space,wordWrap='CJK',textColor=colors.HexColor('#203B4D'),keepWithNext=k in ['h','th']) for k,size,lead,space in [('title',26,35,13),('h',17,25,12),('body',10.5,17,9),('small',9,14,8),('cell',9,14,0),('th',9.3,14,6)]}
story=[];pages=[];cur=[]
def p(s,kind='body'):
    import html
    story.append(Paragraph(html.escape(s),styles[kind]));cur.append(f'<p class="{kind}">{html.escape(s)}</p>')
def table(title,headers,rows,widths):
    import html
    title=re.sub(r'^表 (1[3-9]|20) ',lambda m:f'表 {int(m[1])-4} ',title)
    p(title,'th');cells=[[Paragraph(html.escape(str(v)),styles['cell']) for v in row] for row in [headers]+rows]
    t=Table(cells,colWidths=widths,repeatRows=1)
    t.setStyle(TableStyle([('VALIGN',(0,0),(-1,-1),'TOP'),('BACKGROUND',(0,0),(-1,0),colors.HexColor('#EAF1F6')),('ROWBACKGROUNDS',(0,1),(-1,-1),[colors.white,colors.HexColor('#F6F9FA')]),('LEFTPADDING',(0,0),(-1,-1),7),('RIGHTPADDING',(0,0),(-1,-1),7),('TOPPADDING',(0,0),(-1,-1),6),('BOTTOMPADDING',(0,0),(-1,-1),6)]))
    story.extend([t,Spacer(1,10)])
    cur.append('<table>'+''.join('<tr>'+''.join('<td>'+html.escape(str(v))+'</td>' for v in row)+'</tr>' for row in [headers]+rows)+'</table>')
def fig(name,caption):
    im=Image(str(BASE/'figures'/(name+'.png')));story.append(KeepTogether([Image(str(BASE/'figures'/(name+'.png')),width=507,height=507*im.imageHeight/im.imageWidth),Paragraph(caption,styles['small'])]));cur.append(f'<figure><img src="figures/{name}.svg"><figcaption>{caption}</figcaption></figure>')
def page():pages.append(''.join(cur));cur.clear();story.append(PageBreak())

p('性能与资源优化报告','title')
p('Scene2D GPU、视觉下沉与灵巧手控制','h')
p('Voice View  |  PYNQ-Z2 / xc7z020clg400-1  |  整理日期 2026 年 10 月 29 日','small')
p('本报告汇总 AI 辅助下的三条优化路线：GPU 通过缓存、流水和条件性双像素提高执行吞吐；视觉将颜色分割与形态学前处理下沉 PL；灵巧手通过减少重复写入、精简驱动工作和复用控制会话降低 PS 开销。回传线程的事件通知优化进一步减少空闲唤醒。各模块按其真实实验条件评价，资源和性能数字均绑定具体版本。')
fig('01_optimization_route','图 1  GPU 优化路线。报告沿用“瓶颈分析—局部实现—结果对照”的方法，进一步评价视觉、手驱动和回传优化。')
table('优化结果总览',['优化对象','主要证据','收益与代价'],[
['GPU P0–P4','同负载 RTL 周期；完整 PL 实现','Tile 缓存+流水 5.92×，Blit 流水 4.91×；整机 LUT +6.71%，BRAM 62→60。'],
['视觉 R1→C0E','旧路径 300 帧剖析；候选物理实现与板端窗口','替换重复搬运与 PS 形态学；候选菜单窗口 18.268 fps；Slice 94.23%→98.83%，setup 余量仅 2 ps。'],
['灵巧手多轮简化','四实体按钮动作记录与独立 JSON','动作段单核等效 55.37%→18.10%→15.94%；非配对历史观察，动作总时长反而增加。'],
['回传事件通知','ARM 无硬件组件对照，约 4 秒','codec 主动切换 40→0，relay 391→4；保留进程与共享槽，不等于释放其内存。']],[91,153,263])
p('最终成果统一以 2026 年 10 月 29 日正式发布的 v2.0 完整版为准。v2.0 在同解释器 PC 对照中将悬停背景上传120→1次，单帧中位耗时1.897→0.080 ms；同时完成16条游戏对照、60项GPU功能和18项实体协议验收。上表为优化过程中的专项结果，第12节给出正式完整版的最终对比。')
p('阅读顺序：第1—6节为GPU专项实验；第7—8节为视觉下沉研发；第9—10节为手驱动简化；第11节为回传开销；第12节统一对照v2.0完整版；第13节总结资源取舍。','small')
page()

p('7  视觉下沉的瓶颈与职责重分配','h')
p('旧 R1 路径从相机采集 RGB，经 PS 复制、缩放和方向处理，再上传 SKN6 获取 mask；PS 同帧参考及形态学仍有明显开销。PL 下沉把颜色阈值、双 mask 和形态学组织为流式前处理，PS 保留轮廓、形状统计、分类投票及输入发布。优化目标是减少重复搬运和前处理开销，同时保持 BGR、方向、阈值和输出语义一致。')
fig('07_vision_profile','图 7  R1 的阶段耗时中位数。300 个不同 NO_HAND 帧，60.101 秒 HTTP 采样；源跨度 377 帧且漏采 78 帧，非全帧无损记录。来源：V1。')
table('表 13  旧路径分段耗时',['阶段','P50 ms','P95 ms','P99 ms'],[[r['stage'],f"{r['p50_ms']:.3f}",f"{r['p95_ms']:.3f}",f"{r['p99_ms']:.3f}"] for r in vision],[264,81,81,81])
p('按逐帧配对样本累加“输入准备+颜色 mask+形态学”，P50/P95/P99 为 119.09/128.70/135.85 ms。这个分布直接来自配对样本，不能用表内分位数相加替代。color_mask 包含 SKN6 事务与 CPU 参考，SKN6 子阶段 P50 为 25.19 ms；不能把整段颜色耗时都归给硬件传输。','small')
p('这组剖析明确了下沉的优先级：颜色 mask 与形态学占据主要前处理时间，适合流式并行；轮廓和分类保留在 PS，继续利用软件的灵活性。新路径把计算前移到采集侧，为 PS 释放前处理预算，后续以新帧率和完整链路继续检验收益。','small')
page()

p('8  视觉加速结果与 FPGA 资源约束','h')
fig('08_vision_resource_budget','图 8  C0D R1 与 C0E reviewed-r02 的整机资源观察。LUT、FF、Slice、BRAM 各以器件容量为分母；两版功能组成不同，不能视为纯核净增量。来源：V1、V2。')
table('表 14  视觉融合版本实现结果',['版本','LUT / FF','Slice / BRAM','WNS / WHS ns'],[[r['version'],f"{r['LUT']:,} / {r['FF']:,}",f"{r['Slice']:,} / {r['BRAM']}",f"{r['WNS']:.3f} / {r['WHS']:.3f}"] for r in vr],[121,130,130,126])
p('C0E 以增加 4,753 LUT、5,451 FF、612 Slice、2 BRAM Tile 和6 DSP实现视觉前处理下沉，并保持 100 MHz 目标。多轮时序修复后，最终 WNS/WHS 达到 0.002/0.049 ns，完成固定 DCP 的实现与配对导出。FPGA Slice 占用达到 98.83%，说明本轮选择了以较紧布局预算换取前处理并行能力。')
table('表 15  板端视觉窗口观察',['窗口','识别率','说明'],[
['R1 G21','5.5637 fps','旧版短窗口；不是候选同场景 ABBA 对照。'],
['C0E R20 B09','18.268 fps','10.18 秒默认菜单，无 JPEG 订阅窗口。'],
['R20 B10','4.777 fps','回传观察期；结果年龄中位 262.7 ms、P95 364.5 ms。'],
['R20 B16','21.183 fps','后续菜单窗口回升；中途订阅变化未全程记录。']],[125,105,277])
p('PL 下沉后，菜单窗口达到 18.268 fps，后续窗口达到 21.183 fps；与旧版 5.5637 fps 的记录相比，新路径展示了更高的新观测产出能力。回传期的 4.777 fps 波动进一步推动预览解耦与按需工作优化。R20 同时通过八条 GPU 黄金、共 3,859 tick 的共存回归，说明加速路径已接入实际应用。表内为不同运行窗口观察，比较时保留各自负载条件。来源：V2、V3。','small')
page()

p('9  灵巧手驱动简化与 CPU 观察','h')
p('17 电机灵巧手的原路径包含高频插值位置写入、反馈扫描、逐包附加审计与重复换算。第一轮改为原生阶段目标、末端降频和及时卸力；后续精简默认审计、缓存不变信息，并采用有界编解码路径。在同一套电机硬件上，这些软件修改减少了重复工作，同时保留 SDK 逐颗 ACK、错误校验与当轮保护合同。')
fig('09_hand_resource_observations','图 9  三轮实体四按钮测试的动作段结果：CPU 占用持续下降，墙钟时间体现阶段等待取舍。各轮起点与配置详见 H1—H3，按历史轮次展示。')
table('表 16  动作段总量及交互变化',['版本','墙钟 s','CPU s','单核等效','位置写入'],[[r['version'],f"{r['wall_s']:.3f}",f"{r['cpu_s']:.3f}",f"{r['one_core_pct']:.2f}%",'1,513' if i==0 else '149' if i==1 else 'lean 附加计数关闭'] for i,r in enumerate(hands)],[104,72,72,87,172])
p('减写是第一轮优化最直接的效果：位置写入尝试由 1,513 次降至149次，记录数量减少90.15%；动作段 CPU 时间由3.655 s降至1.656 s。进一步精简审计和编解码后，CPU时间降至1.441 s，单核等效占用15.94%。这些结果表明，将重复插值和附加处理移出动作热路径，能有效降低手侧软件负担。三轮为非配对历史测试，动作起点与等待策略见原件。')
p('资源节省伴随明确的时间取舍：阶段目标版动作总时长9.149 s，轻量驱动版9.038 s，均长于原插值轮的6.600 s。h164 四态分别约1.287/2.392/2.059/3.299 s；动作内100 ms采样峰值最高39.59%，全程含启动峰值108.76%。平均占用与窗口峰值分别列示，便于继续优化启动热点。','small')
page()

p('10  预计算动作与持续会话复用','h')
table('表 17  从逐动作流程到固定播放',['环节','原流程','简化后及边界'],[
['启动','模型导入、冻结校验、connect/arm、自检与对齐','启动仍执行必要身份与设备检查；在同一有效会话内只 arm 一次。'],
['轨迹','动作期插值、换算及反馈驱动','构造时预计算阶段 raw 目标，动作期写目标并执行可取消等待。'],
['反馈','依模式取得实测位置与三帧到位判断','固定播放正常动作 0 READ，逐颗 ACK 保留；played 仅表示播放完成。'],
['调度','每键完成后卸力，再接下一动作','持续来源下复用 Controller/enable epoch；动作后只处理最新帧，忙时不积压旧命令。'],
['退出','释放并核回执','保留 17 OFF 与回读；来源失活/撤销/身份改变触发取消、关闭。']],[60,170,277])
p('固定播放的 PC 门禁 h170 为 137 测试、117 个冻结文件一致；32 个唯一组合各连续两次，验证 64 次正常播放零 READ。测试中 0.1/0.2/0.3 秒是假时钟刺激，不能作为真实机械等待时间。持续 owner 后续 182 项离线测试通过，35.297 秒驻留测试跨过原 30 秒边界，但使用内存串口与线程替代，不是实体长稳态。来源：H4、H5。')
p('预计算使动作热路径聚焦于“写目标—等待—响应取消”，持续会话则复用初始化与使能结果，避免每个手势重复进入完整启动流程。两者分别减少动作内计算和跨动作固定成本。固定播放采用定时完成语义，输出played；机械到位和持续温升单独验收。')
table('表 18  后续实体接入证据',['记录','已验证','验收范围与进展'],[
['10 月 25 日 r04','现场反馈剪刀与回默认正确；owner 117.718 s；退出 17 OFF 确认','完成现场交互与退出验证；末项在正常关闭时取消。'],
['r04 的 10.011 s 窗口','手侧约 1.498% 单核，RSS 约 23.0 MiB','混合运行窗口观察；动作占比未单独标记。'],
['10 月 28 日 R60','正常入口 HAND ACTIVE、无总时限，预览关闭','持续会话接入完成，交给真人操作；等待现场反馈。']],[105,205,197])
p('来源：H6、H7。现场剪刀及回默认验证把离线预计算路径推进到真实交互；完整17颗OFF回执验证退出清理。持续运行版本已接入正常入口，后续重点为阶段等待、持力温升和异常恢复。','small')
page()

p('11  回传按需工作与空闲唤醒优化','h')
p('视觉下沉后，预览编码和轮询仍会争用 ARM、内存与 DDR。R30 将 codec 的 100 ms 周期等待改为 Event 通知，relay 从 10 ms 管道轮询改为结果/任务/退出事件等待；保持原双 slot 和 latest-only 策略，不增加线程或无界任务队列。relay 仅保留 1 秒本地故障检查。')
fig('10_preview_idle_wakeups','图 10  板端 ARM 无硬件组件对照，约 4.008 秒空闲窗口。主动切换作为唤醒开销的观察指标；两轮均收到 frame1/2/3 并 CLEAN 退出。来源：P1、P2。')
table('表 19  空闲窗口记录',['版本','窗口 s','codec / relay 主动切换','codec / relay CPU ticks'],[[r['version'],f"{r['window_s']:.4f}",f"{r['codec_switches']} / {r['relay_switches']}",f"{r['codec_cpu_ticks']} / {r['relay_cpu_ticks']}"] for r in idle],[129,88,160,130])
p('事件通知直接消除了 codec 的40次周期性主动切换，并将relay切换由391次降至4次，约减少98.98%。对应CPU ticks由0/9变为0/0。保留已初始化进程待命，使空闲时减少工作、需要回传时快速恢复；共享槽容量和进程数量保持稳定。CPU tick按原采样粒度记录。')
p('真实菜单、三游戏和视频中共 10 条 MJPEG 流、30 张 640×360 JPEG 解码及重连通过。独立停播观察还记录约 68.994 秒编码/JPEG 序号不再增长，而视觉源前进 1,619 帧，说明预览可停止工作而不停止识别。后者验证控制行为，不提供 CPU 节省百分比。来源：P3、P4。','small')
page()

p('12  与 v2.0 完整版的最终对比','h')
p('最终优化后版本选用正式发布 v2.0，软件清单为5f53d85d…41e9d56，BUILD_ID为0xC0061000。画板性能采用同解释器、同通用图像校验、每组120帧的R60/v2.0配对PC基准；实际板端功能另由发行验收原件确认。')
fig('11_v2_final_comparison','图11  R60与v2.0最终画板优化对照。悬停背景上传减少99.17%，单帧中位耗时减少95.77%（23.66×）；绘制中位耗时减少16.00%。测量范围：PC CPU，无GPU/网络计时。来源：F1。')
table('最终对比  优化前路径与 v2.0 完整版',['对象','优化前 / 中间路径','v2.0 完整版结果'],[
['画板资源','悬停每帧重建/上传背景；120帧120次','复用背景，四条GPU边框命令；120帧仅1次背景上传。'],
['画板输入','独立分类可否决UI握拳；限频前提前消费帧','使用同源新鲜ControlState；接受后消费帧；实体40次有效修订、固定46,080字节。'],
['灵巧手','每次动作重复使能/反馈；菜单进入存在空档','固定播放持续owner；首次开机及HOME/GAMES/VIDEOS跟随；回传/画板/视频有界交接。'],
['视觉与PL','C0E为下沉研发与时序实验对象','最终沿用C0061000配对Overlay，WNS/WHS=0.011/0.050 ns。'],
['GPU实验','P0–P4展示缓存、流水与双像素的专项周期收益','发行HWH中这些实验开关为0；最终GPU收益以画板复用与60项功能验收体现。']],[67,207,233])
p('v2.0完整验收：四游戏16条PC/PYNQ逐tick对照、真实GPU60项、实体串口18项、两次实际exec与17OFF/CLOSED、Studio重连和正常入口均通过。优化既有量化效率结果，也已完成完整版集成验证。来源：F2、F3。','small')
page()
p('13  优化有效性与资源取舍总结','h')
table('表 20  优化效果与下一阶段评价',['目标','已形成的证据','进一步量测'],[
['提高绘图吞吐','GPU 同负载周期、CRC、完整扫描和实现报告','P0/P4 同 Scene submit→present 分布及实际 FPS。'],
['减少视觉前处理','旧路径剖析、PL 资源/时序与真实新帧推进','固定场景/订阅/诊断负载，采集配对阶段与端到端时延。'],
['降低手侧软件开销','写包、动作段 CPU/墙钟、固定播放零 READ 合同','相同起点、阶段等待、动作序列配对；记录机械到位与温升。'],
['减少后台空转','ARM 空闲组件切换计数、真实回传重连','长窗口 CPU/PSS、按需模式切换成本和识别源龄。'],
['维持资源余量','各版本完整 PL 报告与具体 FPGA 站点余量','融合版本独立签核；避免将模块 OOC 增量简单相加。']],[105,194,208])
p('建议统一测量合同：固定配对包 SHA、BUILD_ID、驱动和输入；每组预热后执行多轮配对，交替顺序。CPU 报进程家族累计时间、墙钟和单核等效；时延报 P50/P95/P99、样本数和缺失；资源报整机 post-route，功耗另做同供电点测量。各阶段分位数不得相加，逻辑吞吐和物理端到端时延分别报告。')
p('AI 辅助方法：以约束和原始计时形成瓶颈假设，生成可关闭或隔离候选，保留独立黄金、失败日志和版本身份，再根据工具及实物反馈决定采纳。视觉的 backpressure/CDC/时序、灵巧手的 ACK/来源撤销/退出和预览的丢弃策略都应进入验证，不能只保留最优速度。')
p('新增来源索引','th')
p('F1 canvas-benchmark.json；F2 v2.0发行/画板菜单记录；F3 acceptance-summary.json及发行回执；F4发行overlay的HWH、manifest和timing。V1视觉延迟方案；V2时序修复；V3 R20板测。H1—H3为h143/h150/h164 JSON，H4固定播放，H5持续owner，H6 r04现场，H7 R60。P1/P2为r30 ARM空闲JSON，P3 R30记录，P4停播记录。GPU S1—S9沿用前章。原件与SHA见data/source_manifest.json。','small')
p('报告以结果对照、机制解释和验证闭环展示优化有效性：GPU 提升执行吞吐，视觉提高新观测产出，灵巧手降低动作热路径 CPU 负担，事件通知减少空闲唤醒。写作参考沿用墨尔本大学 Technical reports、Michael Ernst 与 Nature 制图指南。数据为归档实验结果，本次完成材料整理与核对。','small')
pages.append(''.join(cur))
tmp=BASE/'qa/new_sections.pdf';SimpleDocTemplate(str(tmp),pagesize=A4,leftMargin=44,rightMargin=44,topMargin=36,bottomMargin=43,title='性能与资源优化报告').build(story)
new=PdfReader(tmp);assert len(new.pages)==8, len(new.pages)
gpu_code=(OLD/'tools/build_report.py').read_text(encoding='utf-8')
replacements={
'不同测试负载的加速比各自报告，不能相乘作为整机加速比。':'各项加速比绑定对应负载，资源收益按整机实现评价。',
'本节的周期减少不能直接换算成整机 FPS 增幅。':'本节以执行周期评价局部优化，整机呈现另按完整回放评价。',
'双像素吞吐受合法对齐、同一源 byte、行内边界和透明 lane 限制；其他场景保留单像素路径。峰值达到 2 像素/拍，不代表所有负载平均吞吐翻倍。不同阶段的倍数也不能直接相乘。':'双像素路径在合法对齐和行内边界内达到2像素/拍，单像素兼容路径覆盖其他输入。',
'不能写成完整游戏或 P4 整机加速 8.82 倍。':'该结果刻画了 Tile 单元内的累计收益。',
'该用例的主要收益来自 CLEAR/FILL，不宜据此声称所有精灵场景均加速 2 倍。':'该用例的主要收益来自 CLEAR/FILL 双写，四组合对照明确了各路径贡献。',
'应表述为“满足本轮既有门禁”，不能写成零告警或所有 I/O 时序完全签核。':'本轮实现满足既有门禁，保留告警按原范围记录。',
'AI 辅助解释反馈并形成可检验修改；独立黄金和工具报告决定该轮是否通过。':'AI辅助缩短定位与改写链路，黄金回归和工具报告验证修改效果。',
'AI辅助缩短定位与改写链路':'AI辅助完成定位与改写',
}
for old,newtext in replacements.items():gpu_code=gpu_code.replace(old,newtext)
gpu_code=gpu_code.replace('table_no=0','table_no=-1').replace('表 5 汇总','表 4 汇总').replace('表 8 用局部','表 7 用局部')
ns={'__name__':'report_gpu_section','__file__':str(OLD/'tools/build_report.py')};exec(compile(gpu_code,str(OLD/'tools/build_report.py'),'exec'),ns)
gpu_root=BASE/'qa/gpu_section';gpu_root.mkdir(parents=True,exist_ok=True)
ns.update(BASE=gpu_root,DATA=gpu_root/'data',EVID=gpu_root/'evidence',FIG=BASE/'figures')
gpu_rows=ns['extract']();gpu_path=ns['build'](*gpu_rows)
gpu=PdfReader(gpu_path);assert len(gpu.pages)==9
ordered=[new.pages[0]]+list(gpu.pages[1:7])+list(new.pages[1:])
w=PdfWriter()
for n,pdfpage in enumerate(ordered,1):
    buf=io.BytesIO();c=Canvas(buf,pagesize=A4);c.setFillColor(colors.white);c.rect(0,0,A4[0],35,fill=1,stroke=0);c.setFillColor(colors.HexColor('#69808E'));c.setFont('Sans',7.5);c.drawString(44,25,'Voice View  /  性能与资源优化报告');c.drawRightString(A4[0]-44,25,f'{n:02d}');c.save();buf.seek(0);pdfpage.merge_page(PdfReader(buf).pages[0]);w.add_page(pdfpage)
w.add_metadata({'/Title':'性能与资源优化报告','/Author':'Voice View project'})
with (BASE/'性能与资源优化报告.pdf').open('wb') as f:w.write(f)
oldhtml=(gpu_root/'chapter.html').read_text(encoding='utf-8');oldsections=re.findall(r'<section>(.*?)</section>',oldhtml,re.S)
css=re.search(r'<style>(.*?)</style>',oldhtml,re.S)[1]
allsections=[pages[0]]+oldsections[1:7]+pages[1:]
allsections[-1]+='<p class="small">写作参考：<a href="https://students.unimelb.edu.au/academic-skills/reading-writing-and-referencing/reports/technical-report-writing">墨尔本大学技术报告教程</a> · <a href="https://homes.cs.washington.edu/~mernst/advice/write-technical-paper.html">Michael Ernst 技术论文写作</a> · <a href="https://research-figure-guide.nature.com/figures/preparing-figures-our-specifications/">Nature 制图指南</a></p>'
(BASE/'chapter.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>性能与资源优化报告</title><style>'+css+'</style><body>'+''.join('<section>'+s+'</section>' for s in allsections)+'</body></html>',encoding='utf-8')
(BASE/'data/source_manifest.json').write_text(json.dumps(list(tracked.values()),ensure_ascii=False,indent=2),encoding='utf-8')
for row in tracked.values():assert hashlib.sha256((BASE/'evidence'/row['path']).read_bytes()).hexdigest()==row['sha256']
(BASE/'README.txt').write_text('性能与资源优化报告，2026-10-29\n14页，最终对比统一采用正式v2.0完整版。第12节包含R60/v2.0画板配对PC对照与完整发行验收。早期GPU与C0E为专项研发记录。\nfigures含11组300dpi PNG与SVG；data含原始/派生CSV和来源SHA。chapter.html可编辑。\n运行：使用包含reportlab/pypdf的Python执行 tools/build_report.py；保留同项目原gpu_ai_preparation目录。绘图依赖复用其中.plot_deps，或安装matplotlib。\n预期输出：PDF/HTML/图表/数据及report/性能与资源优化报告_材料包.zip。下一步：合入AI报告。\n',encoding='utf-8')
qa={'pages':len(ordered),'source_files':len(tracked),'source_hash_checks':'PASS','figures':11,'new_data_tables':6,'final_version':'v2.0 / bd6858bbe4ded19caf1f91322850150c97cab21e','scope':'archival evidence, no new hardware experiments','visual_review':'pending'}
(BASE/'data/expanded_verification.json').write_text(json.dumps(qa,ensure_ascii=False,indent=2),encoding='utf-8')
def bundle():
    with zipfile.ZipFile(BASE.parent/'性能与资源优化报告_材料包.zip','w',zipfile.ZIP_DEFLATED) as z:
        for f in BASE.rglob('*'):
            if f.is_file() and not any(a in f.relative_to(BASE).parts for a in ['qa','__pycache__']):z.write(f,Path(BASE.name)/f.relative_to(BASE))
bundle();print(json.dumps(qa,ensure_ascii=False))
