"""Review the frozen physical-r04 clock tree without creating a Vivado waiver.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/audit_latency_admission_clock.py
Output: exclusive evidence/latency-admission-clock-r01.json.
Next: explicitly supply this receipt to the full physical auditor; no board permission is implied.
"""
import argparse
import hashlib
import json
import re
import tkinter
from pathlib import Path

from audit_latency_signoff import rules
from audit_latency_timing import active_xdc

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
ROOT = REPO / 'build/hosd/c0e/admission-r01/physical-r04'
CANDIDATE = 'd93553902fbfc2c0295200641fb0185e09716b2d5b10c90e6a44573ad3ec8346'
PARENT = '9ca2c562e1bf38864e745553665a15090265c663cc6c825501444fb012598f3f'
BUFFER = 'c6v_i/ps7_0/inst/buffer_fclk_clk_0.FCLK_CLK_0_BUFG'
BUFFERS = [BUFFER, BUFFER + '_replica', BUFFER + '_replica_1', BUFFER + '_replica_2']
PS_CLOCK = 'c6v_i/ps7_0/inst/PS7_i/FCLKCLK[0]'
TC = tkinter.Tcl()  # Data parsing only; never eval the captured Tcl.


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def records(path):
    result = []
    for line in path.read_text().splitlines():
        values = TC.splitlist(line)
        assert len(values) % 2 == 0 and len(set(values[::2])) == len(values) // 2
        result.append(dict(zip(values[::2], values[1::2])))
    return result


def route_paths(sequence, target, prefix=()):
    path = prefix
    for item in sequence:
        inner = TC.splitlist(item)
        if len(inner) > 1:
            yield from route_paths(inner, target, path)
        else:
            path += (item,)
            if item == target:
                yield path


def validate_topology(rows):
    assert rows[0] == dict(candidate_sha256=CANDIDATE, tool='2026.1', part='xc7z020clg400-1')
    cells = [r for r in rows if 'cell' in r]
    assert [r['cell'] for r in cells] == BUFFERS
    for index, row in enumerate(cells):
        assert row['ref'] == 'BUFG'
        assert row['loc'] == 'BUFGCTRL_X0Y' + str([16, 31, 30, 29][index])
        assert row['input_drivers'] == (BUFFERS[index + 1] + '/O' if index < 3 else PS_CLOCK)
        assert row['output_clock'] == 'clk_fpga_0'
        assert row['route_status'] == 'ROUTED' and row['route_fixed'] == '0'
        assert row['clock_dedicated_route'] == '', 'explicit clock route override'
        assert int(row['loads']) == [51298, 7, 8, 7][index]
    routes = {r['route_for']: r['route'] for r in rows if 'route_for' in r}
    assert set(routes) == set(BUFFERS)
    dedicated = {}
    for index, source, destination in ((1, 15, 0), (2, 14, 15), (3, 13, 14)):
        tile = 'CLK_BUFG_TOP_R_X87Y53/'
        expected = (tile + f'CLK_BUFG_BUFGCTRL{source}_O',
                    tile + f'CLK_BUFG_R_FBG_OUT{source}',
                    tile + f'CLK_BUFG_BUFGCTRL{destination}_I0')
        assert list(route_paths(TC.splitlist(routes[BUFFERS[index]]), expected[-1])) == [expected], 'non-dedicated cascade'
        dedicated[BUFFERS[index]] = list(expected)
    payload = 'c6v_i/vision_gp0_slice/inst/ar.ar_pipe/m_payload_i_reg'
    rgb = 'c6v_i/capture_write_pair/inst/rgb/byte_count_reg'
    dma = 'c6v_i/moments_dma/U0/'
    expected_groups = [
        {rgb + f'[{i}]' for i in (44, 5, 6, 7)} | {
            dma + 'GEN_SG_ENGINE.I_SG_ENGINE/I_SG_AXI_DATAMOVER/GEN_MM2S_BASIC.I_MM2S_BASIC_WRAPPER/I_RESET/sig_cmd_stat_rst_user_reg_n_cdc_from_reg',
            dma + 'I_RST_MODULE/GEN_RESET_FOR_S2MM.RESET_I/GEN_ASYNC_RESET.scndry_resetn_reg'},
        {payload + f'[{i}]' for i in (21, 24, 25, 26, 27, 28, 29)},
        {payload + f'[{i}]' for i in (18, 19, 30, 31, 38, 39)},
    ]
    load_rows = [r for r in rows if 'load_pins_for' in r]
    assert [r['load_pins_for'] for r in load_rows] == BUFFERS[1:]
    for index, (row, group) in enumerate(zip(load_rows, expected_groups)):
        pins = TC.splitlist(row['pins'])
        assert len(pins) == len(set(pins))
        assert set(pins) == {cell + '/C' for cell in group} | {BUFFERS[index] + '/I'}
    sequential = [r for r in rows if 'sequential' in r]
    assert len(sequential) == 19 and {r['sequential'] for r in sequential} == set.union(*expected_groups)
    assert all(r['ref'] == 'FDRE' and r['clocks'] == 'clk_fpga_0' for r in sequential)
    return dict(dedicated_cascade_routes=dedicated, branch_sequential_cells=sorted(set.union(*expected_groups)))


def timing_row(path):
    text = path.read_text()
    summary = text.split('| Design Timing Summary', 1)[1]
    row = list(map(float, re.search(r'WNS\(ns\).*?\n\s*-+.*?\n([^\n]+)', summary, re.S)[1].split()))
    assert len(row) == 12 and row[0] == .002 and row[4] == .049
    assert all(row[i] == 0 for i in (1, 2, 5, 6, 9, 10)) and row[8] == .538
    assert 'All user specified timing constraints are met.' in summary
    for check in ('no_clock', 'unconstrained_internal_endpoints', 'multiple_clock', 'loops'):
        assert 'checking ' + check + ' (0)' in text
    return row


def review(root=ROOT):
    assert root.resolve() == ROOT.resolve(), 'review applies only to frozen physical-r04'
    directory, ext, signoff = root / 'clock-review-r01', root / 'extended', root / 'signoff'
    inputs = []

    def use(path):
        inputs.append(path)
        return path

    assert sha(use(signoff / 'candidate.dcp')) == CANDIDATE
    topology_path = use(directory / 'topology.tcldict')
    facts = validate_topology(records(topology_path))
    parent_path = use(HERE / 'evidence/latency-prewarm-signoff-r01.json')
    parent = json.loads(parent_path.read_text())
    assert parent['status'] == 'C0E_TIMING_ROUTE_AND_SCOPED_REVIEW_PASS'
    assert sha(use(REPO / 'build/hosd/c0e/prewarm-r01/signoff/candidate.dcp')) == PARENT
    old = records(use(root.parent / 'diagnostic-r01/parent_clock_topology.tcldict'))
    assert old[0]['sha256'] == PARENT
    assert [r['cell'] for r in old[1:]] == BUFFERS[:2]
    assert old[1]['input_drivers'] == BUFFER + '_replica/O'
    assert old[2]['input_drivers'] == PS_CLOCK
    previous = records(use(ext / 'fclk_topology.tcldict'))[0]
    assert previous == dict(candidate_sha256=CANDIDATE, clock='clk_fpga_0', period='10.000', waveform='0.000 5.000')
    assert timing_row(use(directory / 'timing.rpt')) == timing_row(use(signoff / 'timing.rpt'))
    route = use(directory / 'route.rpt').read_text()
    for label, expected in (('routable nets', 75210), ('fully routed nets', 75210), ('nets with routing errors', 0)):
        assert int(re.search(r'# of ' + label + r'\.+\s*:\s*(\d+)\b', route)[1]) == expected
    xdc = active_xdc(use(signoff / 'effective_timing.xdc'))
    assert len(xdc) == 1327 and xdc == active_xdc(use(directory / 'effective_timing.xdc'))
    assert xdc == active_xdc(use(root.parent / 'opt-review-r02/effective_timing.xdc'))
    drc_path = use(ext / 'drc_unlimited.rpt')
    actual = rules(drc_path.read_text())
    expected = {k: tuple(v) for k, v in parent['drc_unlimited'].items()}
    assert expected['PLBUFGOPT-1'] == ('Warning', 1)
    expected['PLBUFGOPT-1'] = ('Warning', 3)
    assert actual == expected and not any(v[0] in ('Error', 'Critical Warning') for v in actual.values())
    pairs = re.findall(r'A non-muxed BUFG (\S+) is driven by another global buffer (\S+)\.', drc_path.read_text())
    assert pairs == list(zip(BUFFERS[:3], BUFFERS[1:]))
    assert rules(use(signoff / 'methodology.rpt').read_text()) == {k: tuple(v) for k, v in parent['methodology'].items()}
    branch_minima = {}
    for branch in range(1, 4):
        for direction in ('from', 'to'):
            path = use(ext / f'fclk_branch{branch}_{direction}.rpt')
            text = path.read_text()
            slacks = re.findall(r'Slack \(([^)]+)\)\s*:\s*(-?[\d.]+)ns', text)
            assert len(slacks) == 20 and all(state == 'MET' and float(value) >= 0 for state, value in slacks)
            assert set(re.findall(r'clocked by (\S+)', text)) == {'clk_fpga_0'}
            branch_minima[path.name] = min(float(value) for _, value in slacks)
    # Preserve the exact collector and native transcript that produced these facts.
    use(directory / 'collect_latency_admission_clock.tcl')
    use(directory / 'session.log')
    facts.update(status='ADMISSION_CLOCK_TREE_SCOPED_REVIEW_PASS', candidate_sha256=CANDIDATE,
                 parent_sha256=PARENT, accepted_drc={k: list(v) for k, v in actual.items()},
                 branch_report_min_slacks_ns=branch_minima, warnings_waived=False,
                 board_validated=False, release_ready=False,
                 scope='Only this frozen DCP: two added dedicated BUFG cascade edges; all raw warnings remain.',
                 files={str(path.relative_to(REPO)): sha(path) for path in inputs},
                 reviewer_sha256=sha(Path(__file__)))
    return facts


def verify_receipt(root, receipt):
    saved = json.loads(receipt.read_text())
    assert saved == review(root), 'clock evidence or reviewed candidate changed'
    return dict(receipt=str(receipt.relative_to(REPO)), sha256=sha(receipt),
                candidate_sha256=saved['candidate_sha256'], accepted_drc=saved['accepted_drc'])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--receipt', type=Path, default=HERE / 'evidence/latency-admission-clock-r01.json')
    args = parser.parse_args()
    result = review()
    with args.receipt.open('x', encoding='utf-8') as out:
        json.dump(result, out, indent=2)
        out.write('\n')
    print(result['status'], result['branch_report_min_slacks_ns'])


if __name__ == '__main__':
    main()
