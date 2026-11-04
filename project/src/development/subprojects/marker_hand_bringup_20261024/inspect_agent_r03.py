"""Read-only post-start check; run with remote.py, output unique receipt.
Next: READY permits protocol tests; preserve any failure before recovery.
"""
import json
from pathlib import Path
import subprocess
ROOT=Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
LOG=ROOT/'var/marker-hand-20261024-a03'
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
files={name:(LOG/name).read_text()[-18000:] if (LOG/name).exists() else None for name in ('service-start.json','service-exit.json','stdout.log','stderr.log','startup-phases.jsonl','load-phases.jsonl')}
owners=[]
for p in Path('/proc').glob('[0-9]*'):
    try:
        maps=p.joinpath('maps').read_text()
        if '/dev/mem' in maps or '/dev/uio' in maps:
            owners.append(dict(pid=int(p.name),start_ticks=p.joinpath('stat').read_text().rsplit(')',1)[1].split()[19],command=p.joinpath('cmdline').read_bytes().replace(bytes([0]),b' ').decode(),wchan=p.joinpath('wchan').read_text()))
    except (FileNotFoundError,ProcessLookupError,PermissionError):pass
print(json.dumps(dict(boot_id=boot,files=files,owners=owners,ports=subprocess.run(['ss','-lntp'],capture_output=True,text=True,check=True).stdout,
 kernel_tail=subprocess.run(['dmesg','--color=never'],capture_output=True,text=True,check=True).stdout[-7000:])),flush=True)
