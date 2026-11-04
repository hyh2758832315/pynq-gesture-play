from __future__ import annotations

import socket
import threading

from PySide6.QtCore import QObject, Signal, Slot

from .device import DeviceState, RemoteDeviceSession


class AgentIoWorker(QObject):
    snapshot_changed = Signal(object)
    frame_received = Signal(object)
    finished = Signal()

    def __init__(self, session: RemoteDeviceSession, *, reconnect_delay: float = 0.25) -> None:
        super().__init__()
        self.session = session
        self.reconnect_delay = reconnect_delay
        self._stopping = threading.Event()

    @Slot()
    def run(self) -> None:
        try:
            while not self._stopping.is_set():
                snapshot = self.session.connect()
                self.snapshot_changed.emit(snapshot)
                if snapshot.state is not DeviceState.READY:
                    if self._stopping.wait(self.reconnect_delay):
                        break
                    continue
                try:
                    while not self._stopping.is_set():
                        try:
                            frame = self.session.receive()
                        except socket.timeout:
                            continue
                        self.frame_received.emit(frame)
                except (ConnectionError, OSError, ValueError) as error:
                    if not self._stopping.is_set():
                        self.snapshot_changed.emit(self.session.fail(str(error)))
                        if self._stopping.wait(self.reconnect_delay):
                            break
        finally:
            self.snapshot_changed.emit(self.session.disconnect())
            self.finished.emit()

    def stop(self) -> None:
        self._stopping.set()
        self.session.disconnect()