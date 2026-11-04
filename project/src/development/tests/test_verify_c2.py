import importlib.util
from pathlib import Path
import unittest


MODULE_PATH = Path(__file__).parents[1] / "board" / "pynq_z2" / "verify_c2.py"
SPEC = importlib.util.spec_from_file_location("verify_c2", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
verify_c2 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(verify_c2)


class VerifyC2InputEvidenceTests(unittest.TestCase):
    def test_observation_records_raw_transition_masks(self) -> None:
        self.assertEqual(
            {
                "name": "BTN2",
                "mask": 4,
                "baseline": 16,
                "asserted": 20,
                "released": 16,
                "asserted_change_mask": 4,
                "released_change_mask": 0,
            },
            verify_c2.input_observation("BTN2", 4, 16, 20, 16),
        )

    def test_exercise_reads_baseline_asserted_and_released_per_input(self) -> None:
        samples = iter(range(18))
        prompts: list[str] = []

        observations = verify_c2.exercise_inputs(
            lambda: next(samples),
            prompts.append,
        )

        self.assertEqual(6, len(observations))
        self.assertEqual("BTN0", observations[0]["name"])
        self.assertEqual(0, observations[0]["baseline"])
        self.assertEqual(1, observations[0]["asserted"])
        self.assertEqual(2, observations[0]["released"])
        self.assertEqual("SW1", observations[-1]["name"])
        self.assertEqual(12, len(prompts))


if __name__ == "__main__":
    unittest.main()