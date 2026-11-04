"""Identity-bound R20 deployment; no action on import.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/deploy_latency_admission.py ACTION
Actions: stage, arm, base, start, ready, inspect. Outputs: exclusive r20-bNN receipts.
Next: observe actual frame progress and independent OSD, then bounded GPU/STOP tests.
Reuses reviewed R17 deployment machinery with explicit R20 evidence and new paths.
"""
import argparse
import hashlib
import json
import deploy_latency_board as deploy
from board_common import REPO, load, remote, save

CHILD = REPO / 'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'
BOARD = '/home/xilinx/voice-view-game/' + CHILD.name
LOG = 'var/pl-admission-r20-b01'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('action', choices=('stage', 'arm', 'base', 'start', 'ready', 'inspect'))
    args = parser.parse_args()
    state = json.loads(load('r20-b01r02-readonly')['stdout'])
    assert not state['processes'] and not state['hardware_mappers']
    assert state['boot_id'] == 'f56e80d1-0222-4c57-8308-162e279eb32f'
    package = load('latency-admission-package-r03')
    assert package['status'] == 'ADMISSION_R20_PACKAGE_RESTORED_AND_PC_PREFLIGHT_PASS'
    assert package['sha256'] == 'd64e5e7a553f13ef7db04305ea9df902def279b35dbe06c4f7a4427b695cb6d4'
    assert hashlib.sha256(CHILD.with_suffix('.zip').read_bytes()).hexdigest() == package['sha256']
    deploy.CHILD, deploy.BOARD, deploy.LOG = CHILD, BOARD, LOG
    deploy.boot = lambda: state['boot_id']

    def mapping(name):
        assert name.startswith('c0e-b')
        return name.replace('c0e-b', 'r20-b', 1)

    # Internal adapter only: the immutable R20 receipt above retains its real status.
    stage_contract = dict(package, status='C0E_PACKAGE_RESTORED_AND_PC_PREFLIGHT_PASS')
    deploy.load = lambda name: stage_contract if name == 'latency-package-r01' else load(mapping(name))
    deploy.save = lambda name, value: save(mapping(name), value)
    deploy.remote = lambda name, source, **kwargs: remote(mapping(name), source, **kwargs)
    if args.action in ('base', 'start'):
        assert load('r20-b03-arm-cpu-contract')['returncode'] == 0
        source = deploy.prefix() + r'''
import os
conflicts=[]
for process in pathlib.Path('/proc').glob('[0-9]*'):
    try:
        command=(process/'cmdline').read_bytes().replace(b'\x00',b' ').decode(errors='replace')
        if 'board_buttons.py' in command or 'pynq_usb_hand' in command:
            conflicts.append(dict(pid=process.name,command=command))
        for descriptor in (process/'fd').iterdir():
            try:
                target=os.readlink(descriptor)
                if target.startswith(('/dev/ttyUSB','/dev/ttyACM')):
                    conflicts.append(dict(pid=process.name,serial=target))
            except (FileNotFoundError,ProcessLookupError): pass
    except (FileNotFoundError,ProcessLookupError): pass
assert not conflicts,conflicts
print(json.dumps(dict(hand_conflicts=conflicts,boot_id=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip())),flush=True)
'''
        remote('r20-b04-hand-free' if args.action == 'base' else 'r20-b05-hand-free', source)
    getattr(deploy, args.action)()
    if args.action == 'arm':
        source = deploy.prefix() + f"import os,subprocess,sys\nroot=pathlib.Path({BOARD!r})\n"
        source += '''
for name in ('latest_capture_contract.py','latest_runtime_contract.py'):
    result=subprocess.run([sys.executable,'-B',str(root/'tools'/name),'-v'],cwd=root,
        env=dict(os.environ,PYTHONPATH=str(root/'python')),capture_output=True,text=True,timeout=60)
    print(json.dumps(dict(test=name,returncode=result.returncode,stdout=result.stdout,stderr=result.stderr)),flush=True)
    assert result.returncode==0
assert '/dev/mem' not in pathlib.Path('/proc/self/maps').read_text()
print('R20_ARM_CPU_CONTRACT_PASS',flush=True)
'''
        remote('r20-b03-arm-cpu-contract', source, timeout=150)


if __name__ == '__main__':
    main()
