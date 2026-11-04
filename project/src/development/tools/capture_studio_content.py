"""Offline native Studio smoke and screenshots; no PYNQ access.

Run: .venv/Scripts/python.exe tools/capture_studio_content.py --output build/studio-content-native
Outputs: screenshots at 1440x900/1080x700, settings.ini, receipt.json.
Next: inspect Game, Video, Vision and Load screenshots at both sizes.
"""
import argparse
import json
import os
from pathlib import Path
import socket
import sys
from unittest.mock import patch

os.environ["QT_QPA_PLATFORM"] = "windows"
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))
os.environ["VOICE_VIEW_GAME_PROJECTS_ROOT"] = str(ROOT / "games_gesture")

from PySide6.QtCore import QSettings, QThread, Qt
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.studio import main_window, qt_app


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    report = {"network_access": False, "captures": []}
    original = main_window.StudioMainWindow

    class Capture(original):
        def __init__(self, *args, **kwargs):
            super().__init__(*args, **kwargs)
            self.setAttribute(Qt.WidgetAttribute.WA_DontShowOnScreen, True)

        def close(self):
            for name, workspace in (("game", self.game_workspace), ("video", self.video_workspace),
                                    ("vision", self.vision_workspace), ("load", self.load_workspace)):
                self.select_workspace(self.workspace_stack.indexOf(workspace))
                for width, height in ((1440, 900), (1080, 700)):
                    self.resize(width, height)
                    QApplication.processEvents()
                    path = output / f"{name}-{width}x{height}.png"
                    assert self.grab().save(str(path))
                    assert (self.width(), self.height()) == (width, height)
                    report["captures"].append(str(path))
            accepted = super().close()
            QApplication.processEvents()
            report["closed"] = accepted
            report["active_qthreads"] = [t.objectName() for t in self.findChildren(QThread) if t.isRunning()]
            report["background_timer_active"] = self._background_timer.isActive()
            return accepted

    with patch.object(qt_app, "StudioMainWindow", Capture), patch.object(
        main_window, "QSettings", lambda: QSettings(str(output / "settings.ini"), QSettings.IniFormat)
    ), patch.object(socket, "create_connection", side_effect=AssertionError("OFFLINE: no network")):
        assert qt_app.run_studio(["studio", "--smoke-test", "--agent-build-id", "0xC0061000"]) == 0
    assert report["closed"] and not report["active_qthreads"] and not report["background_timer_active"]
    (output / "receipt.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps(report))


if __name__ == "__main__":
    main()
