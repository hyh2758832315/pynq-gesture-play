import importlib.util
from pathlib import Path
import tempfile
import unittest


MODULE_PATH = Path(__file__).parents[1] / "board" / "pynq_z2" / "verify_c4m1.py"
SPEC = importlib.util.spec_from_file_location("verify_c4m1", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
verify_c4m1 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(verify_c4m1)


class VerifyC4M1Tests(unittest.TestCase):
    def test_decodes_accepted_status(self) -> None:
        self.assertEqual((128, 0, True), verify_c4m1.decode_accepted_status(0x480))
        self.assertEqual((35, 1, True), verify_c4m1.decode_accepted_status(0x623))

    def test_reads_address_from_hwh(self) -> None:
        hwh_text = """<?xml version="1.0"?>
<SYSTEM><MODULES><MODULE INSTANCE="command_status_gpio"><MEMRANGES>
<MEMRANGE BASEVALUE="0x41230000" HIGHVALUE="0x4123FFFF" INSTANCE="command_status_gpio" />
</MEMRANGES></MODULE></MODULES></SYSTEM>
"""
        with tempfile.TemporaryDirectory() as temporary_dir:
            hwh = Path(temporary_dir) / "test.hwh"
            hwh.write_text(hwh_text, encoding="ascii")
            self.assertEqual(
                (0x41230000, 0x10000),
                verify_c4m1.hwh_address(hwh, "command_status_gpio"),
            )

    def test_scene_payload_uses_full_command_bank(self) -> None:
        payload, command_bank, command_count = verify_c4m1.build_scene_payload(77)
        self.assertEqual(verify_c4m1.PAYLOAD_BYTES, len(payload))
        self.assertEqual(verify_c4m1.COMMAND_BANK_BYTES, len(command_bank))
        self.assertGreater(command_count, 0)
        self.assertEqual(b"S2DG", payload[:4])
        self.assertEqual(77, int.from_bytes(payload[12:16], "little"))


if __name__ == "__main__":
    unittest.main()