"""Exercise the isolated vision-to-hand action path with an in-memory servo.

Run with the hand venv: python -I -B mock_motion_receiver.py --help
Outputs ready.json and mock-motion.json. No real serial or ORCA backend exists
in this entry; a physical action owner must be a separately reviewed program.
"""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import socket
import sys
import time


def _write_new(path: Path, value: dict) -> None:
    with path.open("x", encoding="utf-8") as stream:
        json.dump(value, stream, indent=2)
        stream.flush()
        os.fsync(stream.fileno())


def run(args) -> dict:
    hand_root = args.hand_root.resolve(strict=True)
    if not (hand_root / "frozen_manifest.json").is_file():
        raise ValueError("hand root lacks frozen identity")
    source = hand_root / "src"
    sys.path.insert(0, str(source))
    import pynq_usb_hand
    from pynq_usb_hand.controller import Controller
    from pynq_usb_hand.game_bridge import DatagramReceiver
    from pynq_usb_hand.gesture_consumer import GestureConsumer
    from pynq_usb_hand.motion import MockBackend, MotionSettings

    if not Path(pynq_usb_hand.__file__).resolve().is_relative_to(source):
        raise ImportError("hand package origin mismatch")
    if not 0 < args.seconds <= 30 or not 0 < args.peer_port < 65536:
        raise ValueError("bounded lifetime and local peer port required")
    if not args.output_dir.is_dir():
        raise ValueError("owner-created output directory required")
    if (args.output_dir / "ready.json").exists() or (args.output_dir / "mock-motion.json").exists():
        raise FileExistsError("preserve previous hand run")

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(("127.0.0.1", 0))
    sock.connect(("127.0.0.1", args.peer_port))
    receiver = DatagramReceiver(sock, session_id=args.session,
                                game_run=args.game_run, max_age=.5)
    _write_new(args.output_dir / "ready.json", {
        "pid": os.getpid(), "parent_pid": os.getppid(),
        "session": args.session, "game_run": args.game_run,
        "address": sock.getsockname(), "actuator": "memory-only",
    })
    started = time.monotonic()
    first = None
    backend = None
    controller = None
    consumer = None
    operations = []
    last_request = 0
    reason = "duration_complete"
    error = None
    try:
        while first is None and time.monotonic() - started < 1:
            first = receiver.poll(time.monotonic())
            if receiver.stopped:
                raise RuntimeError(f"input channel: {receiver.stopped}")
            if first is None:
                time.sleep(.02)
        if first is None or not first.valid:
            raise RuntimeError("fresh vision source missing")
        _write_new(args.output_dir / "active.json", {
            "pid": os.getpid(), "session": args.session,
            "game_run": args.game_run, "source": [first.run_id, first.config_epoch],
        })
        backend = MockBackend()
        controller = Controller(
            lambda: backend, lease_seconds=5,
            settings=MotionSettings.fixed_playback(stage_waits=(.001,) * 3),
        )
        controller.wait_connected()
        controller.arm()
        if not controller.wait_idle():
            raise TimeoutError("mock hand did not arm")

        class Mailbox:
            def read(self):
                return receiver.poll(time.monotonic())

        consumer = GestureConsumer(
            controller, Mailbox(),
            source_identity=(first.run_id, first.config_epoch),
            max_age=.5, stable_seconds=.06, renew_interval=.1,
        )
        while time.monotonic() - started < args.seconds:
            reason = consumer.tick(time.monotonic)
            status = controller.status()
            operation = status["operation"]
            if operation is not None and operation["request_id"] > last_request:
                last_request = operation["request_id"]
                operations.append({"request_id": last_request,
                                   "state": operation["state"]})
            if consumer.stopped:
                break
            time.sleep(.02)
    except Exception as failure:
        error = f"{type(failure).__name__}: {failure}"
    finally:
        if consumer is not None:
            consumer.stop("mock_child_closed")
        if controller is not None:
            try:
                controller.close(timeout=8)
            except Exception as failure:
                error = error or f"{type(failure).__name__}: {failure}"
        sock.close()
    forbidden = [name for name in ("serial", "orca_core", "pynq_usb_hand.orca_backend")
                 if name in sys.modules]
    report = {
        "schema": "vision-hand-mock-process-v1", "result": "MOCK_ACTION_PASS"
        if first is not None and error is None and not forbidden
        and backend is not None and backend.closed and not backend.torque
        else "MOCK_ACTION_FAIL",
        "session": args.session, "game_run": args.game_run,
        "source": None if first is None else [first.run_id, first.config_epoch],
        "operations": operations, "stop_reason": reason,
        "receiver_stop": receiver.stopped, "error": error,
        "serial_opened": False, "hardware_motion": False,
        "forbidden_modules": forbidden,
        "torque_on_after_close": None if backend is None else backend.torque,
        "backend_closed": None if backend is None else backend.closed,
        "elapsed": time.monotonic() - started,
    }
    _write_new(args.output_dir / "mock-motion.json", report)
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--hand-root", type=Path, required=True)
    parser.add_argument("--session", required=True)
    parser.add_argument("--game-run", required=True)
    parser.add_argument("--peer-port", type=int, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--seconds", type=float, required=True)
    report = run(parser.parse_args())
    print(json.dumps(report, sort_keys=True), flush=True)
    return 0 if report["result"] == "MOCK_ACTION_PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
