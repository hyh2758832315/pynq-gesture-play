from __future__ import annotations

from contextlib import contextmanager, ExitStack
from importlib.metadata import distribution
import hashlib
import json
import mmap
import os
from pathlib import Path
import struct
import subprocess
import sys
import time
from xml.etree import ElementTree as ET

from pynq_multimodal_game.agent.c6i_backend import C6IOverlaySession


OWNER_LOCK = Path('/var/lock/voice-view-c6i.lock')
AUDIO_LOCK = Path('/run/lock/voice_pcm_audio.lock')
BASELINE = Path('/home/xilinx/voice-view-game/voice-s4-runtime-fix-r218-20261015')
BASELINE_MANIFEST_SHA256 = '9be167943e5678e5a21611a3d1d16521446993cdc449e2f03360848d3b968223'


def _dma_inventory(build_id: int) -> frozenset:
    common = {('axi_dma', 'MM2S'), ('moments_dma', 'S2MM'),
              ('voice_pcm_dma', 'S2MM'), ('frame_dma', 'S2MM')}
    if build_id == 0xC0060900:
        return frozenset(common | {('moments_dma', 'MM2S'), ('return_dma', 'S2MM')})
    if build_id == 0xC0060B00:
        return frozenset(common)
    raise ValueError('Audited BUILD required for DMA inventory')


def _audit_cold_boot(boot_id: str) -> dict:
    if Path('/proc/sys/kernel/random/boot_id').read_text().strip() != boot_id:
        raise RuntimeError('Cold boot identity mismatch')
    marker = Path('/run/lock') / ('voice-view-cold-' + boot_id + '.attempt')
    state_path = Path(distribution('pynq').locate_file('pynq')) / 'pl_server/global_pl_state_.json'
    if marker.exists() or state_path.exists():
        raise RuntimeError('Cold boot already consumed or active PL metadata exists')
    base = Path(distribution('pynq').locate_file('pynq')) / 'overlays/base'
    identities = {
        base / 'base.bit': 'd9aec0ff1cddeaf109dd08b1510c2ed38b4804bd29ef7648ee80eac8f06de505',
        base / 'base.hwh': '94dee45319dfecb22d9684eb565916e62f910eb999650c9a99fda51bdc9158fe',
        Path('/boot/boot.py'): 'b2653ef809c3271231c78772342c2be728d39686a877d3c6fe8cdabfd4ac1d42',
        Path('/usr/local/bin/clear_pl_statefile.sh'): '37beb431e2c26d5df4f8ff57b42fe889b73cdee0dd705dcf27780bb22a07a0ad',
    }
    if any(hashlib.sha256(path.read_bytes()).hexdigest() != digest for path, digest in identities.items()):
        raise RuntimeError('Cold boot base or startup source identity changed')
    service_report = {}
    for name in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
        completed = subprocess.run(['systemctl', 'show', name, '--property=ActiveState,SubState,Result,ExecMainPID,ExecMainStatus,ExecMainExitTimestampMonotonic'],
                                   check=True, capture_output=True, text=True)
        values = dict(line.split('=', 1) for line in completed.stdout.splitlines() if '=' in line)
        if (values.get('ActiveState') != 'inactive' or values.get('SubState') != 'dead'
                or values.get('Result') != 'success' or values.get('ExecMainStatus') != '0'
                or values.get('ExecMainPID') != '0' and name == 'voice-view-shell.service'):
            raise RuntimeError('Cold boot initialization or business service not quiescent: ' + name)
        service_report[name] = values
    boot_exit = int(service_report['bootpy.service']['ExecMainExitTimestampMonotonic'])
    clear_exit = int(service_report['clear_pl_statefile.service']['ExecMainExitTimestampMonotonic'])
    if not 0 < boot_exit < clear_exit:
        raise RuntimeError('Cold boot startup ordering unconfirmed')
    _verify_no_business_owner()
    if Path('/sys/class/fpga_manager/fpga0/state').read_text().strip() != 'operating':
        raise RuntimeError('Cold boot FPGA manager not operating')
    tree = ET.parse(base / 'base.hwh')
    addresses = {node.get('INSTANCE'): int(node.get('BASEVALUE'), 0) for node in tree.iter('MEMRANGE')}
    expected = {'video_axi_vdma': 0x43000000, 'trace_analyzer_pmodb_axi_dma_0': 0x80420000,
                'trace_analyzer_pi_axi_dma_0': 0x80430000}
    modules = {node.get('INSTANCE'): node for node in tree.iter('MODULE')
               if node.get('MODTYPE') in ('axi_dma', 'axi_vdma')}
    if set(modules) != set(expected) or any(addresses.get(name) != address for name, address in expected.items()):
        raise RuntimeError('Cold boot base DMA inventory changed')
    dma = []
    with ExitStack() as resources:
        descriptor = os.open('/dev/mem', os.O_RDONLY | os.O_SYNC | os.O_CLOEXEC)
        resources.callback(os.close, descriptor)
        for name, address in expected.items():
            parameters = {node.get('NAME'): node.get('VALUE') for node in modules[name].iter('PARAMETER')}
            window = resources.enter_context(mmap.mmap(descriptor, 4096, access=mmap.ACCESS_READ, offset=address))
            for direction, offset in (('MM2S', 0), ('S2MM', 0x30)):
                if parameters.get('C_INCLUDE_' + direction) != '1':
                    continue
                control, status = struct.unpack_from('<II', window, offset)
                if control & 5 or not status & 1:
                    raise RuntimeError('Cold boot base DMA stop unconfirmed: ' + name + '/' + direction)
                dma.append({'instance': name, 'direction': direction, 'control': control, 'status': status})
    if not dma or state_path.exists() or marker.exists():
        raise RuntimeError('Cold boot identity changed during audit')
    return {'boot_id': boot_id, 'cold_boot': True, 'hardware_operations': False,
            'pynq_imported': 'pynq' in sys.modules, 'active_pair': [identities[base / 'base.bit'], identities[base / 'base.hwh']],
            'build_id': 'official-base', 'dma': dma, 'services': service_report,
            'owner_identity_gate_passed': True, 'monotonic_ns': time.monotonic_ns()}


def _is_read_only_startup_monitor(process: Path, arguments: list[str]) -> bool:
    runner = Path(__file__).resolve().parent / 'scripts/run_pl_voice_fusion_acceptance.py'
    expected = [sys.executable, '-B', str(runner), '--startup-monitor', '--monitor-pid',
                str(os.getpid()), '--monitor-directory']
    if len(arguments) != 8 or arguments[:7] != expected:
        return False
    try:
        directory = Path(arguments[7]).resolve(strict=True)
        if directory.parent != runner.parents[3] / 'var' or not directory.name.startswith('fusion-'):
            return False
        parent = int((process / 'stat').read_text().rsplit(')', 1)[1].split()[1])
        ready = json.loads((directory / 'startup-monitor-ready.json').read_bytes())
        return parent == os.getpid() and ready == {'owner_pid': os.getpid(), 'monitor_pid': int(process.name)}
    except (OSError, ValueError, IndexError):
        return False


def _verify_no_business_owner():
    forbidden = ('start_board_test.py', 'run_voice_fusion_acceptance.py', 'run_pl_voice_fusion_acceptance.py',
                 'pynq_multimodal_game.agent', 'capture_camera_direct_plug.py', 'pcm_capture_test.py',
                 'project1_live_ov5640.py', 'run_vision_guarded.py', 'run_camera_live_guarded.py')
    ancestors, parent = set(), os.getppid()
    while parent > 1 and parent not in ancestors:
        ancestors.add(parent)
        parent = int(Path(f'/proc/{parent}/stat').read_text().rsplit(')', 1)[1].split()[1])
    for path in Path('/proc').glob('[0-9]*/cmdline'):
        pid = int(path.parent.name)
        if pid == os.getpid():
            continue
        try:
            arguments = path.read_bytes().decode(errors='replace').rstrip('\0').split('\0')
            command = ' '.join(arguments)
            if pid in ancestors and Path(os.readlink(path.parent / 'exe')).name in ('sudo', 'sshd', 'sh', 'bash', 'nohup'):
                continue
        except FileNotFoundError:
            continue
        if any(name in command for name in forbidden):
            if _is_read_only_startup_monitor(path.parent, arguments):
                continue
            raise RuntimeError(f'Existing hardware business owner PID {pid}; no load permitted')


def _audit_idle_hardware() -> dict:
    from pynq_multimodal_game.agent.vision_pl_fusion import BIT_SHA256, HWH_SHA256
    baseline_bytes = (BASELINE / 'deployment_manifest.json').read_bytes()
    if hashlib.sha256(baseline_bytes).hexdigest() != BASELINE_MANIFEST_SHA256:
        raise RuntimeError('Read-only R218 baseline identity changed')
    baseline = json.loads(baseline_bytes)
    state_path = Path(distribution('pynq').locate_file('pynq')) / 'pl_server/global_pl_state_.json'
    state_before = state_path.read_bytes()
    state = json.loads(state_before)
    active = Path(state['bitfile_name'])
    pair = [hashlib.sha256(path.read_bytes()).hexdigest() for path in (active, active.with_suffix('.hwh'))]
    old_pair = [baseline['sha256']['overlay/c6v_candidate.' + suffix] for suffix in ('bit', 'hwh')]
    if pair not in (old_pair, [BIT_SHA256, HWH_SHA256]):
        raise RuntimeError('Active pair differs from audited R218 or canonical B00')
    expected_build = 0xC0060900 if pair == old_pair else 0xC0060B00
    tree = ET.parse(active.with_suffix('.hwh'))
    addresses = {node.get('INSTANCE'): int(node.get('BASEVALUE'), 0) for node in tree.iter('MEMRANGE')}
    expected = {'axi_dma': 0x40400000, 'return_dma': 0x40410000, 'moments_dma': 0x40420000,
                'voice_pcm_dma': 0x40430000, 'frame_dma': 0x43000000,
                'build_id_gpio': 0x41200000, 'voice_capture': 0x413E0000}
    if expected_build == 0xC0060B00:
        del expected['return_dma']
        expected.update(capture_control=0x413F0000, capture_status=0x41410000)
    if any(addresses.get(name) != address for name, address in expected.items()):
        raise RuntimeError('Active HWH address identity changed')
    if Path('/sys/class/fpga_manager/fpga0/state').read_text().strip() != 'operating':
        raise RuntimeError('FPGA manager not operating')
    _verify_no_business_owner()
    report = {'boot_id': Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
              'hardware_operations': False, 'pynq_imported': 'pynq' in sys.modules,
              'active_pair': pair, 'build_id': hex(expected_build), 'dma': [], 'source_quiescent': False}
    modules = {node.get('INSTANCE'): node for node in tree.iter('MODULE')}
    with ExitStack() as resources:
        descriptor = os.open('/dev/mem', os.O_RDONLY | os.O_SYNC | os.O_CLOEXEC)
        resources.callback(os.close, descriptor)
        windows = {}

        def register(name, offset):
            if name not in windows:
                windows[name] = resources.enter_context(mmap.mmap(
                    descriptor, 4096, access=mmap.ACCESS_READ, offset=addresses[name]))
            return struct.unpack_from('<I', windows[name], offset)[0]

        if register('build_id_gpio', 0) != expected_build:
            raise RuntimeError('Real BUILD differs from active pair')
        if (register('voice_capture', 0) != 0x56535431 or register('voice_capture', 0x24) != 0x10001
                or register('voice_capture', 0x28) != 0 or register('voice_capture', 0x2C) != 0):
            raise RuntimeError('Audio source identity or stopped state unconfirmed')
        for name in sorted({name for name, _ in _dma_inventory(expected_build)}):
            parameters = {node.get('NAME'): node.get('VALUE') for node in modules[name].iter('PARAMETER')}
            for direction, control, status in (('MM2S', 0, 4), ('S2MM', 0x30, 0x34)):
                if parameters.get('C_INCLUDE_' + direction) != '1':
                    continue
                control_value, status_value = register(name, control), register(name, status)
                if control_value & 5 or not status_value & 1:
                    raise RuntimeError(f'DMA stop unconfirmed: {name}/{direction}')
                report['dma'].append({'instance': name, 'direction': direction,
                                      'control': control_value, 'status': status_value})
        inventory = {(entry['instance'], entry['direction']) for entry in report['dma']}
        if inventory != _dma_inventory(expected_build) or len(report['dma']) != len(inventory):
            raise RuntimeError('Enabled DMA directions differ from this audited BUILD')
        if expected_build == 0xC0060B00:
            from board.pynq_z2.dual_mask_packet import read_capture_epoch_status
            if addresses.get('capture_control') != 0x413F0000 or addresses.get('capture_status') != 0x41410000:
                raise RuntimeError('B00 capture control/status address mismatch')
            capture = read_capture_epoch_status(lambda offset: register('capture_status', offset))
            granted, released = register('capture_control', 0x5C), register('capture_control', 0x60)
            if (not capture.ready or not capture.sealed or capture.faults or capture.epoch == 0
                    or register('capture_control', 0) != 0x31435456
                    or register('capture_control', 4) != 0x20000
                    or register('capture_control', 8) != 5 or register('capture_control', 0x4C) != 4
                    or granted != released or released == 0):
                raise RuntimeError('Prior B00 epoch not sealed, error-free and owner-drained')
            report.update(source_quiescent=True, prior_epoch=capture.epoch, released_frames=released)
    if state_path.read_bytes() != state_before:
        raise RuntimeError('Active PYNQ identity changed during audit')
    report.update(owner_identity_gate_passed=True, monotonic_ns=time.monotonic_ns())
    return report


@contextmanager
def locked_idle_board(c6i_lock=None, *, cold_boot_id=None, vision_only_epoch=None):
    import fcntl
    with ExitStack() as resources:
        mode = 'a+b' if cold_boot_id is not None else 'rb'
        owner = c6i_lock if c6i_lock is not None else resources.enter_context(OWNER_LOCK.open(mode))
        audio = resources.enter_context(AUDIO_LOCK.open(mode))
        for stream, path in ((owner, OWNER_LOCK), (audio, AUDIO_LOCK)):
            fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            held, current = os.fstat(stream.fileno()), path.stat()
            if (held.st_dev, held.st_ino) != (current.st_dev, current.st_ino):
                raise RuntimeError('Owner lock inode changed')
        audio.seek(0)
        journal_bytes = audio.read()
        if cold_boot_id is not None:
            if journal_bytes:
                raise RuntimeError('Cold boot requires empty initial audio journal')
            report = _audit_cold_boot(cold_boot_id)
        elif vision_only_epoch is not None:
            if journal_bytes or type(vision_only_epoch) is not int or not 0 < vision_only_epoch <= 0xFFFFFFFF:
                raise RuntimeError('Vision-only stop requires unused empty audio journal and owned epoch')
            report = _audit_idle_hardware()
            if (report.get('build_id') != '0xc0060b00' or report.get('prior_epoch') != vision_only_epoch
                    or report.get('source_quiescent') is not True):
                raise RuntimeError('Vision-only stop requires this sealed canonical B00 epoch')
            report['audio_journal_unused'] = True
        else:
            journal = json.loads(journal_bytes)
            if journal.get('state') != 'CLEAN':
                raise RuntimeError('Audio journal not CLEAN; retain prior owner')
            report = _audit_idle_hardware()
        report['audio_journal_sha256'] = hashlib.sha256(journal_bytes).hexdigest()
        yield report
        audio.seek(0)
        if audio.read() != journal_bytes:
            raise RuntimeError('Audio journal changed under download locks')


def validate_preflight(expected: dict, current: dict) -> None:
    age = current['monotonic_ns'] - expected.get('monotonic_ns', -1)
    if (expected.get('owner_identity_gate_passed') is not True or expected.get('hardware_operations') is not False
            or not 0 <= age <= 60_000_000_000
            or any(expected.get(key) != current.get(key) for key in
                   ('boot_id', 'active_pair', 'build_id', 'audio_journal_sha256', 'dma', 'cold_boot', 'services'))):
        raise RuntimeError('Current, matching owner preflight within 60 seconds required')


class PlGuardedOverlaySession(C6IOverlaySession):
    def __init__(self, *args, owner_preflight: Path, overlay_factory, **options):
        self._owner_preflight = Path(owner_preflight)
        self._guarded_loader = overlay_factory
        self._download_gate_pending = False
        self._download_context = None
        self.download_receipt = None
        super().__init__(*args, overlay_factory=self._guarded_load, **options)

    def _guarded_load(self, bitstream, *, download):
        if download is not True or self._lock_file is None:
            raise RuntimeError('Exclusive C6I owner required before guarded download')
        expected = json.loads(self._owner_preflight.read_text(encoding='utf-8'))
        context = (locked_idle_board(c6i_lock=self._lock_file, cold_boot_id=expected['boot_id'])
               if expected.get('cold_boot') is True else locked_idle_board(c6i_lock=self._lock_file))
        current = context.__enter__()
        try:
            validate_preflight(expected, current)
            self.download_receipt = current
            self._download_context = context
            self._download_gate_pending = True
            if current.get('cold_boot') is True:
                marker = Path('/run/lock') / ('voice-view-cold-' + current['boot_id'] + '.attempt')
                with marker.open('x', encoding='ascii') as stream:
                    json.dump(current, stream)
                    stream.flush()
                    os.fsync(stream.fileno())
            return self._guarded_loader(bitstream, download=True)
        except BaseException:
            if not self._download_gate_pending:
                context.__exit__(*sys.exc_info())
            raise

    def open(self):
        if self._download_gate_pending:
            raise RuntimeError('B00 download cannot be retried; retain prior owner')
        result = super().open()
        if self._download_context is not None:
            self._download_context.__exit__(None, None, None)
            self._download_context = None
        self._download_gate_pending = False
        return result

    def _close_unborrowed(self):
        if self._download_gate_pending:
            raise RuntimeError('B00 download/BUILD unconfirmed; retain exclusive owner')
        super()._close_unborrowed()