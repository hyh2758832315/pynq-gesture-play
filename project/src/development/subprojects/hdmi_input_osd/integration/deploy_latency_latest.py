"""Deploy independently frozen R19 only after current idle-boot ownership gates.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/deploy_latency_latest.py ACTION --state POSTBOOT_RECEIPT
Actions: stage, arm, base, start, ready, inspect.
Outputs: c0e-q02..q07 receipts, ARM CPU contracts and board var/pl-latest-q01.
Next: verify sustained capture, STOP/restart, GPU goldens and measured performance.
"""
import argparse
import hashlib
import json
from pathlib import Path
import deploy_latency_board as deploy
from board_common import REPO, load, remote, save

CHILD = REPO / 'deliveries/c6i-pl-vision-volume-osd-r19-latest-20261023'
BOARD = '/home/xilinx/voice-view-game/' + CHILD.name
LOG = 'var/pl-latest-q01'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('action', choices=('stage', 'arm', 'base', 'start', 'ready', 'inspect'))
    parser.add_argument('--state', required=True)
    args = parser.parse_args()
    state = json.loads(load(args.state)['stdout'])
    assert state['recovery_ready'] is True and not state['processes'] and not state['hardware_mappers']
    package = load('latency-latest-package-r01')
    assert package['status'] == 'C0E_PACKAGE_RESTORED_AND_PC_PREFLIGHT_PASS'
    contract = load('latency-latest-contract-r02')
    assert contract['status'] == 'LATEST_CAPTURE_PC_CONTRACT_PASS'
    for name, digest in contract['source_sha256'].items():
        assert hashlib.sha256((CHILD / name).read_bytes()).hexdigest() == digest
    if args.action in ('base', 'start'):
        assert load('c0e-q03-arm-cpu-contract')['returncode'] == 0
        gate = load('latency-constraint-equivalence-unit-r01')
        assert gate['status'] == 'CONSTRAINT_EQUIVALENCE_UNIT_FIXTURES_PASS'
        assert gate['gate_source_sha256'] == hashlib.sha256((Path(__file__).parent / 'audit_latency_signoff.py').read_bytes()).hexdigest()
    deploy.CHILD, deploy.BOARD, deploy.LOG = CHILD, BOARD, LOG
    deploy.boot = lambda: state['boot_id']
    def mapping(name):
        assert name.startswith('c0e-b')
        return name.replace('c0e-b', 'c0e-q', 1)
    deploy.load = lambda name: package if name == 'latency-package-r01' else load(mapping(name))
    deploy.save = lambda name, value: save(mapping(name), value)
    deploy.remote = lambda name, source, **kwargs: remote(mapping(name), source, **kwargs)
    getattr(deploy, args.action)()
    if args.action == 'arm':
        source = f"import hashlib,json,os,pathlib,subprocess,sys\nroot=pathlib.Path({BOARD!r})\n"
        source += f"assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()=={state['boot_id']!r}\n"
        source += '''manifest=json.loads((root/'deployment_manifest.json').read_text())
for name in ('latest_capture_contract.py','latest_runtime_contract.py'):
    path=root/'tools'/name
    assert hashlib.sha256(path.read_bytes()).hexdigest().upper()==manifest['sha256']['tools/'+name]
    result=subprocess.run([sys.executable,'-B',str(path),'-v'],cwd=root,
        env=dict(os.environ,PYTHONPATH=str(root/'python')),capture_output=True,text=True,timeout=60)
    print(json.dumps(dict(test=name,returncode=result.returncode,stdout=result.stdout,stderr=result.stderr,hardware_access=False)),flush=True)
    assert result.returncode==0
maps=pathlib.Path('/proc/self/maps').read_text()
assert '/dev/mem' not in maps and '/dev/uio' not in maps
print('LATEST_CAPTURE_ARM_CPU_CONTRACT_PASS',flush=True)
'''
        remote('c0e-q03-arm-cpu-contract', source, timeout=150)


if __name__ == '__main__':
    main()
