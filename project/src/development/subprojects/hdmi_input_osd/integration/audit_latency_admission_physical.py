"""Offline physical signoff gate for the source-bound admission candidate.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/audit_latency_admission_physical.py
Output: exclusive evidence/latency-admission-physical-r01.json (PASS or preserved FAIL).
Next: export/package only after PASS; board use additionally needs current Copilot release.
"""
import argparse
import hashlib
import json
import re
from pathlib import Path
from audit_latency_timing import active_xdc
from audit_latency_signoff import rules

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
BUILD = REPO / 'build/hosd/c0e/admission-r01'


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def load(p):
    return json.loads(p.read_text(encoding='utf-8'))


def constraint_review(report, ext):
    opt = BUILD / 'opt-review-r02'
    gate = load(HERE / 'evidence/latency-admission-opt-r01.json')
    assert gate['status'] == 'ADMISSION_OPT_CONSTRAINT_DELTA_PASS'
    assert gate['files']['effective_timing.xdc'] == sha(opt / 'effective_timing.xdc')
    old, new = active_xdc(opt / 'effective_timing.xdc'), active_xdc(report / 'effective_timing.xdc')
    assert len(old) == len(new) == 1327
    scopes = gate['inherited_reset_aliases']
    proof = (ext / 'reset_scope_aliases.tcldict').read_text()
    release = (ext / 'release_cdc.tcldict').read_text()
    digest = sha(report / 'candidate.dcp')
    assert re.search(r'candidate_sha256 ([0-9a-f]{64})', proof)[1] == digest
    assert re.search(r'candidate_sha256 ([0-9a-f]{64})', release)[1] == digest
    for scope in scopes:
        assert '{scope ' + scope + ' no_traverse ' + scope + '/src_arst normal ' + scope + '/src_arst equal 1}' in proof
    added = 'c6v_i/capture_lifecycle/inst/release_credit/video_reset'
    assert 'reset_scope ' + added + ' no_traverse ' + added + '/src_arst normal ' + added + '/src_arst equal 1' in release
    allowed = set(scopes + [added])
    original = 'set_false_path -through [get_ports -scoped_to_current_instance -no_traverse src_arst]'
    replacement = 'set_false_path -through [get_ports -scoped_to_current_instance src_arst]'
    changed = []
    for i, (a, b) in enumerate(zip(old, new)):
        if a == b:
            continue
        assert a == original and b == replacement and i > 0
        assert old[i - 1] == new[i - 1] and old[i - 1].startswith('current_instance ')
        scope = old[i - 1].removeprefix('current_instance ')
        assert scope in allowed
        changed.append(scope)
    assert len(changed) == len(set(changed))
    assert release.count('async_reg 1 clock vid_pclk') == 9
    paths = re.findall(r'requirement 10.000 slack (-?[\d.]+)', release)
    assert len(paths) == 3 and min(map(float, paths)) >= 0
    return dict(inherited_opt_gate_sha256=sha(HERE / 'evidence/latency-admission-opt-r01.json'),
                proven_selector_spelling_changes=changed, release_max_delay_slacks_ns=list(map(float, paths)))


def osd_payload_indices(cdc):
    # Six 32-bit words; synthesis removes reserved bits, not a contiguous 135-bit vector.
    expected = set(range(4)) | set(range(32, 43)) | set(range(48, 58))
    expected |= set(range(64, 74)) | set(range(80, 90)) | set(range(96, 106)) | set(range(112, 192))
    payload = [line for line in cdc.splitlines() if 'CDC-15' in line and 'mailbox_reg[' in line]
    assert len(payload) == 135
    indices = []
    for line in payload:
        a, b = re.search(r'mailbox_reg\[(\d+)\].*pending_cfg_reg\[(\d+)\]', line).groups()
        assert a == b and 'Max Delay Datapath Only' in line
        indices.append(int(a))
    assert len(set(indices)) == 135 and set(indices) == expected
    return sorted(indices)


def osd_payload_review(cdc, parent):
    baseline = REPO / 'build/hosd/c0e/prewarm-r01/signoff/cdc.rpt'
    digest = next(v for k, v in parent['files'].items() if k.replace('\\', '/') == 'signoff/cdc.rpt')
    assert sha(baseline) == digest
    indices = osd_payload_indices(cdc)
    assert indices == osd_payload_indices(baseline.read_text())
    endpoints = lambda text: sorted(re.findall(r'(c6v_i/input_osd_0/inst/impl/ctrl/mailbox_reg\[\d+\]/C)\s+(c6v_i/input_osd_0/inst/impl/ctrl/pending_cfg_reg\[\d+\]/D)', text))
    assert len(endpoints(cdc)) == 135 and endpoints(cdc) == endpoints(baseline.read_text())
    names = {'input_osd_ctrl.sv', 'input_osd_pixels.sv', 'input_osd_top.sv', 'input_osd_axi.sv', 'c6v_input_osd_0_0.dcp'}
    sources = {p: digest for p, digest in parent['synthesis_sources'].items() if Path(p).name in names}
    assert {Path(p).name for p in sources} == names and len(sources) == 5
    assert all(sha(Path(p)) == digest for p, digest in sources.items())
    return dict(parent_cdc_sha256=digest, retained_indices=indices, unchanged_sources=sources)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=BUILD / 'physical-r01')
    parser.add_argument('--receipt', type=Path, default=HERE / 'evidence/latency-admission-physical-r01.json')
    parser.add_argument('--clock-review', type=Path, help='Explicit frozen-DCP clock review receipt; default DRC equality stays strict.')
    args = parser.parse_args()
    root, receipt = args.root.resolve(), args.receipt.resolve()
    assert root.is_relative_to(REPO / 'build/hosd') and receipt.is_relative_to(HERE / 'evidence')
    if receipt.exists():
        raise FileExistsError(receipt)
    report, ext = root / 'signoff', root / 'extended'
    result = dict(status='FAIL', board_access=False, board_validated=False, release_ready=False, warnings_waived=False)
    try:
        timing = (report / 'timing.rpt').read_text()
        summary = timing.split('| Design Timing Summary', 1)[1]
        row = re.search(r'WNS\(ns\).*?\n\s*-+.*?\n([^\n]+)', summary, re.S)[1].split()
        assert len(row) == 12
        result['timing'] = dict(zip(('wns','tns','setup_failing','setup_total','whs','ths','hold_failing','hold_total','wpws','tpws','pulse_failing','pulse_total'), map(float, row)))
        assert all(float(row[i]) >= 0 for i in (0, 4, 8)) and all(float(row[i]) == 0 for i in (1, 2, 5, 6, 9, 10)), 'physical timing failed'
        assert 'All user specified timing constraints are met.' in summary
        for check in ('no_clock', 'unconstrained_internal_endpoints', 'multiple_clock', 'loops'):
            assert 'checking ' + check + ' (0)' in timing
        route = (report / 'route.rpt').read_text()
        counts = [int(re.search(r'# of ' + name + r'\.+\s*:\s*(\d+)\b', route)[1]) for name in ('routable nets', 'fully routed nets', 'nets with routing errors')]
        assert counts[0] == counts[1] > 0 and counts[2] == 0
        result['route'] = dict(zip(('routable', 'fully_routed', 'errors'), counts))
        result['constraints'] = constraint_review(report, ext)
        if (root / 'input_opt.dcp').exists():
            opt_gate = load(HERE / 'evidence/latency-admission-opt-r01.json')
            assert sha(root / 'input_opt.dcp') == opt_gate['files']['candidate.dcp']
        parent = load(HERE / 'evidence/latency-prewarm-signoff-r01.json')
        for key, path in (('drc_unlimited', ext / 'drc_unlimited.rpt'), ('methodology', report / 'methodology.rpt')):
            actual = rules(path.read_text())
            result[key] = actual
            expected = {k: tuple(v) for k, v in parent[key].items()}
            if actual != expected:
                assert key == 'drc_unlimited' and args.clock_review is not None, ('unreviewed report delta', key)
                from audit_latency_admission_clock import verify_receipt
                result['clock_review'] = verify_receipt(root, args.clock_review.resolve())
                expected = {k: tuple(v) for k, v in result['clock_review']['accepted_drc'].items()}
            assert actual == expected, ('unreviewed report delta', key)
            assert not any(v[0] in ('Critical Warning', 'Error') for v in actual.values())
        cdc = (report / 'cdc.rpt').read_text()
        for p in (report / 'cdc.rpt', ext / 'cdc_all.rpt'):
            assert not re.search(r'^CDC-\d+\s+Critical', p.read_text(), re.M)
        assert re.search(r'^CDC-6\s+Warning\s+2\s', cdc, re.M)
        assert re.search(r'^CDC-15\s+Warning\s+135\s', cdc, re.M)
        result['osd_cdc_review'] = osd_payload_review(cdc, parent)
        for source in ('held_budget_reg[95:0]', 'release_credit/source_gray_reg[2:0]'):
            lines = [s for s in cdc.splitlines() if 'CDC-6' in s and source in s]
            assert len(lines) == 1 and 'Max Delay Datapath Only' in lines[0]
        skew = (report / 'bus_skew.rpt').read_text()
        assert 'VIOLATED' not in skew
        assert re.findall(r'^Endpoints: (\d+)', skew, re.M) == ['96', '10', '10', '135', '3']
        slacks = list(map(float, re.findall(r'^Slack \(MET\)\s*:\s*([\d.]+)ns', skew, re.M)))
        assert len(slacks) == 5 and min(slacks) > 0
        result['bus_skew_slacks_ns'] = slacks
        dma = (ext / 'design_identity.tcldict').read_text().splitlines()[1:]
        assert len(dma) >= 32 and all(s.endswith('clocks clk_fpga_0') for s in dma)
        gate = load(BUILD / 'offline-gates.json')
        assert gate['status'] == 'ADMISSION_OFFLINE_GATES_PASS'
        synthesis = load(HERE / 'evidence/latency-admission-synthesis-r01.json')
        assert synthesis['status'] == 'ADMISSION_SYNTHESIS_SOURCE_IDENTITY_PASS'
        assert synthesis['source_sha256'] == gate['candidate_sources']
        for name, digest in synthesis['files'].items():
            assert sha(BUILD / 'synthesis-r01' / name) == digest
        top_dcp = Path('E:/vvl/c0e/c6_latency.runs/synth_admission_r01/c6v_wrapper.dcp')
        assert sha(top_dcp) == synthesis['files']['top-c6v_wrapper.dcp']
        for path, digest in gate['evidence_sha256'].items():
            assert sha(REPO / path) == digest, ('offline evidence changed', path)
        sources = [Path(s) for s in (root / 'project_synthesis_files.txt').read_text().splitlines() if s]
        byname = {}
        for p in sources:
            byname.setdefault(p.name, []).append(p)
        for name, digest in gate['candidate_sources'].items():
            assert byname.get(name) == [BUILD / 'source' / name], ('wrong control source binding', name)
            assert sha(byname[name][0]) == digest
        numeric = load(REPO / 'build/hosd/c0e-prewarm-numeric-r01/receipt.json')
        assert numeric['status'] == 'BGR_FRONTEND_AND_CAPTURE_NUMERIC_PASS'
        matched = {}
        for name, digest in numeric['source_sha256'].items():
            if name in gate['candidate_sources'] or name.startswith('tb_') or name not in byname:
                continue
            assert all(sha(p) == digest for p in byname[name]), ('numeric source mismatch', name)
            assert parent['numeric_production_sources'][name] == digest
            matched[name] = digest
        assert all(name in matched for name in ('axis_binary_dilate9.sv','axis_rgb_mask_frontend.sv','axis_bgr_hsv_skin.sv','vision_source_budget_cdc.sv','vision_frame_owner.sv'))
        result['unchanged_numeric_sources'] = matched
        result['control_sources_separately_simulated'] = gate['candidate_sources']
        result['synthesis_sources'] = {str(p): sha(p) for p in sources}
        util = (report / 'utilization.rpt').read_text()
        resources = {label: float(re.search(r'^\|\s*' + re.escape(label) + r'\s*\|\s*([\d.]+)\s*\|', util, re.M)[1]) for label in ('Slice LUTs', 'Slice Registers', 'Slice', 'Block RAM Tile', 'DSPs')}
        assert resources['Slice'] <= 13300 and resources['Block RAM Tile'] <= 140
        result['resources'] = resources
        result['resource_delta_vs_signed_parent'] = {k: v - parent['resources'][k] for k, v in resources.items()}
        result['files'] = {str(p.relative_to(root)): sha(p) for p in root.rglob('*') if p.is_file()}
        result['status'] = 'ADMISSION_PHYSICAL_AND_SCOPED_REVIEW_PASS'
        result['limits'] = ['No physical board or end-to-end latency acceptance.', 'Inherited camera non-dedicated clock route and I2C timing limitations retained.', 'CDC warnings reviewed, not waived; real DDR service inside an accepted frame remains required.']
    except Exception as exc:
        result['error'] = repr(exc)
        raise
    finally:
        # A failing gate must retain the exact evidence it rejected as well.
        result['files'] = {str(p.relative_to(root)): sha(p) for p in root.rglob('*') if p.is_file()}
        result['auditor_sha256'] = sha(Path(__file__))
        with receipt.open('x', encoding='utf-8') as out:
            json.dump(result, out, indent=2)
            out.write('\n')
    print(result['status'], result['timing'], result['resources'])


if __name__ == '__main__':
    main()
