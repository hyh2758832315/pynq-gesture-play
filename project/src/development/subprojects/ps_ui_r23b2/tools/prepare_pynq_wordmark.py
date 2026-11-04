"""Compile the official AMD PYNQ lockup into the HDMI palette, preserving geometry.
Run: .venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/prepare_pynq_wordmark.py
Outputs: source data/pynq_wordmark.json and design/assets/provenance.json.
Next: render the board pages and check the actual 320x180 result and asset budget.
"""
from pathlib import Path
import hashlib
import json
from PySide6.QtCore import Qt
from PySide6.QtGui import QImage

ROOT=Path(__file__).resolve().parents[1]
source=ROOT/'design/assets/pynq-official-logo.png'
image=QImage(str(source))
assert not image.isNull()
scaled=image.scaledToWidth(104,Qt.SmoothTransformation)
indices=bytearray()
for y in range(scaled.height()):
    for x in range(scaled.width()):
        c=scaled.pixelColor(x,y)
        coverage=255-min(c.red(),c.green(),c.blue())
        ink = 9 if y < scaled.height()*.59 else 7
        indices.append(ink if coverage>=145 else 12 if coverage>=65 else 11 if coverage>=22 else 0)
record=dict(schema='pynq-wordmark-mask-v1',width=scaled.width(),height=scaled.height(),
    indices_hex=indices.hex(),source_url='https://raw.githubusercontent.com/Xilinx/PYNQ/master/logo.png',
    source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
    adaptation='Official AMD PYNQ lockup geometry; AMD dark plum and PYNQ pink per user request.')
target=ROOT/'python/pynq_multimodal_game/data/pynq_wordmark.json'
target.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
(ROOT/'design/assets/provenance.json').write_text(json.dumps({source.name:{k:v for k,v in record.items()
    if k not in ('indices_hex','schema')}},indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(width=scaled.width(),height=scaled.height(),pixels=len(indices),source_sha256=record['source_sha256'])))
