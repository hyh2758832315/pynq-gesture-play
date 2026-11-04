from __future__ import annotations

import argparse
import ast
import hashlib
import json
from pathlib import Path, PurePosixPath
import xml.etree.ElementTree as ET
import zipfile


CAMERA_SHA256 = "B79C5735EA5C81B0EA4A95E805AEF3CDDF45D221BBD1906D76326D79B9E2E253"
IP_RELATIVE = "hardware/workspace/pl_accel_v1_build/camera_osd_v1_reference/board/pynq_z2/generated/rgb2dvi_v1_2"
NAMESPACE = {"spirit": "http://www.spiritconsortium.org/XMLSchema/SPIRIT/1685-2009"}
CANDIDATE_FILES = ("c6v_candidate.bit", "c6v_candidate.hwh", "c6v_candidate.xsa", "candidate.dcp",
                   "timing.rpt", "route.rpt", "drc.rpt", "methodology.rpt", "cdc.rpt",
                   "bus_skew.rpt", "clock_interaction.rpt", "exceptions.rpt", "utilization.rpt",
                   "effective_timing.xdc")


def verify_sources(root: Path, reference: Path) -> dict[str, object]:
    camera = root / "board/pynq_z2/capture_camera_direct_plug.py"
    required = [camera, root / "board/pynq_z2/ov5640_direct_plug_config.py",
                root / "board/pynq_z2/camera_driver.py",
                root / "board/pynq_z2/generated/pynq_z2_ps7_config.tcl",
                root / "board/pynq_z2/constraints/camera_direct_plug_corrected.xdc"]
    missing = [str(path) for path in required if not path.is_file()]
    if missing:
        raise FileNotFoundError("Missing integration source: " + ", ".join(missing))
    identities = {path.relative_to(root).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest().upper()
                  for path in required}
    actual = identities[camera.relative_to(root).as_posix()]
    if actual != CAMERA_SHA256:
        raise ValueError(f"Camera differs from verified board source: {actual}; expected {CAMERA_SHA256}")
    tree = ast.parse(camera.read_text(encoding="utf-8"))
    functions = {node.name for node in tree.body if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef))}
    needed = {"probe_chip_id", "configure_sensor", "open_frame_dma", "save_frame"}
    if not needed <= functions:
        raise ValueError("Camera API incomplete: " + ", ".join(sorted(needed - functions)))
    ip = reference / IP_RELATIVE
    component = ET.parse(ip / "component.xml")
    identity = [component.findtext("spirit:" + name, namespaces=NAMESPACE)
                for name in ("vendor", "library", "name", "version")]
    if identity != ["digilentinc.com", "ip", "rgb2dvi", "1.2"]:
        raise ValueError("Unexpected RGB2DVI IP identity")
    files = sorted({node.text for node in component.findall(".//spirit:file/spirit:name", NAMESPACE)
                    if node.text})
    if not files:
        raise ValueError("RGB2DVI file list is empty")
    for name in files + ["component.xml", "tmds_v1_0/tmds.xml", "tmds_v1_0/tmds_rtl.xml"]:
        path = (ip / name).resolve()
        if not path.is_relative_to(ip.resolve()):
            raise ValueError("IP reference escapes source directory")
        if not path.is_file():
            raise FileNotFoundError(path)
        identities["reference/" + path.relative_to(reference.resolve()).as_posix()] = hashlib.sha256(path.read_bytes()).hexdigest().upper()
    return {"status": "SOURCE_PREFLIGHT_PASS", "board_validated": False,
            "vivado_validated": False, "camera_sha256": actual,
            "ip_file_count": len(files), "sha256": identities}


def main() -> int:
    root = Path(__file__).resolve().parents[3]
    parser = argparse.ArgumentParser(description="Read-only vision integration source identity check")
    parser.add_argument("--root", type=Path, default=root)
    parser.add_argument("--reference", type=Path, default=root / "handoffs/gesture_vision_v61")
    candidate = parser.add_mutually_exclusive_group()
    candidate.add_argument("--candidate-hwh", type=Path)
    candidate.add_argument("--candidate-dir", type=Path)
    options = parser.parse_args()
    try:
        result = verify_sources(options.root.resolve(), options.reference.resolve())
        frozen = options.root.resolve() / "handoffs/gesture_vision_v61"
        if options.reference.resolve() != frozen:
            if result["sha256"] != verify_sources(options.root.resolve(), frozen)["sha256"]:
                raise ValueError("External IP source differs from frozen handoff")
            result["external_frozen_sha256_match"] = True
        if options.candidate_hwh is not None:
            result["candidate"] = verify_candidate_hwh(options.candidate_hwh)
        if options.candidate_dir is not None:
            result["candidate"] = verify_candidate_bundle(options.candidate_dir)
    except (OSError, ValueError, ET.ParseError, SyntaxError, KeyError, zipfile.BadZipFile) as error:
        print(json.dumps({"status": "SOURCE_PREFLIGHT_BLOCKED", "error": str(error)}, ensure_ascii=True))
        return 1
    print(json.dumps(result, indent=2, ensure_ascii=True))
    return 0


def verify_candidate_hwh(path: Path) -> dict[str, object]:
    return _verify_candidate_hwh(path, 0xC0060800)


def verify_volume_candidate_hwh(path: Path) -> dict[str, object]:
    return _verify_candidate_hwh(path, 0xC0060C00)


def _verify_candidate_hwh(path: Path, build_id: int) -> dict[str, object]:
    root = ET.parse(path).getroot()
    modules = {module.get("INSTANCE"): module for module in root.iter("MODULE")}
    if modules["skin_kernel"].get("MODTYPE") != "bgr_skin_dma":
        raise ValueError("SKN6 module identity mismatch")
    ranges = {}
    for memory in root.iter("MEMRANGE"):
        instance = memory.get("INSTANCE")
        if instance:
            bounds = (int(memory.attrib["BASEVALUE"], 0), int(memory.attrib["HIGHVALUE"], 0))
            if instance in ranges and ranges[instance] != bounds:
                raise ValueError(f"Ambiguous address range for {instance}")
            ranges[instance] = bounds
    expected = {"axi_dma": 0x40400000, "return_dma": 0x40410000,
                "build_id_gpio": 0x41200000, "render_trace_gpio": 0x41280000,
                "render_cycles_gpio": 0x41290000, "present_completion_gpio": 0x412B0000,
                "moments_dma": 0x40420000, "moments_reset": 0x413D0000,
                "frame_dma": 0x43000000, "camera_iic": 0x41600000, "demosaic": 0x43C00000}
    for name, base in expected.items():
        if ranges.get(name) != (base, base + 0xFFFF):
            raise ValueError(f"Candidate address mismatch for {name}: {ranges.get(name)} expected {base:#x}")
    control_ranges = sorted((base, high, name) for name, (base, high) in ranges.items() if 0x40000000 <= base < 0x80000000)
    for previous, current in zip(control_ranges, control_ranges[1:]):
        if current[0] <= previous[1]:
            raise ValueError(f"Control address overlap: {previous[2]} and {current[2]}")
    def parameters(name):
        return {value.get("NAME"): value.get("VALUE") for value in modules[name].iter("PARAMETER")}
    if parameters("frame_dma").get("C_INCLUDE_MM2S") != "0":
        raise ValueError("Shared vision VDMA must be capture-only")
    if int(parameters("build_id_constant")["CONST_VAL"], 0) != build_id:
        raise ValueError("Candidate BUILD_ID mismatch")
    if build_id == 0xC0060C00:
        if (ranges.get("voice_volume_0") != (0x43C10000, 0x43C10FFF)
                or modules["voice_volume_0"].get("MODTYPE") != "voice_volume_top"):
            raise ValueError("Candidate VOL1 module or address mismatch")
        expected_parameters = {
            "gp0_smc": {"NUM_MI": "31"},
            "ps7_0": {"PCW_EN_EMIO_I2C1": "1", "PCW_EN_I2C1": "1",
                       "PCW_I2C1_GRP_INT_ENABLE": "1", "PCW_I2C1_GRP_INT_IO": "EMIO",
                       "PCW_I2C1_I2C1_IO": "EMIO", "PCW_I2C1_PERIPHERAL_ENABLE": "1"},
            "audio_mclk": {"PRIM_IN_FREQ": "100.000", "CLKOUT1_REQUESTED_OUT_FREQ": "10.000"}}
        for instance, expected_values in expected_parameters.items():
            actual = parameters(instance)
            if any(actual.get(name) != value for name, value in expected_values.items()):
                raise ValueError(f"Candidate VOL1 parameters mismatch for {instance}")
        for channel in ("AW", "AR", "W", "R", "B"):
            for prefix in ("REG_", "C_REG_CONFIG_"):
                if parameters("vision_gp0_slice").get(prefix + channel) != "1":
                    raise ValueError(f"GP0 pipeline is not Full on {channel}")
    return {"status": "HWH_PREFLIGHT_PASS", "sha256": hashlib.sha256(path.read_bytes()).hexdigest().upper(),
            "address_segments": len(control_ranges), "build_id": f"0x{build_id:08X}",
            "board_validated": False, "routed": False}


def verify_candidate_bundle(directory: Path) -> dict[str, object]:
    return _verify_candidate_bundle(directory, volume=False)


def verify_volume_candidate_bundle(directory: Path) -> dict[str, object]:
    return _verify_candidate_bundle(directory, volume=True)


def _verify_candidate_bundle(directory: Path, *, volume: bool) -> dict[str, object]:
    directory = directory.resolve()
    identities = {}
    for name in CANDIDATE_FILES:
        path = directory / name
        if not path.is_file() or path.stat().st_size == 0:
            raise ValueError(f"Missing or empty candidate artifact: {name}")
        identities[name] = hashlib.sha256(path.read_bytes()).hexdigest().upper()
    hwh_path = directory / "c6v_candidate.hwh"
    hwh = verify_volume_candidate_hwh(hwh_path) if volume else verify_candidate_hwh(hwh_path)
    document = ET.parse(hwh_path).getroot()
    slices = [module for module in document.iter("MODULE") if module.get("INSTANCE") == "vision_gp0_slice"]
    if len(slices) != 1:
        raise ValueError("Candidate requires exactly one GP0 pipeline")
    parameters = {value.get("NAME"): value.get("VALUE") for value in slices[0].iter("PARAMETER")}
    for channel in ("AW", "AR", "W", "R", "B"):
        if parameters.get("REG_" + channel) != "1" or parameters.get("C_REG_CONFIG_" + channel) != "1":
            raise ValueError(f"GP0 pipeline is not Full on {channel}")
    with zipfile.ZipFile(directory / "c6v_candidate.xsa") as archive:
        for archived_name, external_name in (("c6v_candidate.bit", "c6v_candidate.bit"),
                                              ("c6v.hwh", "c6v_candidate.hwh")):
            members = [member for member in archive.infolist()
                       if not member.is_dir() and PurePosixPath(member.filename).name == archived_name]
            if len(members) != 1:
                raise ValueError(f"XSA requires exactly one {archived_name}")
            if archive.read(members[0]) != (directory / external_name).read_bytes():
                raise ValueError(f"XSA pairing mismatch: {external_name}")
        return {"status": "OFFLINE_CANDIDATE_PAIR_PASS",
            "schema": "c6i-vision-volume-offline-candidate-v1" if volume else "c6i-vision-offline-candidate-v1",
            "profile": "C6I_VISION_VOLUME_V1" if volume else "C6I_VISION",
            "build_id": "0xC0060C00" if volume else "0xC0060800", "release_ready": False,
            "board_pending": True, "validation_scope": "file identity, HWH topology and XSA pairing only",
            "report_review_required": True, "sha256": identities, "hwh": hwh,
            "gp0_full_channels": 5, "xsa_contents_match": True}


if __name__ == "__main__":
    raise SystemExit(main())