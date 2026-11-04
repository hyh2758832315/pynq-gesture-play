"""Run a hash-bound frozen Agent with an observation-only hand subprocess.

Run: hand-python -I -B tools/run_agent_shadow.py --help
Outputs: shadow-directory/{publisher,ready,shadow}.json and child logs.
Next: inspect source identities and pause/expiry; no physical motion is possible.
Use --check-only for PC/source preflight. Real launch requires Linux root, Python
3.10, explicit current boot, two manifest SHA identities and original Agent args.
"""
import argparse
import ast
import hashlib
import json
import os
from pathlib import Path
import runpy
import sys


def verify(root,manifest_name,digest):
    root=root.resolve(strict=True)
    manifest=root/manifest_name
    if hashlib.sha256(manifest.read_bytes()).hexdigest()!=digest.lower():raise ValueError('Manifest identity mismatch')
    entries=json.loads(manifest.read_text())['sha256']
    for name,expected in entries.items():
        path=(root/name).resolve(strict=True)
        if not path.is_relative_to(root) or hashlib.sha256(path.read_bytes()).hexdigest()!=expected.lower():
            raise ValueError('Source identity mismatch: '+name)
        if name.endswith('.py'):ast.parse(path.read_text(encoding='utf-8-sig'),filename=name,feature_version=(3,10))
    return root


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate',type=Path,required=True)
    parser.add_argument('--candidate-manifest-sha',required=True)
    parser.add_argument('--hand-root',type=Path,required=True)
    parser.add_argument('--hand-manifest-sha',required=True)
    parser.add_argument('--hand-python',type=Path,required=True)
    parser.add_argument('--shadow-directory',type=Path,required=True)
    parser.add_argument('--boot-id')
    parser.add_argument('--seconds',type=float,default=60)
    parser.add_argument('--check-only',action='store_true')
    parser.add_argument('agent_args',nargs=argparse.REMAINDER)
    args=parser.parse_args()
    candidate=verify(args.candidate,'deployment_manifest.json',args.candidate_manifest_sha)
    hand=verify(args.hand_root,'source_manifest.json',args.hand_manifest_sha)
    if not args.hand_python.is_file() or args.shadow_directory.exists():raise ValueError('Interpreter and new output directory required')
    sys.path[:0]=[str(hand/'src'),str(candidate/'python')]
    from pynq_usb_hand.game_bridge import GameFeed,install_game_observer
    from pynq_usb_hand.shadow_session import HandShadowSession
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    for module_name,expected in (
            ('pynq_usb_hand.game_bridge',hand/'src/pynq_usb_hand/game_bridge.py'),
            ('pynq_usb_hand.shadow_session',hand/'src/pynq_usb_hand/shadow_session.py'),
            ('pynq_multimodal_game.agent.game_runtime',candidate/'python/pynq_multimodal_game/agent/game_runtime.py')):
        if Path(sys.modules[module_name].__file__).resolve()!=expected:
            raise ImportError('Unexpected runtime origin: '+module_name)
    feed=GameFeed()
    shadow=HandShadowSession(feed,python=args.hand_python,hand_root=hand,output_dir=args.shadow_directory,seconds=args.seconds)
    if args.check_only:
        uninstall=install_game_observer(PackagedGameRuntime,feed);uninstall()
        print('HAND_AGENT_SHADOW_PREFLIGHT_PASS hardware_access=false');return 0
    if (sys.platform!='linux' or getattr(os,'geteuid',lambda:-1)()!=0 or sys.version_info[:2]!=(3,10)
            or not args.boot_id or Path('/proc/sys/kernel/random/boot_id').read_text().strip()!=args.boot_id):
        raise RuntimeError('Explicit current board identity, root and PYNQ Python3.10 required')
    uninstall=install_game_observer(PackagedGameRuntime,feed)
    try:
        shadow.start()
        agent_args=args.agent_args[1:] if args.agent_args[:1]==['--'] else args.agent_args
        sys.argv=[str(candidate/'start_board_test.py'),*agent_args]
        runpy.run_path(str(candidate/'start_board_test.py'),run_name='__main__')
    finally:
        try:uninstall()
        finally:shadow.close()


if __name__=='__main__':raise SystemExit(main())
