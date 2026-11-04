"""Check changed games through the already-running Studio-installed Agent.

Run: .venv/Scripts/python.exe -B tools/r58_installed_game_accept.py
     --output build/studio-r58-r05-board --games game1
Outputs: installed-game-checks.json, per-case PYNQ reports and comparisons.
Next: complete the separate video/restart and observed hand acceptance.
Uses normal Studio APIs; every test returns to the menu and releases test input.
"""
import argparse
import json
from pathlib import Path
import sys
import time
from zipfile import ZipFile

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState
from pynq_multimodal_game.studio.system_loader import run_process
from pynq_multimodal_game.game_validation import compare_test_reports

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--output',type=Path,required=True)
p.add_argument('--games',nargs='+',required=True)
a=p.parse_args();out=a.output.resolve()
system=json.loads(Path(json.loads((out/'ui-system.json').read_text(encoding='utf-8'))['receipt']).read_text(encoding='utf-8'))
content_path=Path(json.loads((out/'ui-content.json').read_text(encoding='utf-8'))['receipt'])
content=json.loads(content_path.read_text(encoding='utf-8'))
assert system['result']=='PASS' and content['status']=='complete'
device=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000)
report=dict(result='RUNNING',manifest_sha256=system['manifest_sha256'],games=a.games,checks=[])
active=False

def save(name,value):
    (out/name).write_text(json.dumps(value,indent=2,ensure_ascii=False),encoding='utf-8')

try:
    raw=run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','ConnectTimeout=8','pynq-z2',
        'cat /home/xilinx/voice-view-game/.studio-system/active.json'],timeout=30)
    owner=json.loads(raw);report['owner']=owner
    assert owner['manifest_sha256']==system['manifest_sha256'] and not owner['hand_enabled']
    assert device.connect().state is DeviceState.READY
    listing=device.list_library()['library_items']
    selected=[r for r in content['items'] if r['kind']=='game' and r['item_id'] in a.games]
    assert {r['item_id'] for r in selected}==set(a.games)
    for index,item in enumerate(content['items'],1):
        if item not in selected:continue
        assert any(row['item_id']==item['item_id'] and row['sha256']==item['sha256']
                   and row['length']==item['length'] for row in listing)
        with ZipFile(item['package']) as archive:
            cases=[(name,archive.read(name).decode()) for name in sorted(archive.namelist())
                   if name.startswith('tests/replays/') and name.endswith('.json')]
        for case_index,(name,case_json) in enumerate(cases,1):
            label=item['item_id']+'-'+Path(name).stem
            assert device.run_game(item['item_id'],test_case_json=case_json)['ok'];active=True
            begin=time.monotonic();deadline=begin+max(40,json.loads(case_json)['max_ticks']/20+30)
            samples=[]
            while True:
                reply=device.video_status();assert reply['ok'];snap=reply['snapshot']
                samples.append(dict(seconds=time.monotonic()-begin,state=snap['state'],
                                    tick=snap.get('game_tick'),presented=snap.get('presented_frames')))
                assert not snap.get('last_error'),snap
                if snap.get('test_complete'):break
                if time.monotonic()>deadline:
                    save(label+'-installed-timeout.json',dict(snapshot=snap,samples=samples))
                    raise TimeoutError(label)
                time.sleep(1)
            assert snap['assertions_failed']==0 and snap['assertions_passed']>0
            pc=json.loads((content_path.parent/str(index)/f'test-{case_index}.json').read_text(encoding='utf-8'))
            comparison=compare_test_reports(pc,snap['game_test_report'])
            save(label+'-installed-pynq.json',snap['game_test_report'])
            save(label+'-installed-comparison.json',comparison)
            assert comparison['status']=='passed',comparison
            stop=device.stop_video();assert stop['ok'] and stop['snapshot']['runtime_mode']=='menu'
            active=False
            report['checks'].append(dict(case=label,passed=True,sha256=item['sha256'],samples=samples))
            save('installed-game-checks.json',report);print(label+' PASS',flush=True)
    report['result']='PASS'
except BaseException as error:
    report.update(result='FAIL',error=str(error));raise
finally:
    if active:
        try:report['cleanup_return']=device.stop_video()
        except Exception as error:report['cleanup_error']=str(error)
    device.disconnect();save('installed-game-checks.json',report)
