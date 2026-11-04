from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path
from xml.etree import ElementTree as ET

from ..voice_service import verify_frozen_source


BUILD_ID = 0xC0060900
PROFILE = "C6I_VISION_VOICE_S3"
SCHEMA = "voice-fusion-offline-candidate-v1"
ARTIFACT_SHA256 = {
    "c6v_candidate.bit": "21cbfa5ecbb9d7a6c9946f30427d776e934da3d0bd8c60ee023f69b89ab2da5a",
    "c6v_candidate.hwh": "cb88d7940b7d943b9b1b7d34723ee35ce3dfba56c749a9e653ffc30e187ba22f",
    "c6v_candidate.xsa": "0c1771e1613f83caf775283fb858e6d69dab18eae39e7417eb971bada47f05aa",
    "candidate.dcp": "4c097e75447656b4411721d123b9f1ff1b9f842e819936e45c2e7dbfed047ebf",
}
AUDIO_IPS = frozenset({"voice_pcm_dma", "voice_capture", "voice_codec_iic"})
DMA_PARAMETERS = {
    "C_INCLUDE_SG": 1, "C_INCLUDE_S2MM": 1, "C_INCLUDE_MM2S": 0,
    "C_M_AXI_S2MM_DATA_WIDTH": 32, "C_S_AXIS_S2MM_TDATA_WIDTH": 32,
    "C_SG_LENGTH_WIDTH": 16, "C_S2MM_BURST_SIZE": 16,
    "C_INCLUDE_S2MM_DRE": 0, "C_MICRO_DMA": 0,
    "C_SG_INCLUDE_STSCNTRL_STRM": 0,
}


def validate_receipt(receipt: dict) -> None:
    expected = {
        "schema": "voice-fusion-implementation-receipt-v1", "build_id": "0xC0060900",
        "cdc_paths": 4, "cdc_limit_ns": 10.0, "drc_errors": 0,
        "methodology_critical": 0, "methodology_warnings": 42, "assigned_pins": 161,
        "runtime_registered": False, "board_pending": True, "release_ready": False,
    }
    if type(receipt) is not dict:
        raise ValueError("Fusion implementation receipt required")
    for name, value in expected.items():
        actual = receipt.get(name)
        if isinstance(value, float):
            valid = type(actual) in (int, float) and actual == value
        else:
            valid = type(actual) is type(value) and actual == value
        if not valid:
            raise ValueError(f"Fusion receipt mismatch: {name}")
    for name in ("setup_ns", "hold_ns"):
        value = receipt.get(name)
        if type(value) not in (int, float) or not math.isfinite(value) or value < 0:
            raise ValueError(f"Invalid fusion timing receipt: {name}")
    if receipt["setup_ns"] != 0.015 or receipt["hold_ns"] != 0.051:
        raise ValueError("Fusion receipt differs from sealed timing")


def _verify_audio_hwh(path: Path, *, build_id: int) -> None:
    document = ET.parse(path)
    modules = list(document.iter("MODULE"))
    by_name = {module.get("INSTANCE"): module for module in modules}
    if len(modules) != 62 or len(by_name) != 62:
        raise ValueError("Fusion HWH must contain 62 unique modules")
    constant = by_name.get("build_id_constant")
    if constant is None:
        raise ValueError("Fusion HWH BUILD_ID is missing")
    constants = {item.get("NAME"): item.get("VALUE") for item in constant.iter("PARAMETER")}
    if int(constants.get("CONST_VAL", "-1"), 0) != build_id:
        raise ValueError("Fusion HWH BUILD_ID mismatch")
    for name, base, modtype in (
        ("voice_pcm_dma", 0x40430000, "axi_dma"),
        ("voice_capture", 0x413E0000, "voice_i2s_dma_capture_axi"),
        ("voice_codec_iic", 0x43C10000, "axi_iic"),
    ):
        module = by_name.get(name)
        if module is None or module.get("MODTYPE") != modtype:
            raise ValueError(f"Fusion HWH IP mismatch: {name}")
        ranges = [item for item in document.iter("MEMRANGE")
                  if item.get("INSTANCE") == name and item.get("MEMTYPE") == "REGISTER"]
        if len(ranges) != 1 or (int(ranges[0].get("BASEVALUE", "-1"), 0),
                                int(ranges[0].get("HIGHVALUE", "-1"), 0)) != (base, base + 0xFFFF):
            raise ValueError(f"Fusion HWH address mismatch: {name}")
    dma = {item.get("NAME"): item.get("VALUE") for item in by_name["voice_pcm_dma"].iter("PARAMETER")}
    for name, expected in DMA_PARAMETERS.items():
        if int(dma.get(name, "-1"), 0) != expected:
            raise ValueError(f"Fusion SG DMA parameter mismatch: {name}")


def verify_audio_hwh(path: Path) -> None:
    _verify_audio_hwh(path, build_id=BUILD_ID)


def verify_candidate(bitstream: Path, manifest_path: Path) -> dict:
    bitstream, manifest_path = Path(bitstream).resolve(strict=True), Path(manifest_path).resolve(strict=True)
    manifest = json.loads(manifest_path.read_text(encoding="utf-8-sig"))
    expected = {"schema": SCHEMA, "profile": PROFILE, "build_id": "0xC0060900",
                "runtime_registered": False, "board_pending": True, "release_ready": False}
    if type(manifest) is not dict:
        raise ValueError("Fusion candidate manifest required")
    for name, value in expected.items():
        if type(manifest.get(name)) is not type(value) or manifest[name] != value:
            raise ValueError(f"Fusion candidate gate mismatch: {name}")
    if bitstream.name != "c6v_candidate.bit":
        raise ValueError("Sealed fusion bitstream name required")
    if manifest.get("sha256") != ARTIFACT_SHA256:
        raise ValueError("Fusion candidate identities differ from sealed artifacts")
    for name, expected_sha in ARTIFACT_SHA256.items():
        path = (bitstream.parent / name).resolve(strict=True)
        if path.parent != bitstream.parent or hashlib.sha256(path.read_bytes()).hexdigest() != expected_sha:
            raise ValueError(f"Fusion artifact SHA mismatch: {name}")
    validate_receipt(manifest.get("implementation_receipt"))
    verify_audio_hwh(bitstream.with_suffix(".hwh"))
    provenance = verify_frozen_source()
    if manifest.get("voice_source_commit") != provenance["source_commit"]:
        raise ValueError("Frozen voice source commit mismatch")
    return manifest