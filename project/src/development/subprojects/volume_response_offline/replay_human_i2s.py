"""Replay official Base human ADC words through the frozen R20 I2S receiver.

Run: .venv/Scripts/python subprojects/volume_response_offline/replay_human_i2s.py
     --root build/volume-response/acoustic-a03-human
     --output build/volume-response/human-i2s-r01
     --bin D:/Xilinx/Vivado/2026.1/Vivado/bin
Output: two bound payload memories, XSim logs, and receipt.json.
Next: compare against real integrated near-voice samples; this is digital-only.
"""
import argparse
import hashlib
import json
import subprocess
import time
from pathlib import Path

import numpy as np

from analyze_human_pcm import filtered_windows


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--bin', type=Path, required=True)
    args = parser.parse_args()
    args.output = args.output.resolve()
    args.output.mkdir(parents=True, exist_ok=False)
    repo = Path(__file__).resolve().parents[2]
    source = repo / 'build/volume-response/audit-r01/rtl/voice_volume_i2s_rx.sv'
    bench = Path(__file__).with_name('tb_human_i2s.sv')
    audit = json.loads((repo / 'build/volume-response/audit-r01/audit.json').read_text())
    assert sha(source) == audit['rtl'][source.name]['sha256']
    raw = args.root / 'board-raw.npy'
    words = np.load(raw, allow_pickle=False).astype(np.int64) & 0xffffff
    words = words.reshape(-1, 2)
    signed = np.where(words & 0x800000, words - 0x1000000, words)
    levels = filtered_windows(signed[:, 0] >> 8)
    quiet = next(i for i in range(100, len(levels)) if levels[i] < 11)
    loud = next(i for i in range(100, len(levels)) if levels[i] > 28)
    indices = np.r_[np.arange(quiet * 977, (quiet + 1) * 977),
                    np.arange(loud * 977, (loud + 1) * 977)]
    assert len(indices) == 1954 and quiet != loud
    for channel, name in ((0, 'human-left-payload.mem'), (1, 'human-right-payload.mem')):
        payload = (words[indices, channel] << 8) & 0xffffffff
        (args.output / name).write_text(''.join(f'{int(value):08x}\n' for value in payload))
    commands = [[str(args.bin / 'xvlog.bat'), '--sv', str(source), str(bench)],
                [str(args.bin / 'xelab.bat'), 'tb_human_i2s', '-s', 'human_i2s', '--mt', 'off'],
                [str(args.bin / 'xsim.bat'), 'human_i2s', '-runall']]
    receipt = dict(status='RUNNING', passed=False, board_access=False, raw_sha256=sha(raw),
                   rtl_sha256=sha(source), bench_sha256=sha(bench), quiet_window=quiet,
                   loud_window=loud, quiet_level=float(levels[quiet]),
                   loud_level=float(levels[loud]), steps=[])
    try:
        for index, command in enumerate(commands):
            started = time.monotonic()
            result = subprocess.run(command, cwd=args.output, capture_output=True, timeout=180)
            transcript = (result.stdout + result.stderr).decode('utf-8', errors='replace')
            (args.output / f'step-{index}.log').write_text(transcript, encoding='utf-8')
            receipt['steps'].append(dict(command=command, returncode=result.returncode,
                                         seconds=time.monotonic() - started))
            print('HUMAN_I2S_STAGE', index, result.returncode, flush=True)
            if result.returncode or 'Fatal:' in transcript or 'FATAL:' in transcript:
                raise RuntimeError(f'XSim stage {index} failed')
            if index == 2:
                lines = [line for line in transcript.splitlines()
                         if line.startswith('TEST_PASS human_i2s ')]
                assert len(lines) == 1
                receipt['verdict'] = lines[0]
        receipt.update(status='HUMAN_PCM_I2S_REPLAY_PASS', passed=True)
        print(receipt['verdict'])
    except BaseException as error:
        receipt.update(status='FAIL', error=repr(error))
        raise
    finally:
        (args.output / 'receipt.json').write_text(json.dumps(receipt, indent=2))


if __name__ == '__main__':
    main()
