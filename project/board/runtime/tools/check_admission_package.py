"""Offline package identity and HWH/XSA check; never imports PYNQ or contacts a board.

Run from the extracted package: python -B tools/check_admission_package.py
Output: JSON verdict on stdout. Next: wait for explicit board release, then follow docs/R20_BOARD_PREPARATION.md.
"""
import hashlib
import json
from pathlib import Path
import runpy


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


def main():
    root = Path(__file__).resolve().parents[1]
    manifest = json.loads((root / 'deployment_manifest.json').read_text())
    assert manifest['build_id'] == '0xC0060E00' and not manifest['release_ready'] and manifest['board_pending']
    for name, digest in manifest['sha256'].items():
        path = (root / name).resolve()
        assert path.is_relative_to(root) and path.is_file() and sha(path) == digest
    identity = json.loads((root / 'verification/r19_runtime_identity.json').read_text())
    assert identity['parent_archive_sha256'] == '98d7dfc5d9b91fe07a53fe5733f10c937623fab68b2090c51be74c515888ee97'
    for name, digest in identity['unchanged_files'].items():
        assert sha(root / name) == digest
    verifier = runpy.run_path(str(root / 'board/pynq_z2/scripts/verify_vision_integration_sources.py'))
    pair = verifier['verify_volume_candidate_bundle'](root / 'overlay')
    assert pair['status'] == 'OFFLINE_CANDIDATE_PAIR_PASS'
    assert pair['sha256']['c6v_candidate.bit'] == '10B01F51E3DC184496C94609D895211215045DAC98EFDB41B898277F2A10C72F'
    assert manifest['bit_sha256'] == pair['sha256']['c6v_candidate.bit']
    stage = json.loads((root / 'candidate_stage.json').read_text())
    assert stage['bit_sha256'] == manifest['bit_sha256']
    review = json.loads((root / 'overlay/osd_signoff_review.json').read_text())
    assert review['status'] == 'MARKER_TIMING_ROUTE_SCOPED_REVIEW_PASS'
    assert review['timing']['wns_ns'] == .002 and review['timing']['whs_ns'] == .049
    assert not review['board_validated'] and not review['release_ready']
    print(json.dumps(dict(status='R21_MARKER_PACKAGE_OFFLINE_CHECK_PASS', board_access=False,
                         build_id=pair['build_id'], bit_sha256=pair['sha256']['c6v_candidate.bit'],
                         unchanged_runtime_files=len(identity['unchanged_files']),
                         release_ready=False, board_pending=True)))


if __name__ == '__main__':
    main()
