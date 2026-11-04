"""Install the already-validated Studio Game1/Game3 bytes; never run a game.

Run: .venv/Scripts/python.exe -B -u tools/studio_r60_sync_games.py
Output: build/studio-r60-live/content-install.json, with SHA identity readback.
Next: start the normal bundled-hand service, then give control to the player.
No rebuild, replay, test input, preview subscription or motor command.
"""
import hashlib,json
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState
out=ROOT/'build/studio-r60-live'
source=ROOT/'games_gesture/.loads/793437ce96764c53bff11f44620e2696/receipt.json'
r=json.loads(source.read_text(encoding='utf-8'));assert r['status']=='validated'
manifest=json.loads((ROOT/'build/ps-ui-r60-hud-canvas-candidate-r09/deployment_manifest.json').read_text(encoding='utf-8'))
d=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000)
result=dict(result='RUNNING',source=str(source),input_injected=False,preview=False,gameplay_started=False,items=[])
def save():(out/'content-install.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
try:
    assert d.connect().state is DeviceState.READY
    for item in r['items']:
        if item['kind']!='game' or item['item_id'] not in ('game1','game3'):continue
        assert item['tests'] and all(t['passed'] and t['assertions'] for t in item['tests'])
        p=Path(item['package']);sha=hashlib.sha256(p.read_bytes()).hexdigest()
        assert sha==item['sha256']==manifest['sha256']['seed_games/'+item['item_id']+'.vvg'].lower()
        known=d.list_library()['library_items']
        same=next((x for x in known if x['item_id']==item['item_id'] and x['sha256']==sha),None)
        if same is None:d.install_game(p)
        known=d.list_library()['library_items']
        row=next(x for x in known if x['item_id']==item['item_id'] and x['sha256']==sha and x['length']==item['length'])
        result['items'].append(row);save();print(item['item_id']+' installed SHA verified',flush=True)
    assert len(result['items'])==2
    result['result']='PASS'
finally:d.disconnect();save()
