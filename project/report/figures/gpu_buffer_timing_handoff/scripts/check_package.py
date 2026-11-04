"""Check GPU handoff hashes, editable figures and numerical claims (stdlib only).

Run: python scripts/check_package.py
Output: PASS JSON. Next: redraw and review visuals before report/poster use.
No hardware, network or runtime process is used.
"""
from pathlib import Path
import csv,hashlib,json,struct,xml.etree.ElementTree as ET,zlib
ROOT=Path(__file__).resolve().parents[1]
m=json.loads((ROOT/'FILE_MANIFEST.json').read_text(encoding='utf-8'))
for name,value in m['sha256'].items():assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==value,name
p=(ROOT/'data/scene_example.bin').read_bytes();assert len(p)==4160 and p[:4]==b'S2DG'
assert struct.unpack_from('<8I',p,96)==(4,247,0x0014000A,0x00100020,0,0,0,0)
assert not any(p[160:])
p=(ROOT/'data/palette_example.bin').read_bytes();assert len(p)==1088 and p[:4]==b'S2DP'
assert struct.unpack_from('<I',p,24)[0]==zlib.crc32(p[64:])
with (ROOT/'data/storage.csv').open(encoding='utf-8-sig',newline='') as f:rows=list(csv.DictReader(f))
for r in rows:assert int(r['copies'])*int(r['bytes_each'])==int(r['total_bytes'])
assert int(rows[1]['total_bytes'])==3*int(rows[0]['total_bytes'])
t=json.loads((ROOT/'data/timing.json').read_text(encoding='utf-8'));assert t['refresh_Hz']==60
scenes=list((ROOT/'figures').glob('0*.json'));assert len(scenes)==3
for path in scenes:
    ET.parse(path.with_suffix('.drawio'));ET.parse(path.with_suffix('.svg'))
    d=json.loads(path.read_text(encoding='utf-8'));ids={n['id'] for n in d['nodes']};assert len(ids)==len(d['nodes'])
    for n in d['nodes']:assert 0<=n['x'] and 0<=n['y'] and n['x']+n['w']<=d['width'] and n['y']+n['h']<=d['height']
    for e in d['edges']:
        assert e['source'] in ids and e['target'] in ids
        assert all(a[0]==b[0] or a[1]==b[1] for a,b in zip(e['points'],e['points'][1:]))
print(json.dumps(dict(result='PASS',files=len(m['sha256']),figures=3,scene_bytes=4160,hardware_access=False)))
