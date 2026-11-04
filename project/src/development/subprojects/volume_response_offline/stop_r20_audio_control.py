"""End only this boot's R20 diagnostic Agent by its recorded identity.

Run: .venv/Scripts/python subprojects/volume_response_offline/stop_r20_audio_control.py stop
     .venv/Scripts/python subprojects/volume_response_offline/stop_r20_audio_control.py verify
Output: exclusive 05-normal-stop.json and 06-closed.json receipts.
Next: update the board reservation only after verify confirms clean closure.
"""
import argparse
import json
import subprocess
import time
from pathlib import Path


REPO = Path(__file__).resolve().parents[2]
OUT = REPO / 'build/volume-response/integrated-r20-control-a01'
INSPECT = REPO / 'build/volume-response/r20-control-inspect-before-stop-a02.json'
ROOT = '/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'
LOG = ROOT + '/var/audio-control-a01'
SSH = ['ssh', '-b', '192.168.2.1', '-o', 'BatchMode=yes',
       '-o', 'StrictHostKeyChecking=yes', '-o', 'ConnectTimeout=8', 'pynq-z2',
       'sudo -n /usr/local/share/pynq-venv/bin/python -B -']


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('stop', 'verify'))
    args = parser.parse_args()
    prior = json.loads(INSPECT.read_text())['state']
    entry = json.loads(prior['files']['service-start.json']['tail'])
    assert prior['boot_id'] == entry['boot_id']
    assert prior['files']['service-exit.json'] is None
    assert entry['command'][3] == ROOT + '/start_board_test.py'
    assert entry['pid'] == 999 and entry['start_ticks'] == '45039'
    if args.action == 'stop':
        source = f"""import json,os,pathlib,signal
entry={entry!r}
log=pathlib.Path({LOG!r})
boot=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot==entry['boot_id']
assert json.loads((log/'service-start.json').read_text())==entry
assert not (log/'service-exit.json').exists()
process=pathlib.Path('/proc')/str(entry['pid'])
assert process.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==entry['start_ticks']
assert process.joinpath('cmdline').read_bytes().split(bytes([0]))[:-1]==[s.encode() for s in entry['command']]
with (log/'stop-control.attempt').open('x') as stream:
    json.dump(dict(identity=entry,forced=False),stream)
    stream.flush();os.fsync(stream.fileno())
os.kill(entry['pid'],signal.SIGTERM)
print(json.dumps(dict(phase='IDENTITY_BOUND_NORMAL_SIGTERM_ONCE',pid=entry['pid'],boot_id=boot)))
"""
        target = OUT / '05-normal-stop.json'
        timeout = 20
    else:
        assert json.loads((OUT / '05-normal-stop.json').read_text())['returncode'] == 0
        source = f"""import fcntl,json,pathlib,subprocess,time
entry={entry!r}
log=pathlib.Path({LOG!r})
boot=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot==entry['boot_id']
deadline=time.monotonic()+35
while True:
    exit_file=log/'service-exit.json'
    exit_record=json.loads(exit_file.read_text()) if exit_file.exists() else None
    process=pathlib.Path('/proc')/str(entry['pid'])
    alive=process.exists() and process.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==entry['start_ticks']
    if exit_record is not None and not alive:break
    if time.monotonic()>=deadline:break
    time.sleep(.5)
owners=[]
for p in pathlib.Path('/proc').glob('[0-9]*'):
    try:
        maps=p.joinpath('maps').read_text()
        if '/dev/mem' in maps or '/dev/uio' in maps:owners.append(int(p.name))
    except (FileNotFoundError,ProcessLookupError,PermissionError):pass
journal=pathlib.Path('/var/lock/voice-view-c6i-volume-owner.json')
volume=json.loads(journal.read_text()) if journal.exists() else None
locks={{}}
for name in ('/var/lock/voice-view-c6i.lock','/run/lock/voice_pcm_audio.lock'):
    path=pathlib.Path(name)
    if not path.exists():locks[name]=dict(exists=False,available=True)
    else:
        with path.open('rb') as stream:
            try:fcntl.flock(stream.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB);available=True
            except BlockingIOError:available=False
            locks[name]=dict(exists=True,available=available,bytes=path.stat().st_size)
record=dict(boot_id=boot,service_exit=exit_record,agent_alive=alive,mappers=owners,volume_journal=volume,locks=locks)
print(json.dumps(record),flush=True)
assert exit_record is not None and exit_record['returncode']==0
assert exit_record['pid']==entry['pid'] and exit_record['boot_id']==boot
assert not alive and not owners and all(v['available'] for v in locks.values())
assert volume is None or volume['state']=='CLEAN'
"""
        target = OUT / '06-closed.json'
        timeout = 55
    with target.open('x', encoding='utf-8') as output:
        record = dict(action=args.action, source=source, started_unix=time.time())
        try:
            result = subprocess.run(SSH, input=source, text=True, capture_output=True, timeout=timeout)
            record.update(returncode=result.returncode, stdout=result.stdout, stderr=result.stderr)
            if result.returncode == 0:
                record['result'] = json.loads(result.stdout)
            print(args.action, result.returncode, result.stdout[-3000:], result.stderr[-500:], flush=True)
            assert result.returncode == 0
        except BaseException as error:
            record['error'] = repr(error)
            raise
        finally:
            record['finished_unix'] = time.time()
            json.dump(record, output, indent=2)


if __name__ == '__main__':
    main()
