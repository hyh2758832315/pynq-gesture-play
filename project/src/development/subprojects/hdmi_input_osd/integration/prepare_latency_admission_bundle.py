"""Build and verify the offline R20 hardware bundle without contacting hardware.

Run: .venv/Scripts/python.exe -E -B subprojects/hdmi_input_osd/integration/prepare_latency_admission_bundle.py
Outputs: physical-r04/bundle-r01 and evidence/latency-admission-pair-r01.json.
Next: freeze unchanged R19 runtime plus this paired hardware in a new R20 package.
"""
import json
import runpy
import shutil
import zipfile
from pathlib import Path
from verify_latency_admission_export import check, ROOT, HERE, REPO, sha

PARENT_NAME = 'c6i-pl-vision-volume-osd-r19-latest-20261023'
PARENT_SHA = '98d7dfc5d9b91fe07a53fe5733f10c937623fab68b2090c51be74c515888ee97'


def main():
    check()
    parent = REPO / 'deliveries' / (PARENT_NAME + '.zip')
    assert sha(parent) == PARENT_SHA
    verifier_path = REPO / 'deliveries' / PARENT_NAME / 'board/pynq_z2/scripts/verify_vision_integration_sources.py'
    with zipfile.ZipFile(parent) as archive:
        assert archive.read(PARENT_NAME + '/board/pynq_z2/scripts/verify_vision_integration_sources.py') == verifier_path.read_bytes()
    verifier = runpy.run_path(str(verifier_path))
    bundle = ROOT / 'bundle-r01'
    bundle.mkdir(exist_ok=False)
    for name in verifier['CANDIDATE_FILES']:
        source = ROOT / ('export-r02' if name.endswith('.bit') else 'platform-r01' if name.endswith(('.hwh', '.xsa')) else 'signoff') / name
        shutil.copyfile(source, bundle / name)
    shutil.copyfile(ROOT / 'signoff/METHODOLOGY_RESOLUTION_REPORT.md', bundle / 'METHODOLOGY_RESOLUTION_REPORT.md')
    pair = verifier['verify_volume_candidate_bundle'](bundle)
    assert pair['status'] == 'OFFLINE_CANDIDATE_PAIR_PASS' and pair['hwh']['address_segments'] == 38
    assert pair['sha256']['c6v_candidate.bit'].lower() == 'ddab12d94487c01b4b526ed1e73e3bf12efe42301bcce1c0da543e60d6709106'
    assert sha(ROOT / 'platform-r01/run-staged-reviewed.bit') == pair['sha256']['c6v_candidate.bit'].lower()
    assert not Path('E:/vvl/c0e/c6_latency.runs/impl_admission_r01/c6v_wrapper.bit').exists()
    sources = lambda path: {Path(s).resolve() for s in path.read_text().splitlines() if s}
    assert sources(ROOT / 'project_synthesis_files.txt') == sources(ROOT / 'platform-r01/project_sources.txt')
    pair.update(board_access=False, bundle=str(bundle), parent_archive_sha256=PARENT_SHA,
                physical_review_sha256=sha(HERE / 'evidence/latency-admission-physical-r04-reviewed-r02.json'),
                export_review_sha256=sha(HERE / 'evidence/latency-admission-bit-export-r02.json'),
                platform_files={p.name: sha(p) for p in (ROOT / 'platform-r01').iterdir() if p.is_file()},
                preparer_sha256=sha(Path(__file__)))
    with (HERE / 'evidence/latency-admission-pair-r01.json').open('x', encoding='utf-8') as stream:
        json.dump(pair, stream, indent=2)
        stream.write('\n')
    print(pair['status'], pair['build_id'], pair['hwh']['address_segments'], pair['xsa_contents_match'])


if __name__ == '__main__':
    main()
