"""Offline native Qt screenshots, isolated settings, no board or HTTP session.

Run: .venv/Scripts/python.exe -B tools/capture_studio_pink.py --output build/studio-pink-native
Outputs: default/minimum screenshots and receipt.json (synthetic image clearly identified).
Next: inspect screenshots; load the separate candidate only during a later board session.
"""
import argparse
import json
import os
from pathlib import Path
import socket
import sys
import time
from unittest.mock import patch

os.environ['QT_QPA_PLATFORM'] = 'windows'
ROOT = Path(__file__).resolve().parents[1]
sys.path[:0] = [str(ROOT / 'python'), str(ROOT / 'tests')]
os.environ['VOICE_VIEW_GAME_PROJECTS_ROOT'] = str(ROOT / 'games_gesture')

from PySide6.QtCore import QSettings, QThread, Qt
from PySide6.QtGui import QFont, QImage
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.studio import main_window
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET
from pynq_multimodal_game.studio.vision_receiver import VisionResultReceiver
from pynq_multimodal_game.vision_preview_render import camera_geometry, six_panel
from test_studio_brand_preview import diagnostic_fixture, packet


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    app = QApplication([])
    font = QFont('Bahnschrift', 10)
    font.setFamilies(['Bahnschrift', 'Microsoft YaHei UI', 'Noto Sans CJK SC'])
    app.setFont(font)
    app.setStyleSheet(STUDIO_STYLESHEET)
    report = dict(board_access=False, network_access=False, input='synthetic/offline', captures=[])
    with patch.object(main_window, 'QSettings', lambda: QSettings(str(output/'settings.ini'), QSettings.IniFormat)), \
         patch.object(socket, 'create_connection', side_effect=AssertionError('offline capture')):
        window = main_window.StudioMainWindow(agent_build_id=0xC0061000)
        window.setAttribute(Qt.WidgetAttribute.WA_DontShowOnScreen, True)
        window.show()
        page = window.vision_workspace
        raw, result, control = diagnostic_fixture()

        def qimage(bgr):
            rgb = bgr[:, :, ::-1].copy()
            return QImage(rgb.data, rgb.shape[1], rgb.shape[0], rgb.strides[0], QImage.Format.Format_RGB888).copy()

        page._preview_image = qimage(camera_geometry(raw, result))
        page._debug_sheet = qimage(six_panel(result, control, 17))
        page._debug_received_at = time.monotonic()
        page._debug_message = ''
        receiver = VisionResultReceiver()
        fresh = receiver.consume(packet(frame=17), 1)
        for width, height in ((1440, 900), (1080, 700)):
            window.resize(width, height)
            for name in ('game', 'video', 'load', 'vision', 'processing', 'historical'):
                workspace = getattr(window, f'{name}_workspace') if name in ('game', 'video', 'load') else page
                window.select_workspace(window.workspace_stack.indexOf(workspace))
                if workspace is page:
                    page.vision_views.setCurrentRow(5 if name == 'processing' else 0)
                    page._show_vision_view()
                    page.canvas_source.setText('离线合成样例 / 仅检查界面布局')
                    page._result_snapshot = receiver.expire(2.3) if name == 'historical' else fresh
                    page._render_result(True if name != 'historical' else False)
                app.processEvents()
                path = output / f'{name}-{width}x{height}.png'
                assert window.grab().save(str(path))
                assert window.size().width() == width
                report['captures'].append(str(path))
        report['closed'] = window.close()
        app.processEvents()
        report['active_qthreads'] = [t.objectName() for t in window.findChildren(QThread) if t.isRunning()]
        assert report['closed'] and not report['active_qthreads']
    (output/'receipt.json').write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps(report, ensure_ascii=False))


if __name__ == '__main__':
    main()
