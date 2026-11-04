"""Start the bundled Studio with this release's exact complete system selected.

Run: studio/.venv/Scripts/python.exe -B start_studio.py
Output: one native Studio window; no automatic upload/preview/motor test.
Next: use normal Studio system/content loading buttons.
"""
import os
from pathlib import Path
import sys
from restore_assets import restore
ROOT=Path(__file__).resolve().parent
if __name__=='__main__':
    restore();sys.path.insert(0,str(ROOT/'studio/python'))
    os.environ['VOICE_VIEW_GAME_PROJECTS_ROOT']=str(ROOT/'studio/games_gesture')
    from PySide6.QtWidgets import QApplication
    from PySide6.QtCore import QSettings
    from pynq_multimodal_game.studio.app import main
    app=QApplication([sys.executable]);app.setOrganizationName('Voice View Game')
    QSettings().setValue('content/system-candidate',str(ROOT/'board_runtime'))
    raise SystemExit(main(['PYNQ Studio','--agent-host','192.168.2.99','--agent-port','8765',
        '--agent-build-id','0xC0061000','--agent-source-address','192.168.2.1',*sys.argv[1:]]))
