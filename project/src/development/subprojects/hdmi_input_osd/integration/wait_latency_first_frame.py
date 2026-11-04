"""Bounded result-only startup observation; no MMIO owner, JPEG demand, STOP or reload.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/wait_latency_first_frame.py --candidate deliveries/c6i-pl-vision-volume-osd-r18-prewarm-20261023 --label c0e-p08-first-frame
Output: exclusive evidence/LABEL.json with every status and the terminal first-frame/fault state.
Next: only after RUNNING with a real frame proceed to sustained acceptance; retain faults for diagnosis.
"""
import argparse
import json
from pathlib import Path
import sys
import time
from uuid import uuid4


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--candidate',type=Path,required=True)
    parser.add_argument('--label',required=True)
    parser.add_argument('--timeout',type=float,default=90)
    args=parser.parse_args()
    assert args.label.replace('-','').isalnum() and 5<=args.timeout<=120
    output=Path(__file__).parent/'evidence'/(args.label+'.json')
    assert not output.exists()
    sys.path.insert(0,str(args.candidate.resolve()/'python'))
    from pynq_multimodal_game.agent.core import AgentCommand
    from pynq_multimodal_game.agent.transport import AgentClient
    client=AgentClient('192.168.2.99',8765,source_address='192.168.2.1',timeout=15)
    record=dict(status='RUNNING',result_only=True,jpeg_demand=False,samples=[])
    started=time.monotonic()
    try:
        client.connect()
        while True:
            response=client.command(uuid4().hex,AgentCommand.STATUS)
            record['samples'].append(dict(host_elapsed_s=time.monotonic()-started,response=response))
            assert response['ok'],response
            snapshot=response['snapshot']
            assert snapshot['build_id']==0xC0060E00 and snapshot['profile']=='C6I_PL_VISION_VOLUME_OSD_V1'
            vision=snapshot['vision']
            if vision['state']=='FAULT' or snapshot['last_error'] is not None:
                raise RuntimeError('terminal capture fault: '+str(vision['last_error']))
            if vision['state']=='RUNNING' and vision['frame_id']>0:
                record.update(status='C0E_REAL_FIRST_FRAME_RUNNING',frame_id=vision['frame_id'])
                break
            if time.monotonic()-started>=args.timeout:raise TimeoutError('no real frame within startup bound')
            time.sleep(.25)
    except BaseException as error:
        record.update(status='FAIL',error=repr(error));raise
    finally:
        client.close();record['seconds']=time.monotonic()-started
        with output.open('x',encoding='utf-8') as stream:json.dump(record,stream,indent=2)
    print(record['status'],record['frame_id'])


if __name__=='__main__':main()
