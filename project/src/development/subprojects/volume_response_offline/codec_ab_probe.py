"""Compare official/project/official Codec on the existing official Base fabric.

Run: python codec_ab_probe.py --output build/volume-response/codec-ab-a01
     --gate build/volume-response/board-gate-a07.json --run
Without --run: compile and hash check only, no board/audio access.
Outputs: exclusive source, PC cue/restoration and board receipts, three raw.npy.
Next: compare exact L1/977 voice envelopes; this is not integrated VOL1 proof.
"""
import argparse
import hashlib
import json
from pathlib import Path
import queue
import subprocess
import threading
import time

from base_acoustic_probe import waveform
from capture_base_source import SOURCE

ROOT = Path(__file__).resolve().parents[2]
CONTROL = ROOT / 'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023/board/pynq_z2/scripts/voice_volume_control.py'

# Retain the independently exercised boot/Base/UIO/ownership gate, not its capture.
HEAD = SOURCE.split('    from pynq.lib.audio import AudioADAU1761')[0]
BODY = r'''
    from pynq.lib.audio import AudioADAU1761
    import ctypes,sys,types
    import numpy as np
    control_text=__CONTROL_TEXT__
    assert hashlib.sha256(control_text.encode()).hexdigest()==__CONTROL_SHA__
    module=types.ModuleType('frozen_r20_control')
    sys.modules[module.__name__]=module
    exec(compile(control_text,'frozen_r20_control.py','exec'),module.__dict__)
    class Message(ctypes.Structure):
        _fields_=[('addr',ctypes.c_uint16),('flags',ctypes.c_uint16),('length',ctypes.c_uint16),('buffer',ctypes.POINTER(ctypes.c_uint8))]
    class Transfer(ctypes.Structure):
        _fields_=[('messages',ctypes.POINTER(Message)),('count',ctypes.c_uint32)]
    class Codec:
        def __init__(self):
            adapter=pathlib.Path('/sys/class/i2c-adapter/i2c-1')
            assert 'e0005000' in str(adapter.resolve())
            self.fd=os.open('/dev/i2c-1',os.O_RDWR|os.O_CLOEXEC)
            fcntl.ioctl(self.fd,0x0702,10);fcntl.ioctl(self.fd,0x0701,0)
        def transfer(self,register,payload=None,length=0):
            assert type(register) is int and 0<=register<=0xffff
            assert (type(payload) is bytes and 0<len(payload)<=32) or (payload is None and type(length) is int and 0<length<=32)
            outgoing=register.to_bytes(2,'big')+(payload or b'')
            out=(ctypes.c_uint8*len(outgoing)).from_buffer_copy(outgoing)
            incoming=(ctypes.c_uint8*length)()
            count=1 if payload is not None else 2
            messages=(Message*count)();messages[0]=Message(0x3b,0,len(outgoing),out)
            if count==2:messages[1]=Message(0x3b,1,length,incoming)
            assert fcntl.ioctl(self.fd,0x0707,bytearray(Transfer(messages,count)))==count
            return len(payload) if payload is not None else bytes(incoming)
        def codec_read(self,register,length):return self.transfer(register,length=length)
        def codec_write(self,register,payload):return self.transfer(register,payload=payload)
        def close(self):
            if self.fd is not None:os.close(self.fd);self.fd=None
        def snapshot(self):
            registers=sorted(set([0x4000,0x4008,0x4009,0x40f6,0x40f8]+[r for r,_ in module.MIC_PROFILE]))
            return dict(pll_hex=self.codec_read(0x4002,6).hex(),registers={hex(r):self.codec_read(r,1)[0] for r in registers})
    audio=AudioADAU1761(receipt['description']);codec=Codec()
    receipt.update(experiment='official-project-official-on-existing-Base',control_sha256=__CONTROL_SHA__,captures=[],cleanup_confirmed=False)
    try:
        for index,profile in enumerate(('official','project-r20','official')):
            entry=dict(index=index,profile=profile,seconds=10)
            receipt['captures'].append(entry);receipt['phase']='configuring';save()
            # No capture is active while changing a profile. Official first also
            # establishes the driver's own iic_index/uio_index for native record.
            if profile=='official':audio.configure();audio.select_microphone()
            else:
                transport=module.DirectTransport(codec)
                module.configure_codec(transport,stopped=True,straps_confirmed=True,mclk_hz=10_000_000)
                assert transport.codec_configured
            entry['codec_before']=codec.snapshot()
            receipt['phase']='recording';entry['started_ns']=time.monotonic_ns();save()
            print('CODEC_AB_READY '+json.dumps(dict(index=index,profile=profile,seconds=10,root=str(ROOT))),flush=True)
            audio.record(10)
            entry.update(finished_ns=time.monotonic_ns(),sample_len=audio.sample_len,sample_rate=audio.sample_rate)
            target=ROOT/('phase-%d-raw.npy'%index)
            np.save(str(target),audio.buffer,allow_pickle=False)
            entry['file']=dict(name=target.name,bytes=target.stat().st_size,sha256=hashlib.sha256(target.read_bytes()).hexdigest())
            entry['codec_after']=codec.snapshot();receipt['phase']='phase-recorded';save()
            print('CODEC_AB_PHASE_DONE '+json.dumps(dict(index=index,file=entry['file'])),flush=True)
        receipt['phase']='recorded'
    except BaseException as error:
        receipt.update(phase='failed',error=repr(error));raise
    finally:
        # Normal exit returns to the final official profile with inputs disabled.
        # A native hang never reaches here; the PC retains that owner, not kill it.
        audio.deselect_inputs();codec.close()
        receipt['cleanup_confirmed']=True;save()
        print('CODEC_AB_FINAL '+json.dumps(receipt),flush=True)
'''


def remote_source(boot,remote_root):
    control=CONTROL.read_text(encoding='utf-8')
    body=BODY.replace('__CONTROL_TEXT__',repr(control)).replace('__CONTROL_SHA__',repr(hashlib.sha256(control.encode()).hexdigest()))
    source=HEAD.replace('/home/xilinx/voice-view-game/volume-response-a01',remote_root).replace('db5b70bc-7b6e-4af0-9f3a-6845e782b31c',boot)+body
    compile(source,'codec-ab-remote','exec')
    return source


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output',type=Path,required=True);p.add_argument('--gate',type=Path,required=True)
    p.add_argument('--remote-root',default='/home/xilinx/voice-view-game/volume-response-codec-ab-a01')
    p.add_argument('--speaker',default='Senary');p.add_argument('--run',action='store_true');args=p.parse_args()
    assert args.remote_root.startswith('/home/xilinx/voice-view-game/volume-response-codec-ab-')
    gate=json.loads(args.gate.read_text(encoding='utf-8'))
    assert gate['gate']=='READ_ONLY_IDLE_GATE_PASS'
    source=remote_source(gate['state']['boot_id'],args.remote_root)
    if not args.run:print('CODEC_AB_CHECK_ONLY_PASS');return
    assert time.time()-gate['finished_unix']<3600
    from PySide6.QtCore import QByteArray,QBuffer,QCoreApplication,QIODevice
    from PySide6.QtMultimedia import QAudio,QAudioFormat,QAudioSink,QMediaDevices
    from pycaw.pycaw import AudioUtilities
    app=QCoreApplication.instance() or QCoreApplication([])
    device,=(d for d in QMediaDevices.audioOutputs() if args.speaker in d.description())
    speaker=AudioUtilities.GetSpeakers();assert bytes(device.id()).decode()==speaker.id
    endpoint=speaker.EndpointVolume;before=dict(mute=bool(endpoint.GetMute()),scalar=endpoint.GetMasterVolumeLevelScalar())
    args.output.mkdir(parents=True,exist_ok=False)
    (args.output/'remote_source.py').write_text(source,encoding='utf-8')
    receipt=dict(status='PREPARED',gate_sha256=hashlib.sha256(args.gate.read_bytes()).hexdigest(),source_sha256=hashlib.sha256(source.encode()).hexdigest(),speaker=dict(name=device.description(),id=speaker.id,before=before),cues=[],hardware_skill_verified=False)
    def save():(args.output/'receipt.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
    save()
    fmt=QAudioFormat();fmt.setSampleRate(48000);fmt.setChannelCount(1);fmt.setSampleFormat(QAudioFormat.SampleFormat.Int16)
    assert device.isFormatSupported(fmt)
    sink=QAudioSink(device,fmt);buffers=[];lines=[];messages=queue.Queue();process=None
    command=['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8','pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -']
    receipt['command']=command
    def pump(seconds):
        end=time.monotonic()+seconds
        while time.monotonic()<end:app.processEvents();threading.Event().wait(.01)
    try:
        process=subprocess.Popen(command,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,bufsize=1)
        process.stdin.write(source);process.stdin.close()
        def collect():
            for line in process.stdout:lines.append(line);messages.put(line)
        reader=threading.Thread(target=collect,daemon=True);reader.start()
        endpoint.SetMasterVolumeLevelScalar(.65,None);endpoint.SetMute(False,None)
        deadline=time.monotonic()+105
        while True:
            try:line=messages.get(timeout=.05)
            except queue.Empty:line=''
            if line.startswith('CODEC_AB_READY '):
                phase=json.loads(line.removeprefix('CODEC_AB_READY '));cue=dict(**phase,pc_ns=time.monotonic_ns())
                buffer=QBuffer(sink);buffer.setData(QByteArray(waveform(.1,1000)));assert buffer.open(QIODevice.OpenModeFlag.ReadOnly);buffers.append(buffer)
                sink.start(buffer);pump(.65)
                cue.update(processed_us=sink.processedUSecs(),remaining=buffer.bytesAvailable(),error=sink.error().value)
                assert cue['processed_us']>=490000 and cue['remaining']==0 and cue['error']==QAudio.Error.NoError.value
                sink.stop();receipt['cues'].append(cue);receipt['status']='RECORDING';save()
                print('VOICE_PHASE_ACTIVE',phase['index'],phase['profile'],flush=True)
            if process.poll() is not None:
                reader.join(2)
                finals=[json.loads(s.removeprefix('CODEC_AB_FINAL ')) for s in lines if s.startswith('CODEC_AB_FINAL ')]
                assert process.returncode==0 and len(finals)==1 and finals[0]['phase']=='recorded' and finals[0]['cleanup_confirmed'], 'board did not complete normally; inspect log'
                assert [c['index'] for c in receipt['cues']]==[0,1,2]
                receipt.update(status='CODEC_AB_CAPTURE_COMPLETE',capture=finals[0]);break
            if time.monotonic()>deadline:raise RuntimeError('board exit unconfirmed; retain owner and do not rerun')
            pump(.01)
    except BaseException as error:
        receipt.update(status='FAIL',error=repr(error));raise
    finally:
        sink.stop();endpoint.SetMasterVolumeLevelScalar(before['scalar'],None);endpoint.SetMute(before['mute'],None)
        after=dict(mute=bool(endpoint.GetMute()),scalar=endpoint.GetMasterVolumeLevelScalar())
        receipt['speaker'].update(after=after,restored=after['mute']==before['mute'] and abs(after['scalar']-before['scalar'])<1e-5)
        receipt['remote_process_exit']=None if process is None else process.poll()
        (args.output/'board.log').write_text(''.join(lines),encoding='utf-8');save()
        assert receipt['speaker']['restored']
    print(receipt['status'])


if __name__=='__main__':main()
