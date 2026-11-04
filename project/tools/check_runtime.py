"""Check immutable deployed bytes and the exact target without opening hardware.

Run: python -B tools/check_runtime.py
Output: board/runtime manifest SHA and file count. Next: Studio or offline tests.
"""
import hashlib
import json
from pathlib import Path
import sys
from xml.etree import ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
board = ROOT / 'board/runtime'
manifest = board / 'deployment_manifest.json'
expected = '56499ea2d1919fffc92ee5cf4b0e15794fc95290201777d10f65424ac71185a3'
assert hashlib.sha256(manifest.read_bytes()).hexdigest() == expected
data = json.loads(manifest.read_text(encoding='utf-8'))
assert data['build_id'] == '0xC0061000'
for name, digest in data['sha256'].items():
    p = (board / name).resolve()
    assert p.is_relative_to(board.resolve()), name
    assert hashlib.sha256(p.read_bytes()).hexdigest() == digest.lower(), name
sys.path.insert(0,str(board/'python'))
sys.path.insert(0,str(board/'hand-runtime/src'))
from pynq_multimodal_game.hand_shadow_bridge import verify_serial_sources, verify_shadow_sources
from pynq_usb_hand.assets import verify_frozen
verify_frozen(board/'hand-runtime')
verify_serial_sources(board/'hand-runtime',board)
verify_shadow_sources(board/'hand-runtime')
tree=ET.fromstring((board/'overlay/c6v_candidate.hwh').read_bytes())
core=next(x for x in tree.iter('MODULE') if x.get('INSTANCE')=='core')
parameters={x.get('NAME'):x.get('VALUE','').strip('"') for x in core.iter('PARAMETER')}
for name in ('TILE_DESCRIPTOR_CACHE_ENABLE','BLIT_PIXEL_PIPELINE_ENABLE','TILE_PIXEL_PIPELINE_ENABLE',
             'TILE_PIXEL_PAIR_ENABLE','BLIT_PIXEL_PAIR_ENABLE','CLEAR_FILL_PIXEL_PAIR_ENABLE'):
    assert parameters[name]=='1',name
assert parameters['UPLOAD_RENDER_OVERLAP_ENABLE']=='0'
print(json.dumps(dict(result='PASS',files=len(data['sha256']),manifest_sha256=expected,
                     gpu_profile='cache_pipeline_pair',hand_sources_verified=True,board_access=False)))
