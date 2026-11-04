"""Check file hashes, packet example and tabulated figure claims (stdlib only).

Run: python scripts/check_package.py
Output: PASS JSON. Next: redraw, then inspect text and arrow layout.
No hardware, network or project runtime is used.
"""
from pathlib import Path
import csv
import hashlib
import json
import struct
import xml.etree.ElementTree as ET
import zlib

ROOT=Path(__file__).resolve().parents[1]
m=json.loads((ROOT/'FILE_MANIFEST.json').read_text(encoding='utf-8'))
for name,value in m['sha256'].items():
    assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==value,name
packet=(ROOT/'data/dms1_example.bin').read_bytes()
assert len(packet)==640*360*2+64
tail=struct.unpack('<16I',packet[-64:])
assert tail[0]==0x31534d44 and tail[1]==0x00100001
assert tail[5]==(360<<16)|640 and tail[6]==640*360 and tail[7]==640*360*2
assert tail[9]==0xff141400 and tail[10]==0xff46 and tail[11]==0x00010802
assert tail[15]==zlib.crc32(packet[:-4])==0x5b04b719
with (ROOT/'data/vote_trace.csv').open(encoding='utf-8-sig',newline='') as f:
    rows=list(csv.DictReader(f))
assert [r['stable'] for r in rows]==['PENDING','PENDING','0','PENDING','PENDING','2']
with (ROOT/'data/osd_registers.csv').open(encoding='utf-8-sig',newline='') as f:
    regs={r['offset']:int(r['value']) for r in csv.DictReader(f)}
assert regs=={'0x10':7,'0x14':0x01680280,'0x18':0,'0x1C':0x000f0000,'0x20':1,'0x24':0,'0x08':1}
scenes=list((ROOT/'figures').glob('0*.json'))
assert len(scenes)==3
for path in scenes:
    ET.parse(path.with_suffix('.svg'));ET.parse(path.with_suffix('.drawio'))
    scene=json.loads(path.read_text(encoding='utf-8'))
    ids={n['id'] for n in scene['nodes']}
    assert len(ids)==len(scene['nodes'])
    for n in scene['nodes']:
        assert 0<=n['x'] and 0<=n['y'] and n['x']+n['w']<=scene['width'] and n['y']+n['h']<=scene['height']
    for e in scene['edges']:
        assert e['source'] in ids and e['target'] in ids
        assert all(a[0]==b[0] or a[1]==b[1] for a,b in zip(e['points'],e['points'][1:]))
print(json.dumps(dict(result='PASS',files=len(m['sha256']),figures=3,packet_bytes=len(packet),hardware_access=False)))
