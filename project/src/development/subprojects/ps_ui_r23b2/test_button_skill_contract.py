"""Real packaged game effects and physical-button delivery, entirely offline.

Run with PYTHONPATH=subprojects/ps_ui_r23b2/python;.:
  .venv/Scripts/python.exe -B -m pytest -q this_file
Output: pytest assertions. Next: verify the paired package on PYNQ/HDMI.
"""
from dataclasses import replace
from types import SimpleNamespace
from pathlib import Path

import pytest

from pynq_multimodal_game.button_input import ButtonSampler, ButtonGameInputProvider
from pynq_multimodal_game.game_sdk import ButtonSignal, GameInput, HandGesture
from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_testing import GameTestCase, InputKind
from pynq_multimodal_game.game_validation import GameTestPlayback
from pynq_multimodal_game.vision_input import GameVisionInputProvider
from subprojects.ps_ui_r23b2.test_pause_closure import game_root
from subprojects.ps_ui_r23b2.test_latest_vision_order import packet


def sample(tick, gesture=None, button=None):
    return GameInput(tick, tick*1_000_000_000//60, gesture is not None,
                     0., 0., 0, False, hand_gesture=gesture,
                     gesture_sequence=tick, gesture_changed=True, button=button)


def sampler():
    value = ButtonSampler(None)
    value._stable = value._candidate = value._candidate_count = 0
    return value


def press(value, bits):
    for _ in range(3):
        value._accept_sample(bits)


@pytest.mark.parametrize('game_id', ['game1', 'game3'])
def test_current_menu_game_ids_receive_debounced_buttons_once(game_id):
    buttons = sampler()
    visual = GameVisionInputProvider(clock=lambda: 100.)
    provider = ButtonGameInputProvider(visual, buttons).new_game_session(
        SimpleNamespace(game_id=game_id), 'run')
    press(buttons, 3)
    assert provider.sample_for_game(game_id, tick_id=0)[0].button == ButtonSignal('BTN0', 1)
    assert provider.sample_for_game(game_id, tick_id=1)[0].button == ButtonSignal('BTN1', 2)
    press(buttons, 3)
    assert provider.sample_for_game(game_id, tick_id=2)[0].button is None
    press(buttons, 0)
    press(buttons, 1)
    provider.suspend()
    provider.resume()
    assert provider.sample_for_game(game_id, tick_id=3)[0].button is None


def test_game1_gesture_changes_and_unknown_flicker_never_trigger_skills(game_root):
    with GameRunner(game_root/'seed_games/game1.vvg', render_rgb=False) as runner:
        for tick in range(90):
            gesture = (HandGesture.PAPER, HandGesture.SCISSORS, None)[tick%3]
            result = runner.step(sample(tick, gesture)).snapshot.values
            assert not result['shield_active']
            assert result['attacks_fired'] == 0


def test_game1_real_button_provider_to_packaged_effects_without_visible_hand(game_root):
    buttons = sampler()
    visual = GameVisionInputProvider(clock=lambda: 100.)
    provider = ButtonGameInputProvider(visual, buttons).new_game_session(
        SimpleNamespace(game_id='game1'), 'run')
    frames = []
    with GameRunner(game_root/'seed_games/game1.vvg', render_rgb=False) as runner:
        for tick in range(39):
            if tick == 0:
                press(buttons, 3)
            if tick == 37:
                press(buttons, 0)
                press(buttons, 2)
            value, receipt = provider.sample_for_game('game1', tick_id=tick)
            frames.append(runner.step(value).snapshot.values)
    assert all(frame['shield_active'] for frame in frames[:36])
    assert not frames[36]['shield_active']
    assert frames[1]['attacks_fired'] == frames[36]['attacks_fired'] == 1
    assert frames[37]['attacks_fired'] == 2


def test_game1_replayed_button_sequence_does_not_attack_again(game_root):
    with GameRunner(game_root/'seed_games/game1.vvg', render_rgb=False) as runner:
        for tick in range(65):
            signal = ButtonSignal('BTN1', 1) if tick in (0, 32, 64) else None
            state = runner.step(sample(tick, button=signal)).snapshot.values
        assert state['attacks_fired'] == 1


@pytest.mark.parametrize('target,kind', [('note', 'BTN1'), ('lift', 'BTN0')])
def test_game3_mechanisms_require_the_matching_button(game_root, target, kind):
    with GameRunner(game_root/'seed_games/game3.vvg', render_rgb=False) as runner:
        # Deterministic placement isolates the actual mechanism rules; no board.
        runner.step(replace(sample(0, HandGesture.FIST), hand_x=-1., fist_event=True))
        game = runner._plugin._game
        level = __import__(game.__class__.__module__.rsplit('.', 1)[0]+'.level', fromlist=['SCALE'])
        game.x = (level.NOTE_X if target == 'note' else level.LIFT_X)*level.SCALE
        game.y = 112*level.SCALE
        game.vx = game.vy = 0
        for tick in range(1, 10):
            runner.step(sample(tick, HandGesture.SCISSORS if tick < 9 else HandGesture.PAPER))
        assert not game.gate_open
        assert getattr(game, 'lift_phase', 'IDLE') == 'IDLE'
        runner.step(sample(10, button=ButtonSignal(kind, 1)))
        assert game.gate_open if target == 'note' else game.lift_phase == 'RISING'


def test_game3_button_mechanisms_preserve_full_level_completion(game_root):
    root = Path(__file__).resolve().parents[2]
    original = GameTestCase.load(root/'games/game3/tests/replays/kingdom-01-princess-win.json')
    case = replace(original, events=tuple(e for e in original.events if e.kind is not InputKind.TONE))
    playback = GameTestPlayback(case, tick_hz=60)
    with GameRunner(game_root/'seed_games/game3.vvg', render_rgb=False) as runner:
        for tick in range(801):
            signal = {341: ButtonSignal('BTN1', 1), 482: ButtonSignal('BTN0', 2)}.get(tick)
            frame = runner.step(replace(playback.input_at(tick), button=signal))
            for assertion in case.assertions_at(tick):
                passed, actual = assertion.evaluate(frame.snapshot)
                assert passed, (tick, assertion.field, actual)


def test_live_runtime_rejects_test_input_before_side_effects():
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    # Exercise the real public guards without creating a worker or socket.
    runtime = PackagedGameRuntime.__new__(PackagedGameRuntime)
    runtime._thread = None
    runtime._live_input = object()
    with pytest.raises(RuntimeError, match='separate runtimes'):
        runtime.load_test_case(None)
    with pytest.raises(RuntimeError, match='does not accept test injection'):
        runtime.inject_test_input(x=100, gesture='scissors')
