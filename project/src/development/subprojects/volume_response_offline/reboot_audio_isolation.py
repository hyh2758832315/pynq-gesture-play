"""Normal reboot after the completed isolated audio test, with identity checks.

Run: .venv/Scripts/python subprojects/volume_response_offline/reboot_audio_isolation.py
     --receipt build/volume-response/codec-pl-a02/board-receipt.json
     --output build/volume-response/codec-pl-a02/reboot.json
Output: exclusive pre-reboot ownership and request receipt. Next: use a new idle
gate after boot services finish; request success alone is not boot completion.
"""
import argparse
import json
import subprocess
from pathlib import Path

from isolate_codec_pl import SSH, BOARD


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--receipt',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True)
    a=p.parse_args()
    prior=json.loads(a.receipt.read_text())
    assert prior['phase']=='measured' and prior['cleanup_confirmed'] and prior['sampling_disabled'] and prior['registers_restored']
    remote=BOARD+'/var/'+a.receipt.parent.name+'/board-receipt.json'
    source='''import pathlib,json,subprocess,os
boot=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot==__BOOT__
receipt=json.loads(pathlib.Path(__RECEIPT__).read_text())
assert receipt==__PRIOR__
owners=[]
for path in pathlib.Path('/proc').glob('[0-9]*/maps'):
    try:
        text=path.read_text()
        if '/dev/mem' in text or '/dev/uio' in text or '/dev/ttyUSB' in text:owners.append(str(path))
    except (FileNotFoundError,ProcessLookupError):pass
assert not owners,owners
assert not pathlib.Path('/proc/'+str(receipt['pid'])).exists(),'diagnostic PID still exists'
marker=pathlib.Path(__RECEIPT__).parent/'normal-reboot.attempt'
with marker.open('x') as f:json.dump(dict(boot=boot,owners=owners,pid=os.getpid()),f);f.flush();os.fsync(f.fileno())
print(json.dumps(dict(boot=boot,owners=owners,normal_reboot_requested=True)),flush=True)
subprocess.run(['systemctl','reboot'],check=True)
'''.replace('__BOOT__',repr(prior['boot_id'])).replace('__RECEIPT__',repr(remote)).replace('__PRIOR__',repr(prior))
    # Entire receipt comparison binds the exact completed run, not a stale PID.
    record=dict(source=source,forced=False)
    with a.output.open('x',encoding='utf-8') as file:
        try:
            r=subprocess.run(SSH+['sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=source,capture_output=True,text=True,timeout=20)
            record.update(returncode=r.returncode,stdout=r.stdout,stderr=r.stderr)
        finally:json.dump(record,file,indent=2)
    print(r.returncode,r.stdout,r.stderr)
    assert r.returncode==0


if __name__=='__main__':main()
