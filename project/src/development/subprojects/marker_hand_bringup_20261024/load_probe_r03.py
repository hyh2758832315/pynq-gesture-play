"""Load-only R21 diagnostic using the frozen loader and session ownership.

Run with remote.py after base_stop.py. Outputs: load-phases.jsonl plus receipt.
Next: only LOAD_ONLY_PASS permits the full runtime phase. No camera/audio/DMA starts.
"""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

BOOT = '92f1a779-d821-46cd-a8d1-69a2a26cbc1f'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
LOG = ROOT/'var/marker-hand-20261024-a03'
assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
assert json.loads((LOG/'base-stop.json').read_text())['boot_id'] == BOOT
manifest = json.loads((ROOT/'deployment_manifest.json').read_text())
for name, expected in manifest['sha256'].items():
    path = (ROOT/name).resolve()
    assert path.is_relative_to(ROOT) and hashlib.sha256(path.read_bytes()).hexdigest().upper() == expected, name
for proc in Path('/proc').glob('[0-9]*/maps'):
    try:
        maps = proc.read_text()
        assert '/dev/mem' not in maps and '/dev/uio' not in maps, str(proc)
    except (FileNotFoundError, ProcessLookupError):
        pass
for name in ('bootpy.service','clear_pl_statefile.service','voice-view-shell.service'):
    value = subprocess.run(['systemctl','show',name,'-p','ActiveState','-p','MainPID','-p','Result'],capture_output=True,text=True,check=True,timeout=5)
    assert dict(line.split('=',1) for line in value.stdout.splitlines()) == dict(ActiveState='inactive', MainPID='0', Result='success')
for name in ('/var/lock/voice-view-c6i.lock','/run/lock/voice_pcm_audio.lock'):
    with open(name,'rb') as stream:
        fcntl.flock(stream.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB)
        assert not stream.read()
with (LOG/'load-only.attempt').open('x') as out:
    json.dump(dict(boot_id=BOOT, pid=os.getpid(),bit_sha=manifest['sha256']['overlay/c6v_candidate.bit']),out)
    out.flush(); os.fsync(out.fileno())

def phase(name, **values):
    entry = dict(phase=name, boot_id=BOOT, pid=os.getpid(), monotonic_ns=time.monotonic_ns(), **values)
    with (LOG/'load-phases.jsonl').open('a') as out:
        out.write(json.dumps(entry,default=str)+'\n'); out.flush(); os.fsync(out.fileno())
    print(json.dumps(entry,default=str),flush=True)

sys.path.insert(0,str(ROOT/'python'))
os.environ['XILINX_XRT']='/usr'
phase('before_import')
import pynq
from pynq_multimodal_game.agent.cli import _load_shared_vision_overlay
from pynq_multimodal_game.agent.c6i_backend import C6IOverlaySession
phase('imports_ready')

def loader(bitstream, *, download):
    phase('before_metadata')
    overlay = _load_shared_vision_overlay(bitstream,download=False)
    phase('metadata_ready',build_id_ip=overlay.ip_dict.get('build_id_gpio'),clocks=overlay.clock_dict)
    device = overlay.device
    for method_name in ('shutdown','gen_cache','set_axi_port_width','_xrt_download'):
        original = getattr(device,method_name)
        def traced(*args,_method=original,_name=method_name,**kwargs):
            phase('before_'+_name)
            result = _method(*args,**kwargs)
            phase('after_'+_name)
            return result
        setattr(device,method_name,traced)
    if download:
        phase('before_overlay_download')
        overlay.download()
        phase('after_overlay_download')
    return overlay

class TracedMMIO:
    def __init__(self,address,length):
        phase('before_mmio_map',address=address,length=length)
        self.raw=pynq.MMIO(address,length)
        phase('after_mmio_map',address=address)
    def read(self,offset):
        phase('before_mmio_read',offset=offset)
        value=self.raw.read(offset)
        phase('after_mmio_read',value=int(value))
        return value

session=C6IOverlaySession(str(ROOT/'overlay/c6v_candidate.bit'),lock_path='/var/lock/voice-view-c6i.lock',
                          expected_build_id=0xC0060E00,overlay_factory=loader,mmio_factory=TracedMMIO,allocate=pynq.allocate)
phase('before_session_open')
try:
    session.open()
    phase('build_id_pass')
finally:
    phase('before_session_close')
    session.close()
    phase('after_session_close')
phase('C6I_LOAD_ONLY_PASS')
