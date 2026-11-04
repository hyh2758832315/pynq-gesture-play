import threading
import time
import unittest
from unittest.mock import patch

from pynq_usb_hand.controller import Controller
from pynq_usb_hand.motion import MockBackend, MotionSettings


class OwnerBackend(MockBackend):
    def __init__(self):
        super().__init__()
        self.owners = set()
        self.fail_write = False
        self.release_failed = ()

    def record(self):
        self.owners.add(threading.get_ident())

    def connect(self, cancel):
        self.record()
        super().connect(cancel)

    def arm(self, cancel):
        self.record()
        super().arm(cancel)

    def sample(self, cancel):
        self.record()
        return super().sample(cancel)

    def write(self, target, cancel):
        self.record()
        if self.fail_write:
            raise OSError("injected communication error")
        super().write(target, cancel)

    def release(self):
        self.record()
        super().release()
        return self.release_failed

    def close(self):
        self.record()
        super().close()


class ControllerTests(unittest.TestCase):
    def controller(self, backend=None, **options):
        backend = backend or OwnerBackend()
        controller = Controller(lambda: backend, lease_seconds=options.pop("lease_seconds", 5),
                                settings=options.pop("settings", MotionSettings(step_size=0.005, hold=0)), **options)
        self.addCleanup(controller.close)
        controller.wait_connected()
        return controller, backend

    def arm(self, controller):
        controller.arm()
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["lifecycle"], controller.ready_lifecycle)

    def submit(self, controller, state="rock", request_id=1, **overrides):
        arguments = {"request_id": request_id, "session_id": controller.session_id,
                     "enable_epoch": controller.enable_epoch}
        arguments.update(overrides)
        return controller.submit(state, **arguments)

    def test_start_off_single_owner_busy_and_idempotence(self):
        controller, backend = self.controller()
        self.assertFalse(backend.torque)
        self.assertEqual(backend.writes, [])
        self.arm(controller)
        self.assertEqual(self.submit(controller), "accepted")
        self.assertEqual(self.submit(controller), "duplicate")
        self.assertEqual(self.submit(controller, "paper"), "conflicting_request")
        self.assertEqual(self.submit(controller, "paper", 2), "busy")
        self.assertTrue(controller.wait_idle())
        self.assertEqual(len(backend.writes), 43)
        self.assertEqual(controller.status()["actual_state"], "rock")
        self.assertEqual(self.submit(controller, "default", 3), "accepted")
        self.assertEqual(self.submit(controller, "paper", 2), "expired")
        controller.release()
        self.assertTrue(controller.wait_idle())
        self.assertFalse(backend.torque)
        self.assertEqual(len(backend.owners), 1)

    def test_fixed_playback_holds_between_requests_without_health_reads(self):
        backend = OwnerBackend()
        settings = MotionSettings.fixed_playback(stage_waits=(0.001, 0.001, 0.001))
        with patch.object(backend, "sample", side_effect=AssertionError("PLAYBACK_READ_FORBIDDEN")), patch.object(backend, "arm", wraps=backend.arm) as arm, patch.object(backend, "release", wraps=backend.release) as release:
            controller, _ = self.controller(backend, settings=settings, idle_scan=0.001)
            self.arm(controller)
            epoch = controller.enable_epoch
            for request_id, state in enumerate(("default", "paper", "scissors", "rock", "rock"), 1):
                self.assertEqual(self.submit(controller, state, request_id), "accepted")
                self.assertTrue(controller.wait_idle())
                status = controller.status()
                self.assertEqual(status["operation"]["status"], "played")
                self.assertEqual(status["actual_state"], "unknown")
                self.assertEqual(status["estimated_state"], state)
                self.assertEqual(status["lifecycle"], "READY_IDLE")
                self.assertEqual(status["enable_epoch"], epoch)
                self.assertTrue(backend.torque)
            with controller.condition:
                controller.condition.wait(0.02)
            self.assertEqual(controller.status()["lifecycle"], "READY_IDLE")
            self.assertEqual(arm.call_count, 1)
            self.assertEqual(release.call_count, 0)
            self.assertEqual(backend.sequence, 0)
            self.assertEqual(len(backend.owners), 1)
            controller.close()
            self.assertFalse(backend.torque)
            self.assertEqual(release.call_count, 1)

    def test_fixed_playback_idle_lease_expiry_releases_without_reading(self):
        backend = OwnerBackend()
        settings = MotionSettings.fixed_playback(stage_waits=(0.001, 0.001, 0.001))
        with patch.object(backend, "sample", side_effect=AssertionError("PLAYBACK_READ_FORBIDDEN")):
            controller, _ = self.controller(backend, settings=settings, lease_seconds=0.04)
            self.arm(controller)
            with controller.condition:
                self.assertTrue(controller.condition.wait_for(lambda: controller.lifecycle == "FAULT", 2))
            self.assertFalse(backend.torque)
            self.assertIn("lease expired", controller.status()["error"])

    def test_fixed_playback_rearm_requires_new_session(self):
        controller, _ = self.controller(settings=MotionSettings.fixed_playback(stage_waits=(0.001, 0.001, 0.001)))
        self.arm(controller)
        controller.release()
        self.assertTrue(controller.wait_idle())
        with self.assertRaisesRegex(RuntimeError, "only once"):
            controller.arm()

    def test_fixed_playback_write_fault_never_reports_reached(self):
        controller, backend = self.controller(settings=MotionSettings.fixed_playback(stage_waits=(0.001, 0.001, 0.001)))
        self.arm(controller)
        backend.fail_write = True
        self.assertEqual(self.submit(controller), "accepted")
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["lifecycle"], "FAULT")
        self.assertEqual(controller.status()["operation"]["status"], "fault")
        self.assertEqual(controller.status()["estimated_state"], "unknown")
        self.assertFalse(backend.torque)

    def test_fixed_playback_wait_release_stops_next_stage(self):
        controller, backend = self.controller(settings=MotionSettings.fixed_playback(stage_waits=(0.5, 0.5, 0.5)))
        self.arm(controller)
        written = threading.Event()
        original = backend.write
        def record(target, cancel):
            original(target, cancel)
            written.set()
        with patch.object(backend, "write", side_effect=record):
            self.assertEqual(self.submit(controller), "accepted")
            self.assertTrue(written.wait(2))
            controller.release()
            self.assertTrue(controller.wait_idle())
        self.assertEqual(len(backend.writes), 1)
        self.assertEqual(controller.status()["operation"]["status"], "cancelled")
        self.assertFalse(backend.torque)

    def test_fixed_playback_rejects_automatic_idle_release(self):
        with self.assertRaisesRegex(ValueError, "explicit release"):
            Controller(lambda: OwnerBackend(), lease_seconds=5,
                       settings=MotionSettings.fixed_playback(stage_waits=(0.1, 0.2, 0.3)), idle_release_after=1)

    def test_release_cancels_trajectory_no_implicit_default(self):
        controller, backend = self.controller()
        self.arm(controller)
        self.submit(controller)
        controller.release()
        self.assertTrue(controller.wait_idle())
        self.assertLess(len(backend.writes), 43)
        self.assertFalse(backend.torque)
        self.assertEqual(controller.status()["actual_state"], "unknown")
        self.assertEqual(controller.status()["operation"]["status"], "cancelled")

    def test_fault_stays_latched_after_release(self):
        controller, backend = self.controller()
        self.arm(controller)
        backend.fail_write = True
        self.submit(controller)
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["lifecycle"], "FAULT")
        self.assertFalse(backend.torque)
        with self.assertRaises(RuntimeError):
            controller.arm()

    def test_unconfirmed_release_is_unknown(self):
        controller, backend = self.controller()
        self.arm(controller)
        backend.release_failed = (9,)
        controller.release()
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["lifecycle"], "RELEASE_UNKNOWN")

    def test_stale_session_and_epoch_rejected(self):
        controller, _ = self.controller()
        self.arm(controller)
        self.assertEqual(self.submit(controller, session_id="old"), "stale_session")
        self.assertEqual(self.submit(controller, enable_epoch="old"), "stale_session")

    def test_release_exception_latches_without_busy_retry(self):
        controller, backend = self.controller()
        self.arm(controller)
        def failed_release():
            raise OSError("injected release link failure")
        backend.release = failed_release
        controller.release()
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["lifecycle"], "RELEASE_UNKNOWN")
        self.assertIsNone(controller.enable_epoch)
        controller.close()
        self.assertTrue(backend.closed)
        self.assertEqual(controller.status()["lifecycle"], "RELEASE_UNKNOWN")

    def test_idle_lease_expires_without_query_renewal(self):
        controller, backend = self.controller(lease_seconds=0.05, idle_scan=0.01)
        self.arm(controller)
        with controller.condition:
            self.assertTrue(controller.condition.wait_for(lambda: controller.lifecycle == "FAULT", 2))
        self.assertFalse(backend.torque)
        self.assertIn("lease expired", controller.status()["error"])

    def test_explicit_idle_release_avoids_health_polling_and_invalidates_epoch(self):
        controller, backend = self.controller(idle_release_after=0.05, idle_scan=5)
        self.arm(controller)
        epoch = controller.enable_epoch
        deadline = controller.idle_deadline
        with controller.condition:
            for _ in range(4):
                controller.renew(session_id=controller.session_id, enable_epoch=epoch)
                self.assertEqual(controller.idle_deadline, deadline)
                if controller.condition.wait_for(lambda: controller.lifecycle == "CONNECTED_OFF", 0.02):
                    break
            self.assertTrue(controller.condition.wait_for(lambda: controller.lifecycle == "CONNECTED_OFF", 2))
        self.assertFalse(backend.torque)
        self.assertEqual(backend.sequence, 0)
        self.assertEqual(backend.writes, [])
        self.assertIsNone(controller.enable_epoch)
        self.assertEqual(self.submit(controller, enable_epoch=epoch), "stale_session")
        self.assertIsNone(controller.status()["error"])
        self.assertEqual(len(backend.owners), 1)

    def test_idle_release_timer_starts_after_motion_and_never_rearms(self):
        controller, backend = self.controller(idle_release_after=0.05, idle_scan=5)
        self.arm(controller)
        self.assertEqual(self.submit(controller), "accepted")
        with controller.condition:
            self.assertTrue(controller.condition.wait_for(lambda: controller.lifecycle == "CONNECTED_OFF", 2))
        self.assertEqual(len(backend.writes), 43)
        self.assertEqual(controller.status()["operation"]["status"], "reached")
        self.assertEqual(controller.status()["actual_state"], "unknown")
        self.assertFalse(backend.torque)
        self.assertIsNone(controller.idle_deadline)
        self.assertIsNone(controller.status()["error"])

    def test_unconfirmed_idle_release_stays_unknown(self):
        controller, backend = self.controller(idle_release_after=0.05, idle_scan=5)
        self.arm(controller)
        backend.release_failed = (9,)
        with controller.condition:
            self.assertTrue(controller.condition.wait_for(lambda: controller.lifecycle == "RELEASE_UNKNOWN", 2))
        self.assertIn("9", controller.status()["error"])
        self.assertIsNone(controller.enable_epoch)

    def test_invalid_idle_release_is_rejected_before_worker_start(self):
        for value in (0, -1, True, float("nan"), float("inf")):
            with self.subTest(value=value), self.assertRaises(ValueError):
                Controller(lambda: OwnerBackend(), lease_seconds=5, idle_release_after=value)


if __name__ == "__main__":
    unittest.main()