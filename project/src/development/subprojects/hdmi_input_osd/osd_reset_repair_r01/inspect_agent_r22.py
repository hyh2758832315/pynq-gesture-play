"""Read-only R22 Agent/OSD process and phase inspection; run via remote.py.

Output: current boot, startup phases, stdout/stderr, process owners and ports.
Next: classify actual startup result before any hardware or cleanup action.
"""
import json
from pathlib import Path
import subprocess

ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024')
LOG = ROOT / 'var/osd-reset-20261024-a02'
boot = Path('/proc/sys/kernel/random/boot_id').read_text().strip()
files = {name: (LOG / name).read_text(errors='replace')[-24000:] if (LOG / name).exists() else None
         for name in ('service-start.json', 'service-exit.json', 'load.attempt',
                      'stdout.log', 'stderr.log', 'startup-phases.jsonl')}
owners = []
for proc in Path('/proc').glob('[0-9]*'):
    try:
        maps = proc.joinpath('maps').read_text(errors='replace')
        if '/dev/mem' in maps or '/dev/uio' in maps:
            owners.append(dict(pid=int(proc.name),
                               start_ticks=proc.joinpath('stat').read_text().rsplit(')', 1)[1].split()[19],
                               command=proc.joinpath('cmdline').read_bytes().replace(b'\0', b' ').decode(errors='replace'),
                               wchan=proc.joinpath('wchan').read_text()))
    except (FileNotFoundError, ProcessLookupError, PermissionError):
        pass
ports = subprocess.run(['ss', '-lntp'], capture_output=True, text=True, check=True).stdout
kernel = subprocess.run(['dmesg', '--color=never'], capture_output=True, text=True, check=True).stdout
print(json.dumps(dict(boot_id=boot, files=files, owners=owners,
                      ports=ports, kernel_tail=kernel[-7000:])), flush=True)
