"""Select and run each visible PC example using Studio's actual test button.

Run: .venv/Scripts/python.exe -B tools/r53_pc_examples.py
Outputs: build/studio-r53/pc-examples.json and native game screenshots.
Next: rebuild the final bundle through Studio content preparation after edits.
No device connection or physical gesture injection.
"""
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
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET

def main():
    out=ROOT/'build/studio-r53';out.mkdir(exist_ok=True)
    app=QApplication(['PYNQ Studio'])
    app.setStyle('Fusion');app.setStyleSheet(STUDIO_STYLESHEET)
    main_window.QSettings=lambda:QSettings(str(out/'pc-settings.ini'),QSettings.IniFormat)
    window=main_window.StudioMainWindow(agent_build_id=0xC0061000)
    window.setAttribute(Qt.WA_DontShowOnScreen,True);window.show();window.resize(1440,900)
    game=window.game_workspace;window.select_workspace(window.workspace_stack.indexOf(game))
    result=dict(result='RUNNING',games=[])
    try:
        for game_id in ('game1','game2','game3','game4'):
            index=next(i for i in range(game.game_list.count()) if Path(
                game.game_list.item(i).data(Qt.ItemDataRole.UserRole)).name==game_id)
            game.game_list.setCurrentRow(index);app.processEvents()
            example=next(i for i in range(game.test_case_list.count())
                         if not game.test_case_list.item(i).isHidden() and game.test_case_list.item(i).text().startswith('PC示例'))
            game.test_case_list.setCurrentRow(example);app.processEvents()
            assert game.timeline_table.rowCount()>0 and game.assertion_table.rowCount()>0
            case=game.current_test_case()
            game.pc_test_button.click();app.processEvents()
            assert game._preview_thread is not None
            deadline=time.monotonic()+180
            while game._preview_thread is not None:
                app.processEvents();time.sleep(.02)
                if time.monotonic()>deadline:raise TimeoutError('PC example still active: '+game_id)
            report=game._last_pc_report
            assert report and report['status']=='passed',report
            result['games'].append(dict(game=game_id,case=case.name,events=len(case.events),
                                        assertions=len(case.assertions),status=report['status']))
            window.grab().save(str(out/(game_id+'-pc-example.png')))
            print(game_id+' PC example PASS',flush=True)
        result['result']='PASS'
    except BaseException as error:
        result.update(result='FAIL',error=str(error));raise
    finally:
        result['closed']=window.close();app.processEvents()
        result['active_qthreads']=[t.objectName() for t in window.findChildren(QThread) if t.isRunning()]
        (out/'pc-examples.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
        print(json.dumps(result,ensure_ascii=False),flush=True)

if __name__=='__main__':main()
