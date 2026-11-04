"""Pair a routed R22 bitstream with the isolated button-only runtime.

Run: .venv/Scripts/python.exe -B subprojects/button_only/finalize_button_delivery.py
Output: deliveries/c6i-pl-vision-button-osd-r22-boardtest-20261024/.
Next: run its start_board_test.py --check-only, then recheck board gate.
"""

from __future__ import annotations

import hashlib
import json
import re
import shutil
from pathlib import Path, PurePosixPath
from xml.etree import ElementTree
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[2]
HARDWARE = Path("D:/vvg_button_only_r22")
SOFTWARE = Path("D:/vvg_button_only_package_stage")
SOURCE = ROOT / "deliveries/c6i-pl-vision-volume-osd-r21-marker-r02-20261023"
DEST = ROOT / "deliveries/c6i-pl-vision-button-osd-r22-boardtest-20261024"
BUILD_ID = "0xC0060F00"


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest().upper()


def read_timing(path: Path) -> dict[str, float]:
    report = path.read_text(encoding="utf-8", errors="replace")
    summary = report.split("Design Timing Summary", 1)[1]
    match = re.search(
        r"(?m)^\s*(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+\d+\s+\d+\s+"
        r"(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+\d+\s+\d+\s+"
        r"(-?\d+\.\d+)\s+(-?\d+\.\d+)", summary)
    if match is None:
        raise ValueError("missing numeric Vivado timing summary")
    names = ("wns", "tns", "whs", "ths", "wpws", "tpws")
    result = dict(zip(names, map(float, match.groups())))
    if any(result[name] < 0 for name in names):
        raise ValueError(f"timing signoff failed: {result}")
    return result


def verify_hwh(data: bytes) -> None:
    root = ElementTree.fromstring(data)
    modules = {m.get("INSTANCE"): m for m in root.iter("MODULE")}
    if "button_gpio" not in modules or "voice_volume_0" in modules or "audio_mclk" in modules:
        raise ValueError("wrong button-only HWH topology")
    params = {p.get("NAME"): p.get("VALUE") for p in modules["button_gpio"].iter("PARAMETER")}
    if (params.get("C_BASEADDR") != "0x43C10000" or params.get("C_GPIO_WIDTH") != "2"
            or params.get("C_ALL_INPUTS") != "1"):
        raise ValueError("wrong button GPIO parameters")
    build = {p.get("NAME"): p.get("VALUE") for p in modules["build_id_constant"].iter("PARAMETER")}
    if build.get("CONST_VAL") != BUILD_ID:
        raise ValueError("wrong BUILD_ID in HWH")
    external = {p.get("NAME") for p in root.findall("./EXTERNALPORTS/PORT")}
    if "btn" not in external or external & {
            "audio_clk_10MHz", "bclk", "lrclk", "sdata_i", "sdata_o", "codec_address"}:
        raise ValueError("wrong external button/audio ports")


def xsa_member(archive: ZipFile, suffix: str) -> bytes:
    members = [x for x in archive.infolist() if not x.is_dir()
               and PurePosixPath(x.filename).name.endswith(suffix)]
    if len(members) != 1:
        raise ValueError(f"expected exactly one XSA {suffix}, got {len(members)}")
    return archive.read(members[0])


def write_json(path: Path, value) -> None:
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def main() -> None:
    if DEST.exists():
        raise SystemExit(f"Refusing to overwrite final delivery: {DEST}")
    if not (HARDWARE / "incremental_final_receipt.txt").is_file():
        raise SystemExit("incremental hardware export is incomplete")
    timing = read_timing(HARDWARE / "incremental_final_timing.rpt")
    drc = (HARDWARE / "incremental_final_drc.rpt").read_text(errors="replace")
    if re.search(r"(?m)^\|\s*\S+\s*\|\s*(?:Error|Critical Warning)\s*\|", drc):
        raise ValueError("final DRC has an error or critical warning")
    xsa = HARDWARE / "exports/c6v_incremental.xsa"
    with ZipFile(xsa) as archive:
        bit_data = xsa_member(archive, ".bit")
        hwh_data = xsa_member(archive, "c6v.hwh")
    verify_hwh(hwh_data)
    for relative in ("python", "board", "handoffs"):
        if not (SOFTWARE / relative).is_dir():
            raise ValueError(f"missing staged {relative}")
    if not (SOFTWARE / "button_offline_receipt.json").is_file():
        raise ValueError("offline button tests did not pass")
    if (SOFTWARE / "button_offline_receipt.json").read_text().count('"PASS"') < 7:
        raise ValueError("offline button receipt incomplete")

    DEST.mkdir()
    for relative in ("python", "board", "handoffs", "tools"):
        source = SOFTWARE / relative
        if source.is_dir():
            shutil.copytree(source, DEST / relative,
                            ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
    shutil.copyfile(SOFTWARE / "start_board_test.py", DEST / "start_board_test.py")
    shutil.copyfile(ROOT / "subprojects/button_only/software/install_button_games.py",
                    DEST / "install_button_games.py")
    shutil.copyfile(SOURCE / "pyproject.toml", DEST / "pyproject.toml")
    (DEST / "games").mkdir()
    shutil.copytree(SOFTWARE / "games/button-only", DEST / "games/button-only")
    (DEST / "docs").mkdir()
    shutil.copyfile(ROOT / "subprojects/button_only/HANDOFF.md", DEST / "docs/HANDOFF.md")
    overlay = DEST / "overlay"
    overlay.mkdir()
    (overlay / "c6v_candidate.bit").write_bytes(bit_data)
    (overlay / "c6v_candidate.hwh").write_bytes(hwh_data)
    shutil.copyfile(xsa, overlay / "c6v_candidate.xsa")
    routed = HARDWARE / "c6_latency.runs/impl_button_incremental_r22/c6v_wrapper_postroute_physopt.dcp"
    if not routed.is_file():
        raise ValueError("post-route checkpoint missing")
    shutil.copyfile(routed, overlay / "candidate.dcp")
    for old, new in (("incremental_final_timing.rpt", "timing.rpt"),
                     ("incremental_final_drc.rpt", "drc.rpt"),
                     ("incremental_final_cdc.rpt", "cdc.rpt"),
                     ("incremental_final_bus_skew.rpt", "bus_skew.rpt"),
                     ("incremental_final_route_status.rpt", "route.rpt")):
        shutil.copyfile(HARDWARE / old, overlay / new)
    manifest = {
        "schema": "c6i-vision-button-offline-candidate-v1",
        "profile": "C6I_VISION_BUTTON_V1", "build_id": BUILD_ID,
        "implementation": "R21_REFERENCE_INCREMENTAL",
        "release_ready": False, "board_pending": True,
        "validation_scope": "timing/DRC, XSA bit/HWH pairing and offline button tests",
        "timing": timing,
        "sha256": {p.name: sha(p.read_bytes()) for p in sorted(overlay.glob("c6v_candidate.*"))},
    }
    write_json(overlay / "board_test_manifest.json", manifest)
    write_json(DEST / "candidate_stage.json", {
        "stage": "PAIRED_PREFLIGHT_READY",
        "profile": "C6I_VISION_BUTTON_V1", "target_build_id": BUILD_ID,
        "release_ready": False, "board_pending": True,
        "bit_sha256": manifest["sha256"]["c6v_candidate.bit"],
        "audio_sampling": False, "button_mapping": {"BTN0": "LOW", "BTN1": "HIGH"},
        "board_operations": False,
    })
    write_json(DEST / "board_test_plan.json", {
        "schema": "button-only-board-plan-v1", "board_pending": True,
        "build_id": BUILD_ID, "bit_sha256": manifest["sha256"]["c6v_candidate.bit"],
        "checks": ["board gate", "HWH/BUILD_ID", "idle BTN GPIO", "HDMI hand OSD",
                   "BTN0 and BTN1 physical press/game effects", "video/game coexistence"],
    })
    files = sorted(p for p in DEST.rglob("*") if p.is_file()
                   and p.name != "deployment_manifest.json")
    write_json(DEST / "deployment_manifest.json", {
        "schema": "c6i-vision-board-deployment-v1", "backend": "c6i-vision-button",
        "build_id": BUILD_ID, "release_ready": False, "board_pending": True,
        "sha256": {p.relative_to(DEST).as_posix(): sha(p.read_bytes()) for p in files},
    })
    print(json.dumps({"delivery": str(DEST), "timing": timing,
                      "bit_sha256": manifest["sha256"]["c6v_candidate.bit"],
                      "files": len(files)}, indent=2))


if __name__ == "__main__":
    main()
