"""Bound whether saved R20 menu polling could hide saved near-voice windows.

Run from repository root:
  .venv/Scripts/python subprojects/volume_response_offline/analyze_poll_visibility.py \
    --voice build/volume-response/cosim-production-project-human-r03 \
    --menu build/volume-response/integrated-r20-control-a01/menu-baseline.json \
    --output build/volume-response/poll-visibility-r01
Output: SHA-bound receipt.json with conditional poll/ACK/OSD timing margins.
Next: obtain synchronized near-mic integrated-board window/event/ACK evidence
when the board is released. This calculation never contacts the board.
"""

import argparse
import csv
import hashlib
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def longest_high_run(rows, threshold_sum):
    best = None
    start = None
    for index, row in enumerate(rows):
        high = int(row['sum']) >= threshold_sum
        if high and start is None:
            start = index
        if start is not None and (not high or index == len(rows) - 1):
            end = index if not high else index + 1
            if end < len(rows):
                run = dict(start_window=start + 1, end_window=end,
                           start_ns=int(rows[start]['ns']), end_ns=int(rows[end]['ns']),
                           high_windows=end - start)
                if best is None or run['high_windows'] > best['high_windows']:
                    best = run
            start = None
    assert best is not None
    return best


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--voice', type=Path, required=True)
    parser.add_argument('--menu', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    voice = json.loads((args.voice / 'receipt.json').read_text(encoding='utf-8'))
    menu = json.loads(args.menu.read_text(encoding='utf-8'))
    core = (ROOT / 'rtl/voice_volume/voice_volume_core.sv').read_text(encoding='utf-8')
    timeout_clks = int(re.search(r'EVENT_TIMEOUT_CLKS\s*=\s*(\d+)', core).group(1))
    assert voice['status'] == 'DIGITAL_FUNCTIONAL_COSIM_PASS' and voice['scenario'] == 'project_human'
    assert menu['status'] == 'INTEGRATED_AUDIO_STATUS_CAPTURE_COMPLETE'
    assert voice['scheduler']['producer_period_ns'] == 20_000_000
    snapshots = [item['response']['snapshot']['volume']['worker'] for item in menu['snapshots']]
    poll_gap_ns = max(item['max_poll_gap_ns'] for item in snapshots)
    cycle_ns = max(item['max_cycle_ns'] for item in snapshots)
    assert all(item['faults'] == 0 for item in snapshots)
    with (args.voice / 'windows.csv').open(newline='', encoding='utf-8') as stream:
        rows = list(csv.DictReader(stream))
    loud = longest_high_run(rows, 28 * 977)
    event_rows = [row for row in rows if row['pending'] == '1' and row['kind'] == '2']
    assert len(event_rows) == 1 and voice['ack_count'] == 1
    event_ns = int(event_rows[0]['ns'])
    timeout_ns = timeout_clks * 10  # frozen 100 MHz AXI clock
    osd_period_ns = voice['scheduler']['osd_period_ns']
    loud_duration_ns = loud['end_ns'] - loud['start_ns']
    result = dict(status='RUNNING', board_access=False,
                  source_sha256=dict(voice_receipt=digest(args.voice / 'receipt.json'),
                                     windows=digest(args.voice / 'windows.csv'),
                                     menu=digest(args.menu),
                                     rtl=digest(ROOT / 'rtl/voice_volume/voice_volume_core.sv'),
                                     analyzer=digest(Path(__file__))),
                  measured_menu_poll_gap_ns=poll_gap_ns,
                  measured_menu_cycle_ns=cycle_ns,
                  saved_voice_loud_run=loud,
                  saved_voice_loud_duration_ns=loud_duration_ns,
                  saved_voice_event_ns=event_ns,
                  event_timeout_ns=timeout_ns,
                  max_event_handling_ns_if_menu_gap_holds=timeout_ns - poll_gap_ns,
                  osd_period_ns=osd_period_ns,
                  osd_one_tick_margin_ns=loud_duration_ns - poll_gap_ns - osd_period_ns,
                  conditions=['Menu poll gap is a historical quiet six-second maximum, not a bound during near-voice/game load.',
                              'ACK handling time with a real event is not bounded by the quiet menu cycle maximum.',
                              'OSD one-tick guarantee assumes independent publisher meets period and no relevant publish skip.',
                              'Saved Base-captured PCM is not a synchronized integrated-board microphone observation.'])
    assert 0 < poll_gap_ns < timeout_ns
    assert result['osd_one_tick_margin_ns'] > 0
    result['status'] = 'CONDITIONAL_SCHEDULE_BOUND_PASS'
    (args.output / 'receipt.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
