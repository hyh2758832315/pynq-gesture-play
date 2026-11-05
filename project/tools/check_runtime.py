"""Check immutable deployed bytes and the exact target without opening hardware.

Run: python -B tools/check_runtime.py
Output: board/runtime manifest SHA and file count. Next: Studio or offline tests.
"""
import ast
import hashlib
import json
from pathlib import Path
import sys
from xml.etree import ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
board = ROOT / 'board/runtime'
manifest = board / 'deployment_manifest.json'
expected = '968c6cbb4b2e1fd38a334a79321e7feabfadaca9546183025de20bbceab1c525'
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
from pynq_multimodal_game.hand_startup import HandStartupGate
from pynq_usb_hand.assets import verify_frozen
verify_frozen(board/'hand-runtime')
verify_serial_sources(board/'hand-runtime',board)
verify_shadow_sources(board/'hand-runtime')

def literal_assignment(path, name):
    tree = ast.parse(path.read_text(encoding='utf-8'))
    return next(ast.literal_eval(node.value) for node in tree.body
                if isinstance(node, ast.Assign)
                and any(isinstance(target, ast.Name) and target.id == name
                        for target in node.targets))

# Construction validates the frozen manifest and all read-only source pins.
# The probe is invoked only by __call__, which this offline check never calls.
port = literal_assignment(board/'hand_child/serial_motion_receiver.py', 'PORT')
gate = HandStartupGate(root=board/'hand-runtime', python=Path(sys.executable),
                       port=port, report_dir=ROOT/'build/output/hand_startup_contract')
assert gate.passed is False and gate.report_path is None
power_pins = literal_assignment(board/'hand-runtime/tools/power_feedback_readonly.py', 'PINS')
for name, digest in power_pins.items():
    assert hashlib.sha256((board/'hand-runtime'/name).read_bytes()).hexdigest() == digest, name
tree=ET.fromstring((board/'overlay/c6v_candidate.hwh').read_bytes())
core=next(x for x in tree.iter('MODULE') if x.get('INSTANCE')=='core')
parameters={x.get('NAME'):x.get('VALUE','').strip('"') for x in core.iter('PARAMETER')}
for name in ('TILE_DESCRIPTOR_CACHE_ENABLE','BLIT_PIXEL_PIPELINE_ENABLE','TILE_PIXEL_PIPELINE_ENABLE',
             'TILE_PIXEL_PAIR_ENABLE','BLIT_PIXEL_PAIR_ENABLE','CLEAR_FILL_PIXEL_PAIR_ENABLE'):
    assert parameters[name]=='1',name
assert parameters['UPLOAD_RENDER_OVERLAP_ENABLE']=='0'
print(json.dumps(dict(result='PASS',files=len(data['sha256']),manifest_sha256=expected,
                     gpu_profile='cache_pipeline_pair',hand_sources_verified=True,
                     hand_startup_identity_verified=True,hand_power_check_identity_verified=True,
                     board_access=False)))
