"""Independently check ARM worker + RTL/HDMI traces after the bounded guest run.

PowerShell: .venv/Scripts/python subprojects/volume_response_offline/cosim/check_guest_audio.py --guest build/volume-response/cosim-guest-audio-r01 --output build/volume-response/cosim-guest-audio-check-r01
Output: SHA-bound receipt.json and first-failure assertion. Next: interpret any
remaining physical microphone/ADC uncertainty; no test opens a board device.
"""
import argparse
import csv
import hashlib
import json
from pathlib import Path
import re


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def csvrows(path):
    with path.open(newline='') as f:return [{k:int(v) for k,v in r.items()} for r in csv.DictReader(f)]


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--guest',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    report=dict(status='RUNNING',board_access=False,analog_verified=False)
    try:
        guest=json.loads((a.guest/'receipt.json').read_text())
        assert guest['status']=='ARM_WORKER_OBSERVED_PENDING_TRACE_CHECKS'
        rtl=a.guest/'rtl';transport=json.loads((rtl/'receipt.json').read_text())
        assert sha(rtl/'receipt.json')==guest['rtl_receipt_sha256']
        assert transport['status']=='TRANSPORT_CLOSED',transport
        assert transport['pixel_errors']==transport['serial_errors']==0
        assert transport['background_pixels_checked']>0 and transport['sync_cycles_checked']>0
        serial=csvrows(rtl/'serialized.csv');pcm=csvrows(rtl/'pcm.csv')
        windows=csvrows(rtl/'windows.csv');frames=csvrows(rtl/'frames.csv');bars=csvrows(rtl/'bar.csv')
        assert len(pcm)>=30000 and len(windows)>=20 and len(frames)>=20 and bars
        assert transport['decoded_count']==len(pcm)
        assert [r['index'] for r in pcm]==list(range(1,len(pcm)+1))
        assert all(b['ns']-a['ns']==20480 for a,b in zip(pcm,pcm[1:]))
        stimulus=[int(s,16) for s in (rtl/'left.mem').read_text().splitlines()]
        stimulus=[v-(1<<24) if v&(1<<23) else v for v in stimulus]
        active=[]
        for row in pcm:
            source=serial[row['index']]
            assert row['ns']-source['ns']==5320,(row,source)
            expected=stimulus[row['index']]>>8 if source['active'] else 0
            assert row['expected']==row['actual']==expected,(row,expected)
            if row['accepted']:active.append(expected)
        dc=0;accumulator=0;gold=[]
        for n,sample in enumerate(active,1):
            scaled=sample<<8;dc+=(scaled-dc)>>10
            accumulator+=abs((scaled-dc)>>8)
            if n%977==0:gold.append(accumulator);accumulator=0
        assert len(gold)==len(windows),(len(gold),len(windows))
        for row,expected in zip(windows,gold):
            assert row['sum']==expected and row['samples']==row['window']*977 and row['faults']==0,(row,expected)
        console=(a.guest/'serial.log').read_text(errors='replace')
        pages=[json.loads(s) for s in re.findall(r'VVG_AUDIO_PAGE (\{[^\r\n]+\})',console)]
        emitted=[json.loads(s) for s in re.findall(r'VVG_AUDIO_COMMIT (\{[^\r\n]+\})',console)]
        assert pages and emitted
        assert all(not page['error'] and page['enabled'] and page['faults']==0 for page in pages)
        assert all(page['window_count']<=len(windows) for page in pages)
        for page in pages:
            if page['window_count']>0 and page['snapshot_valid']:
                assert page['l1_sum']==windows[page['window_count']-1]['sum'],page
        assert max(page['l1_sum']/977 for page in pages)>=28
        assert max(page['ack_count'] for page in pages)>=1
        mmio=[json.loads(s) for s in (rtl/'remote-mmio.jsonl').read_text().splitlines()]
        commits=[row for row in mmio if row['address']==0x41001008 and row['write']==1]
        assert len(commits)==len(emitted),(len(commits),len(emitted))
        active_words=[0]*6;remaining=0;next_commit=0;expected_frames={0:(active_words.copy(),False)}
        for frame in frames:
            remaining=max(0,remaining-1)
            if next_commit<len(commits) and commits[next_commit]['rtl_ns']+commits[next_commit]['delay_ns']<frame['ns']-100:
                words=emitted[next_commit]['words'];next_commit+=1
                if words[5]!=active_words[5]:remaining=min(6,words[3]>>24)
                active_words=words
            fresh=bool(active_words[0]&1 and active_words[0]&8 and remaining)
            assert [frame[f'w{i}'] for i in range(6)]==active_words,frame
            assert frame['audio_fresh']==int(fresh),frame
            expected_frames[frame['frame']]=(active_words.copy(),fresh)
        for pixel in bars:
            words,fresh=expected_frames[pixel['frame']]
            x,y=pixel['x'],pixel['y'];rgb=pixel['background']
            level=words[2]&1023;soft=words[2]>>16&1023;loud=words[3]&1023
            if words[0]&1:
                if 1266<=x<1274:
                    rgb=0x202830
                    if fresh and 480-y<=level:
                        rgb=0xff4848 if level>=loud else 0xff40cc if level>=soft else 0x4070e0
                    if x in (1266,1273) or y in (240,479):rgb=0x707070
                if 1262<=x<1277 and 480-y in (soft,loud):rgb=0xe0e0e0 if fresh else 0x505050
            assert pixel['rgb']==rgb,(pixel,hex(rgb))
        report.update(status='ARM_RTL_HDMI_COSIM_PASS',checks=dict(decoded=len(pcm),windows=len(windows),
            frames=len(frames),bar_pixels=len(bars),guest_pages=len(pages),guest_osd_commits=len(emitted),
            max_mean=max(page['l1_sum']/977 for page in pages),ack_count=max(page['ack_count'] for page in pages),
            source_sha256=transport['source_hashes']))
    except BaseException as e:report.update(status='FAIL',error=repr(e));raise
    finally:
        report['guest_receipt_sha256']=sha(a.guest/'receipt.json')
        report['script_sha256']=sha(__file__)
        (a.output/'receipt.json').write_text(json.dumps(report,indent=2))
    print(report['status'])


if __name__=='__main__':main()
