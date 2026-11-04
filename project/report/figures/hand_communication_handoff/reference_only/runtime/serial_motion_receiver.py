"""Isolated, explicitly enabled serial hand owner for a checked PS candidate.

Run: hand-venv/bin/python -I -B serial_motion_receiver.py --help
Outputs: ready.json, active.json (only after arm), serial-motion.json in a new
owner-created output directory. Requires --enable-motion and three reviewed
--stage-waits values; the PS owner supplies the checked hand tree and channel.
Next: verify release_confirmed and all 17 OFF IDs before releasing board use.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
from pathlib import Path
import signal
import socket
import sys
import threading
import time


PORT = "/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00"


def write_new(path, value):
    with path.open("x", encoding="utf-8") as stream:
        json.dump(value, stream, indent=2)
        stream.flush()
        os.fsync(stream.fileno())


def verify_serial_device(args):
    if sys.platform != "linux" or os.geteuid() != 0 or not args.enable_motion:
        raise ValueError("explicit Linux serial motion enable required")
    if args.port != PORT or not 0 < args.peer_port < 65536:
        raise ValueError("identified serial port and local peer required")
    if args.seconds is not None and (not math.isfinite(args.seconds) or args.seconds <= 0):
        raise ValueError("optional session limit must be finite and positive")
    if args.approval_seconds is not None and (not math.isfinite(args.approval_seconds)
                                            or not 0 < args.approval_seconds <= 10):
        raise ValueError("approval window must be finite, positive and at most ten seconds")
    selected = Path(args.port)
    if sorted(selected.parent.glob("usb-1a86_USB_Single_Serial_*-if00")) != [selected]:
        raise ValueError("unique identified hand serial device required")
    resolved = selected.resolve(strict=True)
    if not resolved.is_char_device():
        raise ValueError("hand port must be a character device")
    for descriptor in Path("/proc").glob("[0-9]*/fd/*"):
        try:
            if descriptor.resolve(strict=True) == resolved:
                raise RuntimeError("hand serial port already owned: " + str(descriptor))
        except (FileNotFoundError, ProcessLookupError):
            pass


def run(args):
    verify_serial_device(args)
    root = args.hand_root.resolve(strict=True)
    manifest = json.loads(Path(__file__).with_name("serial_sources.json").read_text(encoding="utf-8"))
    if manifest.get("schema") != "hand-serial-source-v1" or not manifest.get("sha256"):
        raise ValueError("serial source manifest required")
    for relative, expected in manifest["sha256"].items():
        source = (root / relative).resolve(strict=True)
        if not source.is_relative_to(root) or hashlib.sha256(source.read_bytes()).hexdigest() != expected:
            raise ValueError("serial hand source mismatch: " + relative)
    source = root / "src"
    sys.path.insert(0, str(source))
    import pynq_usb_hand
    from pynq_usb_hand.actuator_owner import VisionActuatorOwner, preview_pause_generation
    from pynq_usb_hand.game_bridge import DatagramReceiver
    from pynq_usb_hand.orca_backend import OrcaBackend, OrcaModel, SafetyPolicy

    if not Path(pynq_usb_hand.__file__).resolve().is_relative_to(source):
        raise ImportError("hand package origin mismatch")
    if not args.output_dir.is_dir():
        raise ValueError("owner-created output directory required")
    for name in ("ready.json", "active.json", "serial-motion.json"):
        if (args.output_dir / name).exists():
            raise FileExistsError("preserve previous hand validation run")
    # CPU-only imports/assets/pose compilation precede the live source lease.
    # No serial backend exists yet; connection and arm still require fresh input.
    model = OrcaModel(root)
    if tuple(model.ids) != tuple(range(1, 18)):
        raise ValueError("unexpected motor identity")
    page_playback = None
    if getattr(args,"page_control",False):
        from pynq_usb_hand.page_playback import load_demo_poses, PageCommandChannel, PagePlayback
        load_demo_poses(model, root/"assets/demo")
        page_playback = PagePlayback(PageCommandChannel(args.output_dir,args.session,args.game_run))
    stop = threading.Event()
    for signum in (signal.SIGINT, signal.SIGTERM):
        signal.signal(signum, lambda *_: stop.set())
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        sock.bind(("127.0.0.1", 0))
        sock.connect(("127.0.0.1", args.peer_port))
        def receiver_factory():
            return DatagramReceiver(sock, session_id=args.session,
                                    game_run=args.game_run, max_age=.5, clock=time.monotonic,
                                    preview_interlock=getattr(args,'preview_interlock',False),
                                    recover_stale=getattr(args,'preview_interlock',False))
        receiver = receiver_factory()

        def factory():
            return OrcaBackend(model, args.port, SafetyPolicy(40, 2),
                               skip_unchanged=True, speed=500,
                               allow_stage_targets=True, allow_playback=True)

        def active(source):
            write_new(args.output_dir / "active.json", {
                "pid": os.getpid(), "session": args.session, "game_run": args.game_run,
                "source": source, "actuator": "serial-fixed-playback",
                "approval_seconds": args.approval_seconds,
            })

        def preview_state(value):
            value.update(schema='hand-preview-interlock-v1',pid=os.getpid(),session=args.session,
                         game_run=args.game_run,actuator='serial-fixed-playback')
            temporary=args.output_dir/'control-state.tmp'
            temporary.write_text(json.dumps(value),encoding='utf-8')
            temporary.replace(args.output_dir/'control-state.json')

        owner = VisionActuatorOwner(
            receiver, factory, motor_ids=tuple(range(1, 18)), stage_waits=args.stage_waits,
            max_seconds=args.seconds, stop=stop, on_active=active,
            approval_seconds=args.approval_seconds,
            receiver_factory=receiver_factory if getattr(args,'preview_interlock',False) else None,
            on_preview_state=preview_state if getattr(args,'preview_interlock',False) else None,
            source_recovery=getattr(args,'preview_interlock',False),
            page_playback=page_playback,
        )
        write_new(args.output_dir / "ready.json", {
            "pid": os.getpid(), "parent_pid": os.getppid(), "session": args.session,
            "game_run": args.game_run, "address": sock.getsockname(),
            "actuator": "serial-fixed-playback",
            "approval_seconds": args.approval_seconds,
        })
        report = owner.run()
        receiver_stop=owner.receiver.stopped
        if preview_pause_generation(receiver_stop) is not None:
            receiver_stop=None
        report.update(session=args.session, game_run=args.game_run,
                      approval_seconds=args.approval_seconds,
                      actuator="serial-fixed-playback", receiver_stop=receiver_stop,
                      hardware_mode=True, mechanical_verified=False, release_ready=False)
        write_new(args.output_dir / "serial-motion.json", report)
        return report
    finally:
        sock.close()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--hand-root", type=Path, required=True)
    parser.add_argument("--session", required=True)
    parser.add_argument("--game-run", required=True)
    parser.add_argument("--peer-port", type=int, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--seconds", type=float,
                        help="Optional validation duration; omitted follows the checked vision session")
    parser.add_argument("--port", required=True)
    parser.add_argument("--stage-waits", type=float, nargs=3, required=True)
    parser.add_argument("--approval-seconds", type=float,
                        help="Whole gesture window from approval; stage waits become relative weights")
    parser.add_argument("--enable-motion", action="store_true")
    parser.add_argument("--preview-interlock", action="store_true")
    parser.add_argument("--page-control", action="store_true")
    report = run(parser.parse_args())
    print(json.dumps(report, sort_keys=True), flush=True)
    return 0 if report["active"] and report["release_confirmed"] and report["error"] is None else 1


if __name__ == "__main__":
    raise SystemExit(main())
