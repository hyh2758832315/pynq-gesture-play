import unittest
from pathlib import Path
import runpy
import sys
import tempfile
import types
from unittest.mock import patch

from pynq_usb_hand.buttons import ButtonSession, DebouncedButtons, STATES, state_route


class ButtonTests(unittest.TestCase):
    def test_model_verifies_once_before_any_button_or_serial_access(self):
        from pynq_usb_hand import assets
        root = Path(__file__).resolve().parents[1]
        resource_stub = types.SimpleNamespace(RUSAGE_SELF=0, getrusage=lambda _: types.SimpleNamespace(ru_maxrss=0))
        with patch.dict(sys.modules, resource=resource_stub):
            namespace = runpy.run_path(str(root / "tools/board_buttons.py"))
        original_read = Path.read_text
        def read(path, *args, **kwargs):
            if path == Path("/proc/sys/kernel/random/boot_id"):
                return "offline-boot"
            if path == root / "source_manifest.json":
                return '{"sha256": {}}'
            return original_read(path, *args, **kwargs)
        with tempfile.TemporaryDirectory() as directory, patch.object(Path, "read_text", read), \
                patch.object(assets, "verify_frozen", wraps=assets.verify_frozen) as verify:
            def no_gpio(address):
                self.assertEqual(verify.call_count, 1)
                raise OSError("OFFLINE_GPIO_SENTINEL")
            options = types.SimpleNamespace(output=Path(directory) / "report.json", boot_id="offline-boot",
                                            address=0, port="/dev/forbidden", seconds=10)
            with patch.dict(namespace["run"].__globals__, ButtonReader=no_gpio):
                self.assertEqual(namespace["run"](options), 1)
            self.assertEqual(verify.call_count, 1)
            self.assertIn("OFFLINE_GPIO_SENTINEL", options.output.read_text())

    def test_every_gesture_requires_default_even_after_same_gesture(self):
        for state in STATES[1:]:
            self.assertEqual(state_route(state), ("default", state))
            self.assertEqual(state_route(state), ("default", state))
        self.assertEqual(state_route("default"), ("default",))
        with self.assertRaises(ValueError):
            state_route("neutral")

    def test_four_buttons_and_hold(self):
        for index, state in enumerate(STATES):
            buttons = DebouncedButtons(0.02)
            self.assertIsNone(buttons.sample(0, 0.0))
            self.assertIsNone(buttons.sample(0, 0.03))
            self.assertIsNone(buttons.sample(1 << index, 0.04))
            self.assertEqual(buttons.sample(1 << index, 0.07), state)
            self.assertIsNone(buttons.sample(1 << index, 2.0))

    def test_startup_held_and_chords_require_full_release(self):
        buttons = DebouncedButtons(0.02)
        for mask, now in ((4, 0.0), (4, 0.1), (0, 0.2), (0, 0.3),
                          (3, 0.4), (3, 0.5), (2, 0.6), (2, 0.7)):
            self.assertIsNone(buttons.sample(mask, now))
        buttons.sample(0, 0.8)
        buttons.sample(0, 0.9)
        buttons.sample(8, 1.0)
        self.assertEqual(buttons.sample(8, 1.1), "rock")

    def test_bounce_and_invalid_input(self):
        buttons = DebouncedButtons(0.02)
        for mask, now in ((0, 0.0), (0, 0.03), (1, 0.04), (0, 0.05),
                          (1, 0.06), (1, 0.07)):
            self.assertIsNone(buttons.sample(mask, now))
        self.assertEqual(buttons.sample(1, 0.1), "default")
        for mask in (-1, 16, True):
            with self.assertRaises(ValueError):
                buttons.sample(mask, 1.0)
        with self.assertRaises(ValueError):
            buttons.sample(0, 0.0)

    def test_board_audit_uses_sdk_endianness(self):
        from pynq_usb_hand.transport import BoundedPortHandler
        from scservo_sdk import scscl

        root = Path(__file__).resolve().parents[1]
        resource_module = sys.modules.get("resource")
        sys.modules["resource"] = types.ModuleType("resource")
        try:
            namespace = runpy.run_path(str(root / "tools" / "board_buttons.py"))
        finally:
            if resource_module is None:
                sys.modules.pop("resource", None)
            else:
                sys.modules["resource"] = resource_module
        with patch.object(BoundedPortHandler, "writePort", lambda self, packet: len(packet)):
            backend = namespace["AuditBackend"](namespace["OrcaModel"](root), "/dev/forbidden",
                                                 namespace["SafetyPolicy"](40, 2), speed=500)
        servo = scscl(backend.transport)
        backend.client.servo = servo
        packets = []

        def send(packet):
            packet[0:2] = [255, 255]
            packet[-1] = ~sum(packet[2:-1]) & 255
            backend.transport.writePort(packet)
            packets.append(bytes(packet))
            return [255, 255, 1, 2, 0, 252], 0, 0

        servo.txRxPacket = send
        self.assertEqual(servo.WritePos(1, 700, 0, 500), (0, 0))
        self.assertEqual(packets[0][10:12], bytes([1, 244]))
        for duration, speed in ((0, 600), (1, 500)):
            with self.assertRaises(ValueError):
                servo.WritePos(1, 700, duration, speed)
        self.assertEqual(len(packets), 1)

    def test_lean_board_audit_skips_packet_and_sample_instrumentation(self):
        from pynq_usb_hand.transport import BoundedPortHandler

        root = Path(__file__).resolve().parents[1]
        resource_module = sys.modules.get("resource")
        sys.modules["resource"] = types.ModuleType("resource")
        try:
            namespace = runpy.run_path(str(root / "tools" / "board_buttons.py"))
        finally:
            if resource_module is None:
                sys.modules.pop("resource", None)
            else:
                sys.modules["resource"] = resource_module
        backend = namespace["AuditBackend"](namespace["OrcaModel"](root), "/dev/forbidden",
                                             namespace["SafetyPolicy"](40, 2), full_audit=False)
        self.assertNotIn("writePort", backend.transport.__dict__)
        frame = object()
        with patch.object(namespace["OrcaBackend"], "sample", return_value=frame) as sample:
            self.assertIs(backend.sample(None), frame)
        sample.assert_called_once_with(None)
        with backend.interval("arm"):
            self.assertEqual(backend.context, "motion")
        self.assertEqual(backend.samples, [])
        self.assertEqual(backend.intervals, [])
        self.assertEqual(backend.counts, {})
        with patch.object(namespace["OrcaBackend"], "release", return_value=()) as release:
            self.assertEqual(backend.release(), ())
        release.assert_called_once_with()
        self.assertEqual(backend.releases[0]["ids"], list(range(1, 18)))
        self.assertEqual(backend.releases[0]["failed_ids"], [])
        self.assertIsInstance(backend.transport, BoundedPortHandler)


class SessionController:
    def __init__(self):
        self.current = {"lifecycle": "CONNECTED_OFF", "error": None, "session_id": "session",
                        "enable_epoch": None, "operation": None, "actual_state": "unknown"}
        self.arms = 0
        self.requests = []
        self.renewals = []
        self.releases = 0

    def status(self):
        return dict(self.current)

    def arm(self):
        self.arms += 1
        self.current.update(lifecycle="ARMING")

    def submit(self, state, **identity):
        self.requests.append((state, identity))
        self.current.update(lifecycle="MOVING", operation={"state": state, "request_id": identity["request_id"], "status": "running"})
        return "accepted"

    def renew(self, **identity):
        self.renewals.append(identity)

    def release(self):
        self.releases += 1


class ButtonSessionTests(unittest.TestCase):
    def press(self, session, mask, now):
        session.tick(0, now)
        session.tick(0, now + 0.04)
        session.tick(mask, now + 0.05)
        return session.tick(mask, now + 0.09)

    def test_four_states_release_and_new_epoch(self):
        controller = SessionController()
        session = ButtonSession(controller)
        for index, state in enumerate(STATES):
            now = index * 3.0
            self.assertEqual(self.press(session, 1 << index, now)[0]["event"], "arm_requested")
            controller.current.update(lifecycle="READY", enable_epoch=str(index))
            self.assertEqual(session.tick(1 << index, now + 0.1)[0]["event"], "accepted")
            session.tick(1 << index, now + 0.7)
            self.assertEqual(controller.requests[-1][1]["request_id"], index + 1)
            self.assertEqual(controller.requests[-1][1]["enable_epoch"], str(index))
            controller.current["operation"]["status"] = "reached"
            controller.current.update(lifecycle="READY", actual_state=state)
            self.assertEqual(session.tick(1 << index, now + 0.8)[0]["event"], "reached")
            controller.current.update(lifecycle="CONNECTED_OFF", enable_epoch=None)
            self.assertEqual(session.tick(1 << index, now + 1.0)[0]["event"], "released")
            self.assertEqual(session.tick(1 << index, now + 1.5), [])
        self.assertEqual(controller.arms, 4)
        self.assertEqual(len(controller.requests), 4)

    def test_playback_startup_arm_once_and_four_states_without_release(self):
        controller = SessionController()
        session = ButtonSession(controller, playback=True)
        self.assertEqual(session.tick(0, 0)[0]["event"], "startup_arm_requested")
        controller.current.update(lifecycle="READY_IDLE", enable_epoch="one")
        self.assertEqual(session.tick(0, 0.04)[0]["event"], "ready")
        for index, state in enumerate(STATES):
            now = 0.2 + index * 2
            self.assertEqual(self.press(session, 1 << index, now)[0]["event"], "accepted")
            controller.current["operation"]["status"] = "played"
            controller.current.update(lifecycle="READY_IDLE", estimated_state=state)
            self.assertEqual(session.tick(1 << index, now + 0.1)[0]["event"], "played")
            self.assertEqual(session.phase, "idle")
            count = len(controller.renewals)
            session.tick(1 << index, now + 0.8)
            self.assertGreater(len(controller.renewals), count)
        self.assertEqual(controller.arms, 1)
        self.assertEqual(controller.releases, 0)
        self.assertEqual([state for state, identity in controller.requests], list(STATES))
        self.assertTrue(all(identity["enable_epoch"] == "one" for state, identity in controller.requests))

    def test_playback_busy_key_is_not_replayed_after_completion(self):
        controller = SessionController()
        session = ButtonSession(controller, playback=True)
        session.tick(0, 0)
        controller.current.update(lifecycle="READY_IDLE", enable_epoch="one")
        session.tick(0, 0.04)
        self.press(session, 1, 0.1)
        self.assertEqual(self.press(session, 2, 0.3)[0]["event"], "ignored_busy")
        controller.current["operation"]["status"] = "played"
        controller.current.update(lifecycle="READY_IDLE", estimated_state="default")
        session.tick(2, 0.5)
        self.assertEqual(session.tick(2, 0.8), [])
        self.assertEqual(len(controller.requests), 1)

    def test_playback_rejects_early_off_and_false_reached(self):
        for fault in ("off", "reached"):
            controller = SessionController()
            session = ButtonSession(controller, playback=True)
            session.tick(0, 0)
            controller.current.update(lifecycle="READY_IDLE", enable_epoch="one")
            session.tick(0, 0.04)
            self.press(session, 1, 0.1)
            if fault == "off":
                controller.current.update(lifecycle="CONNECTED_OFF")
            else:
                controller.current["operation"]["status"] = "reached"
                controller.current.update(lifecycle="READY_IDLE", actual_state="default", estimated_state="default")
            with self.subTest(fault=fault), self.assertRaises(RuntimeError):
                session.tick(1, 0.3)
            self.assertEqual(controller.releases, 1)
            self.assertEqual(controller.arms, 1)

    def test_playback_configuration_requires_both_flags_and_explicit_waits(self):
        root = Path(__file__).resolve().parents[1]
        with patch.dict(sys.modules, {"resource": types.ModuleType("resource")}):
            namespace = runpy.run_path(str(root / "tools/board_buttons.py"))
        settings = namespace["playback_settings"]
        options = types.SimpleNamespace(fixed_playback=True, confirm_startup_only=True,
                                        playback_stage_waits=(0.1, 0.2, 0.3), minimal_interactions=False)
        self.assertTrue(settings(options).open_loop)
        for field, value in (("confirm_startup_only", False), ("minimal_interactions", True),
                              ("playback_stage_waits", None), ("playback_stage_waits", (0.1, 0.2, 0))):
            changed = types.SimpleNamespace(**{**vars(options), field: value})
            with self.subTest(field=field, value=value), self.assertRaises(ValueError):
                settings(changed)
        with self.assertRaises(ValueError):
            ButtonSession(SessionController(), playback=True, release_on_reached=True)

    def test_busy_key_is_consumed_not_queued(self):
        controller = SessionController()
        session = ButtonSession(controller)
        self.press(session, 1, 0)
        self.assertEqual(self.press(session, 2, 0.2)[0]["event"], "ignored_busy")
        controller.current.update(lifecycle="READY", enable_epoch="new")
        session.tick(2, 0.4)
        self.assertEqual(controller.requests[0][0], "default")
        self.assertEqual(len(controller.requests), 1)

    def test_immediate_release_is_explicit_and_once_after_matching_completion(self):
        for enabled in (False, True):
            controller = SessionController()
            session = ButtonSession(controller, release_on_reached=enabled)
            self.press(session, 1, 0)
            controller.current.update(lifecycle="READY", enable_epoch="new")
            session.tick(1, 0.1)
            controller.current["operation"]["status"] = "reached"
            controller.current.update(lifecycle="READY", actual_state="default")
            self.assertEqual(session.tick(1, 0.2)[0]["event"], "reached")
            self.assertEqual(controller.releases, int(enabled))
            session.tick(1, 0.3)
            self.assertEqual(controller.releases, int(enabled))
            controller.current.update(lifecycle="CONNECTED_OFF", enable_epoch=None)
            self.assertEqual(session.tick(1, 0.4)[0]["event"], "released")
        for invalid in (0, 1, None, "yes"):
            with self.assertRaises(ValueError):
                ButtonSession(SessionController(), release_on_reached=invalid)

    def test_fault_invalid_input_and_budget_request_release(self):
        for failure in ("budget", "fault", "invalid", "early_off", "wrong_completion"):
            controller = SessionController()
            session = ButtonSession(controller, arm_timeout=1)
            self.press(session, 1, 0)
            mask, now = 1, 0.2
            if failure == "budget":
                now = 1.2
            elif failure == "fault":
                controller.current.update(lifecycle="RELEASE_UNKNOWN", error="OFF unconfirmed")
            elif failure == "invalid":
                mask = 16
            elif failure == "early_off":
                controller.current.update(lifecycle="CONNECTED_OFF")
            else:
                controller.current.update(lifecycle="READY", enable_epoch="new")
                session.tick(1, 0.15)
                controller.current.update(lifecycle="READY")
            with self.assertRaises((ValueError, RuntimeError, TimeoutError)):
                session.tick(mask, now)
            self.assertEqual(controller.releases, 1)

    def test_invalid_budgets(self):
        for value in (0, -1, float("inf"), float("nan")):
            with self.assertRaises(ValueError):
                ButtonSession(SessionController(), request_timeout=value)


if __name__ == "__main__":
    unittest.main()
