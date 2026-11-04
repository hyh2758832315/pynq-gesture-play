import argparse
import ast
import hashlib
import json
import os
from pathlib import Path
import runpy
import subprocess
import sys
import threading
import time
import zipfile


HERE = Path(__file__).resolve().parent
REPO = HERE.parents[3]
PARENT = REPO / 'deliveries/c6i-vision-volume-c0c-r14-autonomous-20261022.zip'
PARENT_SHA = 'b20019eb06b5b8df4483b4735529456293bb60fe80ea63812785025c5795941b'
OUTPUT = REPO / 'deliveries/c6i-vision-volume-c0c-r15-unified-input-20261022-r2'
GAMES = REPO / 'deliveries/c6i-unified-input-games-20261022-r2'


def save(path, value):
    with path.open('x', encoding='utf-8') as stream:
        json.dump(value, stream, indent=2)


def game1_hold():
    from pynq_multimodal_game.game_sdk import HandGesture
    from pynq_multimodal_game.game_testing import AssertionOperator, AssertionRule, GameTestCase, InputEvent, InputKind
    builder = runpy.run_path(str(REPO / 'candidates/volume-v1/build.py'))
    return GameTestCase('game1-hold-volume', 'Held fist and independent volume input', seed=17, max_ticks=59,
        schema_version=4, events=(InputEvent(0, InputKind.GESTURE, event_id='hold', x=160, y=90, gesture=HandGesture.FIST),
                                 builder['volume_event'](0, 1, 'SOFT'), builder['volume_event'](1, 2, 'LOUD'),
                                 InputEvent(40, InputKind.GESTURE, event_id='release', x=160, y=90, gesture=HandGesture.PAPER)),
        assertions=(AssertionRule(0, 'values.z', AssertionOperator('gt'), 0),
                    AssertionRule(0, 'values.shield_active', AssertionOperator.EQUAL, True),
                    AssertionRule(1, 'values.attacks_fired', AssertionOperator.EQUAL, 1),
                    AssertionRule(20, 'values.z', AssertionOperator('gt'), 0)))


def build_games():
    from pynq_multimodal_game.game_package import GamePackageBuilder
    from pynq_multimodal_game.game_runner import GameRunner
    from pynq_multimodal_game.game_sdk import GameInput
    from pynq_multimodal_game.game_testing import GameTestCase
    from pynq_multimodal_game.game_validation import build_verified_game, run_game_test
    builder = runpy.run_path(str(REPO / 'candidates/volume-v1/build.py'))
    hold = runpy.run_path(str(HERE.parent / 'round14/f138_game3_hold.py'))['hold_case']
    GAMES.mkdir()
    cases = []
    packages = {}
    for game_id in ('game1', 'game3'):
        project = builder['stage_project'](game_id, GAMES / (game_id + '-volume-v1'))
        probe = GamePackageBuilder().build(project, GAMES / (game_id + '-probe.vvg'))
        game_cases = ([builder['shield_case'](), game1_hold()] if game_id == 'game1' else
                      [builder['platform_case'](probe.path, character) for character in ('male', 'female')] + [hold()])
        replay = project / 'tests/replays'
        replay.mkdir(parents=True)
        for case in game_cases:
            case.save(replay / (case.test_id + '.json'))
        package = build_verified_game(project, GAMES / (game_id + '-volume-v1.vvg'))
        packages[game_id + '-volume-v1.vvg'] = package.sha256
        cases.extend((package.path, case) for case in game_cases)
    parent = REPO / 'deliveries/c6i-vision-volume-c0c-r14-autonomous-20261022'
    for game_id, case_name in (('game1', 'c1-golden.json'), ('game3', 'game3-golden.json')):
        package = build_verified_game(REPO / 'games' / game_id, GAMES / (game_id + '-C0060E00.vvg'),
                                      target_build_id=0xC0060E00)
        packages[package.path.name] = package.sha256
        cases.append((package.path, GameTestCase.load(parent / 'games' / case_name)))
    cases.append((parent / 'games/game2-C0060E00.vvg', GameTestCase.load(parent / 'games/game2-golden.json')))
    records = []
    for package, case in cases:
        report = run_game_test(package, case)
        report.save(GAMES / (case.test_id + '.pc-report.json'))
        assert report.passed, report.to_dict()
        with GameRunner(package, render_rgb=False) as runner:
            first = runner.step(GameInput(0, 0, False, 0, 0, 0, False))
            assert first.asset_packet and len(first.asset_packet) <= 32880
        case.save(GAMES / (case.test_id + '.json'))
        records.append({'package': package.name, 'test_id': case.test_id, 'ticks': len(report.frames),
                        'asset_packet_bytes': len(first.asset_packet)})
        print('UNIFIED_PC_PASS ' + case.test_id, flush=True)
    save(GAMES / 'verification.json', {'packages': packages, 'cases': records, 'status': 'DOUBLE_BUILD_PC_PASS'})


def export():
    helper = runpy.run_path(str(REPO / 'results/game-validation/vision-v0-offline-20261019/workflow.py'))
    manifest, contents = helper['checked_archive'](PARENT, PARENT_SHA)
    original = dict(contents)
    changed = ['python/pynq_multimodal_game/vision_input.py', 'python/pynq_multimodal_game/volume_input.py']
    for name in changed:
        contents[name] = (REPO / name).read_bytes()
    runtime = [name for name in contents if name.startswith(('python/pynq_multimodal_game/', 'board/pynq_z2/scripts/'))
               and (REPO / name).is_file()]
    for name in runtime:
        assert contents[name] == (REPO / name).read_bytes(), 'Undeclared runtime difference: ' + name
    games = json.loads((GAMES / 'verification.json').read_text(encoding='utf-8'))
    for name, expected in games['packages'].items():
        data = (GAMES / name).read_bytes()
        assert hashlib.sha256(data).hexdigest().lower() == expected.lower()
        contents['games/' + name] = data
    for entry in games['cases']:
        for suffix in ('.json', '.pc-report.json'):
            name = entry['test_id'] + suffix
            contents['games/unified/' + name] = (GAMES / name).read_bytes()
    contents['games/unified/verification.json'] = (GAMES / 'verification.json').read_bytes()
    contents['tools/unified_input_validation.py'] = Path(__file__).read_bytes()
    contents['docs/bringup/2026-10-22_vision_volume_fusion.md'] = (REPO / 'docs/bringup/2026-10-22_vision_volume_fusion.md').read_bytes()
    for name in ('tests/test_vision_receiver.py', 'tests/test_multimodal_input.py', 'tests/test_volume_monitor.py'):
        contents[name] = (REPO / name).read_bytes()
    hardware = [name for name in original if name.startswith('overlay/')]
    assert all(contents[name] == original[name] for name in hardware)
    for name, data in contents.items():
        if name.endswith('.py'):
            ast.parse(data.decode('utf-8-sig'), filename=name, feature_version=(3, 10))
    manifest.update(parent_archive_sha256=PARENT_SHA, purpose='unified-raw-gesture-and-volume-input',
                    release_ready=False, board_pending=True,
                    sha256={name: hashlib.sha256(data).hexdigest().upper() for name, data in contents.items()
                            if name != 'deployment_manifest.json'})
    contents['deployment_manifest.json'] = (json.dumps(manifest, indent=2) + '\n').encode()
    OUTPUT.mkdir()
    for name, data in contents.items():
        path = (OUTPUT / name).resolve()
        assert path.is_relative_to(OUTPUT)
        path.parent.mkdir(parents=True, exist_ok=True)
        with path.open('xb') as stream:
            stream.write(data)
    with zipfile.ZipFile(OUTPUT.with_suffix('.zip'), 'x', compression=zipfile.ZIP_DEFLATED) as archive:
        for name in sorted(contents):
            archive.write(OUTPUT / name, OUTPUT.name + '/' + name)
    digest = hashlib.sha256(OUTPUT.with_suffix('.zip').read_bytes()).hexdigest()
    restored_manifest, restored = helper['checked_archive'](OUTPUT.with_suffix('.zip'), digest)
    assert restored == contents and restored_manifest == manifest
    save(HERE / 'f153-export.json', {'status': 'EXPORTED', 'sha256': digest, 'runtime_matches': len(runtime),
         'unchanged_hardware': len(hardware), 'files': len(contents), 'hardware_access': False})
    print('UNIFIED_EXPORT_PASS ' + digest, flush=True)


def contract(root):
    from pynq_multimodal_game.game_runner import GameRunner
    from pynq_multimodal_game.game_sdk import HandGesture
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    import pynq_multimodal_game.vision_input as implementation
    assert Path(implementation.__file__).resolve().is_relative_to(root.resolve())
    for game_id in ('game1', 'game2', 'game3', 'future-game'):
        now = [1.0]
        provider = GameVisionInputProvider(clock=lambda: now[0])
        provider.publish({'run_id': 'raw', 'server_age_ms': 0, 'frame': 1, 'stable': '0', 'rps': 'ROCK',
                          'control': {'schema': 'gesture-control-v1', 'frame_id': 1, 'action_event_seq': 0,
                                      'action_event': False, 'valid': True, 'direction': 'UP'}})
        sample, receipt = provider.sample_for_game(game_id, tick_id=0)
        assert sample.hand_gesture is HandGesture.FIST and sample.hand_y == -1 and sample.fist_event
        sample, receipt = provider.sample_for_game(game_id, tick_id=1)
        assert sample.hand_gesture is HandGesture.FIST and not sample.fist_event
        assert receipt['source_hand_gesture'] == receipt['hand_gesture'] == 'fist'
        now[0] += 1.21
        assert not provider.sample(tick_id=2).hand_valid
    for game_id in ('game1', 'game3'):
        now = [1.0]
        provider = GameVisionInputProvider(clock=lambda: now[0])
        launches = 0
        previous = None
        with GameRunner(root / 'games' / (game_id + '-volume-v1.vvg'), render_rgb=False) as runner:
            for tick in range(141 if game_id == 'game3' else 60):
                now[0] += .05
                provider.publish({'run_id': 'raw-loop', 'server_age_ms': 0, 'frame': tick + 1,
                                  'stable': '0', 'rps': 'ROCK', 'control': {'schema': 'gesture-control-v1',
                                  'frame_id': tick + 1, 'action_event_seq': 0, 'action_event': False,
                                  'valid': True, 'direction': 'IDLE'}})
                if tick == 0:
                    provider.sample_for_game(game_id, tick_id=0)
                sample, receipt = provider.sample_for_game(game_id, tick_id=tick)
                assert sample.hand_gesture is HandGesture.FIST and not sample.fist_event
                frame = runner.step(sample)
                values = frame.snapshot.values
                if game_id == 'game3':
                    assert frame.snapshot.status == 'RUNNING'
                    if tick == 0:
                        assert values['vy'] == 0
                    elif previous['grounded'] and values['vy'] < 0:
                        launches += 1
                elif values['z'] > 0 and (previous is None or previous['z'] == 0):
                    launches += 1
                previous = values
        assert launches >= 2, (game_id, launches)
        print('UNIFIED_PROVIDER_GAME_PASS ' + game_id + ' launches=' + str(launches), flush=True)
    print('UNIFIED_RUNTIME_CONTRACT_PASS ' + str(root), flush=True)


def native(root, test_ids):
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.game_testing import GameTestCase
    from pynq_multimodal_game.game_validation import compare_test_reports

    class Sink:
        def upload_palette(self, packet): pass
        def upload_asset(self, packet): pass
        def upload_tilemap(self, packet): pass
        def submit_scene(self, packet): pass

    metadata = json.loads((root / 'games/unified/verification.json').read_text(encoding='utf-8'))
    for entry in metadata['cases']:
        label = entry['test_id']
        if test_ids and label not in test_ids:
            continue
        case = GameTestCase.load(root / 'games/unified' / (label + '.json'))
        pc = json.loads((root / 'games/unified' / (label + '.pc-report.json')).read_text(encoding='utf-8'))
        runtime = PackagedGameRuntime(root / 'games' / entry['package'], Sink())
        runtime.load_test_case(case)
        try:
            runtime.start()
            deadline = time.monotonic() + 90
            while not runtime.test_complete and runtime.last_error is None:
                assert time.monotonic() < deadline, label
                threading.Event().wait(.02)
            assert runtime.last_error is None, runtime.last_error
            comparison = compare_test_reports(pc, runtime.test_report)
            save(HERE / ('f153-' + label + '-native.json'), {'comparison': comparison, 'report': runtime.test_report})
            assert comparison['status'] == 'passed', comparison
            print('UNIFIED_NATIVE_PASS ' + label, flush=True)
        finally:
            runtime.stop()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('action', choices=('check', 'games', 'export', 'contract', 'native'))
    parser.add_argument('--root', type=Path)
    parser.add_argument('--test-id', action='append', default=[])
    options = parser.parse_args()
    ast.parse(Path(__file__).read_text(), feature_version=(3, 10))
    root = options.root or REPO
    sys.path.insert(0, str(root / 'python'))
    if options.action == 'check':
        print('UNIFIED_WORKFLOW_AST_PASS', flush=True)
    elif options.action == 'contract':
        contract(root)
    elif options.action == 'native':
        native(root, options.test_id)
    else:
        {'games': build_games, 'export': export}[options.action]()