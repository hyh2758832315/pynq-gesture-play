"""Offline render and CPU budget sample; no PYNQ or motor access.

Run with PYTHONPATH=subprojects/ps_ui_r23b2/python:
  .venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/preview_creative_pages.py
Outputs: build/r43-creative-preview/{canvas,canvas-empty,canvas-return,gesture-show}.png
and budget.json. Next: inspect PNGs and run test_creative_pages.py.
"""
import json
import argparse
from pathlib import Path
import statistics
import time
from PySide6.QtGui import QImage,QPainter
from pynq_multimodal_game.creative_pages import (
    CanvasPage,PixelPageRenderer,robot_frame,stamp,SHAPES,COLORS)
from pynq_multimodal_game.scene_compiler import CommandRenderer

ROOT=Path(__file__).resolve().parents[3]
def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,default=ROOT/'build/r43-creative-preview')
    out=parser.parse_args().output;out.mkdir(parents=True,exist_ok=True)
    geometry=json.loads((Path(__file__).parents[1]/'python/pynq_multimodal_game/data/demo_geometry.json').read_text())
    renderer=PixelPageRenderer();cpu=CommandRenderer()
    def image(pixels):
        return QImage(cpu.render(renderer.compile(pixels,1,1)),320,180,960,QImage.Format_RGB888).copy()
    canvas=CanvasPage()
    image(canvas.render()).scaled(1280,720).save(str(out/'canvas-empty.png'))
    for i,shape in enumerate(SHAPES):
        canvas.shape=shape;canvas.size_index=i+2;canvas.pointer=(60+i*50,55+i*22)
        stamp(canvas.pixels,shape,canvas.size,*canvas.pointer,COLORS[i],stride=256)
    canvas.revision=1;canvas.pointer=(95,135)
    image(canvas.render()).scaled(1280,720).save(str(out/'canvas.png'))
    canvas.dialog=True;canvas.dialog_target='clear'
    image(canvas.render()).scaled(1280,720).save(str(out/'canvas-return.png'))
    atlas=QImage(1280,540,QImage.Format_RGB888);painter=QPainter(atlas)
    for i,key in enumerate(geometry):
        painter.drawImage((i%4)*320,(i//4)*180,image(robot_frame(key,'PLAYING',i,geometry)))
    painter.end();atlas.scaled(1920,810).save(str(out/'gesture-show.png'))
    canvas.dialog=False;samples=[]
    for i in range(81):
        canvas.pointer=(40+i%150,80)
        began=time.perf_counter()
        frame=renderer.compile(canvas.render(),i,1)
        packet=renderer.pack_assets(frame,1)
        if i: samples.append((time.perf_counter()-began)*1000)
    report=dict(pc_only=True,samples=len(samples),render_pack_median_ms=statistics.median(samples),
                render_pack_max_ms=max(samples),packet_bytes=len(packet),canvas_bytes=len(canvas.pixels),
                command_count=len(frame.commands),max_fps=15,
                arm_budget_measured=False)
    (out/'budget.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report))

if __name__=='__main__':main()
