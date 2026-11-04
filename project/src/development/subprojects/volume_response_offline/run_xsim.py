"""Run isolated offline digital characterization with Vivado 2026.1 XSim.

Run: .venv/Scripts/python subprojects/volume_response_offline/run_xsim.py --bin D:/Xilinx/Vivado/2026.1/Vivado/bin --baseline build/volume-response/audit-r01 --output build/volume-response/xsim-r01
Output: stage logs and receipt.json. Next: interpret alongside saved acoustic evidence.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import time


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--bin', type=Path, required=True)
    parser.add_argument('--baseline', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output = args.output.resolve()
    args.output.mkdir(parents=True, exist_ok=False)
    source = args.baseline.resolve() / 'rtl/voice_volume_core.sv'
    bench = Path(__file__).with_name('tb_volume_response.sv').resolve()
    baseline = json.loads((args.baseline / 'audit.json').read_text())
    assert hashlib.sha256(source.read_bytes()).hexdigest() == baseline['rtl'][source.name]['sha256']
    commands = [[str(args.bin / 'xvlog.bat'), '--sv', str(source), str(bench)],
                [str(args.bin / 'xelab.bat'), 'tb_volume_response', '-s', 'volume_response', '--mt', 'off'],
                [str(args.bin / 'xsim.bat'), 'volume_response', '-runall']]
    receipt = dict(board_access=False, physical_response_verified=False, passed=False,
                   source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
                   bench_sha256=hashlib.sha256(bench.read_bytes()).hexdigest(), steps=[])
    try:
        for i, command in enumerate(commands):
            start = time.monotonic()
            result = subprocess.run(command, cwd=args.output, capture_output=True, timeout=180)
            transcript = (result.stdout + result.stderr).decode('utf-8', errors='replace')
            (args.output / f'step-{i}.log').write_text(transcript, encoding='utf-8')
            receipt['steps'].append(dict(command=command, returncode=result.returncode, seconds=time.monotonic()-start))
            print(f'VOLUME_STAGE {i} returncode={result.returncode}', flush=True)
            if result.returncode or 'Fatal:' in transcript or 'FATAL:' in transcript:
                raise RuntimeError(f'failed stage {i}; see step-{i}.log')
            if i == 2:
                lines = [line for line in transcript.splitlines() if line.startswith('TEST_PASS volume_response ')]
                if len(lines) != 1:
                    raise RuntimeError('missing unique terminal PASS')
                receipt['verdict'] = lines[0]
                receipt['cases'] = [line for line in transcript.splitlines() if line.startswith('CASE ')]
                print('\n'.join(receipt['cases'] + lines))
        receipt['passed'] = True
    finally:
        (args.output / 'receipt.json').write_text(json.dumps(receipt, indent=2), encoding='utf-8')


if __name__ == '__main__':
    main()
