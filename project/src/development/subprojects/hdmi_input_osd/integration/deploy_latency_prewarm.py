"""Identity-bound r18 prewarm board phases using the existing reviewed deployment gates.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/deploy_latency_prewarm.py ACTION
Actions: stage, arm, base, start, ready, inspect. --state must name an actual fresh idle-boot receipt.
Outputs: exclusive c0e-p02..p07 receipts and independent board var/pl-prewarm-p01.
Next: first-frame, same-frame masks, normal STOP/restart, GPU/mode and matched performance acceptance.
"""
import argparse
import hashlib
import json
from pathlib import Path
import deploy_latency_board as deploy
from board_common import REPO, load, remote, save

CHILD=REPO/'deliveries/c6i-pl-vision-volume-osd-r18-prewarm-20261023'
BOARD='/home/xilinx/voice-view-game/'+CHILD.name
LOG='var/pl-prewarm-p01'


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('action',choices=('stage','arm','base','start','ready','inspect'))
    parser.add_argument('--state',default='c0e-p01-readonly-postboot-r01')
    args=parser.parse_args()
    state=json.loads(load(args.state)['stdout'])
    assert state['recovery_ready'] is True and not state['processes'] and not state['hardware_mappers']
    package=load('latency-prewarm-package-r01')
    assert package['status']=='C0E_PACKAGE_RESTORED_AND_PC_PREFLIGHT_PASS'
    if args.action in ('base','start'):
        gate=load('latency-constraint-equivalence-unit-r01')
        assert gate['status']=='CONSTRAINT_EQUIVALENCE_UNIT_FIXTURES_PASS'
        assert gate['gate_source_sha256']==hashlib.sha256((Path(__file__).parent/'audit_latency_signoff.py').read_bytes()).hexdigest()
    deploy.CHILD,deploy.BOARD,deploy.LOG=CHILD,BOARD,LOG
    deploy.boot=lambda:state['boot_id']

    def mapping(name):
        assert name.startswith('c0e-b'),name
        return name.replace('c0e-b','c0e-p',1)

    deploy.load=lambda name:package if name=='latency-package-r01' else load(mapping(name))
    deploy.save=lambda name,value:save(mapping(name),value)
    deploy.remote=lambda name,source,**kwargs:remote(mapping(name),source,**kwargs)
    getattr(deploy,args.action)()


if __name__=='__main__':main()
