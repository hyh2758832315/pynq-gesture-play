"""Bounded offline canvas work/traffic comparison; never opens hardware.

Run: python tools/r49_canvas_benchmark.py --package <candidate> --output <json>
Output: JSON timing and resource-byte counts for 60 moving preview frames.
Next: compare the frozen baseline/candidate on the same interpreter, then
validate the Studio-installed candidate through the normal board entry.
"""
import argparse
import json
from pathlib import Path
import sys
import time
from types import SimpleNamespace

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--package',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True)
    args=p.parse_args()
    sys.path.insert(0,str(args.package.resolve()/'python'))
    from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
    from pynq_multimodal_game.menu import MenuPage
    class Sink:
        def __init__(self):self.uploads=0;self.resource_bytes=0;self.scenes=0
        def upload_asset(self,p):self.uploads+=1;self.resource_bytes+=len(p)
        def upload_palette(self,p):pass
        def upload_tilemap(self,p):pass
        def submit_scene(self,p):self.scenes+=1
    s=C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000),menu_fps=0)
    sink=Sink();s._sink=sink;s._select_page_locked(MenuPage.CANVAS)
    s._canvas.shape='star';s._canvas.size_index=5
    sink.uploads=sink.resource_bytes=sink.scenes=0
    started=time.process_time()
    for n in range(60):
        s._canvas.pointer=(35+n*3,70+(n%10)*3)
        s._feature_last_submit=-1
        s._submit_menu_frame_locked()
    result=dict(hardware_io=False,frames=60,cpu_seconds=time.process_time()-started,
                uploads=sink.uploads,resource_bytes=sink.resource_bytes,scenes=sink.scenes)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result))

if __name__=='__main__':main()
