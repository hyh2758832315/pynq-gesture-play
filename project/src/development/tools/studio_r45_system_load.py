"""Exercise the native Studio system loader; preview alone never accesses PYNQ.

Run: .venv/Scripts/python.exe -B tools/studio_r45_system_load.py [--deploy]
Outputs: build/studio-r45/native-*.png, ui-system.json and the Studio load receipt.
Next: use Studio's normal game/video API for board acceptance, then normal stop.
"""
from pathlib import Path
import argparse
import json
import os
import sys
import time

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
os.environ['VOICE_VIEW_GAME_PROJECTS_ROOT']=str(ROOT/'games_gesture')
os.environ['TEMP']=str(ROOT/'build');os.environ['TMP']=str(ROOT/'build')
from PySide6.QtCore import QSettings,Qt,QThread
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.studio import main_window
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--deploy',action='store_true')
    parser.add_argument('--live',action='store_true',help='One visible normal Studio window; skip layout checks')
    parser.add_argument('--candidate',type=Path,default=ROOT/'build/ps-ui-r45-pink-studio-candidate-r32')
    parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r45')
    args=parser.parse_args()
    out=args.output.resolve();out.mkdir(exist_ok=True)
    app=QApplication(['PYNQ Studio']);app.setStyle('Fusion');app.setStyleSheet(STUDIO_STYLESHEET)
    instance=None
    if args.live:
        from pynq_multimodal_game.studio.single_instance import StudioSingleInstance,studio_server_name
        app.setOrganizationName('Voice View Game');app.setApplicationDisplayName('PYNQ Studio')
        instance=StudioSingleInstance(studio_server_name(),lambda:None)
        if not instance.claim():raise RuntimeError('Studio is already open; no second window created')
    else:
        main_window.QSettings=lambda:QSettings(str(out/'ui-settings.ini'),QSettings.IniFormat)
    window=main_window.StudioMainWindow(agent_host='192.168.2.99',agent_port=8765,
        agent_source_address='192.168.2.1',agent_build_id=0xC0061000)
    window.setAttribute(Qt.WA_DontShowOnScreen,not args.live);window.show()
    pane=window.load_workspace
    window.select_workspace(window.workspace_stack.indexOf(pane))
    pane.set_system_candidate(args.candidate)
    report=dict(result='RUNNING',physical_board=args.deploy,native_ui=True,hand_enabled=False)
    try:
        for width,height in (() if args.live else ((1440,900),(1080,700))):
            window.resize(width,height);app.processEvents()
            window.grab().save(str(out/f'native-{width}.png'))
            assert pane.system_load_button.isEnabled()
            assert window.width()==width
        if args.deploy:
            pane.system_load_button.click()
            assert pane.is_busy
            deadline=time.monotonic()+1200;last=''
            while pane.is_busy and time.monotonic()<deadline:
                app.processEvents();time.sleep(.03)
                if pane.status_label.text()!=last:
                    last=pane.status_label.text();print(last,flush=True)
            assert not pane.is_busy,'System loader exceeded its bounded test window'
            assert pane.last_receipt and pane.last_receipt['result']=='PASS',pane.log.toPlainText()
            report['receipt']=str(pane.output/'receipt.json')
            window.grab().save(str(out/'native-loaded.png'))
        report['result']='PASS'
    except Exception as error:
        report.update(result='FAIL',error=str(error))
        if pane.output:report['receipt']=str(pane.output/'receipt.json')
        raise
    finally:
        (out/'ui-log.txt').write_text(pane.log.toPlainText(),encoding='utf-8')
        report['closed']=window.close();app.processEvents()
        report['active_qthreads']=[t.objectName() for t in window.findChildren(QThread) if t.isRunning()]
        if instance is not None:instance.close()
        (out/('ui-system.json' if args.deploy else 'ui-preview.json')).write_text(
            json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
        print(json.dumps(report,ensure_ascii=False),flush=True)

if __name__=='__main__':main()

