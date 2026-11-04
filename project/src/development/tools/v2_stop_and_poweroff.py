"""Normally release the accepted v2 system, then perform user-requested shutdown.

Run: .venv/Scripts/python.exe -B tools/v2_stop_and_poweroff.py
Output: build/studio-v2/user-shutdown/{stop,poweroff}.json.
Next: finish PC-only publication; board needs physical power-on for later use.
Never force-kills, reloads PL or probes motors; saved OFF/cleanup receipts gate halt.
"""
import json
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process
out=ROOT/'build/studio-v2/user-shutdown';out.mkdir(exist_ok=False)
def remote(code):
    return run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','ConnectTimeout=20',
        'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=90)
active=json.loads(remote("from pathlib import Path\nprint(Path('/home/xilinx/voice-view-game/.studio-system/active.json').read_text())\n"))
assert active['manifest_sha256']=='5f53d85d5bcdb8c871d387683cbf7b6b12c899b380b9370642c9bd2ff41e9d56'
device=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000)
stopped=SystemLoader(device).remote('stop',active['transaction'],active['manifest_sha256'])
assert not stopped['running'] and stopped['owners']==[]
evidence=[v['summary'] for v in stopped['shutdown_evidence']]
assert any(v.get('schema')=='shared-vision-stop-v1' and v.get('cleanup_confirmed') is True and not v.get('error') for v in evidence)
assert any(v.get('schema')=='vision-hand-actuator-owner-v1' and v.get('backend_closed') is True
    and v.get('release_confirmed') is True and v.get('release_confirmed_ids')==list(range(1,18))
    and not v.get('error') for v in evidence)
(out/'stop.json').write_text(json.dumps(stopped,indent=2),encoding='utf-8')
print('PASS: normal service stopped, 17 OFF/CLOSED, vision cleanup, owners=[]',flush=True)
code='owner='+repr(active)+'''
import json,subprocess,sys
from pathlib import Path
sys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')
import system_board as b
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot==owner['boot_id'];b.gate(None,boot)
assert subprocess.run(['systemctl','is-active','--quiet','voice-view-shell.service']).returncode!=0
record=dict(result='POWEROFF_SCHEDULED',boot_id=boot,manifest_sha256=owner['manifest_sha256'],
            user_requested=True,owners=[],default_autostart_preserved=True)
Path('/home/xilinx/voice-view-game/.studio-system/v2-user-poweroff.json').write_text(json.dumps(record,indent=2))
subprocess.run(['sync'],check=True)
subprocess.run(['systemd-run','--unit=v2-user-poweroff','--on-active=3s','/bin/systemctl','poweroff'],check=True,
               stdout=subprocess.PIPE,stderr=subprocess.PIPE)
print(json.dumps(record),flush=True)
'''
raw=remote(code);(out/'poweroff.json').write_bytes(raw)
print(raw.decode().strip(),flush=True)
