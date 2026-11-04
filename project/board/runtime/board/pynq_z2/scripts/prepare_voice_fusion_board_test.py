from __future__ import annotations

import argparse
import ast
from email import message_from_string
import hashlib
from importlib.metadata import distribution
import json
from pathlib import Path
import shutil
import subprocess
import sys
import zipfile


def prepare(root: Path, candidate: Path, driver_source: Path, contract: Path, output: Path) -> dict:
    from pynq_multimodal_game.agent.voice_backend import DRIVER_SHA256, verify_driver_sources
    from pynq_multimodal_game.agent.voice_fusion import (
        ARTIFACT_SHA256, BUILD_ID, PROFILE, SCHEMA, validate_receipt, verify_audio_hwh, verify_candidate,
    )
    from pynq_multimodal_game.game_testing import GameTestCase
    from pynq_multimodal_game.game_validation import build_verified_game, run_game_test
    from pynq_multimodal_game.voice_service import verify_frozen_source
    from verify_vision_integration_sources import verify_sources

    root, candidate, driver_source, contract, output = (
        path.resolve() for path in (root, candidate, driver_source, contract, output))
    archive = output.with_name(output.name + ".zip")
    if output.exists() or archive.exists():
        raise FileExistsError("Fusion deployment must use a new output and archive")
    dependencies = [distribution(name) for name in ("collision", "tomli", "tomli-w")]
    for dependency in dependencies:
        metadata = message_from_string(dependency.read_text("WHEEL") or "")
        if (metadata.get("Root-Is-Purelib") != "true"
                or any(path.suffix in (".pyd", ".so", ".dll") for path in dependency.files or ())):
            raise ValueError("ARM deployment requires pure Python dependency: " + dependency.metadata["Name"])
    report = json.loads(contract.read_text(encoding="utf-8-sig"))
    validate_receipt(report["receipt"])
    verify_audio_hwh(candidate / "c6v_candidate.hwh")
    provenance = verify_frozen_source()
    verify_sources(root, root / "handoffs/gesture_vision_v61")
    for directory, identities in ((candidate, ARTIFACT_SHA256), (driver_source, DRIVER_SHA256)):
        for name, digest in identities.items():
            if hashlib.sha256((directory / name).read_bytes()).hexdigest() != digest:
                raise ValueError(f"Frozen fusion input changed: {name}")
    output.mkdir(parents=True)
    overlay = output / "overlay"
    overlay.mkdir()
    for name in ARTIFACT_SHA256:
        shutil.copy2(candidate / name, overlay / name)
    manifest = {"schema": SCHEMA, "profile": PROFILE, "build_id": "0xC0060900",
                "runtime_registered": False, "board_pending": True, "release_ready": False,
                "sha256": ARTIFACT_SHA256, "implementation_receipt": report["receipt"],
                "voice_source_commit": provenance["source_commit"]}
    receipt = overlay / "voice_fusion_manifest.json"
    receipt.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    verify_candidate(overlay / "c6v_candidate.bit", receipt)
    for relative in ("python/pynq_multimodal_game", "handoffs/gesture_vision_v61",
                     "handoffs/pc_gesture_baseline_20261007", "board/pynq_z2/scripts"):
        shutil.copytree(root / relative, output / relative,
                        ignore=shutil.ignore_patterns("__pycache__", "*.pyc", "NA"))
    for path in (root / "board/pynq_z2").glob("*.py"):
        shutil.copy2(path, output / path.relative_to(root))
    driver_dir = output / "audio_driver"
    driver_dir.mkdir()
    for name in DRIVER_SHA256:
        shutil.copy2(driver_source / name, driver_dir / name)
    verify_driver_sources(driver_dir)
    for dependency in dependencies:
        if dependency.metadata["Name"] == "collision" and dependency.version != "1.2.2":
            raise ValueError("Frozen collision==1.2.2 required")
        for relative in dependency.files or ():
            if "__pycache__" in relative.parts or relative.suffix == ".pyc":
                continue
            destination = (output / "python" / relative).resolve()
            if not destination.is_relative_to(output / "python"):
                raise ValueError("Dependency path escapes fusion deployment")
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(dependency.locate_file(relative), destination)
    games = output / "games"
    games.mkdir()
    game_reports = {}
    selections = (
        (root / "candidates/game1-voice-s2", "s2-boundaries"),
        (root / "games/game1", "c1-golden"),
        (root / "games/game2", "rps-01-win"),
        (root / "games/game3", "kingdom-01-princess-win"),
    )
    for project, case_name in selections:
        package = build_verified_game(project, games / (project.name + ".vvg"), target_build_id=BUILD_ID)
        case_path = project / "tests/replays" / (case_name + ".json")
        case = GameTestCase.load(case_path)
        if not case.assertions:
            raise ValueError("Fusion package requires asserted golden cases")
        golden = run_game_test(package.path, case)
        golden.save(games / (project.name + "-pc-report.json"))
        if not golden.passed:
            raise RuntimeError(f"Fusion PC golden failed: {project.name}")
        shutil.copy2(case_path, games / (project.name + "-case.json"))
        game_reports[package.manifest.game_id] = {"sha256": package.sha256,
            "file": package.path.relative_to(output).as_posix(), "matched_ticks": len(golden.frames),
            "assertions": len(case.assertions), "target_build_id": BUILD_ID}
    for relative in ("docs/bringup/2026-10-13_voice_s3_fusion_implementation.md",
                     "docs/voice_game_fusion_plan_20261012.md", "pyproject.toml"):
        destination = output / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(root / relative, destination)
    shutil.copy2(candidate / "METHODOLOGY_RESOLUTION_REPORT.md", overlay / "METHODOLOGY_RESOLUTION_REPORT.md")
    shutil.copy2(root / "board/pynq_z2/scripts/run_voice_fusion_acceptance.py", output / "start_board_test.py")
    identities = {}
    for path in sorted(output.rglob("*")):
        if path.is_file():
            if path.suffix == ".py":
                ast.parse(path.read_text(encoding="utf-8-sig"), filename=str(path), feature_version=(3, 10))
            identities[path.relative_to(output).as_posix()] = hashlib.sha256(path.read_bytes()).hexdigest()
    deployment = {"schema": "voice-fusion-board-deployment-v1", "build_id": "0xC0060900",
                  "runtime_registered": False, "board_pending": True, "release_ready": False,
                  "sha256": identities, "games": game_reports, "python_syntax": "3.10",
                  "live_authorization_required": True, "nominal_packets": 900, "nominal_samples": 864000}
    (output / "deployment_manifest.json").write_text(json.dumps(deployment, indent=2) + "\n", encoding="utf-8")
    subprocess.run([sys.executable, "-B", str(output / "start_board_test.py"), "--check-only"],
                   check=True, cwd=output)
    with zipfile.ZipFile(archive, "x", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as bundle:
        for path in sorted(output.rglob("*")):
            if path.is_file():
                bundle.write(path, path.relative_to(output.parent).as_posix())
    return {"status": "OFFLINE_FUSION_RUNTIME_PACKAGE_VERIFIED_BOARD_PENDING", "files": len(identities),
            "archive": str(archive), "sha256": hashlib.sha256(archive.read_bytes()).hexdigest(),
            "games": game_reports, "runtime_registered": False, "board_pending": True, "release_ready": False}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--candidate-dir", type=Path, required=True)
    parser.add_argument("--driver-source", type=Path, required=True)
    parser.add_argument("--implementation-contract", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[3]
    sys.path.insert(0, str(root / "python"))
    print(json.dumps(prepare(root, args.candidate_dir, args.driver_source,
                             args.implementation_contract, args.output), indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())