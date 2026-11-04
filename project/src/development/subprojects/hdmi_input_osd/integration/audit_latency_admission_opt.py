"""Read-only PYNQ-Z2/Vivado 2026.1 optimized admission gate; no board IO.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/audit_latency_admission_opt.py
Output: exclusive evidence/latency-admission-opt-r01.json.
Next: resume impl_admission_r01 placement/route; this is NOT physical signoff.
"""
import hashlib
import json
import re
from pathlib import Path
from audit_latency_timing import active_xdc

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
ROOT = REPO / 'build/hosd/c0e/admission-r01/opt-review-r02'
PARENT = REPO / 'build/hosd/c0e/prewarm-r01/signoff'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    receipt = HERE / 'evidence/latency-admission-opt-r01.json'
    if receipt.exists():
        raise FileExistsError(receipt)
    result = dict(status='FAIL', board_access=False, postroute_signoff=False)
    try:
        parent_audit = json.loads((HERE / 'evidence/latency-prewarm-signoff-r01.json').read_text())
        assert parent_audit['files']['signoff\\candidate.dcp'] == sha(PARENT / 'candidate.dcp')
        old = active_xdc(PARENT / 'effective_timing.xdc')
        new = active_xdc(ROOT / 'effective_timing.xdc')
        proof = (ROOT / 'reset_scope_aliases.tcldict').read_text()
        assert re.search(r'candidate_sha256 ([0-9a-f]{64})', proof)[1] == sha(ROOT / 'candidate.dcp')
        scopes = ['c6v_i/capture_lifecycle/inst/' + s for s in (
            'fence/source_reset', 'admission/source_reset', 'budget/video_reset',
            'budget/processing_reset', 'fence/monitor/video_reset', 'fence/monitor/processing_reset')]
        assert proof.count('{scope ') == 6
        normal = 'set_false_path -through [get_ports -scoped_to_current_instance src_arst]'
        no_traverse = 'set_false_path -through [get_ports -scoped_to_current_instance -no_traverse src_arst]'
        for scope in scopes:
            assert '{scope ' + scope + ' no_traverse ' + scope + '/src_arst normal ' + scope + '/src_arst equal 1}' in proof
            index = old.index('current_instance ' + scope) + 1
            assert old[index] == normal
            old[index] = no_traverse
        reset_block = ['current_instance c6v_i/capture_lifecycle/inst/release_credit/video_reset', no_traverse, 'current_instance -quiet']
        index = new.index(reset_block[0])
        assert new[index:index + 3] == reset_block
        del new[index:index + 3]
        endpoints = r'-from [get_cells -hier -regexp {^c6v_i/capture_lifecycle/inst/release_credit/source_gray_reg\[[0-2]\]$}] -to [get_cells -hier -regexp {^c6v_i/capture_lifecycle/inst/release_credit/gray_meta_reg\[[0-2]\]$}] 10.000'
        additions = ['set_max_delay -datapath_only ' + endpoints, 'set_bus_skew ' + endpoints]
        for line in additions:
            assert new.count(line) == 1
            new.remove(line)
        assert new == old, 'unreviewed inherited constraint delta'
        cdc = (ROOT / 'cdc.rpt').read_text()
        summary = {m[0]: (m[1], int(m[2])) for m in re.findall(r'^CDC-(\d+)\s+(Info|Warning|Critical)\s+(\d+)\s+', cdc, re.M)}
        assert summary == {'3': ('Info', 25), '6': ('Warning', 2), '9': ('Info', 7), '15': ('Warning', 135)}
        assert re.search(r'CDC-6\s+Warning\s+Multi-bit synchronized with ASYNC_REG property\s+3\s+Max Delay Datapath Only\s+c6v_i/capture_lifecycle/inst/release_credit/source_gray_reg\[2:0\]/C\s+c6v_i/capture_lifecycle/inst/release_credit/gray_meta_reg\[2:0\]/D', cdc)
        paths = (ROOT / 'gray-paths.tcldict').read_text()
        assert paths.count('requirement 10.000 async_reg 1') == 3
        assert 'ADMISSION_OPT_GRAY_PATHS_BOUND' in paths
        skew = (ROOT / 'bus_skew.rpt').read_text()
        assert [int(s) for s in re.findall(r'^Endpoints: (\d+)$', skew, re.M)] == [96, 10, 10, 135, 3]
        log = (ROOT / 'implementation-opt.log').read_text()
        for marker in ('C6V_VOLUME_POSTOPT_BASELINE_PASS', 'OSD_POSTOPT_CDC_BOUND_PASS', 'C0E_ADMISSION_RELEASE_GRAY_CDC_BOUND_3_BITS'):
            assert marker in log
        assert '0 Critical Warnings and 0 Errors' in log
        result.update(status='ADMISSION_OPT_CONSTRAINT_DELTA_PASS', cdc_summary=summary,
                      added_constraints=reset_block + additions, inherited_reset_aliases=scopes,
                      files={p.name: sha(p) for p in ROOT.iterdir() if p.is_file()})
    except Exception as exc:
        result['error'] = repr(exc)
        raise
    finally:
        with receipt.open('x', encoding='utf-8') as out:
            json.dump(result, out, indent=2)
            out.write('\n')
    print(result['status'])


if __name__ == '__main__':
    main()
