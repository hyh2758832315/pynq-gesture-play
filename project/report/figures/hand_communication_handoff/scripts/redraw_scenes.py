"""Redraw plates 01-03 using PySide6, without any runtime or hardware access.

Run from the handoff root: python scripts/redraw_scenes.py
Outputs: generated/{01_logic,02_sequence,03_packet}.{svg,png,pdf,drawio}.
Next: inspect the images, then place the vectors into your final document.
"""
from pathlib import Path
import importlib.util
import json
import os
from PySide6.QtGui import QGuiApplication, QFontDatabase

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('renderer',ROOT/'scripts/render_scene.py')
renderer=importlib.util.module_from_spec(spec)
spec.loader.exec_module(renderer)
app=QGuiApplication([])
if os.name=='nt':
    for f in ['msyh.ttc','msyhbd.ttc','arial.ttf']:
        QFontDatabase.addApplicationFont('C:/Windows/Fonts/'+f)
out=ROOT/'generated'
out.mkdir(exist_ok=True)
for name in ('01_logic','02_sequence','03_packet'):
    scene=json.loads((ROOT/'figures'/f'{name}.json').read_text(encoding='utf-8'))
    renderer.render(scene,out/name)
