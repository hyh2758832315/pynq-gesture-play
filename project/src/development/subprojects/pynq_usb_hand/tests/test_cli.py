from contextlib import redirect_stdout, redirect_stderr
import io
import json
from pathlib import Path
import unittest
from unittest.mock import patch

from pynq_usb_hand.cli import main


ROOT = Path(__file__).resolve().parents[1]


class CliTests(unittest.TestCase):
    def invoke(self, *arguments, stdin=""):
        output = io.StringIO()
        with redirect_stdout(output), patch("sys.stdin", io.StringIO(stdin)):
            result = main(["--root", str(ROOT), *arguments])
        return result, [json.loads(line) for line in output.getvalue().splitlines()]

    def test_frozen_verify_without_sdk_import(self):
        result, events = self.invoke("verify")
        self.assertEqual(result, 0)
        self.assertEqual(events[0]["event"], "frozen_verified")
        self.assertGreater(events[0]["files"], 5)

    def test_mock_three_cycles_release_and_close(self):
        result, events = self.invoke("demo", "--fast")
        self.assertEqual(result, 0)
        self.assertEqual(events[-1]["source"], "MOCK_SYNTHETIC")
        self.assertEqual(events[-1]["waypoints"], 384)
        self.assertTrue(events[-1]["torque_off"] and events[-1]["closed"])

    def test_keys_start_off_no_implicit_arm(self):
        result, events = self.invoke("keys", stdin="2sq")
        self.assertEqual(result, 0)
        self.assertEqual(events[0]["event"], "connected_off")
        self.assertEqual(events[1]["result"], "stale_session")
        self.assertEqual(events[2]["lifecycle"], "CONNECTED_OFF")
        self.assertEqual(events[-1]["lifecycle"], "CLOSED")

    def test_hardware_gate_before_model_or_serial(self):
        with patch("pynq_usb_hand.orca_backend.OrcaModel", side_effect=AssertionError("MODEL_MUST_NOT_LOAD")), redirect_stderr(io.StringIO()):
            with self.assertRaises(SystemExit) as context:
                self.invoke("keys", "--hardware")
        self.assertEqual(context.exception.code, 2)

    def test_mask_input_consumes_debounced_press(self):
        result, events = self.invoke("keys", "--input", "masks", stdin="0 0\n0.04 0\n0.05 8\n0.09 8\n0.20 8\nq\n")
        self.assertEqual(result, 0)
        requests = [event for event in events if event["event"] == "request"]
        self.assertEqual(len(requests), 1)
        self.assertEqual(requests[0]["state"], "rock")

    def test_feedback_interval_is_explicit_and_validated_before_connect(self):
        result, events = self.invoke("keys", "--waypoint-feedback-interval", "0.1", stdin="q")
        self.assertEqual(result, 0)
        self.assertEqual(events[0]["waypoint_feedback_interval"], 0.1)
        result, events = self.invoke("keys", stdin="q")
        self.assertEqual(events[0]["waypoint_feedback_interval"], 0)
        with patch("pynq_usb_hand.cli.Controller", side_effect=AssertionError("MUST_NOT_CONNECT")):
            for interval in ("-1", "nan", "inf", "2"):
                result, events = self.invoke("keys", "--hardware", "--port", "fake-only", "--confirm-safety",
                                             "--max-temperature", "40", "--max-scan-age", "2",
                                             "--lease-seconds", "5", "--waypoint-feedback-interval", interval)
                self.assertEqual(result, 1)
                self.assertIn("Waypoint feedback interval", events[-1]["error"])

    def test_responsive_profile_is_explicit_and_cannot_mix_intervals(self):
        result, events = self.invoke("keys", "--motion-profile", "responsive", stdin="q")
        self.assertEqual(result, 0)
        self.assertEqual(events[0]["motion_profile"], "responsive")
        self.assertEqual(events[0]["waypoint_feedback_interval"], 0.2)
        result, events = self.invoke("keys", stdin="q")
        self.assertEqual(events[0]["motion_profile"], "audit")
        with patch("pynq_usb_hand.cli.Controller", side_effect=AssertionError("MUST_NOT_CONNECT")), redirect_stderr(io.StringIO()):
            with self.assertRaises(SystemExit):
                self.invoke("keys", "--motion-profile", "responsive", "--waypoint-feedback-interval", "0.2")

    def test_invalid_demo_is_rejected(self):
        result, events = self.invoke("demo", "--sequence", "neutral")
        self.assertEqual(result, 1)
        self.assertEqual(events[-1]["event"], "error")


if __name__ == "__main__":
    unittest.main()