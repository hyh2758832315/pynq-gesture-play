"""Revalidate frozen admission signoff immediately before offline bit export.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/verify_latency_admission_export.py
Output: physical-r04/export-r02/preflight.json; --verify-existing rechecks the same receipt.
Next: source export_latency_admission_bit.tcl in owned Vivado; no board access.
"""
import argparse
import json
import os
from pathlib import Path

# Vivado exports its own Tcl library paths. Keep this Python-only parser on its
# interpreter's matching Tcl; do not mutate the parent Vivado process environment.
for variable in ('TCL_LIBRARY', 'TK_LIBRARY', 'TCLLIBPATH'):
    os.environ.pop(variable, None)

from audit_latency_admission_clock import ROOT, CANDIDATE, HERE, REPO, sha, verify_receipt


def check():
    receipt = HERE / 'evidence/latency-admission-physical-r04-reviewed-r02.json'
    review = json.loads(receipt.read_text())
    assert review['status'] == 'ADMISSION_PHYSICAL_AND_SCOPED_REVIEW_PASS'
    assert not review['board_access'] and not review['board_validated'] and not review['release_ready']
    assert review['files']['signoff\\candidate.dcp'] == CANDIDATE
    for name, digest in review['files'].items():
        assert sha(ROOT / name) == digest, ('reviewed evidence changed', name)
    auditor = HERE / 'audit_latency_admission_physical.py'
    assert sha(auditor) == review['auditor_sha256']
    assert sha(ROOT / 'auditor-reviewed-r02.py') == review['auditor_sha256']
    for name, digest in review['synthesis_sources'].items():
        assert sha(Path(name)) == digest, ('synthesis source changed', name)
    clock_receipt = HERE / 'evidence/latency-admission-clock-r01.json'
    assert verify_receipt(ROOT, clock_receipt) == review['clock_review']
    for name, status, key, code in (
        ('latency-admission-osd-cdc-negative-r01.json', 'OSD_CDC_NEGATIVE_CONTROLS_PASS', 'auditor_sha256', sha(auditor)),
        (None, 'CLOCK_REVIEW_NEGATIVE_CONTROLS_PASS', 'reviewer_sha256', sha(HERE / 'audit_latency_admission_clock.py')),
    ):
        path = HERE / 'evidence' / name if name else ROOT / 'clock-review-r01/negative-controls.json'
        controls = json.loads(path.read_text())
        assert controls['status'] == status and controls[key] == code
        assert len(controls['controls']) == (4 if name else 5) and all(item['rejected'] for item in controls['controls'])
    return dict(status='ADMISSION_BIT_EXPORT_PREFLIGHT_PASS', candidate_sha256=CANDIDATE,
                review_sha256=sha(receipt), auditor_sha256=sha(auditor),
                clock_review_sha256=sha(clock_receipt), timing=review['timing'],
                verifier_sha256=sha(Path(__file__)), board_access=False, release_ready=False)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--verify-existing', action='store_true')
    args = parser.parse_args()
    result = check()
    out = ROOT / 'export-r02'
    path = out / 'preflight.json'
    if args.verify_existing:
        assert json.loads(path.read_text()) == result
    else:
        out.mkdir(exist_ok=False)
        with path.open('x', encoding='utf-8') as stream:
            json.dump(result, stream, indent=2)
            stream.write('\n')
    print(result['status'], CANDIDATE)


if __name__ == '__main__':
    main()
