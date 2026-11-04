from __future__ import annotations

import argparse
import ast
from email import message_from_string
import hashlib
from importlib.metadata import distribution
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import zipfile

from verify_vision_integration_sources import CAMERA_SHA256, CANDIDATE_FILES, verify_candidate_bundle, verify_volume_candidate_bundle, verify_sources


LAUNCHER = '''from pathlib import Path
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
    parser.add_argument("--game-controls", action="store_true")
    parser.add_argument("--volume-disable-sampling", action="store_true")
    parser.add_argument("--physical-audio-confirmed", action="store_true")
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
    arguments = ["--backend", manifest.get("backend", "c6i-vision"), "--build-id", manifest["build_id"], "--vision-board-test",
                 "--host", host, "--port", "8765",
                 "--bitstream", str(root / "overlay/c6v_candidate.bit"),
                 "--vision-manifest", str(root / "overlay/board_test_manifest.json"),
                 "--vision-camera-dir", str(root / "board/pynq_z2"),
                 "--vision-camera-sha256", "@CAMERA_SHA256@",
                 "--vision-output-dir", str(root / "var/vision"),
                 "--vision-bind", host, "--vision-port", "8081",
                 "--library-root", str(root / "var/library"),
                 "--lock-path", "/var/lock/voice-view-c6i.lock"]
    if check_only:
        arguments.append("--vision-check-only")
    if options.game_controls:
        arguments.append("--vision-game-input")
    if options.volume_disable_sampling:
        arguments.append("--volume-disable-sampling")
    if options.physical_audio_confirmed:
        arguments.append("--physical-audio-confirmed")
    return agent_main(arguments)


if __name__ == "__main__":
    raise SystemExit(main())
'''


def prepare(root: Path, candidate: Path, game: Path, case_path: Path, output: Path,
            *, additional_games: tuple[tuple[Path, Path], ...] = (), volume: bool = False) -> dict[str, object]:
    root, candidate, game, case_path, output = (path.resolve() for path in (root, candidate, game, case_path, output))
    archive_path = output.with_name(output.name + ".zip")
    if output.exists() or archive_path.exists():
        raise FileExistsError("Board-test output and archive must be new")
    receipt = (verify_volume_candidate_bundle if volume else verify_candidate_bundle)(candidate)
    build_id = 0xC0060C00 if volume else 0xC0060800
    build_tag = f"{build_id:08X}"
    verify_sources(root, root / "handoffs/gesture_vision_v61")
    subprocess.run([sys.executable, "-B", str(root / "handoffs/gesture_vision_v61/scripts/verify_handoff.py")],
                   check=True, cwd=root)
    sys.path.insert(0, str(root / "python"))
    from pynq_multimodal_game.game_testing import GameTestCase
    from pynq_multimodal_game.game_validation import run_game_test

    case = GameTestCase.load(case_path)
    report = run_game_test(game, case)
    if not report.passed or not case.assertions or report.package.manifest.target_build_id != build_id:
        raise ValueError("Asserted PC golden validation and fusion game identity required")
    validated_games = [(game, case_path, report)]
    game_ids = {report.package.manifest.game_id}
    for extra_game, extra_case in additional_games:
        extra_game, extra_case = extra_game.resolve(), extra_case.resolve()
        case = GameTestCase.load(extra_case)
        extra_report = run_game_test(extra_game, case)
        game_id = extra_report.package.manifest.game_id
        if (not extra_report.passed or not case.assertions
                or extra_report.package.manifest.target_build_id != build_id
                or game_id in game_ids):
            raise ValueError("Unique fusion games with asserted PC golden validation required")
        game_ids.add(game_id)
        validated_games.append((extra_game, extra_case, extra_report))
    dependency = distribution("collision")
    wheel = message_from_string(dependency.read_text("WHEEL") or "")
    if dependency.version != "1.2.2" or wheel["Root-Is-Purelib"] != "true" or dependency.requires:
        raise ValueError("The frozen collision==1.2.2 pure-Python distribution is required")
    output.mkdir(parents=True)
    for relative in ("python/pynq_multimodal_game", "board/pynq_z2/scripts", "handoffs/gesture_vision_v61",
                     "handoffs/pc_gesture_baseline_20261007"):
        source = root / relative
        shutil.copytree(source, output / relative, ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
    for relative in dependency.files or ():
        if "__pycache__" in relative.parts or relative.suffix == ".pyc":
            continue
        destination = (output / "python" / relative).resolve()
        if not destination.is_relative_to(output / "python"):
            raise ValueError("Dependency path escapes deployment: " + str(relative))
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(str(dependency.locate_file(relative)), destination)
    for source in (root / "board/pynq_z2").glob("*.py"):
        shutil.copy2(source, output / source.relative_to(root))
    for relative in ("board/pynq_z2/generated/pynq_z2_ps7_config.tcl",
                     "board/pynq_z2/constraints/camera_direct_plug_corrected.xdc",
                     "docs/c6i_vision_board_acceptance.md",
                     "docs/bringup/2026-10-05_pynq-z2_vision_v3_v4.md",
                     "docs/bringup/2026-10-06_pynq-z2_vision_fusion_board.md",
                     "docs/bringup/2026-10-08_selective_board_vision.md", "pyproject.toml"):
        destination = output / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(root / relative, destination)
    records = list((root / "docs/bringup").glob("2026-10-06_v[3-7]_*"))
    records += [root / "docs/bringup" / name for name in (
        "2026-10-06_debug_readback_probe.md", "2026-10-06_jump_state_repair.md",
        "2026-10-07_pc_live_vision_bridge.md", "2026-10-07_selected_pc_gesture_baseline.md",
        "PERFORMANCE_PLAN.md")]
    for source in records:
        shutil.copy2(source, output / source.relative_to(root))
    overlay = output / "overlay"
    overlay.mkdir()
    for name in CANDIDATE_FILES:
        shutil.copy2(candidate / name, overlay / name)
    (overlay / "board_test_manifest.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    games = output / "games"
    games.mkdir()
    shutil.copy2(game, games / ("game1-" + build_tag + ".vvg"))
    shutil.copy2(case_path, games / "c1-golden.json")
    report.save(games / "pc-golden-report.json")
    game_identities = {report.package.manifest.game_id: report.package.sha256}
    for extra_game, extra_case, extra_report in validated_games[1:]:
        game_id = extra_report.package.manifest.game_id
        shutil.copy2(extra_game, games / (game_id + "-" + build_tag + ".vvg"))
        shutil.copy2(extra_case, games / (game_id + "-golden.json"))
        extra_report.save(games / (game_id + "-pc-golden-report.json"))
        game_identities[game_id] = extra_report.package.sha256
    (output / "start_board_test.py").write_bytes(LAUNCHER.replace("@CAMERA_SHA256@", CAMERA_SHA256).encode("ascii"))
    identities = {}
    for path in sorted(output.rglob("*")):
        if path.is_file():
            if path.suffix == ".py":
                ast.parse(path.read_text(encoding="utf-8-sig"), filename=str(path), feature_version=(3, 10))
            identities[path.relative_to(output).as_posix()] = hashlib.sha256(path.read_bytes()).hexdigest().upper()
    manifest = {"schema": "c6i-vision-board-deployment-v1", "build_id": f"0x{build_id:08X}",
                "release_ready": False, "board_pending": True, "sha256": identities,
                "game_sha256": report.package.sha256, "pc_golden_pass": True,
                "games_sha256": game_identities,
                "python_syntax": "3.10", "agent_port": 8765, "vision_port": 8081}
    if volume:
        manifest["backend"] = "c6i-vision-volume"
        manifest["profile"] = "C6I_VISION_VOLUME_V1"
    (output / "deployment_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    subprocess.run([sys.executable, "-B", str(output / "start_board_test.py"), "--check-only"],
                   check=True, cwd=output)
    subprocess.run([sys.executable, "-B", str(output / "start_board_test.py"), "--check-only", "--game-controls"],
                   check=True, cwd=output)
    if volume:
        subprocess.run([sys.executable, "-B", str(output / "start_board_test.py"), "--check-only",
                        "--game-controls", "--volume-disable-sampling"], check=True, cwd=output)
    with zipfile.ZipFile(archive_path, "x", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
        for path in sorted(output.rglob("*")):
            if path.is_file():
                archive.write(path, path.relative_to(output.parent).as_posix())
    return {"status": "BOARD_TEST_PACKAGE_READY", "directory": str(output), "archive": str(archive_path),
            "archive_sha256": hashlib.sha256(archive_path.read_bytes()).hexdigest().upper(),
            "files": len(identities), "pc_golden_pass": True, "check_only_pass": True,
            "board_pending": True, "release_ready": False}


def main() -> int:
    parser = argparse.ArgumentParser(description="Prepare an isolated C6I visual board-acceptance deployment")
    parser.add_argument("--candidate-dir", type=Path, required=True)
    parser.add_argument("--game", type=Path, required=True)
    parser.add_argument("--test-case", type=Path, required=True)
    parser.add_argument("--additional-game", type=Path, nargs=2, action="append", default=[],
                        metavar=("VVG", "TEST_CASE"))
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--volume", action="store_true")
    args = parser.parse_args()
    result = prepare(Path(__file__).resolve().parents[3], args.candidate_dir, args.game, args.test_case, args.output,
                     additional_games=tuple(tuple(pair) for pair in args.additional_game), volume=args.volume)
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())