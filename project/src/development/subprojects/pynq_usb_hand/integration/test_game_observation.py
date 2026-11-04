"""Optional repository integration check, separate from standalone hand tests."""
from pathlib import Path
import sys
import unittest
from unittest.mock import patch
from pynq_usb_hand.gesture_consumer import GestureObservation, LatestGesture


class GameObservationTests(unittest.TestCase):
    def test_provider_to_slot_to_real_sdk_controller(self):
        from pynq_usb_hand.controller import Controller
        from pynq_usb_hand.gesture_consumer import GestureConsumer
        from pynq_usb_hand.motion import MotionSettings
        from pynq_usb_hand.orca_backend import OrcaModel
        root = Path(__file__).resolve().parents[1]
        with patch.object(sys, "path", [str(root / "tests"), str(root.parents[1] / "python"), *sys.path]):
            from memory_hand import MemoryHand
            from pynq_multimodal_game.vision_input import GameVisionInputProvider
        backend = MemoryHand(OrcaModel(root))
        controller = Controller(lambda: backend, lease_seconds=5,
                                settings=MotionSettings.fixed_playback(stage_waits=(0.001,) * 3))
        self.addCleanup(controller.close)
        controller.wait_connected()
        controller.arm()
        self.assertTrue(controller.wait_idle())
        slot = LatestGesture()
        consumer = GestureConsumer(controller, slot, source_identity=("run-a", "cfg-a"),
                                   max_age=0.5, stable_seconds=0.1, renew_interval=0.2)
        now = [10.0]
        provider = GameVisionInputProvider(clock=lambda: now[0])
        frame = 0
        backend.packets.clear()
        for stable, label, expected in (("5", "PAPER", "paper"), ("0", "ROCK", "rock"), ("2", "SCISSORS", "scissors")):
            for attempt in range(2):
                frame += 1
                now[0] += 0.15
                packet = {"run_id": "run-a", "server_age_ms": 10, "stable": stable, "rps": label,
                          "control": {"schema": "gesture-control-v1", "frame_id": frame,
                                      "action_event_seq": 0, "valid": True, "direction": "LEFT"}}
                provider.publish(packet, config_epoch="cfg-a")
                sample, receipt = provider.sample_for_game("game2", tick_id=frame)
                slot.offer(GestureObservation.from_game(sample, receipt, observed_at=now[0]))
                self.assertEqual(consumer.tick(now[0]), "accepted" if attempt else "stabilizing")
            self.assertTrue(controller.wait_idle())
            self.assertEqual(controller.status()["operation"]["state"], expected)
            self.assertEqual(controller.status()["operation"]["status"], "played")
        self.assertTrue(backend.packets)
        self.assertTrue(all((p[4], p[5]) == (3, 42) for _, p in backend.packets))
        consumer.tick(now[0] + 0.6)
        self.assertTrue(controller.wait_idle())
        self.assertFalse(any(backend.torque.values()))
        self.assertTrue(consumer.stopped)
        controller.close()
        self.assertTrue(backend.closed)

    def test_existing_game_provider_sample_is_copied_without_consuming_edges(self):
        repo = Path(__file__).resolve().parents[3]
        with patch.object(sys, "path", [str(repo / "python"), *sys.path]):
            from pynq_multimodal_game.vision_input import GameVisionInputProvider
        now = [10.0]
        providers = [GameVisionInputProvider(clock=lambda: now[0]) for _ in range(2)]
        slot = LatestGesture()
        for frame, stable, label in ((1, "5", "PAPER"), (2, "0", "ROCK"), (3, "0", "ROCK"), (4, "2", "SCISSORS")):
            now[0] += 0.1
            packet = {"run_id": "run-a", "server_age_ms": 20, "stable": stable, "rps": label,
                      "control": {"schema": "gesture-control-v1", "frame_id": frame,
                                  "action_event_seq": 0, "valid": True, "direction": "LEFT"}}
            sampled = []
            for provider in providers:
                provider.publish(packet, config_epoch="cfg-a")
                sampled.append(provider.sample_for_game("game2", tick_id=frame))
            game_input, receipt = sampled[1]
            before = dict(receipt)
            observation = GestureObservation.from_game(game_input, receipt, observed_at=now[0])
            self.assertTrue(slot.offer(observation))
            self.assertEqual(sampled[0], sampled[1])
            self.assertEqual(receipt, before)
            self.assertAlmostEqual(observation.source_at, now[0] - 0.02)
            self.assertEqual(observation.gesture, game_input.hand_gesture.value)
            with self.assertRaises(ValueError):
                GestureObservation.from_game(game_input, {**receipt, "sample_tick": -1}, observed_at=now[0])
            # Re-reading cached input cannot silently make the frame newer.
            now[0] += 0.02
            for provider in providers:
                next_sample, next_receipt = provider.sample_for_game("game2", tick_id=frame + 10)
            cached = GestureObservation.from_game(next_sample, next_receipt, observed_at=now[0])
            self.assertFalse(slot.offer(cached))
            self.assertAlmostEqual(cached.source_at, observation.source_at)
        self.assertEqual(providers[0].sample(tick_id=99), providers[1].sample(tick_id=99))

