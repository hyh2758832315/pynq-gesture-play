"""Exercise Studio from SSH-only board to project READY and content loading.

Run: .venv/Scripts/python.exe -B tools/studio_board_bootstrap_check.py --start
Outputs: build/studio-board-bootstrap/{result.json,ssh-only-*.png,ready.png}.
Next: open the regular desktop Studio; use the same installed-project button.
No motor actions, preview, input injection or synthetic board load is used.
The started project is normally stopped and its release receipt saved at exit.
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
os.environ['TEMP']=str(ROOT/'build');os.environ['TMP']=str(ROOT/'build')
from PySide6.QtCore import QSettings,Qt,QThread
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.studio import main_window
from pynq_multimodal_game.studio.device import DeviceState
from pynq_multimodal_game.studio.system_loader import SystemLoader
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--start',action='store_true')
    parser.add_argument('--output',type=Path,default=ROOT/'build/studio-board-bootstrap')
    args=parser.parse_args();out=args.output.resolve();out.mkdir(parents=True,exist_ok=False)
    app=QApplication(['PYNQ Studio']);app.setStyle('Fusion');app.setStyleSheet(STUDIO_STYLESHEET)
    main_window.QSettings=lambda:QSettings(str(out/'settings.ini'),QSettings.IniFormat)
    window=main_window.StudioMainWindow(agent_host='192.168.2.99',agent_port=8765,
        agent_source_address='192.168.2.1',agent_build_id=0xC0061000)
    window.setAttribute(Qt.WA_DontShowOnScreen,True);window.show()
    pane=window.load_workspace;window.select_workspace(window.workspace_stack.indexOf(pane))
    report=dict(result='RUNNING',hand_enabled=False,preview=False)
    started=None
    def wait(predicate,seconds):
        deadline=time.monotonic()+seconds;last=None
        while not predicate():
            app.processEvents();time.sleep(.03)
            if pane.status_label.text()!=last:
                last=pane.status_label.text();print(last,flush=True)
            if time.monotonic()>deadline:raise TimeoutError(pane.log.toPlainText())
    try:
        window.device_button.click()
        wait(lambda:window._board_info is not None,30)
        report['board']=window._board_info
        assert report['board']['ssh_ready'] and not report['board']['running']
        assert window.device.snapshot.state is not DeviceState.READY
        assert pane.system_candidate is None and pane.project_start_button.isEnabled()
        for width,height in ((1440,900),(1080,700)):
            window.resize(width,height);app.processEvents()
            assert window.width()==width
            window.grab().save(str(out/f'ssh-only-{width}.png'))
        if args.start:
            pane.project_start_button.click()
            assert pane.is_busy
            wait(lambda:not pane.is_busy,660)
            assert pane.last_receipt and pane.last_receipt['result']=='PASS',pane.log.toPlainText()
            started=pane.last_receipt
            report['start_receipt']=str(pane.output/'receipt.json')
            wait(lambda:window._display_snapshot.state is DeviceState.READY and not window._connection_pending,20)
            window.grab().save(str(out/'ready.png'))
            for index in range(pane.items.count()):
                item=pane.items.item(index)
                content=item.data(Qt.UserRole)
                item.setCheckState(Qt.Checked if content.kind=='game' and content.path.name=='game1' else Qt.Unchecked)
            assert len(pane.selected_items())==1
            pane.load_button.click();assert pane.is_busy
            wait(lambda:not pane.is_busy,300)
            assert pane.last_receipt and pane.last_receipt.get('status')=='complete',pane.log.toPlainText()
            report['content_receipt']=str(pane.output/'receipt.json')
        report['result']='PASS'
    except Exception as error:
        report.update(result='FAIL',error=str(error))
        raise
    finally:
        report['closed']=window.close();app.processEvents()
        if started:
            report['stop']=SystemLoader(window.device).remote('stop',started['transaction'],started['manifest_sha256'])
        report['active_qthreads']=[t.objectName() for t in window.findChildren(QThread) if t.isRunning()]
        (out/'result.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
        print(json.dumps(dict(result=report['result'],closed=report['closed'],output=str(out)),ensure_ascii=False),flush=True)


if __name__=='__main__':main()
