"""Render report figures from extracted data. Requires matplotlib and numpy.

Run: python plot_figures.py --data ../data --output ../figures
Outputs: six PNG/SVG figure pairs. Next: run build_report.py for the report.
"""
import argparse
import csv
from pathlib import Path
import sys
import os
os.environ['MPLCONFIGDIR'] = str(Path(__file__).resolve().parents[1]/'qa'/'.matplotlib')
local_deps = Path(__file__).resolve().parents[1]/'.plot_deps'
if local_deps.is_dir():
    sys.path.insert(0, str(local_deps))
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib import font_manager
import numpy as np

def main():
    p = argparse.ArgumentParser()
    p.add_argument('--data', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    a.output.mkdir(parents=True, exist_ok=True)
    font = Path('C:/Windows/Fonts/msyh.ttc')
    if font.exists():
        font_manager.fontManager.addfont(str(font))
        plt.rcParams['font.family'] = font_manager.FontProperties(fname=str(font)).get_name()
    plt.rcParams.update({'font.size': 12.5, 'axes.spines.top': False,
        'axes.spines.right': False, 'axes.unicode_minus': False,
        'axes.labelcolor': '#263746', 'text.color': '#263746',
        'xtick.color': '#52616D', 'ytick.color': '#52616D',
        'axes.edgecolor': '#9AA8B3', 'axes.linewidth': .8,
        'svg.fonttype': 'none', 'pdf.fonttype': 42, 'figure.facecolor': 'white'})
    blue, orange, teal, gray = '#0072B2', '#D55E00', '#009E73', '#727B85'
    def read(name):
        with (a.data/name).open(encoding='utf-8-sig', newline='') as f:
            return list(csv.DictReader(f))
    def save(fig, name):
        fig.savefig(a.output/(name+'.png'), dpi=300, bbox_inches='tight', facecolor='white')
        fig.savefig(a.output/(name+'.svg'), bbox_inches='tight', facecolor='white')
        plt.close(fig)

    fig, ax = plt.subplots(figsize=(8.6, 2.3))
    ax.axis('off')
    labels = ['P0 基线\n串行处理','P1 缓存\n描述符复用',
              'P2 流水\n像素连续执行','P3 双像素\n条件性双写','P4 重叠\n预上传场景']
    for i, label in enumerate(labels):
        x = .02+i*.20
        ax.text(x+.08,.64,label,ha='center',va='center',transform=ax.transAxes,
                bbox=dict(boxstyle='round,pad=0.6',fc='#EFF5F8',ec='#A8BFCD'),fontsize=11)
        if i < 4:
            ax.annotate('',xy=(x+.205,.64),xytext=(x+.164,.64),xycoords='axes fraction',arrowprops=dict(arrowstyle='->',color=gray))
    ax.text(.5,.14,'提出假设  →  局部改写  →  黄金回归  →  资源与时序检查  →  保留可复验证据',
            transform=ax.transAxes,ha='center',fontsize=11)
    save(fig,'01_optimization_route')

    rows=read('tile_ablation.csv')
    fig, ax = plt.subplots(figsize=(8.6,4.7))
    vals=[int(r['cycles']) for r in rows]
    labels=[f"{r['cache']} / {r['pipeline']} / {r['pair']}" for r in rows]
    bars=ax.barh(np.arange(8),vals,color=[teal if i==7 else blue if i in (4,6) else '#B7C0C7' for i in range(8)],height=.62)
    ax.set_yticks(np.arange(8),labels)
    ax.invert_yaxis(); ax.set_xlim(0,18100); ax.set_xlabel('执行周期（cycle，越少越好）')
    ax.set_ylabel('缓存 / 流水 / 双像素')
    ax.set_xticks([0,4000,8000,12000,16000])
    for b,v in zip(bars,vals):
        ax.text(v+170,b.get_y()+b.get_height()/2,f'{v:,}  |  {13860/v:.2f}×',va='center',fontsize=11.5)
    ax.set_title('同负载消融  ·  100 MHz  ·  1,440 次有效写入',loc='left',pad=12,fontsize=13)
    fig.tight_layout(); save(fig,'02_tile_ablation')

    rows=read('performance.csv')
    chosen=[rows[1],rows[4],rows[5]]
    fig, axes=plt.subplots(1,3,figsize=(8.6,3.65))
    for ax,r in zip(axes,chosen):
        b,o=int(r['before']),int(r['after'])
        if r['short_name']=='栅格双像素':
            cases=read('raster_ablation.csv')
            numbers=[int(v['cycles']) for v in cases]
            bars=ax.bar(range(4),numbers,color=[gray,'#A8BFCD',blue,teal],width=.68)
            ax.set_xticks(range(4),['全关','Blit','实色','全开'],fontsize=9.3)
        else:
            numbers=[b,o]
            bars=ax.bar([0,1],numbers,color=[gray,blue],width=.6)
            ax.set_xticks([0,1],['关闭','开启'])
        ax.set_ylim(0,b*1.3)
        ax.set_ylabel('周期（cycle）'); ax.set_title(r['short_name']+'\n'+f'{b/o:.2f}×  /  -{(1-o/b)*100:.2f}%',fontsize=12)
        for bar,v in zip(bars,numbers):
            ax.text(bar.get_x()+bar.get_width()/2,v+b*.03,f'{v:,}',ha='center',fontsize=9 if len(numbers)==4 else 11,rotation=90 if len(numbers)==4 else 0)
        ax.ticklabel_format(axis='y',style='plain')
    fig.tight_layout(w_pad=2); save(fig,'03_workload_comparisons')

    rows=read('resources.csv'); first,last=rows[0],rows[-1]
    fig, axes=plt.subplots(1,2,figsize=(8.6,3.75))
    names=['LUT','FF','Slice','BRAM']; caps=[53200,106400,13300,140]
    x=np.arange(4)
    for offset,row,c,label in [(-.19,first,gray,'P0'),(.19,last,blue,'P4')]:
        vals=[int(row[k])/cap*100 for k,cap in zip(names,caps)]
        bars=axes[0].bar(x+offset,vals,.36,color=c,label=label)
        for bar,v in zip(bars,vals):
            axes[0].text(bar.get_x()+bar.get_width()/2,v+.8,f'{v:.1f}',ha='center',fontsize=9)
    axes[0].set_xticks(x,names); axes[0].set_ylabel('器件容量占用（%）'); axes[0].set_ylim(0,68)
    axes[0].legend(frameon=False); axes[0].set_title('a  器件容量占用',loc='left',fontsize=13)
    for k,c in [('LUT',blue),('FF',orange),('Slice',teal)]:
        vals=[(int(r[k])/int(first[k])-1)*100 for r in rows]
        axes[1].plot(range(7),vals,'o-',label=k,color=c,linewidth=1.8,markersize=4)
    axes[1].set_xticks(range(7),[r['stage'] for r in rows],rotation=40,ha='right')
    axes[1].set_ylim(-1,8); axes[1].set_ylabel('相对 P0 的资源变化（%）')
    axes[1].axhline(0,color='#B0B6BC',linewidth=.8); axes[1].legend(frameon=False,ncol=3,fontsize=9)
    axes[1].set_title('b  累计资源变化',loc='left',fontsize=13)
    fig.tight_layout(); save(fig,'04_resource_tradeoff')

    fig,ax=plt.subplots(figsize=(8.6,3.3))
    for key,c,marker in [('WNS',blue,'o'),('WHS',orange,'s')]:
        vals=[float(r[key]) for r in rows]
        ax.plot(range(7),vals,marker=marker,color=c,label=key,linewidth=1.8)
        for i,v in enumerate(vals):
            other=float(rows[i]['WHS' if key=='WNS' else 'WNS'])
            offset=10 if v>=other else (-9 if v<.025 else -16)
            ax.annotate(f'{v:.3f}',(i,v),xytext=(0,offset),textcoords='offset points',ha='center',fontsize=10.5)
    ax.axhline(0,color='black',linewidth=1,label='零余量门槛')
    ax.set_ylim(-.018,.170); ax.set_xticks(range(7),[r['stage'] for r in rows])
    ax.set_ylabel('最差时序余量（ns）')
    ax.legend(frameon=False,ncol=3,loc='upper right',fontsize=11); fig.tight_layout(); save(fig,'05_timing_margin')

    fig,axes=plt.subplots(1,2,figsize=(8.6,3.4))
    bars=axes[0].bar(['重叠关闭','重叠开启'],[0,520],color=[gray,blue],width=.55)
    axes[0].set_ylabel('内部上传握手数（次）'); axes[0].set_ylim(0,650)
    for b,v in zip(bars,[0,520]): axes[0].text(b.get_x()+b.get_width()/2,v+15,str(v),ha='center')
    axes[0].set_title('a  渲染 busy 期间',loc='left',fontsize=13)
    axes[1].axis('off')
    for y,label,value in [(.83,'两 Scene 总写入','57,602 → 57,602'),(.57,'CLEAR trace CRC','A0708AC3 → A0708AC3'),(.31,'FILL trace CRC','3094986A → 3094986A')]:
        axes[1].text(.03,y,label,fontsize=11); axes[1].text(.03,y-.13,value,fontsize=12.5,color='black')
    axes[1].set_title('b  输出一致性',loc='left',fontsize=13)
    fig.tight_layout(); save(fig,'06_overlap_correctness')

if __name__=='__main__':
    main()
