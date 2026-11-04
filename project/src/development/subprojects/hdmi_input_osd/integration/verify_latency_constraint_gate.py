"""Positive/negative unit fixtures for the six-selector equivalence gate; no FPGA DCP or board access.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/verify_latency_constraint_gate.py
Outputs: build/hosd/c0e-prewarm-constraint-tests-r01 fixtures and evidence/latency-constraint-equivalence-unit-r01.json.
Next: use the real final-DCP-bound proof for hardware signoff; these fixtures never count as hardware validation.
"""
import hashlib
import re
from pathlib import Path
import audit_latency_signoff as audit
from board_common import REPO, save


def main():
    output=REPO/'build/hosd/c0e-prewarm-constraint-tests-r01'
    assert not output.exists()
    output.mkdir()
    baseline=(REPO/'build/hosd/c0e/preroute-r04/results/constraints_before.xdc').read_text()
    actual=(REPO/'build/hosd/c0e/prewarm-r01/signoff/effective_timing.xdc').read_text()
    proof=(REPO/'build/hosd/c0e/prewarm-r01/extended/reset_scope_aliases.tcldict').read_text()
    dummy=b'UNIT_FIXTURE_NOT_AN_FPGA_CHECKPOINT\n'
    sha=hashlib.sha256(dummy).hexdigest()
    proof=re.sub(r'candidate_sha256 [0-9a-f]{64}', 'candidate_sha256 '+sha,proof,count=1)
    fixture_repo=output/'repo'
    path=fixture_repo/'build/hosd/c0e/preroute-r04/results/constraints_before.xdc'
    path.parent.mkdir(parents=True);path.write_text(baseline)
    audit.REPO=fixture_repo

    def change_bound(prefix):
        line=next(line for line in actual.splitlines() if line.startswith(prefix) and '10.000' in line)
        return actual.replace(line,line.replace('10.000','11.000',1),1)

    original='set_false_path -through [get_ports -scoped_to_current_instance -no_traverse src_arst]'
    replacement='set_false_path -through [get_ports -scoped_to_current_instance src_arst]'
    normal=re.search(r'normal (\S+)',proof)[1]
    first_scope='c6v_i/capture_lifecycle/inst/fence/source_reset'
    first_record='{scope '+first_scope+' no_traverse '+first_scope+'/src_arst normal '+first_scope+'/src_arst equal 1}'
    cases=[
        ('literal_exact',baseline,None,True),
        ('six_tool_proven_aliases',actual,proof,True),
        ('clock_changed',actual.replace('create_clock -period 10.000 -name clk_fpga_0','create_clock -period 11.000 -name clk_fpga_0',1),proof,False),
        ('max_delay_changed',change_bound('set_max_delay '),proof,False),
        ('bus_skew_changed',change_bound('set_bus_skew '),proof,False),
        ('missing_statement',actual.replace(next(line for line in actual.splitlines() if line.startswith('set_max_delay ')),'',1),proof,False),
        ('stale_dcp_proof',actual,proof.replace(sha,'f'*64,1),False),
        ('missing_alias_proof',actual,None,False),
        ('missing_proof_record',actual,proof.replace(first_record,'',1),False),
        ('different_resolved_port',actual,proof.replace('normal '+normal,'normal '+normal+'_wrong',1),False),
        ('extra_unproven_scope',actual.replace(original,replacement,1),proof,False),
        ('only_five_text_changes',actual.replace(replacement,original,1),proof,False),
        ('extra_clock_group',actual+'\nset_clock_groups -asynchronous -group [get_clocks clk_fpga_0]\n',proof,False),
    ]
    record=dict(status='RUNNING',unit_fixtures_only=True,board_access=False,cases=[],
                gate_source_sha256=hashlib.sha256(Path(audit.__file__).read_bytes()).hexdigest())
    try:
        assert cases[2][1]!=actual
        for name,text,evidence,expected in cases:
            root=output/name;root.mkdir()
            audit.REPORT=root/'signoff';audit.REPORT.mkdir()
            audit.EXT=root/'extended';audit.EXT.mkdir()
            (audit.REPORT/'effective_timing.xdc').write_text(text)
            (audit.REPORT/'candidate.dcp').write_bytes(dummy)
            if evidence is not None:(audit.EXT/'reset_scope_aliases.tcldict').write_text(evidence)
            accepted=True;error=None
            try:audit.review_xdc()
            except (AssertionError,FileNotFoundError) as failure:
                accepted=False;error=type(failure).__name__
            record['cases'].append(dict(name=name,accepted=accepted,expected=expected,error=error))
            assert accepted==expected,name
        record['status']='CONSTRAINT_EQUIVALENCE_UNIT_FIXTURES_PASS'
    except BaseException as error:
        record.update(status='FAIL',error=repr(error));raise
    finally:save('latency-constraint-equivalence-unit-r01',record)
    print(record['status'],len(cases))


if __name__=='__main__':main()
