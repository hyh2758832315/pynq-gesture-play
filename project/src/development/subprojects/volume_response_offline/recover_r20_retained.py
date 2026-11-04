"""Record and normally reboot one identity-bound retained R20 board session.

Run: .venv/Scripts/python subprojects/volume_response_offline/recover_r20_retained.py inspect
     .venv/Scripts/python subprojects/volume_response_offline/recover_r20_retained.py reboot
     .venv/Scripts/python subprojects/volume_response_offline/recover_r20_retained.py postboot
Output: exclusive 07-retained-inspect, 08-normal-reboot, 09-postboot JSON receipts.
Next: only a passing new-boot idle gate releases the board reservation.
"""
import argparse
import json
import re
import subprocess
import time
from pathlib import Path


REPO = Path(__file__).resolve().parents[2]
OUT = REPO / 'build/volume-response/integrated-r20-control-a01'
LOG = '/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r20-admission-r03-20261023/var/audio-control-a01'
BOOT = '9181dda3-5e9f-4bf5-947e-25da9f498a0d'
SSH = ['ssh', '-b', '192.168.2.1', '-o', 'BatchMode=yes',
       '-o', 'StrictHostKeyChecking=yes', '-o', 'ConnectTimeout=8', 'pynq-z2',
       'sudo -n /usr/local/share/pynq-venv/bin/python -B -']


def run(target, source, timeout):
    with target.open('x', encoding='utf-8') as output:
        receipt = dict(source=source, started_unix=time.time())
        try:
            response = subprocess.run(SSH, input=source, capture_output=True,
                                      text=True, timeout=timeout)
            receipt.update(returncode=response.returncode, stdout=response.stdout,
                           stderr=response.stderr)
            print(target.name, response.returncode, response.stdout[-2500:],
                  response.stderr[-400:], flush=True)
            if response.returncode == 0:
                receipt['state'] = json.loads(response.stdout)
            assert response.returncode == 0
        except BaseException as error:
            receipt['error'] = repr(error)
            raise
        finally:
            receipt['finished_unix'] = time.time()
            json.dump(receipt, output, indent=2)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('inspect', 'reboot', 'postboot'))
    parser.add_argument('--attempt', default='a01', help='unique postboot receipt suffix')
    args = parser.parse_args()
    assert re.fullmatch(r'a[0-9]{2}', args.attempt)
    if args.action in ('inspect', 'reboot'):
        # The original read-only receipt is outside OUT; its identity is fixed here.
        prior = json.loads((REPO / 'build/volume-response/r20-control-inspect-after-stop-a03.json').read_text())['state']
        entry = json.loads(prior['files']['service-start.json']['tail'])
        assert prior['boot_id'] == BOOT == entry['boot_id']
        assert entry['pid'] == 999 and entry['start_ticks'] == '45039'
        assert prior['files']['service-exit.json'] is None
        assert 'VISION_AGENT_RETAINED: capture reader retained: S2MM halt not confirmed' in prior['files']['stderr.log']['tail']
    if args.action == 'inspect':
        source = f"""import json,pathlib,subprocess
log=pathlib.Path({LOG!r}); expected={entry!r}
boot=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot==expected['boot_id']
assert json.loads((log/'service-start.json').read_text())==expected
assert not (log/'service-exit.json').exists()
assert 'VISION_AGENT_RETAINED' in (log/'stderr.log').read_text()
processes={{}}
for pid in (expected['supervisor_pid'],expected['pid'],1039):
    p=pathlib.Path('/proc')/str(pid)
    assert p.exists()
    processes[str(pid)]=dict(status=p.joinpath('status').read_text()[:1500],
                            wchan=p.joinpath('wchan').read_text(),
                            start_ticks=p.joinpath('stat').read_text().rsplit(')',1)[1].split()[19],
                            cmdline=[s.decode(errors='replace') for s in
                                     p.joinpath('cmdline').read_bytes().split(bytes([0]))[:-1]])
assert processes[str(expected['pid'])]['start_ticks']==expected['start_ticks']
journal=pathlib.Path('/var/lock/voice-view-c6i-volume-owner.json')
volume=json.loads(journal.read_text()) if journal.exists() else None
assert volume is not None and volume['state']=='ACTIVE' and volume['owner_pid']==expected['pid']
ports=subprocess.run(['ss','-lntp'],capture_output=True,text=True,check=True).stdout
kernel=subprocess.run(['dmesg','--color=never'],capture_output=True,text=True,check=True).stdout[-12000:]
print(json.dumps(dict(boot_id=boot,processes=processes,volume_journal=volume,
                      stderr=(log/'stderr.log').read_text(),ports=ports,kernel_tail=kernel)))
"""
        run(OUT / '07-retained-inspect.json', source, 40)
    elif args.action == 'reboot':
        inspection = json.loads((OUT / '07-retained-inspect.json').read_text())
        assert inspection['returncode'] == 0
        state = inspection['state']
        assert state['boot_id'] == BOOT
        assert state['volume_journal']['state'] == 'ACTIVE'
        source = f"""import json,os,pathlib,subprocess
log=pathlib.Path({LOG!r}); expected={entry!r}; old_boot={BOOT!r}
boot=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot==old_boot==expected['boot_id']
assert json.loads((log/'service-start.json').read_text())==expected
assert not (log/'service-exit.json').exists()
assert 'VISION_AGENT_RETAINED: capture reader retained: S2MM halt not confirmed' in (log/'stderr.log').read_text()
p=pathlib.Path('/proc')/str(expected['pid'])
assert p.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==expected['start_ticks']
assert p.joinpath('cmdline').read_bytes().split(bytes([0]))[:-1]==[s.encode() for s in expected['command']]
volume=json.loads(pathlib.Path('/var/lock/voice-view-c6i-volume-owner.json').read_text())
assert volume['state']=='ACTIVE' and volume['owner_pid']==expected['pid'] and volume['owner_start_ticks']==int(expected['start_ticks'])
owners=[];other_business=[]
for item in pathlib.Path('/proc').glob('[0-9]*'):
    try:
        command=item.joinpath('cmdline').read_bytes().replace(bytes([0]),b' ').decode(errors='replace')
        maps=item.joinpath('maps').read_text()
        if '/dev/mem' in maps or '/dev/uio' in maps:owners.append(int(item.name))
        if any(token in command for token in ('board_buttons.py','pynq_usb_hand','run_camera_live_guarded.py')):
            other_business.append(int(item.name))
    except (FileNotFoundError,ProcessLookupError,PermissionError):pass
assert sorted(owners)==[999,1039] and not other_business
with (log/'recovery-before.json').open('x') as output:
    json.dump(dict(boot_id=boot,identity=expected,volume_journal=volume,owners=owners),output)
    output.flush();os.fsync(output.fileno())
with (log/'normal-reboot.attempt').open('x') as output:
    json.dump(dict(identity=expected,forced=False,operator_authorized=True),output)
    output.flush();os.fsync(output.fileno())
result=subprocess.run(['systemctl','reboot'],capture_output=True,text=True,timeout=10)
print(json.dumps(dict(phase='IDENTITY_BOUND_NORMAL_REBOOT',returncode=result.returncode,
                      stdout=result.stdout,stderr=result.stderr)),flush=True)
assert result.returncode==0
"""
        run(OUT / '08-normal-reboot.json', source, 25)
    else:
        reboot = json.loads((OUT / '08-normal-reboot.json').read_text())
        assert reboot['returncode'] == 0 and reboot['state']['returncode'] == 0
        source = f"""import fcntl,json,pathlib,subprocess
old_boot={BOOT!r}
root=pathlib.Path('/proc')
boot=root.joinpath('sys/kernel/random/boot_id').read_text().strip()
owners=[];business=[]
for p in root.glob('[0-9]*'):
    try:
        command=p.joinpath('cmdline').read_bytes().replace(bytes([0]),b' ').decode(errors='replace')
        maps=p.joinpath('maps').read_text()
        if '/dev/mem' in maps or '/dev/uio' in maps:owners.append(int(p.name))
        if 'start_board_test.py' in command or 'board_buttons.py' in command:business.append(int(p.name))
    except (FileNotFoundError,ProcessLookupError,PermissionError):pass
services={{}}
for name in ('bootpy.service','clear_pl_statefile.service','voice-view-shell.service'):
    r=subprocess.run(['systemctl','show',name,'-p','ActiveState','-p','MainPID','-p','Result'],capture_output=True,text=True,timeout=5)
    services[name]=r.stdout
locks={{}}
for name in ('/var/lock/voice-view-c6i.lock','/run/lock/voice_pcm_audio.lock'):
    p=pathlib.Path(name)
    if not p.exists():locks[name]=dict(exists=False,available=True,bytes=0)
    else:
        with p.open('rb') as stream:
            try:fcntl.flock(stream.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB);available=True
            except BlockingIOError:available=False
        locks[name]=dict(exists=True,available=available,bytes=p.stat().st_size)
journal=pathlib.Path('/var/lock/voice-view-c6i-volume-owner.json')
volume=json.loads(journal.read_text()) if journal.exists() else None
ports=subprocess.run(['ss','-lntp'],capture_output=True,text=True,check=True).stdout
state=dict(boot_id=boot,owners=owners,business=business,services=services,locks=locks,
           volume_journal=volume,ports=ports)
print(json.dumps(state),flush=True)
assert boot!=old_boot and not owners and not business
assert all('ActiveState=inactive' in s and 'MainPID=0' in s for s in services.values())
assert all(v['available'] and v['bytes']==0 for v in locks.values())
assert volume is None or volume['state']=='CLEAN'
assert all(':'+str(port) not in ports for port in (8765,8081,8771))
"""
        receipt_name = '09-postboot.json' if args.attempt == 'a01' else f'09-postboot-{args.attempt}.json'
        run(OUT / receipt_name, source, 45)


if __name__ == '__main__':
    main()
