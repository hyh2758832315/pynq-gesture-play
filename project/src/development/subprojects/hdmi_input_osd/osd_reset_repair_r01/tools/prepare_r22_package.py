"""Freeze an independent R22 OSD reset candidate from the exact R21 package.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/prepare_r22_package.py
Outputs: deliveries/c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024 and .zip;
         build/hosd/osd-reset-r01/package-r01.json.
Next: verify package and current board ownership before one integrated load.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import runpy
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[4]
PARENT = ROOT / 'deliveries/c6i-pl-vision-volume-osd-r21-marker-r02-20261023'
OUT = ROOT / 'deliveries/c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024'
BUILD = ROOT / 'build/hosd/osd-reset-r01'
OVERLAY = OUT / 'overlay'
RECEIPT = BUILD / 'package-r01.json'
BIT_SHA = '507833ade953e9fe33c51cf8ef0c76943026a8b2a3d8ed2ed93aa1c1f2c1cd42'
PARENT_ZIP_SHA = 'b63de36c89c6d5718dc789768335de613bf63bfdf5f5e60774c23a97a3e28c78'


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


def main() -> None:
    assert not OUT.exists() and not OUT.with_suffix('.zip').exists() and not RECEIPT.exists()
    assert sha(PARENT.with_suffix('.zip')).lower() == PARENT_ZIP_SHA
    audit = json.loads((BUILD / 'full-audit-r01.json').read_text())
    assert audit['status'] == 'OSD_RESET_FULL_SIGNOFF_PASS'
    assert sha(BUILD / 'bit-r01/c6v_candidate.bit').lower() == BIT_SHA
    assert sha(BUILD / 'platform-r02/c6v_candidate.hwh') == sha(PARENT / 'overlay/c6v_candidate.hwh')
    assert sha(BUILD / 'platform-r02/run-staged-bit.bit').lower() == BIT_SHA
    assert not Path('E:/vvl/c0e/c6_latency.runs/impl_admission_r01/c6v_wrapper.bit').exists()
    with zipfile.ZipFile(BUILD / 'platform-r02/c6v_candidate.xsa') as new, zipfile.ZipFile(PARENT / 'overlay/c6v_candidate.xsa') as old:
        members = {item.filename: item for item in new.infolist() if not item.is_dir()}
        parent_members = {item.filename: item for item in old.infolist() if not item.is_dir()}
        assert members.keys() == parent_members.keys() and len(members) == 18
        assert new.read('c6v_candidate.bit') == (BUILD / 'bit-r01/c6v_candidate.bit').read_bytes()
        assert new.read('c6v.hwh') == (BUILD / 'platform-r02/c6v_candidate.hwh').read_bytes()
        for name in members:
            if name not in {'c6v_candidate.bit', 'xsa.json', 'xsa.xml'}:
                assert new.read(name) == old.read(name), name

    shutil.copytree(PARENT, OUT)
    verifier = runpy.run_path(str(PARENT / 'board/pynq_z2/scripts/verify_vision_integration_sources.py'))
    for name in verifier['CANDIDATE_FILES']:
        src = (BUILD / 'bit-r01/c6v_candidate.bit' if name.endswith('.bit') else
               BUILD / 'platform-r02' / name if name.endswith(('.hwh', '.xsa')) else
               BUILD / 'route-vcc-r01/signoff' / name)
        shutil.copyfile(src, OVERLAY / name)
    shutil.rmtree(OVERLAY / 'extended-review')
    shutil.copytree(BUILD / 'route-vcc-r01/extended', OVERLAY / 'extended-review')
    shutil.rmtree(OVERLAY / 'osd-source')
    rtl = ROOT / 'subprojects/hdmi_input_osd/osd_reset_repair_r01/rtl'
    (OVERLAY / 'osd-source').mkdir()
    for name in ('input_osd_axi.sv', 'input_osd_ctrl.sv', 'input_osd_pixels.sv', 'input_osd_top.sv'):
        shutil.copyfile(rtl / name, OVERLAY / 'osd-source' / name)
    (OVERLAY / 'osd_signoff_review.json').write_text(json.dumps(audit, indent=2))
    (OVERLAY / 'METHODOLOGY_RESOLUTION_REPORT.md').write_text(
        '# R22 OSD reset repair review\n\nExact R21 static primitive placement, scoped constraints, '
        'DRC/methodology rule counts and severities retained. OSD route reconnected; all 75,267 '
        'routable nets fully routed. WNS +0.002 ns, WHS +0.049 ns. No warnings waived. '
        'See osd_signoff_review.json and extended-review. Integrated board acceptance pending.\n')
    pair = verifier['verify_volume_candidate_bundle'](OVERLAY)
    assert pair['status'] == 'OFFLINE_CANDIDATE_PAIR_PASS' and pair['xsa_contents_match']
    assert pair['sha256']['c6v_candidate.bit'].lower() == BIT_SHA
    (OVERLAY / 'board_test_manifest.json').write_text(json.dumps(pair, indent=2))
    stage = json.loads((OUT / 'candidate_stage.json').read_text())
    stage.update(bit_sha256=pair['sha256']['c6v_candidate.bit'], timing_review=audit['status'],
                 immediate_parent_archive_sha256=PARENT_ZIP_SHA,
                 warning='R22 OSD reset repair: full offline signoff and targeted OSD register board probe passed; full Agent/HDMI/acoustic acceptance pending.')
    (OUT / 'candidate_stage.json').write_text(json.dumps(stage, indent=2))
    identity = json.loads((OUT / 'verification/r19_runtime_identity.json').read_text())
    assert len(identity['unchanged_files']) == 250
    for name, digest in identity['unchanged_files'].items():
        assert sha(OUT / name) == digest, name
    checker = OUT / 'tools/check_admission_package.py'
    check = checker.read_text()
    assert '10B01F51E3DC184496C94609D895211215045DAC98EFDB41B898277F2A10C72F' in check
    check = check.replace('10B01F51E3DC184496C94609D895211215045DAC98EFDB41B898277F2A10C72F', BIT_SHA.upper())
    check = check.replace('MARKER_TIMING_ROUTE_SCOPED_REVIEW_PASS', audit['status'])
    check = check.replace('R21_MARKER_PACKAGE_OFFLINE_CHECK_PASS', 'R22_OSD_RESET_PACKAGE_OFFLINE_CHECK_PASS')
    checker.write_text(check)
    (OUT / 'R22_OSD_RESET_README.md').write_text(
        '# R22 OSD pixel-reset AXI response repair\n\nPYNQ-Z2, Vivado 2026.1, BUILD_ID 0xC0060E00. '
        'When pixel reset is asserted, OSD register responses remain serviced by AXI clock while '
        'published pixel controls clear. Normal HDMI marker is unchanged. Exact R21 runtime: 250 '
        'files identical. XSim reset regression, full OSD regression, routed signoff and a targeted '
        'board ID read passed. Full Agent/HDMI and acoustic acceptance remain pending.\n\n'
        'Run `python -B tools/check_admission_package.py` and '
        '`python -B start_board_test.py --check-only`. Check fresh board ownership before load.\n')
    manifest = json.loads((OUT / 'deployment_manifest.json').read_text())
    manifest.update(bit_sha256=pair['sha256']['c6v_candidate.bit'],
                    purpose='osd-pixel-reset-axi-response-repair-r22',
                    immediate_parent_archive_sha256=PARENT_ZIP_SHA)
    manifest['sha256'] = {p.relative_to(OUT).as_posix(): sha(p) for p in sorted(OUT.rglob('*'))
                          if p.is_file() and p.name != 'deployment_manifest.json' and '__pycache__' not in p.parts}
    (OUT / 'deployment_manifest.json').write_text(json.dumps(manifest, indent=2))
    runpy.run_path(str(checker), run_name='__main__')
    with zipfile.ZipFile(OUT.with_suffix('.zip'), 'x', compression=zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(OUT.rglob('*')):
            if path.is_file() and '__pycache__' not in path.parts:
                archive.write(path, OUT.name + '/' + path.relative_to(OUT).as_posix())
    receipt = dict(status='R22_OSD_RESET_PACKAGE_FROZEN', archive_sha256=sha(OUT.with_suffix('.zip')),
                   bit_sha256=pair['sha256']['c6v_candidate.bit'],
                   xsa_sha256=pair['sha256']['c6v_candidate.xsa'],
                   unchanged_runtime_files=250, xsa_members=len(members),
                   board_probe_passed=True, full_agent_board_validated=False, release_ready=False)
    RECEIPT.write_text(json.dumps(receipt, indent=2))
    print(json.dumps(receipt))


if __name__ == '__main__':
    main()
