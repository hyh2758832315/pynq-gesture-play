"""Normally stop official Base DMA before the isolated R21 comparison.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/r21_base_stop_c01.py --output build/hosd/osd-reset-r01/r21-base-stop-c01.json --timeout 60
Output: exclusive PC receipt and board R21 var/osd-r21-compare-20261024-c01/base-stop.json.
Next: verify the receipt and a fresh idle gate before loading R21.
"""
import fcntl
import hashlib
import json
import mmap
import os
from pathlib import Path
import struct
import subprocess
import time
from xml.etree import ElementTree as ET

BOOT = '0aa3d567-97fe-42d7-91be-332f0aaf6c22'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
LOG = ROOT / 'var/osd-r21-compare-20261024-c01'
BASE = Path('/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq/overlays/base')
BASE_SHA = {'base.bit': 'd9aec0ff1cddeaf109dd08b1510c2ed38b4804bd29ef7648ee80eac8f06de505',
            'base.hwh': '94dee45319dfecb22d9684eb565916e62f910eb999650c9a99fda51bdc9158fe'}
DMA = {'video_axi_vdma': 1124073472,
       'trace_analyzer_pmodb_axi_dma_0': 2151809024,
       'trace_analyzer_pi_axi_dma_0': 2151874560}


def check_idle():
    assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
    for proc in Path('/proc').glob('[0-9]*/maps'):
        try:
            maps = proc.read_text(errors='replace')
            assert '/dev/mem' not in maps and '/dev/uio' not in maps, str(proc)
        except (FileNotFoundError, ProcessLookupError):
            pass
    for proc in Path('/proc').glob('[0-9]*/cmdline'):
        try:
            cmd = proc.read_bytes().replace(b'\0', b' ').decode(errors='replace')
            assert not any(name in cmd for name in ('start_board_test.py', 'pynq_usb_hand',
                                                     'board_buttons.py', 'run_agent_shadow.py'))
        except (FileNotFoundError, ProcessLookupError):
            pass
    for service in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
        p = subprocess.run(['systemctl', 'show', service, '-p', 'ActiveState', '-p',
                            'MainPID', '-p', 'Result'], capture_output=True, text=True,
                           check=True, timeout=5)
        assert all(x in p.stdout for x in ('ActiveState=inactive', 'MainPID=0', 'Result=success')), service


def reg(window, offset):
    return struct.unpack_from('<II', window, offset)


check_idle()
assert LOG.is_dir() and (LOG / 'base-restore.jsonl').exists()
assert hashlib.sha256((ROOT / 'overlay/c6v_candidate.bit').read_bytes()).hexdigest() == '10b01f51e3dc184496c94609d895211215045dac98efdb41b898277f2a10c72f'
for name, digest in BASE_SHA.items():
    assert hashlib.sha256((BASE / name).read_bytes()).hexdigest() == digest
manifest = json.loads((ROOT / 'deployment_manifest.json').read_text())
assert manifest['build_id'] == '0xC0060E00' and len(manifest['sha256']) == 628
tree = ET.parse(BASE / 'base.hwh')
modules = {m.get('INSTANCE'): m for m in tree.iter('MODULE') if m.get('MODTYPE') in ('axi_dma', 'axi_vdma')}
addresses = {m.get('INSTANCE'): int(m.get('BASEVALUE'), 0) for m in tree.iter('MEMRANGE')}
assert set(modules) == set(DMA) and all(addresses.get(k) == v for k, v in DMA.items())
locks = []
try:
    for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock'):
        stream = open(name, 'a+b')
        locks.append(stream)
        fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        stream.seek(0)
        assert not stream.read(), name
    check_idle()
    LOG.mkdir(parents=True, exist_ok=True)
    descriptor = os.open('/dev/mem', os.O_RDWR | os.O_SYNC)
    try:
        windows = {name: mmap.mmap(descriptor, 4096, offset=address) for name, address in DMA.items()}
        try:
            for direction, offset in (('MM2S', 0), ('S2MM', 48)):
                control, status = reg(windows['video_axi_vdma'], offset)
                assert not control & 5 and status & 1, ('VDMA active', direction, control, status)
            report = []
            for name in ('trace_analyzer_pmodb_axi_dma_0', 'trace_analyzer_pi_axi_dma_0'):
                parameters = {p.get('NAME'): p.get('VALUE') for p in modules[name].iter('PARAMETER')}
                assert parameters.get('C_INCLUDE_MM2S') == '0' and parameters.get('C_INCLUDE_S2MM') == '1'
                window = windows[name]
                control, status = reg(window, 48)
                assert not control & 4 and not status & 1904, (name, control, status)
                if control & 1:
                    struct.pack_into('<I', window, 48, control & ~1)
                deadline = time.monotonic() + 2
                while True:
                    after_control, after_status = reg(window, 48)
                    if not after_control & 5 and after_status & 1:
                        break
                    assert time.monotonic() < deadline, ('DMA stop timeout', name)
                    time.sleep(.005)
                report.append(dict(instance=name, before_control=control,
                                   before_status=status, after_control=after_control,
                                   after_status=after_status))
            all_dma = []
            for name, window in windows.items():
                parameters = {p.get('NAME'): p.get('VALUE') for p in modules[name].iter('PARAMETER')}
                for direction, offset in (('MM2S', 0), ('S2MM', 48)):
                    if parameters.get('C_INCLUDE_' + direction) == '1':
                        control, status = reg(window, offset)
                        assert not control & 5 and status & 1, (name, direction, control, status)
                        all_dma.append(dict(instance=name, direction=direction, control=control, status=status))
        finally:
            for window in windows.values():
                window.close()
    finally:
        os.close(descriptor)
    result = dict(verdict='R21_BASE_STOP_PASS', boot_id=BOOT, trace_stop=report,
                  all_dma=all_dma, overlay_loaded=False)
    with (LOG / 'base-stop.json').open('x') as output:
        json.dump(result, output)
        output.flush()
        os.fsync(output.fileno())
    print(json.dumps(result), flush=True)
finally:
    for stream in reversed(locks):
        stream.close()
