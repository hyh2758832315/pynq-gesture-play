"""Seal only this OSD candidate plus explicitly verified offline evidence."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import zipfile


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--verification", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    verification = args.verification.resolve()
    report = json.loads(verification.read_text(encoding="utf-8"))
    if report.get("status") != "OFFLINE_VERIFIED" or report.get("release_ready") is not False:
        raise ValueError("expected offline-only verified candidate")
    files = {p.relative_to(root).as_posix(): p for p in root.glob("*.md")}
    for dirname in ("rtl", "sim", "constraints", "tools", "tests"):
        for path in (root / dirname).iterdir():
            if path.is_file():
                files[path.relative_to(root).as_posix()] = path
    files["osd_publisher.py"] = root / "osd_publisher.py"
    for name, expected in {**report["source_sha256"], **report["evidence_sha256"]}.items():
        path = (root / name).resolve()
        if root not in path.parents or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise ValueError(f"unsealed file: {name}")
        files[name] = path
    files[verification.relative_to(root).as_posix()] = verification
    test_log = verification.parent / "publisher-tests.log"
    files[test_log.relative_to(root).as_posix()] = test_log
    payload = {name: path.read_bytes() for name, path in files.items()}
    manifest = {name: {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}
                for name, data in sorted(payload.items())}
    output = args.output.resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(output, "x", compression=zipfile.ZIP_DEFLATED) as archive:
        for name, data in sorted(payload.items()):
            archive.writestr(name, data)
        archive.writestr("MANIFEST.json", json.dumps(manifest, indent=2))
    with zipfile.ZipFile(output) as archive:
        if archive.testzip() is not None or set(archive.namelist()) != set(manifest) | {"MANIFEST.json"}:
            raise ValueError("ZIP CRC/member validation failed")
        for name, entry in manifest.items():
            data = archive.read(name)
            if len(data) != entry["bytes"] or hashlib.sha256(data).hexdigest() != entry["sha256"]:
                raise ValueError(f"ZIP member mismatch: {name}")
    digest = hashlib.sha256(output.read_bytes()).hexdigest()
    receipt = {"file": str(output), "sha256": digest, "bytes": output.stat().st_size,
               "members": len(manifest) + 1, "board_pending": True, "release_ready": False}
    output.with_suffix(".json").write_text(json.dumps(receipt, indent=2), encoding="utf-8")
    print("OSD_PACKAGE_PASS", digest, "members=" + str(len(manifest) + 1))


if __name__ == "__main__":
    main()
