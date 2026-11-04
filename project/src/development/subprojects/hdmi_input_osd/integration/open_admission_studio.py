"""Open an owned native Studio window using the frozen R20 implementation.

Run with project .venv Python, -B; output: build/hosd/c0e/r20-studio-r01/.
Opens Agent observer and HTTP camera subscription; never issues VISION_START.
The window remains available after 120 seconds of bounded local telemetry.
"""
import hashlib
import argparse
import json
import os
from pathlib import Path
import sys
import time

REPO = Path(__file__).resolve().parents[3]
ROOT = REPO / 'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--run-id', default='r01', choices=('r01','r02'))
    args = parser.parse_args()
    OUT = REPO / ('build/hosd/c0e/r20-studio-' + args.run_id)
    manifest = json.loads((ROOT / 'deployment_manifest.json').read_text(encoding='utf-8'))
    for name, digest in manifest['sha256'].items():
        assert hashlib.sha256((ROOT / name).read_bytes()).hexdigest().upper() == digest
    OUT.mkdir(parents=True, exist_ok=False)
    os.environ['QT_QPA_PLATFORM'] = 'windows'
    sys.path.insert(0, str(ROOT / 'python'))
    from PySide6.QtCore import QTimer
    from PySide6.QtGui import QFont
    from PySide6.QtWidgets import QApplication
    from pynq_multimodal_game.studio.main_window import StudioMainWindow
    from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET
    app = QApplication([sys.argv[0]])
    app.setApplicationDisplayName('Voice View Studio')
    app.setOrganizationName('Voice View Game')
    font = QFont('Bahnschrift', 10)
    font.setFamilies(['Bahnschrift','Microsoft YaHei UI','Noto Sans CJK SC'])
    app.setFont(font)
    app.setStyleSheet(STUDIO_STYLESHEET)
    window = StudioMainWindow(agent_host='192.168.2.99',agent_port=8765,
                              agent_source_address='192.168.2.1',agent_build_id=0xC0060E00)
    window.setWindowTitle('Voice View Studio — R20 实板回传')
    window.show()
    window.select_workspace(0)
    window.toggle_device()
    window.vision_workspace.start_camera()
    started = time.monotonic()
    count = 0
    timer = QTimer(window)

    def capture():
        nonlocal count
        count += 1
        view = window.vision_workspace
        row = dict(elapsed_s=time.monotonic()-started,pid=os.getpid(),visible=window.isVisible(),
                   device_state=window.device.snapshot.state.value,
                   device_message=window.device.snapshot.message,camera=window.camera_status.text(),
                   frames=view.frames_value.text(),ui_age=view.latency_value.text(),
                   rendered=view._rendered,stream_status=view.stream_status.text())
        with (OUT/'telemetry.jsonl').open('a',encoding='utf-8') as output:
            output.write(json.dumps(row,ensure_ascii=False)+'\n')
        if count in (2,6,12):
            assert window.grab().save(str(OUT/f'studio-{count*10:03}.png'))
        if count >= 12:
            timer.stop()
    timer.timeout.connect(capture)
    timer.start(10000)
    (OUT/'started.json').write_text(json.dumps(dict(pid=os.getpid(),root=str(ROOT),build_id='0xC0060E00',
         http_url='http://192.168.2.99:8081/camera.mjpg',started_unix=time.time())),encoding='utf-8')
    return app.exec()


if __name__ == '__main__':
    raise SystemExit(main())
