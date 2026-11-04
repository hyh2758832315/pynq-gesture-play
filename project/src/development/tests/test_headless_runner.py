import unittest

from pynq_multimodal_game.demo import build_demo_scene, create_demo_assets, create_demo_engine
from pynq_multimodal_game.headless_runner import TICK_PERIOD_NS, run_headless_replay
from pynq_multimodal_game.replay import build_demo_controls, run_replay


class CountingRenderer:
    def __init__(self, renderer: object) -> None:
        self._renderer = renderer
        self.render_calls = 0

    def render(self, scene: object) -> object:
        self.render_calls += 1
        return self._renderer.render(scene)

    def crc32(self, frame: object) -> int:
        return self._renderer.crc32(frame)


class HeadlessRunnerTests(unittest.TestCase):
    def test_headless_replay_matches_c1_golden_outputs(self) -> None:
        controls = build_demo_controls(20)
        assets = create_demo_assets()
        clock_values = iter(range(1_000))
        scene_builder = lambda state, engine: build_demo_scene(
            state, engine.config, assets
        )

        headless = run_headless_replay(
            create_demo_engine(),
            controls,
            scene_builder=scene_builder,
            renderer=assets.renderer,
            now_ns=lambda: next(clock_values),
        )
        replay = run_replay(
            create_demo_engine(),
            controls,
            scene_builder=scene_builder,
            renderer=assets.renderer,
        )

        self.assertEqual(replay.final_state, headless.final_state)
        self.assertEqual(replay.report.final_state_sha256, headless.report.final_state_sha256)
        self.assertEqual(replay.report.first_frame_crc32, headless.report.first_frame_crc32)
        self.assertEqual(replay.report.last_frame_crc32, headless.report.last_frame_crc32)
        self.assertEqual(0, headless.report.deadline_miss_count)
        self.assertGreaterEqual(headless.report.audit_render_ns, 0)

    def test_renders_only_first_and_last_replay_frames(self) -> None:
        controls = build_demo_controls(20)
        assets = create_demo_assets()
        renderer = CountingRenderer(assets.renderer)
        clock_values = iter(range(1_000))

        run_headless_replay(
            create_demo_engine(),
            controls,
            scene_builder=lambda state, engine: build_demo_scene(
                state, engine.config, assets
            ),
            renderer=renderer,  # type: ignore[arg-type]
            now_ns=lambda: next(clock_values),
        )

        self.assertEqual(2, renderer.render_calls)

    def test_counts_tick_that_finishes_after_its_next_deadline(self) -> None:
        controls = build_demo_controls(2)
        assets = create_demo_assets()
        clock_values = iter(
            (
                0,
                1,
                TICK_PERIOD_NS + 1,
                TICK_PERIOD_NS + 2,
                TICK_PERIOD_NS + 3,
                TICK_PERIOD_NS + 4,
                TICK_PERIOD_NS + 5,
                TICK_PERIOD_NS + 6,
            )
        )

        result = run_headless_replay(
            create_demo_engine(),
            controls,
            scene_builder=lambda state, engine: build_demo_scene(
                state, engine.config, assets
            ),
            renderer=assets.renderer,
            now_ns=lambda: next(clock_values),
        )

        self.assertEqual(1, result.report.deadline_miss_count)


if __name__ == "__main__":
    unittest.main()