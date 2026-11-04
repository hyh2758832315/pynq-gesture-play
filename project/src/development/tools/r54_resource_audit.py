"""Audit actual Studio VVG packet peaks and save game previews.
Run: .venv/Scripts/python.exe -B tools/r54_resource_audit.py
Outputs: build/studio-r54-final-games/resource-audit.json and game1/game3 PNGs.
Next: use the matching Studio receipt for a whole-system candidate and board test.
"""
import json
import argparse
from pathlib import Path
import sys
from zipfile import ZipFile
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'python'))
from PySide6.QtGui import QImage
from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_testing import GameTestCase
from pynq_multimodal_game.game_validation import GameTestPlayback

root=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output',type=Path,default=root/'build/studio-r54-final-games')
out=parser.parse_args().output.resolve()
r=json.loads((out/'prepare.json').read_text(encoding='utf-8'))
receipt=json.loads(Path(r['receipt']).read_text(encoding='utf-8'))
assert r['result']=='PASS' and receipt['status']=='validated'
result=dict(result='RUNNING',receipt=r['receipt'],games={})
for item in receipt['items']:
    if item['kind']!='game':continue
    peak=dict(asset=0,palette=0,tilemap=0,scene=0,commands=0,cycles=0)
    with ZipFile(item['package']) as z:
        cases=[GameTestCase.from_json(z.read(n)) for n in sorted(z.namelist()) if n.startswith('tests/replays/') and n.endswith('.json')]
    for case in cases:
        with GameRunner(Path(item['package']),seed=case.seed,render_rgb=False) as runner:
            playback=GameTestPlayback(case,tick_hz=60)
            for tick in range(case.max_ticks+1):
                frame=runner.step(playback.input_at(tick))
                for key in ('asset','palette','tilemap','scene'):
                    peak[key]=max(peak[key],len(getattr(frame,key+'_packet') or b''))
                peak['commands']=max(peak['commands'],frame.command_count)
                peak['cycles']=max(peak['cycles'],frame.predicted_cycles)
    assert peak['asset']<=32880 and peak['tilemap']<=4096+64
    with GameRunner(Path(item['package'])) as runner:
        playback=GameTestPlayback(cases[0],tick_hz=60)
        for tick in range(15):frame=runner.step(playback.input_at(tick))
        image=QImage(frame.rgb,320,180,960,QImage.Format_RGB888)
        assert image.scaled(960,540).save(str(out/(item['item_id']+'.png')))
    result['games'][item['item_id']]=dict(sha256=item['sha256'],packet_peak_bytes=peak,cases=len(cases))
result['result']='PASS'
(out/'resource-audit.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(result))
