"""Run: .venv/Scripts/python subprojects/volume_response_offline/analyze_base_pcm.py --root build/volume-response/acoustic-a01
Output: pcm-analysis.json and window-envelope.csv. Next: compare Codec/format,
using matched frequency/time response, not total recording RMS as proof.
"""
import argparse,csv,json
from pathlib import Path
import numpy as np


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--root',type=Path,required=True);args=parser.parse_args()
    raw=np.load(args.root/'board-raw.npy',allow_pickle=False)
    assert raw.dtype==np.int32 and raw.ndim==1 and raw.size%2==0
    u=raw.astype(np.int64)&0xffffff
    samples=np.where(u&0x800000,u-0x1000000,u).reshape(-1,2).astype(float)/256
    rate=48000;size=960;count=len(samples)//size
    windows=samples[:count*size].reshape(count,size,2)
    centered=windows-windows.mean(axis=1,keepdims=True)
    rms=np.sqrt(np.mean(centered**2,axis=1));mean=np.mean(np.abs(centered),axis=1)
    spectrum=np.abs(np.fft.rfft(centered*np.hanning(size)[None,:,None],axis=1))**2
    freq=np.fft.rfftfreq(size,1/rate)
    bands={str(hz):spectrum[:,np.abs(freq-hz)<width,:].sum(axis=1) for hz,width in ((640,160),(3000,200))}
    pc=json.loads((args.root/'receipt.json').read_text());result=dict(driver_sample_rate=rate,window_samples=size,window_ms=20,channels=[],trials=[],
        limits='Timing aligned to SSH READY receipt, not calibrated acoustic onset; band power comparison cannot prove human-voice or skills accuracy.')
    times=(np.arange(count)+.5)*size/rate
    for i in range(2):
        result['channels'].append(dict(index=i,quiet_median_mean_abs=float(np.median(mean[times<.8,i])),quiet_median_rms=float(np.median(rms[times<.8,i])),max_mean_abs=float(mean[:,i].max()),rms_p99=float(np.quantile(rms[:,i],.99))))
    for trial in pc['pulses']:
        start=(trial['requested_pc_ns']-pc['ready_pc_ns'])/1e9
        # Timing uncertainty is bounded here only by broad measurement regions;
        # also retain raw windows for subsequent exact lag analysis.
        active=(times>=start+.08)&(times<=start+.43)
        baseline=(times>=max(0,start-.4))&(times<=start-.08)
        assert active.any() and baseline.any()
        hz=str(trial['hz']);responses=[]
        for i in range(2):
            a=float(np.median(bands[hz][active,i]));b=float(np.median(bands[hz][baseline,i]))
            responses.append(dict(channel=i,active_median_mean_abs=float(np.median(mean[active,i])),before_median_mean_abs=float(np.median(mean[baseline,i])),band_power_ratio=a/max(b,1e-12)))
        result['trials'].append(dict(hz=trial['hz'],amplitude=trial['amplitude'],start_seconds=start,responses=responses))
    with (args.root/'window-envelope.csv').open('x',newline='') as f:
        writer=csv.writer(f);writer.writerow(['time_s','left_mean_s16','right_mean_s16','left_rms_s16','right_rms_s16','left_640_power','right_640_power','left_3000_power','right_3000_power'])
        for n,t in enumerate(times):writer.writerow([t,*mean[n],*rms[n],*bands['640'][n],*bands['3000'][n]])
    with (args.root/'pcm-analysis.json').open('x') as f:json.dump(result,f,indent=2)
    print(json.dumps(result,indent=2))


if __name__=='__main__':main()
