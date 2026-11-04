"""Normal identity-bound recovery of the faulted R18 owner, without forced reset.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/recover_latency_prewarm.py ACTION --label UNIQUE [--state READONLY_RECEIPT]
Actions: inspect, vision-stop, term, reboot, postboot.
Outputs: immutable local receipts, normal-term/reboot attempt records on the board.
Next: proceed only after a new boot reports recovery_ready, before R19 staging.
"""
import argparse
import json
from pathlib import Path
import sys
from uuid import uuid4

from board_common import HERE, REPO, load, remote, save, inspect_source

BOARD = '/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r18-prewarm-20261023'
LOG = 'var/pl-prewarm-p01'


def binding(state_name):
    state = json.loads(load(state_name)['stdout'])
    owner = state['service_start']
    assert state['service_exit'] is None and owner['boot_id'] == state['boot_id']
    assert Path(owner['command'][3]).as_posix().startswith(BOARD + '/')
    source = f'import json,os,pathlib,signal\nexpected={owner!r}\nroot=pathlib.Path({BOARD!r})/{LOG!r}\n'
    source += '''assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()==expected['boot_id']
assert json.loads((root/'service-start.json').read_text())==expected
assert not (root/'service-exit.json').exists()
process=pathlib.Path('/proc')/str(expected['pid'])
assert process.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==expected['start_ticks']
assert process.joinpath('cmdline').read_bytes().split(bytes([0]))[:-1]==[s.encode() for s in expected['command']]
'''
    return source


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('action', choices=('inspect', 'vision-stop', 'term', 'reboot', 'postboot'))
    parser.add_argument('--label', required=True)
    parser.add_argument('--state')
    args = parser.parse_args()
    assert args.label.startswith('c0e-') and args.label.replace('-', '').isalnum()
    assert not (HERE / 'evidence' / (args.label + '.json')).exists()
    if args.action == 'inspect':
        remote(args.label, inspect_source(current=BOARD, log=LOG))
    elif args.action == 'vision-stop':
        remote(args.label + '-identity', binding(args.state) + "print(json.dumps(expected),flush=True)\n")
        root = REPO / 'deliveries' / Path(BOARD).name
        sys.path.insert(0, str(root / 'python'))
        from pynq_multimodal_game.agent.core import AgentCommand
        from pynq_multimodal_game.agent.transport import AgentClient
        client = AgentClient('192.168.2.99', 8765, source_address='192.168.2.1', timeout=30)
        try:
            client.connect()
            before = client.command(uuid4().hex, AgentCommand.STATUS)
            assert before['snapshot']['build_id'] == 0xC0060E00
            assert before['snapshot']['vision']['state'] == 'FAULT'
            response = client.command(uuid4().hex, AgentCommand.VISION_STOP)
            save(args.label, dict(before=before, response=response, forced=False))
            print(json.dumps(response, ensure_ascii=False))
        finally:
            client.close()
    elif args.action == 'term':
        source = binding(args.state)
        source += f"with (root/{(args.label+'.attempt')!r}).open('x') as out:\n    json.dump(dict(identity=expected,forced=False),out);out.flush();os.fsync(out.fileno())\n"
        source += "print(json.dumps(dict(phase='IDENTITY_BOUND_NORMAL_SIGTERM_ONCE',identity=expected)),flush=True)\nos.kill(expected['pid'],signal.SIGTERM)\n"
        remote(args.label, source, hardware_access=True)
    else:
        import diagnose_latency_board as recovery
        recovery.OLD_BOARD, recovery.OLD_LOG = BOARD, LOG
        recovery.BOARD, recovery.LOG = BOARD, LOG
        if args.action == 'reboot':
            recovery.reboot(args.state, args.label)
        else:
            recovery.postboot(args.label, args.state)


if __name__ == '__main__':
    main()
