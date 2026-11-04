"""Audit saved Base PCM against the frozen R20 volume window/event rules.

Run from the repository root:
  .venv/Scripts/python subprojects/volume_response_offline/analyze_codec_ab_events.py \
    --input build/volume-response/codec-ab-a01 \
    --output build/volume-response/codec-ab-events-r01
Output: SHA-bound receipt.json with threshold spans and predicted RTL events.
Next: compare a future synchronized near-mic R20 capture with VOL1 window/event
and ACK counters; Base capture cannot prove the loaded PL serial input path.
No board or network access; the raw captures and source RTL are read-only.
"""

import argparse
import csv
import hashlib
import json
from pathlib import Path


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def runs(values, predicate, times):
    result = []
    start = None
    for index, value in enumerate(values):
        if predicate(value) and start is None:
            start = index
        if start is not None and (not predicate(value) or index == len(values) - 1):
            end = index if predicate(value) else index - 1
            result.append(dict(start_s=times[start], end_s=times[end], windows=end - start + 1))
            start = None
    return result


def predict_r20(values, times):
    """Mirror voice_volume_core's window FSM with a perfect immediate ACK.

    This is an optimistic upper bound: delayed/missing ACK can only suppress
    rearming. The recorded Base PCM is not an integrated VOL1 observation.
    """
    state = 'UNARMED'
    quiet_count = soft_count = loud_count = candidate_count = 0
    high_seen = False
    events = []
    candidates = []
    for index, (level, at) in enumerate(zip(values, times)):
        quiet, soft, loud = level <= 11, level >= 16, level >= 28
        prior_quiet = quiet_count
        quiet_count = min(5, quiet_count + 1) if quiet else 0
        if state == 'UNARMED':
            if quiet and prior_quiet >= 4:
                state = 'ARMED'
        elif state == 'ARMED':
            if soft:
                state = 'CANDIDATE'
                candidate_count = soft_count = 1
                loud_count = int(loud)
                high_seen = loud
                candidates.append(dict(window=index + 1, at_s=at, level=level))
        elif state == 'CANDIDATE':
            prior_candidate, prior_soft, prior_loud = candidate_count, soft_count, loud_count
            prior_high = high_seen
            candidate_count += 1
            soft_count = soft_count + 1 if soft else 0
            loud_count = loud_count + 1 if loud else 0
            high_seen |= loud
            kind = None
            if loud and prior_loud >= 1:
                state, kind = 'RECOVERY', 'LOUD'
            elif prior_candidate >= 2:
                state = 'RECOVERY'
                if not prior_high and not loud and soft and prior_soft >= 2:
                    kind = 'SOFT'
            if kind:
                events.append(dict(window=index + 1, at_s=at, kind=kind, level=level))
        elif state == 'RECOVERY':
            if quiet and prior_quiet >= 4:
                state = 'ARMED'
    return events, candidates


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    repo = Path(__file__).resolve().parents[2]
    capture = json.loads((args.input / 'board-receipt.json').read_text(encoding='utf-8'))
    assert capture['experiment'] == 'official-project-official-on-existing-Base'
    assert capture['phase'] == 'recorded' and capture['cleanup_confirmed']
    control = repo / 'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023/board/pynq_z2/scripts/voice_volume_control.py'
    # The board receipt hashes Python read_text().encode() after newline
    # normalization, while the deployment manifest hashes raw file bytes.
    assert hashlib.sha256(control.read_text(encoding='utf-8').encode()).hexdigest() == capture['control_sha256']
    rtl = repo / 'rtl/voice_volume/voice_volume_core.sv'
    receipt = dict(status='RUNNING', board_access=False, source_rtl=str(rtl),
                   source_rtl_sha256=sha256(rtl), source_capture_sha256=sha256(args.input / 'board-receipt.json'),
                   frozen_control_raw_sha256=sha256(control),
                   source_script_sha256=sha256(Path(__file__)), phases=[],
                   assumption='Immediate perfect ACK; event counts are optimistic predictions, not hardware observations.')
    try:
        for entry in capture['captures']:
            index = entry['index']
            raw = args.input / entry['file']['name']
            assert sha256(raw) == entry['file']['sha256']
            envelope = args.input / f'phase-{index}-envelope.csv'
            with envelope.open(newline='', encoding='utf-8') as stream:
                rows = list(csv.DictReader(stream))
            times = [float(row['time_s']) for row in rows]
            values = [float(row['left_l1_mean']) for row in rows]
            assert times == sorted(times) and times and len(rows) > 400
            events, candidates = predict_r20(values, times)
            active = [(at, level) for at, level in zip(times, values) if at >= 2.0]
            active_times = [at for at, _ in active]
            active_values = [level for _, level in active]
            soft_runs = runs(active_values, lambda x: x >= 16, active_times)
            loud_runs = runs(active_values, lambda x: x >= 28, active_times)
            phase = dict(index=index, profile=entry['profile'], raw_sha256=entry['file']['sha256'],
                         envelope_sha256=sha256(envelope), post_2s_windows=len(active),
                         post_2s_soft_windows=sum(value >= 16 for value in active_values),
                         post_2s_loud_windows=sum(value >= 28 for value in active_values),
                         post_2s_soft_runs=soft_runs, post_2s_loud_runs=loud_runs,
                         candidate_starts_post_2s=[x for x in candidates if x['at_s'] >= 2],
                         predicted_events_post_2s=[x for x in events if x['at_s'] >= 2],
                         predicted_events_startup=[x for x in events if x['at_s'] < 2])
            receipt['phases'].append(phase)
        assert [p['profile'] for p in receipt['phases']] == ['official', 'project-r20', 'official']
        assert receipt['phases'][1]['post_2s_soft_windows'] == 20
        assert receipt['phases'][1]['post_2s_loud_windows'] == 10
        # Check the predictor against a separate 1.536M-sample XSim run of the
        # frozen RTL before trusting its phase-1 event interpretation.
        human_envelope = repo / 'build/volume-response/acoustic-a03-human/human-envelope.csv'
        human_rtl = repo / 'build/volume-response/human-xsim-r01/receipt.json'
        with human_envelope.open(newline='', encoding='utf-8') as stream:
            human_rows = list(csv.DictReader(stream))
        rtl_receipt = json.loads(human_rtl.read_text(encoding='utf-8'))
        assert rtl_receipt['status'] == 'HUMAN_PCM_ORIGINAL_RTL_REPLAY_PASS'
        assert rtl_receipt['rtl_sha256'] == receipt['source_rtl_sha256']
        human_events, _ = predict_r20([float(row['left_mean_abs']) for row in human_rows],
                                      [float(row['time_s']) for row in human_rows])
        import re
        rtl_events = []
        for line in rtl_receipt['events']:
            match = re.search(r'kind=([12]).*window=(\d+)', line)
            assert match, line
            rtl_events.append((int(match.group(2)), 'LOUD' if match.group(1) == '2' else 'SOFT'))
        assert [(event['window'], event['kind']) for event in human_events] == rtl_events
        receipt['predictor_crosscheck'] = dict(status='MATCHED_SAVED_XSIM',
                                               envelope_sha256=sha256(human_envelope),
                                               rtl_receipt_sha256=sha256(human_rtl),
                                               matching_events=len(rtl_events))
        receipt['status'] = 'SAVED_PCM_EVENT_AUDIT_PASS'
    except BaseException as error:
        receipt.update(status='FAIL', error=repr(error))
        raise
    finally:
        (args.output / 'receipt.json').write_text(json.dumps(receipt, indent=2), encoding='utf-8')
    print(json.dumps({p['profile'] + '-' + str(p['index']): p['predicted_events_post_2s']
                      for p in receipt['phases']}, indent=2))


if __name__ == '__main__':
    main()
