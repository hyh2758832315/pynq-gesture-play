"""Normally stop the currently registered autostart instance before reboot verification.

Run: .venv/Scripts/python.exe -B tools/studio_r48_owned_stop.py
Outputs: build/studio-r48/pre-reboot-active.json and pre-reboot-stop.json.
Next: reboot only when this receipt confirms no owner, vision cleanup and all 17 OFF.
"""
import json
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process
from pynq_multimodal_game.studio.device import RemoteDeviceSession

def main():
    raw=run_process(['ssh','-o','BatchMode=yes','-o','ConnectTimeout=8','-b','192.168.2.1','pynq-z2',
        'sudo -n cat /home/xilinx/voice-view-game/.studio-system/active.json'],timeout=20)
    active=json.loads(raw)
    if not active.get('autostart'):raise RuntimeError('Current owner is not this autostart session')
    out=ROOT/'build/studio-r48';(out/'pre-reboot-active.json').write_bytes(raw)
    device=RemoteDeviceSession('192.168.2.99',8765,expected_build_id=0xC0061000,source_address='192.168.2.1')
    result=SystemLoader(device).remote('stop',active['transaction'],active['manifest_sha256'])
    (out/'pre-reboot-stop.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    assert not result['running'] and not result['owners']
    evidence=[item['summary'] for item in result['shutdown_evidence']]
    assert any(r.get('cleanup_confirmed') is True and not r.get('error') for r in evidence)
    if active['hand_enabled']:
        assert any(r.get('release_confirmed_ids')==list(range(1,18)) and r.get('backend_closed')
                   and r.get('release_confirmed') and not r.get('error') for r in evidence)
    print(json.dumps(dict(result='PASS',boot_id=result['boot_id'],running=False,owners=[],evidence=evidence)))

if __name__=='__main__':main()
