"""Official Base PCM capture at original/max/original mic PGA with metered PC tones.

Run: .venv/Scripts/python subprojects/volume_response_offline/isolate_base_pcm.py
     --gate <fresh-idle-gate.json> --output build/volume-response/base-pga-a01 --run
Output: original stereo raw NPY, distinct board/PC receipts, hashes and playback peaks.
Next: analyze settled frequency bands; this does not assume loudspeaker/mic proximity.
"""
import argparse
import ast
import hashlib
import json
import queue
import subprocess
import threading
import time
from pathlib import Path

from codec_ab_probe import HEAD, BODY, CONTROL
from isolate_codec_pl import SSH

TAIL=r'''
    audio=AudioADAU1761(receipt['description']);codec=Codec()
    receipt.update(experiment='official-base-pga-acoustic-isolation',captures=[])
    try:
        audio.configure();audio.select_microphone()
        for index,pga in enumerate((0xb3,0xff,0xb3)):
            for r in (0x400e,0x400f):
                codec.codec_write(r,bytes([pga]));assert codec.codec_read(r,1)==bytes([pga])
            entry=dict(index=index,pga=pga,seconds=9,codec_before=codec.snapshot())
            receipt['captures'].append(entry);receipt['phase']='recording'
            entry['started_ns']=time.monotonic_ns();save()
            print('BASE_PGA_PHASE '+json.dumps(dict(index=index,pga=pga,seconds=9)),flush=True)
            audio.record(9)
            entry.update(finished_ns=time.monotonic_ns(),sample_len=audio.sample_len,sample_rate=audio.sample_rate)
            target=ROOT/('phase-%d-raw.npy'%index)
            np.save(str(target),audio.buffer,allow_pickle=False)
            entry['file']=dict(name=target.name,bytes=target.stat().st_size,sha256=hashlib.sha256(target.read_bytes()).hexdigest())
            entry['codec_after']=codec.snapshot();save()
        receipt['phase']='recorded'
    except BaseException as error:
        receipt.update(phase='failed',error=repr(error));raise
    finally:
        for r in (0x400e,0x400f):codec.codec_write(r,b'\xb3')
        audio.deselect_inputs();codec.close()
        receipt['cleanup_confirmed']=True;save()
        print('BASE_PGA_FINAL '+json.dumps(dict(phase=receipt['phase'],cleanup_confirmed=True)),flush=True)
'''


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--gate',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--run',action='store_true');args=p.parse_args()
    assert args.output.name.startswith('base-pga-') and all(c.isalnum() or c=='-' for c in args.output.name)
    remote='/home/xilinx/voice-view-game/volume-response-'+args.output.name
    gate=json.loads(args.gate.read_text());assert gate['gate']=='READ_ONLY_IDLE_GATE_PASS'
    control=CONTROL.read_text(encoding='utf-8')
    prefix=BODY.split('    audio=AudioADAU1761')[0]
    source=HEAD.replace('/home/xilinx/voice-view-game/volume-response-a01',remote).replace('db5b70bc-7b6e-4af0-9f3a-6845e782b31c',gate['state']['boot_id'])
    source+=(prefix+TAIL).replace('__CONTROL_TEXT__',repr(control)).replace('__CONTROL_SHA__',repr(hashlib.sha256(control.encode()).hexdigest()))
    ast.parse(source,feature_version=(3,10))
    if not args.run:print('BASE_PGA_CHECK_ONLY_PASS');return
    assert time.time()-gate['finished_unix']<3600
    args.output.mkdir(parents=True,exist_ok=False)
    (args.output/'remote_source.py').write_text(source,encoding='utf-8')
    receipt=dict(status='PREPARED',gate_sha256=hashlib.sha256(args.gate.read_bytes()).hexdigest(),source_sha256=hashlib.sha256(source.encode()).hexdigest(),phases=[])
    def save():(args.output/'pc-receipt.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
    save()
    from verified_speaker import VerifiedSpeaker
    speaker=None;process=None;lines=[];messages=queue.Queue()
    try:
        speaker=VerifiedSpeaker();receipt['speaker']=speaker.receipt;speaker.prepare()
        process=subprocess.Popen(SSH+['sudo -n /usr/local/share/pynq-venv/bin/python -B -'],stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,bufsize=1)
        process.stdin.write(source);process.stdin.close()
        def collect():
            for line in process.stdout:
                lines.append(line);messages.put(line)
                with (args.output/'board.log').open('a',encoding='utf-8') as file:file.write(line)
        reader=threading.Thread(target=collect,daemon=True);reader.start()
        deadline=time.monotonic()+100
        while process.poll() is None or not messages.empty():
            try:line=messages.get(timeout=.05)
            except queue.Empty:line=''
            if line.startswith('BASE_PGA_PHASE '):
                phase=json.loads(line[len('BASE_PGA_PHASE '):]);phase['received_pc_ns']=time.monotonic_ns();phase['plays']=[]
                receipt['phases'].append(phase);save();print('PHASE',phase['index'],flush=True)
                speaker.pump(1.5)
                for hz in (640,1000,3000):
                    phase['plays'].append(speaker.play(hz,1));save();speaker.pump(.8)
            if time.monotonic()>deadline:raise TimeoutError('record exit unconfirmed; inspect before any new capture')
            speaker.app.processEvents()
        reader.join(2);receipt['returncode']=process.returncode
        assert process.returncode==0,''.join(lines)[-1200:]
        receipt['status']='MEASUREMENT_COMPLETE'
    except BaseException as error:receipt.update(status='FAIL',error=repr(error));raise
    finally:
        if speaker:speaker.close()
        save()
    receipt['copies']=[]
    for source_name,dest_name in [('receipt.json','board-receipt.json')]+[(f'phase-{i}-raw.npy',f'phase-{i}-raw.npy') for i in range(3)]:
        r=subprocess.run(['scp','-o','BindAddress=192.168.2.1','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes',
                          'pynq-z2:'+remote+'/'+source_name,str(args.output/dest_name)],capture_output=True,text=True,timeout=25)
        receipt['copies'].append(dict(file=dest_name,returncode=r.returncode,stderr=r.stderr));save();assert r.returncode==0
    board=json.loads((args.output/'board-receipt.json').read_text())
    for entry in board['captures']:
        file=entry['file'];assert hashlib.sha256((args.output/file['name']).read_bytes()).hexdigest()==file['sha256']
    receipt['raw_hashes_verified']=True;save();print(receipt['status'],flush=True)


if __name__=='__main__':main()
