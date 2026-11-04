"""Normal recovery of the evidenced retained r15 owner, never forced takeover.

Run: python -B .../recover_board.py inspect|reboot|postboot|base|start|ready
Use --state g19-postboot-rNN for base/start after an actual READY receipt.
Outputs unique g19/g20 receipts, new boot-bound Base halt and load attempts.
Next: verify HELLO/C0D sources and perform automated acceptance.
"""
import argparse
import ast
import json
from pathlib import Path

from board_common import BOARD, CHILD, HERE, REPO, load, remote, inspect_source

LOG = "var/osd-live-r02"


def inspect(): remote("g19-retained-readonly", inspect_source())


def reboot():
    receipt = load("g19-retained-readonly")
    assert receipt["returncode"] == 0
    expected = json.loads(receipt["stdout"])
    assert expected["service_exit"] is None and "VISION_AGENT_RETAINED" in expected["stderr_tail"]
    code = "import contextlib,io,json,os,pathlib,subprocess\nbuffer=io.StringIO()\nwith contextlib.redirect_stdout(buffer):\n    exec(compile(" + repr(inspect_source()) + ",'<readonly>','exec'),{})\nstate=json.loads(buffer.getvalue())\n"
    binding = {k:expected[k] for k in ("boot_id","service_start","volume_journal")}
    code += f"expected={binding!r}\n"
    code += '''assert all(state[k]==v for k,v in expected.items())
assert state['service_exit'] is None and 'VISION_AGENT_RETAINED' in state['stderr_tail']
owner=state['service_start']
process=pathlib.Path('/proc')/str(owner['pid'])
assert process.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==owner['start_ticks']
assert process.joinpath('cmdline').read_bytes().split(bytes([0]))[:-1]==[s.encode() for s in owner['command']]
assert all(':'+str(p) not in state['ports'] for p in (8765,8081,8771))
'''
    code += f"root=pathlib.Path({BOARD!r})/'var/retained-recovery-r01'\nroot.mkdir(parents=True)\n"
    code += '''with (root/'before.json').open('x') as output:
    json.dump(state,output);output.flush();os.fsync(output.fileno())
with (root/'normal-reboot.attempt').open('x') as output:
    json.dump(dict(identity=owner,forced=False,operator_authorized=True),output);output.flush();os.fsync(output.fileno())
print(json.dumps(dict(phase='IDENTITY_BOUND_AUTHORIZED_NORMAL_REBOOT',boot_id=state['boot_id'],owner=owner)),flush=True)
result=subprocess.run(['systemctl','reboot'],capture_output=True,text=True,timeout=10)
print(json.dumps(dict(returncode=result.returncode,stdout=result.stdout,stderr=result.stderr)),flush=True)
assert result.returncode==0
'''
    remote("g19-normal-reboot", code)


def postboot(name):
    old = json.loads(load("g19-retained-readonly")["stdout"])["boot_id"]
    code="import contextlib,io,json,pathlib,threading,time\nsource="+repr(inspect_source())+f"\nold_boot={old!r}\ndeadline=time.monotonic()+40\nobservations=[]\n"
    code+='''while True:
    buffer=io.StringIO()
    with contextlib.redirect_stdout(buffer): exec(compile(source,'<readonly>','exec'),{})
    state=json.loads(buffer.getvalue())
    properties=[dict(line.split('=',1) for line in entry['stdout'].splitlines()) for entry in state['services'].values()]
    ready=state['boot_id']!=old_boot and all(p==dict(ActiveState='inactive',MainPID='0',Result='success') for p in properties)
    observations.append(dict(boot=state['boot_id'],services=state['services']))
    if ready or time.monotonic()>=deadline: break
    threading.Event().wait(1)
state['startup_observations']=observations
state['recovery_ready']=bool(ready and not state['processes'] and not state['hardware_mappers'] and
    all(not e['exists'] or e['available'] and e['bytes']==0 for e in state['locks'].values()) and
    all(':'+str(p) not in state['ports'] for p in (8765,8081,8771)) and
    (state['volume_journal'] is None or state['volume_journal']['state']=='CLEAN'))
print(json.dumps(state),flush=True)
'''
    remote(name,code,timeout=55)


def binding(name):
    receipt=load(name)
    assert receipt['returncode']==0
    state=json.loads(receipt['stdout'])
    assert state['recovery_ready'] is True
    return state['boot_id']


def template(name,boot):
    original=REPO/'results/game-validation/game-volume-fusion-20261022/round14'/name
    source=json.loads(original.read_text(encoding='utf-8'))['remote_code']
    oldroot='/home/xilinx/voice-view-game/vision-volume-c0c-r14-autonomous-20261022'
    assert oldroot in source and '13f0774f-963f-47b0-a505-282f07e20956' in source
    source=source.replace(oldroot,BOARD).replace('var/game3-live-20261022',LOG).replace(
        '13f0774f-963f-47b0-a505-282f07e20956',boot).replace('0xC0060C00','0xC0060D00')
    if 'agent-start' in name:
        assert source.count("'--physical-audio-confirmed']")==1
        source=source.replace("'--physical-audio-confirmed']", "'--physical-audio-confirmed', '--osd-test-stimuli']")
    tree=ast.parse(source)
    count=0
    for node in ast.walk(tree):
        if isinstance(node,ast.Constant) and type(node.value) is int and node.value==504:
            node.value=len(json.loads((CHILD/'deployment_manifest.json').read_text(encoding='utf-8'))['sha256'])
            count+=1
    assert count==1
    return ast.unparse(ast.fix_missing_locations(tree))


def base(name):
    boot=binding(name)
    remote("g20-newboot-base-stop",template('f130-game3-base-normal-stop.json',boot),timeout=90,hardware_access=True)


def start(name):
    boot=binding(name)
    assert load('g20-newboot-base-stop')['returncode']==0
    prefix=f"import fcntl,json,pathlib\nassert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()=={boot!r}\n"
    prefix+='''journal=pathlib.Path('/var/lock/voice-view-c6i-volume-owner.json')
assert not journal.exists() or json.loads(journal.read_text())['state']=='CLEAN'
for name in ('/var/lock/voice-view-c6i.lock','/run/lock/voice_pcm_audio.lock'):
    with pathlib.Path(name).open('rb') as stream:
        fcntl.flock(stream.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB)
        assert not stream.read()
'''
    remote('g20-newboot-c0d-start',prefix+template('f131-game3-agent-start.json',boot),timeout=90,hardware_access=True)


def ready():
    source=f"import json,pathlib,threading,time\nroot=pathlib.Path({BOARD!r})/{LOG!r}\ndeadline=time.monotonic()+75\n"
    source+='''while not (root/'service-start.json').exists() or 'voice-view-agent listening' not in (root/'stdout.log').read_text():
    assert not (root/'service-exit.json').exists()
    assert time.monotonic()<deadline
    threading.Event().wait(.25)
print(json.dumps(dict(service_start=json.loads((root/'service-start.json').read_text()),stdout=(root/'stdout.log').read_text(),stderr=(root/'stderr.log').read_text())),flush=True)
'''
    remote('g20-newboot-c0d-ready',source,timeout=90)


if __name__=='__main__':
    parser=argparse.ArgumentParser()
    parser.add_argument('action',choices=('inspect','reboot','postboot','base','start','ready','check'))
    parser.add_argument('--state',default='g19-postboot-r01')
    args=parser.parse_args()
    if args.action=='check':
        for name in ('f130-game3-base-normal-stop.json','f131-game3-agent-start.json'):
            ast.parse(template(name,'00000000-0000-0000-0000-000000000000'),feature_version=(3,10))
        print('NEWBOOT_TEMPLATE_AST_AND_BINDING_PASS')
    elif args.action in ('postboot','base','start'): globals()[args.action](args.state)
    else: globals()[args.action]()
