"""Verify native Studio start-button responsiveness against an existing Agent.

Run: .venv/Scripts/python.exe -B tools/studio_start_responsiveness_check.py
Outputs: build/studio-start-responsive-board/{result.json,busy.png,ready.png}.
Next: reopen the desktop Studio. Existing board PID must remain unchanged.
No motor action, preview, board stop or duplicate project launch is performed.
"""
import json
import os
from pathlib import Path
import sys
import time

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
os.environ['VOICE_VIEW_GAME_PROJECTS_ROOT']=str(ROOT/'games_gesture')
os.environ['TEMP']=str(ROOT/'build');os.environ['TMP']=str(ROOT/'build')
from PySide6.QtCore import QSettings,Qt,QThread,QTimer
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.studio import main_window
from pynq_multimodal_game.studio.system_loader import SystemLoader
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET


def main():
    out=ROOT/'build/studio-start-responsive-board';out.mkdir(exist_ok=False)
    app=QApplication(['PYNQ Studio']);app.setStyle('Fusion');app.setStyleSheet(STUDIO_STYLESHEET)
    main_window.QSettings=lambda:QSettings(str(out/'settings.ini'),QSettings.IniFormat)
    window=main_window.StudioMainWindow(agent_host='192.168.2.99',agent_port=8765,
        agent_source_address='192.168.2.1',agent_build_id=0xC0061000)
    window.setAttribute(Qt.WA_DontShowOnScreen,True);window.resize(1080,700);window.show()
    pane=window.load_workspace;window.select_workspace(window.workspace_stack.indexOf(pane))
    report=dict(result='RUNNING');samples=[]
    timer=QTimer();timer.setInterval(20)
    timer.timeout.connect(lambda:samples.append(time.monotonic()))
    try:
        loader=SystemLoader(window.device)
        before=loader.inspect();assert before['running'],'This test only attaches to an existing project'
        report['before']=before
        samples.append(time.monotonic());timer.start()
        pane.project_start_button.click()
        deadline=time.monotonic()+30;captured=False
        while pane.is_busy:
            app.processEvents();time.sleep(.005)
            if not captured:
                window.grab().save(str(out/'busy.png'));captured=True
            if time.monotonic()>deadline:raise TimeoutError('Native start button did not finish')
        timer.stop();samples.append(time.monotonic())
        report['gui_heartbeat_count']=len(samples)-2
        report['max_gui_gap_seconds']=max(b-a for a,b in zip(samples,samples[1:]))
        assert report['gui_heartbeat_count']>=3
        assert report['max_gui_gap_seconds']<.5
        assert pane.last_receipt and pane.last_receipt['result']=='PASS',pane.log.toPlainText()
        assert pane.last_receipt['already_running']
        report['receipt']=str(pane.output/'receipt.json')
        deadline=time.monotonic()+10
        while window._connection_pending:
            app.processEvents();time.sleep(.01)
            if time.monotonic()>deadline:raise TimeoutError('Receiver reconnect pending')
        window.grab().save(str(out/'ready.png'))
        after=loader.inspect();report['after']=after
        assert after['running'] and after['installed']==before['installed']
        report['result']='PASS'
    except Exception as error:
        report.update(result='FAIL',error=str(error));raise
    finally:
        timer.stop();report['closed']=window.close();app.processEvents()
        report['active_qthreads']=[t.objectName() for t in window.findChildren(QThread) if t.isRunning()]
        (out/'result.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
        print(json.dumps({k:v for k,v in report.items() if k not in ('before','after')},ensure_ascii=False))


if __name__=='__main__':main()
