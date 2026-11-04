"""Validate Vivado's generated R23 BD/HWH after its receipt-writing crash.

Run: .venv/Scripts/python.exe -B subprojects/button_only/finalize_shared_id_stage.py
Output: D:/vvg_button_only_r23b/configured_receipt.txt.
Next: run synthesize_button_shared_id.tcl; require clean synthesis and route before board use.
"""

from __future__ import annotations

import hashlib
from pathlib import Path
from xml.etree import ElementTree

ROOT = Path(__file__).resolve().parents[2]
STAGE = Path("D:/vvg_button_only_r23b")
HWH = STAGE / "c6_latency.gen/sources_1/bd/c6v/hw_handoff/c6v.hwh"


def parameters(module):
    return {p.get("NAME"): p.get("VALUE") for p in module.iter("PARAMETER")}


def main() -> None:
    receipt = STAGE / "configured_receipt.txt"
    if receipt.stat().st_size != 0:
        raise SystemExit("Refusing to overwrite a nonempty configuration receipt")
    log = (STAGE / "configure.log").read_text(errors="replace")
    if "validate_bd_design: Time" not in log or "Generated Hardware Definition File" not in log:
        raise ValueError("Vivado BD validation or HWH generation did not complete")
    if not any("EXCEPTION_ACCESS_VIOLATION" in p.read_text(errors="replace")
               for p in STAGE.glob("hs_err_pid*.log")):
        raise ValueError("This recovery path is only for the recorded post-validation crash")
    xpr = (STAGE / "c6_latency.xpr").read_text(errors="replace")
    if "button_only.xdc" not in xpr or "button_sync.sv" not in xpr or "voice_volume_top.sv" in xpr:
        raise ValueError("saved Vivado project sources are wrong")
    root = ElementTree.parse(HWH).getroot()
    modules = {m.get("INSTANCE"): m for m in root.iter("MODULE")}
    if "button_gpio" in modules or "voice_volume_0" in modules or "audio_mclk" in modules:
        raise ValueError("audio or standalone button IP remains")
    gpio = parameters(modules["build_id_gpio"])
    expected = {"C_BASEADDR": "0x41200000", "C_GPIO_WIDTH": "32",
                "C_ALL_INPUTS": "1", "C_IS_DUAL": "1", "C_GPIO2_WIDTH": "2",
                "C_ALL_INPUTS_2": "1"}
    if any(gpio.get(k) != v for k, v in expected.items()):
        raise ValueError(f"BUILD_ID GPIO channels differ: {gpio}")
    if parameters(modules["build_id_constant"]).get("CONST_VAL") != "0xC0061000":
        raise ValueError("wrong R23 build ID")
    ports = {p.get("NAME") for p in root.findall("./EXTERNALPORTS/PORT")}
    if "btn" not in ports or ports & {"bclk", "lrclk", "sdata_i", "sdata_o"}:
        raise ValueError("button/audio external ports differ")
    content = "\n".join((
        "board=PYNQ-Z2 xc7z020clg400-1", "vivado=2026.1",
        "buttons=build_id_gpio/channel_2", "button_offset=0x41200008",
        "button_width=2", "button_all_inputs=1", "build_id=0xC0061000",
        f"hwh_sha256={hashlib.sha256(HWH.read_bytes()).hexdigest().upper()}",
        "vivado_bd_validation=PASS", "vivado_generated_hwh=PASS",
        "vivado_receipt_phase=EXCEPTION_ACCESS_VIOLATION", "board_access=false", "",
    ))
    receipt.write_text(content, encoding="utf-8")
    print(content, end="")


if __name__ == "__main__":
    main()
