"""Start previously proven R20 for a single real-time audio diagnostic control.

Run: python deploy_r20_audio_control.py ACTION --gate <fresh idle gate>
Actions: arm, base, start, ready. Output: exclusive JSON receipts in
build/volume-response/integrated-r20-control-a01 and board var/audio-control-a01.
Next: record default-menu PL/OSD/PC levels, then normal STOP; do not repeat
an unconfirmed hardware phase. No action on import.
"""
import argparse,ast,hashlib,json,subprocess,time
from pathlib import Path

REPO=Path(__file__).resolve().parents[2]
BOARD='/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'
LOG='var/audio-control-a01'
OUT=REPO/'build/volume-response/integrated-r20-control-a01'
OLD_BOOT='f56e80d1-0222-4c57-8308-162e279eb32f'
EVIDENCE=REPO/'subprojects/hdmi_input_osd/integration/evidence'
SSH=['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8','pynq-z2']


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('action',choices=('arm','base','start','ready'));p.add_argument('--gate',type=Path,required=True);args=p.parse_args()
    gate=json.loads(args.gate.read_text());assert gate['gate']=='READ_ONLY_IDLE_GATE_PASS'
    boot=gate['state']['boot_id'];assert time.time()-gate['finished_unix']<3600
    OUT.mkdir(parents=True,exist_ok=True)
    def source(name):
        text=json.loads((EVIDENCE/name).read_text())['remote_code']
        assert OLD_BOOT in text and 'var/pl-admission-r20-b01' in text if name!='r20-b03-arm-preflight.json' else OLD_BOOT in text
        text=text.replace(OLD_BOOT,boot).replace('var/pl-admission-r20-b01',LOG)
        assert OLD_BOOT not in text
        ast.parse(text,feature_version=(3,10));return text
    def run(label,text,hardware=False,timeout=100):
        target=OUT/(label+'.json');assert not target.exists()
        receipt=dict(source=text,boot_id=boot,gate_sha256=hashlib.sha256(args.gate.read_bytes()).hexdigest(),hardware_access=hardware,started_unix=time.time())
        with target.open('x',encoding='utf-8') as out:
            try:
                r=subprocess.run(SSH+['sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=text,text=True,capture_output=True,timeout=timeout)
                receipt.update(returncode=r.returncode,stdout=r.stdout,stderr=r.stderr)
            except BaseException as error:receipt['error']=repr(error);raise
            finally:receipt['finished_unix']=time.time();json.dump(receipt,out,indent=2)
        print(label,r.returncode,r.stdout[-2000:],r.stderr[-500:],flush=True)
        assert r.returncode==0,'preserve failure; no blind retry'
    if args.action=='arm':
        text=source('r20-b03-arm-preflight.json')
        text=text.replace("commands=[[", "commands=[[sys.executable,'-B',str(root/'tools/check_admission_package.py')],[")
        run('01-arm',text,timeout=180)
    elif args.action=='base':
        assert json.loads((OUT/'01-arm.json').read_text())['returncode']==0
        run('02-base-stop',source('r20-b04-base-normal-stop.json'),True,100)
    elif args.action=='start':
        assert json.loads((OUT/'02-base-stop.json').read_text())['returncode']==0
        run('03-start',source('r20-b05r02-agent-start.json'),True,45)
    else:
        assert json.loads((OUT/'03-start.json').read_text())['returncode']==0
        text=source('r20-b06-agent-ready.json').replace('deadline=time.monotonic()+75','deadline=time.monotonic()+45')
        run('04-ready',text,False,58)


if __name__=='__main__':main()
