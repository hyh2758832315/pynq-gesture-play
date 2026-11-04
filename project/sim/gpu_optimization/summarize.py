"""Run: python sim/gpu_optimization/summarize.py OUTPUT_DIR
Output: comparison/measurements.{csv,json}; next: review and publish with sources.
RTL cycles at 100 MHz, not camera/HDMI FPS or PS end-to-end latency.
"""
import csv
import hashlib
import json
from pathlib import Path
import re

import sys
OUT = Path(sys.argv[1]).resolve()
profiles = {}
sources = {}
for profile in ('baseline', 'v35', 'v40'):
    rows = {}
    for scope in ('mixed', 'raster'):
        path = OUT / f'{profile}_{scope}.log'
        text = path.read_text()
        assert '$finish called' in text
        assert not re.search(r'fatal:|error:|watchdog expired', text, re.I)
        sources[path.name] = hashlib.sha256(path.read_bytes()).hexdigest()
        for line in text.splitlines():
            if not re.match(r'C4M7_(BLIT|TILE|PAIR|RASTER)_FRAME=PASS ', line):
                continue
            family = line.split('=')[0]
            fields = dict(re.findall(r'(\w+)=(\w+)', line))
            identity = (family, fields.get('mixed', ''), fields.get('frame', ''), fields.get('mask', ''))
            assert identity not in rows
            rows[identity] = fields
    profiles[profile] = rows
assert profiles['baseline'].keys() == profiles['v35'].keys() == profiles['v40'].keys()
result = []
for identity, baseline in profiles['baseline'].items():
    row = dict(zip(('workload', 'mixed', 'frame', 'mask'), identity))
    row.update(writes=int(baseline['writes']), crc=baseline['crc'])
    for profile, rows in profiles.items():
        fields = rows[identity]
        assert fields['crc'] == baseline['crc'] and fields['writes'] == baseline['writes'], identity
        row[profile + '_cycles'] = int(fields['cycles'])
        row[profile + '_us'] = int(fields['cycles']) / 100
    row['v35_speedup'] = row['baseline_cycles'] / row['v35_cycles']
    row['v40_speedup'] = row['baseline_cycles'] / row['v40_cycles']
    result.append(row)
with (OUT/'measurements.csv').open('w', newline='', encoding='utf-8') as stream:
    writer = csv.DictWriter(stream, fieldnames=list(result[0]))
    writer.writeheader()
    writer.writerows(result)
report = dict(result='PASS', clock_mhz=100, measurement='RTL core render cycles',
              comparisons=len(result), output_crc_and_writes_identical=True,
              log_sha256=sources, rows=result)
(OUT/'measurements.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
print(json.dumps(report, indent=2))
