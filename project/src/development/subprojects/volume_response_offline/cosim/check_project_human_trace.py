"""Independently check a completed A13 project-Codec XSI trace after capture.

Run from the repository root:
  .venv/Scripts/python subprojects/volume_response_offline/cosim/check_project_human_trace.py \
    --trace build/volume-response/cosim-production-project-human-r02 \
    --output build/volume-response/cosim-project-human-check-r01
Output: SHA-bound receipt.json; the original trace and its FAIL receipt remain intact.
Next: use a future synchronized near-mic integrated-board observation to locate
the physical codec/I2S boundary; this check cannot verify analog microphone gain.
No board/network access or XSim rerun is performed.
"""

import argparse
import hashlib
import json
import math
from pathlib import Path

from run_cosim import validate


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--trace', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    trace = json.loads((args.trace / 'receipt.json').read_text(encoding='utf-8'))
    assert trace['scenario'] == 'project_human' and trace['status'] == 'FAIL'
    assert trace['error'] == 'AssertionError(240)'
    assert trace['ack_count'] == 1
    assert digest(args.trace / 'left.mem') == trace['stimulus_sha256']
    root = Path(__file__).resolve().parents[3]
    raw = root / trace['stimulus']['path']
    assert digest(raw) == trace['stimulus']['sha256']
    prior = root / 'build/volume-response/cosim-production-human-r01/receipt.json'
    assert digest(prior) == trace['compile_steps'][0]['prior_receipt_sha256']
    count = math.ceil(.82 * (100_000_000 / 2048))
    with (args.trace / 'left.mem').open(encoding='ascii') as stream:
        values = []
        for _ in range(count):
            value = int(next(stream).strip(), 16)
            values.append(value - 0x1000000 if value & 0x800000 else value)
    commits = json.loads((args.trace / 'commits.json').read_text(encoding='utf-8'))
    result = dict(status='RUNNING', board_access=False,
                  original_trace_status='FAIL',
                  original_trace_sha256=digest(args.trace / 'receipt.json'),
                  check_script_sha256=digest(Path(__file__)),
                  validator_sha256=digest(Path(__file__).with_name('run_cosim.py')),
                  trace_hashes={name: digest(args.trace / name) for name in
                                ('left.mem', 'right.mem', 'pcm.csv', 'windows.csv',
                                 'serialized.csv', 'frames.csv', 'bar.csv', 'commits.json', 'polls.jsonl')})
    try:
        result['checks'] = validate(args.trace, values, commits, 'project_human')
        result['ack_count'] = trace['ack_count']
        assert result['checks']['event_kinds'] == [2]
        result['status'] = 'PROJECT_HUMAN_TRACE_POSTCHECK_PASS'
    except BaseException as error:
        result.update(status='FAIL', error=repr(error))
        raise
    finally:
        (args.output / 'receipt.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
    print(json.dumps(result['checks'], indent=2))


if __name__ == '__main__':
    main()
