import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import uuid
import zipfile


ROOT = Path(__file__).resolve().parents[1]


def restore(archive_path, destination):
    if destination.exists():
        raise FileExistsError("Restore destination must be a new directory")
    with zipfile.ZipFile(archive_path) as archive:
        candidates = [name for name in archive.namelist() if name.endswith("/deployment_manifest.json")]
        if len(candidates) != 1 or archive.testzip() is not None:
            raise ValueError("Invalid release archive")
        manifest_path = candidates[0]
        prefix = manifest_path.rsplit("/", 1)[0] + "/"
        manifest = json.loads(archive.read(manifest_path))
        if manifest.get("schema") != "pynq-usb-hand-release-v1":
            raise ValueError("Unknown release schema")
        expected_names = {prefix + name for name in manifest["sha256"]} | {manifest_path}
        if set(archive.namelist()) != expected_names or len(archive.namelist()) != len(expected_names):
            raise ValueError("Unlisted or duplicate archive entries")
        destination.mkdir(parents=True)
        for name in archive.namelist():
            relative = name[len(prefix):]
            target = (destination / relative).resolve()
            if not target.is_relative_to(destination):
                raise ValueError("Escaping archive path")
            content = archive.read(name)
            if name != manifest_path and hashlib.sha256(content).hexdigest() != manifest["sha256"][relative]:
                raise ValueError(f"Archive SHA mismatch: {relative}")
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(content)
    environment = dict(os.environ)
    environment.pop("PYTHONPATH", None)
    environment.pop("PYTHONHOME", None)
    environment["PYTHONNOUSERSITE"] = "1"
    steps = []

    def execute(label, arguments):
        completed = subprocess.run(arguments, cwd=destination, env=environment,
                                   capture_output=True, text=True, encoding="utf-8", errors="replace")
        (destination / (label + ".log")).write_text(completed.stdout + completed.stderr, encoding="utf-8")
        steps.append({"step": label, "exit_code": completed.returncode})
        if completed.returncode != 0:
            raise RuntimeError(f"Restore {label} failed, exit={completed.returncode}; original log preserved")
        print(f"HAND_RESTORE_STEP={label} PASS", flush=True)

    try:
        execute("create_environment", [sys.executable, "-I", "-m", "venv", str(destination / ".venv")])
        python = destination / ".venv" / ("Scripts/python.exe" if os.name == "nt" else "bin/python")
        execute("offline_install", [str(python), "-m", "pip", "install", "--no-index", "--find-links", "wheelhouse",
                                    "-r", "requirements-host.txt", "pynq-usb-hand==0.1.0", "orca-core==0.4.3"])
        execute("dependency_check", [str(python), "-m", "pip", "check"])
        execute("verify_restored", [str(python), "-I", "-B", "tools/verify_offline.py"])
        execute("verify_installed_entrypoint", [str(python.parent / ("pynq-usb-hand.exe" if os.name == "nt" else "pynq-usb-hand")),
                                               "--root", str(destination), "verify"])
        execute("verify_installed_origin", [str(python), "-I", "-c",
                "import pathlib,sys,pynq_usb_hand,orca_core; root=pathlib.Path(sys.prefix).resolve(); "
                "assert pathlib.Path(pynq_usb_hand.__file__).resolve().is_relative_to(root); "
                "assert pathlib.Path(orca_core.__file__).resolve().is_relative_to(root); print('INSTALLED_ORIGINS=PASS')"])
        for relative, expected in manifest["sha256"].items():
            if hashlib.sha256((destination / relative).read_bytes()).hexdigest() != expected:
                raise ValueError(f"Payload drift after restore tests: {relative}")
        result = "RESTORE_VERIFIED"
    except Exception:
        result = "FAILED"
        raise
    finally:
        report = {"result": result, "archive_sha256": hashlib.sha256(archive_path.read_bytes()).hexdigest(),
                  "manifest_entries": len(manifest["sha256"]), "steps": steps,
                  "board_pending": True, "release_ready": False}
        (destination / "restore-verification.json").write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"HAND_RESTORE_PASS files={len(manifest['sha256'])} steps={len(steps)} root={destination}")


if __name__ == "__main__":
    arguments = argparse.ArgumentParser()
    arguments.add_argument("archive", type=Path)
    arguments.add_argument("--destination", type=Path, default=ROOT / "build" / ("restore-" + uuid.uuid4().hex[:8]))
    options = arguments.parse_args()
    restore(options.archive.resolve(), options.destination.resolve())