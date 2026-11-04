"""Verify real Studio reconnect, upload availability and default hand startup.

Run: .venv/Scripts/python.exe -B tools/studio_r48_connect_check.py --tag before-reboot
Outputs: build/studio-r48/<tag>.json and <tag>.png. No input injection or preview.
Next: repeat with --tag after-reboot after a normal, confirmed shutdown and reboot.
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
from pynq_multimodal_game.studio.device import DeviceState
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET
from pynq_multimodal_game.studio.single_instance import StudioSingleInstance, studio_server_name

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tag',choices=('before-reboot','after-reboot','after-restart'),required=True)
    parser.add_argument('--candidate',type=Path,default=ROOT/'build/ps-ui-r47-canvas-candidate-r33')
    parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r48')
    parser.add_argument('--allow-hand-wait',action='store_true',help='Accept OFF while awaiting a fresh real gesture after video')
    parser.add_argument('--persist-default-candidate',action='store_true',
                        help='Use desktop settings and remember this accepted system candidate')
    args=parser.parse_args();out=args.output.resolve();out.mkdir(exist_ok=True)
    app=QApplication(['PYNQ Studio']);app.setStyle('Fusion');app.setStyleSheet(STUDIO_STYLESHEET)
    instance=None
    if args.persist_default_candidate:
        app.setOrganizationName('Voice View Game')
        app.setApplicationDisplayName('PYNQ Studio')
        instance=StudioSingleInstance(studio_server_name(),lambda:None)
        if not instance.claim():
            raise RuntimeError('Desktop Studio is already open; no second window or settings change')
    else:
        main_window.QSettings=lambda:QSettings(str(out/'connect-settings.ini'),QSettings.IniFormat)
    window=main_window.StudioMainWindow(agent_host='192.168.2.99',agent_port=8765,
        agent_source_address='192.168.2.1',agent_build_id=0xC0061000)
    window.setAttribute(Qt.WA_DontShowOnScreen,True);window.show();window.resize(1440,900)
    pane=window.load_workspace;window.select_workspace(window.workspace_stack.indexOf(pane))
    pane.set_system_candidate(args.candidate)
    result=dict(result='RUNNING',tag=args.tag)
    if args.persist_default_candidate:
        window.settings.sync()
        stored=QSettings()
        assert Path(stored.value('content/system-candidate')).resolve()==args.candidate.resolve()
        result['desktop_settings']=dict(path=stored.fileName(),candidate=str(args.candidate.resolve()))
    started=time.monotonic()
    try:
        window.device_button.click()
        deadline=time.monotonic()+600;last=None
        while window._display_snapshot.state is not DeviceState.READY:
            app.processEvents();time.sleep(.03)
            label=window.device_label.text()
            if label!=last:print(label,flush=True);last=label
            if time.monotonic()>deadline:raise TimeoutError(window._display_snapshot.message)
        result['connected_after_seconds']=time.monotonic()-started
        print('Studio AGENT READY; checking startup cache once active',flush=True)
        deadline=time.monotonic()+60
        while True:
            status=window.device.video_status();result['startup_snapshot']=status
            snap=status['snapshot'];vision=snap.get('vision') or {};hand=vision.get('hand_session') or {}
            if snap.get('last_error') or vision.get('last_error') or hand.get('error'):
                raise RuntimeError('Startup fault')
            if hand.get('phase')=='ACTIVE' or (args.allow_hand_wait
                    and hand.get('phase') in ('RESUMING','WAITING_SOURCE','WAITING_SOURCE_OFF')
                    and hand.get('video_paused') is False):break
            if time.monotonic()>deadline:raise TimeoutError('Default hand not ACTIVE')
            for _ in range(50):app.processEvents();time.sleep(.04)
        assert hand['max_seconds'] is None and hand['approval_seconds']==3
        assert hand['preview_allowed'] is False and hand['preview_interlock'] is True
        result['library']=window.device.list_library()
        assert result['library']['ok']
        pane.refresh_contents();assert pane.items.count()>=3
        pane.items.item(0).setCheckState(Qt.CheckState.Checked);app.processEvents()
        assert pane.load_button.isEnabled() and pane.system_load_button.isEnabled()
        result.update(result='PASS',label=window.device_label.text(),content_load_enabled=True,
                      hand_default=True,input_injected=False,preview=False)
        window.grab().save(str(out/(args.tag+'.png')))
    except Exception as error:
        result.update(result='FAIL',error=str(error));raise
    finally:
        result['closed']=window.close();app.processEvents()
        result['active_qthreads']=[t.objectName() for t in window.findChildren(QThread) if t.isRunning()]
        if instance is not None:instance.close()
        (out/(args.tag+'.json')).write_text(json.dumps(result,indent=2,ensure_ascii=False),encoding='utf-8')
        print(json.dumps({k:v for k,v in result.items() if k not in ('startup_snapshot','library')},ensure_ascii=False))

if __name__=='__main__':main()

