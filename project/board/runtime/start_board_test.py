# C0E source staging is intentionally non-deployable until paired finalization.
from pathlib import Path as _StagePath
import json as _StageJson
_stage = _StageJson.loads((_StagePath(__file__).parent / "candidate_stage.json").read_text())
if _stage.get("stage") != "PAIRED_PREFLIGHT_READY":
    raise RuntimeError("C0E hardware/software pairing and preflight are not complete")

from pathlib import Path
import argparse
import hashlib
import importlib
from importlib.metadata import distribution
import json
import math
import os
import subprocess
import sys
import time


def verify_deployment_identity(root: Path, manifest: dict) -> None:
    for name, digest in manifest["sha256"].items():
        path = (root / name).resolve()
        if (not path.is_relative_to(root)
                or hashlib.sha256(path.read_bytes()).hexdigest() != digest.lower()):
            raise ValueError("Deployment identity mismatch: " + name)


def main():
    root = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser()
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument("--hand-readonly-root", type=Path)
    parser.add_argument("--hand-readonly-python", type=Path)
    parser.add_argument("--hand-readonly-port")
    parser.add_argument("--hand-shadow", action="store_true")
    parser.add_argument("--hand-mock-actions", action="store_true")
    parser.add_argument("--hand-serial-actions", action="store_true")
    parser.add_argument("--hand-serial-seconds", type=float)
    parser.add_argument("--hand-approval-seconds", type=float)
    parser.add_argument("--hand-stage-waits", type=float, nargs=3)
    options = parser.parse_args()
    hand_options = (options.hand_readonly_root, options.hand_readonly_python,
                    options.hand_readonly_port)
    if any(option is not None for option in hand_options) and not all(
            option is not None for option in hand_options):
        parser.error("hand read-only startup requires root, Python and port together")
    if options.hand_shadow and not all(option is not None for option in hand_options):
        parser.error("hand shadow requires root, Python and port together")
    if options.hand_mock_actions and not all(option is not None for option in hand_options):
        parser.error("mock hand actions require root, Python and port together")
    if sum((options.hand_shadow, options.hand_mock_actions, options.hand_serial_actions)) > 1:
        parser.error("choose one hand shadow, mock or serial action mode")
    if options.hand_serial_actions and not all(option is not None for option in hand_options):
        parser.error("serial hand actions require root, Python and port together")
    if options.hand_serial_actions != (options.hand_stage_waits is not None):
        parser.error("serial hand actions require three explicit stage waits; other modes cannot use them")
    if options.hand_serial_seconds is not None and (not options.hand_serial_actions
            or not math.isfinite(options.hand_serial_seconds) or options.hand_serial_seconds <= 0):
        parser.error("serial duration requires serial action mode and a finite positive value")
    if options.hand_stage_waits is not None and any(not math.isfinite(value) or not 0 < value <= 10
                                                  for value in options.hand_stage_waits):
        parser.error("serial stage waits must be finite, positive and at most ten seconds")
    if options.hand_approval_seconds is not None and (not options.hand_serial_actions
            or not math.isfinite(options.hand_approval_seconds) or not 0 < options.hand_approval_seconds <= 10):
        parser.error("approval window requires serial mode and a finite value in (0, 10]")
    check_only = options.check_only
    manifest = json.loads((root / "deployment_manifest.json").read_text(encoding="utf-8"))
    verify_deployment_identity(root, manifest)
    sys.path.insert(0, str(root / "python"))
    os.environ["PYTHONPATH"] = str(root / "python")
    os.environ["XILINX_XRT"] = "/usr"
    os.environ["VVG_VISION_RUNTIME_DIR"] = str(root / "handoffs/gesture_vision_v61/runtime")
    collision = importlib.import_module("collision")
    dependency = distribution("collision")
    if dependency.version != "1.2.2" or not Path(collision.__file__).resolve().is_relative_to(root / "python"):
        raise RuntimeError("The SHA-verified deployment must supply collision==1.2.2")
    print("DEPLOYED_DEPENDENCY collision", dependency.version, collision.__file__, flush=True)
    if not check_only:
        if sys.platform != "linux" or os.geteuid() != 0 or sys.version_info[:2] != (3, 10):
            raise RuntimeError("Use sudo -n and the frozen PYNQ Python 3.10 interpreter")
        for name in ("pynq", "cv2", "numpy", "collision", "tomli"):
            module = importlib.import_module(name)
            print("DEPENDENCY", name, getattr(module, "__version__", "available"), flush=True)
        processes = subprocess.run(["ps", "-ww", "-eo", "pid,args"], check=True,
                                   text=True, capture_output=True).stdout
        owners = ("project1_live_ov5640.py", "capture_camera_direct_plug.py",
                  "run_camera_live_guarded.py", "run_accel_guarded.py", "run_vision_guarded.py")
        if any(name in processes for name in owners):
            raise RuntimeError("An existing camera owner must be stopped and its DMA cleanup confirmed first")
    from pynq_multimodal_game.agent.cli import main as agent_main
    if check_only and all(option is not None for option in hand_options):
        from pynq_multimodal_game.hand_startup import HandStartupGate
        HandStartupGate(root=options.hand_readonly_root,
                        python=options.hand_readonly_python,
                        port=options.hand_readonly_port,
                        report_dir=root / "var/vision")
        if options.hand_shadow or options.hand_mock_actions:
            from pynq_multimodal_game.hand_shadow_bridge import verify_shadow_sources, verify_mock_child
            verify_shadow_sources(options.hand_readonly_root)
            if options.hand_mock_actions:
                verify_mock_child(root)
        if options.hand_serial_actions:
            from pynq_multimodal_game.hand_shadow_bridge import verify_shadow_sources, verify_serial_sources
            verify_shadow_sources(options.hand_readonly_root)
            verify_serial_sources(options.hand_readonly_root, root)
    from pynq_multimodal_game.game_seeds import ensure_seed_games
    from pynq_multimodal_game.library import AssetLibrary
    from pynq_multimodal_game.video_seeds import ensure_seed_videos
    def initialize_library():
        bundled_games = ensure_seed_games(root, AssetLibrary(root / "var/library"),
                                          install=not check_only)
        print("BUNDLED_GAMES", ",".join(bundled_games), flush=True)
        bundled_videos = ensure_seed_videos(root, AssetLibrary(root / "var/library"),
                                           install=not check_only)
        print("BUNDLED_VIDEOS", ",".join(bundled_videos), flush=True)
    if check_only:
        initialize_library()
    host = os.environ.get("VVG_BOARD_HOST", "192.168.2.99")
    arguments = ["--backend", "c6i-vision-button", "--build-id", manifest["build_id"], "--vision-board-test",
                 "--host", host, "--port", "8765",
                 "--bitstream", str(root / "overlay/c6v_candidate.bit"),
                 "--vision-manifest", str(root / "overlay/board_test_manifest.json"),
                 "--vision-camera-dir", str(root / "board/pynq_z2"),
                 "--vision-camera-sha256", "B79C5735EA5C81B0EA4A95E805AEF3CDDF45D221BBD1906D76326D79B9E2E253",
                 "--vision-output-dir", str(root / "var/vision"),
                 "--vision-bind", host, "--vision-port", "8081",
                 "--library-root", str(root / "var/library"),
                 "--lock-path", "/var/lock/voice-view-c6i.lock", "--vision-game-input"]
    if all(option is not None for option in hand_options):
        arguments.extend(("--hand-readonly-root", str(options.hand_readonly_root),
                          "--hand-readonly-python", str(options.hand_readonly_python),
                          "--hand-readonly-port", options.hand_readonly_port))
    if options.hand_shadow:
        arguments.append("--hand-shadow")
    if options.hand_mock_actions:
        arguments.append("--hand-mock-actions")
    if options.hand_serial_actions:
        arguments.extend(("--hand-serial-actions", "--hand-stage-waits",
                          *(str(value) for value in options.hand_stage_waits)))
    if options.hand_serial_seconds is not None:
        arguments.extend(("--hand-serial-seconds", str(options.hand_serial_seconds)))
    if options.hand_approval_seconds is not None:
        arguments.extend(("--hand-approval-seconds", str(options.hand_approval_seconds)))
    if check_only:
        arguments.append("--vision-check-only")
    # The verified GPU loading renderer must exist before lengthy content
    # validation. This runs before vision/hand start, under the LIBRARY stage.
    started=time.monotonic()
    result=agent_main(arguments, startup_library=None if check_only else initialize_library)
    if result in (73,74) and not check_only:
        if result==74:
            streak=0 if time.monotonic()-started>120 else int(os.environ.get('VVG_RECOVERY_STREAK','0'))
            streak=min(6,streak+1);os.environ['VVG_RECOVERY_STREAK']=str(streak)
            delay=min(60,2**streak)
            print(f'UI_RECOVERY_BACKOFF seconds={delay}',flush=True)
            time.sleep(delay)
        else:os.environ.pop('VVG_RECOVERY_STREAK',None)
        print('UI_RESTART_CLEANUP_CONFIRMED',flush=True)
        os.execv(sys.executable,[sys.executable,'-B','-u',str(root/'start_board_test.py'),*sys.argv[1:]])
    return result


if __name__ == "__main__":
    raise SystemExit(main())
