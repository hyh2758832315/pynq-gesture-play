"""Run only this isolated subproject, with explicit tools and bounded subprocesses."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import time


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bin", required=True, type=Path, help="Vivado 2026.1 bin directory")
    parser.add_argument("--output", required=True, type=Path, help="New, unoccupied run directory")
    parser.add_argument("--full-hdmi", action="store_true")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    sources = sorted((root / "rtl").glob("*.sv")) + [root / "sim/tb_input_osd.sv"]
    commands = [
        [str(args.bin / "xvlog.bat"), "--sv", *(["--define", "FULL_HDMI"] if args.full_hdmi else []),
         *(str(path) for path in sources)],
        [str(args.bin / "xelab.bat"), "tb_input_osd", "-s", "osd_test", "--mt", "off"],
        [str(args.bin / "xsim.bat"), "osd_test", "-runall"],
    ]
    receipt = {"sources": {str(p.relative_to(root)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},
               "full_hdmi": args.full_hdmi, "steps": [], "board_access": False, "passed": False}
    try:
        for index, command in enumerate(commands):
            start = time.monotonic()
            result = subprocess.run(command, cwd=output, capture_output=True, timeout=180)
            transcript = result.stdout.decode("utf-8", errors="replace") + result.stderr.decode("utf-8", errors="replace")
            (output / f"step-{index}.log").write_text(transcript, encoding="utf-8")
            receipt["steps"].append({"command": command, "returncode": result.returncode,
                                      "seconds": time.monotonic() - start})
            print(f"OSD_STAGE {index} returncode={result.returncode}", flush=True)
            if result.returncode or "FATAL:" in transcript or "Fatal:" in transcript:
                raise RuntimeError(f"stage {index} failed; see {output / f'step-{index}.log'}")
            if index == 2:
                lines = [line for line in transcript.splitlines() if "TEST_PASS input_osd " in line]
                if len(lines) != 1:
                    raise RuntimeError("missing unique terminal test PASS")
                receipt["verdict"] = lines[0]
                print(lines[0], flush=True)
        receipt["passed"] = True
    finally:
        (output / "receipt.json").write_text(json.dumps(receipt, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
