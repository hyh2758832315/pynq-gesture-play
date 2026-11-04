import argparse
from contextlib import contextmanager
import json
from pathlib import Path
import sys

from .assets import verify_frozen
from .buttons import DebouncedButtons, STATES
from .controller import Controller
from .motion import MockBackend, MotionSettings


def emit(event, **fields):
    print(json.dumps({"event": event, **fields}, sort_keys=True), flush=True)


@contextmanager
def key_source(stream):
    if not stream.isatty():
        yield lambda: stream.read(1)
    elif sys.platform == "win32":
        import msvcrt
        yield msvcrt.getwch
    else:
        import termios
        import tty
        original = termios.tcgetattr(stream.fileno())
        try:
            tty.setcbreak(stream.fileno())
            yield lambda: stream.read(1)
        finally:
            termios.tcsetattr(stream.fileno(), termios.TCSADRAIN, original)


def parser():
    arguments = argparse.ArgumentParser(description="Standalone experimental USB hand controller")
    arguments.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[2])
    commands = arguments.add_subparsers(dest="command", required=True)
    commands.add_parser("verify", help="Verify frozen sources and assets without importing ORCA")
    commands.add_parser("poses", help="Rebuild four real poses offline, with zero serial access")
    demo = commands.add_parser("demo", help="Run a finite mock sequence, then release and close")
    demo.add_argument("--sequence", default="paper,scissors,rock")
    demo.add_argument("--cycles", type=int, default=3)
    demo.add_argument("--real-poses", action="store_true")
    demo.add_argument("--fast", action="store_true", help="Skip delays in mock only")
    keys = commands.add_parser("keys", help="1..4: default/paper/scissors/rock; a: arm; r: release; s: status; q: quit")
    keys.add_argument("--input", choices=("keyboard", "masks"), default="keyboard")
    keys.add_argument("--hardware", action="store_true")
    keys.add_argument("--port")
    keys.add_argument("--confirm-safety", action="store_true")
    keys.add_argument("--max-temperature", type=float)
    keys.add_argument("--max-scan-age", type=float)
    keys.add_argument("--lease-seconds", type=float)
    keys.add_argument("--motion-profile", choices=("audit", "responsive"), default="audit",
                      help="responsive: experimental 10ms steps, no fixed hold, 200ms scans and acknowledged target deduplication")
    keys.add_argument("--waypoint-feedback-interval", type=float, default=None,
                      help="Seconds between waypoint safety scans; 0 scans every waypoint; stage feedback stays enabled")
    return arguments


def mock_factory(root, real_poses):
    if real_poses:
        from .orca_backend import OrcaModel
        model = OrcaModel(root)
        return MockBackend(model.poses, model.roms)
    return MockBackend()


def run_demo(arguments):
    sequence = tuple(arguments.sequence.split(","))
    if not sequence or any(state not in STATES for state in sequence) or not 1 <= arguments.cycles <= 100:
        raise ValueError("Expected known states and 1..100 finite cycles")
    backend = mock_factory(arguments.root, arguments.real_poses)
    settings = MotionSettings(step_size=0, hold=0, sample_interval=0.0001) if arguments.fast else MotionSettings()
    controller = Controller(lambda: backend, lease_seconds=60, settings=settings)
    completed = []
    try:
        controller.wait_connected()
        controller.arm()
        if not controller.wait_idle() or controller.status()["lifecycle"] != "READY":
            raise RuntimeError(controller.status())
        for request_id, state in enumerate(sequence * arguments.cycles, 1):
            controller.renew(session_id=controller.session_id, enable_epoch=controller.enable_epoch)
            accepted = controller.submit(state, request_id=request_id, session_id=controller.session_id,
                                         enable_epoch=controller.enable_epoch)
            if accepted != "accepted" or not controller.wait_idle(90):
                raise RuntimeError(f"Mock request failed: {accepted}")
            status = controller.status()
            if status["lifecycle"] != "READY" or status["operation"]["status"] != "reached":
                raise RuntimeError(status)
            completed.append(state)
    finally:
        controller.close()
    if backend.torque or not backend.closed or controller.status()["lifecycle"] != "CLOSED":
        raise RuntimeError("Mock final release/close failed")
    emit("mock_complete", source="MOCK_REAL_POSES" if arguments.real_poses else "MOCK_SYNTHETIC",
         requests=completed, waypoints=len(backend.writes), joint_count=len(backend.roms),
         torque_off=True, closed=True, board_pending=True)
    return 0


def run_keys(arguments, command_parser):
    max_age = arguments.max_scan_age if arguments.hardware else 1.0
    if arguments.motion_profile == "responsive" and arguments.waypoint_feedback_interval is not None:
        command_parser.error("responsive defines its feedback interval; use audit for custom intervals")
    if arguments.hardware:
        required = (arguments.port, arguments.confirm_safety, arguments.max_temperature,
                    arguments.max_scan_age, arguments.lease_seconds)
        if not all(value is not None and value is not False for value in required):
            command_parser.error("Hardware requires explicit port, safety confirmation, temperature, scan age and lease")
        from .orca_backend import OrcaBackend, OrcaModel, SafetyPolicy
        policy = SafetyPolicy(arguments.max_temperature, arguments.max_scan_age)
        factory = lambda: OrcaBackend(OrcaModel(arguments.root), arguments.port, policy,
                                      skip_unchanged=arguments.motion_profile == "responsive")
    else:
        factory = lambda: MockBackend()
    settings = (MotionSettings.responsive(max_age=max_age) if arguments.motion_profile == "responsive"
                else MotionSettings(max_age=max_age, waypoint_feedback_interval=(
                    0.0 if arguments.waypoint_feedback_interval is None else arguments.waypoint_feedback_interval)))
    controller = Controller(factory, lease_seconds=arguments.lease_seconds or 60, settings=settings)
    request_id = 0
    buttons = DebouncedButtons()

    def dispatch(key):
        nonlocal request_id
        if key == "q":
            return False
        if key == "a":
            controller.arm()
            emit("arm_requested")
        elif key == "r":
            controller.release()
            emit("release_requested")
        elif key == "s":
            emit("status", **controller.status())
        elif key in ("1", "2", "3", "4"):
            request_id += 1
            result = controller.submit(STATES[int(key) - 1], request_id=request_id,
                                       session_id=controller.session_id, enable_epoch=controller.enable_epoch)
            emit("request", request_id=request_id, state=STATES[int(key) - 1], result=result)
        return True

    try:
        controller.wait_connected()
        emit("connected_off", source="HARDWARE_EXPERIMENT" if arguments.hardware else "MOCK_SYNTHETIC",
               motion_profile=arguments.motion_profile,
               waypoint_feedback_interval=settings.waypoint_feedback_interval,
             input=arguments.input, controls={"1": "default", "2": "paper", "3": "scissors", "4": "rock",
                                             "a": "arm", "r": "release", "s": "status", "q": "quit"})
        if arguments.input == "keyboard":
            with key_source(sys.stdin) as read_key:
                while True:
                    key = read_key()
                    if not key or key == "\x03" or not dispatch(key.lower()):
                        break
        else:
            for line in sys.stdin:
                line = line.strip()
                if line in ("a", "r", "s", "q"):
                    if not dispatch(line):
                        break
                elif line:
                    timestamp, mask = line.split()
                    state = buttons.sample(int(mask, 0), float(timestamp))
                    if state is not None:
                        dispatch(str(STATES.index(state) + 1))
    finally:
        controller.close()
    emit("closed", **controller.status())
    return 0 if controller.status()["lifecycle"] == "CLOSED" else 1


def main(argv=None):
    command_parser = parser()
    arguments = command_parser.parse_args(argv)
    arguments.root = arguments.root.resolve()
    try:
        manifest = verify_frozen(arguments.root)
        if arguments.command == "verify":
            emit("frozen_verified", files=len(manifest["sha256"]), upstream=manifest["upstream_version"])
            return 0
        if arguments.command == "poses":
            from .orca_backend import OrcaModel
            model = OrcaModel(arguments.root)
            emit("poses_rebuilt", poses=model.poses, motor_count=len(model.ids), serial_opened=False)
            return 0
        if arguments.command == "demo":
            return run_demo(arguments)
        return run_keys(arguments, command_parser)
    except KeyboardInterrupt:
        return 130
    except Exception as error:
        emit("error", error=f"{type(error).__name__}: {error}")
        return 1