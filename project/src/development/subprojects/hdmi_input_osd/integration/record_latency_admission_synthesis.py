"""Preserve completed admission synthesis logs/checkpoints and verify source identity.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/record_latency_admission_synthesis.py
Outputs: build/hosd/c0e/admission-r01/synthesis-r01 and evidence/latency-admission-synthesis-r01.json.
Next: implement the independent run, then audit actual timing, CDC, route and resources.
No board access. Top synthesis is hierarchical with black boxes: its zero-LUT count is not device usage.
"""
import hashlib
import json
from pathlib import Path
import re
import shutil

from board_common import REPO, save


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    build = REPO / 'build/hosd/c0e/admission-r01'
    out = build / 'synthesis-r01'
    assert not out.exists()
    gate = json.loads((build / 'offline-gates.json').read_text())
    assert gate['status'] == 'ADMISSION_OFFLINE_GATES_PASS'
    base = Path('E:/vvl/c0e/c6_latency.runs')
    runs = {'lifecycle':base/'c6v_capture_lifecycle_0_synth_1', 'top':base/'synth_admission_r01'}
    texts = {name:(root/'runme.log').read_text() for name,root in runs.items()}
    for name, text in texts.items():
        assert 'synth_design completed successfully' in text and 'ERROR:' not in text and 'CRITICAL WARNING:' not in text
    for name, digest in gate['candidate_sources'].items():
        path = build/'source'/name
        assert sha(path) == digest
        assert path.as_posix() in texts['lifecycle'], ('not read by synthesis', name)
    out.mkdir()
    copied = {}
    for name, root in runs.items():
        for source in root.iterdir():
            if source.name == 'runme.log' or source.suffix in ('.tcl','.dcp') or source.name.endswith('_utilization_synth.rpt'):
                target = out/(name+'-'+source.name)
                shutil.copyfile(source,target)
                copied[target.name] = sha(target)
    util = (runs['lifecycle']/'c6v_capture_lifecycle_0_utilization_synth.rpt').read_text()
    def resource(label):
        pattern = r'^\|\s*'+re.escape(label)+r'\s*\|\s*(\d+(?:\.\d+)?)\s*\|'
        match = re.search(pattern,util,re.M)
        assert match, label
        return float(match.group(1))
    record = dict(status='ADMISSION_SYNTHESIS_SOURCE_IDENTITY_PASS', board_access=False,
                  candidate_timing_verified=False, source_sha256=gate['candidate_sources'],
                  files=copied, top_warnings=texts['top'].count('WARNING:'),
                  lifecycle_warnings=texts['lifecycle'].count('WARNING:'),
                  lifecycle_ooc_resources={key:resource(key) for key in ('Slice LUTs*','Slice Registers','Block RAM Tile','DSPs')},
                  resource_scope='Lifecycle OOC synthesis only; not a placed-resource delta against the parent.')
    save('latency-admission-synthesis-r01',record)
    print(record['status'],record['lifecycle_ooc_resources'])


if __name__ == '__main__':
    main()
