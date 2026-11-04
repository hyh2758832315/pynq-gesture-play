import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess


ASSETS = {
    "config.yaml": ("orca_core/models/v2/orcahand-scs225-right/config.yaml", "4815b1ea1ca0e68dd2dab070f8e9112a00525db8d297a8bfa7173f945fb5ec3b"),
    "calibration.yaml": ("orca_core/models/v2/orcahand-scs225-right/calibration.yaml", "1b767f73b4e8a49b0ec65f2965036fce794b42384817324cfe364e4dcd877b8a"),
    "default-captured.txt": ("docs/records/scs225-gesture-20261021-152524/default-captured.txt", "95eb9e2397bf5a2b509adc4ab9880b47749c1cfab84bd32850093f5276c6fe8f"),
    "paper-captured.txt": ("docs/records/scs225-gesture-20261021-152524/paper-captured.txt", "2a7bffaa75dc11512c7ec1389f9592c8df091a57952febb475d7fe18b8529378"),
    "receipt.json": ("docs/records/scs225-gesture-20261021-152524/receipt.json", "3e4c12e039cc2da81697c902b43eb99c8582debd0243a341580d8106527a0591"),
}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def freeze(source, destination):
    for _, (relative, expected) in ASSETS.items():
        if digest(source / relative) != expected:
            raise ValueError(f"Upstream asset changed: {relative}")
    if (destination / "vendor").exists() or (destination / "assets").exists():
        raise FileExistsError("Frozen vendor/assets already exist; create a new baseline instead")
    vendor = destination / "vendor" / "orca"
    vendor.mkdir(parents=True)
    originals = {}
    for path in sorted((source / "orca_core").rglob("*")):
        if path.is_file() and "__pycache__" not in path.parts and path.suffix != ".pyc":
            relative = path.relative_to(source)
            target = vendor / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(path, target)
            originals[str(target.relative_to(destination)).replace("\\", "/")] = digest(path)
    for name in ("LICENSE", "README.md", "pyproject.toml", "uv.lock"):
        shutil.copyfile(source / name, vendor / name)
        originals[f"vendor/orca/{name}"] = digest(source / name)
    (destination / "assets").mkdir()
    for name, (relative, expected) in ASSETS.items():
        target = destination / "assets" / name
        shutil.copyfile(source / relative, target)
        originals[f"assets/{name}"] = expected
    head = subprocess.run(["git", "rev-parse", "HEAD"], cwd=source, check=True, capture_output=True).stdout.decode().strip()
    diff = subprocess.run(["git", "diff", "--binary", "HEAD", "--", "orca_core", "pyproject.toml", "uv.lock"], cwd=source, check=True, capture_output=True).stdout
    (vendor / "working-tree.patch").write_bytes(diff)
    originals["vendor/orca/working-tree.patch"] = hashlib.sha256(diff).hexdigest()
    manifest = {"schema": "pynq-usb-hand-frozen-v1", "upstream_version": "0.4.3", "upstream_head": head, "working_tree_diff_bytes": len(diff), "sha256": originals}
    (destination / "frozen_manifest.json").write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    for relative, expected in originals.items():
        if digest(destination / relative) != expected:
            raise ValueError(f"Copy verification failed: {relative}")
    print(f"ORCA_FREEZE_PASS files={len(originals)} assets=5 source_unchanged=true")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, required=True)
    arguments = parser.parse_args()
    freeze(arguments.source.resolve(), Path(__file__).resolve().parents[1])
