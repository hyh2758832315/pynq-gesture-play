import json
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest

from pynq_multimodal_game.controls import ControlSource, MockControlAdapter, MockInput
from pynq_multimodal_game.demo import build_demo_scene, create_demo_assets, create_demo_engine
from pynq_multimodal_game.game import Coin, GameEngine
from pynq_multimodal_game.replay import (
    GameEventKind,
    build_demo_controls,
    load_control_jsonl,
    run_replay,
    write_replay_result,
)


class ReplayTests(unittest.TestCase):
    def test_replay_report_is_deterministic_except_timing(self) -> None:
        adapter = MockControlAdapter(ControlSource.KEYBOARD)
        controls = tuple(
            adapter.sample(MockInput(right=True), tick_id=tick_id, timestamp_ns=tick_id)
            for tick_id in range(8)
        )
        assets = create_demo_assets()

        first = run_replay(
            create_demo_engine(),
            controls,
            scene_builder=lambda state, engine: build_demo_scene(
                state, engine.config, assets
            ),
            renderer=assets.renderer,
        )
        second = run_replay(
            create_demo_engine(),
            controls,
            scene_builder=lambda state, engine: build_demo_scene(
                state, engine.config, assets
            ),
            renderer=assets.renderer,
        )

        self.assertEqual(first.final_state, second.final_state)
        self.assertEqual(first.events, second.events)
        self.assertEqual(first.report.controls_sha256, second.report.controls_sha256)
        self.assertEqual(first.report.final_state_sha256, second.report.final_state_sha256)
        self.assertEqual(first.report.first_frame_crc32, second.report.first_frame_crc32)
        self.assertEqual(first.report.last_frame_crc32, second.report.last_frame_crc32)
        self.assertEqual(8, first.report.tick_metrics.count)
        self.assertLessEqual(first.report.tick_metrics.p50_ns, first.report.tick_metrics.p95_ns)
        self.assertLessEqual(first.report.tick_metrics.p95_ns, first.report.tick_metrics.p99_ns)
        self.assertLessEqual(first.report.tick_metrics.p99_ns, first.report.tick_metrics.max_ns)

    def test_replay_records_coin_event_and_writes_json(self) -> None:
        adapter = MockControlAdapter(ControlSource.KEYBOARD)
        control = adapter.sample(MockInput(), tick_id=0, timestamp_ns=100)
        result = run_replay(GameEngine(coins=(Coin(4, 0),)), (control,))

        self.assertEqual(10, result.report.final_score)
        self.assertEqual(
            (GameEventKind.COIN_COLLECTED,),
            tuple(event.kind for event in result.events),
        )
        with TemporaryDirectory() as temporary_directory:
            write_replay_result(result, temporary_directory, "coin")
            report_path = Path(temporary_directory) / "coin.report.json"
            events_path = Path(temporary_directory) / "coin.events.jsonl"

            report = json.loads(report_path.read_text(encoding="ascii"))
            event = json.loads(events_path.read_text(encoding="ascii"))

        self.assertEqual(10, report["final_score"])
        self.assertEqual("COIN_COLLECTED", event["kind"])

    def test_demo_controls_round_trip_through_jsonl(self) -> None:
        controls = build_demo_controls(20)
        with TemporaryDirectory() as temporary_directory:
            path = Path(temporary_directory) / "demo.jsonl"
            from pynq_multimodal_game.controls import write_control_jsonl

            write_control_jsonl(path, controls)
            restored = load_control_jsonl(path)

        self.assertEqual(controls, restored)


if __name__ == "__main__":
    unittest.main()