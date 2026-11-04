"""Compare R60 and v2 canvas CPU work without opening any hardware.

Run: .venv/Scripts/python.exe -B tools/v2_canvas_benchmark.py
Output: build/studio-v2/canvas-benchmark.json. Next: actual GPU acceptance.
"""
import importlib.util
import json
from pathlib import Path
import statistics
import sys
import time

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'subprojects/ps_ui_r23b2/python'))
from pynq_multimodal_game import creative_pages as current

old_path=ROOT/'build/ps-ui-r60-hud-canvas-candidate-r09/python/pynq_multimodal_game/creative_pages.py'
spec=importlib.util.spec_from_file_location('pynq_multimodal_game._canvas_r60',old_path)
old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)

def measure(module):
    p=module.CanvasPage();p.shape='star';r=module.PixelPageRenderer()
    r.compile_canvas(p,0,3)
    result={}
    for kind in ('hover','paint'):
        times=[];uploads=0;previous=None
        cpu_begin=time.process_time_ns()
        for n in range(120):
            if kind=='hover':p._choices._hovered_id=module.SHAPES[n%4]
            else:
                module.stamp(p.pixels,'star',16,20+n%215,80,6,stride=256)
                p.revision+=1
            begin=time.perf_counter_ns()
            frame=r.compile_canvas(p,n+1,3)
            if frame.assets[0].pixels!=previous:
                r.pack_assets(frame,3);uploads+=1
            previous=frame.assets[0].pixels
            times.append((time.perf_counter_ns()-begin)/1e6)
        result[kind]=dict(median_elapsed_ms=statistics.median(times),
                          max_elapsed_ms=max(times),total_cpu_ms=(time.process_time_ns()-cpu_begin)/1e6,
                          uploads=uploads,frames=len(times))
    return result

report=dict(scope='PC CPU only; same interpreter; no GPU/network',R60=measure(old),v2=measure(current))
out=ROOT/'build/studio-v2';out.mkdir(exist_ok=True)
(out/'canvas-benchmark.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps(report))
