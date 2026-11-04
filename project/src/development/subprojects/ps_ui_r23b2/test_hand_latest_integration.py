"""Offline menu-to-hand observation check; no hardware or game runtime required."""

from __future__ import annotations

from pathlib import Path
import sys
import time
import unittest


ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "subprojects" / "pynq_usb_hand" / "src"))
sys.path.insert(0, str(ROOT / "subprojects" / "ps_ui_r23b2" / "python"))

from pynq_multimodal_game.vision_input import GameVisionInputProvider
from pynq_usb_hand.controller import Controller
from pynq_usb_hand.gesture_consumer import GestureConsumer, LatestVisionMailbox
from pynq_usb_hand.motion import MockBackend, MotionSettings
from pynq_usb_hand.vision_session import VisionHandSession


class LatestVisionHandTests(unittest.TestCase):
    def test_menu_frames_drive_three_gestures_then_default_without_game_sampling(self):
        now = [10.0]
        provider = GameVisionInputProvider(clock=lambda: now[0])
        backend = MockBackend()
        controller = Controller(lambda: backend, lease_seconds=5,
                                settings=MotionSettings.fixed_playback(stage_waits=(.001,) * 3))
        try:
            controller.wait_connected()
            controller.arm()
            self.assertTrue(controller.wait_idle())
            consumer = GestureConsumer(
                controller, LatestVisionMailbox(provider),
                source_identity=("run-a", "cfg-a"), max_age=.5,
                stable_seconds=.1, renew_interval=.2,
            )
            frame = 0

            def offer(stable, label):
                nonlocal frame
                frame += 1
                now[0] += .15
                provider.publish({
                    "run_id": "run-a", "server_age_ms": 0,
                    "stable": stable, "rps": label,
                    "control": {"schema": "gesture-control-v1", "frame_id": frame,
                                "action_event_seq": 0, "valid": True,
                                "direction": "IDLE", "smooth_uv": [0.0, 0.0]},
                }, config_epoch="cfg-a")
                return consumer.tick(now[0])

            for stable, label, expected in (
                ("5", "PAPER", "paper"), ("0", "ROCK", "rock"),
                ("2", "SCISSORS", "scissors"),
            ):
                self.assertEqual(offer(stable, label), "stabilizing")
                self.assertEqual(offer(stable, label), "accepted")
                self.assertTrue(controller.wait_idle())
                self.assertEqual(controller.status()["operation"]["state"], expected)

            self.assertEqual(offer("1", "UNKNOWN"), "accepted")
            self.assertTrue(controller.wait_idle())
            self.assertEqual(controller.status()["operation"]["state"], "default")
            writes = len(backend.writes)
            self.assertEqual(offer("1", "UNKNOWN"), "unchanged")
            self.assertEqual(len(backend.writes), writes)
            self.assertTrue(provider.sample_menu_control(tick_id=frame).hand_valid)

            now[0] += .6
            self.assertEqual(consumer.tick(now[0]), "invalid_or_stale_source")
            self.assertTrue(controller.wait_idle())
            self.assertFalse(backend.torque)
        finally:
            controller.close()

    def test_live_hand_worker_shares_latest_source_with_menu_and_game(self):
        provider = GameVisionInputProvider()
        backend = MockBackend()
        controller = Controller(lambda: backend, lease_seconds=5,
                                settings=MotionSettings.fixed_playback(stage_waits=(.001,) * 3))
        controller.wait_connected()
        controller.arm()
        self.assertTrue(controller.wait_idle())
        session = VisionHandSession(
            controller, provider, source_identity=("shared-run", "shared-config"),
            max_age=.6, stable_seconds=.04, renew_interval=.1,
            poll_seconds=.02,
        )
        frame = 0

        def offer(stable, label):
            nonlocal frame
            frame += 1
            provider.publish({
                "run_id": "shared-run", "server_age_ms": 0,
                "stable": stable, "rps": label,
                "control": {"schema": "gesture-control-v1", "frame_id": frame,
                            "action_event_seq": 0, "valid": True,
                            "direction": "IDLE", "smooth_uv": [0.0, 0.0]},
            }, config_epoch="shared-config")
            # Menu and game both inspect the same source; neither may steal the
            # hand worker's newest classification or cause a frame queue.
            provider.sample_menu_control(tick_id=frame)
            provider.sample_with_receipt(tick_id=frame)

        def wait_for(state):
            deadline = time.monotonic() + 1.5
            while time.monotonic() < deadline:
                operation = controller.status()["operation"]
                if operation is not None and operation["state"] == state:
                    self.assertTrue(controller.wait_idle())
                    return
                time.sleep(.01)
            self.fail(f"hand never reached {state}")

        try:
            offer("5", "PAPER")
            session.start()
            for stable, label, state in (
                ("5", "PAPER", "paper"),
                ("0", "ROCK", "rock"),
                ("2", "SCISSORS", "scissors"),
                ("1", "UNKNOWN", "default"),
            ):
                time.sleep(.07)
                offer(stable, label)
                if state != "default":
                    time.sleep(.07)
                    offer(stable, label)
                wait_for(state)
            writes = len(backend.writes)
            for _ in range(60):
                offer("1", "UNKNOWN")
            deadline = time.monotonic() + 1
            while session.consumer.last_frame != frame and time.monotonic() < deadline:
                time.sleep(.01)
            self.assertEqual(session.consumer.last_frame, frame)
            self.assertEqual(len(backend.writes), writes)
            self.assertTrue(provider.peek_menu_control().hand_valid)
            time.sleep(.65)
            deadline = time.monotonic() + 1
            while not backend.closed and time.monotonic() < deadline:
                time.sleep(.01)
            self.assertTrue(backend.closed, "stale source must release the hand")
        finally:
            session.close()
        self.assertFalse(backend.torque)


if __name__ == "__main__":
    unittest.main()
