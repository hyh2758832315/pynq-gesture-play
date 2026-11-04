"""Read or normally stop this exact Studio deployment; no direct MMIO access.
Run: .venv/Scripts/python.exe tools/studio_r45_status.py [--stop]
Outputs: build/studio-r45/board-status.json or board-stop.json.
Next: inspect the receipt before handing the board to another task.
"""
import argparse
import json
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import SystemLoader
from pynq_multimodal_game.studio.device import RemoteDeviceSession

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--stop',action='store_true')
    args=parser.parse_args();out=ROOT/'build/studio-r45'
    ui=json.loads((out/'ui-system.json').read_text(encoding='utf-8'))
    receipt=json.loads(Path(ui['receipt']).read_text(encoding='utf-8'))
    device=RemoteDeviceSession('192.168.2.99',8765,expected_build_id=0xC0061000,source_ids=())
    action='stop' if args.stop else 'status'
    result=SystemLoader(device).remote(action,receipt['transaction'],receipt['manifest_sha256'])
    (out/f'board-{action}.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(dict(action=action,boot_id=result['boot_id'],running=result['running'],owners=result['owners'])))
if __name__=='__main__':main()
