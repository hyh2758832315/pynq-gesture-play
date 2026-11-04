"""Summarize captured VOL1 windows without accessing the board.

Run: .venv/Scripts/python.exe -B subprojects/volume_response_offline/analyze_live_volume.py
     --root build/volume-response/codec-pl-human-20261024-a01
Output: exclusive live-analysis.json and live-windows.csv, bound to source hashes.
Next: compare with same-earpiece official Base PCM; this is not game acceptance.
"""
import argparse
import csv
import hashlib
import json
import statistics
from collections import Counter
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, required=True)
    args = parser.parse_args()
    board = json.loads((args.root / 'board-receipt.json').read_text())
    pc = json.loads((args.root / 'pc-receipt.json').read_text())
    assert pc['status'] == 'MEASUREMENT_COMPLETE' and pc['returncode'] == 0
    assert board['phase'] == 'measured' and board['cleanup_confirmed']
    assert board['human_voice'] and board['registers_restored'] and board['sampling_disabled']
    assert len(board['phases']) == 1
    phase = board['phases'][0]
    rows = []
    for sample in phase['samples']:
        assert not sample['faults'] and not sample['ack_error']
        assert sample['clock_locked'] and sample['snapshot_valid']
        if sample['mean_abs'] is None:
            continue
        assert sample['mean_abs'] == sample['l1_sum'] / 977
        rows.append(dict(seconds=(sample['board_ns'] - phase['start_ns']) / 1e9,
                         window=sample['window_count'], sample_count=sample['sample_count'],
                         mean_abs=sample['mean_abs'], l1_sum=sample['l1_sum'], state=sample['state']))
    assert rows and len({r['window'] for r in rows}) == len(rows)
    settled = [r for r in rows if r['seconds'] >= 2]
    values = sorted(r['mean_abs'] for r in settled)
    assert values
    seconds = []
    for index in range(30):
        chunk = [r['mean_abs'] for r in rows if index <= r['seconds'] < index + 1]
        if chunk:
            seconds.append(dict(second=index, windows=len(chunk), median=statistics.median(chunk), maximum=max(chunk)))
    events = phase['events']
    result = dict(status='LIVE_VOLUME_WINDOWS_ANALYZED', boot_id=board['boot_id'],
                  seconds=(phase['end_ns'] - phase['start_ns']) / 1e9,
                  total_observations=len(phase['samples']), valid_windows=len(rows),
                  skipped_window_count=sum(max(0, b['window']-a['window']-1) for a, b in zip(rows, rows[1:])),
                  first_two_seconds_excluded=True, settled_windows=len(values),
                  minimum=values[0], median=statistics.median(values),
                  p95=values[round((len(values)-1)*.95)], maximum=values[-1],
                  windows_ge_soft=sum(v >= 16 for v in values), windows_ge_loud=sum(v >= 28 for v in values),
                  states=dict(Counter(r['state'] for r in settled)),
                  event_count=len(events), ack_confirmed_count=sum(bool(e['ack_confirmed']) for e in events),
                  events=events, per_second=seconds, cleanup_confirmed=True,
                  skills_verified=False, osd_verified=False,
                  source_sha256={n: hashlib.sha256((args.root/n).read_bytes()).hexdigest()
                                 for n in ('board-receipt.json','pc-receipt.json','remote_source.py','board.log')})
    with (args.root / 'live-analysis.json').open('x', encoding='utf-8') as output:
        json.dump(result, output, ensure_ascii=False, indent=2)
    with (args.root / 'live-windows.csv').open('x', newline='', encoding='utf-8') as output:
        writer = csv.DictWriter(output, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    print(json.dumps({k: v for k, v in result.items() if k not in ('per_second', 'source_sha256')}, indent=2))


if __name__ == '__main__':
    main()
