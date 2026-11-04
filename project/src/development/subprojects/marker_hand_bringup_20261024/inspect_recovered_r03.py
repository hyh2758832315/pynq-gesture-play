"""Read-only recovery of R21 OSD failure evidence after the next board boot.

Run: .venv/Scripts/python.exe -I -B subprojects/marker_hand_bringup_20261024/remote.py subprojects/marker_hand_bringup_20261024/inspect_recovered_r03.py --output build/marker-hand-board-20261024/UNIQUE.json
Output: boot inventory, prior-boot kernel tail, diagnostic files and services.
Next: correlate the final fsynced startup phase with kernel and volume evidence.
"""
import json
from pathlib import Path
import subprocess

ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
LOG = ROOT / 'var/marker-hand-20261024-a03'
OLD_BOOT = '92f1a779-d821-46cd-a8d1-69a2a26cbc1f'

def command(*args, timeout=5):
    try:
        result = subprocess.run(args, capture_output=True, text=True, timeout=timeout)
        return {'returncode': result.returncode, 'stdout': result.stdout[-12000:],
                'stderr': result.stderr[-1200:]}
    except subprocess.TimeoutExpired:
        return {'timeout_seconds': timeout}

diagnostics = {}
directory = LOG / 'volume-diagnostic'
if directory.is_dir():
    for path in sorted(directory.rglob('*')):
        if not path.is_file():
            continue
        relative = str(path.relative_to(directory))
        size = path.stat().st_size
        item = {'bytes': size}
        if size <= 100000 and path.suffix.lower() in ('.json', '.log', '.jsonl', '.txt'):
            item['tail'] = path.read_text(errors='replace')[-1500:]
        diagnostics[relative] = item

print(json.dumps({
    'boot_id': Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
    'old_boot': OLD_BOOT,
    'journal_boots': command('journalctl', '--list-boots', '--no-pager', timeout=3),
    'old_kernel': command('journalctl', '-b', OLD_BOOT, '-k', '--no-pager', '-o', 'short-monotonic', timeout=5),
    'old_errors': command('journalctl', '-b', OLD_BOOT, '-p', 'err', '--no-pager', '-o', 'short-monotonic', timeout=5),
    'diagnostics': diagnostics,
    'services': {name: command('systemctl', 'show', name, '-p', 'ActiveState', '-p', 'MainPID', '-p', 'Result')
                 for name in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service')},
    'locks': {name: (Path(name).read_text() if Path(name).exists() else None)
              for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock',
                           '/var/lock/voice-view-c6i-volume-owner.json')},
}, ensure_ascii=False), flush=True)
