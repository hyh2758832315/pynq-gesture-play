"""Start this contest snapshot's native Studio; no upload or board start.

Run: python -B tools/start_studio.py [--smoke-test]
Output: one Studio window selecting board/runtime. Next: standard Studio load.
"""
import os
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'src/studio/python'))
os.environ['VOICE_VIEW_GAME_PROJECTS_ROOT'] = str(ROOT / 'src/studio/games_gesture')
from PySide6.QtCore import QSettings
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.studio.app import main

if __name__ == '__main__':
    app = QApplication([sys.executable])
    app.setOrganizationName('Voice View Game')
    QSettings().setValue('content/system-candidate', os.environ.get('PYNQ_RUNTIME', str(ROOT / 'board/runtime')))
    raise SystemExit(main(['PYNQ Studio', '--agent-host', '192.168.2.99',
        '--agent-port', '8765', '--agent-build-id', '0xC0061000',
        '--agent-source-address', '192.168.2.1', *sys.argv[1:]]))
