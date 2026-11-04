import importlib.util
from pathlib import Path
import tempfile
import unittest
from unittest.mock import Mock


MODULE_PATH = Path(__file__).parents[1] / "board" / "pynq_z2" / "verify_c6t.py"
SPEC = importlib.util.spec_from_file_location("verify_c6t", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
verify_c6t = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(verify_c6t)


class SequenceMmio:
    def __init__(self, values: list[int]) -> None:
        self.values = iter(values)

    def read(self, offset: int) -> int:
        self.offset = offset
        return next(self.values)


class VerifyC6TTests(unittest.TestCase):
    def test_reads_address_from_hwh(self) -> None:
        hwh_text = """<?xml version="1.0"?>
<SYSTEM><MODULES><MODULE INSTANCE="return_status_gpio"><MEMRANGES>
<MEMRANGE BASEVALUE="0x413A0000" HIGHVALUE="0x413AFFFF" INSTANCE="return_status_gpio" />
</MEMRANGES></MODULE></MODULES></SYSTEM>
"""
        with tempfile.TemporaryDirectory() as temporary_dir:
            hwh = Path(temporary_dir) / "test.hwh"
            hwh.write_text(hwh_text, encoding="ascii")
            self.assertEqual(
                (0x413A0000, 0x10000),
                verify_c6t.hwh_address(hwh, "return_status_gpio"),
            )

    def test_prefers_overlay_ip_dict_address(self) -> None:
        overlay = Mock()
        overlay.ip_dict = {
            "return_status_gpio": {"phys_addr": 0x413A0000, "addr_range": 0x10000}
        }
        self.assertEqual(
            (0x413A0000, 0x10000),
            verify_c6t.ip_address(overlay, Path("unused.hwh"), "return_status_gpio"),
        )

    def test_payload_matches_rtl_pattern(self) -> None:
        for size in (1, 17, 256, 1025):
            payload = verify_c6t.deterministic_return_payload(size, 0x10203040)
            self.assertEqual(size, len(payload))
            self.assertEqual(
                bytes(
                    verify_c6t.pattern_byte(0x10203040, index)
                    for index in range(size)
                ),
                payload,
            )
        self.assertNotEqual(
            verify_c6t.deterministic_return_payload(17, 0x10203040),
            verify_c6t.deterministic_return_payload(17, 0x10203041),
        )

    def test_wait_for_s2mm_accepts_idle(self) -> None:
        mmio = SequenceMmio([0x00000000, verify_c6t.DMA_IDLE_MASK])
        self.assertEqual(
            verify_c6t.DMA_IDLE_MASK,
            verify_c6t.wait_for_s2mm(mmio, 1.0),
        )
        self.assertEqual(verify_c6t.S2MM_STATUS_OFFSET, mmio.offset)

    def test_wait_for_s2mm_rejects_dma_errors(self) -> None:
        mmio = SequenceMmio([0x00000010])
        with self.assertRaisesRegex(RuntimeError, "DMA error"):
            verify_c6t.wait_for_s2mm(mmio, 1.0)

    def test_nearest_rank_percentile(self) -> None:
        values = [5.0, 1.0, 4.0, 2.0, 3.0]
        self.assertEqual(3.0, verify_c6t.percentile(values, 0.50))
        self.assertEqual(5.0, verify_c6t.percentile(values, 0.99))


if __name__ == "__main__":
    unittest.main()