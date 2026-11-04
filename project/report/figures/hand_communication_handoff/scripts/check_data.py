"""Check the handoff hashes and numerical/packet claims using the standard library.

Run from the handoff root: python scripts/check_data.py
Output: a concise PASS JSON on stdout; failure raises AssertionError.
Next: redraw using the checked data and preserve its units and scopes.
This script does not open serial ports, sockets, or project runtime processes.
"""
from pathlib import Path
import hashlib
import json
import math
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[1]
manifest=json.loads((ROOT/'FILE_MANIFEST.json').read_text(encoding='utf-8'))
for name,expected in manifest['sha256'].items():
    assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==expected, f'File changed: {name}'

def frame(identifier,code,parameters):
    body=[identifier,len(parameters)+2,code,*parameters]
    return bytes([255,255,*body,(~sum(body))&255])

examples=json.loads((ROOT/'data/protocol_examples.json').read_text(encoding='utf-8'))
for entry in examples['examples']:
    actual=frame(entry['id'],entry['instruction_or_error'],entry['parameters_or_data'])
    expected=bytes.fromhex(entry['hex'])
    assert actual==expected,entry['name']
    assert len(actual)==actual[3]+4
    assert sum(actual[2:])&255==255
sdk_result=json.loads((ROOT/'data/packet_check.json').read_text(encoding='utf-8'))
assert sdk_result['tx_hex']==examples['examples'][0]['hex']
assert sdk_result['ack_hex']==examples['examples'][1]['hex']
assert sdk_result['communication']==0 and sdk_result['device_error']==0

d=json.loads((ROOT/'data/comparison_data.json').read_text(encoding='utf-8'))
for row in d['board_runs']:
    raw=json.loads((ROOT/'data/raw'/row['source']).read_text(encoding='utf-8'))['phases']['motion']
    for key in ('cpu_seconds','wall_seconds','single_core_percent'):
        assert math.isclose(raw[key],row[key],abs_tol=1e-10)
    assert math.isclose(row['cpu_seconds']/row['wall_seconds']*100,row['single_core_percent'])
raw=json.loads((ROOT/'data/raw/verification-final.json').read_text(encoding='utf-8'))['fixed_playback_budget']['results']
for i,state in enumerate(d['offline']['poses']):
    for flag,key in [(False,'writes_all'),(True,'writes_cached')]:
        match=[r for r in raw if r['start']=='default' and r['state']==state and r['skip_unchanged']==flag]
        assert len(match)==1 and match[0]['repetitions']==2 and match[0]['read_packets']==0
        assert match[0]['write_packets']==d['offline'][key][i]
for i,key in enumerate(('writes_all','writes_cached')):
    total=sum(d['offline'][key])
    assert total==d['offline']['total_writes'][i]
    assert total*19==d['offline']['total_tx_ack_bytes'][i]
    assert math.isclose(total*19*10/1_000_000*1000,d['offline']['ideal_wire_ms'][i])
assert math.isclose(d['offline']['saved_percent'],(1-201/306)*100)
for name in ('01_logic','02_sequence','03_packet'):
    ET.parse(ROOT/'figures'/f'{name}.drawio')
    ET.parse(ROOT/'figures'/f'{name}.svg')
    scene=json.loads((ROOT/'figures'/f'{name}.json').read_text(encoding='utf-8'))
    assert all('3 s' not in n['lines'] for n in scene['nodes'])
print(json.dumps(dict(result='PASS',hashed_files=len(manifest['sha256']),packet_examples=len(examples['examples']),
    board_runs=3,paired_pose_cases=4,hardware_access=False),ensure_ascii=False))
