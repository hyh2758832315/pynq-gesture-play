"""Read final normal service state through Studio and the existing owner gate.

Run: .venv/Scripts/python.exe -B tools/r59_final_state.py
Output: build/studio-r59-board/final-state.json. No start, stop or test input.
Next: finalize the acceptance summary and leave the normal service running.
"""
import json
import argparse
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState
from pynq_multimodal_game.studio.system_loader import run_process

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--expected-mode',choices=('menu','canvas'),default='menu',
               help='Explicit currently observed page; never navigate to force an assertion')
args=p.parse_args()

code="""import json,sys,subprocess
from pathlib import Path
sys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')
import system_board as b
a=json.loads(Path('/home/xilinx/voice-view-game/.studio-system/active.json').read_text())
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
owned=b.gate(a,boot)
assert owned
for verb in ('is-active','is-enabled'):
 assert subprocess.run(['systemctl',verb,'--quiet','voice-view-shell.service']).returncode==0
assert '--hand-serial-seconds' not in a['command']
print(json.dumps(dict(result='PASS',pid=a['pid'],root=a['root'],owners=sorted(owned),command=a['command'])))
"""
d=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000,timeout=3)
try:
    assert d.connect().state is DeviceState.READY
    s=d.video_status()['snapshot'];h=s['vision']['hand_session']
    (ROOT/'build/studio-r59-board/final-observed-state.json').write_text(json.dumps(s,indent=2),encoding='utf-8')
    print(json.dumps(dict(mode=s['runtime_mode'],last_error=s['last_error'],hand=h),ensure_ascii=False),flush=True)
    assert s['runtime_mode']==args.expected_mode and s['last_error'] is None
    assert h['max_seconds'] is None and not h['preview_allowed'] and not h['video_paused'] and not h['error']
    assert h['phase'] in ('ACTIVE','RESUMING','WAITING_SOURCE','WAITING_SOURCE_OFF')
    audit=json.loads(run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','ConnectTimeout=8',
        'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=30))
    result=dict(result='PASS',snapshot=s,service=audit,preview=False,test_input=False)
    (ROOT/'build/studio-r59-board/final-state.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(dict(result='PASS',mode=s['runtime_mode'],hand_phase=h['phase'],
                         service_pid=audit['pid'],owners=audit['owners'])))
finally:d.disconnect()
