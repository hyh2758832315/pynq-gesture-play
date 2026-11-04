import importlib.util
from pathlib import Path
import tempfile
import unittest
import zlib


MODULE_PATH = Path(__file__).parents[1] / "board" / "pynq_z2" / "verify_c4m2.py"
SPEC = importlib.util.spec_from_file_location("verify_c4m2", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
verify_c4m2 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(verify_c4m2)


class VerifyC4M2Tests(unittest.TestCase):
    def test_decodes_status_words(self) -> None:
        self.assertEqual((128, 0, True), verify_c4m2.decode_accepted_status(0x480))
        self.assertEqual(
            (True, 0x2, 0x3, 17),
            verify_c4m2.decode_render_status(0x00110321),
        )

    def test_reads_address_from_hwh(self) -> None:
        hwh_text = """<?xml version="1.0"?>
<SYSTEM><MODULES><MODULE INSTANCE="render_status_gpio"><MEMRANGES>
<MEMRANGE BASEVALUE="0x412A0000" HIGHVALUE="0x412AFFFF" INSTANCE="render_status_gpio" />
</MEMRANGES></MODULE></MODULES></SYSTEM>
"""
        with tempfile.TemporaryDirectory() as temporary_dir:
            hwh = Path(temporary_dir) / "test.hwh"
            hwh.write_text(hwh_text, encoding="ascii")
            self.assertEqual(
                (0x412A0000, 0x10000),
                verify_c4m2.hwh_address(hwh, "render_status_gpio"),
            )

    def test_canonical_payload_matches_frozen_vector(self) -> None:
        payload, command_bank, command_count = verify_c4m2.build_canonical_payload(
            0xC4020001
        )
        self.assertEqual(verify_c4m2.PAYLOAD_BYTES, len(payload))
        self.assertEqual(verify_c4m2.COMMAND_BANK_BYTES, len(command_bank))
        self.assertEqual(6, command_count)
        self.assertEqual(b"S2DG", payload[:4])
        self.assertEqual(0xC4020001, int.from_bytes(payload[12:16], "little"))
        self.assertEqual(0xC277CACE, zlib.crc32(payload) & 0xFFFFFFFF)

    def test_error_payloads_remain_uploader_valid(self) -> None:
        unsupported, _ = verify_c4m2.build_error_payload(1, "unsupported")
        malformed, _ = verify_c4m2.build_error_payload(2, "malformed")
        self.assertEqual(0x7F, int.from_bytes(unsupported[64:68], "little"))
        self.assertEqual(1, int.from_bytes(malformed[72:76], "little"))
        self.assertEqual(1, int.from_bytes(unsupported[16:20], "little"))
        self.assertEqual(1, int.from_bytes(malformed[16:20], "little"))


if __name__ == "__main__":
    unittest.main()