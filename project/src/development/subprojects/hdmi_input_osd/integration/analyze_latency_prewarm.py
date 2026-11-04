"""Read focused XSim VCDs and pin the prewarm A/B evidence; no hardware access.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/analyze_latency_prewarm.py
Output: evidence/latency-prewarm-ab-r01.json with first divergence/fault snapshots and SHA256.
Next: finish full-frame rate testing, rebuild and sign off the changed RTL before board loading.
"""
import hashlib
from pathlib import Path
from board_common import REPO, save


def analyze(path):
    names, values, events = {}, {}, {}
    timestamp = 0

    def settle():
        conditions = dict(rgb_backpressure=values.get('rv') == 1 and values.get('rr') == 0,
                          skin_backpressure=values.get('skin_valid') == 1 and values.get('skin_ready') == 0,
                          overflow=values.get('overflow') == 1,
                          owner_fault=values.get('owner_causes', 0) not in (None, 0),
                          capture_fault=values.get('faults', 0) not in (None, 0))
        for name, condition in conditions.items():
            if condition and name not in events:
                events[name] = dict(time_ps=timestamp, values=dict(values))

    with path.open() as stream:
        for raw in stream:
            line = raw.strip()
            if line.startswith('$var '):
                fields = line.split()
                names[fields[3]] = fields[4]
            elif line.startswith('#'):
                settle()
                timestamp = int(line[1:])
            elif line and line[0] in '01xz':
                if line[1:] in names:
                    values[names[line[1:]]] = int(line[0]) if line[0] in '01' else None
            elif line.startswith('b'):
                number, code = line[1:].split()
                if code in names:
                    values[names[code]] = None if 'x' in number or 'z' in number else int(number, 2)
    settle()
    return dict(first_events=events, final_values=values, final_time_ps=timestamp,
                bytes=path.stat().st_size, sha256=hashlib.sha256(path.read_bytes()).hexdigest())


def main():
    baseline = analyze(REPO / 'build/hosd/c0e-video-rate-r04/first-fault.vcd')
    fixed = analyze(REPO / 'build/hosd/c0e-video-rate-prewarm-r01/first-fault.vcd')
    assert baseline['first_events']['overflow']['values']['dilation_row'] == 2
    assert baseline['first_events']['rgb_backpressure']['time_ps'] < baseline['first_events']['overflow']['time_ps']
    # Short internal filter stalls are valid; the contract is no propagated RGB stall or fault.
    assert not set(fixed['first_events']) & {'rgb_backpressure', 'overflow', 'capture_fault', 'owner_fault'}
    assert fixed['final_values']['stalls'] == 0
    source = REPO / 'subprojects/hdmi_input_osd/latency_rtl/axis_binary_dilate9.sv'
    save('latency-prewarm-ab-r01', dict(status='VIDEO_PREFIX_CAUSAL_AB_PASS', board_access=False,
        scope='Fixed-rate first 32 lines, actual generated video IP and production capture, always-ready sinks; full frames and DDR acceptance pending',
        baseline=baseline, fixed=fixed, changed_source=str(source),
        changed_source_sha256=hashlib.sha256(source.read_bytes()).hexdigest()))
    print('VIDEO_PREFIX_CAUSAL_AB_PASS', baseline['first_events']['overflow']['time_ps'])


if __name__ == '__main__':
    main()
