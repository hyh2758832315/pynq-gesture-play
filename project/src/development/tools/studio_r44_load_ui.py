"""Drive the actual native Studio load button against the idle, authorized board.

Run: .venv/Scripts/python.exe -B tools/studio_r44_load_ui.py
Outputs: build/studio-r44/ui-load.json, native PNG and the loader's receipt.json.
Next: exercise the installed items through the same RemoteDeviceSession API.
"""
from pathlib import Path
import json
import os
import sys
import time

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
os.environ['VOICE_VIEW_GAME_PROJECTS_ROOT']=str(ROOT/'games_gesture')
os.environ['TEMP']=str(ROOT/'build');os.environ['TMP']=str(ROOT/'build')
from PySide6.QtCore import Qt,QSettings,QThread
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.studio import main_window
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET
from pynq_multimodal_game.studio.device import DeviceState

def main():
    output=ROOT/'build/studio-r44'
    app=QApplication(['Studio content acceptance'])
    app.setStyle('Fusion');app.setStyleSheet(STUDIO_STYLESHEET)
    main_window.QSettings=lambda:QSettings(str(output/'ui-settings.ini'),QSettings.IniFormat)
    win=main_window.StudioMainWindow(agent_host='192.168.2.99',agent_port=8765,
        agent_source_address='192.168.2.1',agent_build_id=0xC0061000)
    win.setAttribute(Qt.WA_DontShowOnScreen,True)
    win.show()
    report=dict(physical_board=True,ui_loader=True,hand_enabled=False,result='RUNNING')

    def until(predicate,seconds):
        deadline=time.monotonic()+seconds
        while not predicate() and time.monotonic()<deadline:
            app.processEvents();time.sleep(.02)
        assert predicate(), win.load_workspace.status_label.text()

    try:
        win.device_button.click()
        until(lambda:win.device.snapshot.state is DeviceState.READY,30)
        report['connection']=win.device.snapshot.message
        win.game_workspace.test_case_list.setCurrentRow(1)
        videos=sorted((output/'videos').glob('*.mp4'))
        assert len(videos)==4
        win.video_workspace.add_sources(videos)
        assert set(win.video_workspace.source_paths)==set(videos)
        pane=win.load_workspace
        win.select_workspace(win.workspace_stack.indexOf(pane))
        pane.refresh_contents()
        for index in range(pane.items.count()):
            pane.items.item(index).setCheckState(Qt.Checked)
        assert len(pane.selected_items())==7
        until(lambda:pane.load_button.isEnabled(),5)
        win.grab().save(str(output/'ui-before-load.png'))
        pane.load_button.click()
        assert pane.is_busy
        until(lambda:not pane.is_busy,600)
        assert pane.last_receipt and pane.last_receipt['status']=='complete', pane.log.toPlainText()
        report.update(result='PASS',receipt=str(pane.output/'receipt.json'),items=len(pane.last_receipt['items']))
        win.grab().save(str(output/'ui-after-load.png'))
        (output/'ui-log.txt').write_text(pane.log.toPlainText(),encoding='utf-8')
    except Exception as error:
        report.update(result='FAIL',error=str(error))
        if win.load_workspace.output:report['receipt']=str(win.load_workspace.output/'receipt.json')
        raise
    finally:
        report['closed']=win.close()
        app.processEvents()
        report['active_qthreads']=[t.objectName() for t in win.findChildren(QThread) if t.isRunning()]
        (output/'ui-load.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
        print(json.dumps(report,ensure_ascii=False),flush=True)


if __name__ == '__main__':
    main()
