"""Stop the currently accepted normal service through Studio's owner contract.

Run: .venv/Scripts/python.exe -B tools/v2_stop_previous.py
Output: build/studio-v2/previous-stop.json. Next: unchanged Studio space gate/install.
"""
import json
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process

code="from pathlib import Path\nprint(Path('/home/xilinx/voice-view-game/.studio-system/active.json').read_text())\n"
active=json.loads(run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','ConnectTimeout=8',
    'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=30))
assert active['manifest_sha256'].upper()=='E4E496BD842470E8F8D7F5D0BF7C8A5C375FA4A28C6B8D9BABE5753F82D1DD49'
d=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000)
r=SystemLoader(d).remote('stop',active['transaction'],active['manifest_sha256'])
assert not r['running'] and not r['owners']
out=ROOT/'build/studio-v2';out.mkdir(exist_ok=True)
(out/'previous-stop.json').write_text(json.dumps(r,indent=2),encoding='utf-8')
print(json.dumps(r))
