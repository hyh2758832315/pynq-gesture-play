"""Audited remote source for existing official Base audio capture (no bit load).

Used only by base_acoustic_probe.py after current release/idle gate. Outputs
exclusive /home/xilinx/voice-view-game/volume-response-a01/{raw.npy,capture.wav,receipt.json}.
Next: correlate raw left/right PCM with PC speaker pulse timestamps.
"""

SOURCE = r'''
import os
os.environ['XILINX_XRT']='/usr'
import fcntl,hashlib,json,pathlib,time
from contextlib import ExitStack
from xml.etree import ElementTree as ET
ROOT=pathlib.Path('/home/xilinx/voice-view-game/volume-response-a01')
BOOT='db5b70bc-7b6e-4af0-9f3a-6845e782b31c'
assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()==BOOT
base=pathlib.Path('/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq/overlays/base')
assert hashlib.sha256((base/'base.bit').read_bytes()).hexdigest()=='d9aec0ff1cddeaf109dd08b1510c2ed38b4804bd29ef7648ee80eac8f06de505'
assert hashlib.sha256((base/'base.hwh').read_bytes()).hexdigest()=='94dee45319dfecb22d9684eb565916e62f910eb999650c9a99fda51bdc9158fe'
assert not base.parent.parent.joinpath('pl_server/global_pl_state_.json').exists()
with ExitStack() as stack:
    for path in ('/var/lock/voice-view-c6i.lock','/run/lock/voice_pcm_audio.lock'):
        stream=stack.enter_context(open(path,'a+b'))
        fcntl.flock(stream.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB)
        stream.seek(0);assert not stream.read(),'retained owner journal'
    for p in pathlib.Path('/proc').glob('[0-9]*/maps'):
        try:
            text=p.read_text()
            assert '/dev/mem' not in text and '/dev/uio' not in text,'another hardware mapper'
        except (FileNotFoundError,ProcessLookupError,PermissionError):pass
    tree=ET.parse(base/'base.hwh')
    modules=[m for m in tree.iter('MODULE') if m.get('MODTYPE')=='audio_codec_ctrl']
    assert len(modules)==1
    name=modules[0].get('INSTANCE')
    ranges=[m for m in tree.iter('MEMRANGE') if m.get('INSTANCE')==name]
    assert len(ranges)==1
    address=int(ranges[0].get('BASEVALUE'),0);high=int(ranges[0].get('HIGHVALUE'),0)
    uios=[p for p in pathlib.Path('/sys/class/uio').glob('uio*') if p.joinpath('name').read_text().strip()=='audio-codec-ctrl']
    assert len(uios)==1 and int(uios[0].joinpath('maps/map0/addr').read_text(),0)==address
    ROOT.mkdir(exist_ok=False)
    receipt=dict(boot_id=BOOT,pid=os.getpid(),bit_loaded=False,source='official-existing-base',description=dict(phys_addr=address,addr_range=high-address+1,fullpath=name),phase='binding',cleanup_confirmed=False)
    def save():
        with ROOT.joinpath('receipt.json').open('w') as f:json.dump(receipt,f,indent=2);f.flush();os.fsync(f.fileno())
    save()
    from pynq.lib.audio import AudioADAU1761
    import numpy as np
    import ctypes
    class Message(ctypes.Structure):
        _fields_=[('addr',ctypes.c_uint16),('flags',ctypes.c_uint16),('length',ctypes.c_uint16),('buffer',ctypes.POINTER(ctypes.c_uint8))]
    class Transfer(ctypes.Structure):
        _fields_=[('messages',ctypes.POINTER(Message)),('count',ctypes.c_uint32)]
    def codec_snapshot():
        fd=os.open('/dev/i2c-1',os.O_RDWR|os.O_CLOEXEC)
        values={}
        try:
            fcntl.ioctl(fd,0x0702,10);fcntl.ioctl(fd,0x0701,0)
            for register in (0x4000,0x4008,0x400a,0x400b,0x400c,0x400d,0x400e,0x400f,0x4010,0x4011,0x4012,0x4013,0x4014,0x4015,0x4016,0x4017,0x4018,0x4019,0x401a,0x401b,0x40eb,0x40f2,0x40f3,0x40f5,0x40f6,0x40f9,0x40fa):
                out=(ctypes.c_uint8*2).from_buffer_copy(register.to_bytes(2,'big'));incoming=(ctypes.c_uint8*1)()
                messages=(Message*2)(Message(0x3b,0,2,out),Message(0x3b,1,1,incoming))
                result=fcntl.ioctl(fd,0x0707,bytearray(Transfer(messages,2)))
                assert result==2,'short Codec read'
                values[hex(register)]=int(incoming[0])
        finally:os.close(fd)
        return values
    audio=AudioADAU1761(receipt['description'])
    try:
        receipt['phase']='codec_configure';save()
        audio.configure();audio.select_microphone()
        receipt['codec_before_record']=codec_snapshot()
        receipt.update(phase='recording',record_started_ns=time.monotonic_ns(),seconds=12)
        save();print('BASE_CAPTURE_READY '+json.dumps(dict(root=str(ROOT),seconds=12)),flush=True)
        audio.record(12)
        receipt.update(phase='saving',record_finished_ns=time.monotonic_ns(),sample_rate=audio.sample_rate,sample_len=audio.sample_len)
        np.save(str(ROOT/'raw.npy'),audio.buffer,allow_pickle=False)
        audio.save(str(ROOT/'capture.wav'))
        words=audio.buffer.astype(np.int64)&0xffffff
        signed=np.where(words&0x800000,words-0x1000000,words).reshape(-1,2)
        receipt['channels']=[]
        for i in range(2):
            v=signed[:,i].astype(np.float64);ac=v-v.mean()
            receipt['channels'].append(dict(index=i,dc=float(v.mean()),ac_rms_24=float(np.sqrt(np.mean(ac*ac))),peak_24=int(np.max(np.abs(v))),nonzero_fraction=float(np.mean(v!=0)),equivalent_s16_ac_rms=float(np.sqrt(np.mean(ac*ac))/256)))
        receipt['phase']='recorded'
    except BaseException as e:
        receipt.update(phase='failed',error=repr(e));raise
    finally:
        audio.deselect_inputs()
        receipt['cleanup_confirmed']=True
        receipt['files']={p.name:dict(bytes=p.stat().st_size,sha256=hashlib.sha256(p.read_bytes()).hexdigest()) for p in (ROOT/'raw.npy',ROOT/'capture.wav') if p.exists()}
        save()
        print('BASE_CAPTURE_FINAL '+json.dumps(receipt),flush=True)
'''
