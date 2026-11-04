"""Reconcile preserved R59 receipts without rerunning hardware or editing evidence.

Run: .venv/Scripts/python.exe -B tools/r59_finalize_acceptance.py
Output: build/studio-r59-board/acceptance-summary.json.
Next: leave the verified normal service at its menu and hand over the record.
"""
import hashlib
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/studio-r59-board'
CANDIDATE=ROOT/'build/ps-ui-r59-recoverable-demo-candidate-r06'

def read(path):return json.loads(Path(path).read_text(encoding='utf-8'))
def passed(path):
    value=read(path)
    assert value['result']=='PASS',str(path)
    return value

identity=hashlib.sha256((CANDIDATE/'deployment_manifest.json').read_bytes()).hexdigest()
system=passed(OUT/'ui-system.json');content=passed(OUT/'ui-content.json')
install=passed(system['receipt'])
assert install['manifest_sha256']==identity
contents=read(content['receipt']);assert contents['status']=='complete'
recovery=passed(OUT/'recovery/board-checks.json')
physical=read(OUT/'physical/board-checks.json')
assert physical['result']=='AUTOMATED_PASS_OBSERVATION_PENDING'
assert all(c['passed'] for r in (recovery,physical) for c in r['checks'])
assert recovery['manifest_sha256']==physical['manifest_sha256']==identity
release=passed(OUT/'physical/physical-release.json')
assert release['manifest_sha256']==identity and release['observation']['passed']
for section in ('recovery','physical'):
    r=passed(OUT/section/'board-release.json')
    assert r['owners']==[] and r['receipts']
    assert all(x['cleanup_confirmed'] and x['error'] is None for x in r['receipts'])
    restart=passed(OUT/section/'restart-evidence.json')
    assert restart['same_pid'] and restart['album_cleared']
startup=passed(OUT/'autostart-install.json')
assert startup['default_hand'] and startup['start_requested']
assert '--hand-serial-seconds' not in startup['check']['command']
connection=passed(OUT/'after-restart.json')
assert connection['hand_default'] and connection['content_load_enabled']
assert Path(connection['desktop_settings']['candidate']).resolve()==CANDIDATE.resolve()
assert connection['closed'] and not connection['active_qthreads']
videos=passed(OUT/'videos.json')
assert videos['manifest_sha256']==identity and all(c['passed'] for c in videos['checks'])
assert videos['final_snapshot']['runtime_mode']=='menu'
assert not videos['input_injected'] and not videos['preview']
final=passed(OUT/'final-state.json')
assert not final['snapshot']['last_error'] and final['snapshot']['vision']['hand_session']['phase']=='ACTIVE'

# Reuse only unchanged packages and relevant successful checks. Preserve the
# earlier observer's FAIL, whose missing tail was separately tested to PASS.
current=read(CANDIDATE/'deployment_manifest.json')['sha256']
old_games=read(ROOT/'build/ps-ui-r58-full-closure-candidate-r03/deployment_manifest.json')['sha256']
old_game1=read(ROOT/'build/ps-ui-r58-full-closure-candidate-r05/deployment_manifest.json')['sha256']
for name in ('game1','game2','game3','game4'):
    key='seed_games/'+name+'.vvg'
    assert current[key]==(old_game1 if name=='game1' else old_games)[key]
game_replays=passed(ROOT/'build/studio-r58-r03-board/board-acceptance.json')
game1=passed(ROOT/'build/studio-r58-r05-board/installed-game-checks.json')
creative_path=ROOT/'build/studio-r58-r04-board/creative-r03/board-checks.json'
creative=read(creative_path)
assert creative['result']=='FAIL' and creative['error']=='loading evidence unbounded'
assert all(c['passed'] for c in creative['checks'])
results={c['name'] for c in creative['checks']}
assert {'WON-actual-terminal','WON-score','LOST-actual-terminal','LOST-score',
        'result-retry-fresh-game','result-return-menu'}<=results

record=dict(result='PASS',manifest_sha256=identity,candidate=str(CANDIDATE),
    native_studio=dict(system_receipt=system['receipt'],content_receipt=content['receipt'],
                       desktop_settings=connection['desktop_settings']),
    recovery_checks=len(recovery['checks']),physical_checks=len(physical['checks']),
    human_observation=release['observation'],physical_closed_sessions=len(release['receipts']),
    normal_hand_duration_limit=None,normal_hand_enabled=True,
    video_checks=len(videos['checks']),video_frames={k:v['samples'][-1] for k,v in videos['videos'].items()},
    automated_return_mode='menu',final_runtime_mode=final['snapshot']['runtime_mode'],
    temporary_preview=False,test_input_in_production=False,
    inherited_unchanged_game_evidence=dict(r03=game_replays['result'],r05_game1=game1['result'],
        r04_creative_checks=len(creative['checks']),original_result=creative['result'],
        original_error=creative['error'],original_path=str(creative_path)),
    normal_startup_wait_seconds=connection['connected_after_seconds'])
(OUT/'acceptance-summary.json').write_text(json.dumps(record,indent=2,ensure_ascii=False),encoding='utf-8')
print(json.dumps({k:record[k] for k in ('result','recovery_checks','physical_checks','video_checks','final_runtime_mode')}))
