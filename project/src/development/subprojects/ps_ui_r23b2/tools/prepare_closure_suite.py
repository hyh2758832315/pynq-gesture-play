"""Prepare deterministic software inputs and PC oracles for the real GPU suite.

Run: .venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/prepare_closure_suite.py --candidate build/CANDIDATE --output build/closure-suite.json
Outputs: explicit cases, every tick's snapshot/normalized Scene hash, package SHA.
Next: use the unchanged candidate and this JSON on PYNQ; no hardware accessed here.
"""
import argparse
from dataclasses import asdict
import hashlib,json
from pathlib import Path
import sys,tempfile

ROOT=Path(__file__).resolve().parents[3]
SOURCE=ROOT/'subprojects/ps_ui_r23b2'
sys.path[:0]=[str(SOURCE/'python'),str(ROOT)]
from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_testing import GameTestCase
from pynq_multimodal_game.game_validation import GameTestPlayback,canonical_scene_sha256,run_game_test
from pynq_multimodal_game.return_button import add_return_to_game_frame
from subprojects.ps_ui_r23b2.tools.build_deployment_candidate import stage_gesture_project

def prepare(candidate,output):
    cases=[]
    def custom(name,game,outcome,events,max_ticks):
        case=dict(schema_version=2,test_id=name,name=name,seed=0,max_ticks=max_ticks,
            events=events,assertions=[dict(tick=max_ticks,field='status',operator='eq',expected=outcome)])
        cases.append((game,outcome,case))
    custom('game1-safe-loss','game1','LOST',[
        dict(tick=600,kind='hand',event_id='right',x=319,y=90),
        dict(tick=630,kind='hand',event_id='down',x=160,y=179),
        dict(tick=648,kind='cancel',event_id='release')],800)
    custom('game1-jump-win','game1','WON',[
        dict(tick=0,kind='gesture',event_id='go',x=319,y=90,gesture='fist')],700)
    with tempfile.TemporaryDirectory(dir=ROOT/'build',prefix='closure-cases-') as temporary:
        staged=Path(temporary)
        for game in ('game2','game3'):stage_gesture_project(game,staged/game,include_tests=True)
        for name,outcome in (('rps-01-win','WON'),('rps-02-lose','LOST'),('rps-03-draw','DRAW')):
            cases.append(('game2',outcome,json.loads((staged/'game2/tests/replays'/f'{name}.json').read_text(encoding='utf-8'))))
        cases.append(('game3','WON',json.loads((staged/'game3/tests/replays/hand-princess-win.json').read_text(encoding='utf-8'))))
    custom('game3-walk-loss','game3','LOST',[
        dict(tick=0,kind='gesture',event_id='select',x=319,y=90,gesture='fist'),
        dict(tick=1,kind='gesture',event_id='walk',x=319,y=90,gesture='paper')],800)
    results=[]
    for game,outcome,data in cases:
        path=candidate/'seed_games'/f'{game}.vvg'
        case=GameTestCase.from_json(json.dumps(data))
        # Existing authored assertions are checked over the entire declared case.
        verified=run_game_test(path,case)
        if not verified.passed:raise AssertionError(verified.to_dict())
        rows=[]
        with GameRunner(path,seed=case.seed,render_rgb=False) as runner:
            playback=GameTestPlayback(case,tick_hz=runner.package.manifest.tick_hz)
            try:
                for tick in range(case.max_ticks+1):
                    frame=add_return_to_game_frame(runner.step(playback.input_at(tick)))
                    rows.append(dict(tick=tick,snapshot=asdict(frame.snapshot),
                        scene=canonical_scene_sha256(frame.scene_packet)))
                    if frame.snapshot.status in ('WON','LOST','DRAW'):break
            finally:playback.close()
        if rows[-1]['snapshot']['status']!=outcome:raise AssertionError((data['test_id'],rows[-1]))
        results.append(dict(game_id=game,outcome=outcome,case=data,oracle=rows,
            package_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
        print(data['test_id'],outcome,rows[-1]['tick'],flush=True)
    record=dict(schema='r27-software-input-pc-oracle-v1',scope='software input; not human recognition',
        candidate_manifest_sha256=hashlib.sha256((candidate/'deployment_manifest.json').read_bytes()).hexdigest(),
        cases=results)
    output.write_text(json.dumps(record,separators=(',',':')),encoding='utf-8')
    return record

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--candidate',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();prepare(a.candidate,a.output)
