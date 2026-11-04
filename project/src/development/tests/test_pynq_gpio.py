import unittest

from pynq_multimodal_game.controls import Direction
from pynq_multimodal_game.pynq_gpio import (
    BTN0_MASK,
    BTN2_MASK,
    SW0_MASK,
    SW1_MASK,
    PynqButtonAdapter,
)


class PynqButtonAdapterTests(unittest.TestCase):
    def test_debounces_and_maps_buttons_switches_and_edges(self) -> None:
        samples = iter((BTN0_MASK, 0, BTN0_MASK, BTN0_MASK, BTN0_MASK | SW1_MASK, BTN0_MASK | SW1_MASK, BTN2_MASK | SW0_MASK, BTN2_MASK | SW0_MASK, SW0_MASK, SW0_MASK))
        adapter = PynqButtonAdapter(lambda: next(samples))

        adapter.sample()
        adapter.sample()
        adapter.sample()
        adapter.sample()
        left = adapter.read(tick_id=0, timestamp_ns=0)
        adapter.sample()
        adapter.sample()
        up = adapter.read(tick_id=1, timestamp_ns=1)
        adapter.sample()
        adapter.sample()
        jump_and_shield = adapter.read(tick_id=2, timestamp_ns=2)
        adapter.sample()
        adapter.sample()
        shield_only = adapter.read(tick_id=3, timestamp_ns=3)

        self.assertEqual(Direction.LEFT, left.direction)
        self.assertEqual(Direction.UP, up.direction)
        self.assertTrue(jump_and_shield.fist_event)
        self.assertTrue(jump_and_shield.low_voice_active)
        self.assertFalse(shield_only.fist_event)
        self.assertTrue(shield_only.low_voice_active)


if __name__ == "__main__":
    unittest.main()