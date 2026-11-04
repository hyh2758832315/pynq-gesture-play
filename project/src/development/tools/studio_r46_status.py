"""Read or normally stop the exact R46 Studio field transaction.

Run: .venv/Scripts/python.exe -B tools/studio_r46_status.py [--stop]
Outputs: build/studio-r46/board-status.json or board-stop.json.
Next: verify 17 OFF, vision cleanup and no owners before releasing the board.
Do not run status during the human observation interval.
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
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--stop',action='store_true')
    parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r46')
    args=parser.parse_args();out=args.output.resolve()
    ui=json.loads((out/'ui-field.json').read_text(encoding='utf-8'))
    receipt=json.loads(Path(ui['receipt']).read_text(encoding='utf-8'))
    device=RemoteDeviceSession('192.168.2.99',8765,expected_build_id=0xC0061000,source_ids=())
    action='stop' if args.stop else 'status'
    result=SystemLoader(device).remote(action,receipt['transaction'],receipt['manifest_sha256'])
    (out/f'board-{action}.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(dict(action=action,**result)))

if __name__=='__main__':main()
