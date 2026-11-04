"""Read-only recovery of fsynced R22 OSD transaction phases after power cycle.

Run via remote_r22.py once the board has a new boot ID.
Output: exact last before/after MMIO transaction and current boot/owners.
Next: reproduce that transaction in XSim before another hardware candidate.
"""
import json
from pathlib import Path

OLD_BOOT = '1b5b27d9-a744-4566-a20d-62bc24416136'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024')
LOG = ROOT / 'var/osd-reset-20261024-b01'
boot = Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot != OLD_BOOT, 'Expected a physical reboot since the transaction probe'
phases = (LOG / 'osd-transactions.jsonl').read_text(errors='replace')
records = [json.loads(line) for line in phases.splitlines() if line.strip()]
assert records and all(item['boot_id'] == OLD_BOOT for item in records)
attempt = json.loads((LOG / 'osd-transactions.attempt').read_text())
assert attempt['boot_id'] == OLD_BOOT
owners = []
for proc in Path('/proc').glob('[0-9]*'):
    try:
        maps = proc.joinpath('maps').read_text(errors='replace')
        if '/dev/mem' in maps or '/dev/uio' in maps:
            owners.append(dict(pid=int(proc.name),
                               command=proc.joinpath('cmdline').read_bytes().replace(b'\0', b' ').decode(errors='replace')[-500:]))
    except (FileNotFoundError, ProcessLookupError, PermissionError):
        pass
print(json.dumps(dict(verdict='OSD_RESET_TRANSACTION_LOG_RECOVERED',
                      boot_id=boot, prior_boot_id=OLD_BOOT, count=len(records),
                      last=records[-1], phases=records, owners=owners)), flush=True)
