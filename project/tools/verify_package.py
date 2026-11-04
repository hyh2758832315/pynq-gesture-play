"""Run: python -B tools/verify_package.py. Output: hash verdict; next: check_runtime.py.

Read-only verification; never connects to the board. Generated files created by a
later Vivado/Studio run are permitted, while every sealed input must stay exact.
"""
import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
if sys.platform == 'win32' and not str(ROOT).startswith('\\\\?\\'):
    ROOT = Path('\\\\?\\' + str(ROOT))

def main():
    manifest = json.loads((ROOT/'manifest.json').read_text('utf-8'))
    failures = []
    for name, item in manifest['files'].items():
        path = (ROOT/name).resolve()
        if not path.is_relative_to(ROOT) or not path.is_file():
            failures.append(name)
            continue
        with path.open('rb') as stream:
            digest = hashlib.file_digest(stream, 'sha256').hexdigest()
        if digest != item['sha256'] or path.stat().st_size != item['bytes']:
            failures.append(name)
    print(json.dumps({'result':'FAIL' if failures else 'PASS', 'files':len(manifest['files']), 'failures':failures}, ensure_ascii=False))
    return bool(failures)

if __name__ == '__main__':
    raise SystemExit(main())
