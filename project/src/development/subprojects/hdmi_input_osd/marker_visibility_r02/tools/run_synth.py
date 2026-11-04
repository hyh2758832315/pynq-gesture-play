"""Bounded OOC audit with pre-run source fingerprints, never a production build."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import time


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--vivado", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    output = args.output.resolve()
    if output.exists() or output.with_suffix(".json").exists():
        raise FileExistsError(output)
    output.parent.mkdir(parents=True, exist_ok=True)
    sources = sorted((root / "rtl").glob("*.sv")) + [root / "constraints/osd_cdc.tcl", root / "tools/synthesize.tcl"]
    source_sha = {p.relative_to(root).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}
    command = [str(args.vivado), "-mode", "batch", "-nojournal", "-log", str(output.with_suffix(".log")),
               "-source", str(root / "tools/synthesize.tcl"), "-tclargs", str(output)]
    receipt = {"sources": source_sha, "command": command, "passed": False, "board_access": False}
    start = time.monotonic()
    try:
        result = subprocess.run(command, cwd=output.parent, capture_output=True, timeout=240)
        transcript = result.stdout.decode("utf-8", errors="replace") + result.stderr.decode("utf-8", errors="replace")
        output.with_suffix(".stdout.log").write_text(transcript, encoding="utf-8")
        receipt["returncode"] = result.returncode
        if result.returncode or not (output / "receipt.txt").is_file():
            raise RuntimeError(f"OOC audit failed, see {output.with_suffix('.stdout.log')}")
        if "OSD_OOC_SYNTH_COMPLETE" not in (output / "receipt.txt").read_text(encoding="utf-8"):
            raise RuntimeError("missing synth marker")
        for p in sources:
            if hashlib.sha256(p.read_bytes()).hexdigest() != source_sha[p.relative_to(root).as_posix()]:
                raise RuntimeError("source changed during synthesis")
        receipt["passed"] = True
        print("OSD_OOC_SYNTH_PASS", flush=True)
    finally:
        receipt["seconds"] = time.monotonic() - start
        output.with_suffix(".json").write_text(json.dumps(receipt, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
