from __future__ import annotations

import argparse
import ast
from email import message_from_string
import hashlib
from importlib.metadata import distribution
import json
from pathlib import Path
import shutil
import subprocess
import sys
import zipfile


def prepare(root: Path, candidate: Path, native_inputs: Path, output: Path) -> dict:
    from pynq_multimodal_game.agent.vision_pl_fusion import BUILD_ID, verify_pl_candidate
    from pynq_multimodal_game.agent.voice_backend import DRIVER_SHA256, verify_driver_sources
    from pynq_multimodal_game.voice_service import verify_frozen_source
    from pynq_multimodal_game.game_testing import GameTestCase
    from pynq_multimodal_game.game_validation import build_verified_game, run_game_test
    from verify_vision_integration_sources import verify_sources

    root, candidate, native_inputs, output = (path.resolve() for path in (root, candidate, native_inputs, output))
    archive = output.with_name(output.name + '.zip')
    if output.exists() or archive.exists():
        raise FileExistsError('B00 package requires new output and archive')
    verify_pl_candidate(candidate / 'c6v_b00_candidate.bit', candidate / 'receipt.json')
    verify_driver_sources(native_inputs / 'audio_driver')
    verify_frozen_source()
    verify_sources(root, root / 'handoffs/gesture_vision_v61')
    dependencies = [distribution(name) for name in ('collision', 'tomli', 'tomli-w')]
    for dependency in dependencies:
        metadata = message_from_string(dependency.read_text('WHEEL') or '')
        if (metadata.get('Root-Is-Purelib') != 'true'
                or any(path.suffix in ('.pyd', '.so', '.dll') for path in dependency.files or ())):
            raise ValueError('B00 requires pure Python dependency: ' + dependency.metadata['Name'])
        if dependency.metadata['Name'] == 'collision' and dependency.version != '1.2.2':
            raise ValueError('Frozen collision==1.2.2 required')
    for source, receipt_name, library_name in (
            ('voice_native_transport.cpp', 'native_transport.json', 'voice_native_transport.so'),
            ('voice_cpu_features.cpp', 'cpu_features.json', 'voice_cpu_features.so')):
        receipt = json.loads((native_inputs / 'var' / receipt_name).read_text(encoding='utf-8'))
        if (hashlib.sha256((root / 'board/pynq_z2/scripts' / source).read_bytes()).hexdigest() != receipt['source_sha256']
                or hashlib.sha256((native_inputs / 'var' / library_name).read_bytes()).hexdigest() != receipt['library_sha256']
                or receipt.get('hardware_operations') is not False or receipt.get('compile_returncode') != 0):
            raise ValueError('B00 frozen native input mismatch: ' + source)
    output.mkdir(parents=True)
    overlay = output / 'overlay'
    overlay.mkdir()
    for name in ('c6v_b00_candidate.bit', 'c6v_b00_candidate.hwh', 'receipt.json'):
        shutil.copy2(candidate / name, overlay / name)
    for relative in ('python/pynq_multimodal_game', 'handoffs/gesture_vision_v61',
                     'handoffs/pc_gesture_baseline_20261007', 'board/pynq_z2/scripts'):
        shutil.copytree(root / relative, output / relative,
                        ignore=shutil.ignore_patterns('__pycache__', '*.pyc', 'NA'))
    for path in (root / 'board/pynq_z2').glob('*.py'):
        shutil.copy2(path, output / path.relative_to(root))
    for relative in ('board/pynq_z2/generated/pynq_z2_ps7_config.tcl',
                     'board/pynq_z2/constraints/camera_direct_plug_corrected.xdc'):
        destination = output / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(root / relative, destination)
    shutil.copytree(native_inputs / 'audio_driver', output / 'audio_driver')
    verify_driver_sources(output / 'audio_driver')
    shutil.copytree(native_inputs / 'var', output / 'var')
    for dependency in dependencies:
        for relative in dependency.files or ():
            if '__pycache__' in relative.parts or relative.suffix == '.pyc':
                continue
            destination = (output / 'python' / relative).resolve()
            if not destination.is_relative_to(output / 'python'):
                raise ValueError('B00 dependency escapes snapshot')
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(dependency.locate_file(relative), destination)
    games = output / 'games'
    games.mkdir()
    game_reports = {}
    for relative, case_name in (('candidates/game1-voice-s2', 's2-boundaries'),
                                ('games/game1', 'c1-golden'), ('games/game2', 'rps-01-win'),
                                ('games/game3', 'kingdom-01-princess-win')):
        project = root / relative
        package = build_verified_game(project, games / (project.name + '.vvg'), target_build_id=BUILD_ID)
        case_path = project / 'tests/replays' / (case_name + '.json')
        case = GameTestCase.load(case_path)
        if not case.assertions:
            raise ValueError('B00 package requires asserted golden cases')
        golden = run_game_test(package.path, case)
        golden.save(games / (project.name + '-pc-report.json'))
        if not golden.passed:
            raise RuntimeError('B00 PC golden failed: ' + project.name)
        shutil.copy2(case_path, games / (project.name + '-case.json'))
        game_reports[package.manifest.game_id] = {'sha256': package.sha256,
            'file': package.path.relative_to(output).as_posix(), 'matched_ticks': len(golden.frames),
            'assertions': len(case.assertions), 'target_build_id': BUILD_ID}
    identities = {}
    for path in sorted(output.rglob('*')):
        if path.is_file():
            if path.suffix == '.py':
                ast.parse(path.read_text(encoding='utf-8-sig'), filename=str(path), feature_version=(3, 10))
            identities[path.relative_to(output).as_posix()] = hashlib.sha256(path.read_bytes()).hexdigest()
    deployment = {'schema': 'pl-voice-fusion-board-deployment-v1', 'build_id': '0xC0060B00',
                  'runtime_registered': False, 'board_pending': True, 'release_ready': False,
                  'sha256': identities, 'games': game_reports, 'python_syntax': '3.10',
                  'live_authorization_required': True, 'nominal_packets': 900, 'nominal_samples': 864000}
    (output / 'deployment_manifest.json').write_text(json.dumps(deployment, indent=2) + '\n', encoding='utf-8')
    runner = output / 'board/pynq_z2/scripts/run_pl_voice_fusion_acceptance.py'
    subprocess.run([sys.executable, '-B', str(runner), '--check-only'], check=True, cwd=output)
    with zipfile.ZipFile(archive, 'x', compression=zipfile.ZIP_DEFLATED, compresslevel=6) as bundle:
        for path in sorted(output.rglob('*')):
            if path.is_file():
                bundle.write(path, path.relative_to(output.parent).as_posix())
    return {'status': 'B00_OFFLINE_RUNTIME_PACKAGE_PASS', 'files': len(identities),
            'archive': str(archive), 'sha256': hashlib.sha256(archive.read_bytes()).hexdigest(),
            'games': game_reports, 'hardware_operations': False, 'board_pending': True, 'release_ready': False}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--candidate-dir', type=Path, required=True)
    parser.add_argument('--native-inputs', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    arguments = parser.parse_args()
    root = Path(__file__).resolve().parents[3]
    sys.path.insert(0, str(root / 'python'))
    print(json.dumps(prepare(root, arguments.candidate_dir, arguments.native_inputs, arguments.output), indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())