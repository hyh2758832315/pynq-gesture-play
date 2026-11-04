"""Playback timing and startup/stop races, with no physical devices."""
import threading
import time
import unittest
from unittest.mock import patch

from pynq_usb_hand.controller import Controller
from pynq_usb_hand.motion import Cancellation, Cancelled, MockBackend, Motion, MotionSettings


SETTINGS = MotionSettings.fixed_playback(stage_waits=(0.001, 0.001, 0.001))


class PlaybackLifecycleTests(unittest.TestCase):
    def test_wait_preserves_stage_duration_across_multiple_renewals(self):
        now = [0.0]
        token = Cancellation(1, clock=lambda: now[0])
        waits = []

        def sleep(duration):
            waits.append(duration)
            now[0] += duration
            token.deadline += 1

        with patch.object(token.event, "wait", side_effect=sleep):
            token.wait(3.5)
        self.assertEqual(now[0], 3.5)
        self.assertEqual(waits, [1, 1, 1, 0.5])

    def test_wait_expiry_and_cancel_stop_at_current_stage(self):
        for renew, cancel in ((False, False), (True, True)):
            now = [0.0]
            token = Cancellation(1, clock=lambda: now[0])
            def sleep(duration):
                now[0] += duration
                if renew:
                    token.deadline += 3
                if cancel:
                    token.event.set()
            with self.subTest(cancel=cancel), patch.object(token.event, "wait", side_effect=sleep):
                with self.assertRaises(Cancelled if cancel else TimeoutError):
                    token.wait(3)
            self.assertEqual(now[0], 1)

    def test_compile_once_per_unique_target_and_share_default(self):
        backend = MockBackend()
        with patch.object(backend, "compile_target", wraps=backend.compile_target) as compile_target:
            motion = Motion(backend, SETTINGS)
        self.assertEqual(compile_target.call_count, 6)
        default = motion.playback_routes["default"][0][1]
        for route in motion.playback_routes.values():
            self.assertIs(route[0][1], default)

    def controller(self, backend, **options):
        controller = Controller(lambda: backend, lease_seconds=5, settings=SETTINGS, **options)
        self.addCleanup(controller.close)
        return controller

    def test_startup_budget_expiry_never_connects_or_writes(self):
        backend = MockBackend()
        with patch("pynq_usb_hand.controller.Cancellation", return_value=Cancellation(0)):
            controller = Controller(lambda: backend, lease_seconds=5, startup_timeout=1, settings=SETTINGS)
            controller.thread.join(2)
        self.addCleanup(controller.close)
        self.assertFalse(controller.thread.is_alive())
        self.assertEqual(controller.status()["lifecycle"], "FAULT")
        self.assertFalse(backend.torque)
        self.assertTrue(backend.closed)
        self.assertEqual(backend.writes, [])

    def test_connect_failure_only_closes_no_implicit_release(self):
        backend = MockBackend()
        with patch.object(backend, "connect", side_effect=OSError("preflight rejected")), patch.object(backend, "release") as release:
            controller = self.controller(backend)
            with self.assertRaisesRegex(RuntimeError, "preflight rejected"):
                controller.wait_connected()
            controller.close()
            release.assert_not_called()
        self.assertTrue(backend.closed)

    def test_cancel_after_arm_returns_never_publishes_ready(self):
        backend = MockBackend()
        arm_done = threading.Event()
        return_arm = threading.Event()
        self.addCleanup(return_arm.set)
        def arm(token):
            backend.torque = True
            arm_done.set()
            self.assertTrue(return_arm.wait(2))
        with patch.object(backend, "arm", side_effect=arm):
            controller = self.controller(backend)
            controller.wait_connected()
            controller.arm()
            self.assertTrue(arm_done.wait(2))
            controller.release()
            return_arm.set()
            self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["lifecycle"], "CONNECTED_OFF")
        self.assertIsNone(controller.status()["enable_epoch"])
        self.assertFalse(backend.torque)

    def test_close_queued_request_has_terminal_operation(self):
        backend = MockBackend()
        controller = self.controller(backend)
        controller.wait_connected()
        controller.arm()
        self.assertTrue(controller.wait_idle())
        with controller.condition:
            self.assertEqual(controller.submit("rock", request_id=1, session_id=controller.session_id,
                                               enable_epoch=controller.enable_epoch), "accepted")
            controller.closing = True
            controller.cancel.event.set()
            controller.condition.notify_all()
        controller.close()
        self.assertEqual(controller.status()["operation"]["status"], "cancelled")
        self.assertEqual(backend.writes, [])
        self.assertFalse(backend.torque)

    def test_renew_does_not_wake_idle_worker(self):
        controller = self.controller(MockBackend())
        controller.wait_connected()
        controller.arm()
        self.assertTrue(controller.wait_idle())
        with controller.condition, patch.object(controller.condition, "notify_all") as notify:
            old_deadline = controller.cancel.deadline
            controller.renew(session_id=controller.session_id, enable_epoch=controller.enable_epoch)
            self.assertGreaterEqual(controller.cancel.deadline, old_deadline)
            notify.assert_not_called()

    def test_startup_timeout_validation_precedes_factory(self):
        for timeout in (0, -1, True, float("inf"), float("nan")):
            with self.subTest(timeout=timeout), self.assertRaises(ValueError):
                Controller(lambda: self.fail("factory started"), lease_seconds=5, startup_timeout=timeout)


if __name__ == "__main__":
    unittest.main()
