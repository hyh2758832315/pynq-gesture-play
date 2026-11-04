"""Prepare an immutable R20 board candidate entirely offline.

Run: .venv/Scripts/python.exe -E -B subprojects/hdmi_input_osd/integration/finalize_latency_admission.py
Outputs: deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023.zip, .sha256,
independent restored tree and evidence/latency-admission-package-r03.json.
Next: read current Copilot release records before any board access; real acceptance remains pending.
"""
import ast
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import runpy
import shutil
import stat
import subprocess
import sys
import zipfile

from prepare_latency_admission_bundle import PARENT_NAME, PARENT_SHA
from verify_latency_admission_export import check, ROOT, HERE, REPO, sha

TARGET = REPO / 'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'
RESTORED = REPO / 'build/hosd/c0e/admission-package-restore-r03'
LOGS = REPO / 'build/hosd/c0e/admission-package-tests-r03'
EVIDENCE = HERE / 'evidence'
RECEIPT = EVIDENCE / 'latency-admission-package-r03.json'


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2) + '\n', encoding='utf-8')


def run(command, cwd, log):
    temporary = LOGS / (log.stem + '-system-temp')
    temporary.mkdir(exist_ok=False)
    environment = {**os.environ, 'PYTHONPATH': os.pathsep.join(map(str, (cwd / 'python', cwd / 'board/pynq_z2/scripts', cwd))),
                   'PYTHONDONTWRITEBYTECODE': '1', 'PYTEST_DISABLE_PLUGIN_AUTOLOAD': '1', 'PYTHONIOENCODING': 'utf-8',
                   'TEMP': str(temporary), 'TMP': str(temporary)}
    print('CHECK', log.stem, flush=True)
    with log.open('x', encoding='utf-8') as output:
        result = subprocess.run(command, cwd=cwd, env=environment, stdout=output, stderr=subprocess.STDOUT,
                                text=True, encoding='utf-8', errors='replace', timeout=180)
    text = log.read_text(encoding='utf-8')
    assert result.returncode == 0, f'{log}: {text[-3000:]}'
    return dict(command=list(map(str, command)), returncode=result.returncode, log=str(log), log_sha256=sha(log),
                passed_tests=int(re.search(r'(\d+) passed', text)[1]) if ' passed' in text else None)


def validate_tree(root, label):
    records = []
    records.append(run([sys.executable, '-B', str(root / 'tools/check_admission_package.py')], root, LOGS / (label + '-integrity.log')))
    for index, flags in enumerate(([], ['--volume-disable-sampling'])):
        records.append(run([sys.executable, '-B', str(root / 'start_board_test.py'), '--check-only', '--game-controls', *flags],
                           root, LOGS / f'{label}-preflight{index}.log'))
    test_dir = root / 'verification/pc-contracts'
    files = sorted(test_dir.glob('test_*.py')) + [root / 'tools/latest_capture_contract.py', root / 'tools/latest_runtime_contract.py']
    temporary = LOGS / (label + '-tmp')
    assert not temporary.exists()
    command = [sys.executable, '-B', '-m', 'pytest', '-q', '-p', 'no:cacheprovider', '-c', str(root / 'tools/pc_pytest.ini'),
               '--basetemp', str(temporary), *map(str, files)]
    records.append(run(command, root, LOGS / (label + '-pytest.log')))
    assert records[-1]['passed_tests'] == 270
    assert not (root / 'var').exists()
    return records


def main():
    archive_path = TARGET.with_suffix('.zip')
    assert not any(path.exists() for path in (TARGET, archive_path, RESTORED, LOGS, RECEIPT, archive_path.with_suffix('.zip.sha256')))
    check()
    parent_path = REPO / 'deliveries' / (PARENT_NAME + '.zip')
    assert sha(parent_path) == PARENT_SHA
    pair = json.loads((EVIDENCE / 'latency-admission-pair-r01.json').read_text())
    review = json.loads((EVIDENCE / 'latency-admission-physical-r04-reviewed-r02.json').read_text())
    assert pair['status'] == 'OFFLINE_CANDIDATE_PAIR_PASS' and review['status'] == 'ADMISSION_PHYSICAL_AND_SCOPED_REVIEW_PASS'
    bundle = ROOT / 'bundle-r01'
    for name, digest in pair['sha256'].items():
        assert sha(bundle / name).upper() == digest
    LOGS.mkdir(parents=True)
    record = dict(status='RUNNING', board_access=False, release_ready=False, board_pending=True, checks=[])
    try:
        with zipfile.ZipFile(parent_path) as parent:
            assert parent.testzip() is None and len(parent.namelist()) == len(set(parent.namelist()))
            prefix = PARENT_NAME + '/'
            original = json.loads(parent.read(prefix + 'deployment_manifest.json'))
            for name, digest in original['sha256'].items():
                assert hashlib.sha256(parent.read(prefix + name)).hexdigest().upper() == digest
            TARGET.mkdir()
            for member in parent.infolist():
                assert member.filename.startswith(prefix) and not member.is_dir()
                name = member.filename[len(prefix):]
                relative = PurePosixPath(name)
                assert name and not relative.is_absolute() and '..' not in relative.parts and ':' not in name
                assert stat.S_IFMT(member.external_attr >> 16) != stat.S_IFLNK
                if name.startswith('overlay/extended-review/'):
                    continue  # Replace the old hardware review with the current one below.
                path = (TARGET / name).resolve()
                assert path.is_relative_to(TARGET)
                path.parent.mkdir(parents=True, exist_ok=True)
                with path.open('xb') as stream:
                    stream.write(parent.read(member))
        runtime = {name: digest for name, digest in original['sha256'].items()
                   if name.startswith(('python/', 'board/', 'tools/')) or name == 'start_board_test.py'}
        assert all(sha(TARGET / name).upper() == digest for name, digest in runtime.items())
        verifier = runpy.run_path(str(TARGET / 'board/pynq_z2/scripts/verify_vision_integration_sources.py'))
        for name in verifier['CANDIDATE_FILES']:
            shutil.copyfile(bundle / name, TARGET / 'overlay' / name)
        shutil.copyfile(bundle / 'METHODOLOGY_RESOLUTION_REPORT.md', TARGET / 'overlay/METHODOLOGY_RESOLUTION_REPORT.md')
        write_json(TARGET / 'overlay/board_test_manifest.json', verifier['verify_volume_candidate_bundle'](TARGET / 'overlay'))
        write_json(TARGET / 'overlay/osd_signoff_review.json', review)
        for source_dir, folder in ((ROOT / 'extended', 'extended-review'), (ROOT / 'clock-review-r01', 'clock-review')):
            for path in source_dir.iterdir():
                if path.is_file():
                    destination = TARGET / 'overlay' / folder / path.name
                    destination.parent.mkdir(exist_ok=True)
                    shutil.copyfile(path, destination)
        for name, digest in review['control_sources_separately_simulated'].items():
            path = ROOT.parent / 'source' / name
            assert sha(path) == digest
            shutil.copyfile(path, TARGET / 'overlay/pl-vision-source' / name)
        for name, digest in review['unchanged_numeric_sources'].items():
            assert sha(TARGET / 'overlay/pl-vision-source' / name) == digest
        for name in ('latency-admission-physical-r04-reviewed-r02.json', 'latency-admission-clock-r01.json',
                     'latency-admission-osd-cdc-negative-r01.json', 'latency-admission-bit-export-r02.json',
                     'latency-admission-pair-r01.json', 'latency-admission-video-r01.json', 'latency-admission-opt-r01.json',
                     'latency-admission-synthesis-r01.json'):
            shutil.copyfile(EVIDENCE / name, TARGET / 'verification' / name)
        shutil.copyfile(ROOT.parent / 'offline-gates.json', TARGET / 'verification/latency-admission-offline-gates.json')
        write_json(TARGET / 'verification/r19_runtime_identity.json', dict(parent_archive_sha256=PARENT_SHA, unchanged_files=runtime))
        shutil.copyfile(HERE / 'admission_board_check.py', TARGET / 'tools/check_admission_package.py')
        (TARGET / 'tools/pc_pytest.ini').write_text('[pytest]\naddopts =\n', encoding='utf-8')
        contracts = json.loads((EVIDENCE / 'latency-latest-contract-r02.json').read_text())
        tests = TARGET / 'verification/pc-contracts'
        tests.mkdir()
        for name in ('test_c0e_origin.py', 'test_agent_transport.py', 'test_multimodal_input.py', 'test_vision_receiver.py', 'test_vision_preview.py'):
            source = EVIDENCE / 'latency-latest-contract-r02' / name
            assert sha(source) == contracts['tests_sha256'][str(source)]
            text = source.read_text()
            if name == 'test_c0e_origin.py':
                text, count = re.subn(r'root=Path\([^\n]+\)', 'root=Path(__file__).resolve().parents[2]', text)
                assert count == 1  # Path adapter only; preserve the actual-origin assertions.
            (tests / name).write_text(text, encoding='utf-8')
        stop = HERE / 'test_latency_stop.py'
        assert sha(stop) == contracts['tests_sha256'][str(stop)]
        shutil.copyfile(stop, tests / stop.name)
        fixture_archive = REPO / 'deliveries/voice-s4-runtime-fix-r06-20261014.zip'
        assert sha(fixture_archive) == '843ff26a13bb2fe95104e90928a4a3d0b245c48514355a26e815e88a01a790a5'
        fixture_member = 'voice-s4-runtime-fix-r06-20261014/tests/test_game_voice_policy.py'
        with zipfile.ZipFile(fixture_archive) as frozen:
            fixture_bytes = frozen.read(fixture_member)
        assert hashlib.sha256(fixture_bytes).hexdigest() == '09d1fd770362260f9da40975bac3224a98534eba51f206514063c4646800c145'
        fixture_text = fixture_bytes.decode('utf-8-sig').replace('\r\n', '\n').replace('\r', '\n')
        fixture_ast = ast.parse(fixture_text)
        nodes = [node for node in fixture_ast.body if isinstance(node, (ast.Import, ast.ImportFrom))
                 or isinstance(node, ast.FunctionDef) and node.name in ('make_policy', 'sample')]
        assert [node.name for node in nodes if isinstance(node, ast.FunctionDef)] == ['make_policy', 'sample']
        fixture_path = tests / 'test_game_voice_policy.py'
        fixture_path.write_text('# Frozen r06 fixture imports and two helpers; no added test cases.\n' +
                                '\n\n'.join(ast.get_source_segment(fixture_text, node) for node in nodes) + '\n', encoding='utf-8')
        write_json(TARGET / 'verification/pc-fixture-source.json', dict(archive=fixture_archive.name,
                   archive_sha256=sha(fixture_archive), member=fixture_member,
                   member_sha256=hashlib.sha256(fixture_bytes).hexdigest(), adapter_sha256=sha(fixture_path),
                   preserved_functions=['make_policy', 'sample'], primary_assertions_unchanged=True))
        shutil.copyfile(REPO / 'docs/bringup/2026-10-23_pynq-z2_r20_board_preparation.md', TARGET / 'docs/R20_BOARD_PREPARATION.md')
        shutil.copyfile(REPO / 'docs/bringup/2026-10-23_pynq-z2_pl_timing_repair.md', TARGET / 'docs/pl_timing_repair.md')
        write_json(TARGET / 'board_test_plan.json', dict(schema='c0e-admission-board-plan-v1', board_access=False,
                   release_ready=False, board_pending=True, required_release_record=None, observed_boot_id=None,
                   observed_owner_pids=None, bit_sha256=pair['sha256']['c6v_candidate.bit'], build_id='0xC0060E00',
                   instructions='docs/R20_BOARD_PREPARATION.md',
                   acceptance=['fresh identity and ownership', 'full-slot pause and recovery', 'CRC and context',
                               'normal STOP and retained faults', 'menu/video/game independent OSD', 'GPU coexistence',
                               'CPU/throughput/frame-age and physical latency comparison']))
        marker = json.loads((TARGET / 'candidate_stage.json').read_text())
        marker.update(stage='PAIRED_PREFLIGHT_READY', release_ready=False, board_pending=True, board_operations=False,
                      timing_review=review['status'], bit_sha256=pair['sha256']['c6v_candidate.bit'],
                      immediate_parent_archive_sha256=PARENT_SHA,
                      warning='R20 admission: offline signed and paired candidate. Current Copilot release and real board acceptance required.')
        write_json(TARGET / 'candidate_stage.json', marker)
        contents = {}
        for path in sorted(TARGET.rglob('*')):
            if not path.is_file() or path == TARGET / 'deployment_manifest.json' or '__pycache__' in path.parts:
                continue
            name = path.relative_to(TARGET).as_posix()
            data = path.read_bytes()
            if name.endswith('.py'):
                ast.parse(data.decode('utf-8-sig'), filename=name, feature_version=(3, 10))
            contents[name] = data
        manifest = original.copy()
        manifest.update(immediate_parent_archive_sha256=PARENT_SHA, release_ready=False, board_pending=True,
                        purpose='pl-frame-admission-and-independent-hdmi-osd-r20',
                        bit_sha256=pair['sha256']['c6v_candidate.bit'],
                        sha256={name: hashlib.sha256(data).hexdigest().upper() for name, data in contents.items()})
        write_json(TARGET / 'deployment_manifest.json', manifest)
        contents['deployment_manifest.json'] = (TARGET / 'deployment_manifest.json').read_bytes()
        record['checks'].extend(validate_tree(TARGET, 'original'))
        with zipfile.ZipFile(archive_path, 'x', compression=zipfile.ZIP_DEFLATED) as archive:
            for name, data in sorted(contents.items()):
                archive.writestr(TARGET.name + '/' + name, data)
        RESTORED.mkdir(parents=True)
        with zipfile.ZipFile(archive_path) as archive:
            assert archive.testzip() is None and len(archive.namelist()) == len(contents) == len(set(archive.namelist()))
            for name, data in contents.items():
                assert archive.read(TARGET.name + '/' + name) == data
                path = RESTORED / name
                path.parent.mkdir(parents=True, exist_ok=True)
                with path.open('xb') as stream:
                    stream.write(archive.read(TARGET.name + '/' + name))
        record['checks'].extend(validate_tree(RESTORED, 'restored'))
        assert all(sha(TARGET / name).upper() == digest == sha(RESTORED / name).upper() for name, digest in manifest['sha256'].items())
        assert sha(parent_path) == PARENT_SHA
        checksum = sha(archive_path)
        with archive_path.with_suffix('.zip.sha256').open('x', encoding='ascii') as stream:
            stream.write(checksum + '  ' + archive_path.name + '\n')
        record.update(status='ADMISSION_R20_PACKAGE_RESTORED_AND_PC_PREFLIGHT_PASS', archive=str(archive_path),
                      sha256=checksum, bytes=archive_path.stat().st_size, manifest_files=len(manifest['sha256']),
                      parent_archive_sha256=PARENT_SHA, bit_sha256=pair['sha256']['c6v_candidate.bit'],
                      restored=str(RESTORED), unchanged_runtime_files=len(runtime), preparer_sha256=sha(Path(__file__)))
    except BaseException as error:
        record.update(status='FAIL', error=f'{type(error).__name__}: {error}')
        if (TARGET / 'candidate_stage.json').exists():
            marker = json.loads((TARGET / 'candidate_stage.json').read_text())
            marker.update(stage='PREPARATION_FAILED', release_ready=False, board_pending=True)
            write_json(TARGET / 'candidate_stage.json', marker)
        raise
    finally:
        with RECEIPT.open('x', encoding='utf-8') as stream:
            json.dump(record, stream, indent=2)
            stream.write('\n')
    print(record['status'], record['sha256'], record['bytes'], record['manifest_files'])


if __name__ == '__main__':
    main()
