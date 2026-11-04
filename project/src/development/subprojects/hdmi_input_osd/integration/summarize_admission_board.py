"""Bind local R20 first-board evidence without contacting the board.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/summarize_admission_board.py
Output: evidence/r20-first-board-summary-r02.json (exclusive; original r01 retained).
Next: address preview coupling offline; physical latency and sealed STOP remain pending.
"""
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
EVIDENCE = HERE / 'evidence'
ROOT = REPO / 'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'


def read(name):
    return json.loads((EVIDENCE / name).read_text(encoding='utf-8'))


def main():
    names = ['r20-b09-menu-observe.json', 'r20-b10-studio-observe.json',
             'r20-b11-modes.json', 'r20-b12-studio-timing.json',
             'r20-b13-goldens.json', 'r20-b16-final-menu-observe.json']
    data = {name: read(name) for name in names}
    assert all(value['status'] == 'PASS' for value in data.values())
    metadata = json.loads((ROOT / 'games/pl-c0e-r01/verification.json').read_text(encoding='utf-8'))
    goldens = []
    for case in metadata['cases']:
        name = 'r20-b13-goldens-' + case['test_id'] + '-gpu.json'
        value = read(name)
        assert value['comparison']['status'] == 'passed'
        assert value['comparison']['matched_ticks'] == case['ticks']
        goldens.append(dict(test_id=case['test_id'],ticks=case['ticks']))
        names.append(name)
    final = data['r20-b16-final-menu-observe.json']['summaries'][-1]['last']
    assert final['runtime_mode'] == 'menu' and final['last_error'] is None
    assert final['vision']['state'] == 'RUNNING'
    osd = final['vision']['hdmi_osd']
    assert osd['enabled'] and osd['thread_alive'] and not osd['test_active'] and osd['error'] is None
    telemetry = REPO / 'build/hosd/c0e/r20-studio-r02/telemetry.jsonl'
    rows = [json.loads(line) for line in telemetry.read_text(encoding='utf-8').splitlines()]
    assert rows[-1]['visible'] and rows[-1]['device_state'] == 'ready'
    assert int(rows[-1]['frames']) > int(rows[0]['frames']) > 0
    archive = ROOT.with_suffix('.zip')
    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    assert digest == 'd64e5e7a553f13ef7db04305ea9df902def279b35dbe06c4f7a4427b695cb6d4'
    runtime = read('r20-b17-final-runtime.json')
    assert runtime['returncode'] == 0
    current = json.loads(runtime['stdout'])
    assert current['result']['frame'] > final['vision']['frame_id']
    assert current['service_exit'] is None and not current['stderr_tail']
    assert all(':8081' in sample for sample in current['connections'])
    names.append('r20-b17-final-runtime.json')
    summary = dict(status='R20_FIRST_BOARD_PARTIAL_PERFORMANCE_LIMIT',release_ready=False,
        board_pending=True,board_running=True,archive_sha256=digest,
        golden_cases=goldens,matched_ticks=sum(case['ticks'] for case in goldens),
        no_preview=data['r20-b09-menu-observe.json']['summaries'][0],
        with_preview=data['r20-b10-studio-observe.json']['summaries'][0],
        final_menu=data['r20-b16-final-menu-observe.json']['summaries'][0],
        studio_120s=rows[-1],
        final_http_connections=current['connections'],final_result_frame=current['result']['frame'],
        pending=['Recognition varied from 4.777 to 21.183 fps with Studio; causal isolation and preview decoupling pending.',
                 'Explicit prolonged full-slot pause/recovery and sealed STOP on real DMA pending.',
                 'Physical gesture/audio to HDMI latency and human HDMI acceptance pending.'],
        evidence_sha256={name:hashlib.sha256((EVIDENCE/name).read_bytes()).hexdigest() for name in names},
        studio_telemetry_sha256=hashlib.sha256(telemetry.read_bytes()).hexdigest())
    with (EVIDENCE / 'r20-first-board-summary-r02.json').open('x',encoding='utf-8') as output:
        json.dump(summary,output,indent=2,allow_nan=False)
    print(summary['status'], len(goldens), summary['matched_ticks'])


if __name__ == '__main__':
    main()
