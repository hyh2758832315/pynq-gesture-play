import time
import unittest

from pynq_usb_hand.controller import Controller
from pynq_usb_hand.motion import MockBackend, MotionSettings
from pynq_usb_hand.vision_session import VisionHandSession


class VisionHandSessionTests(unittest.TestCase):
    def test_only_latest_frame_is_polled_then_session_closes_controller(self):
        backend = MockBackend()
        controller = Controller(lambda: backend, lease_seconds=5,
                                settings=MotionSettings.fixed_playback(stage_waits=(.001,) * 3))
        controller.wait_connected()
        controller.arm()
        self.assertTrue(controller.wait_idle())
        source_at = time.monotonic()

        class Provider:
            calls = 0

            def peek_hand_classification(self):
                self.calls += 1
                return {"run_id": "run-a", "config_epoch": "cfg-a",
                        "frame_id": 1, "observed_at": time.monotonic(),
                        "source_at": source_at, "valid": True, "gesture": None}

        provider = Provider()
        session = VisionHandSession(
            controller, provider, source_identity=("run-a", "cfg-a"),
            max_age=.3, stable_seconds=.1, renew_interval=.05,
            poll_seconds=.02,
        )
        try:
            session.start()
            with self.assertRaisesRegex(RuntimeError, "cannot restart"):
                session.start()
            # Re-reading one unknown frame must never qualify a default
            # motion; it still ages out and closes the controller normally.
            deadline = time.monotonic() + 1
            while not backend.closed and time.monotonic() < deadline:
                time.sleep(.01)
            self.assertTrue(backend.closed, "stale vision must close the serial owner")
            self.assertGreaterEqual(provider.calls, 1)
            self.assertIsNone(controller.status()["operation"])
            self.assertEqual(backend.writes, [])
        finally:
            session.close()
        self.assertFalse(backend.torque)
        self.assertTrue(backend.closed)


if __name__ == "__main__":
    unittest.main()
