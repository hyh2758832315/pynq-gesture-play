"""One identity-bound normal SSH reboot, explicitly authorized by the user.
Run with remote.py. Output a16 and durable recovery-before/reboot markers.
Next: read the new boot and preserved startup logs before loading anything.
"""
import json
import os
from pathlib import Path
import subprocess

expected_boot='15a410e0-d375-45ef-8d01-7b9a02e21a8e'
root=Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
log=root/'var/marker-hand-20261024-a02'
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot==expected_boot,'Boot changed; inspect new state first'
entry=json.loads((log/'service-start.json').read_text())
assert entry['boot_id']==boot and entry['pid']==1268 and entry['start_ticks']=='252459'
processes=[]
for proc in Path('/proc').glob('[0-9]*'):
    try:
        command=proc.joinpath('cmdline').read_bytes().replace(bytes([0]),b' ').decode(errors='replace')
        maps=proc.joinpath('maps').read_text()
        if 'pynq_usb_hand' in command or 'board_buttons.py' in command:
            raise RuntimeError('Unexpected hand owner; preserve live state')
        if '/dev/mem' in maps or '/dev/uio' in maps:
            processes.append(dict(pid=int(proc.name),command=command,start_ticks=proc.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]))
    except (FileNotFoundError,ProcessLookupError,PermissionError):pass
state=dict(boot_id=boot,identity=entry,owners=processes,
           files={name:(log/name).read_text() if (log/name).exists() else None for name in ('startup-phases.jsonl','stdout.log','stderr.log','service-exit.json')},
           kernel=subprocess.run(['dmesg','--color=never'],capture_output=True,text=True,check=True).stdout[-12000:])
with (log/'recovery-before.json').open('x') as out:
    json.dump(state,out);out.flush();os.fsync(out.fileno())
print(json.dumps(state),flush=True)
with (log/'normal-reboot.attempt').open('x') as out:
    json.dump(dict(boot_id=boot,normal=True,user_authorized=True),out);out.flush();os.fsync(out.fileno())
response=subprocess.run(['systemctl','reboot'],capture_output=True,text=True,timeout=10)
print(json.dumps(dict(phase='NORMAL_REBOOT_REQUESTED',returncode=response.returncode,stdout=response.stdout,stderr=response.stderr)),flush=True)
assert response.returncode==0
