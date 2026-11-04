"""Test fixtures use the same Studio content pipeline as normal authoring."""
from pathlib import Path
import shutil
import subprocess
import sys
import os
import json
from tempfile import TemporaryDirectory
from types import SimpleNamespace
from .tools.build_deployment_candidate import GAME_DISPLAY_NAMES,stage_gesture_project


def build_bundled_games(output):
    from .tools.build_deployment_candidate import ROOT
    output=Path(output);output.mkdir(parents=True,exist_ok=True)
    with TemporaryDirectory(dir=output) as folder:
        projects=[]
        for game_id in GAME_DISPLAY_NAMES:
            path=Path(folder)/game_id;stage_gesture_project(game_id,path,include_tests=True)
            projects.append((str(path),GAME_DISPLAY_NAMES[game_id]))
        # A fresh PC process keeps the full Studio framework separate from the
        # intentionally older board-only module overrides in this test process.
        code="""import json,sys
from pathlib import Path
from types import SimpleNamespace
from pynq_multimodal_game.studio.content_pipeline import ContentItem,load_content
load_content([ContentItem('game',Path(p),n) for p,n in json.loads(sys.argv[1])],
             SimpleNamespace(expected_build_id=0xC0061000),Path(sys.argv[2]),prepare_only=True)
"""
        environment=os.environ.copy();environment['PYTHONPATH']=str(ROOT/'python')
        subprocess.run([sys.executable,'-B','-c',code,json.dumps(projects),str(output/'studio-prepared')],
                       cwd=ROOT,env=environment,check=True,timeout=180,capture_output=True)
        receipt=json.loads((output/'studio-prepared/receipt.json').read_text(encoding='utf-8'))
    (output/'seed_games').mkdir(exist_ok=True)
    for item in receipt['items']:
        shutil.copy2(item['package'],output/'seed_games'/(item['item_id']+'.vvg'))
