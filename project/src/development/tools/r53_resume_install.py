"""Resume the failed Studio installation after reclaiming generated caches.
Run: .venv/Scripts/python.exe -B tools/r53_resume_install.py
Outputs: separate recovery receipt and ui-system.json pointing to it.
Next: native Studio content loading. No upload, Overlay change, or hand motion.
"""
from pathlib import Path
import sys,json,shutil
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession
from pynq_multimodal_game.studio.system_loader import SystemLoader
out=ROOT/'build/studio-r53';old=out/'ui-system.json';failed=json.loads(old.read_text(encoding='utf-8'))
shutil.copyfile(old,out/'ui-system-failed-r01.json')
device=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000,timeout=3)
try:
    receipt=SystemLoader(device).resume_installed(failed['receipt'],out/'recovery-r01',progress=lambda s:print(s,flush=True))
    report=dict(result=receipt['result'],physical_board=True,native_ui=False,studio_framework=True,hand_enabled=False,
        receipt=str(out/'recovery-r01/receipt.json'),original_native_install=str(out/'ui-system-failed-r01.json'))
    old.write_text(json.dumps(report,indent=2),encoding='utf-8');print(json.dumps(report),flush=True)
finally:device.disconnect()
