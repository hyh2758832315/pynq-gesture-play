import importlib.util
from pathlib import Path
import tempfile
import unittest
from unittest.mock import Mock
import zlib


MODULE_PATH = Path(__file__).parents[1] / "board" / "pynq_z2" / "verify_c4t.py"
SPEC = importlib.util.spec_from_file_location("verify_c4t", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
verify_c4t = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(verify_c4t)


class VerifyC4TTests(unittest.TestCase):
    def test_reads_address_from_hwh(self) -> None:
        hwh_text = """<?xml version="1.0"?>
<SYSTEM><MODULES><MODULE INSTANCE="status"><MEMRANGES>
<MEMRANGE BASEVALUE="0x41210000" HIGHVALUE="0x4121FFFF" INSTANCE="status" />
</MEMRANGES></MODULE></MODULES></SYSTEM>
"""
        with tempfile.TemporaryDirectory() as temporary_dir:
            hwh = Path(temporary_dir) / "test.hwh"
            hwh.write_text(hwh_text, encoding="ascii")
            self.assertEqual((0x41210000, 0x10000), verify_c4t.hwh_address(hwh, "status"))

    def test_prefers_overlay_ip_dict_address(self) -> None:
        overlay = Mock()
        overlay.ip_dict = {"status": {"phys_addr": 0x1234, "addr_range": 0x100}}
        self.assertEqual(
            (0x1234, 0x100),
            verify_c4t.ip_address(overlay, Path("unused.hwh"), "status"),
        )

    def test_payload_is_deterministic_and_crc_compatible(self) -> None:
        first = verify_c4t.deterministic_payload(4096, 123)
        second = verify_c4t.deterministic_payload(4096, 123)
        different = verify_c4t.deterministic_payload(4096, 124)
        self.assertEqual(first, second)
        self.assertNotEqual(first, different)
        self.assertEqual(zlib.crc32(first), zlib.crc32(second))

    def test_nearest_rank_percentile(self) -> None:
        values = [5.0, 1.0, 4.0, 2.0, 3.0]
        self.assertEqual(3.0, verify_c4t.percentile(values, 0.50))
        self.assertEqual(5.0, verify_c4t.percentile(values, 0.99))


if __name__ == "__main__":
    unittest.main()