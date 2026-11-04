"""Evidence-only C0E diagnostic deployment; never changes hardware or rejection rules.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/diagnose_latency_board.py ACTION
Actions: verify, reboot, postboot, stage, arm, base, start, ready, inspect.
Outputs: exclusive d02 restoration and c0e-dNN receipts, independent var/pl-diagnostic-d02.
Next: use actual fault words to build a simulation reproducer before any functional repair.
"""
import argparse
import ast
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import zipfile

from board_common import HERE, REPO, load, remote, save, inspect_source

CHILD = REPO / 'deliveries/c6i-pl-vision-volume-osd-r17-20261023-d02'
BOARD = '/home/xilinx/voice-view-game/' + CHILD.name
LOG = 'var/pl-diagnostic-d02'
OLD_BOARD = '/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r17-20261023'
OLD_LOG = 'var/pl-live-b01'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify():
    receipt = HERE / 'evidence/latency-diagnostics-restore-r02.json'
    restored = REPO / 'build/hosd/c0e/diagnostics-restore-d02'
    assert not receipt.exists() and not restored.exists()
    package = load('latency-diagnostics-package-r02')
    archive = CHILD.with_suffix('.zip')
    assert package['status'] == 'DIAGNOSTICS_ONLY_PACKAGE_PASS'
    assert sha(archive) == package['sha256']
    with zipfile.ZipFile(archive) as zipped:
        names = zipped.namelist()
        assert zipped.testzip() is None and len(names) == len(set(names)) == 595
        for name in names:
            assert name.startswith(CHILD.name + '/')
            destination = (restored / name[len(CHILD.name) + 1:]).resolve()
            assert destination.is_relative_to(restored.resolve())
            destination.parent.mkdir(parents=True, exist_ok=True)
            with destination.open('xb') as out:
                out.write(zipped.read(name))
    manifest = json.loads((restored / 'deployment_manifest.json').read_text())
    parent = json.loads((CHILD.with_name(CHILD.name[:-4]) / 'deployment_manifest.json').read_text())
    changed = [name for name, digest in manifest['sha256'].items() if parent['sha256'][name] != digest]
    assert changed == ['board/pynq_z2/vision_dma_pool.py']
    for name, digest in manifest['sha256'].items():
        target = restored / name
        assert sha(target).upper() == digest
        if name.endswith('.py'):
            ast.parse(target.read_text(encoding='utf-8-sig'), filename=name, feature_version=(3, 10))
    for name, digest in package['hardware_sha256'].items():
        assert sha(restored / 'overlay' / name) == digest
    preflights = []
    for options in ([], ['--volume-disable-sampling']):
        command = [sys.executable, '-B', str(restored / 'start_board_test.py'), '--check-only', '--game-controls', *options]
        result = subprocess.run(command, cwd=restored, env=dict(os.environ, PYTHONPATH=str(restored / 'python')),
                                capture_output=True, text=True, timeout=120)
        preflights.append(dict(command=command, returncode=result.returncode, stdout=result.stdout, stderr=result.stderr))
        assert result.returncode == 0, result.stdout + result.stderr
    save(receipt.stem, dict(status='DIAGNOSTICS_RESTORE_SHA_AST_PREFLIGHT_PASS', board_access=False,
                           sha256=sha(archive), restored=str(restored), changed_files=changed, preflights=preflights))
    print('DIAGNOSTICS_RESTORE_SHA_AST_PREFLIGHT_PASS')


def reboot(retained, receipt):
    expected = json.loads(load(retained)['stdout'])
    assert expected['service_exit'] is None and 'VISION_AGENT_RETAINED' in expected['stderr_tail']
    board = str(Path(expected['service_start']['command'][3]).parent).replace('\\', '/')
    assert board in (OLD_BOARD, BOARD)
    log = OLD_LOG if board == OLD_BOARD else LOG
    assert receipt.replace('-', '').isalnum() and receipt.startswith('c0e-')
    source = 'import contextlib,io,json,os,pathlib,subprocess\nbuffer=io.StringIO()\nwith contextlib.redirect_stdout(buffer):\n    exec(compile(' + repr(inspect_source(current=board, log=log)) + ",'<readonly>','exec'),{})\nstate=json.loads(buffer.getvalue())\n"
    binding = {key: expected[key] for key in ('boot_id', 'service_start', 'volume_journal', 'processes')}
    source += f'expected={binding!r}\n'
    source += '''assert all(state[key]==value for key,value in expected.items())
assert state['service_exit'] is None and 'VISION_AGENT_RETAINED' in state['stderr_tail']
for entry in state['processes']:
    process=pathlib.Path('/proc')/str(entry['pid'])
    assert process.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==entry['start_ticks']
owner=state['service_start']
assert pathlib.Path('/proc',str(owner['pid']),'cmdline').read_bytes().split(bytes([0]))[:-1]==[s.encode() for s in owner['command']]
'''
    source += f"root=pathlib.Path({board!r})/'var'/{receipt!r}\nroot.mkdir()\n"
    source += '''with (root/'before.json').open('x') as output:
    json.dump(state,output);output.flush();os.fsync(output.fileno())
with (root/'normal-reboot.attempt').open('x') as output:
    json.dump(dict(identity=owner,forced=False,operator_authorized=True),output);output.flush();os.fsync(output.fileno())
print(json.dumps(dict(phase='C0E_IDENTITY_BOUND_NORMAL_REBOOT',boot_id=state['boot_id'],owner=owner)),flush=True)
result=subprocess.run(['systemctl','reboot'],capture_output=True,text=True,timeout=10)
print(json.dumps(dict(returncode=result.returncode,stdout=result.stdout,stderr=result.stderr)),flush=True)
assert result.returncode==0
'''
    remote(receipt, source, timeout=30, hardware_access=True)


def postboot(name, retained):
    source = inspect_source(current=BOARD, log=LOG)
    source = source.replace('print(json.dumps(state),flush=True)', '''properties=[dict(line.split('=',1) for line in entry['stdout'].splitlines()) for entry in state['services'].values()]
state['recovery_ready']=bool(state['boot_id']!=OLD_BOOT and
    all(p==dict(ActiveState='inactive',MainPID='0',Result='success') for p in properties) and
    not state['processes'] and not state['hardware_mappers'] and
    all(not entry['exists'] or entry['available'] and entry['bytes']==0 for entry in state['locks'].values()) and
    all(':'+str(port) not in state['ports'] for port in (8765,8081,8771)) and
    (state['volume_journal'] is None or state['volume_journal']['state']=='CLEAN'))
print(json.dumps(state),flush=True)''')
    old_boot = json.loads(load(retained)['stdout'])['boot_id']
    remote(name, 'OLD_BOOT=' + repr(old_boot) + '\n' + source)


def deployment(action, name):
    import deploy_latency_board as deploy
    state = json.loads(load(name)['stdout'])
    assert state['recovery_ready'] is True
    assert load('latency-diagnostics-restore-r02')['status'] == 'DIAGNOSTICS_RESTORE_SHA_AST_PREFLIGHT_PASS'
    deploy.CHILD, deploy.BOARD, deploy.LOG = CHILD, BOARD, LOG
    deploy.boot = lambda: state['boot_id']

    def name_map(name):
        assert name.startswith('c0e-b'), name
        return name.replace('c0e-b', 'c0e-d', 1)

    def get_receipt(name):
        if name == 'latency-package-r01':
            package = load('latency-diagnostics-package-r02')
            # Adapt only the common deployment interface after independent full verification above.
            return dict(status='C0E_PACKAGE_RESTORED_AND_PC_PREFLIGHT_PASS', sha256=package['sha256'])
        return load(name_map(name))

    deploy.load = get_receipt
    deploy.save = lambda name, value: save(name_map(name), value)
    deploy.remote = lambda name, source, **kwargs: remote(name_map(name), source, **kwargs)
    getattr(deploy, action)()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('action', choices=('verify', 'reboot', 'postboot', 'stage', 'arm', 'base', 'start', 'ready', 'inspect'))
    parser.add_argument('--state', default='c0e-d01-readonly-postboot-r02')
    parser.add_argument('--retained', default='c0e-b12-retained-after-normal-stop')
    parser.add_argument('--receipt', default='c0e-d00-normal-reboot')
    args = parser.parse_args()
    action = args.action
    if action == 'postboot':
        postboot(args.state, args.retained)
    elif action == 'reboot':
        reboot(args.retained, args.receipt)
    elif action == 'verify':
        verify()
    else:
        deployment(action, args.state)
