import hashlib
import json
from pathlib import Path
import tempfile
import unittest

from pynq_usb_hand.assets import verify_frozen


class AssetTests(unittest.TestCase):
    def test_complete_frozen_working_tree(self):
        root = Path(__file__).resolve().parents[1]
        manifest = verify_frozen(root)
        self.assertEqual(manifest["upstream_version"], "0.4.3")
        self.assertEqual(sum(name.startswith("assets/") for name in manifest["sha256"]), 5)

    def test_drift_and_escape_are_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "payload").write_bytes(b"original")
            manifest = {"schema": "pynq-usb-hand-frozen-v1", "sha256": {"payload": hashlib.sha256(b"original").hexdigest()}}
            (root / "frozen_manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            verify_frozen(root)
            (root / "payload").write_bytes(b"changed")
            with self.assertRaisesRegex(ValueError, "changed"):
                verify_frozen(root)
            manifest["sha256"] = {"../outside": "0" * 64}
            (root / "frozen_manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "escaping"):
                verify_frozen(root)


if __name__ == "__main__":
    unittest.main()