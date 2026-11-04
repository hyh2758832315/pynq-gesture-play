"""Offline checks for button edges, hand-only OSD writes, and game effects.

Run: .venv/Scripts/python.exe -B subprojects/button_only/verify_button_shared.py
Output: D:/vvg_button_shared_package_stage/button_offline_receipt.json.
Next: compare against full Vivado route/DRC, then perform board admission.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

STAGE = Path("D:/vvg_button_shared_package_stage")
sys.path.insert(0, str(STAGE / "python"))

from pynq_multimodal_game.button_input import ButtonGameInputProvider, ButtonSampler
from pynq_multimodal_game.button_osd import HandObservation, HandOsdPublisher
from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_sdk import ButtonSignal, GameInput


class Registers:
    def __init__(self):
        self.words = {0: 0x4F534401, 4: 0}

    def read(self, offset):
        return self.words.get(offset, 0)

    def write(self, offset, value):
        self.words[offset] = value


def sample(tick, button=None):
    return GameInput(tick, tick * 1_000_000_000 // 60, False, 0, 0, 0, False, button=button)


def main():
    assert ButtonSignal("BTN0", 1).kind == "BTN0"
    class ButtonRegisters:
        def read(self, offset):
            assert offset == 8, "button reads must use BUILD_ID GPIO channel 2"
            return 3
    assert ButtonSampler(ButtonRegisters())._read_bits() == 3
    sampler = ButtonSampler(Registers())
    sampler._stable = sampler._candidate = 0
    sampler._candidate_count = 0
    for raw in (1, 0, 1, 1):
        sampler._accept_sample(raw)
    assert sampler.consume() is None, "switch bounce emitted an event"
    sampler._accept_sample(1)
    assert sampler.consume() == ButtonSignal("BTN0", 1)
    for _ in range(8):
        sampler._accept_sample(1)
    assert sampler.consume() is None, "held button repeated"
    for _ in range(3):
        sampler._accept_sample(0)
    for _ in range(3):
        sampler._accept_sample(3)
    assert sampler.consume() == ButtonSignal("BTN0", 2)
    assert sampler.consume() == ButtonSignal("BTN1", 3)
    assert sampler.consume() is None
    class Visual:
        capabilities = {"schema": "test-vision"}
        def sample_for_game(self, game_id, *, tick_id, timestamp_ns=None):
            return sample(tick_id), {"game_id": game_id}
        def suspend(self): pass
        def resume(self): pass
        def release(self, message): pass
        def sample_menu_control(self, *, tick_id): return tick_id
    class Manifest:
        game_id = "game1-button-v1"
    provider = ButtonGameInputProvider(Visual(), sampler).new_game_session(Manifest(), "test")
    for _ in range(3):
        sampler._accept_sample(0)
    for _ in range(3):
        sampler._accept_sample(1)
    delivered, visual_receipt = provider.sample_current_for_game("game1-button-v1", tick_id=5)
    assert delivered.button == ButtonSignal("BTN0", 4)
    assert visual_receipt["button"] == {"kind": "BTN0", "sequence": 4}
    assert provider.sample_menu_control(tick_id=6) == 6

    registers = Registers()
    publisher = HandOsdPublisher(registers)
    hand = HandObservation("test", 1, 1_000_000_000, 0.0, 0.0, True, True)
    assert publisher.tick(hand, now_ns=1_100_000_000)
    assert registers.words[0x10] & 7 == 7
    assert registers.words[0x18] == 0
    assert registers.words[0x1C] & 0xFFFF == 0
    assert registers.words[0x24] == 0
    assert publisher.tick(None, now_ns=1_251_000_000)
    assert registers.words[0x10] & 6 == 0, "stale hand remained visible"

    game1 = STAGE / "games/button-only/game1-button-v1.vvg"
    with GameRunner(game1, render_rgb=False) as runner:
        events = {0: ButtonSignal("BTN0", 1), 1: ButtonSignal("BTN1", 2),
                  2: ButtonSignal("BTN1", 2), 37: ButtonSignal("BTN1", 3)}
        frames = [runner.step(sample(tick, events.get(tick))).snapshot for tick in range(38)]
    assert all(frame.values["shield_active"] for frame in frames[:36])
    assert not frames[36].values["shield_active"]
    assert frames[1].values["attacks_fired"] == frames[2].values["attacks_fired"] == 1
    assert frames[37].values["attacks_fired"] == 2

    game3 = STAGE / "games/button-only/game3-button-v1.vvg"
    with GameRunner(game3, render_rgb=False) as runner:
        chosen = runner.step(GameInput(0, 0, True, -1, 0, 1, True)).snapshot
        frame = runner.step(sample(1, ButtonSignal("BTN0", 1))).snapshot
    assert chosen.values["character"] == "male"
    assert frame.values["button_event_kind"] == "BTN0"
    receipt = {"button_channel_2": "PASS", "debounce": "PASS", "held_button": "PASS", "simultaneous": "PASS",
               "provider_delivery": "PASS",
               "hand_osd_audio_words_zero": "PASS", "game1_button_effects": "PASS",
               "game3_button_input": "PASS", "board_access": False}
    target = STAGE / "button_offline_receipt.json"
    target.write_text(json.dumps(receipt, indent=2) + "\n")
    print(json.dumps(receipt, indent=2))


if __name__ == "__main__":
    main()
