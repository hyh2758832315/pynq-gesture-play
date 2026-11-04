"""Bind admission synthesis to exact offline evidence and the signed parent sources.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/verify_latency_admission_gates.py --output build/hosd/c0e-admission-gates-r01.json
Output: exclusive JSON receipt; omission of --output validates without writing.
Next: install_latency_admission.tcl, then separate launch_runs/wait_on_run calls.
This gate does not claim candidate synthesis, timing or board validation.
"""
import argparse
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
CANDIDATE = HERE.parent / 'latency_rtl/admission_r01'


def sha(path):
    value = hashlib.sha256()
    with path.open('rb') as handle:
        for block in iter(lambda: handle.read(1024*1024), b''):
            value.update(block)
    return value.hexdigest()


def load(path):
    return json.loads(path.read_text())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    unit_path = REPO / 'build/hosd/c0e-admission-unit-r01/receipt.json'
    negative_path = REPO / 'build/hosd/c0e-admission-negative-r01/receipt.json'
    model_path = REPO / 'build/hosd/c0e-admission-model-r01.json'
    video_run = REPO / 'build/hosd/c0e-admission-video-r01'
    video_path = video_run / 'receipt.json'
    analysis_path = HERE / 'evidence/latency-admission-video-r01.json'
    parent_path = HERE / 'evidence/latency-prewarm-signoff-r01.json'
    reproduction_path = HERE / 'evidence/latency-credit-starvation-r01.json'
    unit, negative, model = map(load, (unit_path, negative_path, model_path))
    video, analysis, parent, reproduction = map(load, (video_path, analysis_path, parent_path, reproduction_path))
    assert unit['status'] == 'ADMISSION_UNIT_PASS'
    assert negative['status'] == 'ADMISSION_NEGATIVE_CONTROL_REJECTED'
    assert model['status'] == 'ABSTRACT_ADMISSION_MODEL_PASS'
    assert model['source_sha256'] == sha(HERE / 'verify_latency_admission_model.py')
    assert video['status'] == 'ISOLATED_VIDEO_RATE_TEST_TERMINATED' and 'ADMISSION_RECOVERY' in video['verdict']
    assert analysis['status'] == 'ADMISSION_VIDEO_RECOVERY_AND_STOP_PASS'
    assert reproduction['status'] == 'CREDIT_STARVATION_CAUSAL_REPRODUCTION_PASS'
    assert reproduction['defect_fixed'] is False
    assert analysis['receipt_sha256'] == sha(video_path)
    assert analysis['analyzer_sha256'] == sha(HERE / 'analyze_latency_admission_video.py')
    assert analysis['packet_file_sha256'] == sha(video_run / 'accepted-packets.hex')
    assert analysis['waveform']['sha256'] == sha(video_run / 'first-fault.vcd')
    assert [p['frame_id'] for p in analysis['packets']] == [1,2,3,4]
    assert all(p['bytes'] == 460864 and 0 < p['raw_nonzero'] < 230400 for p in analysis['packets'])
    assert video['unit_gate_sha256'] == sha(unit_path)
    assert all(s['returncode'] == 0 for r in (unit, video) for s in r['steps'])
    sources = {p.name: sha(p) for p in sorted(CANDIDATE.glob('*.sv'))}
    assert set(sources) == {'vision_source_admission.sv','vision_capture_lifecycle.sv','vision_release_credit_cdc.sv'}
    for name, digest in sources.items():
        assert digest == unit['sources'][name]['sha256'] == video['source_sha256'][name]
        assert sha(unit_path.parent / name) == digest == sha(video_run / name)
    assert negative['negative_control']['original_sha256'] == sources['vision_source_admission.sv']
    assert negative['negative_control']['mutated_sha256'] != sources['vision_source_admission.sv']
    for name in ('tb_c0e_admission_unit.sv',):
        assert sha(HERE / name) == unit['sources'][name]['sha256'] == negative['sources'][name]['sha256']
    assert sha(HERE / 'tb_c0e_admission_video.sv') == video['testbench_origin']['sha256']
    for path, marker in ((unit_path.parent/'step-2.log','TEST_PASS C0E_ADMISSION_UNIT '),
                         (video_run/'step-2.log','TEST_PASS C0E_VIDEO_RATE_ADMISSION_RECOVERY ')):
        log = path.read_text()
        assert log.count(marker) == 1 and 'Fatal:' not in log and 'FATAL:' not in log
        assert 'ERROR:' not in log and 'CRITICAL WARNING:' not in log
    # Preserve the signed parent's full synthesis inputs; only installation changes
    # the two control source bindings and adds the new CDC source afterward.
    assert parent['status'] == 'C0E_TIMING_ROUTE_AND_SCOPED_REVIEW_PASS'
    for path, digest in parent['synthesis_sources'].items():
        assert sha(Path(path)) == digest, ('parent synthesis source changed', path)
    checkpoint = REPO / 'build/hosd/c0e/prewarm-r01/signoff/candidate.dcp'
    checkpoint_hash = parent['files']['signoff\\candidate.dcp']
    assert sha(checkpoint) == checkpoint_hash
    assert checkpoint_hash == '9ca2c562e1bf38864e745553665a15090265c663cc6c825501444fb012598f3f'
    record = dict(status='ADMISSION_OFFLINE_GATES_PASS', board_access=False, candidate_timing_verified=False,
                  candidate_sources=sources, parent_synthesis_input_count=len(parent['synthesis_sources']),
                  parent_checkpoint=str(checkpoint), parent_checkpoint_sha256=checkpoint_hash,
                  constraints_hook_sha256=sha(HERE/'postopt_latency_admission.tcl'),
                  inherited_hook_sha256=sha(REPO/'build/hosd/c0d/postopt_osd.tcl'),
                  verifier_sha256=sha(Path(__file__)),
                  evidence_sha256={str(p.relative_to(REPO)):sha(p) for p in
                      (unit_path,negative_path,model_path,video_path,analysis_path,parent_path,reproduction_path)})
    if args.output:
        out = args.output.resolve()
        assert out.is_relative_to(REPO/'build/hosd')
        with out.open('x',encoding='utf-8') as handle:
            json.dump(record,handle,indent=2)
    print(record['status'])


if __name__ == '__main__':
    main()
