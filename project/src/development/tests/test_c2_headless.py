import importlib.util
from pathlib import Path
from types import SimpleNamespace
import unittest


MODULE_PATH = Path(__file__).parents[1] / "board" / "pynq_z2" / "c2_headless.py"
SPEC = importlib.util.spec_from_file_location("c2_headless", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
c2_headless = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(c2_headless)


class C2HeadlessGoldenTests(unittest.TestCase):
    def test_golden_report_has_no_mismatches(self) -> None:
        report = SimpleNamespace(**c2_headless.C1_GOLDEN)
        report.final_status = SimpleNamespace(value=report.final_status)

        self.assertEqual({}, c2_headless.golden_mismatches(report))

    def test_reports_every_mismatched_golden_field(self) -> None:
        report = SimpleNamespace(**c2_headless.C1_GOLDEN)
        report.final_status = SimpleNamespace(value="LOST")
        report.final_score = 35

        self.assertEqual(
            {
                "final_status": {"expected": "WON", "observed": "LOST"},
                "final_score": {"expected": 40, "observed": 35},
            },
            c2_headless.golden_mismatches(report),
        )


if __name__ == "__main__":
    unittest.main()