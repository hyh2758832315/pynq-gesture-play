"""Stage a separate PYNQ-Z2 / Vivado 2026.1 button-on-BUILD_ID-GPIO project.

Run: .venv/Scripts/python.exe -B subprojects/button_only/stage_button_shared_id.py
Output: D:/vvg_button_only_r23b/c6_latency.xpr and stage_receipt.json.
Next: run configure_button_shared_id.tcl; do not program hardware at this stage.
"""

from __future__ import annotations

import hashlib
import json
import shutil
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
SOURCE = Path("E:/vvl/c0e")
DEST = Path("D:/vvg_button_only_r23b")
IMPORTS = Path("c6_latency.srcs/sources_1/imports")
R20_SHA = "670fe8a91445e70d747b9f2f9c2a4686b32edc55831f4057dec6a59f50408e01"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    if DEST.exists():
        raise SystemExit(f"Refusing to overwrite stage: {DEST}")
    source_xpr = SOURCE / "c6_latency.xpr"
    if sha(source_xpr) != R20_SHA:
        raise SystemExit("Frozen R20 source XPR changed")
    rtl = REPO / "subprojects/button_only/rtl"
    for name in ("input_osd_pixels.sv", "input_osd_ctrl.sv", "input_osd_top.sv", "button_sync.sv"):
        if not (rtl / name).is_file():
            raise SystemExit(f"Missing {name}")
    DEST.mkdir()
    for name in ("c6_latency.srcs", "c6_latency.gen", "c6_latency.ip_user_files",
                 "c6_latency.cache", "latency-r01", "latency-r02"):
        if (SOURCE / name).exists():
            shutil.copytree(SOURCE / name, DEST / name)
    for name in ("input_osd_pixels.sv", "input_osd_ctrl.sv", "input_osd_top.sv"):
        shutil.copyfile(rtl / name, DEST / IMPORTS / name)
    old_prefix = "$PPRDIR/../../projects/fpga/voice-view-game"
    xpr_text = source_xpr.read_text(encoding="utf-8")
    if old_prefix not in xpr_text:
        raise SystemExit("Unexpected source project paths")
    xpr_text = xpr_text.replace(old_prefix, REPO.as_posix())
    xpr_text = xpr_text.replace("E:/vvl/c0e/c6_latency.xpr", (DEST / "c6_latency.xpr").as_posix())
    (DEST / "c6_latency.xpr").write_text(xpr_text, encoding="utf-8")
    receipt = {
        "board": "PYNQ-Z2 xc7z020clg400-1", "vivado": "2026.1",
        "source_xpr_sha256": R20_SHA,
        "rtl_sha256": {p.name: sha(p) for p in rtl.glob("*.sv")},
        "stage": DEST.as_posix(), "board_access": False,
        "next": "configure_button_shared_id.tcl",
    }
    (DEST / "stage_receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
    print(json.dumps(receipt, indent=2))


if __name__ == "__main__":
    main()
