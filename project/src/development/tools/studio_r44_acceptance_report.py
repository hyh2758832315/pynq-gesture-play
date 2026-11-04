"""Assemble checked R44 evidence without hiding earlier failed observations.

Run: .venv/Scripts/python.exe -B tools/studio_r44_acceptance_report.py
Output: build/studio-r44/acceptance.json and a stable copy of the batch receipt.
Next: review docs/bringup/2026-10-27_studio_four_video_board.md before another board run.
"""
from pathlib import Path
import hashlib
import json
import shutil
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[1]
out=ROOT/'build/studio-r44'
read=lambda name:json.loads((out/name).read_text('utf-8-sig'))
ui=read('ui-load.json')
assert ui['result']=='PASS' and ui['closed'] and not ui['active_qthreads']
batch=json.loads(Path(ui['receipt']).read_text('utf-8'))
assert batch['status']=='complete' and len(batch['items'])==7
assert all(r['state']=='installed' and all(r['library'][k]==r[k] for k in ('item_id','length','sha256')) for r in batch['items'])
shutil.copyfile(ui['receipt'],out/'batch-receipt.json')
games=[s for s in read('exercise.json')['steps'] if s['name'].startswith(('game1','game2','game3'))]
videos=read('exercise-videos.json')
assert len(games)==30 and all(s['passed'] for s in games)
assert videos['result']=='PASS' and len(videos['steps'])==25 and all(s['passed'] for s in videos['steps'])
restart=read('restart-check.json')
assert restart['result']=='PASS' and len(restart['retained'])==7
cleanup=[read(f'stop-{run}.json') for run in ('a01','a02')]
assert all(r['board_released'] and not r['hardware_owners'] for r in cleanup)
parity=read('uploaded-game-parity.json')
assert len(parity)==3 and all(r['matches_r31'] for r in parity)
tests=[]
for name in ('studio-r44-tests-final.xml','studio-r44-parity-01.xml','studio-r44-video-menu-02.xml'):
    suites=ET.parse(ROOT/'build'/name).getroot().findall('testsuite')
    assert all(int(s.get('failures','0'))==int(s.get('errors','0'))==0 for s in suites)
    tests.append(dict(path=name,passed=sum(int(s.get('tests','0'))-int(s.get('skipped','0')) for s in suites)))
assert sum(r['passed'] for r in tests)==118
files=('python/pynq_multimodal_game/studio/device.py',
       'python/pynq_multimodal_game/studio/content_pipeline.py',
       'subprojects/ps_ui_r23b2/tools/prepare_studio_projects.py')
report=dict(schema='studio-r44-content-acceptance-v1',content_acceptance='PASS',
    board_released=True,installed_games=3,installed_videos=4,offline_tests=tests,
    physical_board_checks=len(games)+len(videos['steps']),restart_retained=7,
    actual_uploaded_game_parity=parity,cleanup=cleanup,
    startup_wait_observation=dict(initial_45_second_window='timed out; root cause not isolated',
        subsequent_probe=read('connection-probe.json'),retry='PASS'),
    earlier_failures_preserved=['exercise.json (fixed one-second video readiness check)',
        'restart-check-initial-wait.json','games_gesture/.loads (preflight harness and library timeout)'],
    physical_hand_enabled=False,human_hdmi_observation=False,
    source_sha256={n:hashlib.sha256((ROOT/n).read_bytes()).hexdigest() for n in files})
(out/'acceptance.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps({k:report[k] for k in ('content_acceptance','board_released','installed_games',
                                     'installed_videos','physical_board_checks','restart_retained')}))
