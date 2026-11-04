"""Replay the four board-tested packages against their recorded PYNQ output.

Run from project/: python -B sim/evidence/gpu_optimization/replay_pc.py --out build/output/game_compare
Requires the Studio Python dependencies. Outputs PC reports and summary.json.
Next: inspect the per-game matched ticks. This script never connects to hardware.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parents[2]
sys.path.insert(0, str(PROJECT / "src/studio/python"))
from pynq_multimodal_game.game_validation import GameTestCase, run_game_test, compare_test_reports


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()
    output = args.out.resolve()
    output.mkdir(parents=True, exist_ok=False)
    reference = json.loads((HERE / "game_replay_summary.json").read_text("utf-8"))
    results = []
    for item in reference["games"]:
        game = item["game"]
        package = HERE / "fixtures" / (game + ".vvg")
        if hashlib.sha256(package.read_bytes()).hexdigest() != item["package_sha256"]:
            raise ValueError("Package hash mismatch: " + game)
        case = GameTestCase.load(HERE / "game_replays" / (game + "-case.json"))
        report = run_game_test(package, case)
        report.save(output / (game + "-pc.json"))
        board = json.loads((HERE / "game_replays" / (game + "-pynq.json")).read_text("utf-8"))
        comparison = compare_test_reports(report.to_dict(), board)
        if not report.passed or comparison["status"] != "passed":
            raise AssertionError((game, comparison))
        results.append(dict(game=game, matched_ticks=comparison["matched_ticks"], status="passed"))
    summary = dict(result="PASS", physical_board_access=False, games=results)
    (output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n", "utf-8")
    print(json.dumps(summary))


if __name__ == "__main__":
    main()
