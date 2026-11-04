"""Read preserved R21 startup files after a new boot; no hardware or service changes.

Run: python inspect_failed_start.py --output build/volume-response/failed-start-a01.json
Output: exclusive JSON of boot, startup logs, service state and owner identity.
Next: classify the failure before any later board load or code change.
"""
import argparse,json,subprocess,time
from pathlib import Path

SOURCE=r'''
import json,pathlib,subprocess
root=pathlib.Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
log=root/'var/audio-diagnosis-a01'
files={}
for name in ('load.attempt','base-stop.json','startup-phases.jsonl','service-start.json','service-exit.json','stdout.log','stderr.log'):
    p=log/name
    files[name]=None if not p.exists() else dict(bytes=p.stat().st_size,tail=p.read_text(errors='replace')[-20000:])
owners=[]
for p in pathlib.Path('/proc').glob('[0-9]*'):
    try:
        command=p.joinpath('cmdline').read_bytes().replace(bytes([0]),b' ').decode(errors='replace')
        maps=p.joinpath('maps').read_text()
        if any(s in command for s in ('start_board_test.py','voice-view-game','boot.py')) or any(s in maps for s in ('/dev/mem','/dev/uio','/dev/ttyUSB')):
            owners.append(dict(pid=int(p.name),command=command[:1200],mapped=any(s in maps for s in ('/dev/mem','/dev/uio','/dev/ttyUSB'))))
    except (FileNotFoundError,ProcessLookupError,PermissionError):pass
services={}
for name in ('bootpy.service','clear_pl_statefile.service','voice-view-shell.service'):
    r=subprocess.run(['systemctl','show',name,'-p','ActiveState','-p','MainPID','-p','Result'],capture_output=True,text=True,timeout=5)
    services[name]=r.stdout
print(json.dumps(dict(boot_id=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip(),files=files,owners=owners,services=services)),flush=True)
'''


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--candidate',choices=('r21','r20'),default='r21');args=p.parse_args()
    source=SOURCE
    if args.candidate=='r20':
        source=source.replace('c6i-pl-vision-volume-osd-r21-marker-r02-20261023','c6i-pl-vision-volume-osd-r20-admission-r03-20261023').replace('var/audio-diagnosis-a01','var/audio-control-a01')
    command=['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8','pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -']
    args.output.parent.mkdir(parents=True,exist_ok=True)
    with args.output.open('x',encoding='utf-8') as output:
        record=dict(read_only=True,source=source,command=command,started_unix=time.time())
        try:
            r=subprocess.run(command,input=source,capture_output=True,text=True,timeout=40)
            record.update(returncode=r.returncode,stdout=r.stdout,stderr=r.stderr)
            if r.returncode==0:
                record['state']=json.loads(r.stdout)
                print(json.dumps(record['state'],indent=2))
        except BaseException as error:record['error']=repr(error);raise
        finally:record['finished_unix']=time.time();json.dump(record,output,indent=2)


if __name__=='__main__':main()
