# Run via remote.py; output unique receipt; inspect before next board phase.
def verify_base_metadata(pynq_root):
    state_path = pynq_root / 'pl_server/global_pl_state_.json'
    if state_path.exists():
        state_bytes = state_path.read_bytes()
        metadata = json.loads(state_bytes)
        expected = pynq_root / 'overlays/base/base.bit'
        assert pathlib.Path(metadata['bitfile_name']).resolve() == expected.resolve()
        assert hashlib.sha256(expected.read_bytes()).hexdigest() == BASE_HASHES['base.bit']
        print(json.dumps({'phase': 'OFFICIAL_BASE_METADATA_VERIFIED', 'metadata_sha256': hashlib.sha256(state_bytes).hexdigest()}), flush=True)
import ast, fcntl, hashlib, json, os, pathlib, subprocess, sys
root = pathlib.Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip() == '92f1a779-d821-46cd-a8d1-69a2a26cbc1f'
manifest = json.loads((root / 'deployment_manifest.json').read_text())
assert manifest['build_id'] == '0xC0060E00' and manifest['board_pending'] is True and (manifest['release_ready'] is False)
assert manifest['backend'] == 'c6i-vision-volume' and len(manifest['sha256']) == 628
for name, digest in manifest['sha256'].items():
    path = (root / name).resolve()
    assert path.is_relative_to(root) and hashlib.sha256(path.read_bytes()).hexdigest().upper() == digest, name
import ctypes, mmap, time, threading, types
from contextlib import ExitStack
from importlib.metadata import distribution
from pathlib import Path
from xml.etree import ElementTree as ET
BASE_HASHES = {'base.bit': 'd9aec0ff1cddeaf109dd08b1510c2ed38b4804bd29ef7648ee80eac8f06de505', 'base.hwh': '94dee45319dfecb22d9684eb565916e62f910eb999650c9a99fda51bdc9158fe'}
BASE_DMA = {'video_axi_vdma': 1124073472, 'trace_analyzer_pmodb_axi_dma_0': 2151809024, 'trace_analyzer_pi_axi_dma_0': 2151874560}

def checkpoint(root, phase):
    entry = {'phase': phase, 'pid': os.getpid(), 'monotonic_ns': time.monotonic_ns()}
    text = json.dumps(entry)
    with (root / 'startup-phases.jsonl').open('a', encoding='utf-8') as output:
        output.write(text + '\n')
        output.flush()
        os.fsync(output.fileno())
    print(text, flush=True)

def read_dma_registers(window, offset):
    control = ctypes.c_uint32.from_buffer(window, offset).value
    status = ctypes.c_uint32.from_buffer(window, offset + 4).value
    return (control, status)

def audit_base(boot_id):
    if Path('/proc/sys/kernel/random/boot_id').read_text().strip() != boot_id:
        raise RuntimeError('Boot identity changed')
    pynq_root = Path(distribution('pynq').locate_file('pynq'))
    verify_base_metadata(pynq_root)
    base = pynq_root / 'overlays/base'
    for name, expected in BASE_HASHES.items():
        if hashlib.sha256((base / name).read_bytes()).hexdigest() != expected:
            raise RuntimeError('Official Base identity changed')
    for service in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
        completed = subprocess.run(['systemctl', 'show', service, '-p', 'ActiveState', '-p', 'MainPID', '-p', 'Result'], check=True, capture_output=True, text=True, timeout=5)
        properties = dict((line.split('=', 1) for line in completed.stdout.splitlines() if '=' in line))
        if properties != {'ActiveState': 'inactive', 'MainPID': '0', 'Result': 'success'}:
            raise RuntimeError('Startup/business service not quiescent: ' + service)
    for process in Path('/proc').glob('[0-9]*/maps'):
        try:
            if '/dev/mem' in process.read_text() or '/dev/uio' in process.read_text():
                raise RuntimeError('Existing hardware mapping: ' + str(process))
        except (FileNotFoundError, ProcessLookupError):
            continue
    tree = ET.parse(base / 'base.hwh')
    modules = {node.get('INSTANCE'): node for node in tree.iter('MODULE') if node.get('MODTYPE') in ('axi_dma', 'axi_vdma')}
    addresses = {node.get('INSTANCE'): int(node.get('BASEVALUE'), 0) for node in tree.iter('MEMRANGE')}
    if set(modules) != set(BASE_DMA) or any((addresses.get(name) != address for name, address in BASE_DMA.items())):
        raise RuntimeError('Base DMA inventory changed')
    report = []
    with ExitStack() as resources:
        descriptor = os.open('/dev/mem', os.O_RDWR | os.O_SYNC)
        resources.callback(os.close, descriptor)
        for name, address in BASE_DMA.items():
            parameters = {node.get('NAME'): node.get('VALUE') for node in modules[name].iter('PARAMETER')}
            window = resources.enter_context(mmap.mmap(descriptor, 4096, access=mmap.ACCESS_WRITE, offset=address))
            for direction, offset in (('MM2S', 0), ('S2MM', 48)):
                if parameters.get('C_INCLUDE_' + direction) == '1':
                    control, status = read_dma_registers(window, offset)
                    if control & 5 or not status & 1:
                        raise RuntimeError('Base DMA not halted: ' + name + '/' + direction)
                    report.append({'instance': name, 'direction': direction, 'control': control, 'status': status})
    return report
board = types.SimpleNamespace(BASE_HASHES=BASE_HASHES, BASE_DMA=BASE_DMA, checkpoint=checkpoint, read_dma_registers=read_dma_registers, audit_base=audit_base)
root = root / 'var/marker-hand-20261024-a03'
root.mkdir(parents=True)
boot = '92f1a779-d821-46cd-a8d1-69a2a26cbc1f'
assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip() == boot
pynq_root = pathlib.Path('/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq')
verify_base_metadata(pynq_root)
assert not pathlib.Path('/run/lock/voice-view-cold-' + boot + '.attempt').exists()
for name, digest in board.BASE_HASHES.items():
    assert hashlib.sha256((pynq_root / 'overlays/base' / name).read_bytes()).hexdigest() == digest
tree = ET.parse(pynq_root / 'overlays/base/base.hwh')
modules = {node.get('INSTANCE'): node for node in tree.iter('MODULE') if node.get('MODTYPE') in ('axi_dma', 'axi_vdma')}
addresses = {node.get('INSTANCE'): int(node.get('BASEVALUE'), 0) for node in tree.iter('MEMRANGE')}
assert set(modules) == set(board.BASE_DMA)
assert all((addresses.get(name) == address for name, address in board.BASE_DMA.items()))
with ExitStack() as owner:
    for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock'):
        stream = owner.enter_context(open(name, 'a+b'))
        fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        stream.seek(0)
        assert not stream.read()
    for service in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
        result = subprocess.run(['systemctl', 'show', service, '-p', 'ActiveState', '-p', 'MainPID', '-p', 'Result'], capture_output=True, text=True, check=True, timeout=5)
        assert dict((line.split('=', 1) for line in result.stdout.splitlines())) == {'ActiveState': 'inactive', 'MainPID': '0', 'Result': 'success'}
    for path in pathlib.Path('/proc').glob('[0-9]*/maps'):
        try:
            text = path.read_text()
            assert '/dev/mem' not in text and '/dev/uio' not in text, str(path)
        except (FileNotFoundError, ProcessLookupError):
            pass
    marker = pathlib.Path('/run/lock/vision-v0-base-normal-stop-' + boot + '.attempt')
    with marker.open('x') as output:
        json.dump({'boot_id': boot, 'pid': os.getpid(), 'root': str(root)}, output)
        output.flush()
        os.fsync(output.fileno())
    board.checkpoint(root, 'base_normal_stop_begin')
    report = []
    with ExitStack() as hardware:
        descriptor = os.open('/dev/mem', os.O_RDWR | os.O_SYNC | os.O_CLOEXEC)
        hardware.callback(os.close, descriptor)
        windows = {name: hardware.enter_context(mmap.mmap(descriptor, 4096, offset=address)) for name, address in board.BASE_DMA.items()}
        for direction, offset in (('MM2S', 0), ('S2MM', 48)):
            control, status = board.read_dma_registers(windows['video_axi_vdma'], offset)
            print(json.dumps({'phase': 'vdma_halted_check', 'direction': direction, 'control': control, 'status': status}), flush=True)
            assert not control & 5 and status & 1, 'VDMA is active; do not take over'
        for name in ('trace_analyzer_pmodb_axi_dma_0', 'trace_analyzer_pi_axi_dma_0'):
            parameters = {node.get('NAME'): node.get('VALUE') for node in modules[name].iter('PARAMETER')}
            assert parameters.get('C_INCLUDE_MM2S') == '0' and parameters.get('C_INCLUDE_S2MM') == '1'
            window = windows[name]
            control, status = board.read_dma_registers(window, 48)
            assert not control & 4 and (not status & 1904), 'Trace DMA reset/error'
            before = {'instance': name, 'control': control, 'status': status}
            print(json.dumps({'phase': 'before_normal_stop', **before}), flush=True)
            if control & 1:
                board.checkpoint(root, 'normal_stop_write_' + name)
                ctypes.c_uint32.from_buffer(window, 48).value = control & ~1
            deadline = time.monotonic() + 2
            while True:
                after_control, after_status = board.read_dma_registers(window, 48)
                if not after_control & 5 and after_status & 1:
                    break
                if time.monotonic() >= deadline:
                    raise TimeoutError('Normal halt timeout: ' + name)
                threading.Event().wait(0.005)
            report.append({'before': before, 'after_control': after_control, 'after_status': after_status})
    summary = {'boot_id': boot, 'normal_stop': report, 'all_base_dma': board.audit_base(boot), 'overlay_loaded': False, 'codec_touched': False}
    with (root / 'base-stop.json').open('x') as output:
        json.dump(summary, output)
        output.flush()
        os.fsync(output.fileno())
    board.checkpoint(root, 'base_normal_stop_passed')
    print(json.dumps(summary), flush=True)