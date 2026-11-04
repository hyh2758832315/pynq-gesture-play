import importlib.util
import io
from pathlib import Path
import sys
import tempfile
import types
import unittest
from contextlib import redirect_stdout
from unittest.mock import patch


MODULE_PATH = Path(__file__).parents[1] / "board" / "pynq_z2" / "verify_c3.py"
SPEC = importlib.util.spec_from_file_location("verify_c3", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
verify_c3 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(verify_c3)


class VerifyC3OverlayTests(unittest.TestCase):
    def test_reloads_overlay_and_reads_expected_build_id(self) -> None:
        loads: list[tuple[str, bool]] = []
        reads: list[tuple[int, int, int]] = []

        class FakeOverlay:
            def __init__(self, bitstream: str, download: bool) -> None:
                loads.append((bitstream, download))
                self.ip_dict = {
                    verify_c3.IP_NAME: {
                        "phys_addr": 0x41200000,
                        "addr_range": 0x10000,
                    }
                }

        class FakeMMIO:
            def __init__(self, address: int, length: int) -> None:
                self.address = address
                self.length = length

            def read(self, offset: int) -> int:
                reads.append((self.address, self.length, offset))
                return verify_c3.EXPECTED_BUILD_ID

        pynq = types.ModuleType("pynq")
        pynq.MMIO = FakeMMIO  # type: ignore[attr-defined]
        pynq.Overlay = FakeOverlay  # type: ignore[attr-defined]

        with tempfile.TemporaryDirectory() as temporary_dir:
            bitstream = Path(temporary_dir) / "c3_overlay.bit"
            bitstream.touch()
            bitstream.with_suffix(".hwh").touch()
            output = io.StringIO()
            with (
                patch.dict(sys.modules, {"pynq": pynq}),
                patch.object(verify_c3.os, "geteuid", return_value=0, create=True),
                redirect_stdout(output),
            ):
                verify_c3.verify_overlay(bitstream, 3)

        self.assertEqual(3, len(loads))
        self.assertTrue(all(download for _, download in loads))
        self.assertEqual([(0x41200000, 0x10000, 0)] * 3, reads)
        self.assertIn("C3_LOAD_03=0xC0030001", output.getvalue())
        self.assertIn("C3_VERIFY_STATUS=PASS (3/3)", output.getvalue())


if __name__ == "__main__":
    unittest.main()