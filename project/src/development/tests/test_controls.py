import unittest
from tempfile import TemporaryDirectory
from pathlib import Path

from pynq_multimodal_game.controls import (
    ControlSource,
    ControlSourceMux,
    Direction,
    MockControlAdapter,
    MockInput,
    ReplayControlAdapter,
    write_control_jsonl,
)


class MockControlAdapterTests(unittest.TestCase):
    def setUp(self) -> None:
        self.adapter = MockControlAdapter(ControlSource.KEYBOARD)

    def sample(self, inputs: MockInput, tick_id: int = 0):
        return self.adapter.sample(
            inputs,
            tick_id=tick_id,
            timestamp_ns=tick_id * 16_666_667,
        )

    def test_maps_direction_and_continuous_actions(self) -> None:
        state = self.sample(MockInput(left=True, shield=True))

        self.assertEqual(Direction.LEFT, state.direction)
        self.assertEqual((-1.0, 0.0), (state.hand_x, state.hand_y))
        self.assertTrue(state.low_voice_active)
        self.assertEqual(1.0, state.low_confidence)

    def test_events_only_fire_on_press_edges(self) -> None:
        first = self.sample(MockInput(jump=True, attack=True), tick_id=1)
        held = self.sample(MockInput(jump=True, attack=True), tick_id=2)
        released = self.sample(MockInput(), tick_id=3)
        pressed_again = self.sample(MockInput(jump=True, attack=True), tick_id=4)

        self.assertTrue(first.fist_event)
        self.assertTrue(first.high_voice_event)
        self.assertFalse(held.fist_event)
        self.assertFalse(held.high_voice_event)
        self.assertFalse(released.fist_event)
        self.assertEqual(2, pressed_again.gesture_seq)
        self.assertEqual(2, pressed_again.voice_seq)

    def test_opposing_directions_cancel(self) -> None:
        cancelled = self.sample(MockInput(left=True, right=True))

        self.assertEqual(Direction.IDLE, cancelled.direction)

    def test_last_pressed_axis_wins_diagonal(self) -> None:
        self.sample(MockInput(up=True), tick_id=1)
        horizontal_last = self.sample(MockInput(up=True, right=True), tick_id=2)
        self.sample(MockInput(), tick_id=3)
        self.sample(MockInput(right=True), tick_id=4)
        vertical_last = self.sample(MockInput(up=True, right=True), tick_id=5)

        self.assertEqual(Direction.RIGHT, horizontal_last.direction)
        self.assertEqual(Direction.UP, vertical_last.direction)

    def test_horizontal_wins_when_axes_are_pressed_together(self) -> None:
        state = self.sample(MockInput(right=True, up=True))

        self.assertEqual(Direction.RIGHT, state.direction)

    def test_rejects_non_mock_source(self) -> None:
        with self.assertRaises(ValueError):
            MockControlAdapter(ControlSource.REAL)


class ControlSourceMuxTests(unittest.TestCase):
    def setUp(self) -> None:
        self.keyboard = MockControlAdapter(ControlSource.KEYBOARD)
        self.buttons = MockControlAdapter(ControlSource.BUTTON)
        self.mux = ControlSourceMux(
            [self.keyboard, self.buttons],
            gesture_source=ControlSource.KEYBOARD,
            voice_source=ControlSource.BUTTON,
        )

    def test_combines_independently_selected_modalities(self) -> None:
        self.keyboard.set_input(MockInput(right=True, jump=True))
        self.buttons.set_input(MockInput(shield=True, attack=True))

        state = self.mux.poll(tick_id=0, timestamp_ns=0)

        self.assertEqual(ControlSource.KEYBOARD, state.gesture_source)
        self.assertEqual(Direction.RIGHT, state.direction)
        self.assertTrue(state.fist_event)
        self.assertEqual(ControlSource.BUTTON, state.voice_source)
        self.assertTrue(state.low_voice_active)
        self.assertTrue(state.high_voice_event)

    def test_source_switch_suppresses_first_event(self) -> None:
        self.keyboard.set_input(MockInput(attack=True))
        self.mux.select_voice(ControlSource.KEYBOARD)

        first = self.mux.poll(tick_id=0, timestamp_ns=0)
        self.keyboard.set_input(MockInput())
        self.mux.poll(tick_id=1, timestamp_ns=1)
        self.keyboard.set_input(MockInput(attack=True))
        next_press = self.mux.poll(tick_id=2, timestamp_ns=2)

        self.assertFalse(first.high_voice_event)
        self.assertTrue(next_press.high_voice_event)

    def test_replay_jsonl_round_trip(self) -> None:
        records = [
            self.keyboard.sample(MockInput(right=True), tick_id=0, timestamp_ns=0),
            self.keyboard.sample(MockInput(attack=True), tick_id=1, timestamp_ns=1),
        ]
        with TemporaryDirectory() as directory:
            path = Path(directory) / "controls.jsonl"
            write_control_jsonl(path, records)
            replay = ReplayControlAdapter.from_jsonl(path)

            replayed = replay.read(tick_id=1, timestamp_ns=123)

        self.assertEqual(ControlSource.REPLAY, replayed.gesture_source)
        self.assertEqual(ControlSource.REPLAY, replayed.voice_source)
        self.assertEqual(123, replayed.timestamp_ns)
        self.assertTrue(replayed.high_voice_event)


if __name__ == "__main__":
    unittest.main()