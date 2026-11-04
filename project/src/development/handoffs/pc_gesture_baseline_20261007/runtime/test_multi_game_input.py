from pathlib import Path
from types import SimpleNamespace

import pytest

from four_way_input import FourWayVisionInputProvider
from multi_game_input import (ClassifiedController, MultiGameVisionInputProvider,
                             install_classification, install_game_routing)
from pynq_multimodal_game.game_sdk import HandGesture
from handoffs.gesture_vision_v61.runtime.gesture_control import GestureControl


def packet(frame=1, stable='5', rps='PAPER', direction='IDLE', seq=0,
           action=False, valid=True, age=0, run='live'):
    return {'run_id': run, 'server_age_ms': age, 'control': {
        'schema': 'gesture-control-v1', 'frame_id': frame,
        'valid': valid, 'direction': direction, 'action_event_seq': seq,
        'action_event': action, 'action_kind': 'HEURISTIC_OPEN_TO_FIST',
        'stable_gesture': stable, 'rps_gesture': rps}}


@pytest.mark.parametrize('stable,rps,gesture', [
    ('0', 'ROCK', HandGesture.FIST), ('2', 'SCISSORS', HandGesture.SCISSORS),
    ('5', 'PAPER', HandGesture.PAPER), ('PENDING', 'UNKNOWN', None),
    ('NO_HAND', 'UNKNOWN', None), ('5', 'ROCK', None), ([], 'PAPER', None)])
def test_stable_rps_and_idempotent_sampling(stable, rps, gesture):
    p = MultiGameVisionInputProvider(clock=lambda: 1.)
    p.publish(packet(stable=stable, rps=rps, direction='LEFT'))
    sample, receipt = p.sample_for_game('game2', tick_id=0)
    assert sample.hand_gesture is gesture
    assert sample.hand_x == sample.hand_y == 0
    assert not sample.fist_event
    assert receipt['control_mapping'] == 'STABLE_RPS'
    assert not p.sample_for_game('game2', tick_id=1)[0].gesture_changed


def test_duplicate_and_out_of_order_do_not_replace_classification():
    p = MultiGameVisionInputProvider(clock=lambda: 1.)
    p.publish(packet(frame=2))
    p.publish(packet(frame=2, stable='0', rps='ROCK'))
    p.publish(packet(frame=1, stable='2', rps='SCISSORS'))
    sample, receipt = p.sample_for_game('game2', tick_id=0)
    assert sample.hand_gesture is HandGesture.PAPER
    assert receipt['source_frame_id'] == 2


def test_unknown_new_frame_does_not_hold_previous_rps():
    p = MultiGameVisionInputProvider(clock=lambda: 1.)
    p.publish(packet())
    assert p.sample_for_game('game2', tick_id=0)[0].hand_gesture is HandGesture.PAPER
    p.publish(packet(frame=2, stable='PENDING', rps='UNKNOWN'))
    sample, _ = p.sample_for_game('game2', tick_id=1)
    assert sample.hand_gesture is None and sample.gesture_changed


def test_stale_pause_resume_stop_epoch_and_run_are_gated():
    now = [1.]
    p = MultiGameVisionInputProvider(clock=lambda: now[0])
    def neutral():
        sample, _ = p.sample_for_game('game2', tick_id=0)
        assert sample.hand_gesture is None and not sample.fist_event
    p.publish(packet())
    now[0] += 1.21
    neutral()
    p.publish(packet(frame=2, age=1201))
    neutral()
    p.publish(packet(frame=3))
    p.suspend()
    p.publish(packet(frame=4))
    neutral()
    p.resume()
    neutral()
    p.publish(packet(frame=5))
    assert p.sample_for_game('game2', tick_id=0)[0].hand_gesture is HandGesture.PAPER
    p.release()
    neutral()
    p.publish(packet(frame=6, valid=False))
    neutral()
    p.publish(packet(run='next', stable='2', rps='SCISSORS'))
    assert p.sample_for_game('game2', tick_id=0)[0].hand_gesture is HandGesture.SCISSORS
    p.publish(packet(stable='0', rps='ROCK'), config_epoch='new')
    assert p.sample_for_game('game2', tick_id=0)[0].hand_gesture is HandGesture.FIST


@pytest.mark.parametrize('game', ['game1', 'game3', 'other'])
def test_game1_and_game3_samples_equal_v6_even_with_pending_jump(game):
    old = FourWayVisionInputProvider(clock=lambda: 1.)
    new = MultiGameVisionInputProvider(clock=lambda: 1.)
    for tick, msg in enumerate((packet(direction='UP'),
            packet(frame=2, stable='0', rps='ROCK', direction='RIGHT', seq=1, action=True),
            packet(frame=3, direction='DOWN', seq=1),
            packet(frame=4, valid=False, seq=1))):
        old.publish(msg)
        new.publish(msg)
        assert old.sample(tick_id=tick) == new.sample_for_game(game, tick_id=tick)[0]


def test_controller_carries_exact_same_frame_without_changing_gates():
    original = GestureControl()
    wrapped = ClassifiedController(GestureControl())
    for frame, stable in enumerate(('5', '2', '0', 'PENDING', 'NO_HAND'), 1):
        observed = {'centroid': None if stable == 'NO_HAND' else [319, 179],
                    'code': stable, 'stable': stable,
                    'rps': {'5': 'PAPER', '2': 'SCISSORS', '0': 'ROCK'}.get(stable, 'UNKNOWN')}
        expected = original.update(observed, frame, frame * .2)
        actual = wrapped.update(observed, frame, frame * .2)
        assert all(actual[k] == v for k, v in expected.items())
        assert actual['frame_id'] == frame


def test_worker_wraps_controller_before_provider_publication():
    class Worker:
        def __init__(self, hardware, recognizer, controller, provider, **kwargs):
            self.controller = controller
            self.provider = provider
    runtime = SimpleNamespace(SharedVisionWorker=Worker)
    install_classification(runtime)
    installed = runtime.SharedVisionWorker
    install_classification(runtime)
    assert runtime.SharedVisionWorker is installed
    p = MultiGameVisionInputProvider(clock=lambda: 1.)
    worker = installed(None, None, GestureControl(), p, run_id='live')
    control = worker.controller.update({'centroid': [319, 179], 'code': '2',
                                        'stable': '2', 'rps': 'SCISSORS'}, 1, 1.)
    worker.provider.publish({'run_id': 'live', 'server_age_ms': 0, 'control': control})
    assert p.sample_for_game('game2', tick_id=0)[0].hand_gesture is HandGesture.SCISSORS


def test_game2_real_package_reaches_reveal_from_local_classifier(tmp_path):
    from pynq_multimodal_game.game_package import GamePackageBuilder
    from pynq_multimodal_game.game_runner import GameRunner
    root = Path(__file__).resolve().parents[2]
    package = GamePackageBuilder().build(root / 'games/game2', tmp_path / 'rps.vvg',
                                        target_build_id=0xC0060800)
    now = [1.]
    p = MultiGameVisionInputProvider(clock=lambda: now[0])
    controller = ClassifiedController(GestureControl())
    with GameRunner(package.path, render_rgb=False) as runner:
        for tick in range(210):
            now[0] += 1 / 60
            # Classifier runs at ~5 Hz; the game samples a fresh held label at 60 Hz.
            if tick % 12 == 0:
                stable, rps = ('5', 'PAPER') if tick < 190 else ('2', 'SCISSORS')
                control = controller.update({'centroid': [319, 179], 'code': stable,
                    'stable': stable, 'rps': rps}, tick // 12 + 1, now[0])
                p.publish({'run_id': 'live', 'server_age_ms': 0, 'control': control})
            sample, _ = p.sample_for_game('game2', tick_id=tick)
            frame = runner.step(sample)
        assert frame.snapshot.values['phase'] == 'REVEAL'
        assert frame.snapshot.values['human_locked'] == 'scissors'


def test_game3_actual_selection_confirmation_move_and_jump():
    from games.game3.src.main import Game
    game = Game()
    now = [1.]
    p = MultiGameVisionInputProvider(clock=lambda: now[0])
    controller = ClassifiedController(GestureControl())
    snapshots = []
    for tick, stable in enumerate(('5', '5', '0', '5', '0', '0')):
        now[0] += .2
        control = controller.update({'centroid': [540, 179], 'code': stable,
            'stable': stable, 'rps': {'5': 'PAPER', '0': 'ROCK'}[stable]}, tick + 1, now[0])
        p.publish({'run_id': 'live', 'server_age_ms': 0, 'control': control})
        snapshots.append(game.step(p.sample_for_game('game3', tick_id=tick)[0]))
    assert snapshots[0].status == 'SELECT'
    assert snapshots[0].values['character'] == 'female'
    assert snapshots[2].status == 'RUNNING' and snapshots[2].values['vy'] == 0
    assert snapshots[4].values['vy'] < 0 and snapshots[4].values['x'] > snapshots[2].values['x']


def test_routing_uses_validated_manifest_not_ui_and_preserves_playback(monkeypatch):
    from pynq_multimodal_game.agent import c6i_shell, game_runtime
    from pynq_multimodal_game import game_package
    class Runtime:
        def __init__(self, package, sink, **kwargs):
            self._live_input = kwargs.get('live_input')
        def _sample_live_input(self, tick):
            return 'legacy', tick
    monkeypatch.setattr(game_runtime, 'PackagedGameRuntime', Runtime)
    monkeypatch.setattr(c6i_shell, 'PackagedGameRuntime', Runtime)
    monkeypatch.setattr(game_package, 'validate_game_package', lambda *a, **k:
                        SimpleNamespace(manifest=SimpleNamespace(game_id='game2')))
    install_game_routing()
    assert c6i_shell.PackagedGameRuntime is game_runtime.PackagedGameRuntime
    provider = MultiGameVisionInputProvider(clock=lambda: 1.)
    provider.publish(packet())
    runtime = c6i_shell.PackagedGameRuntime('package', None, live_input=provider)
    sample, receipt = runtime._sample_live_input(0)
    assert sample.hand_gesture is HandGesture.PAPER and receipt['game_id'] == 'game2'
    assert c6i_shell.PackagedGameRuntime('package', None)._sample_live_input(1) == ('legacy', 1)


@pytest.mark.parametrize('game_id', ['game2', 'game3'])
def test_real_spawn_runtime_routes_first_frame_and_receipt(tmp_path, monkeypatch, game_id):
    from pynq_multimodal_game.agent import c6i_shell, game_runtime
    from pynq_multimodal_game.game_package import GamePackageBuilder
    # Restore original class references after each test, including installation.
    monkeypatch.setattr(c6i_shell, 'PackagedGameRuntime', c6i_shell.PackagedGameRuntime)
    monkeypatch.setattr(game_runtime, 'PackagedGameRuntime', game_runtime.PackagedGameRuntime)
    install_game_routing()
    root = Path(__file__).resolve().parents[2]
    package = GamePackageBuilder().build(root / 'games' / game_id, tmp_path / 'live.vvg',
                                        target_build_id=0xC0060800)
    class Sink:
        def upload_palette(self, packet):
            pass
        def upload_asset(self, packet):
            pass
        def upload_tilemap(self, packet):
            pass
        def submit_scene(self, packet):
            pass
    p = MultiGameVisionInputProvider(clock=lambda: 1.)
    p.publish(packet(direction='RIGHT'))
    runtime = c6i_shell.PackagedGameRuntime(package.path, Sink(), live_input=p)
    try:
        runtime.start()
        runtime.pause()
        assert runtime.last_error is None
        assert runtime.vision_consumption['game_id'] == game_id
        if game_id == 'game2':
            assert runtime.last_frame.snapshot.values['human_live'] == 'paper'
            assert runtime.vision_consumption['hand_gesture'] == 'paper'
        else:
            assert runtime.last_frame.snapshot.values['character'] == 'female'
            assert runtime.last_frame.snapshot.status == 'SELECT'
    finally:
        runtime.stop()
