"""Run the frozen autonomous audio worker in the designated offline ARM guest.

Guest command: python3 /opt/vvg-cosim/guest_audio.py
Requires SystemC/XSI real RTL at simulation-only 0x41000000/1000 and codec
transaction mailbox at 0x41002000. Output: VVG_AUDIO_PAGE/COMMIT/RESULT lines.
Next: validate raw RTL/HDMI traces independently; result is not physical proof.
"""
import json
import ctypes
import mmap
import os
from pathlib import Path
import platform
import struct
import sys
import time

ROOT=Path(__file__).resolve().parent
sys.path[:0]=[str(ROOT/'scripts'),str(ROOT/'python')]


def guard():
    assert Path('/proc/device-tree/model').read_bytes().rstrip(b'\0')==b'VoiceView offline QEMU cosimulation'
    assert platform.machine()=='armv7l'


class Registers:
    def __init__(self,address):
        guard()
        self.fd=os.open('/dev/mem',os.O_RDWR|os.O_SYNC)
        self.memory=mmap.mmap(self.fd,4096,offset=address)
    # A single aligned ARM load/store, not a sequence of byte accesses.
    def read(self,offset):return ctypes.c_uint32.from_buffer(self.memory,offset).value
    def write(self,offset,value):ctypes.c_uint32.from_buffer(self.memory,offset).value=value
    def close(self):self.memory.close();os.close(self.fd)


class AudioBackend:
    def __init__(self):
        self.volume=Registers(0x41000000);self.codec=Registers(0x41002000)
    def read32(self,offset):return self.volume.read(offset)
    def write32(self,offset,value):self.volume.write(offset,value)
    def codec_read(self,register,length):
        self.codec.write(0,register);self.codec.write(4,length);self.codec.write(16,1)
        return (self.codec.read(24).to_bytes(4,'little')+self.codec.read(28).to_bytes(4,'little'))[:length]
    def codec_write(self,register,payload):
        assert 1<=len(payload)<=8
        self.codec.write(0,register);self.codec.write(4,len(payload))
        padded=payload.ljust(8,b'\0')
        self.codec.write(8,int.from_bytes(padded[:4],'little'))
        self.codec.write(12,int.from_bytes(padded[4:],'little'));self.codec.write(16,2)
        return len(payload)
    def close(self):self.volume.close();self.codec.close()


def emit(kind,value):print('VVG_AUDIO_'+kind+' '+json.dumps(value),flush=True)


def main():
    guard()
    # Reuse baseline's source identity verification before importing production.
    import hashlib
    for name,expected in json.loads((ROOT/'source-hashes.json').read_text()).items():
        assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==expected,name
    from voice_volume_runtime import AutonomousVolumeProcess
    from pynq_multimodal_game.osd_publisher import OsdPublisher
    from pynq_multimodal_game.input_osd import audio_observation
    worker=AutonomousVolumeProcess(AudioBackend,
        dict(quiet_sum=11*977,soft_sum=16*977,loud_sum=28*977))
    io=None;maximum=0;ack=0;commits=0
    try:
        worker.start()
        io=Registers(0x41001000);publisher=OsdPublisher(io)
        stop=time.monotonic_ns()+900_000_000
        while time.monotonic_ns()<stop:
            started=time.monotonic_ns()
            page=worker.page.read_observation()
            if page:
                emit('PAGE',page)
                assert not page['error'],page
                maximum=max(maximum,page['l1_sum']/977)
                ack=max(ack,page['ack_count'])
            if publisher.tick(None,audio_observation(page),now_ns=started):
                commits+=1
                emit('COMMIT',dict(monotonic_ns=time.monotonic_ns(),words=list(publisher.last_words)))
            time.sleep(max(0,(started+33_333_334-time.monotonic_ns())/1e9))
        worker.close()
        assert worker.stopped_confirmed and worker.process.exitcode==0
        assert maximum>=28 and ack>=1 and commits>=10,(maximum,ack,commits)
        emit('RESULT',dict(status='ARM_WORKER_OBSERVED',max_mean=maximum,ack_count=ack,
            osd_commits=commits,worker_pid=worker.process.pid,worker_exitcode=worker.process.exitcode,
            stopped_confirmed=worker.stopped_confirmed,board_access=False,physical_microphone=False))
    finally:
        if io:io.close()
        if not worker.stopped_confirmed:
            # Guest-only cleanup: whole simulator is bounded by its PC owner.
            # Preserve failure and original cleanup semantics; do not force ACK.
            worker.close()


if __name__=='__main__':main()
