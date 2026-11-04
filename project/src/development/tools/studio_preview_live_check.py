"""Native Studio preview acceptance; real camera only, no synthetic game input.

Run: .venv/Scripts/python.exe -B tools/studio_preview_live_check.py --candidate PACKAGE --output NEW_DIR
Output: NEW_DIR/preview.json and native-preview.png. Opens one normal Studio window
for two minutes, then closes preview and the client; never starts/stops the board.
Next: inspect HDMI/hand feedback, then use the normal Studio system stop action.
"""
import argparse,json,sys,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from PySide6.QtCore import QSettings,QThread,QTimer
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.studio.main_window import StudioMainWindow
from pynq_multimodal_game.studio.single_instance import StudioSingleInstance,studio_server_name
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--candidate',type=Path,required=True)
    parser.add_argument('--seconds',type=float,default=120)
    parser.add_argument('--startup-timeout',type=float,default=600)
    args=parser.parse_args()
    out=args.output.resolve();out.mkdir(parents=True,exist_ok=False)
    app=QApplication(['python']);app.setOrganizationName('Voice View Game')
    app.setApplicationDisplayName('PYNQ Studio');app.setStyle('Fusion');app.setStyleSheet(STUDIO_STYLESHEET)
    instance=StudioSingleInstance(studio_server_name(),lambda:None)
    if not instance.claim():raise RuntimeError('Existing Studio window retained; no second window opened')
    window=StudioMainWindow(agent_host='192.168.2.99',agent_port=8765,
        agent_source_address='192.168.2.1',agent_build_id=0xC0061000)
    window.resize(1440,900);window.select_workspace(0);window.show()
    window.load_workspace.set_system_candidate(args.candidate)
    page=window.vision_workspace
    report=dict(schema='studio-preview-live-v1',synthetic_inputs=False,
        board_probes=False,phase='connecting',samples=[])
    began=time.monotonic();start=None;last_frames=0;last_at=None;stopping=False
    def save():
        (out/'preview.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
    def poll():
        nonlocal start,last_frames,last_at,stopping
        now=time.monotonic()
        if start is None:
            if window.device.snapshot.state.value=='ready':
                page.start_camera();start=now;last_at=now
                report['phase']='preview';save();print('PREVIEW_STARTED: real camera, hand follows; HDMI should show PAUSED',flush=True)
            elif now-began>args.startup_timeout:
                report.update(phase='failed',error='Agent not READY');save();window.close()
            return
        worker=page._camera_worker
        frames=getattr(worker,'_frames',last_frames)
        elapsed=now-start
        if last_at is not None and now-last_at>=1:
            fps=(frames-last_frames)/(now-last_at)
            report['samples'].append(dict(seconds=round(elapsed,2),frames=frames,fps=round(fps,2),
                displayed=page.image_fps_value.text()))
            last_frames,last_at=frames,now
            if len(report['samples'])%10==0:
                window.grab().save(str(out/'native-preview.png'))
                print(json.dumps(report['samples'][-1]),flush=True)
            save()
        if not stopping and elapsed>=args.seconds:
            stopping=True;timer.stop();page.stop_camera(wait=True)
            report.update(phase='preview_closed',frames=frames,elapsed_seconds=round(elapsed,2))
            save();print('PREVIEW_CLOSED: original HDMI page should resume',flush=True)
            QTimer.singleShot(3000,window.close)
    timer=QTimer();timer.timeout.connect(poll);timer.start(200)
    window._start_remote()
    try:app.exec()
    finally:
        timer.stop();window.close();app.processEvents();instance.close()
        report['active_qthreads']=[t.objectName() for t in window.findChildren(QThread) if t.isRunning()]
        report['closed']=not window.isVisible();save()
        print(json.dumps({k:v for k,v in report.items() if k!='samples'}),flush=True)


if __name__=='__main__':main()
