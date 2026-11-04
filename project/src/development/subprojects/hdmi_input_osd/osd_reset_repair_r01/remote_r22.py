"""Run one fixed-source PYNQ script, retaining partial output on timeout.

Run: .venv/Scripts/python.exe -I -B remote_r22.py SOURCE --output NEW.json
Output: exclusive JSON receipt with source SHA, stdout/stderr and outcome.
Next: inspect receipt and board state before another hardware operation.
"""
import argparse
import ast
import hashlib
import json
from pathlib import Path
import subprocess
import time


def as_text(value):
    if isinstance(value, bytes):
        return value.decode('utf-8', errors='replace')
    return value or ''


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
    receipt = dict(source_sha256=hashlib.sha256(source.encode()).hexdigest(),
                   command=command, started_unix=time.time())
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open('x', encoding='utf-8') as output:
        try:
            result = subprocess.run(command, input=source, capture_output=True,
                                    text=True, encoding='utf-8', timeout=args.timeout)
            receipt.update(returncode=result.returncode, stdout=result.stdout, stderr=result.stderr)
            print(result.stdout[-7000:], result.stderr[-2000:], flush=True)
            return result.returncode
        except subprocess.TimeoutExpired as error:
            receipt.update(error='remote_timeout', timeout_seconds=args.timeout,
                           stdout=as_text(error.stdout), stderr=as_text(error.stderr))
            print(receipt['stdout'][-7000:], receipt['stderr'][-2000:], flush=True)
            return 124
        finally:
            receipt['finished_unix'] = time.time()
            json.dump(receipt, output, ensure_ascii=False, indent=2)


if __name__ == '__main__':
    raise SystemExit(main())
