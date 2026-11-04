from __future__ import annotations

import argparse
import sys
from collections.abc import Sequence

from PySide6.QtGui import QFont
from PySide6.QtWidgets import QApplication

from .main_window import StudioMainWindow
from .single_instance import StudioSingleInstance, studio_server_name
from .theme import STUDIO_STYLESHEET


def run_studio(arguments: Sequence[str] | None = None) -> int:
    application_arguments = list(arguments) if arguments is not None else list(sys.argv)
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--smoke-test", action="store_true")
    parser.add_argument("--camera-preview", action="store_true")
    parser.add_argument("--agent-host")
    parser.add_argument("--agent-port", type=int, default=8765)
    parser.add_argument("--agent-build-id", type=lambda value: int(value, 0),
                        choices=(0xC0060700, 0xC0060800, 0xC0060900, 0xC0060C00, 0xC0061000), default=0xC0060700)
    parser.add_argument("--agent-source-address")
    parser.add_argument("--volume-monitor")
    parser.add_argument("--volume-source-address")
    options, qt_arguments = parser.parse_known_args(application_arguments[1:])
    if options.agent_build_id == 0xC0061000 and options.volume_monitor:
        parser.error("the button candidate has no audio monitor")
    application_arguments = [application_arguments[0], *qt_arguments]
    existing = QApplication.instance()
    app = existing if isinstance(existing, QApplication) else QApplication(application_arguments)
    app.setApplicationDisplayName("PYNQ Studio")
    app.setOrganizationName("Voice View Game")
    font = QFont("Bahnschrift", 10)
    font.setFamilies(["Bahnschrift", "Microsoft YaHei UI", "Noto Sans CJK SC"])
    app.setFont(font)
    app.setStyleSheet(STUDIO_STYLESHEET)
    window: StudioMainWindow | None = None
    instance: StudioSingleInstance | None = None
    if not options.smoke_test:
        def activate_window() -> None:
            if window is not None:
                window.showNormal()
                window.raise_()
                window.activateWindow()

        instance = StudioSingleInstance(studio_server_name(), activate_window)
        if not instance.claim():
            return 0
    window = StudioMainWindow(
        agent_host=options.agent_host,
        agent_port=options.agent_port,
        agent_source_address=options.agent_source_address,
        agent_build_id=options.agent_build_id,
    )
    window.show()
    if options.agent_host and not options.smoke_test:
        # The desktop shortcut names a target; connect without requiring a second click.
        from PySide6.QtCore import QTimer
        QTimer.singleShot(0, window._start_remote)
    if options.volume_monitor:
        audio = window.audio_workspace
        if audio is None:
            raise RuntimeError("Audio monitor requires an audio-capable Studio profile")
        window.select_workspace(1)
        audio.observation_source.setCurrentIndex(1)
        audio.volume_url.setText(options.volume_monitor)
        audio.volume_source_address.setText(options.volume_source_address or "")
        audio.start_observation()
    if options.camera_preview and not options.volume_monitor:
        window.select_workspace(0)
        window.vision_workspace.start_camera()
    if options.smoke_test:
        app.processEvents()
        window.close()
        app.processEvents()
        return 0
    try:
        return app.exec()
    finally:
        if instance is not None:
            instance.close()
