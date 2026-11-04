"""Use the same Studio start-installed operation for the authorized hand test.

Run: .venv/Scripts/python.exe -B tools/r15b_start_installed_hand.py --output NEW_DIR
Outputs: NEW_DIR/receipt.json with running identity; no test-duration shutdown.
Next: human HDMI menu restart / video / preview / gesture checks.
"""
import argparse,json,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession
from pynq_multimodal_game.studio.system_loader import SystemLoader

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    args=p.parse_args()
    device=RemoteDeviceSession('192.168.2.99',8765,expected_build_id=0xC0061000,
                               source_address='192.168.2.1',timeout=5)
    loader=SystemLoader(device)
    try:
        before=loader.inspect()
        identity='5efd63005162b7871fcce7c658b4a28b16f6002a567000f7513112c15d96ed8b'
        assert before['installed']['manifest_sha256']==identity,'R15b installation required'
        result=loader.start_installed(args.output,hand_enabled=True,progress=lambda s:print(s,flush=True))
        print(json.dumps(result,ensure_ascii=True),flush=True)
    finally:device.disconnect()

if __name__=='__main__':main()
