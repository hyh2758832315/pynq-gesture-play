from __future__ import annotations

import getpass
import hashlib
from pathlib import Path
from typing import Callable

from PySide6.QtNetwork import QLocalServer, QLocalSocket


def studio_server_name() -> str:
    # Stable across desktop shortcuts and CLI launches of this workspace.
    workspace = Path(__file__).resolve().parents[3]
    identity = f"{getpass.getuser()}:{workspace}".casefold().encode("utf-8")
    return "voice-view-studio-" + hashlib.sha256(identity).hexdigest()[:24]


class StudioSingleInstance:
    def __init__(self, name: str, activate: Callable[[], None]) -> None:
        self._name = name
        self._activate = activate
        self._server = QLocalServer()
        self._server.newConnection.connect(self._on_connection)

    def claim(self) -> bool:
        if self._notify_existing():
            return False
        if self._server.listen(self._name):
            return True
        if self._notify_existing():
            return False
        # Only remove an endpoint after both listening and connecting failed.
        QLocalServer.removeServer(self._name)
        if self._server.listen(self._name):
            return True
        if self._notify_existing():
            return False
        raise RuntimeError(f"Cannot reserve Studio single-instance endpoint: {self._server.errorString()}")

    def close(self) -> None:
        self._server.close()

    def _notify_existing(self) -> bool:
        socket = QLocalSocket()
        socket.connectToServer(self._name)
        connected = socket.waitForConnected(300)
        if connected:
            socket.write(b"activate")
            socket.waitForBytesWritten(300)
            socket.disconnectFromServer()
        return connected

    def _on_connection(self) -> None:
        while self._server.hasPendingConnections():
            socket = self._server.nextPendingConnection()
            socket.disconnectFromServer()
            socket.deleteLater()
        self._activate()
