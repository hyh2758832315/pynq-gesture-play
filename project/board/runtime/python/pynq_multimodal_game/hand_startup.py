"""Explicit read-only USB hand startup gate for the button-only candidate."""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import subprocess
import uuid

from .startup_checks import verify_hand_readonly_report


EXPECTED_MOTOR_IDS = tuple(range(1, 18))
FROZEN_MANIFEST_SHA256 = "5bbe20b6f9ce099eda45026db7e9965defa700d466a83d21e34403bbbd136128"
READONLY_SOURCE_SHA256 = {
    "src/pynq_usb_hand/__init__.py": "3c6f4a858fe730ce1185288680ae07a2679d25a1e5a672b75189c7f3a0256c90",
    "src/pynq_usb_hand/probe.py": "c7a349070d83001fde1c6c60859a38c93a2b5515ab634eeed8c8c89bdda3882c",
    "src/pynq_usb_hand/transport.py": "81460ff83a05ba31f2d5657b05b0810992b3fd6dc2c772305ea7c114b781bf16",
    "src/pynq_usb_hand/orca_backend.py": "74837e49bc9fbb063ed6610d6e90fcc4ec5b2ce223374bc27c78a49357facaa9",
    "src/pynq_usb_hand/assets.py": "6f9242f7354746e51ff2ffe019b0c51189cdf2b4111113f9ecc0199041fec9a7",
    "src/pynq_usb_hand/motion.py": "5c5a7f127e78819a63a47d862dcf863920aad8c02aecf4272e977588ccd71c23",
    "src/pynq_usb_hand/buttons.py": "36aea178026d3da8b7e829972acf02c473d91037406d0c5e7f2d331abb5fd125",
}


class HandStartupGate:
    """Run the separate hand probe once; never arm or send motion commands."""

    def __init__(self, *, root: Path, python: Path, port: str,
                 report_dir: Path) -> None:
        self.root = root.resolve(strict=True)
        # POSIX venv/bin/python is commonly a symlink. Preserve that path so
        # the probe runs with the hand environment rather than base Python.
        self.python = Path(os.path.abspath(python))
        self.report_dir = report_dir.resolve()
        if not self.root.is_dir() or not self.python.is_file():
            raise ValueError("hand root and Python must exist")
        if port != "/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00":
            raise ValueError("hand port must name the uniquely identified USB device")
        self.port = port
        self.report_path: Path | None = None
        self.passed = False
        manifest_path = self.root / "frozen_manifest.json"
        if hashlib.sha256(manifest_path.read_bytes()).hexdigest() != FROZEN_MANIFEST_SHA256:
            raise ValueError("frozen hand manifest identity mismatch")
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        files = manifest.get("sha256")
        if manifest.get("schema") != "pynq-usb-hand-frozen-v1" or not isinstance(files, dict) or not files:
            raise ValueError("invalid frozen hand manifest")
        for relative, expected in files.items():
            path = (self.root / relative).resolve(strict=True)
            if (not path.is_relative_to(self.root) or not path.is_file()
                    or hashlib.sha256(path.read_bytes()).hexdigest() != expected):
                raise ValueError(f"frozen hand file mismatch: {relative}")
        for relative, expected in READONLY_SOURCE_SHA256.items():
            path = self.root / relative
            if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
                raise ValueError(f"hand read-only source mismatch: {relative}")

    def __call__(self) -> bool:
        if self.report_path is not None:
            raise RuntimeError("hand startup gate can run only once")
        self.report_dir.mkdir(parents=True, exist_ok=True)
        self.report_path = self.report_dir / f"hand-readonly-{uuid.uuid4().hex}.json"
        environment = os.environ.copy()
        environment["PYTHONPATH"] = str(self.root / "src") + os.pathsep + environment.get("PYTHONPATH", "")
        command = (str(self.python), "-B", "-m", "pynq_usb_hand.probe",
                   "--root", str(self.root), "--port", self.port,
                   "--output", str(self.report_path))
        result = subprocess.run(command, cwd=self.root, env=environment,
                                capture_output=True, text=True, timeout=30, check=False)
        if result.returncode != 0:
            raise RuntimeError(f"hand read-only probe failed (exit {result.returncode}); report: {self.report_path}")
        report = json.loads(self.report_path.read_text(encoding="utf-8"))
        verify_hand_readonly_report(report, port=self.port, motor_ids=EXPECTED_MOTOR_IDS)
        self.passed = True
        return True
