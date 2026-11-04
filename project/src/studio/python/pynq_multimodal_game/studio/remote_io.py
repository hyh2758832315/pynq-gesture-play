from __future__ import annotations

import socket
import threading
import time

from PySide6.QtCore import QObject, Signal, Slot

from .device import DeviceState, RemoteDeviceSession


class AgentIoWorker(QObject):
    snapshot_changed = Signal(object)
    frame_received = Signal(object)
    board_changed = Signal(object)
    finished = Signal()

    def __init__(self, session: RemoteDeviceSession, *, reconnect_delay: float = 0.25,
                 board_probe=None) -> None:
        super().__init__()
        self.session = session
        self.reconnect_delay = reconnect_delay
        self._stopping = threading.Event()
        self.board_probe = board_probe

    @Slot()
    def run(self) -> None:
        retry_delay = self.reconnect_delay
        last_failure = None
        next_probe = 0.0
        try:
            while not self._stopping.is_set():
                snapshot = self.session.connect()
                if snapshot.state is not DeviceState.READY:
                    failure=(snapshot.state,snapshot.message)
                    if failure!=last_failure:self.snapshot_changed.emit(snapshot)
                    last_failure=failure
                    if self.board_probe is not None and time.monotonic() >= next_probe:
                        try:
                            board = self.board_probe(stop_event=self._stopping)
                        except Exception as error:
                            board = dict(ssh_ready=False, error=str(error))
                        if not self._stopping.is_set(): self.board_changed.emit(board)
                        next_probe = time.monotonic() + 15
                    if self._stopping.wait(retry_delay):
                        break
                    retry_delay=min(5.0,max(.25,retry_delay*2))
                    continue
                retry_delay=self.reconnect_delay;last_failure=None;next_probe=0.0
                self.snapshot_changed.emit(snapshot)
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
