"""Render the hand communication comparison from archived records.

Run: python plot_hand_comparison.py --data PATH --output PATH [--deps PATH]
Requires matplotlib/numpy; --deps may point to an existing compatible installation.
Outputs: 04_comparison.{png,svg,pdf}, comparison_metrics.csv, comparison_data.json.
Next: inspect the PNG and retain the measurement scopes when redrawing.
No hardware, network, or runtime process is accessed.
"""
from pathlib import Path
import argparse
import csv
import hashlib
import json
import os
import sys


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--data',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--deps',type=Path)
    parser.add_argument('--font',type=Path)
    a=parser.parse_args()
    if a.deps: sys.path.insert(0,str(a.deps.resolve()))
    a.output.mkdir(parents=True,exist_ok=True)
    os.environ.setdefault('MPLCONFIGDIR',str(a.output/'.matplotlib'))
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    from matplotlib import font_manager
    import numpy as np

    font=a.font or Path('C:/Windows/Fonts/msyh.ttc')
    if font.is_file():
        font_manager.fontManager.addfont(str(font))
        family=font_manager.FontProperties(fname=str(font)).get_name()
    else: family='sans-serif'
    plt.rcParams.update({'font.family':family,'font.size':13,'svg.fonttype':'none',
        'pdf.fonttype':42,'axes.spines.top':False,'axes.spines.right':False,
        'axes.spines.left':False,'axes.spines.bottom':False,'axes.unicode_minus':False,
        'text.color':'#172b3a','axes.labelcolor':'#172b3a','xtick.color':'#465968',
        'ytick.color':'#465968','savefig.facecolor':'white'})
    PINK='#bf286e'; GRAY='#a9b5bf'; BLUE='#d6e7f1'; DARK='#172b3a'
    files=['h143-buttons-cpu-analysis.json','h150-minimal-analysis.json','h164-lean-analysis.json']
    labels=['插值写入\nH143','阶段目标\nH150','阶段目标＋轻量审计\nH164']
    board=[]; rows=[]; source_hashes={}
    for fname,label in zip(files,labels):
        path=a.data/fname; raw=path.read_bytes(); d=json.loads(raw)
        source_hashes[fname]=hashlib.sha256(raw).hexdigest()
        m=d['phases']['motion']
        assert abs(m['cpu_seconds']/m['wall_seconds']*100-m['single_core_percent'])<1e-8
        assert len(d['requests'])==4
        board.append(dict(label=label,source=fname,**m))
        for key,unit in [('cpu_seconds','s'),('wall_seconds','s'),('single_core_percent','% of one core')]:
            rows.append(dict(panel='board_historical',case=label.replace('\n',' / '),
                metric=key,value=m[key],unit=unit,source=fname,
                scope='Motion segment; four poses once per run; unmatched historical starts/configuration'))
    p=a.data/'verification-final.json'; raw=p.read_bytes(); offline=json.loads(raw)
    source_hashes[p.name]=hashlib.sha256(raw).hexdigest()
    results=offline['fixed_playback_budget']['results']
    poses=['default','paper','scissors','rock']; writes={False:[],True:[]}
    for state in poses:
        for skip in (False,True):
            found=[r for r in results if r['start']=='default' and r['state']==state and r['skip_unchanged']==skip]
            assert len(found)==1
            r=found[0]; assert r['repetitions']==2 and r['read_packets']==0
            writes[skip].append(r['write_packets'])
            rows.append(dict(panel='offline_paired',case=state,metric='write_packets_dedup_'+str(skip),
                value=r['write_packets'],unit='packets',source=p.name,
                scope='Fresh default-start case; two Motion.run calls; startup/arm/release excluded'))
    totals=[sum(writes[x]) for x in (False,True)]
    wire_bytes=[v*19 for v in totals]
    wire_ms=[v*10/1_000_000*1000 for v in wire_bytes]
    savings=(1-totals[1]/totals[0])*100
    for metric,values,unit in [('write_packets',totals,'packets'),('tx_plus_ack_bytes',wire_bytes,'B'),
                                ('ideal_wire_time',wire_ms,'ms')]:
        for method,value in zip(('all_stage_targets','skip_unchanged'),values):
            rows.append(dict(panel='offline_aggregate',case=method,metric=metric,value=value,unit=unit,
                source=p.name,scope='Sum of four independent two-play cases; wire derived at 1 Mbaud 8N1; 13 B TX + 6 B ACK'))
    with (a.output/'comparison_metrics.csv').open('w',encoding='utf-8-sig',newline='') as f:
        w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
    data=dict(board_runs=board,offline=dict(poses=poses,writes_all=writes[False],writes_cached=writes[True],
        total_writes=totals,total_tx_ack_bytes=wire_bytes,ideal_wire_ms=wire_ms,saved_percent=savings),
        source_sha256=source_hashes,method=dict(board='Unpaired historical PYNQ process observations, not v3.0 whole-system measurement',
        offline='Same-case SDK memory transport; communication counts only',
        formula='cpu_pct=cpu_s/wall_s*100; wire_B=write_count*19; ideal_ms=wire_B*10/1e6*1000',
        omitted='No paired RSS/memory or final v3.0 CPU comparison available in these records'))
    (a.output/'comparison_data.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

    fig=plt.figure(figsize=(19,12.5),facecolor='white')
    fig.text(.5,.966,'PYNQ  /  灵巧手驱动与低负荷通信  /  04 数据对照',ha='center',fontsize=12,color='#516473')
    fig.text(.5,.913,'灵巧手通信与软件开销对照',ha='center',fontsize=29,weight='bold')
    fig.text(.055,.855,'板端历史实测',fontsize=18,weight='bold',color=PINK)
    fig.text(.215,.855,'动作段合计 · 四姿态各一次 · CPU 单核等效，100% = 占满一核',fontsize=12)
    ax=fig.add_axes([.085,.552,.37,.245])
    x=np.arange(3); cpu=[r['single_core_percent'] for r in board]
    bars=ax.bar(x,cpu,color=[GRAY,'#927792',PINK],width=.53,zorder=3)
    ax.set_title('A  进程 CPU 平均占用',loc='left',fontsize=16,pad=16,weight='bold')
    ax.set_ylabel('单核等效（%）');ax.set_ylim(0,65);ax.set_yticks([0,20,40,60])
    ax.set_xticks(x,labels,fontsize=12);ax.grid(axis='y',color='#e4e9ee',zorder=0)
    ax.tick_params(length=0,pad=9)
    for b,v in zip(bars,cpu):ax.text(b.get_x()+b.get_width()/2,v+1.7,f'{v:.2f}%',ha='center',fontsize=16,weight='bold')
    ax2=fig.add_axes([.565,.552,.38,.245]);width=.31
    wall=[r['wall_seconds'] for r in board];cput=[r['cpu_seconds'] for r in board]
    bw=ax2.bar(x-width/2,wall,width,color=BLUE,label='墙钟时间',zorder=3)
    bc=ax2.bar(x+width/2,cput,width,color=PINK,label='CPU 时间',zorder=3)
    ax2.set_title('B  动作段耗时',loc='left',fontsize=16,pad=16,weight='bold')
    ax2.set_ylabel('时间（s）');ax2.set_ylim(0,11.8);ax2.set_yticks([0,3,6,9])
    ax2.set_xticks(x,labels,fontsize=12);ax2.grid(axis='y',color='#e4e9ee',zorder=0);ax2.tick_params(length=0,pad=9)
    ax2.legend(loc='upper left',ncols=2,frameon=False,fontsize=11)
    for bars,vals in [(bw,wall),(bc,cput)]:
        for b,v in zip(bars,vals):ax2.text(b.get_x()+b.get_width()/2,v+.22,f'{v:.3f}',ha='center',fontsize=12)
    fig.text(.055,.484,'H143 / H150 / H164：2026-10-23 研发记录；各轮起点、等待与审计配置不同，作为历史阶段观察。',fontsize=11,color='#516473')
    fig.add_artist(plt.Line2D([.055,.945],[.463,.463],transform=fig.transFigure,color='#dce3e9',lw=1))
    fig.text(.055,.418,'同用例离线对照',fontsize=18,weight='bold',color=PINK)
    fig.text(.238,.418,'固定播放 · 每个姿态由 default 起始，连续播放两次 · 逐 ID 应答保留',fontsize=12)
    ax3=fig.add_axes([.085,.135,.455,.225]);x4=np.arange(4);w=.31
    b0=ax3.bar(x4-w/2,writes[False],w,color=GRAY,label='逐阶段全量写',zorder=3)
    b1=ax3.bar(x4+w/2,writes[True],w,color=PINK,label='跳过未变目标',zorder=3)
    ax3.set_title('C  位置指令写包数',loc='left',fontsize=16,pad=17,weight='bold')
    ax3.set_ylabel('写包数（次）');ax3.set_ylim(0,132);ax3.set_yticks([0,30,60,90,120])
    ax3.set_xticks(x4,['default','张手','剪刀','握拳']);ax3.grid(axis='y',color='#e4e9ee',zorder=0)
    ax3.tick_params(length=0,pad=9);ax3.legend(loc='upper left',ncols=2,frameon=False,fontsize=11)
    for bars,vals in [(b0,writes[False]),(b1,writes[True])]:
        for b,v in zip(bars,vals):ax3.text(b.get_x()+b.get_width()/2,v+3,f'{v}',ha='center',fontsize=13)
    fig.text(.60,.373,'D  四用例合计',fontsize=16,weight='bold')
    fig.text(.60,.341,'指标',fontsize=12,color='#516473')
    fig.text(.79,.341,'全量写',ha='center',fontsize=12,color='#516473')
    fig.text(.91,.341,'跳过未变目标',ha='center',fontsize=12,color=PINK)
    table=[('位置写包（次）',str(totals[0]),str(totals[1])),
           ('报文总量（kB）',f'{wire_bytes[0]/1000:.3f}',f'{wire_bytes[1]/1000:.3f}'),
           ('理论线占用（ms）',f'{wire_ms[0]:.2f}',f'{wire_ms[1]:.2f}')]
    for i,(label,left,right) in enumerate(table):
        y=.293-i*.050
        fig.text(.60,y,label,fontsize=12)
        fig.text(.79,y,left,ha='center',fontsize=17,weight='bold')
        fig.text(.91,y,right,ha='center',fontsize=17,weight='bold',color=PINK)
    fig.text(.60,.137,f'该组用例的写包与通信字节减少 {savings:.1f}%',fontsize=13,color=PINK,weight='bold')
    fig.text(.055,.077,'离线口径：四个独立用例汇总，动作段均为 0 次寄存器 READ；启动、使能、卸力不计入。',fontsize=11,color='#516473')
    fig.text(.055,.049,'线占用 = 写包数 ×（13 B 指令 + 6 B 应答）× 10 bit / 1 Mbaud；不含 USB、设备处理、调度等待与机械运动。',fontsize=11,color='#516473')
    fig.text(.945,.016,'来源：H143 / H150 / H164 原始分析 JSON · verification-final.json / fixed_playback_budget',ha='right',fontsize=9,color='#697586')
    for ext in ('png','svg','pdf'):
        fig.savefig(a.output/f'04_comparison.{ext}',dpi=240)
    plt.close(fig)
    print(json.dumps(dict(output=str(a.output),board_cpu_percent=cpu,writes=totals,ideal_wire_ms=wire_ms),ensure_ascii=False))


if __name__=='__main__':main()
