import threading
import time
import unittest
from pathlib import Path
from unittest.mock import patch

from pynq_usb_hand.actuator_owner import VisionActuatorOwner
from pynq_usb_hand.gesture_consumer import GestureObservation
from pynq_usb_hand.motion import MockBackend as MemoryBackend


class MockBackend(MemoryBackend):
    # The audit wrapper deliberately preserves explicit backend authorization.
    stage_targets_authorized = True
    playback_authorized = True


class Receiver:
    def __init__(self, value=lambda now: "paper"):
        self.value = value
        self.stopped = None
        self.frame = 0

    def poll(self, now):
        self.frame += 1
        value = self.value(now)
        if value == "missing":
            return None
        return GestureObservation("run", "config", self.frame, now, now,
                                  True, value)


def owner(receiver, backend, **kwargs):
    return VisionActuatorOwner(
        receiver, lambda: backend, motor_ids=tuple(range(1, 18)),
        stage_waits=(.001,) * 3, max_seconds=kwargs.pop("max_seconds", .3),
        poll_seconds=.02, stable_seconds=.025, **kwargs,
    )


class ActuatorOwnerTests(unittest.TestCase):
    def test_continuous_owner_releases_when_frames_stop_advancing(self):
        first = []

        class FrozenReceiver:
            stopped = None

            def poll(self, now):
                if not first:
                    first.append(GestureObservation("run", "config", 1, now, now, True, "paper"))
                return first[0]

        backend = MockBackend()
        report = owner(FrozenReceiver(), backend, max_seconds=None).run()
        self.assertTrue(report["active"])
        self.assertIsNone(report["max_seconds"])
        self.assertEqual(report["stop_reason"], "invalid_or_stale_source")
        self.assertTrue(report["release_confirmed"])
        self.assertFalse(backend.torque)

    def test_optional_duration_rejects_invalid_values(self):
        for seconds in (0, -1, float("nan"), float("inf"), True):
            with self.subTest(seconds=seconds), self.assertRaises(ValueError):
                owner(Receiver(), MockBackend(), max_seconds=seconds)

    def test_three_gestures_and_no_hand_then_release_same_owner(self):
        activated = []
        backend = MockBackend()

        def gesture(now):
            if not activated:
                return "paper"
            index = min(int((now - activated[0]) / .15), 3)
            return ("paper", "fist", "scissors", "default")[index]

        session = owner(Receiver(gesture), backend, max_seconds=.75,
                        on_active=lambda source: activated.append(time.monotonic()))
        report = session.run()
        self.assertIsNone(report["error"])
        self.assertEqual([op["state"] for op in report["operations"]],
                         ["paper", "rock", "scissors", "default"])
        self.assertTrue(report["release_confirmed"])
        self.assertEqual(report["release_confirmed_ids"], list(range(1, 18)))
        self.assertEqual(report["controller"]["lifecycle"], "CLOSED")
        self.assertTrue(backend.closed)
        self.assertFalse(backend.torque)
        with self.assertRaisesRegex(RuntimeError, "cannot restart"):
            session.run()

    def test_no_fresh_source_never_creates_backend(self):
        created = []
        session = VisionActuatorOwner(
            Receiver(lambda now: "missing"), lambda: created.append(True),
            motor_ids=(1,), stage_waits=(.001,) * 3, max_seconds=.03,
            poll_seconds=.02,
        )
        report = session.run()
        self.assertFalse(created)
        self.assertFalse(report["arm_attempted"])
        self.assertFalse(report["release_confirmed"])
        self.assertIn("fresh source", report["error"])

    def test_revoked_source_during_connect_never_arms(self):
        receiver = Receiver()

        class Backend(MockBackend):
            def connect(self, cancel):
                receiver.stopped = "producer_revoked"
                cancel.wait(.03)

        backend = Backend()
        report = owner(receiver, backend).run()
        self.assertFalse(report["arm_attempted"])
        self.assertTrue(report["backend_closed"])
        self.assertFalse(backend.torque)
        self.assertFalse(report["release_confirmed"])

    def test_revoked_source_during_arm_cancels_and_confirms_release(self):
        receiver = Receiver()

        class Backend(MockBackend):
            def arm(self, cancel):
                super().arm(cancel)
                receiver.stopped = "producer_revoked"
                cancel.wait(.1)

        backend = Backend()
        report = owner(receiver, backend).run()
        self.assertTrue(report["arm_attempted"])
        self.assertFalse(report["active"])
        self.assertTrue(report["release_confirmed"])
        self.assertFalse(backend.torque)

    def test_failed_off_readback_cannot_claim_release(self):
        class Backend(MockBackend):
            def release(self):
                super().release()
                return (7,)

        report = owner(Receiver(), Backend(), max_seconds=.15).run()
        self.assertFalse(report["release_confirmed"])
        self.assertEqual(report["release_confirmed_ids"], [])
        self.assertEqual(report["controller"]["lifecycle"], "RELEASE_UNKNOWN")
        self.assertIn(7, report["release_attempts"][-1]["failed_ids"])

    def test_stop_during_motion_closes_without_next_request(self):
        stop = threading.Event()

        class Backend(MockBackend):
            def write_compiled(self, target, cancel):
                super().write_compiled(target, cancel)
                stop.set()
                cancel.wait(.1)

        backend = Backend()
        report = owner(Receiver(), backend, stop=stop).run()
        self.assertEqual(len(report["operations"]), 1)
        self.assertEqual(report["stop_reason"], "owner_stop")
        self.assertTrue(report["release_confirmed"])
        self.assertEqual(report["controller"]["operation"]["status"], "cancelled")


class ActuatorOwnerPacketTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from pynq_usb_hand.orca_backend import OrcaModel
        with patch("serial.Serial.open", side_effect=AssertionError("REAL_SERIAL_FORBIDDEN")):
            cls.model = OrcaModel(Path(__file__).resolve().parents[1])

    def test_real_sdk_startup_motion_and_all_motor_off_receipt(self):
        from memory_hand import MemoryHand
        backend = MemoryHand(self.model)
        with patch("serial.Serial.open", side_effect=AssertionError("REAL_SERIAL_FORBIDDEN")):
            report = owner(Receiver(), backend, max_seconds=.18).run()
        self.assertTrue(report["active"], report)
        self.assertTrue(report["release_confirmed"], report)
        self.assertFalse(any(backend.torque.values()))
        self.assertTrue(backend.closed)
        startup = [(p[4], p[5]) for _, p in backend.packets[:85]]
        self.assertEqual(startup, [(2, 16)] * 34 + [(3, 42)] * 17
                         + [(3, 40)] * 17 + [(2, 16)] * 17)
        playback = [p for phase, p in backend.packets if phase == "playback"]
        self.assertTrue(playback)
        self.assertTrue(all(p[4:6] == bytes((3, 42)) for p in playback))
        self.assertEqual([(p[4], p[5]) for _, p in backend.packets[-34:]],
                         [(3, 40)] * 17 + [(2, 40)] * 17)
        self.assertFalse(backend.responses)

    def test_hardware_safety_failures_only_read_never_enable(self):
        from memory_hand import MemoryHand
        for options in ({"voltage": 39}, {"temperature": 40}, {"residual_on": 5}):
            with self.subTest(options=options):
                backend = MemoryHand(self.model, **options)
                report = owner(Receiver(), backend).run()
                self.assertFalse(report["arm_attempted"])
                self.assertFalse(report["active"])
                self.assertFalse(report["release_confirmed"])
                self.assertTrue(backend.closed)
                self.assertTrue(all(p[4] == 2 for _, p in backend.packets))

    def test_one_motor_off_read_error_remains_unknown_with_real_packets(self):
        from memory_hand import MemoryHand
        backend = MemoryHand(
            self.model, fault=lambda bus, p: bus.phase == "release"
            and p[2] == 7 and p[4:6] == bytes((2, 40)),
        )
        report = owner(Receiver(), backend, max_seconds=.18).run()
        self.assertTrue(report["active"])
        self.assertFalse(report["release_confirmed"])
        self.assertEqual(report["release_confirmed_ids"], [])
        self.assertEqual(report["release_attempts"][-1]["failed_ids"], [7])
        self.assertEqual(report["controller"]["lifecycle"], "RELEASE_UNKNOWN")


if __name__ == "__main__":
    unittest.main()
