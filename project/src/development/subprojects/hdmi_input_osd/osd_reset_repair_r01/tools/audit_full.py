"""Audit the complete OSD-reset repair against the frozen routed R21.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/audit_full.py --candidate build/hosd/osd-reset-r01/route-vcc-r01 --output build/hosd/osd-reset-r01/full-audit-r01.json
Output: exclusive JSON receipt with full-design routing, timing, CDC, DRC, static and constraint comparison.
Next: write a new bitstream only after OSD_RESET_FULL_SIGNOFF_PASS.
"""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[4]
sys.path.insert(0, str(ROOT / 'subprojects/hdmi_input_osd/integration'))
from audit_latency_signoff import rules  # noqa: E402

PARENT = ROOT / 'build/hosd/marker-visibility-r02'
ASSEMBLY = ROOT / 'build/hosd/osd-reset-r01/full-r01'


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def scoped(path: Path) -> Counter:
    scope = ''
    rows = []
    for line in path.read_text(encoding='utf-8').splitlines():
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        if line.startswith('current_instance '):
            scope = line.removeprefix('current_instance ').strip('{}')
            if scope == '-quiet':
                scope = ''
        else:
            rows.append((scope, line))
    return Counter(rows)


def skew_groups(path: Path) -> Counter:
    return Counter(re.findall(r'^(set_bus_skew[^\n]+)\nRequirement: ([^\n]+)\nEndpoints: (\d+)',
                              path.read_text(encoding='utf-8'), re.M))


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    candidate = args.candidate.resolve()
    out = args.output.resolve()
    out.parent.mkdir(parents=True, exist_ok=True)
    result = dict(status='RUNNING', board_validated=False, release_ready=False,
                  warnings_waived=False)
    with out.open('x', encoding='utf-8') as stream:
        try:
            parent_report = PARENT / 'signoff-r01'
            report = candidate / 'signoff'
            ext = candidate / 'extended'
            assert sha(parent_report / 'candidate.dcp') == '0d2e035785da9a93e03990ffdf3a6cb61868ce4af4cf488222516161f44ce3d5'
            assert (candidate / 'routed.dcp').is_file()
            timing = (report / 'timing.rpt').read_text(encoding='utf-8')
            row = re.search(r'WNS\(ns\).*?\n\s*-+.*?\n([^\n]+)', timing.split('| Design Timing Summary', 1)[1], re.S)[1].split()
            assert len(row) == 12 and all(float(row[i]) >= 0 for i in (0, 4, 8)), row
            assert all(float(row[i]) == 0 for i in (1, 2, 5, 6, 9, 10)), row
            assert 'All user specified timing constraints are met.' in timing
            for check in ('no_clock', 'unconstrained_internal_endpoints', 'multiple_clock', 'loops'):
                assert 'checking ' + check + ' (0)' in timing, check
            route = (report / 'route.rpt').read_text(encoding='utf-8')
            counts = [int(re.search(r'# of ' + label + r'\.+\s*:\s*(\d+)', route)[1])
                      for label in ('routable nets', 'fully routed nets', 'nets with routing errors')]
            assert counts[0] == counts[1] > 0 and counts[2] == 0, counts
            original = scoped(ASSEMBLY / 'parent_timing.xdc')
            current = scoped(report / 'effective_timing.xdc')
            assert original == current, 'scoped timing changed'
            old = Counter((ASSEMBLY / 'parent_static_cells.tcldict').read_text().splitlines())
            new = Counter((candidate / 'static-final.tcldict').read_text().splitlines())
            assert old == new, 'non-OSD placement changed'
            for actual, previous in ((ext / 'drc_unlimited.rpt', PARENT / 'extended-r01/drc_unlimited.rpt'),
                                     (report / 'methodology.rpt', parent_report / 'methodology.rpt')):
                a, b = rules(actual.read_text()), rules(previous.read_text())
                assert a and a == b and all(v[0] not in ('Critical Warning', 'Error') for v in a.values())
            cdc = (report / 'cdc.rpt').read_text(encoding='utf-8')
            all_cdc = (ext / 'cdc_all.rpt').read_text(encoding='utf-8')
            assert not re.search(r'^CDC-\d+\s+Critical', cdc + '\n' + all_cdc, re.M)
            payload = [line for line in cdc.splitlines() if 'CDC-15' in line and 'mailbox_reg[' in line]
            assert len(payload) == 135, len(payload)
            indices = []
            for line in payload:
                a, b = re.search(r'mailbox_reg\[(\d+)\].*pending_cfg_reg\[(\d+)\]', line).groups()
                assert a == b and 'Max Delay Datapath Only' in line
                indices.append(int(a))
            assert len(set(indices)) == 135
            skew = (report / 'bus_skew.rpt').read_text(encoding='utf-8')
            assert 'VIOLATED' not in skew
            groups = skew_groups(report / 'bus_skew.rpt')
            assert len(groups) == 5 and groups == skew_groups(parent_report / 'bus_skew.rpt')
            slacks = list(map(float, re.findall(r'^Slack \(MET\)\s*:\s*([\d.]+)ns', skew, re.M)))
            assert len(slacks) == 5 and min(slacks) > 0, slacks
            sim = json.loads((ROOT / 'build/hosd/osd-reset-r01/regression-full-r03/receipt.json').read_text())
            reset = json.loads((ROOT / 'build/hosd/osd-reset-r01/repaired-r04/receipt.json').read_text())
            assert sim['passed'] and reset['passed']
            result.update(status='OSD_RESET_FULL_SIGNOFF_PASS',
                          timing=dict(wns_ns=float(row[0]), whs_ns=float(row[4]), wpws_ns=float(row[8])),
                          route=dict(routable=counts[0], fully_routed=counts[1], errors=counts[2]),
                          static_cells_identical=sum(old.values()), scoped_constraints_identical=sum(original.values()),
                          bus_skew_slacks_ns=slacks, parent_dcp_sha256=sha(parent_report / 'candidate.dcp'),
                          candidate_dcp_sha256=sha(report / 'candidate.dcp'),
                          files={str(p.relative_to(candidate)): sha(p) for folder in (report, ext)
                                 for p in folder.iterdir() if p.is_file()})
        except BaseException as error:
            result.update(status='FAIL', error=repr(error))
            raise
        finally:
            json.dump(result, stream, indent=2)
    print(result['status'], result['timing'], result['route'])


if __name__ == '__main__':
    main()
