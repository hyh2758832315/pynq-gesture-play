import argparse
import hashlib
import json
from pathlib import Path
import zipfile


ROOT = Path(__file__).resolve().parents[1]
PREFIX = "pynq-usb-hand-0.1.0"


def package(output):
    evidence = ROOT / "build" / "offline-verification.json"
    report = json.loads(evidence.read_text(encoding="utf-8"))
    if report["result"] != "OFFLINE_VERIFIED" or report["failures"] or report["errors"]:
        raise ValueError("A successful offline verification receipt is required")
    payload = {}
    for directory in ("src", "tests", "tools", "assets", "vendor"):
        for path in (ROOT / directory).rglob("*"):
            if path.is_file() and "__pycache__" not in path.parts and path.suffix != ".pyc":
                payload[path.relative_to(ROOT).as_posix()] = path.read_bytes()
    for name in ("README.md", "run.py", "pyproject.toml", "frozen_manifest.json", "requirements-host.txt"):
        payload[name] = (ROOT / name).read_bytes()
    for path in sorted((ROOT / "build" / "wheelhouse").glob("*.whl")):
        payload["wheelhouse/" + path.name] = path.read_bytes()
    if not any(name.startswith("wheelhouse/pynq_usb_hand-") for name in payload):
        raise ValueError("Build the standalone wheel and dependencies before packaging")
    if not any(name.startswith("wheelhouse/orca_core-") for name in payload):
        raise ValueError("A wheel built from the frozen ORCA source is required")
    payload["evidence/offline-verification.json"] = evidence.read_bytes()
    payload["evidence/offline-verification.log"] = evidence.with_suffix(".log").read_bytes()
    manifest = {name: hashlib.sha256(content).hexdigest() for name, content in sorted(payload.items())}
    payload["deployment_manifest.json"] = (json.dumps({"schema": "pynq-usb-hand-release-v1", "sha256": manifest,
                                                    "hardware_tested": False, "release_ready": False,
                                                    "dependency_platform": report["platform"]}, indent=2, sort_keys=True) + "\n").encode()
    output.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(output, "x", compression=zipfile.ZIP_DEFLATED) as archive:
        for name, content in sorted(payload.items()):
            archive.writestr(PREFIX + "/" + name, content)
    with zipfile.ZipFile(output) as archive:
        if archive.testzip() is not None or len(archive.namelist()) != len(payload):
            raise ValueError("Archive integrity/count mismatch")
        for name, expected in manifest.items():
            if hashlib.sha256(archive.read(PREFIX + "/" + name)).hexdigest() != expected:
                raise ValueError(f"Archive content changed: {name}")
    receipt = {"zip": output.name, "sha256": hashlib.sha256(output.read_bytes()).hexdigest(),
               "manifest_entries": len(manifest), "zip_members": len(payload), "bytes": output.stat().st_size,
               "status": "OFFLINE_VERIFIED", "board_pending": True, "release_ready": False}
    output.with_suffix(".json").write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps(receipt, sort_keys=True))


if __name__ == "__main__":
    arguments = argparse.ArgumentParser()
    arguments.add_argument("--output", type=Path, default=ROOT / "build" / "pynq-usb-hand-0.1.0-offline.zip")
    options = arguments.parse_args()
    package(options.output)