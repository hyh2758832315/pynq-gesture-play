"""Render single-button startup states without network or board actions.

Run: .venv/Scripts/python.exe -B tools/studio_unified_start_preview.py
Output: build/studio-unified-start-native/*.png and receipt.json.
Next: package these UI changes; no live Studio or PYNQ process is changed.
"""
import json,os,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
os.environ['VOICE_VIEW_GAME_PROJECTS_ROOT']=str(ROOT/'games_gesture')
os.environ['TEMP']=os.environ['TMP']=str(ROOT/'build')
from PySide6.QtCore import QSettings,Qt,QThread
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.studio import main_window
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET

out=ROOT/'build/studio-unified-start-native';out.mkdir(exist_ok=True)
app=QApplication(['ui-preview']);app.setStyle('Fusion');app.setStyleSheet(STUDIO_STYLESHEET)
main_window.QSettings=lambda:QSettings(str(out/'settings.ini'),QSettings.IniFormat)
window=main_window.StudioMainWindow(agent_host='192.0.2.1',agent_build_id=0xC0061000)
window.setAttribute(Qt.WA_DontShowOnScreen,True);window.show()
window.select_workspace(window.workspace_stack.indexOf(window.load_workspace))
states=dict(checking=dict(loader_busy=True),
    loading=dict(running=True,startup_stage='内容库初始化'),
    failed=dict(service={'ActiveState':'failed','Result':'exit-code'}),
    stopped=dict(running=False))
images=[]
try:
    for width,height in ((1440,900),(1080,700)):
        for name,info in states.items():
            window.device.fail('simulated: Agent not yet ready')
            window._on_board_info(dict(ssh_ready=True,installed={'root':'sample'},**info))
            window.resize(width,height);app.processEvents()
            assert window.width()==width
            assert not hasattr(window.load_workspace,'field_start_button')
            path=out/f'simulated-{name}-{width}.png';window.grab().save(str(path));images.append(path.name)
finally:
    closed=window.close();app.processEvents()
    active=[t.objectName() for t in window.findChildren(QThread) if t.isRunning()]
    report=dict(result='PASS',simulated=True,board_access=False,network_access=False,
                closed=closed,active_qthreads=active,images=images)
    assert not active
    (out/'receipt.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
    print(json.dumps(report))
