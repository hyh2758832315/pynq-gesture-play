"""Bounded R1 result-only HTTP timing probe; no JPEG demand or MMIO access.

Run: .venv/Scripts/python.exe -B .../sample_result_timing.py --label UNIQUE --seconds 60
Output: evidence/LABEL.json, including failures and raw per-frame samples.
Next: compare same-condition candidate timings; these are not sensor-to-display times.
"""
import argparse
import http.client
import json
from pathlib import Path
import statistics
import time


HERE=Path(__file__).resolve().parent


def distribution(values):
    ordered=sorted(values)
    def percentile(fraction):
        location=(len(ordered)-1)*fraction
        lo=int(location)
        hi=min(lo+1,len(ordered)-1)
        return ordered[lo]+(ordered[hi]-ordered[lo])*(location-lo)
    return dict(n=len(ordered),p50=statistics.median(ordered),p95=percentile(.95),
                p99=percentile(.99),maximum=ordered[-1])


def sample(args):
    output=HERE/'evidence'/(args.label+'.json')
    if output.exists(): raise FileExistsError(output)
    record=dict(status='RUNNING',hardware_access=False,jpeg_subscription=False,
                scope='Published per-frame software-stage timings, not sensor SOF or physical HDMI latency.',
                samples=[],unique_frames=[],error=None)
    seen=set()
    started=time.monotonic()
    try:
        while time.monotonic()-started<args.seconds:
            client=http.client.HTTPConnection('192.168.2.99',8081,timeout=4,
                                              source_address=('192.168.2.1',0))
            requested=time.monotonic()
            try:
                client.request('GET','/result.json')
                response=client.getresponse()
                if response.status!=200: raise RuntimeError('HTTP result status '+str(response.status))
                payload=response.read(65537)
                if len(payload)>65536: raise RuntimeError('unbounded result response')
                value=json.loads(payload)
            finally:
                client.close()
            key=(value.get('run_id'),value.get('frame'))
            if key[0] is None or type(key[1]) is not int: raise RuntimeError('result identity missing')
            record['samples'].append(dict(host_monotonic_s=requested,http_seconds=time.monotonic()-requested,
                                          result=value))
            if key not in seen:
                seen.add(key)
                record['unique_frames'].append(value)
            time.sleep(max(0.,.2-(time.monotonic()-requested)))
        unique=record['unique_frames']
        if len(unique)<2: raise RuntimeError('no continuing distinct frame results')
        if len({item['run_id'] for item in unique})!=1: raise RuntimeError('run boundary crossed')
        timing={}
        for item in unique:
            for key,value in (item.get('timing_ms') or {}).items():
                if type(value) in (int,float): timing.setdefault(key,[]).append(value)
        if not timing: raise RuntimeError('no software stage timings published')
        record.update(status='PASS',stage_ms={key:distribution(values) for key,values in timing.items()},
                      frame_span=unique[-1]['frame']-unique[0]['frame'],
                      unobserved_frames=unique[-1]['frame']-unique[0]['frame']+1-len(unique),
                      note='Polling can miss source frames; stage percentiles must not be added to infer end-to-end percentiles.')
    except BaseException as failure:
        record.update(status='FAIL',error=repr(failure))
        raise
    finally:
        record['seconds']=time.monotonic()-started
        with output.open('x',encoding='utf-8') as stream: json.dump(record,stream,indent=2,allow_nan=False)
    print(json.dumps({key:record[key] for key in ('status','seconds','stage_ms','frame_span','unobserved_frames')}),flush=True)


if __name__=='__main__':
    parser=argparse.ArgumentParser()
    parser.add_argument('--label',required=True)
    parser.add_argument('--seconds',type=float,default=60.)
    args=parser.parse_args()
    if not args.label.replace('-','').isalnum() or not 5<=args.seconds<=120:
        parser.error('unique alphanumeric label and duration in [5,120] seconds required')
    sample(args)
