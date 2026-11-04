"""Run: python analyze_human_pcm.py --root build/volume-response/acoustic-a03-human
Output: human-analysis.json and R20-exact filtered-window CSV. Next: inspect
voice/time response; digital predicted edges never count as hardware/game PASS.
"""
import argparse,csv,json
from pathlib import Path
import numpy as np
from gesture_policy import VolumeGesturePolicy


def filtered_windows(values):
    dc=total=count=0;result=[]
    for value in values.tolist():
        scaled=value<<8;dc+=(scaled-dc)>>10
        total+=abs((scaled-dc)>>8);count+=1
        if count==977:
            result.append(total/977);total=count=0
    return np.array(result)


def segments(mask,times):
    result=[];start=None
    for i,active in enumerate(mask):
        if active and start is None:start=i
        if start is not None and (not active or i==len(mask)-1):
            end=i if active else i-1
            result.append(dict(start_seconds=float(times[start]),end_seconds=float(times[end]),windows=end-start+1))
            start=None
    return result


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--root',type=Path,required=True);args=p.parse_args()
    r=json.loads((args.root/'board-receipt.json').read_text());raw=np.load(args.root/'board-raw.npy',allow_pickle=False)
    u=raw.astype(np.int64)&0xffffff;signed=np.where(u&0x800000,u-0x1000000,u).reshape(-1,2)
    s16=(signed>>8).astype(np.int64)
    levels=np.stack([filtered_windows(s16[:,i]) for i in range(2)],axis=1)
    fs=r['sample_len']/((r['record_finished_ns']-r['record_started_ns'])/1e9)
    times=(np.arange(len(levels))+.5)*977/fs
    active=times>=2.0;summary=[]
    for i in range(2):
        values=levels[active,i];policy=VolumeGesturePolicy();edges=[]
        for n,value in enumerate(levels[:,i]):
            frame=policy.sample(epoch=1,window=n+1,observed_ns=int((n+1)*977/fs*1e9),now_ns=int((n+1)*977/fs*1e9),mean_abs=float(value))
            if frame.edge and times[n]>=2:edges.append(dict(seconds=float(times[n]),kind=frame.edge))
        summary.append(dict(channel=i,post_startup_mean_abs_min=float(values.min()),median=float(np.median(values)),p95=float(np.quantile(values,.95)),maximum=float(values.max()),
                            windows_over_soft=int(np.sum(values>=16)),windows_over_loud=int(np.sum(values>=28)),
                            soft_segments=segments((levels[:,i]>=16)&active,times),loud_segments=segments((levels[:,i]>=28)&active,times),candidate_edges=edges))
    result=dict(status='HUMAN_PCM_ANALYZED',record_seconds=(r['record_finished_ns']-r['record_started_ns'])/1e9,
                samples_per_channel=r['sample_len'],measured_average_samples_per_second=fs,channels=summary,
                metric='Signed high16, exact original integer DC estimator DC_FRAC8/DC_SHIFT10 and L1/977; startup first2 seconds excluded.',
                hardware_events_verified=False,skills_verified=False,limits='Voice onset marks are not supplied; predicted policy edges are offline results only.')
    with (args.root/'human-analysis.json').open('x') as f:json.dump(result,f,indent=2)
    with (args.root/'human-envelope.csv').open('x',newline='') as f:
        w=csv.writer(f);w.writerow(['time_s','left_mean_abs','right_mean_abs']);w.writerows(zip(times,levels[:,0],levels[:,1]))
    print(json.dumps(result,indent=2))


if __name__=='__main__':main()
