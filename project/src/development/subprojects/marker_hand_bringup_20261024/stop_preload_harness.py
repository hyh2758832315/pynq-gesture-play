"""Stop only this chat's slow pre-hardware diagnostic wrapper.
Run via remote.py; output a11. Next verify exit then use bounded tracing.
"""
import json
import os
from pathlib import Path
import signal
import time
root=Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
log=root/'var/marker-hand-20261024-a01'
entry=json.loads((log/'service-start.json').read_text())
assert entry['boot_id']==Path('/proc/sys/kernel/random/boot_id').read_text().strip()=='15a410e0-d375-45ef-8d01-7b9a02e21a8e'
assert entry['pid']==1103 and entry['start_ticks']=='222286'
proc=Path('/proc')/str(entry['pid'])
assert proc.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==entry['start_ticks']
assert proc.joinpath('cmdline').read_bytes().split(bytes([0]))[:-1]==[x.encode() for x in entry['command']]
assert not (log/'startup-trace.jsonl').exists(), 'initialization entered; re-evaluate normal cleanup'
assert not Path('/var/lock/voice-view-c6i-volume-owner.json').exists()
for p in Path('/proc').glob('[0-9]*/maps'):
    try:
        maps=p.read_text()
        assert '/dev/mem' not in maps and '/dev/uio' not in maps,str(p)
    except (FileNotFoundError,ProcessLookupError):pass
with (log/'preload-sigterm.attempt').open('x') as out:
    json.dump(dict(identity=entry,status=proc.joinpath('status').read_text(),stat=proc.joinpath('stat').read_text(),hardware_owners=[]),out)
    out.flush();os.fsync(out.fileno())
os.kill(entry['pid'],signal.SIGTERM)
end=time.monotonic()+10
while not (log/'service-exit.json').exists():
    assert time.monotonic()<end,'retain and inspect; no repeated signal'
    time.sleep(.1)
print(json.dumps(dict(exit=json.loads((log/'service-exit.json').read_text()),hardware_access=False)),flush=True)
