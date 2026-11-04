"""Verify passive hooks against an explicitly selected frozen game candidate.
Run: hand-python -I -B tools/verify_bound_bridge.py --candidate PATH --output NEW.json
Outputs: JSON/log and exact runtime/bridge hashes. Next: ARM + real channel test.
No real serial/socket connection, Agent, MMIO, image stream or motors.
"""
import argparse
import hashlib
import io
import json
from pathlib import Path
import socket
import sys
import unittest
from unittest.mock import patch

ROOT=Path(__file__).resolve().parents[1]

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    candidate=args.candidate.resolve(strict=True)
    if args.output.exists() or args.output.with_suffix('.log').exists():raise FileExistsError(args.output)
    manifest=json.loads((candidate/'deployment_manifest.json').read_text())
    for name,digest in manifest['sha256'].items():
        if name.startswith('python/'):
            assert hashlib.sha256((candidate/name).read_bytes()).hexdigest().upper()==digest,name
    sys.path[:0]=[str(ROOT/'src'),str(candidate/'python')]
    import serial
    log=io.StringIO()
    with patch.object(serial.Serial,'open',side_effect=AssertionError('REAL_SERIAL_FORBIDDEN')) as opened, \
         patch.object(socket.socket,'connect',side_effect=AssertionError('NETWORK_FORBIDDEN')):
        suite=unittest.defaultTestLoader.discover(str(ROOT/'integration'),pattern='test_runtime_hand_bridge.py')
        result=unittest.TextTestRunner(stream=log,verbosity=2).run(suite)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.with_suffix('.log').write_text(log.getvalue(),encoding='utf-8')
    from pynq_multimodal_game.agent import game_runtime
    assert Path(game_runtime.__file__).resolve()==candidate/'python/pynq_multimodal_game/agent/game_runtime.py'
    files=[ROOT/'src/pynq_usb_hand/game_bridge.py',ROOT/'src/pynq_usb_hand/gesture_consumer.py',
           ROOT/'integration/test_runtime_hand_bridge.py',Path(game_runtime.__file__),
           candidate/'python/pynq_multimodal_game/vision_input.py']
    report=dict(result='FROZEN_GAME_HAND_BRIDGE_PASS' if result.wasSuccessful() else 'FAIL',
                tests=result.testsRun,failures=len(result.failures),errors=len(result.errors),
                real_serial_opens=opened.call_count,hardware_tested=False,runtime_hook_installed_on_board=False,
                source_sha256={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in files})
    with args.output.open('x') as out:json.dump(report,out,indent=2)
    if not result.wasSuccessful() or result.testsRun!=1 or opened.call_count:raise AssertionError(log.getvalue())
    print(report['result'])

if __name__=='__main__':main()
