"""Check the independent no-release XSim reproduction and its causal waveform.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/analyze_latency_credit_starvation.py --run build/hosd/c0e-credit-starvation-r02 --label latency-credit-starvation-r01
Output: evidence/<label>.json with source/receipt hashes and settled VCD events.
Next: compare a separately implemented admission candidate to this frozen failure.
No board access; TEST_PASS means the expected defect was reproduced, not repaired.
"""

import argparse
import hashlib
import json
from pathlib import Path

from analyze_latency_prewarm import analyze
from board_common import REPO, save


def sha(path):
    digest = hashlib.sha256()
    with path.open('rb') as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b''):
            digest.update(chunk)
    return digest.hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--run', required=True, type=Path)
    parser.add_argument('--label', required=True)
    args = parser.parse_args()
    run = args.run.resolve()
    assert run.is_relative_to(REPO / 'build/hosd')
    assert args.label.replace('-', '').isalnum()
    receipt = json.loads((run / 'receipt.json').read_text())
    assert receipt['status'] == 'ISOLATED_VIDEO_RATE_TEST_TERMINATED'
    assert 'CREDIT_STARVATION_REPRODUCED' in receipt['verdict']
    assert receipt['stimulus']['frames'] == 4 and receipt['stimulus']['active_lines'] == 720
    assert receipt['source_sha256']['axis_binary_dilate9.sv'] == 'c2a60d3490c616762bd76493087ea593fa550a251a170372feb4a5f1f06771a6'
    assert all(step['returncode'] == 0 for step in receipt['steps'])
    for name in ('tb_c0e_video_rate.sv', 'axis_binary_dilate9.sv'):
        assert sha(run / name) == receipt['source_sha256'][name]
    waveform = analyze(run / 'first-fault.vcd')
    events = waveform['first_events']
    assert events['rgb_backpressure']['time_ps'] < events['overflow']['time_ps']
    assert events['overflow']['time_ps'] <= events['capture_fault']['time_ps']
    for event in ('rgb_backpressure', 'overflow'):
        values = events[event]['values']
        assert values['granted'] == 3 and values['credit'] == 0
        assert values['axis_enable'] == 1 and values['packet_frames'] == 3
    final = waveform['final_values']
    assert final['faults'] == 5 and final['owner_causes'] == 1 and final['granted'] == 3
    result = dict(status='CREDIT_STARVATION_CAUSAL_REPRODUCTION_PASS', board_access=False,
                  defect_fixed=False, verdict=receipt['verdict'], waveform=waveform,
                  receipt_sha256=sha(run / 'receipt.json'), analyzer_sha256=sha(Path(__file__)),
                  scope='Actual generated video_in/demosaic plus prewarm capture; always-ready output sinks; no CPU release; no DDR model or board access')
    save(args.label, result)
    print(result['status'], json.dumps({name: event['time_ps'] for name, event in events.items()}))


if __name__ == '__main__':
    main()
