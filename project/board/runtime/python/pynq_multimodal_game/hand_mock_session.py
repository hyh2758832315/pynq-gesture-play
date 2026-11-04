"""Bounded PS owner for the isolated, memory-only hand action child.

This module deliberately accepts only mock_motion_receiver.py. A real serial
owner needs a separately reviewed shutdown protocol and OFF-readback receipt.
"""

from __future__ import annotations

import json
import os
from pathlib import Path
import socket
import subprocess
import threading
import time
from uuid import uuid4


class MockHandActionSession:
    def __init__(self, feed, *, python: Path, hand_root: Path,
                 entry: Path, output_dir: Path, seconds: float = 30) -> None:
        if not 0 < seconds <= 30:
            raise ValueError("mock action lifetime must be within 30 seconds")
        self.feed = feed
        # Keep POSIX venv/bin/python as a symlink so it selects that venv.
        self.python = Path(os.path.abspath(python))
        self.hand_root = hand_root.resolve(strict=True)
        self.entry = entry.resolve(strict=True)
        if self.entry.name != "mock_motion_receiver.py":
            raise ValueError("only the memory-only child is supported")
        if not self.python.is_file():
            raise FileNotFoundError(self.python)
        self.output_dir = output_dir.absolute()
        self.seconds = seconds
        self.session = uuid4().hex
        self.error: str | None = None
        self.finished = threading.Event()
        self._stop = threading.Event()
        self._thread: threading.Thread | None = None
        self._child_pid: int | None = None
        self._child_active = False
        self._child_exited = False
        self._release_confirmed: bool | None = None

    def status(self) -> dict[str, object]:
        """Read in-memory lifecycle only; never poll vision or child files."""
        if self.finished.is_set():
            phase = "FAULT" if self.error is not None else "CLOSED"
        elif self._child_exited:
            phase = "VERIFYING_RELEASE"
        elif self._stop.is_set():
            phase = "CLOSING"
        elif self._child_active:
            phase = "ACTIVE"
        elif self._child_pid is not None:
            phase = "STARTING"
        elif self._thread is not None:
            phase = "WAITING_SOURCE"
        else:
            phase = "NEW"
        return {"schema": "hand-session-status-v1", "mode": "memory-only",
                "phase": phase, "session": self.session,
                "child_pid": self._child_pid,
                "release_confirmed": self._release_confirmed,
                "error": self.error}

    def start(self) -> None:
        if self._thread is not None:
            raise RuntimeError("mock hand session cannot restart")
        self.output_dir.mkdir(mode=0o700, parents=False, exist_ok=False)
        self._thread = threading.Thread(target=self._run, name="hand-mock-publisher",
                                        daemon=False)
        self._thread.start()

    def close(self) -> None:
        self._stop.set()
        if self._thread is not None:
            self._thread.join(15)
            if self._thread.is_alive():
                raise TimeoutError("mock hand process cleanup not confirmed")
        if self.error is not None:
            raise RuntimeError(self.error)

    def _run(self) -> None:
        child = None
        sock = None
        publisher = None
        source = None
        result = {"schema": "vision-hand-mock-parent-v1", "session": self.session,
                  "actuator": "memory-only", "child_started": False}
        started = time.monotonic()
        try:
            from pynq_usb_hand.game_bridge import DatagramPublisher

            deadline = started + self.seconds
            while not self._stop.is_set() and time.monotonic() < deadline:
                value = self.feed.read()
                if self.feed.revoked is not None:
                    break
                if value is None:
                    self._stop.wait(.1)
                    continue
                source = value.game_run
                sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
                sock.bind(("127.0.0.1", 0))
                command = [str(self.python), "-I", "-B", str(self.entry),
                           "--hand-root", str(self.hand_root),
                           "--session", self.session, "--game-run", source,
                           "--peer-port", str(sock.getsockname()[1]),
                           "--output-dir", str(self.output_dir),
                           "--seconds", str(self.seconds)]
                with (self.output_dir / "child-stdout.log").open("xb") as out, (
                        self.output_dir / "child-stderr.log").open("xb") as err:
                    child = subprocess.Popen(
                        command, stdin=subprocess.DEVNULL, stdout=out, stderr=err,
                        creationflags=subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0)
                result.update(child_started=True, launch_pid=child.pid, game_run=source)
                self._child_pid = child.pid
                self._release_confirmed = False
                ready_path = self.output_dir / "ready.json"
                ready_deadline = time.monotonic() + 4
                while True:
                    if child.poll() is not None:
                        raise RuntimeError("mock child exited before ready")
                    if time.monotonic() >= ready_deadline:
                        raise TimeoutError("mock child readiness deadline")
                    try:
                        ready = json.loads(ready_path.read_text(encoding="utf-8"))
                    except (FileNotFoundError, json.JSONDecodeError):
                        time.sleep(.02)
                        continue
                    parent_matches = (ready.get("pid") == child.pid or
                                      (os.name == "nt" and ready.get("parent_pid") == child.pid))
                    address = ready.get("address")
                    if (not parent_matches or ready.get("session") != self.session
                            or ready.get("game_run") != source
                            or ready.get("actuator") != "memory-only"
                            or not isinstance(address, list) or len(address) != 2
                            or address[0] != "127.0.0.1"
                            or type(address[1]) is not int or not 0 < address[1] < 65536):
                        raise ValueError("mock child readiness identity mismatch")
                    sock.connect(tuple(address))
                    publisher = DatagramPublisher(sock, self.feed, session_id=self.session)
                    result["child_pid"] = ready["pid"]
                    break
                # The child must receive one fresh frame before a close request
                # can revoke the channel and obtain its release receipt.
                publisher.publish()
                active_path = self.output_dir / "active.json"
                active_deadline = time.monotonic() + 1
                while True:
                    if child.poll() is not None:
                        raise RuntimeError("mock child exited before accepting vision")
                    if time.monotonic() >= active_deadline:
                        raise TimeoutError("mock child did not acknowledge vision")
                    try:
                        active = json.loads(active_path.read_text(encoding="utf-8"))
                    except (FileNotFoundError, json.JSONDecodeError):
                        publisher.publish()
                        time.sleep(.05)
                        continue
                    if (active.get("pid") != ready["pid"]
                            or active.get("session") != self.session
                            or active.get("game_run") != source):
                        raise ValueError("mock child active identity mismatch")
                    result["child_active"] = True
                    self._child_active = True
                    break
                while not self._stop.is_set() and time.monotonic() < deadline:
                    if child.poll() is not None or self.feed.revoked is not None:
                        break
                    publisher.publish()
                    self._stop.wait(.1)
                break
            self.feed.revoke("mock_session_finished")
            if publisher is not None:
                publisher.publish()
            if child is not None:
                try:
                    result["child_exit"] = child.wait(timeout=3)
                    self._child_exited = True
                except subprocess.TimeoutExpired:
                    # The exact child entry owns only MockBackend, never serial.
                    child.terminate()
                    result["child_exit"] = child.wait(timeout=3)
                    self._child_exited = True
                    raise TimeoutError("mock child did not close after revocation")
                receipt = json.loads((self.output_dir / "mock-motion.json").read_text(encoding="utf-8"))
                if (result["child_exit"] != 0 or receipt.get("schema") != "vision-hand-mock-process-v1"
                        or receipt.get("result") != "MOCK_ACTION_PASS"
                        or receipt.get("session") != self.session
                        or receipt.get("game_run") != source
                        or receipt.get("serial_opened") is not False
                        or receipt.get("hardware_motion") is not False
                        or receipt.get("backend_closed") is not True
                        or receipt.get("torque_on_after_close") is not False):
                    raise RuntimeError("mock child final release receipt mismatch")
                result["child_result"] = receipt["result"]
                self._release_confirmed = True
        except Exception as error:
            self.error = f"{type(error).__name__}: {error}"
        finally:
            self.feed.revoke("mock_session_closed")
            if child is not None and child.poll() is None:
                self.feed.revoke("mock_session_cleanup")
                if publisher is not None:
                    publisher.publish()
                try:
                    result["child_exit"] = child.wait(timeout=3)
                    self._child_exited = True
                except subprocess.TimeoutExpired:
                    child.terminate()  # This child owns only MockBackend.
                    result["child_exit"] = child.wait(timeout=3)
                    self._child_exited = True
                    self.error = self.error or "mock child forced to stop during cleanup"
            if sock is not None:
                sock.close()
            result.update(error=self.error, feed_revoked=self.feed.revoked,
                          elapsed=time.monotonic() - started,
                          publisher_dropped=None if publisher is None else publisher.dropped)
            try:
                with (self.output_dir / "parent.json").open("x", encoding="utf-8") as out:
                    json.dump(result, out, indent=2)
            finally:
                self.finished.set()
