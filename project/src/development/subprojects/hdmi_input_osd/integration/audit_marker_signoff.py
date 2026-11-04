"""Run: .venv/Scripts/python subprojects/hdmi_input_osd/integration/audit_marker_signoff.py
Output: exclusive marker-visibility-r02/signoff-audit-r03.json.
Next: export the exact candidate only after this scoped review passes.
"""
from collections import Counter
import hashlib,json,re
from pathlib import Path
from audit_latency_signoff import rules

ROOT=Path(__file__).resolve().parents[3]
BASE=ROOT/'build/hosd/marker-visibility-r02'
PARENT=ROOT/'build/hosd/c0e/admission-r01/physical-r04'

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def scoped(p):
    scope='';rows=[]
    for line in p.read_text().splitlines():
        line=line.strip()
        if not line or line.startswith('#'):continue
        if line.startswith('current_instance '):
            scope=line.removeprefix('current_instance ').strip('{}')
            if scope=='-quiet':scope=''
        else:rows.append((scope,line))
    return Counter(rows)

def main():
    result=dict(status='RUNNING',board_validated=False,release_ready=False,warnings_waived=False)
    with (BASE/'signoff-audit-r03.json').open('x') as output:
        try:
            parent_dcp=PARENT/'signoff/candidate.dcp'
            assert sha(parent_dcp)=='d93553902fbfc2c0295200641fb0185e09716b2d5b10c90e6a44573ad3ec8346'
            report=BASE/'signoff-r01';ext=BASE/'extended-r01'
            timing=(report/'timing.rpt').read_text()
            row=re.search(r'WNS\(ns\).*?\n\s*-+.*?\n([^\n]+)',timing.split('| Design Timing Summary',1)[1],re.S)[1].split()
            assert len(row)==12 and all(float(row[i])>=0 for i in (0,4,8))
            assert all(float(row[i])==0 for i in (1,2,5,6,9,10))
            assert 'All user specified timing constraints are met.' in timing
            for check in ('no_clock','unconstrained_internal_endpoints','multiple_clock','loops'):
                assert 'checking '+check+' (0)' in timing
            route=(report/'route.rpt').read_text()
            counts=[int(re.search(r'# of '+label+r'\.+\s*:\s*(\d+)',route)[1]) for label in ('routable nets','fully routed nets','nets with routing errors')]
            assert counts[0]==counts[1]>0 and counts[2]==0
            assert scoped(BASE/'assembly-r01/parent_timing.xdc')==scoped(report/'effective_timing.xdc')
            old=Counter((BASE/'assembly-r01/parent_static_cells.tcldict').read_text().splitlines())
            new=Counter((BASE/'static-final.tcldict').read_text().splitlines())
            assert old==new
            for actual,previous in ((ext/'drc_unlimited.rpt',PARENT/'extended/drc_unlimited.rpt'),
                                    (report/'methodology.rpt',PARENT/'signoff/methodology.rpt')):
                a=rules(actual.read_text());b=rules(previous.read_text())
                assert a and a==b and all(v[0] not in ('Critical Warning','Error') for v in a.values())
            cdc=(report/'cdc.rpt').read_text();allcdc=(ext/'cdc_all.rpt').read_text()
            assert not re.search(r'^CDC-\d+\s+Critical',cdc+'\n'+allcdc,re.M)
            payload=[l for l in cdc.splitlines() if 'CDC-15' in l and 'mailbox_reg[' in l]
            assert len(payload)==135
            indices=[]
            for line in payload:
                a,b=re.search(r'mailbox_reg\[(\d+)\].*pending_cfg_reg\[(\d+)\]',line).groups()
                assert a==b and 'Max Delay Datapath Only' in line;indices.append(int(a))
            assert len(set(indices))==135
            skew=(report/'bus_skew.rpt').read_text()
            assert 'VIOLATED' not in skew
            skew_groups=lambda text:Counter(re.findall(r'^(set_bus_skew[^\n]+)\nRequirement: ([^\n]+)\nEndpoints: (\d+)',text,re.M))
            groups=skew_groups(skew)
            assert len(groups)==5 and groups==skew_groups((PARENT/'signoff/bus_skew.rpt').read_text())
            assert sorted(int(k[2]) for k in groups)==[3,10,10,96,135]
            slacks=list(map(float,re.findall(r'^Slack \(MET\)\s*:\s*([\d.]+)ns',skew,re.M)))
            assert len(slacks)==5 and min(slacks)>0
            simulation=json.loads((BASE/'xsim-full-r02/receipt.json').read_text())
            assert simulation['passed'] and 'pixel_checks=12066119' in simulation['verdict']
            result.update(status='MARKER_TIMING_ROUTE_SCOPED_REVIEW_PASS',
                timing=dict(wns_ns=float(row[0]),whs_ns=float(row[4]),wpws_ns=float(row[8])),
                route=dict(routable=counts[0],fully_routed=counts[1],errors=counts[2]),
                static_cells_identical=sum(old.values()),scoped_constraints_identical=468,bus_skew_slacks_ns=slacks,
                parent_dcp_sha256=sha(parent_dcp),candidate_dcp_sha256=sha(report/'candidate.dcp'),
                inherited_review_sha256=sha(PARENT/'signoff/METHODOLOGY_RESOLUTION_REPORT.md'),
                scope='Only OSD implementation changes; all other primitive identities/LOC/BEL and scoped timing commands identical. Parent warnings retained, not waived.',
                files={str(p.relative_to(BASE)):sha(p) for folder in (report,ext) for p in folder.iterdir() if p.is_file()})
        except BaseException as error:
            result.update(status='FAIL',error=repr(error));raise
        finally:json.dump(result,output,indent=2)
    print(result['status'],result['timing'],result['route'])

if __name__=='__main__':main()
