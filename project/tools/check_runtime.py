"""Check immutable deployed bytes and the exact target without opening hardware.

Run: python -B tools/check_runtime.py
Output: board/runtime manifest SHA and file count. Next: Studio or offline tests.
"""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
board = ROOT / 'board/runtime'
manifest = board / 'deployment_manifest.json'
expected = '77e083bddf389581a3321c56af125aaf7690e37e95e7c34b97001e5c0d88d06a'
assert hashlib.sha256(manifest.read_bytes()).hexdigest() == expected
data = json.loads(manifest.read_text(encoding='utf-8'))
assert data['build_id'] == '0xC0061000'
for name, digest in data['sha256'].items():
    p = (board / name).resolve()
    assert p.is_relative_to(board.resolve()), name
    assert hashlib.sha256(p.read_bytes()).hexdigest() == digest.lower(), name
print(json.dumps(dict(result='PASS',files=len(data['sha256']),manifest_sha256=expected,
                     board_access=False)))
