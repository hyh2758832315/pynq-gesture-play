"""Smoke the portable release launcher with isolated settings and no board.

Run: .venv/Scripts/python.exe -B tools/v3_snapshot_studio_smoke.py
Output: build/studio-v3/snapshot-launcher.json. Next: seal after acceptance.
"""
import json
import os
from pathlib import Path
import runpy
import sys
ROOT=Path(__file__).resolve().parents[1];out=ROOT/'build/studio-v3/snapshot-settings';out.mkdir(parents=True,exist_ok=True)
release=ROOT/'build/v3-release-repo/releases/v3.0'
os.environ['QT_QPA_PLATFORM']='offscreen'
os.environ['TEMP']=os.environ['TMP']=str(ROOT/'build')
from PySide6.QtCore import QSettings
QSettings.setDefaultFormat(QSettings.Format.IniFormat)
QSettings.setPath(QSettings.Format.IniFormat,QSettings.Scope.UserScope,str(out))
sys.path.insert(0,str(release));sys.argv=[str(release/'start_studio.py'),'--smoke-test']
try:runpy.run_path(sys.argv[0],run_name='__main__')
except SystemExit as result:assert result.code in (0,None)
settings=QSettings();settings.sync()
assert Path(settings.value('content/system-candidate')).resolve()==(release/'board_runtime').resolve()
import pynq_multimodal_game
assert Path(pynq_multimodal_game.__file__).resolve().is_relative_to(release/'studio/python')
result=dict(result='PASS',source=pynq_multimodal_game.__file__,settings=settings.fileName(),
            candidate=settings.value('content/system-candidate'),physical_board=False)
(ROOT/'build/studio-v3/snapshot-launcher.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(result))
