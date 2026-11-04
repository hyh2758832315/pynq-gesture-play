"""Verify this candidate and seal its independent test/synthesis evidence."""
from __future__ import annotations

import argparse
import ast
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def check_source_receipt(root: Path, receipt: dict) -> None:
    if receipt.get("passed") is not True or receipt.get("board_access") is not False:
        raise ValueError("unverified or non-offline receipt")
    for name, expected in receipt["sources"].items():
        path = (root / name.replace("\\", "/")).resolve()
        if root not in path.parents or sha(path) != expected:
            raise ValueError(f"source mismatch: {name}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--xsim", required=True, type=Path, help="final full-HDMI run directory")
    parser.add_argument("--synth", required=True, type=Path, help="run_synth.py output directory")
    parser.add_argument("--output", required=True, type=Path, help="new evidence directory")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=False)
    result = {"status": "FAIL", "board_access": False, "release_ready": False,
              "integration": "NOT_APPLIED", "source_sha256": {}}
    try:
        pyfiles = sorted(root.glob("*.py")) + sorted((root / "tools").glob("*.py")) + sorted((root / "tests").glob("*.py"))
        for path in pyfiles:
            ast.parse(path.read_text(encoding="utf-8"), filename=str(path), feature_version=(3, 10))
        env = {**os.environ, "PYTHONPATH": str(root), "PYTHONDONTWRITEBYTECODE": "1"}
        tests = subprocess.run([sys.executable, "-B", "-m", "unittest", "discover", "-s", str(root / "tests"), "-v"],
                               capture_output=True, timeout=30, env=env, cwd=root)
        test_log = tests.stdout.decode("utf-8", errors="replace") + tests.stderr.decode("utf-8", errors="replace")
        (out / "publisher-tests.log").write_text(test_log, encoding="utf-8")
        if tests.returncode or not re.search(r"Ran \d+ tests", test_log) or not test_log.rstrip().endswith("OK"):
            raise ValueError("publisher regression failed")
        xsim_dir, synth_dir = args.xsim.resolve(), args.synth.resolve()
        xsim = json.loads((xsim_dir / "receipt.json").read_text(encoding="utf-8"))
        synth = json.loads(synth_dir.with_suffix(".json").read_text(encoding="utf-8"))
        check_source_receipt(root, xsim)
        check_source_receipt(root, synth)
        if not xsim["full_hdmi"] or len(xsim["steps"]) != 3 or any(step["returncode"] for step in xsim["steps"]):
            raise ValueError("incomplete full-HDMI simulation")
        transcript = (xsim_dir / "step-2.log").read_text(encoding="utf-8")
        if transcript.count("TEST_PASS input_osd ") != 1 or "width=1280 height=720" not in transcript or "Fatal:" in transcript:
            raise ValueError("invalid XSim verdict")
        util = (synth_dir / "utilization.rpt").read_text(encoding="utf-8")
        for name in ("LUT as Memory", "Block RAM Tile", "DSPs", "Register as Latch"):
            if not re.search(r"\|\s*" + re.escape(name) + r"\s*\|\s*0\s*\|", util):
                raise ValueError(f"nonzero unexpected resource: {name}")
        cdc = (synth_dir / "cdc.rpt").read_text(encoding="utf-8")
        if "Critical" in cdc:
            raise ValueError("critical CDC requires investigation")
        warning = re.search(r"^CDC-15\s+Warning\s+(\d+)", cdc, re.MULTILINE)
        if not warning:
            raise ValueError("missing bundled-data CDC review information")
        resource_counts = {}
        for name in ("Slice LUTs*", "Slice Registers", "Block RAM Tile", "DSPs"):
            match = re.search(r"\|\s*" + re.escape(name) + r"\s*\|\s*(\d+)\s*\|", util)
            if match is None:
                raise ValueError(f"missing resource count: {name}")
            resource_counts[name] = int(match.group(1))
        if "All user specified timing constraints are met." not in (synth_dir / "timing.rpt").read_text(encoding="utf-8"):
            raise ValueError("OOC constrained timing audit failed")
        result.update(status="OFFLINE_VERIFIED", python=sys.version, python310_ast_files=len(pyfiles),
                      publisher_tests=int(re.search(r"Ran (\d+) tests", test_log).group(1)),
                      xsim_verdict=xsim["verdict"], resources=resource_counts,
                      cdc=f"{warning.group(1)} CDC-15 warnings, manual full-design review pending",
                      exclusions=["full-parent BD attach", "whole-design routing/STA/CDC", "ARM load", "HDMI/physical latency", "live-source adapter wiring"])
        for directory in (root / "rtl", root / "sim", root / "constraints", root / "tools", root / "tests"):
            for path in sorted(directory.iterdir()):
                if path.is_file():
                    result["source_sha256"][path.relative_to(root).as_posix()] = sha(path)
        result["source_sha256"]["osd_publisher.py"] = sha(root / "osd_publisher.py")
        result["evidence_sha256"] = {}
        for path in [xsim_dir / "receipt.json", *(xsim_dir / f"step-{i}.log" for i in range(3)),
                     synth_dir.with_suffix(".json"), synth_dir.with_suffix(".stdout.log"),
                     *(synth_dir / name for name in ("receipt.txt", "utilization.rpt", "timing.rpt", "cdc.rpt", "drc.rpt", "bus_skew.rpt"))]:
            result["evidence_sha256"][path.relative_to(root).as_posix()] = sha(path)
        print(f"OSD_OFFLINE_PASS publisher_tests={result['publisher_tests']} no_bram=true no_dsp=true board_pending=true")
    finally:
        (out / "verification.json").write_text(json.dumps(result, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
