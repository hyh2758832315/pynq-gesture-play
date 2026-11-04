"""Optional menu/video/game vision shadow in the isolated hand interpreter.

The PS process only peeks the newest classification. This bridge cannot arm a
controller or import the ORCA serial backend; the child is observation-only.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import sys
from uuid import uuid4


SHADOW_SOURCE_SHA256 = {
    "src/pynq_usb_hand/shadow_session.py": "b07a163819d8e6753d354190ea4201c835d11f6a49cb01c45df8f31595742e2f",
    "src/pynq_usb_hand/game_bridge.py": "d72e8c59fb2e57f325e09217f9428ad6981a46d6d4fbd5879a4bdc6d61742f2d",
    "src/pynq_usb_hand/gesture_consumer.py": "e23a2138fad29f29f53ab6701bba9238ecc280017b0beea4407c8129d0c82406",
    "tools/shadow_receiver.py": "79715d60e4f19d96153a9a53e664e9d22ead0851ffbf41468d9f0bed6eaa6aae",
}
MOCK_CHILD_SHA256 = "327e0b5d60b4c4b528e6e2afe39a9ac5f900c1f0804b82ff67fd25c210b76758"
SERIAL_CHILD_SHA256 = "2cb1d3dfafb526054ef2a810886f8c38f9e2631f58f7db3270dda856071e8092"
SERIAL_MANIFEST_SHA256 = "fcd0155e220af8df386e76677bcd5f3aeec2e3c8b4c621371632fdd6fcbf75d2"


class LatestVisionFeed:
    """One source-bound snapshot, polled only by the shadow publisher thread."""

    def __init__(self, provider, *, observation_type, envelope_type):
        if not callable(getattr(provider, "peek_hand_classification", None)):
            raise TypeError("non-consuming hand classification view required")
        self.provider = provider
        self.observation_type = observation_type
        self.envelope_type = envelope_type
        self._source = None
        self._latest = None
        self.revoked = None

    def revoke(self, reason):
        if self.revoked is None:
            self.revoked = str(reason)[:160]

    def read(self):
        if self.revoked is not None:
            return self._latest
        try:
            snapshot = self.provider.peek_hand_classification()
            if snapshot is None:
                return self._latest
            observation = self.observation_type(**snapshot)
        except (AttributeError, KeyError, TypeError, ValueError):
            self.revoke("invalid_vision_snapshot")
            return self._latest
        if not observation.valid and self._source is None:
            return None
        source = (observation.run_id, observation.config_epoch)
        if self._source is not None and source != self._source:
            self.revoke("vision_source_changed")
            return self._latest
        if self._latest is not None:
            previous = self._latest.observation
            if observation.valid and observation.frame_id <= previous.frame_id:
                return self._latest
        if self._source is None:
            self._source = source
        run = "vision-" + hashlib.sha256("\0".join(source).encode()).hexdigest()[:24]
        self._latest = self.envelope_type(run, observation)
        return self._latest


def verify_shadow_sources(root: Path) -> None:
    root = root.resolve(strict=True)
    for relative, expected in SHADOW_SOURCE_SHA256.items():
        path = (root / relative).resolve(strict=True)
        if not path.is_relative_to(root) or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise ValueError(f"hand shadow source mismatch: {relative}")


def verify_mock_child(package_root: Path) -> Path:
    root = package_root.resolve(strict=True)
    entry = (root / "hand_child/mock_motion_receiver.py").resolve(strict=True)
    if (not entry.is_relative_to(root)
            or hashlib.sha256(entry.read_bytes()).hexdigest() != MOCK_CHILD_SHA256):
        raise ValueError("mock hand child identity mismatch")
    return entry


def verify_serial_child(package_root: Path) -> Path:
    root = package_root.resolve(strict=True)
    for name, expected in (("serial_motion_receiver.py", SERIAL_CHILD_SHA256),
                           ("serial_sources.json", SERIAL_MANIFEST_SHA256)):
        path = (root / "hand_child" / name).resolve(strict=True)
        if not path.is_relative_to(root) or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise ValueError("serial hand child identity mismatch: " + name)
    return root / "hand_child/serial_motion_receiver.py"


def verify_serial_sources(root: Path, package_root: Path) -> None:
    entry = verify_serial_child(package_root)
    manifest = json.loads(entry.with_name("serial_sources.json").read_text(encoding="utf-8"))
    root = root.resolve(strict=True)
    for relative, expected in manifest["sha256"].items():
        path = (root / relative).resolve(strict=True)
        if not path.is_relative_to(root) or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise ValueError("serial hand source mismatch: " + relative)


def create_serial_action_session(provider, *, gate, package_root: Path,
                                 output_dir: Path, stage_waits, seconds: float | None = None,
                                 approval_seconds: float | None = None):
    root, feed = _verified_feed(provider, gate)
    verify_serial_sources(root, package_root)
    from .hand_serial_session import SerialHandActionSession

    return SerialHandActionSession(
        feed, gate=gate, entry=verify_serial_child(package_root), stage_waits=stage_waits,
        output_dir=output_dir / f"hand-serial-{uuid4().hex}", seconds=seconds,
        approval_seconds=approval_seconds,
    )


def _verified_feed(provider, gate):
    if gate.passed is not True:
        raise RuntimeError("hand read-only startup must pass before hand bridge startup")
    root = gate.root.resolve(strict=True)
    verify_shadow_sources(root)
    source = root / "src"
    if str(source) not in sys.path:
        sys.path.insert(0, str(source))
    import pynq_usb_hand
    from pynq_usb_hand.game_bridge import GameObservation
    from pynq_usb_hand.gesture_consumer import GestureObservation

    if not Path(pynq_usb_hand.__file__).resolve().is_relative_to(source):
        raise ImportError("hand package origin mismatch")
    return root, LatestVisionFeed(provider, observation_type=GestureObservation,
                                  envelope_type=GameObservation)


def create_shadow_session(provider, *, gate, output_dir: Path, seconds: float = 60):
    """Bind a verified hand tree to a passive child without opening serial."""
    root, feed = _verified_feed(provider, gate)
    from pynq_usb_hand.shadow_session import HandShadowSession

    return HandShadowSession(
        feed, python=gate.python, hand_root=root,
        output_dir=output_dir / f"hand-shadow-{uuid4().hex}", seconds=seconds,
    )


def create_mock_action_session(provider, *, gate, package_root: Path,
                               output_dir: Path, seconds: float = 30):
    """Opt-in action lifecycle with a SHA-pinned, memory-only hand child."""
    root, feed = _verified_feed(provider, gate)
    entry = verify_mock_child(package_root)
    from .hand_mock_session import MockHandActionSession

    return MockHandActionSession(
        feed, python=gate.python, hand_root=root, entry=entry,
        output_dir=output_dir / f"hand-mock-{uuid4().hex}", seconds=seconds,
    )
