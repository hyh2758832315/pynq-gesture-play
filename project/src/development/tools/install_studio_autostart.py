"""Install the persistent, verified Studio boot entry without replacing the SD image.

Run: .venv/Scripts/python.exe -B tools/install_studio_autostart.py --enable-hand --start
Outputs: build/studio-r48/autostart-install.json, remote .studio-system/boot/ and
the backed-up systemd drop-in. Next: verify Agent/hand startup, then reboot test.
"""
import argparse
import base64
import hashlib
import json
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio import system_board
from pynq_multimodal_game.studio.system_loader import run_process

INSTALL=r'''
import base64,hashlib,json,os,subprocess,uuid
from pathlib import Path
p=PAYLOAD
base=Path('/home/xilinx/voice-view-game/.studio-system')
active=json.loads((base/'active.json').read_text())
if active['manifest_sha256']!=p['expected']:raise RuntimeError('Installed identity differs; no configuration changed')
namespace={'__name__':'autostart_install_check'}
exec(compile(base64.b64decode(p['files']['system_board.py']['data']),'system_board.py','exec'),namespace)
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
namespace['verify'](Path(active['root']),p['expected'])
namespace['gate'](None,boot)
unit='voice-view-shell.service'
unit_state=subprocess.check_output(['systemctl','show',unit,'-p','ActiveState','-p','UnitFileState'],text=True)
if 'ActiveState=inactive' not in unit_state:raise RuntimeError('Existing service is not inactive')
out=base/('autostart-install-'+uuid.uuid4().hex);out.mkdir()
(out/'unit-before.txt').write_text(subprocess.check_output(['systemctl','cat',unit],text=True))
(out/'state-before.txt').write_text(unit_state)
target=base/'boot';target.mkdir(exist_ok=True)
def install(path,raw):
    if path.exists():(out/(path.name+'.before')).write_bytes(path.read_bytes())
    temporary=path.with_name(path.name+'.new')
    temporary.write_bytes(raw);temporary.chmod(0o644);temporary.replace(path)
for name,value in p['files'].items():
    if name not in ('system_autostart.py','system_board.py'):raise ValueError('Invalid file')
    raw=base64.b64decode(value['data'])
    if hashlib.sha256(raw).hexdigest()!=value['sha256']:raise ValueError('File identity mismatch')
    install(target/name,raw)
install(target/'config.json',json.dumps(dict(schema='studio-autostart-v1',hand_enabled=p['hand_enabled'],
    authorization='User requested default hand startup on 2026-10-27'),indent=2).encode())
dropin=Path('/etc/systemd/system/voice-view-shell.service.d/90-studio-autostart.conf')
dropin.parent.mkdir(exist_ok=True)
install(dropin,base64.b64decode(p['unit']))
subprocess.run(['systemctl','daemon-reload'],check=True)
verified=subprocess.run(['systemd-analyze','verify',unit],stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
(out/'unit-verify.txt').write_text(verified.stdout)
if verified.returncode:raise RuntimeError('Unit verification failed: '+verified.stdout)
raw=subprocess.check_output(['/usr/local/share/pynq-venv/bin/python','-B',str(target/'system_autostart.py'),'--check'])
checked=json.loads(raw.decode().strip().splitlines()[-1])
(out/'check.json').write_bytes(raw)
subprocess.run(['systemctl','enable',unit],check=True)
if p['start']:subprocess.run(['systemctl','start','--no-block',unit],check=True)
result=dict(result='PASS',boot_id=boot,backup=str(out),default_hand=p['hand_enabled'],
    start_requested=p['start'],unit=unit,check=checked)
(out/'install.json').write_text(json.dumps(result,indent=2))
print(json.dumps(result))
'''

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--enable-hand',action='store_true')
    parser.add_argument('--start',action='store_true')
    parser.add_argument('--candidate',type=Path,default=ROOT/'build/ps-ui-r47-canvas-candidate-r33')
    parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r48')
    args=parser.parse_args()
    system_board.verify(args.candidate,exact=True)
    files={}
    for name in ('system_board.py','system_autostart.py'):
        raw=(ROOT/'python/pynq_multimodal_game/studio'/name).read_bytes()
        files[name]=dict(data=base64.b64encode(raw).decode(),sha256=hashlib.sha256(raw).hexdigest())
    payload=dict(files=files,expected=system_board.sha(args.candidate/'deployment_manifest.json'),
        hand_enabled=args.enable_hand,start=args.start,
        unit=base64.b64encode((ROOT/'board/pynq_z2/studio_autostart.conf').read_bytes()).decode())
    script=INSTALL.replace('p=PAYLOAD','p=json.loads('+repr(json.dumps(payload))+')')
    out=args.output.resolve();out.mkdir(parents=True,exist_ok=True)
    raw=run_process(['ssh','-o','BatchMode=yes','-o','ConnectTimeout=8','-b','192.168.2.1','pynq-z2',
        'sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=script.encode(),timeout=180)
    result=json.loads(raw.decode().strip().splitlines()[-1])
    (out/'autostart-install.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result))

if __name__=='__main__':main()
