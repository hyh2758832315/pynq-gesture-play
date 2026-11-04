"""Stage signed R21 marker hardware and unchanged R20 runtime for audio diagnosis.

Run: python deploy_integrated_probe.py ACTION --gate <fresh idle-gate.json>
Actions: stage, arm, base, start, ready, inspect. Output: exclusive local receipts
build/volume-response/integrated-r21-a01 and board var/audio-diagnosis-a01.
Next: compare raw VOL1 window, PS observation, OSD and PC telemetry before games.
No action on import. Base/start are never retried after an unconfirmed outcome.
"""
import argparse,ast,hashlib,json,subprocess,time
from pathlib import Path

REPO=Path(__file__).resolve().parents[2]
NAME='c6i-pl-vision-volume-osd-r21-marker-r02-20261023'
BOARD='/home/xilinx/voice-view-game/'+NAME
LOG='var/audio-diagnosis-a01'
OUT=REPO/'build/volume-response/integrated-r21-a01'
EVIDENCE=REPO/'subprojects/hdmi_input_osd/integration/evidence'
ARCHIVE_SHA='b63de36c89c6d5718dc789768335de613bf63bfdf5f5e60774c23a97a3e28c78'
SSH=['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8','pynq-z2']


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('action',choices=('stage','arm','base','start','ready','inspect'));p.add_argument('--gate',type=Path,required=True);args=p.parse_args()
    gate=json.loads(args.gate.read_text());assert gate['gate']=='READ_ONLY_IDLE_GATE_PASS'
    boot=gate['state']['boot_id'];OUT.mkdir(parents=True,exist_ok=True)
    count=len(json.loads((REPO/'deliveries'/NAME/'deployment_manifest.json').read_text())['sha256'])
    def remote(label,source,hardware=False,timeout=90):
        ast.parse(source,feature_version=(3,10))
        path=OUT/(label+'.json');assert not path.exists()
        record=dict(source=source,hardware_access=hardware,boot_id=boot,gate_sha256=hashlib.sha256(args.gate.read_bytes()).hexdigest(),started_unix=time.time())
        with path.open('x',encoding='utf-8') as f:
            try:
                r=subprocess.run(SSH+['sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=source,text=True,capture_output=True,timeout=timeout)
                record.update(returncode=r.returncode,stdout=r.stdout,stderr=r.stderr)
            except BaseException as error:record['error']=repr(error);raise
            finally:record['finished_unix']=time.time();json.dump(record,f,indent=2)
        print(label,r.returncode,r.stdout[-1800:],r.stderr[-1000:],flush=True)
        assert r.returncode==0,'preserve failure; no blind retry'
    def prefix():return 'import json,pathlib\nassert pathlib.Path("/proc/sys/kernel/random/boot_id").read_text().strip()=='+repr(boot)+'\n'
    def template(name):
        source=json.loads((EVIDENCE/name).read_text())['remote_code']
        source=source.replace('c6i-pl-vision-volume-osd-r20-admission-r03-20261023',NAME).replace('var/pl-admission-r20-b01',LOG).replace('f56e80d1-0222-4c57-8308-162e279eb32f',boot)
        source=source.replace('== 644','== '+str(count)).replace('==644','=='+str(count))
        assert 'f56e80d1' not in source and 'r20-admission-r03-20261023' not in source
        return source
    if args.action=='stage':
        assert time.time()-gate['finished_unix']<3600
        archive=REPO/'deliveries'/(NAME+'.zip');assert hashlib.sha256(archive.read_bytes()).hexdigest()==ARCHIVE_SHA
        remote('01-stage-create',prefix()+f"import os,pwd\nroot=pathlib.Path({BOARD!r});root.mkdir(exist_ok=False)\np=pwd.getpwnam('xilinx');os.chown(root,p.pw_uid,p.pw_gid)\nprint('R21_STAGE_CREATED')\n")
        command=['scp','-B','-o','BindAddress=192.168.2.1','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes',str(archive),'pynq-z2:'+BOARD+'/package.zip']
        with (OUT/'02-upload.json').open('x') as f:
            r=subprocess.run(command,capture_output=True,text=True,timeout=120);json.dump(dict(command=command,returncode=r.returncode,stdout=r.stdout,stderr=r.stderr),f,indent=2)
        assert r.returncode==0
        source=template('r20-b02-stage-restore.json').replace('expected_file_count=644','expected_file_count='+str(count)).replace('d64e5e7a553f13ef7db04305ea9df902def279b35dbe06c4f7a4427b695cb6d4',ARCHIVE_SHA)
        remote('03-stage-verify',source)
    elif args.action=='arm':
        assert json.loads((OUT/'03-stage-verify.json').read_text())['returncode']==0
        source=template('r20-b03-arm-preflight.json')
        source=source.replace("commands=[[", "commands=[[sys.executable,'-B',str(root/'tools/check_admission_package.py')],[")
        remote('04-arm',source,timeout=180)
    elif args.action=='base':
        assert json.loads((OUT/'04-arm.json').read_text())['returncode']==0
        remote('05-base-stop',template('r20-b04-base-normal-stop.json'),True)
    elif args.action=='start':
        assert json.loads((OUT/'05-base-stop.json').read_text())['returncode']==0
        remote('06-start',template('r20-b05r02-agent-start.json'),True,45)
    elif args.action=='ready':
        source=prefix()+f"import time,threading\nlog=pathlib.Path({BOARD!r})/{LOG!r}\nend=time.monotonic()+50\n"
        source+="while not (log/'service-start.json').exists() or 'voice-view-agent listening' not in (log/'stdout.log').read_text():\n    assert not (log/'service-exit.json').exists(),'owner exited'\n    assert time.monotonic()<end,'ready deadline; retain owner'\n    threading.Event().wait(.25)\nprint(json.dumps(dict(start=json.loads((log/'service-start.json').read_text()),stdout=(log/'stdout.log').read_text(),stderr=(log/'stderr.log').read_text())),flush=True)\n"
        remote('07-ready',source,timeout=65)
    else:
        source=prefix()+f"log=pathlib.Path({BOARD!r})/{LOG!r}\n"
        source+="print(json.dumps({n:(log/n).read_text()[-14000:] if (log/n).exists() else None for n in ('service-start.json','service-exit.json','stdout.log','stderr.log')}),flush=True)\n"
        remote('08-inspect',source,timeout=30)


if __name__=='__main__':main()
