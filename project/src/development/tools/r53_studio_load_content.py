"""Load all six default items using the native Studio content-load button.

Run: .venv/Scripts/python.exe -B tools/r53_studio_load_content.py
Outputs: build/studio-r53/ui-content.json, native screenshot and Studio receipt.
Next: compare board library identities with the same validated packages.
No automatic game/video playback or physical hand commands.
"""
import json
import argparse
import os
from pathlib import Path
import sys
import time
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
os.environ['VOICE_VIEW_GAME_PROJECTS_ROOT']=str(ROOT/'games_gesture')
os.environ['TEMP']=os.environ['TMP']=str(ROOT/'build')
from PySide6.QtCore import QSettings,Qt,QThread
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.studio import main_window
from pynq_multimodal_game.studio.device import DeviceState
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r53')
    parser.add_argument('--games',nargs='+',help='Load only these game IDs through the same native selection UI')
    args=parser.parse_args()
    out=args.output.resolve();out.mkdir(exist_ok=True)
    app=QApplication(['PYNQ Studio']);app.setStyle('Fusion');app.setStyleSheet(STUDIO_STYLESHEET)
    main_window.QSettings=lambda:QSettings(str(out/'load-settings.ini'),QSettings.IniFormat)
    window=main_window.StudioMainWindow(agent_host='192.168.2.99',agent_port=8765,
        agent_source_address='192.168.2.1',agent_build_id=0xC0061000)
    window.setAttribute(Qt.WA_DontShowOnScreen,True);window.show();window.resize(1440,900)
    pane=window.load_workspace;window.select_workspace(window.workspace_stack.indexOf(pane))
    result=dict(result='RUNNING',native_ui=True,physical_board=True,preview=False)
    try:
        window.device_button.click();deadline=time.monotonic()+180
        while window._display_snapshot.state is not DeviceState.READY:
            app.processEvents();time.sleep(.03)
            if time.monotonic()>deadline:raise TimeoutError(window.device_label.text())
        for i in range(pane.items.count()):
            row=pane.items.item(i);content=row.data(Qt.ItemDataRole.UserRole)
            selected=args.games is None or (content.kind=='game' and content.path.name in args.games)
            row.setCheckState(Qt.CheckState.Checked if selected else Qt.CheckState.Unchecked)
        app.processEvents();assert len(pane.selected_items())==(6 if args.games is None else len(args.games))
        pane.load_button.click();assert pane.is_busy
        deadline=time.monotonic()+900;last=''
        while pane.is_busy:
            app.processEvents();time.sleep(.03)
            value=pane.status_label.text()
            if value!=last:print(value,flush=True);last=value
            if time.monotonic()>deadline:raise TimeoutError('Studio load still active')
        assert pane.last_receipt and pane.last_receipt['status']=='complete',pane.log.toPlainText()
        result.update(result='PASS',receipt=str(pane.output/'receipt.json'))
        window.grab().save(str(out/'loaded-content.png'))
    except BaseException as error:
        result.update(result='FAIL',error=str(error));raise
    finally:
        result['closed']=window.close();app.processEvents()
        result['active_qthreads']=[t.objectName() for t in window.findChildren(QThread) if t.isRunning()]
        (out/'ui-content.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
        (out/'ui-content-log.txt').write_text(pane.log.toPlainText(),encoding='utf-8')
        print(json.dumps(result),flush=True)

if __name__=='__main__':main()
