"""Studio's board-side system installer, sent through authenticated SSH stdin.

Invoked by system_loader.py, not as a user startup service. Outputs JSON receipts
under /home/xilinx/voice-view-game/.studio-system/<transaction>/. Next: Studio
checks Agent HELLO before declaring the new system ready. Physical hand startup
is a separate field action requiring the Studio observer confirmation.
"""
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import signal
import runpy
import subprocess
import sys
import tarfile
import time

BASE=Path('/home/xilinx/voice-view-game')
BOOTSTRAP='ps-ui-r43-creative-board-candidate-r31'
# Explicit migration identity from the last Studio-verified system.
BOOTSTRAP_SHA='d20cdba183227abe26494db43bad2580c5c3263252446aad9db7e94db104320a'

def sha(path):
    digest=hashlib.sha256()
    with path.open('rb') as stream:
        for chunk in iter(lambda:stream.read(1024*1024),b''):digest.update(chunk)
    return digest.hexdigest()

def reserve_upload(path):
    # sudo keeps transaction metadata root-owned. Grant the SSH login user
    # access only to this new upload file, never to the installer or receipts.
    path.touch(mode=0o600,exist_ok=False)
    os.chown(path,int(os.environ.get('SUDO_UID',os.getuid())),
             int(os.environ.get('SUDO_GID',os.getgid())))

def safe_name(name):
    p=PurePosixPath(name)
    if (not isinstance(name,str) or not name or p.is_absolute() or '\\' in name
            or ':' in name or any(part in ('..','.') for part in name.split('/'))
            or p.as_posix()!=name):
        raise ValueError('Unsafe manifest path')
    return name

def verify(root,expected=None,*,exact=False):
    manifest_path=root/'deployment_manifest.json'
    if expected and sha(manifest_path)!=expected.lower():raise ValueError('Manifest identity mismatch')
    manifest=json.loads(manifest_path.read_text(encoding='utf-8'))
    if manifest.get('backend')!='c6i-vision-button' or manifest.get('build_id')!='0xC0061000':
        raise ValueError('System requires the frozen C6I VISION BUTTON platform')
    identities=manifest['sha256']
    for name,digest in identities.items():
        path=root/safe_name(name)
        if (path.is_symlink() or not path.resolve().is_relative_to(root.resolve())
                or sha(path)!=digest.lower()):raise ValueError('File identity mismatch: '+name)
    if exact:
        actual={p.relative_to(root).as_posix() for p in root.rglob('*') if p.is_file()}
        if actual!=set(identities)|{'deployment_manifest.json'}:raise ValueError('Unlisted package files')
        if any(p.is_symlink() for p in root.rglob('*')):raise ValueError('Package symlink')
    stage=json.loads((root/'candidate_stage.json').read_text())
    if stage.get('stage')!='PAIRED_PREFLIGHT_READY' or stage.get('profile')!='C6I_VISION_BUTTON_V1':
        raise ValueError('Candidate has not completed hardware/software pairing')
    if stage.get('bit_sha256','').lower()!=sha(root/'overlay/c6v_candidate.bit'):
        raise ValueError('Paired bitstream mismatch')
    return manifest

def unpack(archive,destination,expected):
    with tarfile.open(archive,'r:gz') as tar:
        entries=tar.getmembers()
        names=[safe_name(m.name) for m in entries]
        if len(names)!=len(set(names)) or any(not m.isfile() for m in entries):
            raise ValueError('Archive must contain unique regular files only')
        if sum(m.size for m in entries)>1024**3:raise ValueError('System package exceeds 1 GiB')
        member=tar.getmember('deployment_manifest.json')
        raw=tar.extractfile(member).read()
        if hashlib.sha256(raw).hexdigest()!=expected:raise ValueError('Archive manifest mismatch')
        identities=json.loads(raw)['sha256']
        if set(names)!=set(identities)|{'deployment_manifest.json'}:raise ValueError('Archive file set mismatch')
        destination.mkdir(exist_ok=False)
        for member in entries:
            target=destination/member.name
            target.parent.mkdir(parents=True,exist_ok=True)
            digest=hashlib.sha256();length=0
            with tar.extractfile(member) as source, target.open('xb') as output:
                for chunk in iter(lambda:source.read(1024*1024),b''):
                    digest.update(chunk);output.write(chunk);length+=len(chunk)
            if length!=member.size:raise ValueError('Archive file length mismatch: '+member.name)
            if member.name!='deployment_manifest.json' and digest.hexdigest()!=identities[member.name].lower():
                raise ValueError('Archive file mismatch: '+member.name)
            target.chmod(0o755 if member.mode & 0o111 else 0o644)
    return verify(destination,expected,exact=True)

def processes():
    rows={}
    for path in Path('/proc').glob('[0-9]*'):
        try:
            stat=(path/'stat').read_text().rsplit(')',1)[1].split()
            argv=(path/'cmdline').read_bytes().split(b'\0')
            targets=[]
            for fd in (path/'fd').iterdir():
                try:
                    link=os.readlink(fd)
                    if link=='/dev/mem' or link.startswith(('/dev/uio','/dev/ttyACM','/dev/ttyUSB')):targets.append(link)
                except OSError:pass
            # MMIO may outlive the descriptor used to mmap it.
            for line in (path/'maps').read_text(errors='replace').splitlines():
                if '/dev/mem' in line or '/dev/uio' in line:
                    targets.append(line.split()[-1])
            command=b' '.join(argv).decode(errors='replace')
            names=('start_board_test.py','serial_motion_receiver.py','project1_live_ov5640.py',
                   'capture_camera_direct_plug.py','run_camera_live_guarded.py','run_accel_guarded.py')
            owner=bool(targets) or any(Path(a.decode(errors='replace')).name in names for a in argv)
            rows[int(path.name)]=dict(ppid=int(stat[1]),ticks=stat[19],state=stat[0],command=command,
                                      argv=argv,owner=owner,devices=targets)
        except (OSError,ProcessLookupError,IndexError):pass
    return rows

def owned_tree(rows,record,boot):
    if not record or record.get('boot_id')!=boot:return set()
    pid=record['pid'];p=rows.get(pid)
    if not p or p['state']=='Z':return set()
    if p['ticks']!=record['start_ticks'] or str(Path(record['root'])/'start_board_test.py').encode() not in p['argv']:
        return set()
    owned={pid}
    while True:
        more={pid for pid,p in rows.items() if p['ppid'] in owned}-owned
        if not more:return owned
        owned.update(more)

def gate(record,boot):
    rows=processes();owned=owned_tree(rows,record,boot)
    foreign=[dict(pid=pid,command=p['command'],devices=p['devices']) for pid,p in rows.items()
             if p['owner'] and pid not in owned and p['state']!='Z']
    if foreign:raise RuntimeError('Board occupied by another owner: '+json.dumps(foreign))
    return owned

def stop_owned(record,boot):
    owned=gate(record,boot)
    if owned:
        os.kill(record['pid'],signal.SIGINT)
        deadline=time.monotonic()+90  # child drain plus bounded shutdown-only OFF probe
        while owned_tree(processes(),record,boot):
            if time.monotonic()>deadline:raise RuntimeError('Normal shutdown timed out; owner retained')
            time.sleep(.2)
    if record and record.get('boot_id')==boot:
        receipts=[json.loads(p.read_text()) for p in (Path(record['root'])/'var/vision').rglob('stop_receipt.json')
                  if p.stat().st_mtime>=record['started']]
        if not receipts or any(not r.get('cleanup_confirmed') or r.get('error') for r in receipts):
            raise RuntimeError('Vision shutdown receipt does not confirm release')
        if record.get('hand_enabled'):
            hand=[p for p in (Path(record['root'])/'var/vision').rglob('serial-motion.json')
                  if p.stat().st_mtime>=record['started']]
            if not hand or any(not hand_shutdown_off(p,record) for p in hand):
                raise RuntimeError('Hand shutdown has not confirmed all 17 motors OFF')
    gate(None,boot)


def hand_shutdown_off(path,record):
    """Accept original OFF or a separately verified, identity-bound read-only proof."""
    value=json.loads(path.read_text())
    if value.get('backend_closed') is not True:return False
    if value.get('release_confirmed') is True and value.get('release_confirmed_ids')==list(range(1,18)):
        return True
    try:
        proof_path=path.parent/'cleanup-off-recheck.json'
        proof=json.loads(proof_path.read_text())
        probe=Path(proof['probe_path'])
        if (proof.get('schema')!='hand-off-recheck-v1'
                or proof.get('session')!=value.get('session') or not value.get('session')
                or proof.get('game_run')!=value.get('game_run')
                or proof.get('original_sha256')!=sha(path)
                or type(proof.get('child_exit')) is not int
                or proof_path.stat().st_mtime<record['started']
                or not probe.resolve().is_relative_to(path.parent.resolve())
                or sha(probe)!=proof.get('probe_sha256')):return False
        checker=Path(record['root'])/'python/pynq_multimodal_game/startup_checks.py'
        manifest=json.loads((Path(record['root'])/'deployment_manifest.json').read_text())
        if sha(checker)!=manifest['sha256']['python/pynq_multimodal_game/startup_checks.py'].lower():return False
        verify=runpy.run_path(str(checker))['verify_hand_readonly_report']
        return verify(json.loads(probe.read_text()),
                      port='/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00',motor_ids=range(1,18)) is True
    except (OSError,ValueError,KeyError,RuntimeError,TypeError):
        return False


def resume_release_gate(record,boot):
    """An exited, hand-disabled startup may retry only with verified cleanup."""
    if record.get('hand_enabled'):
        raise RuntimeError('Resume requires a hand-disabled installed startup')
    gate(None,boot)
    root=Path(record['root'])/'var/vision'
    if root.exists() and any(root.iterdir()):
        stop_owned(record,boot)


def field_pairing_check(active, boot, command, root):
    """Run the heavy offline import check only after the live owner releases."""
    stop_owned(active, boot)
    return subprocess.run([*command, '--check-only'], cwd=root,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=90)


def field_command(root, *, lifetime_seconds=1800):
    port=Path('/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00')
    if not port.exists():raise RuntimeError('Verified hand USB serial device is absent')
    hand_root=root/'hand-runtime'
    if not hand_root.exists():hand_root=BASE/'hand-r43-creative-r06'
    command=['/usr/local/share/pynq-venv/bin/python','-B','-u',str(root/'start_board_test.py'),
        '--hand-readonly-root',str(hand_root),
        '--hand-readonly-python','/home/xilinx/pynq-usb-hand/board-20261023-r01/venv/bin/python',
        '--hand-readonly-port',str(port),'--hand-serial-actions',
        '--hand-stage-waits','3','3','3','--hand-approval-seconds','3']
    if lifetime_seconds is not None:command.extend(('--hand-serial-seconds',str(lifetime_seconds)))
    return command

def library_files(root):
    if not root.exists():return {}
    files={}
    for p in root.rglob('*'):
        if p.is_symlink():raise ValueError('Content library contains a symlink')
        if p.is_file():files[p.relative_to(root).as_posix()]=sha(p)
    return files


def previous_installation(active):
    """Fresh stock systems have no project or library to migrate."""
    if active:
        previous = Path(active['root'])
        if previous.is_symlink() or previous.parent != BASE or not previous.name.startswith('studio-system-'):
            raise ValueError('Unmanaged installed system')
        verify(previous, active['manifest_sha256'])
        return previous, active['manifest_sha256']
    previous = BASE / BOOTSTRAP
    if previous.exists():
        verify(previous, BOOTSTRAP_SHA)
        return previous, BOOTSTRAP_SHA
    return None, None


def prepare_current_start(active, boot, *, hand_requested):
    """Only explicit hand enable may replace a running interface-only owner."""
    root, _ = previous_installation(active)
    running = gate(active, boot)
    if running and (not hand_requested or active.get('hand_enabled')):
        raise RuntimeError('Project is already running; connect instead of launching another owner')
    stop_owned(active, boot)
    return root

def quiesce_prepared(active, prepared, expected, boot):
    """Confirm the reserved identity, then release all old owners before SCP."""
    if (prepared['boot_id']!=boot or prepared['manifest_sha256']!=expected
            or prepared.get('previous_owner')!=active):
        raise RuntimeError('Board or managed owner changed after preflight')
    stop_owned(active,boot)
    gate(None,boot)
    return dict(boot_id=boot,manifest_sha256=expected,stopped=True,owners=[])


def main():
    import fcntl
    action,transaction,expected=sys.argv[1:]
    if action not in ('prepare','quiesce','install','resume','status','stop','field-check','field-start',
                      'start-current','start-current-hand') or not re.fullmatch('[a-f0-9]{32}',transaction):
        raise ValueError('Invalid Studio transaction')
    if not re.fullmatch('[a-f0-9]{64}',expected):raise ValueError('Invalid manifest SHA')
    base=BASE/'.studio-system';base.mkdir(parents=True,exist_ok=True)
    with (base/'loader.lock').open('a') as lock:
        try:
            fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        except BlockingIOError:
            print(json.dumps(dict(result='BUSY',retry_after=2,
                message='板卡正在执行启动或安装事务，等待后重新检查')),flush=True)
            return
        boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
        active_path=base/'active.json'
        active=json.loads(active_path.read_text()) if active_path.exists() else None
        out=base/transaction
        if action in ('start-current', 'start-current-hand'):
            if not active or active['manifest_sha256'] != expected:
                raise RuntimeError('Installed project changed; check the board again')
            if gate(active,boot) and (action=='start-current' or active.get('hand_enabled')):
                print(json.dumps(dict(result='BUSY',retry_after=2,
                    message='项目已由其他启动入口启动，重新检查并连接')),flush=True)
                return
            root = prepare_current_start(active, boot, hand_requested=action == 'start-current-hand')
            command = (field_command(root, lifetime_seconds=None) if action == 'start-current-hand' else
                       ['/usr/local/share/pynq-venv/bin/python', '-B', '-u', str(root/'start_board_test.py')])
            out.mkdir(exist_ok=False)
            check = subprocess.run([*command, '--check-only'], cwd=root, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT, timeout=90)
            (out/'check.log').write_bytes(check.stdout)
            if check.returncode:
                raise RuntimeError('Installed project check failed: ' + check.stdout.decode(errors='replace')[-2000:])
            gate(None, boot)
            with (out/'console.log').open('wb') as stream:
                child = subprocess.Popen(command, cwd=root, stdout=stream,
                                         stderr=subprocess.STDOUT, start_new_session=True)
            result = dict(root=str(root), boot_id=boot, pid=child.pid,
                start_ticks=processes()[child.pid]['ticks'], started=time.time(),
                manifest_sha256=expected, hand_enabled=action == 'start-current-hand',
                command=command, transaction=transaction)
            pending = base/('active-'+transaction+'.tmp')
            pending.write_text(json.dumps(result, indent=2)); pending.replace(active_path)
            (out/'start.json').write_text(json.dumps(result, indent=2))
        elif action in ('field-check','field-start'):
            if not active or active['manifest_sha256']!=expected:raise RuntimeError('Current Studio system identity differs')
            root=Path(active['root'])
            if root.parent!=BASE or not root.name.startswith('studio-system-'):raise ValueError('Unmanaged system root')
            gate(active,boot)
            manifest=verify(root,expected)
            command=field_command(root)
            if action=='field-check':
                out.mkdir(exist_ok=False)
                checked=field_pairing_check(active,boot,command,root)
                (out/'check.log').write_bytes(checked.stdout)
                if checked.returncode:raise RuntimeError('Hand pairing preflight failed: '+checked.stdout.decode(errors='replace')[-2500:])
                result=dict(root=str(root),boot_id=boot,manifest_sha256=expected,command=command,
                    addresses=subprocess.check_output(['hostname','-I'],text=True).split())
                (out/'field-check.json').write_text(json.dumps(result))
            else:
                checked=json.loads((out/'field-check.json').read_text())
                if checked['boot_id']!=boot or checked['root']!=str(root) or checked['command']!=command:
                    raise RuntimeError('Field configuration changed after preflight')
                stop_owned(active,boot)
                started=time.time()
                with (out/'console.log').open('wb') as stream:
                    child=subprocess.Popen(command,cwd=root,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
                result=dict(root=str(root),boot_id=boot,pid=child.pid,start_ticks=processes()[child.pid]['ticks'],
                    started=started,manifest_sha256=expected,files=len(manifest['sha256']),
                    hand_enabled=True,command=command,observer_confirmed=True)
                active_path.write_text(json.dumps(result,indent=2));(out/'start.json').write_text(json.dumps(result,indent=2))
        elif action=='prepare':
            gate(active,boot)
            previous, previous_sha = previous_installation(active)
            out.mkdir(exist_ok=False)
            reserve_upload(out/'package.tar.gz')
            result=dict(boot_id=boot,previous_root=str(previous) if previous else None,previous_sha=previous_sha,
                        previous_owner=active,
                        archive=str(out/'package.tar.gz'),manifest_sha256=expected,
                        addresses=subprocess.check_output(['hostname','-I'],text=True).split())
            disk=shutil.disk_usage(BASE)
            result['storage']=dict(free=disk.free,total=disk.total,
                library_bytes=sum(p.stat().st_size for p in (previous/'var/library').rglob('*') if p.is_file()) if previous else 0)
            (out/'prepare.json').write_text(json.dumps(result))
        elif action=='quiesce':
            prepare=json.loads((out/'prepare.json').read_text())
            result=quiesce_prepared(active,prepare,expected,boot)
            (out/'quiesced.json').write_text(json.dumps(result))
        elif action=='install':
            prepare=json.loads((out/'prepare.json').read_text())
            if prepare['boot_id']!=boot or prepare['manifest_sha256']!=expected:raise RuntimeError('Board changed after preflight')
            quiesced=json.loads((out/'quiesced.json').read_text())
            if (quiesced['boot_id']!=boot or quiesced['manifest_sha256']!=expected
                    or not quiesced['stopped'] or prepare.get('previous_owner')!=active):
                raise RuntimeError('Upload shutdown receipt or owner identity changed')
            gate(None,boot)
            root=BASE/('studio-system-'+transaction)
            manifest=unpack(out/'package.tar.gz',root,expected)
            check=subprocess.run(['/usr/local/share/pynq-venv/bin/python','-B',str(root/'start_board_test.py'),'--check-only'],
                                 cwd=root,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=90)
            (out/'check.log').write_bytes(check.stdout)
            if check.returncode:raise RuntimeError('Candidate preflight failed; see check.log')
            # Old capture/hand work was already normally stopped before SCP.
            previous=Path(prepare['previous_root'])/'var/library' if prepare['previous_root'] else None
            before=library_files(previous) if previous else {}
            if previous is not None and previous.exists():shutil.copytree(previous,root/'var/library')
            if library_files(root/'var/library')!=before:raise RuntimeError('Content library copy mismatch')
            gate(None,boot)
            command=['/usr/local/share/pynq-venv/bin/python','-B','-u',str(root/'start_board_test.py')]
            with (out/'console.log').open('wb') as stream:
                child=subprocess.Popen(command,cwd=root,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
            result=dict(root=str(root),boot_id=boot,pid=child.pid,start_ticks=processes()[child.pid]['ticks'],
                        started=time.time(),manifest_sha256=expected,files=len(manifest['sha256']),
                        hand_enabled=False,previous_root=prepare['previous_root'],library_sha256=before)
            active_path.write_text(json.dumps(result,indent=2));(out/'start.json').write_text(json.dumps(result,indent=2))
        elif action=='resume':
            record=json.loads((out/'start.json').read_text())
            if active!=record or record['manifest_sha256']!=expected or record.get('hand_enabled'):
                raise RuntimeError('Resume requires the same installed, hand-disabled system')
            gate(None,boot)  # Never restart a running or foreign owner.
            root=Path(record['root'])
            if root.parent!=BASE or root.name!='studio-system-'+transaction:
                raise ValueError('Unmanaged resume root')
            verify(root,expected)
            # A failed first-frame attempt is recoverable after its ordinary
            # stop receipt proves all owners released. No delete/reload bypass.
            resume_release_gate(record,boot)
            command=['/usr/local/share/pynq-venv/bin/python','-B','-u',str(root/'start_board_test.py')]
            (out/'failed-start.json').write_text(json.dumps(record,indent=2))
            with (out/'console.log').open('ab') as stream:
                stream.write(b'\nSTUDIO_RESUME_INSTALLED\n');stream.flush()
                child=subprocess.Popen(command,cwd=root,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
            result=dict(record,boot_id=boot,pid=child.pid,start_ticks=processes()[child.pid]['ticks'],started=time.time())
            active_path.write_text(json.dumps(result,indent=2));(out/'start.json').write_text(json.dumps(result,indent=2))
        else:
            record=json.loads((out/'start.json').read_text())
            if record['manifest_sha256']!=expected:raise ValueError('Wrong installed identity')
            if action=='stop':stop_owned(record,boot)
            rows=processes()
            result=dict(boot_id=boot,running=bool(owned_tree(rows,record,boot)),
                        owners=[dict(pid=pid,command=p['command']) for pid,p in rows.items() if p['owner']],
                        console=(out/'console.log').read_text(errors='replace').splitlines()[-35:])
            if action=='stop':
                evidence=[]
                if record['boot_id']==boot:
                    for name in ('stop_receipt.json','serial-motion.json'):
                        for path in (Path(record['root'])/'var/vision').rglob(name):
                            if path.stat().st_mtime<record['started']:continue
                            value=json.loads(path.read_text())
                            keys=('schema','session','run_id','error','cleanup_confirmed','backend_closed',
                                  'release_confirmed','release_confirmed_ids','source_stop_reason')
                            evidence.append(dict(path=str(path),sha256=sha(path),
                                summary={k:value[k] for k in keys if k in value}))
                result['shutdown_evidence']=evidence
                (out/'stop.json').write_text(json.dumps(result,indent=2))
        print(json.dumps(result),flush=True)

if __name__=='__main__':main()
