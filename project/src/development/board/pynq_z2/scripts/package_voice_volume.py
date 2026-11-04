"""Build/verify the isolated VOL1 candidate. No board access or deployment."""

import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET
import zipfile


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def validate_reset_contract(hardware):
    modules = {module.get("INSTANCE"): module for module in hardware.findall(".//MODULES/MODULE")}
    reset = modules.get("control_reset")
    if reset is None:
        raise ValueError("VOL1 reset module missing")
    parameters = {node.get("NAME"): node.get("VALUE") for node in reset.findall("./PARAMETERS/PARAMETER")}
    if parameters.get("C_EXT_RESET_HIGH") != "0" or parameters.get("C_AUX_RESET_HIGH") != "1":
        raise ValueError("VOL1 reset polarity mismatch")
    for source, source_port, target, target_port in (
        ("constant_low", "dout", "control_reset", "aux_reset_in"),
        ("ps7_0", "FCLK_RESET0_N", "control_reset", "ext_reset_in"),
        ("control_reset", "peripheral_aresetn", "control_axi", "aresetn"),
        ("control_reset", "peripheral_aresetn", "voice_volume_0", "s_axi_aresetn"),
    ):
        nets = []
        for instance, port_name in ((source, source_port), (target, target_port)):
            module = modules.get(instance)
            ports = [] if module is None else module.findall(f"./PORTS/PORT[@NAME='{port_name}']")
            if len(ports) != 1 or not ports[0].get("SIGNAME"):
                raise ValueError(f"VOL1 reset port missing or ambiguous: {instance}/{port_name}")
            nets.append(ports[0].get("SIGNAME"))
        if nets[0] != nets[1]:
            raise ValueError(f"VOL1 reset connection mismatch: {target}/{target_port}")
    return {"ext_reset_high": 0, "aux_reset_high": 1, "connections": 4}


def validate_content(root, evidence_relative="results/game-validation/voice-volume-only-20261019", round_name=None):
    artifacts = root / "artifacts"
    bit = (artifacts / "voice_volume.bit").read_bytes()
    if len(bit) < 1_000_000:
        raise ValueError("truncated bitstream")
    with zipfile.ZipFile(artifacts / "voice_volume.xsa") as archive:
        bits = [name for name in archive.namelist() if name.endswith(".bit")]
        if len(bits) != 1 or archive.read(bits[0]) != bit:
            raise ValueError("XSA bitstream differs from exported bitstream")
    hardware = ET.parse(artifacts / "voice_volume.hwh").getroot()
    modules = {module.get("INSTANCE"): module.get("MODTYPE") for module in hardware.findall(".//MODULES/MODULE")}
    expected = {"audio_mclk": "clk_wiz", "constant_high": "xlconstant", "constant_low": "xlconstant",
                "control_axi": "axi_protocol_converter", "control_reset": "proc_sys_reset",
                "ps7_0": "processing_system7", "voice_volume_0": "voice_volume_top"}
    if modules != expected:
        raise ValueError(f"unexpected hardware modules: {modules}")
    reset_contract = validate_reset_contract(hardware)
    segments = hardware.findall(".//MEMRANGE[@INSTANCE='voice_volume_0']")
    if len(segments) != 1 or int(segments[0].get("BASEVALUE"), 16) != 0x43C00000 or int(segments[0].get("HIGHVALUE"), 16) != 0x43C00FFF:
        raise ValueError("VOL1 address segment mismatch")
    rtl = (root / "rtl/voice_volume/axi_voice_volume.sv").read_text(encoding="utf-8").lower()
    if "32'hc00c0001" not in rtl or "32'h564f4c31" not in rtl:
        raise ValueError("VOL1 RTL identity missing")
    evidence_path = PurePosixPath(evidence_relative)
    if evidence_path.is_absolute() or ".." in evidence_path.parts or "\\" in evidence_relative or ":" in evidence_relative:
        raise ValueError("unsafe evidence path")
    if round_name is not None and re.fullmatch(r"r[0-9]+", round_name) is None:
        raise ValueError("invalid evidence round")
    evidence = root / evidence_path
    timing = (evidence / "routed-timing.rpt").read_text(encoding="utf-8")
    row = re.search(r"\n\s*(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+(\d+)\s+\d+\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+(\d+)\s+\d+\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+(\d+)\s+\d+", timing)
    if row is None:
        raise ValueError("timing summary row missing")
    values = list(map(float, row.groups()))
    if any(values[index] < 0 for index in (0, 3, 6)) or any(values[index] != 0 for index in (1, 2, 4, 5, 7, 8)):
        raise ValueError(f"timing gate failed: {values}")
    for name in ("routed-drc.rpt", "routed-methodology.rpt"):
        if not re.search(r"Checks found:\s+0\b", (evidence / name).read_text(encoding="utf-8")):
            raise ValueError(f"nonzero checks in {name}")
    route = (evidence / "routed-status.rpt").read_text(encoding="utf-8")
    if not re.search(r"nets with routing errors\.+\s*:\s*0", route):
        raise ValueError("routing errors")
    for case, legacy_round in (("core", "r11"), ("numeric", "r10"), ("axi", "r10"), ("i2s", "r10"), ("link", "r10")):
        text = (evidence / f"{case}-{round_name or legacy_round}.log").read_text(encoding="utf-8")
        if f"VOLUME_{case.upper()}_PASS" not in text or re.search(r"Fatal:|_FAIL|_WATCHDOG", text):
            raise ValueError(f"RTL regression failed: {case}")
    if round_name is not None:
        text = (evidence / f"bd-{round_name}.log").read_text(encoding="utf-8")
        if "VOLUME_BD_EXTENDED_PASS idle_resets=2 audio_frames=1024" not in text or "VOLUME_BD_DIAGNOSTIC_PASS expect_stuck=0" not in text or re.search(r"Fatal:|_FAIL|_WATCHDOG", text):
            raise ValueError("BD extended regression failed")
    return {"wns_ns": values[0], "whs_ns": values[3], "wpws_ns": values[6], "modules": modules,
            "reset_contract": reset_contract}


def verify(root, archive_path=None):
    manifest = json.loads((root / "deployment_manifest.json").read_text(encoding="utf-8"))
    entries = manifest["files"]
    actual = {path.relative_to(root).as_posix() for path in root.rglob("*") if path.is_file()}
    if actual != {entry["path"] for entry in entries} | {"deployment_manifest.json"}:
        raise ValueError("unexpected or missing package members")
    for entry in entries:
        data = (root / entry["path"]).read_bytes()
        if len(data) != entry["bytes"] or sha256(data) != entry["sha256"]:
            raise ValueError(f"hash mismatch: {entry['path']}")
    if archive_path is not None:
        with zipfile.ZipFile(archive_path) as archive:
            names = archive.namelist()
            if len(names) != len(set(names)) or set(names) != {f"{root.name}/{name}" for name in actual}:
                raise ValueError("ZIP member set mismatch")
            if archive.testzip() is not None:
                raise ValueError("ZIP CRC mismatch")
            for name in actual:
                if archive.read(f"{root.name}/{name}") != (root / name).read_bytes():
                    raise ValueError(f"ZIP bytes differ: {name}")
    evidence = manifest.get("evidence", {})
    result = validate_content(root, **evidence)
    print(json.dumps({"VOLUME_PACKAGE_VERIFIED": True, "files": len(entries), **result}, sort_keys=True))


def pack(repo, artifacts, platform, output, evidence, round_name):
    evidence = evidence.resolve()
    evidence_relative = evidence.relative_to(repo.resolve()).as_posix()
    if re.fullmatch(r"r[0-9]+", round_name) is None:
        raise ValueError("invalid evidence round")
    archive_path = output.with_suffix(".zip")
    if output.exists() or archive_path.exists():
        raise ValueError("refusing existing delivery or ZIP")
    output.mkdir(parents=True)
    sources = [*repo.glob("rtl/voice_volume/*.sv"), *repo.glob("sim/voice_volume/*.sv"),
               repo / "python/pynq_multimodal_game/volume_monitor.py",
               *repo.glob("sim/voice_volume/test_*.py"), *repo.glob("board/pynq_z2/scripts/*voice_volume*"),
               repo / "board/pynq_z2/generated/pynq_z2_ps7_config.tcl",
               repo / "board/pynq_z2/constraints/voice_volume.xdc", repo / "docs/voice_dual_volume_subproject.md",
               repo / "docs/bringup/2026-10-19_voice_volume_offline.md"]
    sources.extend(path for path in evidence.iterdir() if path.suffix in {".rpt", ".log", ".xdc", ".json", ".xml", ".sv"})
    for source in sources:
        if not source.is_file():
            raise ValueError(f"required source missing: {source}")
        target = output / source.relative_to(repo)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
    (output / "artifacts").mkdir()
    for suffix in ("bit", "hwh", "xsa"):
        shutil.copy2(artifacts / f"voice_volume.{suffix}", output / f"artifacts/voice_volume.{suffix}")
    for run in ("synth_1", "impl_1", "volume_voice_volume_0_0_synth_1"):
        shutil.copy2(platform / f"voice_volume.runs/{run}/runme.log", output / evidence.relative_to(repo) / f"{run}-final.log")
    result = subprocess.run([sys.executable, "-B", str(output / "sim/voice_volume/test_control.py")], capture_output=True, text=True, timeout=20)
    (output / evidence.relative_to(repo) / "control-final.log").write_text(result.stdout + result.stderr + f"\nEXIT={result.returncode}\n", encoding="utf-8")
    if result.returncode:
        raise ValueError("packaged control tests failed; preserve delivery for diagnosis")
    evidence_contract = {"evidence_relative": evidence_relative, "round_name": round_name}
    gates = validate_content(output, **evidence_contract)
    entries = [{"path": path.relative_to(output).as_posix(), "bytes": path.stat().st_size,
                "sha256": sha256(path.read_bytes())} for path in sorted(output.rglob("*")) if path.is_file()]
    manifest = {"schema": 1, "profile": "VOICE_VOLUME_ONLY_V1", "magic": "0x564F4C31", "build_id": "0xC00C0001",
                "hardware_schema": "0x00010000", "offline_status": "OFFLINE_VERIFIED", "board_status": "BOARD_PENDING",
                "release_ready": False, "tool": "Vivado 2026.1", "part": "xc7z020clg400-1",
                "axi_base": "0x43C00000", "axi_bytes": 4096, "evidence": evidence_contract,
                "gates": gates, "files": entries}
    (output / "deployment_manifest.json").write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    with zipfile.ZipFile(archive_path, "x", compression=zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(output.rglob("*")):
            if path.is_file():
                archive.write(path, f"{output.name}/{path.relative_to(output).as_posix()}")
    verify(output, archive_path)
    print(f"VOLUME_ZIP_SHA256={sha256(archive_path.read_bytes())}")


def restore(archive_path, destination):
    if destination.exists():
        raise ValueError("refusing occupied restore root")
    with zipfile.ZipFile(archive_path) as archive:
        for name in archive.namelist():
            path = PurePosixPath(name)
            if path.is_absolute() or ".." in path.parts or "\\" in name or ":" in name:
                raise ValueError("unsafe ZIP member")
        archive.extractall(destination)
    roots = list(destination.iterdir())
    if len(roots) != 1 or not roots[0].is_dir():
        raise ValueError("expected one delivery root")
    verify(roots[0], archive_path)
    print(f"VOLUME_RESTORED_ROOT={roots[0]}")


def monitor_package(repo, output):
    archive_path = output.with_suffix(".zip")
    if output.exists() or archive_path.exists():
        raise ValueError("refusing existing monitor delivery")
    paths = ["python/pynq_multimodal_game/volume_monitor.py", "python/pynq_multimodal_game/studio/audio_workspace.py",
             "python/pynq_multimodal_game/studio/qt_app.py", "board/pynq_z2/scripts/voice_volume_control.py",
             "board/pynq_z2/scripts/package_voice_volume.py", "sim/voice_volume/test_control.py",
             "tests/test_volume_monitor.py", "tests/test_studio_ui.py", "docs/voice_dual_volume_subproject.md",
             "docs/bringup/2026-10-19_voice_volume_offline.md",
             "results/game-validation/voice-volume-monitor-20261019/r04/studio-vol1-1440x900.png",
             "results/game-validation/voice-volume-monitor-20261019/r04/studio-vol1-1080x700.png"]
    output.mkdir(parents=True)
    entries = []
    for name in paths:
        source, target = repo / name, output / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
        data = target.read_bytes()
        entries.append({"path": name, "bytes": len(data), "sha256": sha256(data)})
    manifest = {"schema": "voice-volume-monitor-addon-v1", "profile": "VOICE_VOLUME_ONLY_V1", "build_id": "0xC00C0001",
                "offline_status": "PC_VERIFIED", "board_status": "BOARD_PENDING", "release_ready": False,
                "delivery_kind": "source-addon-not-standalone-studio", "files": entries}
    (output / "deployment_manifest.json").write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    with zipfile.ZipFile(archive_path, "x", compression=zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(output.rglob("*")):
            if path.is_file():
                archive.write(path, f"{output.name}/{path.relative_to(output).as_posix()}")
    verify_monitor(output, archive_path)
    print(f"VOLUME_MONITOR_ZIP_SHA256={sha256(archive_path.read_bytes())}")


def verify_monitor(root, archive_path):
    manifest = json.loads((root / "deployment_manifest.json").read_text(encoding="utf-8"))
    if manifest.get("schema") != "voice-volume-monitor-addon-v1" or manifest.get("profile") != "VOICE_VOLUME_ONLY_V1" or manifest.get("build_id") != "0xC00C0001" or manifest.get("board_status") != "BOARD_PENDING" or manifest.get("release_ready") is not False:
        raise ValueError("invalid monitor add-on identity")
    paths = {entry["path"] for entry in manifest["files"]}
    if len(paths) != len(manifest["files"]) or {path.relative_to(root).as_posix() for path in root.rglob("*") if path.is_file()} != paths | {"deployment_manifest.json"}:
        raise ValueError("monitor member set mismatch")
    with zipfile.ZipFile(archive_path) as archive:
        names = archive.namelist()
        if len(names) != len(set(names)) or set(names) != {f"{root.name}/{path}" for path in paths | {"deployment_manifest.json"}} or archive.testzip() is not None:
            raise ValueError("monitor ZIP members/CRC mismatch")
        for entry in manifest["files"]:
            path = PurePosixPath(entry["path"])
            if path.is_absolute() or ".." in path.parts or "\\" in entry["path"] or ":" in entry["path"]:
                raise ValueError("unsafe monitor path")
            data = (root / entry["path"]).read_bytes()
            if len(data) != entry["bytes"] or sha256(data) != entry["sha256"] or archive.read(f"{root.name}/{entry['path']}") != data:
                raise ValueError(f"monitor hash mismatch: {entry['path']}")
        if archive.read(f"{root.name}/deployment_manifest.json") != (root / "deployment_manifest.json").read_bytes():
            raise ValueError("monitor ZIP manifest differs")
    print(f"VOLUME_MONITOR_PACKAGE_VERIFIED files={len(paths)} hardware_access=false")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("pack", "verify", "restore", "monitor-pack", "monitor-verify"))
    parser.add_argument("--root", type=Path)
    parser.add_argument("--zip", type=Path)
    parser.add_argument("--artifacts", type=Path)
    parser.add_argument("--platform", type=Path)
    parser.add_argument("--evidence", type=Path)
    parser.add_argument("--round")
    arguments = parser.parse_args()
    if arguments.action == "monitor-pack":
        monitor_package(Path(__file__).resolve().parents[3], arguments.root)
    elif arguments.action == "monitor-verify":
        verify_monitor(arguments.root, arguments.zip)
    elif arguments.action == "pack":
        if arguments.evidence is None or arguments.round is None:
            parser.error("pack requires --evidence and --round")
        pack(Path(__file__).resolve().parents[3], arguments.artifacts, arguments.platform, arguments.root,
             arguments.evidence, arguments.round)
    elif arguments.action == "verify":
        verify(arguments.root, arguments.zip)
    else:
        restore(arguments.zip, arguments.root)


if __name__ == "__main__":
    main()