"""Analyze bounded Base PGA capture; no hardware access.

Run: .venv/Scripts/python subprojects/volume_response_offline/analyze_base_pga.py
     --root build/volume-response/base-pga-a01
Output: exclusive analysis.json with high16 original-RTL L1 and narrowband RMS.
Next: distinguish acoustic response from gain-amplified noise; timing is approximate.
"""
import argparse
import hashlib
import json
from pathlib import Path
import numpy as np
from analyze_human_pcm import filtered_windows


def band_rms(values, fs, frequency):
    values=values-values.mean()
    window=np.hanning(len(values))
    spectrum=np.fft.rfft(values*window)
    freqs=np.fft.rfftfreq(len(values),1/fs)
    mask=np.abs(freqs-frequency)<=40
    return float(np.sqrt(2*np.sum(np.abs(spectrum[mask])**2)/(len(values)*np.sum(window**2))))


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root',type=Path,required=True)
    parser.add_argument('--output-name',default='analysis.json');args=parser.parse_args()
    assert Path(args.output_name).name==args.output_name and args.output_name.endswith('.json')
    board=json.loads((args.root/'board-receipt.json').read_text())
    pc=json.loads((args.root/'pc-receipt.json').read_text())
    assert board['phase']=='recorded' and board['cleanup_confirmed'] and pc['raw_hashes_verified']
    result=dict(phases=[],startup_excluded_seconds=2,limits='PC receives phase marker just before native record; no shared clock. Tone middles and following silence use margins; +/-40Hz bands tolerate average-rate uncertainty. First tone can overlap initial ADC transient. Digital endpoint peaks are not acoustic measurements.')
    for capture,phase in zip(board['captures'],pc['phases']):
        file=args.root/capture['file']['name']
        assert hashlib.sha256(file.read_bytes()).hexdigest()==capture['file']['sha256']
        raw=np.load(file,allow_pickle=False).astype(np.int64)&0xffffff
        signed=np.where(raw&0x800000,raw-0x1000000,raw).reshape(-1,2)
        elapsed=(capture['finished_ns']-capture['started_ns'])/1e9
        fs=len(signed)/elapsed
        entry=dict(index=capture['index'],pga=capture['pga'],seconds=elapsed,average_fs=fs,channels=[])
        for channel in range(2):
            levels=filtered_windows(signed[:,channel]>>8)
            times=(np.arange(len(levels))+.5)*977/fs
            stable=levels[times>=2]
            summary=dict(channel=channel,mean_abs_median=float(np.median(stable)),mean_abs_p95=float(np.quantile(stable,.95)),mean_abs_max=float(stable.max()),tones=[])
            for play in phase['plays']:
                start=(play['started_ns']-phase['received_pc_ns'])/1e9
                tone=(start+.25,start+.75)
                quiet=(start+1.3,start+1.8)
                assert quiet[1]<elapsed
                def values(bounds):return signed[int(bounds[0]*fs):int(bounds[1]*fs),channel]/256.0
                on=band_rms(values(tone),fs,play['frequency']);off=band_rms(values(quiet),fs,play['frequency'])
                summary['tones'].append(dict(hz=play['frequency'],tone_seconds=tone,quiet_seconds=quiet,tone_band_rms_s16=on,quiet_band_rms_s16=off,power_ratio=on**2/max(off**2,1e-15),endpoint_peak=play['peak_max']))
            entry['channels'].append(summary)
        result['phases'].append(entry)
    with (args.root/args.output_name).open('x') as out:json.dump(result,out,indent=2)
    for phase in result['phases']:
        for c in phase['channels']:
            print(phase['index'],hex(phase['pga']),c['channel'],'L1',round(c['mean_abs_median'],3),'max',round(c['mean_abs_max'],3),'bands',[(x['hz'],round(x['tone_band_rms_s16'],3),round(x['quiet_band_rms_s16'],3),round(x['power_ratio'],2)) for x in c['tones']])


if __name__=='__main__':main()
