"""Run python scripts/verify_handoff.py; verify files only, never access hardware.
Output HANDOFF_HASHES_PASS. Next: docs/QUICKSTART.md software/board checks.
"""
import hashlib
import importlib.util
import json
from pathlib import Path


def main():
    root = Path(__file__).resolve().parents[1]
    manifest = json.loads((root/'handoff_manifest.json').read_text(encoding='utf-8-sig'))
    for name, digest in manifest['sha256'].items():
        path = (root/name).resolve()
        if not path.is_relative_to(root) or not path.is_file():
            raise ValueError(f'missing/unsafe path: {name}')
        if hashlib.sha256(path.read_bytes()).hexdigest().upper() != digest:
            raise ValueError(f'hash mismatch: {name}')
    spec = importlib.util.spec_from_file_location('runtime_package_verifier',root/'runtime/verify_package.py')
    verifier = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(verifier)
    verifier.verify(root/'runtime')
    print(f"HANDOFF_HASHES_PASS files={len(manifest['sha256'])}; no hardware accessed")


if __name__ == '__main__': main()
