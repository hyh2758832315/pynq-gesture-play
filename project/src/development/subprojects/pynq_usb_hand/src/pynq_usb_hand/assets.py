import hashlib
import importlib
import json
from pathlib import Path
import sys


def verify_frozen(root: Path) -> dict:
    root = root.resolve()
    manifest = json.loads((root / "frozen_manifest.json").read_text(encoding="utf-8"))
    if manifest.get("schema") != "pynq-usb-hand-frozen-v1" or not manifest.get("sha256"):
        raise ValueError("Invalid frozen manifest")
    for relative, expected in manifest["sha256"].items():
        path = (root / relative).resolve()
        if not path.is_relative_to(root) or not path.is_file():
            raise ValueError(f"Missing or escaping frozen file: {relative}")
        if hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise ValueError(f"Frozen file changed: {relative}")
    return manifest


def import_orca(root: Path):
    verify_frozen(root)
    vendor = (root / "vendor" / "orca").resolve()
    for name, module in tuple(sys.modules.items()):
        if name == "orca_core" or name.startswith("orca_core."):
            location = getattr(module, "__file__", None)
            if location is None or not Path(location).resolve().is_relative_to(vendor):
                raise RuntimeError("Another ORCA copy is already imported")
    sys.path.insert(0, str(vendor))
    module = importlib.import_module("orca_core")
    if not Path(module.__file__).resolve().is_relative_to(vendor):
        raise RuntimeError("ORCA origin mismatch")
    return module