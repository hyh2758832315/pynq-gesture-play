"""Plot completed cosim receipts using matplotlib (no board or network access).

Run with a Python environment containing matplotlib:
  python subprojects/volume_response_offline/cosim/plot_cosim.py --output build/volume-response/cosim-summary-r01
Outputs: comparison.png, comparison.svg, summary.json. Next: consult the bound
receipts for exact assertions; curves represent simulation, not a board capture.
"""
import argparse
import csv
import hashlib
import json
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

ROOT=Path(__file__).resolve().parents[3]


def read_csv(path):
    with path.open() as stream:
        return [{k:int(v) for k,v in r.items()} for r in csv.DictReader(stream)]


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--production-cadence',action='store_true',help='Use corrected 20 ms producer/independent OSD runs')
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    cases=[('cosim-r03','Normal stereo input'),('cosim-left-missing-r01','Fault injection: right channel only'),
           ('cosim-human-r01','Captured human voice, original 24-bit samples'),
           ('cosim-publisher-paused-r01','Fault injection: OSD publisher paused')]
    if a.production_cadence:
        cases=list(zip(('cosim-production-normal-r01','cosim-production-left-missing-r01',
                        'cosim-production-human-r01','cosim-production-publisher-paused-r01'),
                       (title for _,title in cases)))
    fig,axes=plt.subplots(2,2,figsize=(13,8),sharex=True,constrained_layout=True)
    summary=[]
    for ax,(name,title) in zip(axes.flat,cases):
        directory=ROOT/'build/volume-response'/name
        receipt=json.loads((directory/'receipt.json').read_text())
        assert receipt['status']=='DIGITAL_FUNCTIONAL_COSIM_PASS',name
        windows=read_csv(directory/'windows.csv');frames=read_csv(directory/'frames.csv')
        bars=read_csv(directory/'bar.csv')
        polls=[json.loads(line) for line in (directory/'polls.jsonl').read_text().splitlines()]
        measured={r['frame']:0 for r in frames}
        for pixel in bars:
            if pixel['x']==1269 and pixel['rgb'] in (0x4070e0,0xff40cc,0xff4848):
                measured[pixel['frame']]=max(measured.get(pixel['frame'],0),480-pixel['y'])
        ax.plot([r['ns']/1e6 for r in windows],[r['sum']/977 for r in windows],
                color='#1d354b',linewidth=1.5,label='RTL mean |sample|')
        ax.plot([r['observed_ns']/1e6 for r in polls],[r['l1_sum']/977 for r in polls],
                color='#4689be',linewidth=1,alpha=.7,label='Original PS shared page')
        ax.step([r['ns']/1e6 for r in frames],[measured[r['frame']]*28/120 for r in frames],
                where='post',color='#ed7d31',linewidth=1.8,label='HDMI colored bar (cap ~56)')
        ax.axhline(16,color='#a08223',linestyle='--',linewidth=.8)
        ax.axhline(28,color='#ba4444',linestyle='--',linewidth=.8)
        if name.endswith('paused-r01'):
            ax.axvspan(430,680,color='#9da4ad',alpha=.18)
            ax.text(555,70,'OSD publish paused',ha='center',fontsize=9,color='#555d66')
        ax.set_title(title,loc='left',fontsize=11,fontweight='bold')
        ax.set_xlim(0,800);ax.set_ylim(0,180 if 'human' in name else 82)
        ax.set_xlabel('Simulation time (ms)');ax.set_ylabel('16-bit sample magnitude / equivalent bar scale')
        ax.grid(axis='y',alpha=.2);ax.spines[['top','right']].set_visible(False)
        summary.append(dict(run=name,receipt_sha256=hashlib.sha256((directory/'receipt.json').read_bytes()).hexdigest(),
            ack_count=receipt['ack_count'],checks=receipt['checks']))
    handles,labels=axes[0,0].get_legend_handles_labels()
    fig.legend(handles,labels,loc='outside lower center',ncol=3,frameon=False)
    cadence='20 ms producer + independent 30 Hz OSD' if a.production_cadence else 'Historical 2 ms producer'
    fig.suptitle('Audio to HDMI: real Python driver + XSim RTL\n'+cadence+'; no physical microphone or ARM/Linux verification',fontsize=14)
    fig.savefig(a.output/'comparison.png',dpi=150)
    fig.savefig(a.output/'comparison.svg')
    (a.output/'summary.json').write_text(json.dumps(summary,indent=2))


if __name__=='__main__':main()
