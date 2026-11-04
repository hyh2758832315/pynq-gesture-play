"""Build and validate all six default items through native Studio controls.

Run: .venv/Scripts/python.exe -B tools/r53_studio_prepare.py
Outputs: build/studio-r53/prepare.json, native screenshots and Studio receipt.
Next: pass that receipt to build_deployment_candidate.py --studio-receipt.
This path never connects to the board or sends hardware commands.
"""
import argparse
import json
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
from pynq_multimodal_game.studio.default_content import default_video_paths
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r53')
    parser.add_argument('--games-only',action='store_true')
    args=parser.parse_args()
    out=args.output.resolve();out.mkdir(parents=True,exist_ok=True)
    app=QApplication(['PYNQ Studio']);app.setStyle('Fusion');app.setStyleSheet(STUDIO_STYLESHEET)
    main_window.QSettings=lambda:QSettings(str(out/'prepare-settings.ini'),QSettings.IniFormat)
    window=main_window.StudioMainWindow(agent_build_id=0xC0061000)
    window.setAttribute(Qt.WA_DontShowOnScreen,True);window.show();window.resize(1440,900)
    pane=window.load_workspace;window.select_workspace(window.workspace_stack.indexOf(pane))
    result=dict(result='RUNNING',native_ui=True,physical_board=False)
    try:
        assert len(window.video_workspace.source_paths)==2
        assert {i.path for i in pane.selected_items()}==set(default_video_paths())
        for i in range(pane.items.count()):
            item=pane.items.item(i)
            item.setCheckState(Qt.CheckState.Checked if not args.games_only or i<4 else Qt.CheckState.Unchecked)
        app.processEvents();assert len(pane.selected_items())==(4 if args.games_only else 6)
        window.grab().save(str(out/'prepare-before.png'))
        pane.prepare_button.click();assert pane.is_busy
        deadline=time.monotonic()+2400;last=''
        while pane.is_busy:
            app.processEvents();time.sleep(.03)
            status=pane.status_label.text()
            if status!=last:print(status,flush=True);last=status
            if time.monotonic()>deadline:raise TimeoutError('Studio preparation still active')
        assert pane.last_receipt and pane.last_receipt['status']=='validated',pane.log.toPlainText()
        records=pane.last_receipt['items']
        assert len(records)==(4 if args.games_only else 6) and len([r for r in records if r['kind']=='game'])==4
        assert all(r['tests'] and all(t['passed'] and t['assertions'] for t in r['tests'])
                   for r in records if r['kind']=='game')
        result.update(result='PASS',receipt=str(pane.output/'receipt.json'),items=len(records))
        window.grab().save(str(out/'prepare-after.png'))
        window.resize(1080,700);app.processEvents();window.grab().save(str(out/'prepare-1080.png'))
    except BaseException as error:
        result.update(result='FAIL',error=str(error));raise
    finally:
        result['closed']=window.close();app.processEvents()
        result['active_qthreads']=[t.objectName() for t in window.findChildren(QThread) if t.isRunning()]
        (out/'prepare.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
        (out/'prepare-log.txt').write_text(pane.log.toPlainText(),encoding='utf-8')
        print(json.dumps(result),flush=True)

if __name__=='__main__':main()
