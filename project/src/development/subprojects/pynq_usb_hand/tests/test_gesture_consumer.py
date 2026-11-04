from dataclasses import replace
import unittest
from unittest.mock import patch

from pynq_usb_hand.controller import Controller
from pynq_usb_hand.gesture_consumer import (
    GestureConsumer, GestureObservation, LatestGesture, LatestVisionMailbox,
)
from pynq_usb_hand.motion import Cancelled, MockBackend, MotionSettings


class PassiveGestureTests(unittest.TestCase):
    def test_vision_mailbox_reads_one_latest_snapshot_and_fails_closed(self):
        class Provider:
            snapshot = {"run_id": "run-a", "config_epoch": "cfg-a", "frame_id": 2,
                        "observed_at": 1.0, "source_at": 0.9, "valid": True,
                        "gesture": "scissors"}

            def peek_hand_classification(self):
                return self.snapshot

        provider = Provider()
        mailbox = LatestVisionMailbox(provider)
        self.assertEqual(mailbox.read().gesture, "scissors")
        provider.snapshot = {**provider.snapshot, "frame_id": 4, "gesture": None}
        self.assertEqual(mailbox.read().frame_id, 4)
        self.assertIsNone(mailbox.read().gesture)
        provider.snapshot = {**provider.snapshot, "gesture": "unsupported"}
        self.assertIsNone(mailbox.read())
        provider.snapshot = None
        self.assertIsNone(mailbox.read())

    def observation(self, frame, at, gesture="paper", **changes):
        return replace(GestureObservation("run-a", "cfg-a", frame, at, at, True, gesture), **changes)

    def test_single_slot_drops_duplicates_old_frames_and_never_revives_old_session(self):
        slot = LatestGesture()
        first = self.observation(2, 1)
        self.assertTrue(slot.offer(first))
        self.assertFalse(slot.offer(self.observation(2, 1.2, "fist")))
        self.assertFalse(slot.offer(self.observation(1, 1.3)))
        self.assertIs(slot.read(), first)
        slot.offer(self.observation(3, 1.4, run_id="new-run"))
        self.assertFalse(slot.offer(self.observation(4, 1.5)))
        self.assertEqual(slot.read().run_id, "new-run")

    def test_producer_never_waits_for_consumer_lock(self):
        slot = LatestGesture()
        with slot._lock:
            self.assertFalse(slot.offer(self.observation(1, 1)))
        self.assertIsNone(slot.read())

    def session(self, waits=(0.001,) * 3):
        backend = MockBackend()
        controller = Controller(lambda: backend, lease_seconds=5,
                                settings=MotionSettings.fixed_playback(stage_waits=waits))
        self.addCleanup(controller.close)
        controller.wait_connected()
        controller.arm()
        self.assertTrue(controller.wait_idle())
        slot = LatestGesture()
        consumer = GestureConsumer(controller, slot, source_identity=("run-a", "cfg-a"),
                                   max_age=0.5, stable_seconds=0.1, renew_interval=0.2)
        return consumer, slot, controller, backend

    def publish(self, consumer, slot, frame, now, gesture="paper", **changes):
        slot.offer(self.observation(frame, now, gesture, **changes))
        return consumer.tick(now)

    def test_stability_fresh_frames_only_once_per_state_and_no_queued_busy_replay(self):
        consumer, slot, controller, backend = self.session()
        self.assertEqual(self.publish(consumer, slot, 1, 1), "stabilizing")
        self.assertEqual(consumer.tick(1.15), "duplicate_frame")
        self.assertEqual(self.publish(consumer, slot, 2, 1.2), "accepted")
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["operation"]["state"], "paper")
        self.assertEqual(self.publish(consumer, slot, 3, 1.3), "unchanged")
        self.assertEqual(len(backend.writes), 3)
        # Hold the owner's condition to test MOVING deterministically.
        with controller.condition:
            self.assertEqual(self.publish(consumer, slot, 4, 1.4, "fist"), "stabilizing")
            self.assertEqual(self.publish(consumer, slot, 5, 1.6, "fist"), "accepted")
            self.assertEqual(self.publish(consumer, slot, 6, 1.7, "scissors"), "busy_dropped")
        self.assertTrue(controller.wait_idle())
        self.assertEqual(consumer.tick(1.75), "duplicate_frame")
        self.assertEqual(controller.status()["operation"]["state"], "rock")
        self.assertEqual(self.publish(consumer, slot, 7, 1.8, "scissors"), "stabilizing")
        self.assertEqual(self.publish(consumer, slot, 8, 2.0, "scissors"), "accepted")
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["actual_state"], "unknown")
        self.assertEqual(controller.status()["estimated_state"], "scissors")

    def test_stale_invalid_or_changed_source_releases_latches_no_default_motion(self):
        for changes, now in (({}, 1.6), ({"valid": False}, 1), ({"run_id": "other"}, 1),
                             ({"config_epoch": "other"}, 1), ({}, 0.5)):
            with self.subTest(changes=changes, now=now):
                consumer, slot, controller, backend = self.session()
                slot.offer(self.observation(1, 1, **changes))
                consumer.tick(now)
                self.assertTrue(consumer.stopped)
                self.assertTrue(controller.wait_idle())
                self.assertFalse(backend.torque)
                self.assertEqual(backend.writes, [])
                self.assertEqual(self.publish(consumer, slot, 2, 2), "stopped")

    def test_fresh_unclassified_frame_returns_to_default_once(self):
        consumer, slot, controller, backend = self.session()
        self.assertEqual(self.publish(consumer, slot, 1, 1, None), "accepted")
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["operation"]["state"], "default")
        count = len(backend.writes)
        self.assertEqual(self.publish(consumer, slot, 2, 1.1, None), "unchanged")
        self.assertEqual(len(backend.writes), count)
        self.assertEqual(self.publish(consumer, slot, 3, 1.2, "paper"), "stabilizing")
        self.assertEqual(self.publish(consumer, slot, 4, 1.4, "paper"), "accepted")
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["operation"]["state"], "paper")
        self.assertEqual(self.publish(consumer, slot, 5, 1.5, None), "accepted")
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["operation"]["state"], "default")
        self.assertEqual(self.publish(consumer, slot, 6, 1.6, "paper"), "stabilizing")
        self.assertEqual(self.publish(consumer, slot, 7, 1.8, "paper"), "accepted")
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()["operation"]["state"], "paper")

    def test_unclassified_frame_with_nonadvancing_source_time_cannot_move_hand(self):
        consumer, slot, controller, backend = self.session()
        self.assertEqual(self.publish(consumer, slot, 1, 1, "paper"), "stabilizing")
        self.assertEqual(self.publish(consumer, slot, 2, 1.1, None, source_at=1),
                         "nonadvancing_source_time")
        self.assertEqual(backend.writes, [])

    def test_cancel_racing_renew_is_latched_without_new_motion(self):
        consumer, slot, controller, backend = self.session()
        slot.offer(self.observation(1, 1))
        with patch.object(controller, "renew", side_effect=Cancelled("external stop")):
            self.assertEqual(consumer.tick(1), "renew_failed")
        self.assertTrue(consumer.stopped)
        self.assertTrue(controller.wait_idle())
        self.assertFalse(backend.torque)

    def test_nonadvancing_timestamp_does_not_count_as_stability(self):
        consumer, slot, controller, backend = self.session()
        self.publish(consumer, slot, 1, 1)
        self.assertEqual(self.publish(consumer, slot, 2, 1.1, source_at=1), "nonadvancing_source_time")
        self.assertEqual(backend.writes, [])

    def test_long_source_gap_restarts_stability(self):
        consumer, slot, controller, backend = self.session()
        self.publish(consumer, slot, 1, 1)
        self.assertEqual(self.publish(consumer, slot, 2, 2), "stabilizing")
        self.assertEqual(backend.writes, [])

    def test_no_new_frames_cannot_extend_source_age(self):
        consumer, slot, controller, backend = self.session()
        self.publish(consumer, slot, 1, 1)
        self.publish(consumer, slot, 1, 1.49)
        self.assertEqual(consumer.tick(1.51), "invalid_or_stale_source")
        self.assertTrue(controller.wait_idle())
        self.assertFalse(backend.torque)



if __name__ == "__main__":
    unittest.main()
