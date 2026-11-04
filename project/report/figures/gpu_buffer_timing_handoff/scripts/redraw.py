"""Redraw all GPU plates from editable scenes, without hardware access.

Run: python scripts/redraw.py
Requires PySide6. Outputs generated/*.svg, *.png, *.pdf, *.drawio.
Next: inspect text/connector layout and edit vectors for report/poster/video.
"""
from pathlib import Path
import importlib.util,json,os
from PySide6.QtGui import QGuiApplication,QFontDatabase
ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('renderer',ROOT/'scripts/render_scene.py')
renderer=importlib.util.module_from_spec(spec);spec.loader.exec_module(renderer)
app=QGuiApplication([])
if os.name=='nt':
    for name in ('msyh.ttc','msyhbd.ttc','arial.ttf'):QFontDatabase.addApplicationFont('C:/Windows/Fonts/'+name)
out=ROOT/'generated';out.mkdir(exist_ok=True)
for path in sorted((ROOT/'figures').glob('0*.json')):
    renderer.render(json.loads(path.read_text(encoding='utf-8')),out/path.stem)
