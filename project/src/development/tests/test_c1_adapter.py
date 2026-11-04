from pynq_multimodal_game.c1_adapter import C1GameInputAdapter
from pynq_multimodal_game.controls import Direction
from pynq_multimodal_game.game_sdk import GameInput, ToneSignal


def game_input(
    tick: int,
    *,
    x: float = 0.0,
    y: float = 0.0,
    fist: bool = False,
    tone: ToneSignal | None = None,
) -> GameInput:
    return GameInput(
        tick_id=tick,
        timestamp_ns=tick * 16_666_667,
        hand_valid=True,
        hand_x=x,
        hand_y=y,
        fist_sequence=1 if fist else 0,
        fist_event=fist,
        tone=tone,
    )


def test_c1_adapter_maps_dominant_hand_axis_and_deadzone() -> None:
    adapter = C1GameInputAdapter()

    assert adapter.adapt(game_input(0, x=0.2)).direction is Direction.IDLE
    assert adapter.adapt(game_input(1, x=-0.8, y=0.4)).direction is Direction.LEFT
    assert adapter.adapt(game_input(2, x=0.4, y=-0.9)).direction is Direction.UP


def test_c1_adapter_maps_fist_edge_to_jump() -> None:
    control = C1GameInputAdapter().adapt(game_input(0, fist=True))

    assert control.fist_event is True
    assert control.fist_score == 1.0
    assert control.gesture_seq == 1


def test_c1_adapter_maps_low_tone_to_shield() -> None:
    tone = ToneSignal(sequence=1, frequency_hz=220.0, active=True, started=True)
    control = C1GameInputAdapter().adapt(game_input(0, tone=tone))

    assert control.low_voice_active is True
    assert control.high_voice_event is False


def test_c1_adapter_preserves_shield_on_high_attack_edge() -> None:
    adapter = C1GameInputAdapter()
    adapter.adapt(
        game_input(
            0,
            tone=ToneSignal(sequence=1, frequency_hz=220.0, active=True, started=True),
        )
    )

    attack = adapter.adapt(
        game_input(
            1,
            tone=ToneSignal(sequence=2, frequency_hz=1200.0, active=True, started=True),
        )
    )
    sustained_high = adapter.adapt(
        game_input(
            2,
            tone=ToneSignal(sequence=2, frequency_hz=1200.0, active=True),
        )
    )

    assert attack.low_voice_active is True
    assert attack.high_voice_event is True
    assert sustained_high.low_voice_active is False
    assert sustained_high.high_voice_event is False