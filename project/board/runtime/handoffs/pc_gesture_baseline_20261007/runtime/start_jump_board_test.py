"""Explicit open-to-fist jump opt-in for the SHA-frozen r8 deployment.

Does not edit the deployment, change the bitstream, or inject game inputs.
"""
import argparse
import functools
import hashlib
import json
import os
import runpy
import shutil
import socket
import sys
import tempfile
import time
from pathlib import Path

R8_ROOT = Path('/home/xilinx/voice-view-game/c6i-vision-fusion-20261006-boarddeps/c6i-vision-board-test-boarddeps-r8-20261006')
CONTROL_NOTICE = 'JUMP_OPT_IN=HEURISTIC_OPEN_TO_FIST; horizontal unchanged; vertical disabled'
IDENTITY = {
    'deployment_manifest.json': '42F6D092DDA06731DF76FB914454D844E2B1F2CEAD5F397AFB50F25FD24E25D6',
    'start_board_test.py': 'C9928A44FCC320CB1EFAF202596FD8AC3ED5A6DAA8F0FA5C58967C36010CB23E',
    'python/pynq_multimodal_game/agent/cli.py': 'C340CED9D88B7F618F149B2FEC26DE27E7A84C5F0768DFD58F721205DCACA0A7',
}


def verify(root):
    root = root.resolve(strict=True)
    for name, expected in IDENTITY.items():
        if hashlib.sha256((root / name).read_bytes()).hexdigest().upper() != expected:
            raise ValueError('Not the frozen r8 deployment: ' + name)
    manifest = json.loads((root / 'deployment_manifest.json').read_text(encoding='utf-8'))
    for name, expected in manifest['sha256'].items():
        path = (root / name).resolve(strict=True)
        if not path.is_relative_to(root):
            raise ValueError('Deployment path escapes root: ' + name)
        if hashlib.sha256(path.read_bytes()).hexdigest().upper() != expected.upper():
            raise ValueError('Deployment SHA mismatch: ' + name)
    return root


def configure_provider(cli):
    # Default library behavior stays OFF. Only this explicit process opts in.
    cli.VisionInputProvider = functools.partial(cli.VisionInputProvider, fist_enabled=True)


def persistent_pair(root, pair_dir):
    pair_dir.mkdir(parents=True, exist_ok=True)
    if pair_dir.is_symlink() or pair_dir.resolve().parent != Path(__file__).resolve().parent:
        raise ValueError('Unsafe runtime pair directory')
    if list(pair_dir.glob('*.xsa')):
        raise ValueError('Runtime pair must not have an adjacent XSA')
    for suffix in ('.bit', '.hwh'):
        source = root / 'overlay' / ('c6v_candidate' + suffix)
        dest = pair_dir / source.name
        if dest.is_symlink():
            raise ValueError('Runtime file must not be a symlink')
        if not dest.exists():
            with dest.open('xb') as output:
                output.write(source.read_bytes())
        if hashlib.sha256(dest.read_bytes()).digest() != hashlib.sha256(source.read_bytes()).digest():
            raise ValueError('Persistent runtime pair SHA mismatch: ' + dest.name)
    return pair_dir / 'c6v_candidate.bit'


def repaired_state(raw, replacement):
    state = json.loads(raw)
    old_name = state['bitfile_name']
    old = Path(old_name)
    if old.is_file():
        return None
    if (old.parent.parent != Path('/tmp') or
            not old.parent.name.startswith('voice-view-c6i-vision-') or
            old.name != 'c6v_candidate.bit'):
        raise ValueError('Refusing to repair an unrelated global PL state')
    if hashlib.sha1(replacement.read_bytes()).hexdigest() != state.get('bitfile_hash'):
        raise ValueError('Recorded PL hash differs from the verified r8 bitstream')
    state['bitfile_name'] = str(replacement.resolve())
    if state.get('active_name') == old_name:
        state['active_name'] = str(replacement.resolve())
    return json.dumps(state, indent=2).encode('utf-8')


def repair_global_state(root, pair_dir):
    if sys.platform != 'linux' or os.geteuid() != 0:
        raise RuntimeError('State repair requires root on the PYNQ board')
    import fcntl
    from pynq.pl_server import global_state
    with open('/var/lock/voice-view-c6i.lock', 'a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        with socket.socket() as probe:
            probe.settimeout(1)
            if probe.connect_ex(('192.168.2.99', 8765)) == 0:
                raise RuntimeError('Agent still listening; stop it before repairing state')
        replacement = persistent_pair(root, pair_dir)
        state_path = Path(global_state._get_state_path())
        if state_path.is_symlink():
            raise ValueError('Refusing symlinked global state')
        raw = state_path.read_bytes()
        updated = repaired_state(raw, replacement)
        if updated is None:
            print('GLOBAL_STATE_ALREADY_READABLE; no state changes', flush=True)
            return
        backup = pair_dir.parent / ('global_pl_state_backup_' + str(time.time_ns()) + '.json')
        with backup.open('xb') as output:
            output.write(raw)
            output.flush()
            os.fsync(output.fileno())
        print('STATE_BACKUP=' + str(backup), flush=True)
        fd, staging = tempfile.mkstemp(prefix='.state-repair-', dir=state_path.parent)
        try:
            with os.fdopen(fd, 'wb') as output:
                output.write(updated)
                output.flush()
                os.fsync(output.fileno())
            os.chmod(staging, state_path.stat().st_mode & 0o777)
            if state_path.read_bytes() != raw:
                raise RuntimeError('Global state changed concurrently; refusing replacement')
            os.replace(staging, state_path)
        finally:
            if os.path.exists(staging):
                os.unlink(staging)
        loaded = global_state.load_global_state()
        if loaded.bitfile_hash != json.loads(raw)['bitfile_hash']:
            raise RuntimeError('Repaired global state hash verification failed; retain backup')
        print('GLOBAL_STATE_REPAIR_PASS; shutdown_ips/psddr preserved; no hardware download', flush=True)


def configure_persistent_overlay(cli, root, pair_dir):
    def load(bitstream, *, download):
        from pynq import Overlay
        if Path(bitstream).resolve() != (root / 'overlay/c6v_candidate.bit').resolve():
            raise ValueError('Unexpected overlay source')
        bit = persistent_pair(root, pair_dir)
        overlay = Overlay(str(bit), download=False)
        cli._restore_shared_vision_interrupts(overlay, bit.with_suffix('.hwh'))
        if download:
            overlay.download()
        return overlay
    cli._load_shared_vision_overlay = load


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--deployment', type=Path, default=R8_ROOT)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument('--check-only', action='store_true')
    mode.add_argument('--repair-state', action='store_true')
    args = parser.parse_args(argv)
    root = verify(args.deployment)
    pair_dir = Path(__file__).resolve().parent / 'persistent_pair_C0060800'
    if args.repair_state:
        repair_global_state(root, pair_dir)
        return 0
    sys.path.insert(0, str(root / 'python'))
    from pynq_multimodal_game.agent import cli
    if not Path(cli.__file__).resolve().is_relative_to(root / 'python'):
        raise RuntimeError('Unexpected Agent module source')
    configure_provider(cli)
    configure_persistent_overlay(cli, root, pair_dir)
    print('OVERLAY_PAIR=PERSISTENT; original r8 files unchanged', flush=True)
    print(CONTROL_NOTICE, flush=True)
    print('JUMP_RULE=stable open then stable fist; one-shot; freshness/pause/run gates retained', flush=True)
    entry = runpy.run_path(str(root / 'start_board_test.py'), run_name='jump_r8_entry')
    original_argv = sys.argv
    try:
        sys.argv = [str(root / 'start_board_test.py')] + (['--check-only'] if args.check_only else [])
        return entry['main']()
    finally:
        sys.argv = original_argv


if __name__ == '__main__':
    raise SystemExit(main())
