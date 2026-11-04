"""Run: python -B validation/verify_files.py (from the delivered skill directory).
Output: inventory PASS/FAIL on stdout; exit 0/1. Next: run run_validation.py.
Read-only SHA-256 integrity check; uses only the Python standard library.
"""
from pathlib import Path
import hashlib
import json


def main():
    root = Path(__file__).resolve().parents[1]
    inventory = json.loads((root / 'inventory.json').read_text(encoding='utf-8'))
    failures = []
    for name, expected in inventory['files'].items():
        path = (root / name).resolve()
        if not path.is_relative_to(root) or not path.is_file():
            failures.append(name)
        elif hashlib.sha256(path.read_bytes()).hexdigest() != expected['sha256']:
            failures.append(name)
    print(json.dumps(dict(status='FAIL' if failures else 'PASS',
        files=len(inventory['files']), failures=failures)))
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())
