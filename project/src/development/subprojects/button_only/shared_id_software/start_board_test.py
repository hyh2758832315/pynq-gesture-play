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
import os
import subprocess
import sys


def main():
    root = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser()
    parser.add_argument("--check-only", action="store_true")
    options = parser.parse_args()
    check_only = options.check_only
    manifest = json.loads((root / "deployment_manifest.json").read_text(encoding="utf-8"))
    for name, digest in manifest["sha256"].items():
        path = (root / name).resolve()
        if not path.is_relative_to(root) or hashlib.sha256(path.read_bytes()).hexdigest().upper() != digest:
            raise ValueError("Deployment identity mismatch: " + name)
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
    if check_only:
        arguments.append("--vision-check-only")
    return agent_main(arguments)


if __name__ == "__main__":
    raise SystemExit(main())
