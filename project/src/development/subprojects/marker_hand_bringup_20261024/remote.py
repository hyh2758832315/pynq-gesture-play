"""Run an explicit identity-bound board script with an immutable local receipt.

Run: .venv/Scripts/python.exe -I -B subprojects/marker_hand_bringup_20261024/remote.py SOURCE --output build/marker-hand-board-20261024/NEW.json
Outputs: JSON with source, SHA, command, stdout/stderr, elapsed and outcome.
Next: inspect the receipt before the next phase; never retry hardware blindly.
"""
import argparse
import ast
import hashlib
import json
from pathlib import Path
import subprocess
import time


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', required=True, type=Path)
    parser.add_argument('--timeout', type=int, default=45)
    args = parser.parse_args()
    source = args.source.read_text(encoding='utf-8')
    ast.parse(source, feature_version=(3, 10))
    command = ['ssh', '-b', '192.168.2.1', '-o', 'BatchMode=yes', '-o',
               'StrictHostKeyChecking=yes', '-o', 'ConnectTimeout=8', 'pynq-z2',
               'sudo -n /usr/local/share/pynq-venv/bin/python -u -B -']
    receipt = dict(source=source, source_sha256=hashlib.sha256(source.encode()).hexdigest(),
                   command=command, started_unix=time.time())
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open('x', encoding='utf-8') as out:
        try:
            result = subprocess.run(command, input=source, capture_output=True,
                                    text=True, encoding='utf-8', timeout=args.timeout)
            receipt.update(returncode=result.returncode, stdout=result.stdout, stderr=result.stderr)
            print(result.stdout[-7000:], result.stderr[-1800:], flush=True)
            return result.returncode
        except subprocess.TimeoutExpired as error:
            receipt.update(error=repr(error), stdout=(error.stdout or b'').decode(errors='replace'),
                           stderr=(error.stderr or b'').decode(errors='replace'))
            raise
        finally:
            receipt['finished_unix'] = time.time()
            json.dump(receipt, out, ensure_ascii=False, indent=2)


if __name__ == '__main__':
    raise SystemExit(main())
