from __future__ import annotations

import argparse
from contextlib import contextmanager
import faulthandler
import hashlib
import importlib
import json
import os
from pathlib import Path, PurePosixPath
import signal
import subprocess
import sys
import threading
import time
import traceback
import uuid


_RETAINED = []


def check_deployment(root: Path) -> dict:
    root = root.resolve(strict=True)
    manifest = json.loads((root / 'deployment_manifest.json').read_text(encoding='utf-8'))
    required = {'schema': 'pl-voice-fusion-board-deployment-v1', 'build_id': '0xC0060B00',
                'runtime_registered': False, 'board_pending': True, 'release_ready': False,
                'live_authorization_required': True, 'nominal_packets': 900, 'nominal_samples': 864000}
    if type(manifest) is not dict or any(type(manifest.get(key)) is not type(value) or manifest[key] != value
                                         for key, value in required.items()):
        raise ValueError('Strict B00 deployment gates required')
    identities = manifest.get('sha256')
    if type(identities) is not dict or not identities:
        raise ValueError('Complete B00 deployment identities required')
    for path in root.rglob('*'):
        if path.is_symlink():
            raise ValueError('B00 deployment symlinks forbidden')
        relative = path.relative_to(root).as_posix()
        if (path.is_file() and relative not in identities and relative != 'deployment_manifest.json'
                and not relative.startswith('var/')):
            raise ValueError(f'Unlisted B00 deployment file: {relative}')
    for name, digest in identities.items():
        relative = PurePosixPath(name)
        immutable_native = {'var/native_transport.json', 'var/voice_native_transport.so',
                    'var/cpu_features.json', 'var/voice_cpu_features.so'}
        if (relative.is_absolute() or '..' in relative.parts or '\\' in name
            or relative.as_posix() != name
            or (name.startswith('var/') and name not in immutable_native)):
            raise ValueError('Unsafe B00 deployment identity path')
        path = (root / name).resolve(strict=True)
        if not path.is_relative_to(root) or hashlib.sha256(path.read_bytes()).hexdigest() != digest:
            raise ValueError(f'B00 deployment SHA mismatch: {name}')
    sys.path.insert(0, str(root / 'python'))
    package = importlib.import_module('pynq_multimodal_game')
    if Path(package.__file__).resolve().parent != root / 'python/pynq_multimodal_game':
        raise ImportError('B00 check requires its isolated software snapshot')
    from pynq_multimodal_game.agent.vision_pl_fusion import verify_pl_candidate
    from pynq_multimodal_game.agent.voice_backend import verify_driver_sources
    from pynq_multimodal_game.voice_service import verify_frozen_source
    from pynq_multimodal_game.game_package import validate_game_package
    verify_pl_candidate(root / 'overlay/c6v_b00_candidate.bit', root / 'overlay/receipt.json')
    verify_driver_sources(root / 'audio_driver')
    verify_frozen_source()
    if type(manifest.get('games')) is not dict or not manifest['games']:
        raise ValueError('Asserted B00 games required')
    for game_id, description in manifest['games'].items():
        path = (root / description['file']).resolve(strict=True)
        if not path.is_relative_to(root):
            raise ValueError('B00 game escapes deployment')
        game = validate_game_package(path)
        if (game.sha256 != description['sha256'] or game.manifest.game_id != game_id
                or game.manifest.target_build_id != 0xC0060B00
                or type(description.get('assertions')) is not int or description['assertions'] < 1):
            raise ValueError('B00 asserted game identity mismatch')
    return manifest


def cpu_snapshot(proc: Path = Path('/proc'), *, pid: int | None = None, ticks_per_second=None) -> dict:
    pid = os.getpid() if pid is None else pid
    processes = {}
    for path in proc.glob('[0-9]*/stat'):
        try:
            fields = path.read_text().rsplit(')', 1)[1].split()
        except FileNotFoundError:
            continue
        processes[int(path.parent.name)] = {'parent': int(fields[1]), 'start': int(fields[19]),
            'self_ticks': int(fields[11]) + int(fields[12]),
            'waited_children_ticks': int(fields[13]) + int(fields[14])}
    if pid not in processes:
        raise RuntimeError('CPU owner PID disappeared')
    family = {pid}
    while True:
        expanded = family | {child for child, values in processes.items() if values['parent'] in family}
        if expanded == family:
            break
        family = expanded
    system = proc.joinpath('stat').read_text().splitlines()[0].split()
    if system[0] != 'cpu' or len(system) < 9:
        raise ValueError('Complete system CPU counters required')
    counters = [int(value) for value in system[1:9]]
    return {'owner_pid': pid, 'owner_start': processes[pid]['start'],
            'ticks_per_second': os.sysconf('SC_CLK_TCK') if ticks_per_second is None else ticks_per_second,
            'processes': {str(child): processes[child] for child in sorted(family)},
            'family_ticks': sum(processes[child]['self_ticks'] + processes[child]['waited_children_ticks']
                                for child in family),
            'system_counters': dict(zip(('user', 'nice', 'system', 'idle', 'iowait', 'irq', 'softirq', 'steal'), counters)),
            'system_total': sum(counters), 'system_idle': counters[3] + counters[4]}


def cpu_usage(before: dict, after: dict, wall_seconds: float, *, cores: int) -> dict:
    if (wall_seconds <= 0 or type(cores) is not int or cores < 1
            or (before['owner_pid'], before['owner_start'], before['ticks_per_second']) !=
               (after['owner_pid'], after['owner_start'], after['ticks_per_second'])):
        raise ValueError('Stable CPU owner, clock and positive interval required')
    ticks = after['family_ticks'] - before['family_ticks']
    total = after['system_total'] - before['system_total']
    idle = after['system_idle'] - before['system_idle']
    if ticks < 0 or total <= 0 or idle < 0 or idle > total:
        raise ValueError('CPU counters regressed or interval incomplete')
    percent = 100 * ticks / before['ticks_per_second'] / wall_seconds
    return {'wall_seconds': wall_seconds, 'family_cpu_seconds': ticks / before['ticks_per_second'],
            'family_percent_one_core_100': percent, 'family_percent_capacity': percent / cores,
            'system_busy_percent': 100 * (total - idle) / total, 'available_cores': cores,
            'includes_live_descendants_and_waited_children': True}


def startup_stage(directory: Path, stage: str) -> None:
    with (directory / 'startup-stages.jsonl').open('a', encoding='utf-8') as stream:
        stream.write(json.dumps({'stage': stage, 'monotonic_ns': time.monotonic_ns()}) + '\n')
        stream.flush()
        os.fsync(stream.fileno())


@contextmanager
def startup_python_traces(directory: Path):
    with (directory / 'startup-python-stacks.log').open('xb') as stream:
        deadline = threading.Timer(180, faulthandler.cancel_dump_traceback_later)
        deadline.daemon = True
        try:
            faulthandler.dump_traceback_later(2, repeat=True, file=stream)
            deadline.start()
            yield
        finally:
            deadline.cancel()
            faulthandler.cancel_dump_traceback_later()


def monitor_startup(directory: Path, pid: int, *, proc: Path = Path('/proc')) -> None:
    started = time.monotonic()
    previous = None
    stack_offset = 0
    preview_offsets = {}
    cores = len(os.sched_getaffinity(0))
    with (directory / 'startup-resources.jsonl').open('x', encoding='utf-8') as stream:
        while True:
            now = time.monotonic()
            record = {'monotonic_ns': time.monotonic_ns(), 'owner_pid': pid,
                      'monitor_pid': os.getpid(), 'hardware_operations': False}
            try:
                record['cpu_raw'] = cpu_snapshot(proc, pid=pid)
                memory = {}
                for line in (proc / 'meminfo').read_text().splitlines():
                    key, value = line.split(':', 1)
                    if key in ('MemTotal', 'MemAvailable', 'MemFree', 'SwapTotal', 'SwapFree'):
                        memory[key] = int(value.split()[0])
                record['memory_kib'] = memory
                for name, relative in (('loadavg', 'loadavg'), ('cpu_pressure', 'pressure/cpu'),
                                       ('memory_pressure', 'pressure/memory'), ('io_pressure', 'pressure/io')):
                    path = proc / relative
                    record[name] = path.read_text().strip() if path.exists() else None
                stages = directory / 'startup-stages.jsonl'
                complete = [line for line in stages.read_text().splitlines(keepends=True)
                            if line.endswith('\n')] if stages.exists() else []
                record['stage'] = json.loads(complete[-1]) if complete else None
                stacks = directory / 'startup-python-stacks.log'
                if stacks.exists():
                    with stacks.open('rb') as reader:
                        reader.seek(stack_offset)
                        fragment = reader.read()
                    if fragment:
                        record['python_stack_fragment'] = {
                            'byte_offset': stack_offset, 'byte_count': len(fragment),
                            'text': fragment.decode('utf-8', errors='backslashreplace')}
                        stack_offset += len(fragment)
                preview_fragments = []
                for path in sorted((directory / 'vision').glob('*/preview-startup*')):
                    key = path.relative_to(directory).as_posix()
                    offset = preview_offsets.get(key, 0)
                    with path.open('rb') as reader:
                        reader.seek(offset)
                        fragment = reader.read()
                    if fragment:
                        preview_fragments.append(dict(path=key, byte_offset=offset, byte_count=len(fragment),
                            text=fragment.decode('utf-8', errors='backslashreplace')))
                        preview_offsets[key] = offset + len(fragment)
                if preview_fragments:
                    record['preview_startup_fragments'] = preview_fragments
                if previous is not None:
                    record['cpu'] = cpu_usage(previous['cpu_raw'], record['cpu_raw'],
                                              now - previous['at'], cores=cores)
            except (OSError, ValueError, RuntimeError) as error:
                record['first_error'] = repr(error)
            stream.write(json.dumps(record) + '\n')
            stream.flush()
            os.fsync(stream.fileno())
            if 'first_error' in record:
                raise RuntimeError('Startup resource monitor failed: ' + record['first_error'])
            if previous is None:
                pending = directory / 'startup-monitor-ready.pending'
                with pending.open('x', encoding='utf-8') as ready:
                    json.dump({'owner_pid': pid, 'monitor_pid': os.getpid()}, ready)
                    ready.flush()
                    os.fsync(ready.fileno())
                os.link(pending, directory / 'startup-monitor-ready.json')
                pending.unlink()
            previous = {'cpu_raw': record['cpu_raw'], 'at': now}
            if (directory / 'startup-monitor.stop').exists() or now - started >= 180:
                break
            threading.Event().wait(.5)


def start_startup_monitor(directory: Path):
    with (directory / 'startup-monitor.log').open('x', encoding='utf-8') as log:
        process = subprocess.Popen([sys.executable, '-B', str(Path(__file__).resolve()), '--startup-monitor',
                                    '--monitor-pid', str(os.getpid()), '--monitor-directory', str(directory)],
                                   stdout=log, stderr=subprocess.STDOUT)
    deadline = time.monotonic() + 5
    ready = directory / 'startup-monitor-ready.json'
    while not ready.exists():
        if process.poll() is not None or time.monotonic() >= deadline:
            raise RuntimeError('Startup monitor readiness unconfirmed; no hardware load permitted')
        try:
            process.wait(timeout=.02)
        except subprocess.TimeoutExpired:
            pass
    receipt = json.loads(ready.read_text())
    if receipt != {'owner_pid': os.getpid(), 'monitor_pid': process.pid} or process.poll() is not None:
        raise RuntimeError('Startup monitor identity changed; no hardware load permitted')
    return process


def wait_for_vision_ready(backend, timeout=30):
    vision = backend._vision_supervisor.status()
    deadline = None
    while vision['state'] == 'STARTING' or (vision['state'] == 'RUNNING' and vision['frame_id'] < 1):
        if deadline is None:
            deadline = time.monotonic() + timeout
        if time.monotonic() >= deadline:
            raise RuntimeError('Vision RUNNING and first frame unconfirmed within startup budget')
        threading.Event().wait(.02)
        vision = backend._vision_supervisor.status()
    if vision['state'] != 'RUNNING' or vision.get('last_error'):
        raise RuntimeError('Dual-mask vision fault: ' + str(vision))
    return vision


def observe_vision_gpu(backend, duration):
    if not 0 < duration <= 60:
        raise ValueError('Vision/GPU diagnostic duration must be in (0,60] seconds')
    started = time.monotonic()
    before = cpu_snapshot()
    initial = backend._vision_supervisor.status()['frame_id']
    initial_presented = backend._game.input_consumptions['presented_frames']
    samples = []
    previous, previous_at = before, started
    cores = len(os.sched_getaffinity(0))
    print('B00_VISION_GPU_ONLY_READY no_audio_service no_pcm_worker', flush=True)
    while True:
        vision = backend._vision_supervisor.status()
        if vision['state'] != 'RUNNING' or vision.get('last_error') or backend._game.last_error:
            raise RuntimeError('Vision/GPU diagnostic fault: ' + str(vision))
        now = time.monotonic()
        if now - previous_at >= .5:
            current = cpu_snapshot()
            samples.append(cpu_usage(previous, current, now - previous_at, cores=cores))
            previous, previous_at = current, now
        if now - started >= duration:
            break
        threading.Event().wait(.02)
    after = cpu_snapshot()
    presented = backend._game.input_consumptions['presented_frames']
    if vision['frame_id'] <= initial or presented <= initial_presented:
        raise RuntimeError('Continuous real vision and completed GPU Scenes required')
    return dict(diagnostic_only=True, audio_service_created=False, pcm_worker_created=False,
        three_way_observed=False, capture_pass=False, vision_gpu_pass=True,
        initial_vision_frame=initial, vision_before_stop=dict(vision), game_presented_frames=presented,
        initial_presented_frames=initial_presented, cpu_samples=samples,
        cpu=cpu_usage(before, after, now - started, cores=cores), cpu_raw=dict(before=before, after=after))


def run_fusion(root: Path, manifest: dict, arguments, directory: Path) -> dict:
    from pynq_multimodal_game.agent import cli
    from pynq_multimodal_game.agent.vision_pl_fusion import create_pl_backend
    from pynq_multimodal_game.library import LibraryKind
    from board.pynq_z2.scripts.run_voice_fusion_acceptance import (
        load_diagnostic_native_voice, record_runtime_snapshot)
    from board.pynq_z2.scripts.verify_vision_integration_sources import CAMERA_SHA256
    from board.pynq_z2.vision_owner_gate import locked_idle_board

    result = {'schema': 'pl-voice-fusion-live-acceptance-v1', 'build_id': '0xC0060B00',
              'board_pending': True, 'release_ready': False, 'runtime_registered': False,
              'nominal_packets': 900, 'nominal_samples': 864000,
              'max_audio_age_ns': 100_000_000, 'audio_slots': 4, 'native_spsc_capacity': 64,
              'recognition_quality': 'pending', 'hdmi_visual_acceptance': 'pending',
              'deployment_sha256': hashlib.sha256((root / 'deployment_manifest.json').read_bytes()).hexdigest()}
    session = backend = None
    vision_only = getattr(arguments, 'vision_gpu_only', False)
    try:
        startup_stage(directory, 'vision_gpu_only_begin' if vision_only else 'native_load_begin')
        native = None if vision_only else load_diagnostic_native_voice(root, manifest)
        options = cli.build_parser().parse_args([
            '--bitstream', str(root / 'overlay/c6v_b00_candidate.bit'),
            '--voice-fusion-manifest', str(root / 'overlay/receipt.json'),
            '--voice-driver-dir', str(root / 'audio_driver'), '--allow-audio-dma-reset',
            '--physical-audio-confirmed', '--vision-game-input',
            '--vision-camera-dir', str(root / 'board/pynq_z2'), '--vision-camera-sha256', CAMERA_SHA256,
            '--vision-output-dir', str(directory / 'vision'), '--library-root', str(directory / 'library')])
        options.voice_record_pcm = True
        epoch = int(directory.name.rsplit('-', 1)[1][:8], 16) or 1
        result['capture_epoch'] = epoch
        startup_stage(directory, 'backend_factory_begin')
        factory_options = dict(vision_only=True) if vision_only else {}
        session, backend = create_pl_backend(options, epoch=epoch, native_transport=native,
                             owner_preflight=arguments.owner_preflight, **factory_options)
        backend._diagnostic_startup_stage = lambda stage: startup_stage(directory, stage)
        startup_stage(directory, 'overlay_open_begin')
        session.open()
        startup_stage(directory, 'overlay_open_complete')
        result['download_gate'] = session.download_receipt
        (directory / 'after-download.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
        game = manifest['games'][arguments.game]
        backend._library.install_file(root / game['file'], item_id=arguments.game, display_name=arguments.game,
                                       kind=LibraryKind.GAME, target_build_id=0xC0060B00)
        prepare = getattr(backend, 'prepare_vision', None)
        if callable(prepare):
            startup_stage(directory, 'vision_preview_prepare_begin')
            prepare()
            startup_stage(directory, 'vision_preview_prepare_complete')
        startup_stage(directory, 'gpu_open_begin')
        backend.open()
        startup_stage(directory, 'gpu_open_complete')
        startup_stage(directory, 'vision_start_begin')
        backend.start_vision()
        startup_stage(directory, 'vision_thread_started')
        wait_for_vision_ready(backend)
        startup_stage(directory, 'vision_start_complete')
        startup_stage(directory, 'game_start_begin' if vision_only else 'game_audio_start_begin')
        backend.start_game(arguments.game)
        startup_stage(directory, 'live_ready')
        if vision_only:
            if hasattr(backend, '_voice'):
                raise RuntimeError('Vision-only backend must not own any voice service')
            result.update(observe_vision_gpu(backend, arguments.vision_gpu_seconds))
            (directory / 'before-cleanup.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
            backend.close()
            with locked_idle_board(c6i_lock=session._lock_file, vision_only_epoch=epoch) as stopped:
                result['normal_stop_gate'] = stopped
            session.close()
            result.update(cleanup_confirmed=True, status='B00_VISION_GPU_ONLY_DIAGNOSTIC_PASS')
            return result
        voice = backend._voice
        started = time.monotonic()
        before = cpu_snapshot()
        cores = len(os.sched_getaffinity(0))
        result['cpu_samples'] = []
        previous, previous_at = before, started
        print('B00_LIVE_READY GPU+audio+dual-mask single-overlay', flush=True)
        while True:
            audio, vision = voice.status(), backend._vision_supervisor.status()
            if audio.get('first_error') or audio['state'] in ('FAULT', 'RETAINED'):
                raise RuntimeError('Native audio fault: ' + str(audio))
            if vision['state'] == 'FAULT' or vision.get('last_error'):
                raise RuntimeError('Dual-mask vision fault: ' + str(vision))
            game_error = getattr(backend._game, 'last_error', None)
            if game_error:
                raise RuntimeError('GPU/game fault: ' + str(game_error))
            now = time.monotonic()
            if now - previous_at >= .5:
                current = cpu_snapshot()
                result['cpu_samples'].append(cpu_usage(previous, current, now - previous_at, cores=cores))
                previous, previous_at = current, now
            if audio['state'] == 'STOPPED':
                break
            if now - started >= 30:
                raise RuntimeError('Bounded 900-packet run did not finish within 30 seconds')
            threading.Event().wait(.02)
        ended = time.monotonic()
        after = cpu_snapshot()
        result['cpu'] = cpu_usage(before, after, ended - started, cores=cores)
        result['cpu_raw'] = {'before': before, 'after': after}
        record_runtime_snapshot(result, backend, voice, 'before_stop')
        result['audio'] = audio
        result['vision_before_stop'] = dict(vision)
        result['capture_pass'] = (audio.get('owner_released') is True and audio['packets'] == 900
                                  and audio['samples'] == 864000
                                  and audio.get('cpu', {}).get('submitted') == 900
                                  and audio.get('cpu', {}).get('received') == 900)
        result['three_way_observed'] = (vision['state'] == 'RUNNING' and vision['frame_id'] > 0
            and backend._game.input_consumptions['presented_frames'] > 0)
        (directory / 'before-cleanup.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
        backend.close()
        with locked_idle_board(c6i_lock=session._lock_file) as stopped:
            if stopped.get('prior_epoch') != epoch:
                raise RuntimeError('Normal stop epoch differs from this run')
            result['normal_stop_gate'] = stopped
        session.close()
        result['cleanup_confirmed'] = True
        pcm = voice.recorded_pcm
        if len(pcm) != 864000 * 4:
            raise RuntimeError('Recorded 900-packet PCM length mismatch')
        if pcm:
            (directory / 'capture.pcm_s32le').write_bytes(pcm)
            result['pcm'] = {'bytes': len(pcm), 'sha256': hashlib.sha256(pcm).hexdigest()}
        result['status'] = ('B00_BOUNDED_THREE_WAY_PASS' if result['capture_pass'] and result['three_way_observed']
                            else 'B00_BOUNDED_COUNTERS_FAIL')
        return result
    except BaseException as error:
        result.update(first_error=f'{type(error).__name__}: {error}', traceback=traceback.format_exc(),
                  cleanup_confirmed=result.get('cleanup_confirmed', False))
        try:
            startup_stage(directory, 'first_error')
        except OSError as stage_error:
            result['startup_stage_error'] = str(stage_error)
        record_runtime_snapshot(result, backend, None, 'first_error')
        touched = session is not None and (session.is_open or session._download_gate_pending)
        result['hardware_owner_retained'] = touched
        result['status'] = 'B00_RETAINED_NOT_PASSED' if touched else 'B00_NOT_PASSED'
        try:
            (directory / 'result.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
        except OSError as save_error:
            print(f'B00_RECEIPT_WRITE_FAILED: {save_error}', file=sys.stderr, flush=True)
        print(json.dumps(result, indent=2), flush=True)
        if touched:
            _RETAINED.append((session, backend))
            print(f'B00_RETAINED pid={os.getpid()} no cleanup/reset/reload/retry; manual inspection required', flush=True)
            signal.signal(signal.SIGINT, signal.SIG_IGN)
            signal.signal(signal.SIGTERM, signal.SIG_IGN)
            while True:
                signal.pause()
        return result


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description='Single-epoch B00 GPU/audio/dual-mask acceptance')
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument('--check-only', action='store_true')
    action.add_argument('--owner-preflight-only', action='store_true')
    action.add_argument('--live-board-test', action='store_true')
    action.add_argument('--startup-monitor', action='store_true')
    parser.add_argument('--monitor-pid', type=int)
    parser.add_argument('--monitor-directory', type=Path)
    parser.add_argument('--allow-audio-dma-reset', action='store_true')
    parser.add_argument('--physical-audio-confirmed', action='store_true')
    parser.add_argument('--owner-preflight', type=Path)
    parser.add_argument('--cold-boot-id')
    parser.add_argument('--game', default='game1-voice-s2')
    parser.add_argument('--vision-gpu-only', action='store_true')
    parser.add_argument('--vision-gpu-seconds', type=float, default=20.)
    arguments = parser.parse_args(argv)
    root = Path(__file__).resolve().parents[3]
    sys.path.insert(0, str(root))
    if arguments.startup_monitor:
        if sys.platform != 'linux' or arguments.monitor_pid is None or arguments.monitor_pid <= 0:
            parser.error('Startup monitor requires Linux and a positive target PID')
        if arguments.monitor_directory is None:
            parser.error('Startup monitor requires its run directory')
        directory = arguments.monitor_directory.resolve(strict=True)
        if not directory.is_relative_to(root / 'var'):
            raise ValueError('Startup monitor requires this package var/ directory')
        monitor_startup(directory, arguments.monitor_pid)
        return 0
    manifest = check_deployment(root)
    if arguments.check_only:
        if 'pynq' in sys.modules:
            raise RuntimeError('Offline deployment check imported PYNQ')
        print('B00_DEPLOYMENT_CHECK_PASS hardware_operations=false pynq_imported=false board_pending=true', flush=True)
        return 0
    if (sys.platform != 'linux' or getattr(os, 'geteuid', lambda: -1)() != 0
            or sys.version_info[:2] != (3, 10)):
        raise RuntimeError('Use frozen PYNQ Linux Python 3.10 with sudo -n')
    if arguments.owner_preflight_only:
        if arguments.owner_preflight is None:
            parser.error('Owner preflight requires a new receipt path')
        destination = arguments.owner_preflight.resolve()
        if not destination.is_relative_to(root / 'var') or destination.exists():
            raise ValueError('Owner preflight requires a new receipt under package var/')
        from board.pynq_z2.vision_owner_gate import locked_idle_board
        context = (locked_idle_board(cold_boot_id=arguments.cold_boot_id)
               if arguments.cold_boot_id is not None else locked_idle_board())
        with context as report:
            pass
        report['locks_released'] = True
        if 'pynq' in sys.modules:
            raise RuntimeError('Read-only owner preflight imported PYNQ')
        destination.parent.mkdir(parents=True, exist_ok=True)
        with destination.open('x', encoding='utf-8') as stream:
            json.dump(report, stream, indent=2)
        print('B00_OWNER_PREFLIGHT_PASS hardware_operations=false pynq_imported=false', flush=True)
        return 0
    if not arguments.owner_preflight or (not arguments.vision_gpu_only and not (
            arguments.allow_audio_dma_reset and arguments.physical_audio_confirmed)):
        parser.error('Live B00 requires explicit reset/physical confirmation and current owner preflight')
    arguments.owner_preflight = arguments.owner_preflight.resolve(strict=True)
    if not arguments.owner_preflight.is_relative_to(root / 'var'):
        raise ValueError('Live B00 requires this package owner preflight')
    if arguments.game not in manifest['games']:
        parser.error('Unknown SHA-verified B00 game')
    os.environ['XILINX_XRT'] = '/usr'
    os.environ['VVG_VISION_RUNTIME_DIR'] = str(root / 'handoffs/gesture_vision_v61/runtime')
    directory = root / 'var' / ('fusion-' + uuid.uuid4().hex)
    directory.mkdir()
    monitor = start_startup_monitor(directory)
    with startup_python_traces(directory):
        result = run_fusion(root, manifest, arguments, directory)
    (directory / 'startup-monitor.stop').touch(exist_ok=False)
    try:
        monitor.wait(timeout=3)
        if monitor.returncode != 0:
            raise RuntimeError('Startup monitor returned nonzero')
    except (subprocess.TimeoutExpired, RuntimeError) as error:
        result.update(first_error='Startup monitor: ' + str(error), status='B00_STARTUP_MONITOR_NOT_PASSED')
    result['startup_monitor_pid'] = monitor.pid
    result['cpu_includes_monitor_overhead'] = True
    if result.get('first_error'):
        return 1
    with (directory / 'result.json').open('x', encoding='utf-8') as stream:
        json.dump(result, stream, indent=2)
    return 0 if result['status'] in ('B00_BOUNDED_THREE_WAY_PASS', 'B00_VISION_GPU_ONLY_DIAGNOSTIC_PASS') else 1


if __name__ == '__main__':
    raise SystemExit(main())