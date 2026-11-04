"""Build checked R43 hand + page data; never access a serial device.

Run: subprojects/pynq_usb_hand/.venv/Scripts/python.exe -B
     subprojects/ps_ui_r23b2/tools/build_creative_hand_candidate.py
Outputs: build/hand-r43-creative-r06, source data/demo_geometry.json and SHA pins.
Next: run offline tests, then build_deployment_candidate.py --output NEW_PATH.
PYNQ-Z2 / existing Vivado 2026.1 R23b2 Overlay remains unchanged.
"""
from pathlib import Path
import hashlib
import json
import re
import shutil
import sys

ROOT=Path(__file__).resolve().parents[3]
SOURCE=ROOT/'subprojects/ps_ui_r23b2'
BASE=ROOT/'build/hand-r35-default-stability-20261026-r05'
OUTPUT=ROOT/'build/hand-r43-creative-r06'
DESKTOP=Path.home()/'Desktop/灵巧手'

def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()

def build():
    if OUTPUT.exists(): raise FileExistsError('Preserve candidate; choose a new output')
    pins=SOURCE/'hand_child/serial_sources.json'
    base_pins=SOURCE/'demo_assets/base-r05-serial-sources.json'
    if sha(base_pins)!='cafb0b53b098f15dd4a68b7bb93baf3e5a3e3bfe660f00bb619de1ac7e40fc5f':
        raise ValueError('R05 baseline manifest identity mismatch')
    baseline=json.loads(base_pins.read_text(encoding='utf-8'))
    for name,expected in baseline['sha256'].items():
        if sha(BASE/name)!=expected: raise ValueError('Hand baseline changed: '+name)
    shutil.copytree(BASE,OUTPUT,ignore=shutil.ignore_patterns('__pycache__','*.pyc','.pytest_cache'))
    for name in ('controller','motion','actuator_owner','page_playback'):
        shutil.copy2(SOURCE/f'hand_overrides/{name}.py',OUTPUT/f'src/pynq_usb_hand/{name}.py')
    assets=SOURCE/'demo_assets'
    assets.mkdir(exist_ok=True)
    demo=OUTPUT/'assets/demo'
    demo.mkdir()
    for stem,original in [(str(i),str(i)) for i in range(10)]+[('heart','比心'),('default','默认位置')]:
        target=assets/(stem+'.txt')
        if target.exists() and sha(target)!=sha(DESKTOP/(original+'.txt')):
            raise ValueError('Imported demo changed; review before replacing')
        shutil.copy2(DESKTOP/(original+'.txt'),target)
        shutil.copy2(target,demo/target.name)
    sys.path.insert(0,str(OUTPUT/'src'))
    from pynq_usb_hand.orca_backend import OrcaModel
    from pynq_usb_hand.page_playback import load_demo_poses,DEMO_STATES
    from pynq_usb_hand.motion import Motion,MotionSettings
    model=OrcaModel(OUTPUT)
    load_demo_poses(model,demo)
    geometry={}
    for name in ('default',*DEMO_STATES):
        pose=model.poses[name]
        def norm(joint):
            lo,hi=model.roms[joint]
            return round(max(0.,min(1.,(pose[joint]-lo)/(hi-lo))),3)
        geometry[name]=dict(curls=[norm(j) for j in ('index_pip','middle_pip','ring_pip','pinky_pip','thumb_dip')],
                            bases=[norm(j) for j in ('index_mcp','middle_mcp','ring_mcp','pinky_mcp','thumb_mcp')],
                            thumb_opposition=norm('thumb_cmc'),
                            spread=[round(2*norm(j)-1,3) for j in ('index_abd','middle_abd','ring_abd','pinky_abd','thumb_abd')])
    # Use the real calibrated compilation path without constructing a serial backend.
    class Offline:
        poses=model.poses
        roms=model.roms
        stage_targets_authorized=True
        playback_authorized=True
        compile_target=staticmethod(model.to_motor)
    motion=Motion(Offline(),MotionSettings.fixed_playback(stage_waits=(3,3,3)))
    assert all(motion.playback_routes[state][0][0]=='default:target' for state in DEMO_STATES)
    data=SOURCE/'python/pynq_multimodal_game/data'
    data.mkdir(exist_ok=True)
    (data/'demo_geometry.json').write_text(json.dumps(geometry,indent=2)+'\n',encoding='utf-8')
    manifest=dict(schema='hand-serial-source-v1',sha256={name:sha(OUTPUT/name) for name in baseline['sha256']})
    for relative in ['src/pynq_usb_hand/page_playback.py',*(str(p.relative_to(OUTPUT).as_posix()) for p in demo.glob('*.txt'))]:
        manifest['sha256'][relative]=sha(OUTPUT/relative)
    pins.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    bridge=SOURCE/'python/pynq_multimodal_game/hand_shadow_bridge.py'
    t=bridge.read_text(encoding='utf-8')
    for key,path in [('SERIAL_CHILD_SHA256',SOURCE/'hand_child/serial_motion_receiver.py'),('SERIAL_MANIFEST_SHA256',pins)]:
        t,n=re.subn(key+r' = "[a-f0-9]+"',key+' = "'+sha(path)+'"',t)
        assert n==1
    bridge.write_text(t,encoding='utf-8')
    startup=SOURCE/'python/pynq_multimodal_game/hand_startup.py'
    t=startup.read_text(encoding='utf-8')
    relative='src/pynq_usb_hand/motion.py'
    t,n=re.subn(r'("'+re.escape(relative)+r'": ")[a-f0-9]+',lambda m:m[1]+sha(OUTPUT/relative),t)
    assert n==1
    startup.write_text(t,encoding='utf-8')
    record=dict(schema='creative-hand-r43-v1',base=str(BASE),output=str(OUTPUT),
                calibration_sha256=sha(OUTPUT/'assets/calibration.yaml'),
                demo_files={p.name:sha(p) for p in demo.glob('*.txt')},
                routes=len(DEMO_STATES),serial_manifest_sha256=sha(pins),hardware_tested=False)
    (ROOT/'build/r43-hand-build.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(record,indent=2))

def refresh():
    """Refresh this unpublished offline candidate after a tested source correction."""
    if not (OUTPUT/'src/pynq_usb_hand/page_playback.py').is_file():
        raise ValueError('Initial candidate required')
    for name in ('controller','motion','actuator_owner','page_playback'):
        shutil.copy2(SOURCE/f'hand_overrides/{name}.py',OUTPUT/f'src/pynq_usb_hand/{name}.py')
    pins=SOURCE/'hand_child/serial_sources.json'
    manifest=json.loads(pins.read_text(encoding='utf-8'))
    manifest['sha256']={name:sha(OUTPUT/name) for name in manifest['sha256']}
    pins.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    bridge=SOURCE/'python/pynq_multimodal_game/hand_shadow_bridge.py'
    t=bridge.read_text(encoding='utf-8')
    for key,path in [('SERIAL_CHILD_SHA256',SOURCE/'hand_child/serial_motion_receiver.py'),('SERIAL_MANIFEST_SHA256',pins)]:
        t,n=re.subn(key+r' = "[a-f0-9]+"',key+' = "'+sha(path)+'"',t)
        assert n==1
    bridge.write_text(t,encoding='utf-8')
    record_path=ROOT/'build/r43-hand-build.json'
    record=json.loads(record_path.read_text(encoding='utf-8'))
    record['serial_manifest_sha256']=sha(pins)
    record_path.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
    print('Refreshed unpublished R43 hand candidate: '+sha(pins))

if __name__=='__main__':
    refresh() if sys.argv[1:]==['--refresh'] else build()
