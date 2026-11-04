"""Boot the last Studio-installed package without uploading or formatting storage.

Installed beside system_board.py under .studio-system/boot/.
Run: PYNQ Python -B system_autostart.py [--check]
Outputs: .studio-system/<transaction>/{check.log,start.json,console.log}, active.json.
Next: Studio connects to the normal Agent; normal SIGINT must confirm resource release.
"""
import argparse
import json
import os
from pathlib import Path
import subprocess
import time
import uuid

try:
    from . import system_board as board
except ImportError:
    import system_board as board

BOOT_UNITS=('bootpy.service','clear_pl_statefile.service')


def boot_status():
    result=[]
    for unit in BOOT_UNITS:
        raw=subprocess.check_output(['systemctl','show',unit,'-p','ActiveState','-p','Result',
                                     '-p','MainPID','-p','LoadState'],text=True)
        state=dict(line.split('=',1) for line in raw.splitlines() if '=' in line)
        result.append(dict(unit=unit,**state))
    jobs=subprocess.check_output(['systemctl','list-jobs','--no-legend','--no-pager'],text=True)
    ready=all(s.get('LoadState')=='loaded' and s.get('ActiveState')=='inactive'
              and s.get('Result')=='success' and s.get('MainPID')=='0' for s in result)
    return dict(ready=ready and not any(u in jobs for u in BOOT_UNITS),units=result)


def launch_plan(active, config, boot):
    if config.get('schema')!='studio-autostart-v1' or type(config.get('hand_enabled')) is not bool:
        raise ValueError('Invalid explicit autostart configuration')
    root=Path(active['root'])
    if root.is_symlink() or root.parent!=board.BASE or not root.name.startswith('studio-system-'):
        raise ValueError('Unmanaged installed system')
    manifest=board.verify(root,active['manifest_sha256'])
    if board.gate(active,boot):raise RuntimeError('A managed system is already running; leave it untouched')
    # The installed entry already supports no duration limit: stop follows the
    # vision session, including its existing latest-only, stale and OFF contracts.
    hand_enabled=config['hand_enabled']
    reason=None
    port=Path('/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00')
    if hand_enabled and not port.exists():
        hand_enabled=False
        reason='Configured hand USB device absent; interface starts without motor access'
    command=(board.field_command(root,lifetime_seconds=None) if hand_enabled else
             ['/usr/local/share/pynq-venv/bin/python','-B','-u',str(root/'start_board_test.py')])
    return dict(root=str(root),manifest_sha256=active['manifest_sha256'],files=len(manifest['sha256']),
                command=command,hand_enabled=hand_enabled,hand_requested=config['hand_enabled'],hand_note=reason)


def main():
    import fcntl
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check',action='store_true')
    args=parser.parse_args()
    base=board.BASE/'.studio-system'
    with (base/'loader.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        readiness=boot_status()
        if not readiness['ready']:raise RuntimeError('Official boot initialization not complete: '+json.dumps(readiness))
        boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
        active=json.loads((base/'active.json').read_text())
        config=json.loads((base/'boot/config.json').read_text())
        plan=launch_plan(active,config,boot)
        checked=subprocess.run([*plan['command'],'--check-only'],cwd=plan['root'],
            stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=90)
        if checked.returncode:raise RuntimeError('Installed package preflight failed: '+checked.stdout.decode(errors='replace')[-2500:])
        if args.check:
            print(json.dumps(dict(result='PASS',boot_id=boot,readiness=readiness,**plan)))
            return
        # Re-check ownership after imports/check-only, before committing launch.
        if board.gate(active,boot):raise RuntimeError('Another managed start won the ownership race')
        transaction=uuid.uuid4().hex
        out=base/transaction;out.mkdir(exist_ok=False)
        (out/'check.log').write_bytes(checked.stdout)
        ticks=Path('/proc/self/stat').read_text().rsplit(')',1)[1].split()[19]
        record=dict(**plan,transaction=transaction,boot_id=boot,pid=os.getpid(),start_ticks=ticks,
                    started=time.time(),autostart=True,boot_readiness=readiness)
        payload=json.dumps(record,indent=2)
        (out/'start.json').write_text(payload)
        pending=base/('active-'+transaction+'.tmp');pending.write_text(payload)
        pending.replace(base/'active.json')
        os.chdir(plan['root'])
        with (out/'console.log').open('ab') as stream:
            os.dup2(stream.fileno(),1);os.dup2(stream.fileno(),2)
        # exec preserves PID/start_ticks and closes the non-inheritable loader lock.
        os.execv(plan['command'][0],plan['command'])


if __name__=='__main__':main()
