"""Run isolated R19 source/runtime regressions and retain exact source hashes.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/verify_latency_latest.py --label latency-latest-contract-r01
Output: evidence/LABEL.json, source snapshots and full subprocess log.
Next: freeze candidate only on PASS; ARM and real-board throughput remain separate.
Windows tests require local loopback sockets for asyncio and preview HTTP.
"""
import argparse
import ast
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
TARGET = REPO / 'deliveries/c6i-pl-vision-volume-osd-r19-latest-20261023'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--label', required=True)
    args = parser.parse_args()
    assert args.label.startswith('latency-latest-contract-') and args.label.replace('-', '').isalnum()
    output = HERE / 'evidence' / args.label
    output.mkdir()
    receipt = output.with_suffix('.json')
    assert not receipt.exists()
    changed = ('board/pynq_z2/vision_latest_capture.py', 'board/pynq_z2/scripts/vision_async_runtime.py',
               'python/pynq_multimodal_game/agent/pl_volume_factory.py',
               'python/pynq_multimodal_game/agent/vision_backend.py')
    sources = {name: sha(TARGET / name) for name in changed}
    assert sources[changed[0]] == sha(HERE.parent / 'latency_runtime/vision_latest_capture.py')
    for name in changed:
        path = TARGET / name
        ast.parse(path.read_text(encoding='utf-8-sig'), filename=name, feature_version=(3, 10))
        snapshot = output / 'source' / name
        snapshot.parent.mkdir(parents=True, exist_ok=True)
        snapshot.write_bytes(path.read_bytes())
    test_paths = []
    for name in ('test_c0e_origin.py', 'test_agent_transport.py', 'test_multimodal_input.py',
                 'test_vision_receiver.py', 'test_vision_preview.py'):
        source = HERE / 'evidence/latency-source-contract-r03' / name
        content = source.read_text(encoding='utf-8-sig').replace(
            'c6i-pl-vision-volume-osd-r17-20261023', TARGET.name)
        destination = output / name
        destination.write_text(content, encoding='utf-8')
        test_paths.append(destination)
    for name in ('test_latest_capture.py', 'test_latest_runtime.py', 'test_latency_stop.py'):
        test_paths.append(HERE / name)
    record = dict(status='RUNNING', board_access=False, candidate=str(TARGET), source_sha256=sources,
                  tests_sha256={str(path): sha(path) for path in test_paths})
    temporary = REPO / 'build/hosd' / ('lc-' + args.label.rsplit('-', 1)[1])
    assert not temporary.exists()
    command = [sys.executable, '-B', '-m', 'pytest', '-q', '-p', 'no:cacheprovider',
               '-o', 'pythonpath=' + str(TARGET / 'python'),
               '--basetemp', str(temporary), *map(str, test_paths)]
    environment = dict(os.environ, PYTHONPATH=os.pathsep.join(map(str, (
        TARGET / 'python', TARGET / 'board/pynq_z2/scripts', TARGET, HERE, REPO / 'tests'))), PYTHONIOENCODING='utf-8')
    try:
        result = subprocess.run(command, cwd=REPO, env=environment, capture_output=True,
                                text=True, encoding='utf-8', errors='replace', timeout=240)
        log = output / 'pytest.log'
        log.write_text(result.stdout + result.stderr, encoding='utf-8')
        record.update(command=command, returncode=result.returncode, log=str(log), log_sha256=sha(log))
        assert result.returncode == 0, result.stdout[-6000:] + result.stderr[-3000:]
        assert all(sha(TARGET / name) == value for name, value in sources.items())
        record['status'] = 'LATEST_CAPTURE_PC_CONTRACT_PASS'
        print(result.stdout, flush=True)
    except BaseException as error:
        record.update(status='FAIL', error=f'{type(error).__name__}: {error}')
        raise
    finally:
        with receipt.open('x', encoding='utf-8') as stream:
            json.dump(record, stream, indent=2)


if __name__ == '__main__':
    main()
