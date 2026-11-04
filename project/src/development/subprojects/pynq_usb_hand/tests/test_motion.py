from dataclasses import replace
import threading
import time
from types import SimpleNamespace
import unittest
from unittest.mock import patch

from pynq_usb_hand.motion import Cancellation, Cancelled, MockBackend, Motion, MotionSettings, Snapshot, TIP_JOINTS


class FastCancellation(Cancellation):
    def __init__(self):
        super().__init__(time.monotonic() + 60)

    def wait(self, duration):
        self.check()


class MotionTests(unittest.TestCase):
    def setUp(self):
        self.backend = MockBackend()
        self.backend.torque = True
        self.cancel = FastCancellation()
        self.motion = Motion(self.backend, MotionSettings(step_size=0, hold=0))

    def test_all_routes_default_precedes_gesture(self):
        for state, expected in (("default", 21), ("paper", 43), ("scissors", 42), ("rock", 43)):
            self.backend.writes.clear()
            self.motion.run(state, self.cancel)
            self.assertEqual(len(self.backend.writes), expected)
            self.assertEqual(self.backend.writes[20], self.backend.poses["default"])
            self.assertEqual(self.backend.writes[-1], self.backend.poses[state])

    def test_fixed_playback_never_reads_and_uses_explicit_stage_waits(self):
        settings = MotionSettings.fixed_playback(stage_waits=(0.1, 0.2, 0.3))
        for state, expected_waits in (("default", [0.1]), ("paper", [0.1, 0.2, 0.3]),
                                      ("scissors", [0.1, 0.3]), ("rock", [0.1, 0.2, 0.3])):
            backend = MockBackend()
            backend.torque = True
            motion = Motion(backend, settings)
            with self.subTest(state=state), patch.object(backend, "sample", side_effect=AssertionError("PLAYBACK_READ_FORBIDDEN")), patch.object(self.cancel, "wait") as wait:
                motion.run(state, self.cancel)
            self.assertEqual([item.args[0] for item in wait.call_args_list], expected_waits)
            self.assertEqual(len(backend.writes), len(expected_waits))
            self.assertEqual(backend.writes[0], backend.poses["default"])
            self.assertEqual(backend.writes[-1], backend.poses[state])
            if state in ("paper", "rock"):
                midpoint = backend.writes[1]
                for joint in TIP_JOINTS:
                    self.assertEqual(midpoint[joint], (backend.poses["default"][joint] + backend.poses[state][joint]) / 2)
                if state == "rock":
                    self.assertEqual(midpoint["thumb_abd"], backend.poses["rock"]["thumb_abd"])
                self.assertEqual(midpoint["wrist"], backend.poses["default"]["wrist"])

    def test_fixed_playback_cancel_stops_before_next_stage(self):
        motion = Motion(self.backend, MotionSettings.fixed_playback(stage_waits=(0.1, 0.2, 0.3)))
        def stop(duration):
            self.cancel.event.set()
            self.cancel.check()
        with patch.object(self.cancel, "wait", side_effect=stop), self.assertRaises(Cancelled):
            motion.run("rock", self.cancel)
        self.assertEqual(len(self.backend.writes), 1)

    def test_fixed_playback_compiles_and_validates_only_at_initialization(self):
        settings = MotionSettings.fixed_playback(stage_waits=(0.1, 0.2, 0.3))
        motion = Motion(self.backend, settings)
        with patch.object(motion, "validate", side_effect=AssertionError("RUNTIME_ROM_CHECK_FORBIDDEN")), patch.object(self.backend, "compile_target", side_effect=AssertionError("RUNTIME_COMPILE_FORBIDDEN")), patch.object(self.backend, "sample", side_effect=AssertionError("RUNTIME_READ_FORBIDDEN")):
            for state in ("default", "paper", "scissors", "rock", "rock"):
                motion.run(state, self.cancel)
        self.assertEqual(len(self.backend.writes), 12)

    def test_fixed_playback_requires_reviewed_timings_and_authorization(self):
        for waits in ((), (0.1,), (0.1, 0.2, 0), (True, 0.2, 0.3), (0.1, float("nan"), 0.3), (11, 0.2, 0.3)):
            with self.subTest(waits=waits), self.assertRaises(ValueError):
                MotionSettings.fixed_playback(stage_waits=waits)
        settings = MotionSettings.fixed_playback(stage_waits=(0.1, 0.2, 0.3))
        other = SimpleNamespace(poses=self.backend.poses, roms=self.backend.roms, stage_targets_authorized=True)
        with self.assertRaisesRegex(ValueError, "startup-only"):
            Motion(other, settings)
        with self.assertRaises(ValueError):
            MotionSettings(open_loop=True)

    def test_five_tips_and_thumb_exception(self):
        self.motion.run("rock", self.cancel)
        midpoint = self.backend.writes[31]
        start = self.backend.poses["default"]
        target = self.backend.poses["rock"]
        for joint in TIP_JOINTS:
            self.assertEqual(midpoint[joint], (start[joint] + target[joint]) / 2)
        self.assertEqual(midpoint["thumb_abd"], target["thumb_abd"])
        self.assertEqual(midpoint["wrist"], start["wrist"])

    def test_default_failure_never_starts_gesture(self):
        original = self.backend.write
        def fail_default(target, cancel):
            original(target, cancel)
            raise OSError("injected write failure")
        self.backend.write = fail_default
        with self.assertRaises(OSError):
            self.motion.run("rock", self.cancel)
        self.assertEqual(len(self.backend.writes), 1)

    def test_cancel_between_motor_waypoints(self):
        original = self.backend.write
        def cancel_after_first(target, cancel):
            original(target, cancel)
            cancel.event.set()
        self.backend.write = cancel_after_first
        with self.assertRaises(Cancelled):
            self.motion.run("paper", self.cancel)
        self.assertEqual(len(self.backend.writes), 1)

    def test_stale_incomplete_nan_and_old_feedback(self):
        good = self.backend.sample(self.cancel)
        for bad in (replace(good, sequence=-1), replace(good, joints={}),
                    replace(good, joints={**good.joints, "wrist": float("nan")}),
                    replace(good, started=good.started - 100)):
            self.backend.sample = lambda cancel, frame=bad: frame
            with self.assertRaises((OSError, ValueError)):
                self.motion.sample(self.cancel)

    def test_requires_three_distinct_fresh_feedback_frames(self):
        sequence = self.backend.sequence
        self.motion.reached(self.backend.position, self.cancel)
        self.assertEqual(self.backend.sequence - sequence, 3)

    def test_endpoint_feedback_reads_only_request_start_and_stage_ends(self):
        for state, expected_samples, boundaries in (("default", 4, (21,)), ("paper", 10, (21, 32, 43)),
                                                   ("scissors", 7, (21, 42)), ("rock", 10, (21, 32, 43))):
            backend = MockBackend()
            backend.torque = True
            settings = MotionSettings.endpoints(settle_delay=0, max_reached_samples=3,
                                               max_feedback_gap=2, max_age=2)
            motion = Motion(backend, settings)
            reads = []
            original_sample = backend.sample

            def sample(token):
                reads.append(len(backend.writes))
                return original_sample(token)

            with self.subTest(state=state), patch.object(backend, "sample", side_effect=sample):
                motion.run(state, self.cancel)
            self.assertEqual(len(reads), expected_samples)
            self.assertEqual(reads, [0] + [boundary for boundary in boundaries for _ in range(3)])
            self.assertEqual(backend.writes[-1], backend.poses[state])
            self.assertEqual(backend.writes[20], backend.poses["default"])

    def test_endpoint_feedback_stops_at_sample_budget(self):
        settings = MotionSettings.endpoints(settle_delay=0, max_reached_samples=4,
                                           max_feedback_gap=2, max_age=2)
        motion = Motion(self.backend, settings)
        initial = self.backend.sequence
        with self.assertRaisesRegex(TimeoutError, "sample budget"):
            motion.reached(self.backend.poses["rock"], self.cancel)
        self.assertEqual(self.backend.sequence - initial, 4)

    def test_stage_targets_are_mock_only_and_preserve_phase_boundaries(self):
        settings = MotionSettings.endpoints(settle_delay=0, max_reached_samples=3,
                                           max_feedback_gap=2, max_age=2, stage_targets=True)
        for state, batches, samples in (("default", 1, 4), ("paper", 3, 10),
                                       ("scissors", 2, 7), ("rock", 3, 10)):
            backend = MockBackend()
            backend.torque = True
            motion = Motion(backend, settings)
            with self.subTest(state=state):
                motion.run(state, self.cancel)
                self.assertEqual(len(backend.writes), batches)
                self.assertEqual(backend.sequence, samples)
                self.assertEqual(backend.writes[0], backend.poses["default"])
                self.assertEqual(backend.writes[-1], backend.poses[state])
                if state in ("paper", "rock"):
                    midpoint = backend.writes[1]
                    for joint in TIP_JOINTS:
                        self.assertEqual(midpoint[joint], (backend.poses["default"][joint] + backend.poses[state][joint]) / 2)
                    if state == "rock":
                        self.assertEqual(midpoint["thumb_abd"], backend.poses["rock"]["thumb_abd"])
        other_backend = SimpleNamespace(poses=self.backend.poses, roms=self.backend.roms)
        with self.assertRaisesRegex(ValueError, "offline-only"):
            Motion(other_backend, settings)
        other_backend.stage_targets_authorized = True
        self.assertIs(Motion(other_backend, settings).backend, other_backend)
        other_backend.stage_targets_authorized = 1
        with self.assertRaisesRegex(ValueError, "offline-only"):
            Motion(other_backend, settings)
        with self.assertRaisesRegex(ValueError, "Stage targets"):
            MotionSettings(stage_targets=True)

    def test_stage_target_failure_does_not_start_midpoint(self):
        settings = MotionSettings.endpoints(settle_delay=0, max_reached_samples=3,
                                           max_feedback_gap=2, max_age=2, stage_targets=True)
        motion = Motion(self.backend, settings)

        def fail(target, token):
            raise OSError("stage target write failed")

        with patch.object(self.backend, "write", side_effect=fail), self.assertRaisesRegex(OSError, "stage target"):
            motion.run("rock", self.cancel)
        self.assertEqual(self.backend.sequence, 1)
        self.assertEqual(self.backend.writes, [])

    def test_endpoint_health_deadline_is_checked_within_backend_write(self):
        now = [0.0]
        settings = MotionSettings.endpoints(settle_delay=0, max_reached_samples=3,
                                           max_feedback_gap=0.05, max_age=2)
        motion = Motion(self.backend, settings, clock=lambda: now[0])
        cancel = Cancellation(10, clock=lambda: now[0])
        packets = []

        def write(target, token):
            for motor_id in range(17):
                token.check()
                packets.append(motor_id)
                now[0] += 0.02

        frame = Snapshot(1, 0, 0, dict(self.backend.position))
        with patch.object(self.backend, "sample", return_value=frame), patch.object(self.backend, "write", side_effect=write):
            with self.assertRaisesRegex(TimeoutError, "Health feedback gap"):
                motion.stage("health-budget", self.backend.poses["default"], 20, cancel)
        self.assertEqual(packets, [0, 1, 2])

    def test_endpoint_settling_wait_can_be_cancelled_or_lose_lease(self):
        for fault in ("cancel", "lease"):
            now = [0.0]
            settings = replace(MotionSettings.endpoints(settle_delay=0.1, max_reached_samples=3,
                                                       max_feedback_gap=2, max_age=2), step_size=0)
            backend = MockBackend()
            backend.torque = True
            motion = Motion(backend, settings, clock=lambda: now[0])
            cancel = Cancellation(0.05 if fault == "lease" else 10, clock=lambda: now[0])

            def sample(token):
                token.check()
                backend.sequence += 1
                return Snapshot(backend.sequence, now[0], now[0], dict(backend.position))

            def wait(duration):
                now[0] += min(duration, cancel.deadline - now[0])
                if fault == "cancel":
                    cancel.event.set()
                cancel.check()

            expected = Cancelled if fault == "cancel" else TimeoutError
            with self.subTest(fault=fault), patch.object(backend, "sample", side_effect=sample), patch.object(cancel, "wait", side_effect=wait):
                with self.assertRaises(expected):
                    motion.run("rock", cancel)
            self.assertEqual(len(backend.writes), 21)
            self.assertEqual(backend.sequence, 1)

    def test_endpoint_health_budget_covers_feedback_transaction(self):
        now = [0.0]
        settings = MotionSettings.endpoints(settle_delay=0, max_reached_samples=3,
                                           max_feedback_gap=2, max_age=2)
        motion = Motion(self.backend, settings, clock=lambda: now[0])
        motion.last_sample_started = 0
        now[0] = 1.9
        cancel = Cancellation(10, clock=lambda: now[0])

        def sample(token):
            self.assertEqual(token.deadline, 2)
            started = now[0]
            now[0] += 0.15
            return Snapshot(1, started, now[0], dict(self.backend.position))

        with patch.object(self.backend, "sample", side_effect=sample), self.assertRaisesRegex(TimeoutError, "Health feedback gap"):
            motion.sample(cancel)
        self.assertEqual(motion.last_sequence, -1)

    def test_endpoint_feedback_is_not_reused_across_requests(self):
        settings = MotionSettings.endpoints(settle_delay=0, max_reached_samples=3,
                                           max_feedback_gap=2, max_age=2)
        motion = Motion(self.backend, settings)
        reads = []
        sample = self.backend.sample

        def record(token):
            reads.append(len(self.backend.writes))
            return sample(token)

        with patch.object(self.backend, "sample", side_effect=record):
            motion.run("rock", self.cancel)
            boundary = len(reads)
            motion.run("rock", self.cancel)
        self.assertEqual(boundary, 10)
        self.assertEqual(reads[boundary], 43)
        self.assertEqual(len(reads), 20)

    def test_endpoint_settings_require_explicit_finite_budgets(self):
        for changes in ({"settle_delay": -1}, {"max_reached_samples": 2}, {"max_reached_samples": True},
                        {"max_feedback_gap": 0}, {"max_feedback_gap": 3}, {"max_feedback_gap": float("nan")}):
            arguments = {"settle_delay": 0, "max_reached_samples": 3, "max_feedback_gap": 2, "max_age": 2, **changes}
            with self.subTest(changes=changes), self.assertRaises(ValueError):
                MotionSettings.endpoints(**arguments)

    def test_reached_period_counts_scan_time_only_in_responsive_profile(self):
        for periodic in (False, True):
            for scan_duration in (0.005, 0.05):
                now = [0.0]
                starts = []
                waits = []
                settings = replace(MotionSettings.responsive(), periodic_reached_samples=periodic)
                motion = Motion(self.backend, settings, clock=lambda: now[0])
                cancel = Cancellation(10, clock=lambda: now[0])

                def sample(token):
                    token.check()
                    starts.append(now[0])
                    now[0] += scan_duration
                    self.backend.sequence += 1
                    return Snapshot(self.backend.sequence, starts[-1], now[0], dict(self.backend.position))

                def wait(duration):
                    waits.append(duration)
                    now[0] += duration
                    cancel.check()

                with self.subTest(periodic=periodic, scan_duration=scan_duration):
                    with patch.object(self.backend, "sample", side_effect=sample), patch.object(cancel, "wait", side_effect=wait):
                        motion.reached(self.backend.position, cancel)
                    period = max(scan_duration, settings.sample_interval) if periodic else scan_duration + settings.sample_interval
                    self.assertEqual(len(starts), 3)
                    for index, started in enumerate(starts):
                        self.assertAlmostEqual(started, index * period)
                    self.assertTrue(all(duration > 0 for duration in waits))
                    if periodic and scan_duration >= settings.sample_interval:
                        self.assertEqual(waits, [])

    def test_wait_is_interruptible_and_lease_expires(self):
        cancel = Cancellation(time.monotonic() + 60)
        cancel.event.set()
        with self.assertRaises(Cancelled):
            cancel.wait(30)
        expired = Cancellation(time.monotonic() - 1)
        with self.assertRaises(TimeoutError):
            expired.check()

    def test_invalid_motion_settings(self):
        for arguments in ({"timeout": 0}, {"max_age": float("nan")}, {"hold": -1}, {"tolerance": 1},
                          {"waypoint_feedback_interval": -1}, {"waypoint_feedback_interval": float("nan")},
                          {"waypoint_feedback_interval": float("inf")}, {"waypoint_feedback_interval": 1}):
            with self.assertRaises(ValueError):
                MotionSettings(**arguments)

    def test_periodic_feedback_preserves_targets_and_fresh_stage_completion(self):
        outputs = []
        for interval in (0, 0.1):
            now = [0.0]
            samples = []
            write_ages = []
            backend = MockBackend()
            backend.torque = True
            motion = Motion(backend, MotionSettings(hold=0, waypoint_feedback_interval=interval), clock=lambda: now[0])
            cancel = Cancellation(60, clock=lambda: now[0])
            original_write = backend.write

            def sample(token):
                token.check()
                started = now[0]
                now[0] += 0.01
                backend.sequence += 1
                samples.append((len(backend.writes), started))
                return Snapshot(backend.sequence, started, now[0], dict(backend.position))

            def write(target, token):
                write_ages.append(now[0] - motion.last_sample_started)
                original_write(target, token)
                now[0] += 0.01

            def wait(duration):
                now[0] += duration
                cancel.check()

            with patch.object(backend, "sample", side_effect=sample), patch.object(backend, "write", side_effect=write), patch.object(cancel, "wait", side_effect=wait):
                motion.run("rock", cancel)
            outputs.append((backend.writes, samples))
            self.assertEqual(len(backend.writes), 43)
            for boundary in (21, 32, 43):
                self.assertGreaterEqual(sum(count == boundary for count, _ in samples), 3)
            if interval:
                self.assertLessEqual(max(write_ages), interval + 1e-9)
        self.assertEqual(outputs[0][0], outputs[1][0])
        self.assertLess(len(outputs[1][1]), len(outputs[0][1]))

    def test_periodic_feedback_fault_stops_before_next_write(self):
        now = [0.0]
        motion = Motion(self.backend, MotionSettings(waypoint_feedback_interval=0.1), clock=lambda: now[0])
        cancel = Cancellation(10, clock=lambda: now[0])
        original_write = self.backend.write

        def sample(token):
            if self.backend.writes:
                raise OSError("injected health failure")
            return Snapshot(1, now[0], now[0], dict(self.backend.position))

        def write(target, token):
            original_write(target, token)
            now[0] += 0.02

        def wait(duration):
            now[0] += 0.2

        with patch.object(self.backend, "sample", side_effect=sample), patch.object(self.backend, "write", side_effect=write), patch.object(cancel, "wait", side_effect=wait):
            with self.assertRaisesRegex(OSError, "health failure"):
                motion.stage("periodic", self.backend.poses["rock"], 20, cancel)
        self.assertEqual(len(self.backend.writes), 1)

    def test_periodic_feedback_still_checks_cancellation_on_skipped_reads(self):
        motion = Motion(self.backend, MotionSettings(waypoint_feedback_interval=0.1))
        original_write = self.backend.write

        def write(target, token):
            original_write(target, token)
            token.event.set()

        with patch.object(self.backend, "write", side_effect=write):
            with self.assertRaises(Cancelled):
                motion.run("rock", self.cancel)
        self.assertEqual(len(self.backend.writes), 1)

    def test_responsive_profile_removes_hold_without_changing_route(self):
        settings = MotionSettings.responsive(max_age=2)
        self.assertEqual(settings.hold, 0)
        self.assertEqual(settings.step_size, 0.01)
        self.assertEqual(settings.waypoint_feedback_interval, 0.2)
        self.assertTrue(settings.periodic_reached_samples)
        self.assertFalse(MotionSettings().periodic_reached_samples)
        self.assertEqual(settings.tolerance, self.motion.settings.tolerance)
        motion = Motion(self.backend, settings)
        motion.run("rock", self.cancel)
        self.assertEqual(len(self.backend.writes), 43)
        self.assertEqual(self.backend.writes[20], self.backend.poses["default"])
        self.assertEqual(self.backend.writes[-1], self.backend.poses["rock"])

    def test_settled_feedback_reuse_is_single_use_fresh_and_request_local(self):
        now = [1.0]
        motion = Motion(self.backend, MotionSettings.responsive(), clock=lambda: now[0])
        frame = Snapshot(1, 0.9, 1.0, dict(self.backend.position))
        motion.settled_frame = frame
        with patch.object(motion, "sample", return_value=self.backend.position) as sample:
            self.assertEqual(motion.starting_joints(self.cancel), frame.joints)
            sample.assert_not_called()
            motion.starting_joints(self.cancel)
            self.assertEqual(sample.call_count, 1)
            motion.settled_frame = frame
            now[0] = 3.0
            motion.starting_joints(self.cancel)
            self.assertEqual(sample.call_count, 2)
            motion.settled_frame = frame
            with patch.object(motion, "stage") as stage:
                motion.run("default", self.cancel)
            self.assertIsNone(motion.settled_frame)
            stage.assert_called_once()

    def test_step_period_accounts_for_io_without_catchup_bursts(self):
        for io_duration, expected_period in ((0.01, 0.03), (0.05, 0.05)):
            now = [0.0]
            starts = []
            waits = []
            motion = Motion(self.backend, MotionSettings(step_size=0.03), clock=lambda: now[0])
            cancel = Cancellation(10, clock=lambda: now[0])

            def write(target, token):
                token.check()
                starts.append(now[0])
                now[0] += io_duration

            def wait(duration):
                waits.append(duration)
                now[0] += duration
                cancel.check()

            with patch.object(motion, "sample", return_value=self.backend.position), patch.object(motion, "reached"), patch.object(self.backend, "write", side_effect=write), patch.object(cancel, "wait", side_effect=wait):
                motion.stage("period", self.backend.poses["default"], 2, cancel)
            with self.subTest(io_duration=io_duration):
                self.assertEqual(len(starts), 3)
                for index, started in enumerate(starts):
                    self.assertAlmostEqual(started, index * expected_period)
                self.assertTrue(all(duration > 0 for duration in waits))
                if io_duration > 0.03:
                    self.assertEqual(waits, [])


if __name__ == "__main__":
    unittest.main()