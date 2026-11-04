from dataclasses import dataclass

from pynq_multimodal_game.game_sdk import GameInput, HandGesture, ToneSignal


@dataclass(frozen=True)
class Command:
    direction: int = 0
    jump: bool = False
    tone: ToneSignal | None = None
    jump_held: bool = False


def adapt(game_input: GameInput) -> Command:
    direction = 0
    if game_input.hand_valid:
        if game_input.hand_x < -0.35:
            direction = -1
        elif game_input.hand_x > 0.35:
            direction = 1
    return Command(direction, game_input.hand_valid and game_input.fist_event, game_input.tone,
                   game_input.hand_valid and game_input.hand_gesture is HandGesture.FIST)