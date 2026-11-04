"""Read-only board gate after confirmed hand-project close records.

Run: .venv/Scripts/python subprojects/volume_response_offline/read_board_state.py --output build/volume-response/board-gate-a01.json
Output: saved SSH request/result and source text, no hardware mapping or writes.
Next: inspect returned boot/owners before planning any hardware operation.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import time

ROOT = Path(__file__).resolve().parents[2]
REMOTE = r'''
import hashlib,json,pathlib,subprocess,importlib.metadata
root=pathlib.Path('/proc')
owners=[];business=[]
for item in root.glob('[0-9]*'):
    try:
        argv=item.joinpath('cmdline').read_bytes().split(bytes([0]))[:-1]
        command=[v.decode(errors='replace') for v in argv]
        maps=item.joinpath('maps').read_text()
        mapped=[s for s in maps.splitlines() if '/dev/mem' in s or '/dev/uio' in s or '/dev/ttyUSB' in s]
        if mapped:
            owners.append(dict(pid=int(item.name),command=command,maps=mapped))
        if any(any(t in arg for t in ('board_buttons.py','start_board_test.py','voice_volume_board.py','voice_view_shell')) for arg in command):
            business.append(dict(pid=int(item.name),command=command))
    except (FileNotFoundError,ProcessLookupError,PermissionError): pass
services={}
for name in ('bootpy.service','clear_pl_statefile.service','voice-view-shell.service'):
    r=subprocess.run(['systemctl','show',name,'-p','ActiveState','-p','MainPID','-p','Result'],capture_output=True,text=True,timeout=5)
    services[name]=dict(returncode=r.returncode,stdout=r.stdout,stderr=r.stderr)
locks={}
for name in ('/var/lock/voice-view-c6i.lock','/run/lock/voice_pcm_audio.lock','/var/lock/voice-view-c6i-volume-owner.json'):
    p=pathlib.Path(name);locks[name]=p.read_text() if p.exists() else None
pynq=pathlib.Path(importlib.metadata.distribution('pynq').locate_file('pynq'))
metadata=pynq/'pl_server/global_pl_state_.json'
source=pynq/'lib/audio.py'
base=pynq/'overlays/base'
info=dict(boot_id=root.joinpath('sys/kernel/random/boot_id').read_text().strip(),owners=owners,business=business,services=services,locks=locks,
          metadata=metadata.read_text() if metadata.exists() else None,pynq_root=str(pynq),
          audio_source=source.read_text(),audio_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
          base_hashes={name:hashlib.sha256((base/name).read_bytes()).hexdigest() for name in ('base.bit','base.hwh')})
print(json.dumps(info),flush=True)
'''


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--expected-boot',default='db5b70bc-7b6e-4af0-9f3a-6845e782b31c')
    args=parser.parse_args()
    handoff=ROOT/'subprojects/pynq_usb_hand/HANDOFF.md'
    facts=ROOT/'docs/bringup/2026-10-23_pynq_usb_hand_board.md'
    assert 'h163' in handoff.read_text(encoding='utf-8')
    assert 'h169终检实际READ_ONLY_PEAK_ANALYSIS_PASS' in facts.read_text(encoding='utf-8')
    release={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in (handoff,facts)}
    args.output.parent.mkdir(parents=True,exist_ok=True)
    command=['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8','pynq-z2',
             'sudo -n /usr/local/share/pynq-venv/bin/python -B -']
    with args.output.open('x',encoding='utf-8') as stream:
        receipt=dict(read_only=True,hardware_access=False,release_records=release,remote_code=REMOTE,command=command,started_unix=time.time())
        try:
            r=subprocess.run(command,input=REMOTE,text=True,capture_output=True,timeout=45)
            receipt.update(returncode=r.returncode,stdout=r.stdout,stderr=r.stderr)
            if r.returncode: raise RuntimeError('read-only SSH gate failed')
            state=json.loads(r.stdout)
            receipt['state']=state
            print(json.dumps({k:v for k,v in state.items() if k not in ('audio_source',)},ensure_ascii=False,indent=2))
            assert state['boot_id']==args.expected_boot,'new boot requires new audit'
            assert not state['owners'] and not state['business'],'active owner; stop'
            assert all(v['returncode']==0 and 'ActiveState=inactive' in v['stdout'] and 'MainPID=0' in v['stdout'] for v in state['services'].values())
            assert all(v in (None,'') for v in state['locks'].values()),'retained owner journal'
            receipt['gate']='READ_ONLY_IDLE_GATE_PASS'
        finally:
            receipt['finished_unix']=time.time()
            json.dump(receipt,stream,ensure_ascii=False,indent=2)


if __name__=='__main__':main()
