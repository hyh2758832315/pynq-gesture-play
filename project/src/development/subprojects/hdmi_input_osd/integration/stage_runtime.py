"""Create a source-identity checked child of frozen r15. No board operations.

Run: python -B .../stage_runtime.py
Output: new deliveries/c6i-vision-volume-osd-r16-20261022 plus baseline-audit.json.
Next: explicit reviewed OSD-only patches, full preflight, package and board tests.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import zipfile


def main() -> None:
    repo = Path(__file__).resolve().parents[3]
    parent = repo / "deliveries/c6i-vision-volume-c0c-r15-unified-input-20261022-r2.zip"
    expected = "a9bf7cc1d2f4420867e47e176f9be789966ef302d9a16c46cfabaa3cab945dfe"
    if hashlib.sha256(parent.read_bytes()).hexdigest() != expected:
        raise ValueError("frozen r15 parent changed")
    target = repo / "deliveries/c6i-vision-volume-osd-r16-20261022"
    if target.exists() and any(target.iterdir()):
        raise FileExistsError(target)
    with zipfile.ZipFile(parent) as archive:
        if archive.testzip() is not None:
            raise ValueError("parent ZIP CRC")
        names = archive.namelist()
        if len(names) != len(set(names)):
            raise ValueError("duplicate ZIP member")
        manifests = [n for n in names if n.endswith("/deployment_manifest.json")]
        if len(manifests) != 1:
            raise ValueError("ambiguous parent manifest")
        prefix = manifests[0][:-len("deployment_manifest.json")]
        if any(not n.startswith(prefix) for n in names):
            raise ValueError("mixed archive roots")
        manifest = json.loads(archive.read(manifests[0]))
        if len(manifest["sha256"]) != 524:
            raise ValueError("parent manifest coverage")
        target.mkdir(exist_ok=True)
        for member in names:
            name = member[len(prefix):]
            path = (target / name).resolve()
            if target not in path.parents:
                raise ValueError("unsafe member path")
            data = archive.read(member)
            if name in manifest["sha256"] and hashlib.sha256(data).hexdigest().upper() != manifest["sha256"][name]:
                raise ValueError(f"parent source mismatch {name}")
            path.parent.mkdir(parents=True, exist_ok=True)
            with path.open("xb") as stream:
                stream.write(data)
    result = {"parent_sha256": expected, "manifest_entries": 524, "zip_members": len(names),
              "child_root": str(target), "status": "PARENT_COPY_VERIFIED_NOT_MODIFIED", "board_access": False}
    dest = repo / "subprojects/hdmi_input_osd/integration/evidence/g04-runtime-parent-audit.json"
    with dest.open("x", encoding="utf-8") as stream:
        json.dump(result, stream, indent=2)
    print("R15_PARENT_COPY_524_SHA_PASS", target)


if __name__ == "__main__":
    main()
