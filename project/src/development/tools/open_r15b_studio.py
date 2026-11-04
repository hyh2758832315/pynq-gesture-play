"""Open the normal single-instance Studio with the verified R15b package selected.

Run: .venv/Scripts/pythonw.exe -B tools/open_r15b_studio.py
Output: one interactive Studio window; its persisted candidate points to R15b.
Next: normal camera switch/manual acceptance. No automatic preview or input.
"""
import os,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
os.environ['VOICE_VIEW_GAME_PROJECTS_ROOT']=str(ROOT/'games_gesture')
from PySide6.QtWidgets import QApplication
from PySide6.QtCore import QTimer
from pynq_multimodal_game.studio.main_window import StudioMainWindow
from pynq_multimodal_game.studio.single_instance import StudioSingleInstance,studio_server_name
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET

def main():
    # Match python -m ...studio.app so the desktop shortcut reads these settings.
    app=QApplication([str(ROOT/'python/pynq_multimodal_game/studio/app.py')]);app.setOrganizationName('Voice View Game')
    app.setApplicationDisplayName('PYNQ Studio');app.setStyle('Fusion');app.setStyleSheet(STUDIO_STYLESHEET)
    holder=[]
    def activate():
        if holder:holder[0].showNormal();holder[0].raise_();holder[0].activateWindow()
    instance=StudioSingleInstance(studio_server_name(),activate)
    if not instance.claim():return 0
    window=StudioMainWindow(agent_host='192.168.2.99',agent_port=8765,
        agent_source_address='192.168.2.1',agent_build_id=0xC0061000)
    holder.append(window)
    window.load_workspace.set_system_candidate(ROOT/'build/ps-ui-video-handoff-r15b')
    window.resize(1440,900);window.show();QTimer.singleShot(0,window._start_remote)
    try:return app.exec()
    finally:instance.close()

if __name__=='__main__':raise SystemExit(main())
