"""Preserve r15 gameplay byte-for-byte; double-build new target identity.

Run with project venv: .venv/Scripts/python.exe -B .../retarget_games.py
Outputs: games/osd-c0d, eight complete PC reports, g09 receipt.
Next: same candidate packages and cases on the real board.
"""
import hashlib
import argparse
import json
import os
from pathlib import Path
import sys
import tempfile
from zipfile import ZipFile

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
CHILD = REPO / "deliveries/c6i-vision-volume-osd-r16-20261022"
sys.path.insert(0, str(CHILD / "python"))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--attempt", required=True)
    args = parser.parse_args()
    if not args.attempt.isalnum():
        raise ValueError("attempt must be alphanumeric")
    from pynq_multimodal_game.game_package import validate_game_package
    from pynq_multimodal_game.game_runner import GameRunner
    from pynq_multimodal_game.game_sdk import GameInput
    from pynq_multimodal_game.game_testing import GameTestCase
    from pynq_multimodal_game.game_validation import build_verified_game, run_game_test
    work = HERE / ("evidence/g09-games-" + args.attempt)
    output = CHILD / ("games/osd-c0d-" + args.attempt)
    if work.exists() or output.exists():
        raise FileExistsError("preserve previous experiment")
    work.mkdir()
    output.mkdir()
    temporary = work / "tmp"
    temporary.mkdir()
    os.environ["TMP"] = os.environ["TEMP"] = str(temporary)
    tempfile.tempdir = str(temporary)
    parent = json.loads((CHILD / "games/unified/verification.json").read_text(encoding="utf-8"))
    record = dict(status="RUNNING", board_validated=False, packages={}, cases=[])
    receipt = work.with_suffix(".json")
    try:
        for name in sorted({r["package"] for r in parent["cases"]}):
            original = CHILD / "games" / name
            info = validate_game_package(original)
            stage = work / name[:-4]
            stage.mkdir()
            with ZipFile(original) as archive:
                # Validated files excludes generated package.json.
                for member in info.files:
                    path = stage / member
                    path.parent.mkdir(parents=True, exist_ok=True)
                    path.write_bytes(archive.read(member))
            target_name = name.replace("C0060C00", "C0060D00")
            built = build_verified_game(stage, output / target_name, target_build_id=0xC0060D00)
            with ZipFile(original) as left, ZipFile(built.path) as right:
                assert set(left.namelist()) == set(right.namelist())
                unchanged = [m for m in left.namelist() if m not in ("game.toml", "package.json")]
                assert all(left.read(m) == right.read(m) for m in unchanged)
            with GameRunner(built.path, render_rgb=False) as runner:
                first = runner.step(GameInput(0, 0, False, 0, 0, 0, False))
                size = len(first.asset_packet)
                assert 0 < size <= 32880
            record["packages"][target_name] = dict(sha256=built.sha256, length=built.length,
                parent_sha256=info.sha256, unchanged_gameplay_files=len(unchanged), asset_packet_bytes=size)
        for case_entry in parent["cases"]:
            case_id = case_entry["test_id"]
            case = GameTestCase.load(CHILD / f"games/unified/{case_id}.json")
            name = case_entry["package"].replace("C0060C00", "C0060D00")
            report = run_game_test(output / name, case)
            report.save(output / f"{case_id}.pc-report.json")
            case.save(output / f"{case_id}.json")
            actual = report.to_dict()
            assert report.passed, actual
            previous = json.loads((CHILD / f"games/unified/{case_id}.pc-report.json").read_text(encoding="utf-8"))
            assert actual["test_sha256"] == previous["test_sha256"]
            assert actual["frames"] == previous["frames"], f"r15 gameplay divergence: {case_id}"
            assert actual["assertions"] == previous["assertions"]
            record["cases"].append(dict(package=name, test_id=case_id, ticks=len(report.frames),
                                       parent_frames_exact_match=True))
            print("C0D_PC_GOLDEN_PASS", case_id, len(report.frames), flush=True)
        record["status"] = "DOUBLE_BUILD_PC_AND_R15_FRAME_EQUIVALENCE_PASS"
        (output / "verification.json").write_text(json.dumps(record, indent=2), encoding="utf-8")
    except BaseException as error:
        record.update(status="FAIL", error=f"{type(error).__name__}: {error}")
        raise
    finally:
        with receipt.open("x", encoding="utf-8") as stream:
            json.dump(record, stream, indent=2)


if __name__ == "__main__":
    main()
