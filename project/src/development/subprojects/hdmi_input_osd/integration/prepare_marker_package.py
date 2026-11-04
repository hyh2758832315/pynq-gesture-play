"""Freeze R21 marker hardware with unchanged R20 runtime; no board access.

Run: .venv/Scripts/python subprojects/hdmi_input_osd/integration/prepare_marker_package.py
Output: deliveries/c6i-pl-vision-volume-osd-r21-marker-20261023 and .zip.
Next: independent restore/check-only, current board gate, single cold load.
"""
import argparse,hashlib,json,runpy,shutil,zipfile
from pathlib import Path

REPO=Path(__file__).resolve().parents[3]
PARENT=REPO/'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'
OUT=REPO/'deliveries/c6i-pl-vision-volume-osd-r21-marker-20261023'
BUILD=REPO/'build/hosd/marker-visibility-r02'

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest().upper()

def main():
    global OUT
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-name',default=OUT.name)
    parser.add_argument('--receipt-name',default='package-r01.json')
    options=parser.parse_args()
    assert options.output_name.startswith('c6i-pl-vision-volume-osd-r21-marker') and '/' not in options.output_name and '\\' not in options.output_name
    assert Path(options.receipt_name).name==options.receipt_name
    OUT=REPO/'deliveries'/options.output_name
    assert not OUT.exists() and not OUT.with_suffix('.zip').exists()
    assert not (BUILD/options.receipt_name).exists()
    assert sha(PARENT.with_suffix('.zip')).lower()=='d64e5e7a553f13ef7db04305ea9df902def279b35dbe06c4f7a4427b695cb6d4'
    audit=json.loads((BUILD/'signoff-audit-r03.json').read_text());assert audit['status']=='MARKER_TIMING_ROUTE_SCOPED_REVIEW_PASS'
    shutil.copytree(PARENT,OUT,ignore=lambda directory,names:['overlay'] if Path(directory)==PARENT else [])
    overlay=OUT/'overlay';overlay.mkdir()
    verifier=runpy.run_path(str(PARENT/'board/pynq_z2/scripts/verify_vision_integration_sources.py'))
    for name in verifier['CANDIDATE_FILES']:
        src=BUILD/('platform-r02' if name.endswith(('.hwh','.xsa')) else 'signoff-r01')/name
        if name.endswith('.bit'):src=BUILD/'marker_visibility.bit'
        shutil.copyfile(src,overlay/name)
    shutil.copytree(BUILD/'extended-r01',overlay/'extended-review')
    shutil.copytree(REPO/'subprojects/hdmi_input_osd/marker_visibility_r02/rtl',overlay/'osd-source')
    shutil.copytree(PARENT/'overlay/pl-vision-source',overlay/'pl-vision-source')
    parent_review=PARENT/'overlay/METHODOLOGY_RESOLUTION_REPORT.md'
    shutil.copyfile(parent_review,OUT/'verification/parent-r20-methodology-review.md')
    (overlay/'METHODOLOGY_RESOLUTION_REPORT.md').write_text(
        '# R21 marker scoped review\n\n97,574 non-OSD primitive identities/LOC/BEL and 468 scoped timing commands match R20. '
        'DRC/methodology rule identities, severities and counts match; retained parent clock/camera/I2C limitations apply. '
        'No warnings waived. Parent review is verification/parent-r20-methodology-review.md. '
        'New complete reports and signoff audit are included; real HDMI/CPU/acoustic acceptance pending.\n',encoding='utf-8')
    (overlay/'osd_signoff_review.json').write_text(json.dumps(audit,indent=2))
    pair=verifier['verify_volume_candidate_bundle'](overlay)
    assert pair['status']=='OFFLINE_CANDIDATE_PAIR_PASS' and pair['xsa_contents_match']
    (overlay/'board_test_manifest.json').write_text(json.dumps(pair,indent=2))
    stage=json.loads((OUT/'candidate_stage.json').read_text());stage.update(
        warning='R21 enlarged marker: offline signed and paired. Acoustic input remains unresolved; no physical skill acceptance.',
        timing_review=audit['status'],bit_sha256=pair['sha256']['c6v_candidate.bit'],
        immediate_parent_archive_sha256=sha(PARENT.with_suffix('.zip')).lower())
    (OUT/'candidate_stage.json').write_text(json.dumps(stage,indent=2))
    # The actual start/Agent/game/voice runtime remains exactly the 250-file R19/R20 set.
    identity=json.loads((OUT/'verification/r19_runtime_identity.json').read_text())
    assert len(identity['unchanged_files'])==250
    for name,digest in identity['unchanged_files'].items():assert sha(OUT/name)==digest
    checker=OUT/'tools/check_admission_package.py'
    text=checker.read_text().replace('DDAB12D94487C01B4B526ED1E73E3BF12EFE42301BCCE1C0DA543E60D6709106',pair['sha256']['c6v_candidate.bit'])
    text=text.replace('ADMISSION_PHYSICAL_AND_SCOPED_REVIEW_PASS','MARKER_TIMING_ROUTE_SCOPED_REVIEW_PASS')
    text=text.replace("review['timing']['wns']","review['timing']['wns_ns']").replace("review['timing']['whs']","review['timing']['whs_ns']")
    text=text.replace('R20_PACKAGE_OFFLINE_CHECK_PASS','R21_MARKER_PACKAGE_OFFLINE_CHECK_PASS')
    text=text.replace("    review = json.loads", "    assert manifest['bit_sha256'] == pair['sha256']['c6v_candidate.bit']\n    stage = json.loads((root / 'candidate_stage.json').read_text())\n    assert stage['bit_sha256'] == manifest['bit_sha256']\n    review = json.loads")
    checker.write_text(text,encoding='utf-8')
    (OUT/'R21_MARKER_README.md').write_text(
        '# R21 HDMI marker candidate\n\nNormal radius48px, fist32px; ring6px; center9x9px. RGB #00FF00/#FF0000. '
        'All HDMI modes share the same independent OSD. Fixed3 pixel cycles; no CPU drawing, DSP or BRAM additions. '
        '250 runtime files identical to frozen R20/R19. The audio trigger candidate is not integrated; '
        'near human voice was captured on official Base with both official and frozen project Codec profiles. '
        'Integrated VOL1/PS/skill acceptance remains pending.\n\n'
        'Run `python -B tools/check_admission_package.py` and `python -B start_board_test.py --check-only`. '
        'Before board load, read current ownership records and perform fresh boot/owner/DMA gates. '
        'R20 docs in this archive are historical context; new marker reports and this candidate_stage.json define the current hardware.\n',encoding='utf-8')
    manifest=json.loads((OUT/'deployment_manifest.json').read_text())
    manifest.update(bit_sha256=pair['sha256']['c6v_candidate.bit'],purpose='enlarged-independent-hdmi-marker-r21',
                    immediate_parent_archive_sha256=sha(PARENT.with_suffix('.zip')).lower())
    manifest['sha256']={p.relative_to(OUT).as_posix():sha(p) for p in sorted(OUT.rglob('*')) if p.is_file() and p.name!='deployment_manifest.json' and '__pycache__' not in p.parts}
    (OUT/'deployment_manifest.json').write_text(json.dumps(manifest,indent=2))
    runpy.run_path(str(checker),run_name='__main__')
    with zipfile.ZipFile(OUT.with_suffix('.zip'),'x',compression=zipfile.ZIP_DEFLATED) as archive:
        for p in sorted(OUT.rglob('*')):
            if p.is_file() and '__pycache__' not in p.parts:archive.write(p,OUT.name+'/'+p.relative_to(OUT).as_posix())
    receipt=dict(status='R21_MARKER_PACKAGE_FROZEN',archive_sha256=sha(OUT.with_suffix('.zip')),unchanged_runtime_files=250,
                 bit_sha256=pair['sha256']['c6v_candidate.bit'],xsa_sha256=pair['sha256']['c6v_candidate.xsa'],board_validated=False,release_ready=False)
    (BUILD/options.receipt_name).write_text(json.dumps(receipt,indent=2));print(json.dumps(receipt))

if __name__=='__main__':main()
