from pynq_multimodal_game.game_sdk import GameInput, HandGesture


def player_gesture(game_input: GameInput) -> HandGesture | None:
    return game_input.hand_gesture if game_input.hand_valid else None