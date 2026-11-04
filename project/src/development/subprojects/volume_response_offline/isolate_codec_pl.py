"""Run frozen R20 audio only; compare reversible Codec attenuation/PGA stages.

Run: .venv/Scripts/python subprojects/volume_response_offline/isolate_codec_pl.py
     --gate build/volume-response/board-gate-a12-audio-isolation.json
     --output build/volume-response/codec-pl-a01 --run
Output: unique PC/board receipts, exact remote source, streamed log, volume restoration.
Next: compare settled samples across stages, then normal reboot before other overlays.
No camera, DMA reader, game, or Agent is started. --run is required for hardware.
With --human-voice, keep original gain for 30 seconds, emit one short PC cue,
then capture real thresholds/events/ACK without further playback or gain changes.
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

REPO = Path(__file__).resolve().parents[2]
BOARD = '/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'
SSH = ['ssh', '-b', '192.168.2.1', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes', '-o', 'ConnectTimeout=8', 'pynq-z2']

BODY = r'''
os.environ['XILINX_XRT']='/usr'
package=pathlib.Path(__PACKAGE__)
log=package/__LOG__
human_voice=__HUMAN_VOICE__
record=dict(boot_id=boot,pid=os.getpid(),human_voice=human_voice,camera_started=False,phases=[],cleanup_confirmed=False)
def save():
    with (log/'board-receipt.json').open('w') as f:
        json.dump(record,f,indent=2);f.flush();os.fsync(f.fileno())
sys.path.insert(0,str(package/'board/pynq_z2/scripts'))
from voice_volume_board import LinuxBackend
from voice_volume_control import DirectTransport,VolumeControl,configure_codec
with ExitStack() as owner:
    for name in ('/var/lock/voice-view-c6i.lock','/run/lock/voice_pcm_audio.lock'):
        stream=owner.enter_context(open(name,'a+b'));fcntl.flock(stream.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB)
        stream.seek(0);assert not stream.read()
    record['base_audit']=board.audit_base(boot)
    with pathlib.Path('/run/lock/voice-view-audio-isolation-'+boot+'-'+log.name+'.attempt').open('x') as f:
        json.dump(dict(pid=os.getpid(),profile='R20_AUDIO_ISOLATION',log=str(log)),f)
    record['phase']='loading';save()
    sys.path.insert(0,str(package/'python'))
    from pynq_multimodal_game.agent.cli import _load_shared_vision_overlay
    overlay=_load_shared_vision_overlay(str(package/'overlay/c6v_candidate.bit'),download=True)
    record['phase']='overlay_loaded';save()
    backend=LinuxBackend(base_address=0x43c10000)
    transport=DirectTransport(backend)
    control=None
    sums=dict(quiet_sum=11*977,soft_sum=16*977,loud_sum=28*977) if human_voice else dict(quiet_sum=1,soft_sum=0xfffffffe,loud_sum=0xffffffff)
    original=None
    try:
        control=VolumeControl(transport,exclusive_owner=True)
        control.configure(**sums,enable=False)
        configure_codec(transport,stopped=True,straps_confirmed=True,mclk_hz=10_000_000,timeout=2)
        registers=(0x400e,0x400f,0x401a,0x401b)
        original={r:backend.codec_read(r,1) for r in registers}
        assert original=={0x400e:b'\xb3',0x400f:b'\xb3',0x401a:b'\x00',0x401b:b'\x00'}
        control.configure(**sums,enable=True)
        stages=(('baseline',0xb3,0),('adc_minus48db',0xb3,128),('restore_adc',0xb3,0),
                ('pga_0db',0x43,0),('pga_max35db',0xff,0),('restore_pga',0xb3,0),
                ('pga_muted',0xb1,0),('final_restore',0xb3,0))
        if human_voice:stages=(('near_voice_original_gain',0xb3,0),)
        duration=30 if human_voice else 5
        for name,pga,atten in stages:
            for r,value in ((0x400e,pga),(0x400f,pga),(0x401a,atten),(0x401b,atten)):
                backend.codec_write(r,bytes([value]));assert backend.codec_read(r,1)==bytes([value])
            phase=dict(name=name,registers={hex(r):backend.codec_read(r,1).hex() for r in registers},
                       start_ns=time.monotonic_ns(),samples=[],events=[])
            record['phases'].append(phase);record['phase']=name;save()
            print('ISOLATION_PHASE '+json.dumps(dict(name=name,start_ns=phase['start_ns'],seconds=duration)),flush=True)
            until=time.monotonic()+duration
            last=None
            while time.monotonic()<until:
                sample=control.monitor()
                assert not sample['faults'] and sample['clock_locked'] and sample['snapshot_valid'],sample
                if sample['event'] is not None:
                    event=dict(sample['event'],observed_board_ns=time.monotonic_ns(),ack_confirmed=False)
                    phase['events'].append(event)
                    control.acknowledge(control.event())
                    event.update(ack_confirmed=True,ack_board_ns=time.monotonic_ns())
                if sample['window_count']!=last:
                    phase['samples'].append(dict(board_ns=time.monotonic_ns(),**sample));last=sample['window_count']
                time.sleep(.006)
            phase['end_ns']=time.monotonic_ns();save()
        record['phase']='measured'
    except BaseException as error:
        record.update(phase='failed',error=repr(error));raise
    finally:
        try:
            if original:
                for r,value in original.items():backend.codec_write(r,value)
                record['registers_restored']=all(backend.codec_read(r,1)==v for r,v in original.items())
            if control and not transport.failed:
                control.configure(**sums,enable=False)
                record['sampling_disabled']=not control.monitor()['enabled']
        finally:
            transport.close()
            record['cleanup_confirmed']=bool(record.get('registers_restored') and record.get('sampling_disabled'));save()
            print('ISOLATION_FINAL '+json.dumps({k:v for k,v in record.items() if k!='phases'}),flush=True)
'''


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gate',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--run',action='store_true')
    parser.add_argument('--resume-parser-failure',type=Path)
    parser.add_argument('--human-voice',action='store_true')
    args=parser.parse_args()
    gate=json.loads(args.gate.read_text(encoding='utf-8'))
    assert gate['gate']=='READ_ONLY_IDLE_GATE_PASS'
    assert args.output.name.startswith('codec-pl-') and all(c.isalnum() or c=='-' for c in args.output.name)
    log='var/'+args.output.name
    original=json.loads((REPO/'subprojects/hdmi_input_osd/integration/evidence/r20-b04-base-normal-stop.json').read_text(encoding='utf-8'))['remote_code']
    source=original.replace('f56e80d1-0222-4c57-8308-162e279eb32f',gate['state']['boot_id']).replace('var/pl-admission-r20-b01',log)
    if args.resume_parser_failure:
        failed=json.loads((args.resume_parser_failure/'pc-receipt.json').read_text(encoding='utf-8'))
        assert failed['boot_id']==gate['state']['boot_id'] and failed['returncode']==1
        assert 'pynqmetadata.frontends.metadata.UnknownInputFileExtension' in (args.resume_parser_failure/'board.log').read_text(encoding='utf-8')
        source=source.split("root = root / 'var/")[0]
        source+='\nboot='+repr(gate['state']['boot_id'])+'\n'
        source+='root=root/'+repr(log)+'\nroot.mkdir(parents=True,exist_ok=False)\n'
        source+="assert json.loads((root.parent/"+repr(args.resume_parser_failure.name)+"/'board-receipt.json').read_text())['phase']=='loading'\n"
    source+=BODY.replace('__PACKAGE__',repr(BOARD)).replace('__LOG__',repr(log)).replace('__HUMAN_VOICE__',repr(args.human_voice))
    ast.parse(source,feature_version=(3,10))
    if not args.run:
        print('ISOLATION_CHECK_ONLY_PASS');return
    assert time.time()-gate['finished_unix']<3600
    args.output.mkdir(parents=True,exist_ok=False)
    (args.output/'remote_source.py').write_text(source,encoding='utf-8')
    receipt=dict(status='PREPARED',boot_id=gate['state']['boot_id'],source_sha256=hashlib.sha256(source.encode()).hexdigest(),gate_sha256=hashlib.sha256(args.gate.read_bytes()).hexdigest(),phases=[])
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
        deadline=time.monotonic()+150
        while process.poll() is None or not messages.empty():
            try:line=messages.get(timeout=.05)
            except queue.Empty:line=''
            if line.startswith('ISOLATION_PHASE '):
                phase=json.loads(line[len('ISOLATION_PHASE '):]);phase['received_pc_ns']=time.monotonic_ns()
                receipt['phases'].append(phase);save();print('PHASE',phase['name'],flush=True)
                if args.human_voice:
                    phase['cue']=speaker.play(1000,.25)
                    print('NEAR_VOICE_CAPTURE_ACTIVE: speak close to microphone with pauses; PC is now silent',flush=True)
                else:
                    speaker.pump(1.5);phase['play']=speaker.play(1000,1.5)
                save()
            if time.monotonic()>deadline:raise TimeoutError('board session exit unconfirmed; inspect before reboot')
            speaker.app.processEvents()
        reader.join(2);receipt['returncode']=process.returncode
        assert process.returncode==0, ''.join(lines)[-1200:]
        receipt['status']='MEASUREMENT_COMPLETE'
    except BaseException as error:
        receipt.update(status='FAIL',error=repr(error));raise
    finally:
        if speaker:speaker.close()
        save()
    copy=subprocess.run(['scp','-o','BindAddress=192.168.2.1','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes',
                         'pynq-z2:'+BOARD+'/'+log+'/board-receipt.json',str(args.output/'board-receipt.json')],capture_output=True,text=True,timeout=25)
    receipt['copy']=dict(returncode=copy.returncode,stdout=copy.stdout,stderr=copy.stderr);save()
    assert copy.returncode==0
    print(receipt['status'],flush=True)


if __name__=='__main__':main()
