"""ARM/Linux baseline inside the explicitly identified offline QEMU guest only.

Guest command: python3 /opt/vvg-cosim/guest_smoke.py
Output: VVG_GUEST_SMOKE_PASS JSON after MMIO time, spawn, and original shared-page
ABI checks. Next: replace the demo device with real audio/OSD RTL transport.
Does not validate microphone, audio algorithm, or actual PYNQ kernel equivalence.
"""
import hashlib
import ctypes
import json
import mmap
import multiprocessing
import os
from pathlib import Path
import platform
import struct
import sys
import time


def fixture_writer(page, connection):
    # Shared-page ABI fixture only; no audio result is invented for the DUT.
    page.publish(dict(phase=2,observed_ns=time.monotonic_ns(),epoch=7,enabled=1,
        clock_locked=1,snapshot_valid=1,sample_count=977,window_count=1,l1_sum=62528,
        quiet=10747,soft=15632,loud=27356))
    connection.send(os.getpid());connection.close()


def main():
    model=Path('/proc/device-tree/model').read_bytes().rstrip(b'\0')
    assert model==b'VoiceView offline QEMU cosimulation','refuse to run outside designated guest'
    assert platform.machine()=='armv7l',platform.machine()
    root=Path(__file__).resolve().parent
    hashes=json.loads((root/'source-hashes.json').read_text())
    for name,expected in hashes.items():
        assert hashlib.sha256((root/name).read_bytes()).hexdigest()==expected,name
    sys.path[:0]=[str(root/'scripts'),str(root/'python')]
    from voice_volume_runtime import VolumeSharedPage
    from pynq_multimodal_game.input_osd import audio_observation
    fd=os.open('/dev/mem',os.O_RDWR|os.O_SYNC)
    try:
        with mmap.mmap(fd,4096,offset=0x40000000) as registers:
            ticks=[]
            for _ in range(3):
                ticks.append(ctypes.c_uint32.from_buffer(registers,0).value);time.sleep(.01)
    finally:os.close(fd)
    assert all(0<(b-a)&0xffffffff<1_000_000_000 for a,b in zip(ticks,ticks[1:])),ticks
    context=multiprocessing.get_context('spawn')
    page=VolumeSharedPage(context,'12'*16)
    parent,child=context.Pipe(False)
    process=context.Process(target=fixture_writer,args=(page,child));process.start();child.close()
    assert parent.poll(10),'spawn worker did not publish'
    worker_pid=parent.recv();process.join(5);assert process.exitcode==0,process.exitcode
    observation=audio_observation(page.read_observation())
    assert observation.healthy and observation.mean_abs==64 and observation.epoch==7,observation
    result=dict(schema='vvg-qemu-baseline-v1',guest_model=model.decode(),machine=platform.machine(),
        kernel=platform.release(),python=sys.version,mmio_ticks=ticks,
        parent_pid=os.getpid(),worker_pid=worker_pid,spawn_exitcode=process.exitcode,
        original_shared_page_abi=True,audio_rtl_connected=False,board_access=False)
    print('VVG_GUEST_SMOKE_PASS '+json.dumps(result),flush=True)


if __name__=='__main__':main()
