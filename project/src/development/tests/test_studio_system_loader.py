"""System loading uses a verified package, matching host and bounded ownership."""
import hashlib
import io
import json
from pathlib import Path
import shlex
import tarfile
import threading
from types import SimpleNamespace
import pytest
from pynq_multimodal_game.studio import system_board as board
from pynq_multimodal_game.studio.system_loader import SystemLoader
from pynq_multimodal_game.studio.device import DeviceState


def test_fresh_board_has_no_required_historical_install(tmp_path,monkeypatch):
    monkeypatch.setattr(board,'BASE',tmp_path/'not-created-yet')
    assert board.previous_installation(None)==(None,None)
    # An existing migration must still verify, never silently drop its library.
    (board.BASE/board.BOOTSTRAP).mkdir(parents=True)
    with pytest.raises(FileNotFoundError):board.previous_installation(None)


def test_fresh_board_prepare_quiesce_and_install(candidate,tmp_path,monkeypatch):
    import shutil
    base=tmp_path/'stock/home/xilinx/voice-view-game'
    monkeypatch.setattr(board,'BASE',base)
    monkeypatch.setitem(__import__('sys').modules,'fcntl',SimpleNamespace(LOCK_EX=1,LOCK_NB=2,flock=lambda *a:None))
    monkeypatch.setattr(board,'gate',lambda *a:set())
    monkeypatch.setattr(board,'stop_owned',lambda *a:None)
    monkeypatch.setattr(board,'reserve_upload',lambda path:path.touch())
    original_read=Path.read_text
    monkeypatch.setattr(Path,'read_text',lambda p,*a,**kw:'boot' if str(p).replace('\\','/')=='/proc/sys/kernel/random/boot_id' else original_read(p,*a,**kw))
    monkeypatch.setattr(board.subprocess,'check_output',lambda *a,**kw:'192.168.2.99')
    monkeypatch.setattr(board.subprocess,'run',lambda *a,**kw:SimpleNamespace(returncode=0,stdout=b'CHECK_PASS'))
    monkeypatch.setattr(board.subprocess,'Popen',lambda *a,**kw:SimpleNamespace(pid=100))
    monkeypatch.setattr(board,'processes',lambda:{100:dict(ticks='123')})
    identity=board.sha(candidate/'deployment_manifest.json');transaction='a'*32
    def invoke(action):
        monkeypatch.setattr(board.sys,'argv',['installer',action,transaction,identity]);board.main()
    invoke('prepare')
    out=base/'.studio-system'/transaction
    prepare=json.loads((out/'prepare.json').read_text())
    assert prepare['previous_root'] is None and prepare['storage']['library_bytes']==0
    invoke('quiesce')
    with tarfile.open(out/'package.tar.gz','w:gz') as archive:
        for path in candidate.rglob('*'):
            if path.is_file():archive.add(path,arcname=path.relative_to(candidate).as_posix())
    invoke('install')
    active=json.loads((base/'.studio-system/active.json').read_text())
    assert active['manifest_sha256']==identity and active['library_sha256']=={}
    assert not active['hand_enabled']


def test_start_stopped_project_without_agent_or_local_package(tmp_path,monkeypatch):
    calls=[]
    loader=SystemLoader(Device())
    monkeypatch.setattr(loader,'inspect',lambda **kw:dict(installed=dict(manifest_sha256='a'*64),
        runtime_available=True,running=False))
    monkeypatch.setattr(loader,'remote',lambda action,*args: calls.append(action) or dict(boot_id='boot',running=True))
    result=loader.start_installed(tmp_path/'start')
    assert result['result']=='PASS' and not result['hand_enabled']
    assert calls==['start-current','status']
    assert json.loads((tmp_path/'start/receipt.json').read_text())['result']=='PASS'


def test_reconnect_to_running_project_never_starts_second_owner(tmp_path,monkeypatch):
    loader=SystemLoader(Device())
    monkeypatch.setattr(loader,'inspect',lambda **kw:dict(installed=dict(manifest_sha256='a'*64,hand_enabled=True),
        runtime_available=True,running=True))
    monkeypatch.setattr(loader,'remote',lambda *a:pytest.fail('must not start or stop'))
    result=loader.start_installed(tmp_path/'start')
    assert result['already_running'] and result['hand_enabled']


def test_running_project_initialization_is_retried_without_second_start(tmp_path,monkeypatch):
    loader=SystemLoader(Device());attempts=[]
    monkeypatch.setattr(loader,'inspect',lambda **kw:dict(installed=dict(
        manifest_sha256='a'*64,hand_enabled=True),runtime_available=True,running=True))
    ready=loader.device.connect()
    def connect():
        attempts.append(1)
        if len(attempts)==1:raise OSError('Agent restarting')
        return ready
    monkeypatch.setattr(loader.device,'connect',connect)
    monkeypatch.setattr(loader,'remote',lambda *a:pytest.fail('must not start another owner'))
    stop=SimpleNamespace(is_set=lambda:False,wait=lambda _:None)
    result=loader.start_installed(tmp_path/'waiting',stop_event=stop)
    assert len(attempts)==2 and result['result']=='PASS'


def test_start_waits_for_boot_lock_then_attaches_without_launch(tmp_path,monkeypatch):
    loader=SystemLoader(Device());reads=[];waits=[];messages=[]
    active=dict(manifest_sha256='a'*64,hand_enabled=True)
    def inspect(**kw):
        reads.append(1)
        return dict(ssh_ready=True,installed=active,runtime_available=True,
            loader_busy=len(reads)<3,running=len(reads)>=3,hand_default=True,hand_available=True)
    monkeypatch.setattr(loader,'inspect',inspect)
    monkeypatch.setattr(loader,'remote',lambda *a:pytest.fail('autostart owns the only launch'))
    stop=SimpleNamespace(is_set=lambda:False,wait=waits.append)
    result=loader.start_installed(tmp_path/'boot',hand_enabled=None,stop_event=stop,progress=messages.append)
    assert result['result']=='PASS' and result['already_running'] and result['hand_enabled']
    assert waits==[2,2] and any('自动等待' in m for m in messages)


def test_start_rechecks_when_lock_is_taken_after_probe(tmp_path,monkeypatch):
    from pynq_multimodal_game.studio.system_loader import BoardBusyError
    loader=SystemLoader(Device());reads=[];calls=[]
    def inspect(**kw):
        reads.append(1)
        return dict(installed=dict(manifest_sha256='a'*64,hand_enabled=True),
                    runtime_available=True,running=len(reads)>1)
    def remote(action,*args):calls.append(action);raise BoardBusyError('boot won race')
    monkeypatch.setattr(loader,'inspect',inspect);monkeypatch.setattr(loader,'remote',remote)
    stop=SimpleNamespace(is_set=lambda:False,wait=lambda _:None)
    result=loader.start_installed(tmp_path/'race',hand_enabled=None,stop_event=stop)
    assert calls==['start-current-hand'] and result['already_running']


@pytest.mark.parametrize('present,action',[(True,'start-current-hand'),(False,'start-current')])
def test_single_start_uses_default_hand_and_absence_fallback(tmp_path,monkeypatch,present,action):
    loader=SystemLoader(Device());calls=[]
    monkeypatch.setattr(loader,'inspect',lambda **kw:dict(installed=dict(manifest_sha256='a'*64),
        runtime_available=True,running=False,hand_default=True,hand_available=present))
    monkeypatch.setattr(loader,'remote',lambda name,*a:calls.append(name) or dict(boot_id='b',running=True))
    result=loader.start_installed(tmp_path/'auto',hand_enabled=None)
    assert calls==[action,'status'] and result['hand_enabled'] is present


def test_cancel_during_boot_wait_does_not_launch(tmp_path,monkeypatch):
    loader=SystemLoader(Device());stop=threading.Event()
    def inspect(**kw):stop.set();return dict(loader_busy=True)
    monkeypatch.setattr(loader,'inspect',inspect)
    monkeypatch.setattr(loader,'remote',lambda *a:pytest.fail('cancelled'))
    with pytest.raises(InterruptedError):loader.start_installed(tmp_path/'cancel',stop_event=stop)


def test_board_lock_contention_returns_busy_without_any_launch(monkeypatch,tmp_path,capsys):
    import sys
    monkeypatch.setattr(board,'BASE',tmp_path)
    def flock(*a):raise BlockingIOError(11,'busy')
    monkeypatch.setitem(sys.modules,'fcntl',SimpleNamespace(LOCK_EX=1,LOCK_NB=2,flock=flock))
    monkeypatch.setattr(board.sys,'argv',['installer','start-current','a'*32,'b'*64])
    board.main()
    assert json.loads(capsys.readouterr().out)['result']=='BUSY'
    assert not (tmp_path/'.studio-system'/'active.json').exists()


def test_explicit_hand_enable_normally_replaces_interface_only_instance(tmp_path,monkeypatch):
    calls=[]
    loader=SystemLoader(Device())
    monkeypatch.setattr(loader,'inspect',lambda **kw:dict(installed=dict(manifest_sha256='a'*64,hand_enabled=False),
        runtime_available=True,running=True))
    monkeypatch.setattr(loader,'remote',lambda action,*a:calls.append(action) or dict(boot_id='boot',running=True))
    result=loader.start_installed(tmp_path/'start',hand_enabled=True)
    assert calls==['start-current-hand','status'] and result['hand_enabled']
    active=dict(hand_enabled=False)
    monkeypatch.setattr(board,'previous_installation',lambda a:(tmp_path,'sha'))
    monkeypatch.setattr(board,'gate',lambda *a:{7})
    monkeypatch.setattr(board,'stop_owned',lambda *a:calls.append('released'))
    assert board.prepare_current_start(active,'boot',hand_requested=True)==tmp_path
    assert calls[-1]=='released'
    with pytest.raises(RuntimeError,match='already running'):
        board.prepare_current_start(active,'boot',hand_requested=False)
    with pytest.raises(RuntimeError,match='already running'):
        board.prepare_current_start(dict(hand_enabled=True),'boot',hand_requested=True)
    def failed(*a):raise RuntimeError('release unconfirmed')
    monkeypatch.setattr(board,'stop_owned',failed)
    with pytest.raises(RuntimeError,match='release unconfirmed'):
        board.prepare_current_start(active,'boot',hand_requested=True)


def test_missing_install_reports_action_and_does_not_launch(tmp_path,monkeypatch):
    loader=SystemLoader(Device())
    monkeypatch.setattr(loader,'inspect',lambda **kw:dict(installed=None,runtime_available=True,running=False))
    monkeypatch.setattr(loader,'remote',lambda *a:pytest.fail('must not launch'))
    with pytest.raises(RuntimeError,match='尚未安装'):loader.start_installed(tmp_path/'start')


def test_content_bootstrap_selects_install_or_start(tmp_path,monkeypatch):
    loader=SystemLoader(Device());calls=[]
    monkeypatch.setattr(loader,'start_installed',lambda *a,**kw:calls.append('start'))
    monkeypatch.setattr(loader,'load',lambda *a,**kw:calls.append('install'))
    monkeypatch.setattr(loader,'inspect',lambda **kw:dict(installed={'root':'installed'}))
    loader.ensure_running(None,tmp_path/'one')
    monkeypatch.setattr(loader,'inspect',lambda **kw:dict(installed=None))
    loader.ensure_running(tmp_path/'candidate',tmp_path/'two')
    assert calls==['start','install']
    with pytest.raises(RuntimeError,match='完整系统包'):loader.ensure_running(None,tmp_path/'three')


@pytest.mark.parametrize('tamper',[None,'torque','missing','identity','hash','open','outside'])
def test_shutdown_recheck_requires_complete_bound_off(tmp_path,tamper):
    import shutil
    root=tmp_path/'system';session=root/'var/vision/hand';session.mkdir(parents=True)
    checker=root/'python/pynq_multimodal_game/startup_checks.py';checker.parent.mkdir(parents=True)
    shutil.copy2(Path(__file__).parents[1]/'subprojects/ps_ui_r23b2/python/pynq_multimodal_game/startup_checks.py',checker)
    (root/'deployment_manifest.json').write_text(json.dumps({'sha256':{'python/pynq_multimodal_game/startup_checks.py':board.sha(checker)}}))
    raw=session/'serial-motion.json'
    raw.write_text(json.dumps(dict(session='s',game_run='g',backend_closed=True,release_confirmed=False)))
    report=dict(schema='pynq-usb-hand-readonly-v1',result='READ_ONLY_COMPLETE',
        port='/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00',motion_authorized=False,
        release_ready=False,port_closed=True,read_requests=85,motors=[])
    for i in range(1,18):
        report['motors'].append(dict(id=i,reads={k:dict(value=v,result=0,device_error=0) for k,v in
            dict(torque=0,position_raw=100,voltage_raw=50,temperature_c=20,native_limit=1000).items()}))
    if tamper=='torque':report['motors'][0]['reads']['torque']['value']=1
    if tamper=='missing':report['motors'].pop()
    if tamper=='open':report['port_closed']=False
    probe=session/'probe.json' if tamper!='outside' else tmp_path/'foreign.json'
    probe.write_text(json.dumps(report))
    proof=dict(schema='hand-off-recheck-v1',session='s',game_run='g',child_exit=1,
               original_sha256=board.sha(raw),probe_path=str(probe),probe_sha256=board.sha(probe))
    if tamper=='identity':proof['session']='foreign'
    if tamper=='hash':proof['original_sha256']='wrong'
    (session/'cleanup-off-recheck.json').write_text(json.dumps(proof))
    assert board.hand_shutdown_off(raw,dict(root=str(root),started=0)) is (tamper is None)


@pytest.fixture
def candidate(tmp_path):
    root=tmp_path/'candidate';(root/'overlay').mkdir(parents=True)
    (root/'overlay/c6v_candidate.bit').write_bytes(b'frozen bit')
    (root/'candidate_stage.json').write_text(json.dumps(dict(stage='PAIRED_PREFLIGHT_READY',
        profile='C6I_VISION_BUTTON_V1',bit_sha256=board.sha(root/'overlay/c6v_candidate.bit'))))
    (root/'start_board_test.py').write_text('print("fixture")')
    manifest=dict(backend='c6i-vision-button',build_id='0xC0061000',sha256={
        p.relative_to(root).as_posix():board.sha(p) for p in root.rglob('*') if p.is_file()})
    (root/'deployment_manifest.json').write_text(json.dumps(manifest))
    return root


class Device:
    expected_build_id=0xC0061000
    connection_settings=('192.168.2.99',8765,'192.168.2.1',0xC0061000)
    def disconnect(self):pass
    def connect(self):return SimpleNamespace(state=DeviceState.READY,build_id=self.expected_build_id)
    def video_status(self):return dict(snapshot=dict(vision=dict(hand_session=dict(
        phase='ACTIVE',mode='serial-fixed-playback',preview_interlock=True,preview_allowed=False))))


def test_field_pairing_import_runs_after_normal_release_and_never_on_failed_release(monkeypatch):
    events=[]
    active=dict(pid=123)
    monkeypatch.setattr(board,'stop_owned',lambda a,b:events.append(('released',a,b)))
    monkeypatch.setattr(board.subprocess,'run',lambda command,**kw:events.append(('check',command,kw)))
    board.field_pairing_check(active,'boot',['python','start.py'],Path('/checked'))
    assert [e[0] for e in events]==['released','check']
    assert events[1][1]==['python','start.py','--check-only']
    assert events[1][2]['timeout']==90
    def failed(*_):raise RuntimeError('release unknown')
    monkeypatch.setattr(board,'stop_owned',failed)
    events.clear()
    with pytest.raises(RuntimeError,match='release unknown'):
        board.field_pairing_check(active,'boot',['python','start.py'],Path('/checked'))
    assert events==[]


def test_field_command_uses_bundled_hand_and_preserves_legacy_fallback(candidate,monkeypatch):
    exists=Path.exists
    monkeypatch.setattr(Path,'exists',lambda p:True if p.name=='usb-1a86_USB_Single_Serial_5B79030971-if00' else exists(p))
    legacy=board.field_command(candidate,lifetime_seconds=None)
    assert legacy[legacy.index('--hand-readonly-root')+1]==str(board.BASE/'hand-r43-creative-r06')
    (candidate/'hand-runtime').mkdir()
    bundled=board.field_command(candidate,lifetime_seconds=None)
    assert bundled[bundled.index('--hand-readonly-root')+1]==str(candidate/'hand-runtime')
    assert '--hand-serial-seconds' not in bundled


def test_complete_transaction_and_preserved_receipt(candidate,tmp_path):
    calls=[]
    def run(argv,**kwargs):
        calls.append(argv)
        if argv[0]=='scp':return b''
        action=shlex.split(argv[-1])[-3]
        results={'prepare':dict(addresses=['192.168.2.99'],archive='/safe/package.tar.gz'),
                 'quiesce':dict(stopped=True,owners=[]),
                 'install':dict(boot_id='boot',library_sha256={'game/manifest.json':'sha'}),
                 'status':dict(running=True,boot_id='boot')}
        return json.dumps(results[action]).encode()
    result=SystemLoader(Device(),runner=run).load(candidate,tmp_path/'out')
    assert result['result']=='PASS' and not result['hand_enabled']
    assert [x['name'] for x in result['steps']]==['verified','preflight','quiesced','uploaded','installed','running']
    assert len(calls)==5
    assert shlex.split(calls[1][-1])[-3]=='quiesce' and calls[2][0]=='scp'
    assert json.loads((tmp_path/'out/receipt.json').read_text(encoding='utf-8'))['result']=='PASS'
    unpacked=tmp_path/'unpacked'
    board.unpack(tmp_path/'out/package.tar.gz',unpacked,board.sha(candidate/'deployment_manifest.json'))
    assert board.verify(unpacked,exact=True)==board.verify(candidate,exact=True)


@pytest.mark.parametrize('failure',['tamper','unlisted','unpaired','platform'])
def test_local_failure_never_contacts_board(candidate,tmp_path,failure):
    device=Device()
    if failure=='tamper':(candidate/'start_board_test.py').write_text('tampered')
    elif failure=='unlisted':(candidate/'extra.py').write_text('extra')
    elif failure=='unpaired':(candidate/'candidate_stage.json').write_text('{}')
    else:device.expected_build_id=0xC0060700
    def run(*args,**kwargs):raise AssertionError('Must not contact board')
    with pytest.raises(ValueError):SystemLoader(device,runner=run).load(candidate,tmp_path/'out')
    assert json.loads((tmp_path/'out/receipt.json').read_text(encoding='utf-8'))['result']=='FAIL'


def test_wrong_host_blocks_upload(candidate,tmp_path):
    calls=[]
    def run(argv,**kwargs):
        calls.append(argv)
        return json.dumps(dict(addresses=['192.168.2.98'],archive='/safe/package.tar.gz')).encode()
    with pytest.raises(ValueError,match='同一台'):
        SystemLoader(Device(),runner=run).load(candidate,tmp_path/'out')
    assert len(calls)==1


def test_cancel_after_upload_keeps_normal_stop_receipt_and_never_installs(candidate,tmp_path):
    stop=threading.Event();calls=[]
    def run(argv,**kwargs):
        calls.append(argv)
        if argv[0]=='scp':stop.set();return b''
        if shlex.split(argv[-1])[-3]=='quiesce':return json.dumps(dict(stopped=True,owners=[])).encode()
        return json.dumps(dict(addresses=['192.168.2.99'],archive='/safe/package.tar.gz')).encode()
    with pytest.raises(InterruptedError):
        SystemLoader(Device(),runner=run).load(candidate,tmp_path/'out',stop_event=stop)
    assert len(calls)==3
    receipt=json.loads((tmp_path/'out/receipt.json').read_text(encoding='utf-8'))
    assert any(s['name']=='quiesced' for s in receipt['steps'])


def test_failed_old_shutdown_blocks_upload(candidate,tmp_path):
    calls=[]
    def run(argv,**kwargs):
        calls.append(argv)
        if argv[0]=='scp':raise AssertionError('Upload must wait for normal shutdown')
        if shlex.split(argv[-1])[-3]=='quiesce':raise RuntimeError('owner retained')
        return json.dumps(dict(addresses=['192.168.2.99'],archive='/safe/package.tar.gz')).encode()
    with pytest.raises(RuntimeError,match='owner retained'):
        SystemLoader(Device(),runner=run).load(candidate,tmp_path/'out')
    assert len(calls)==2


def test_quiesce_checks_identity_before_stopping_and_verifies_empty_owner(monkeypatch):
    active=dict(pid=17);events=[]
    prepared=dict(boot_id='boot',manifest_sha256='sha',previous_owner=active)
    monkeypatch.setattr(board,'stop_owned',lambda *a:events.append(('stop',a)))
    monkeypatch.setattr(board,'gate',lambda *a:events.append(('gate',a)))
    with pytest.raises(RuntimeError,match='changed'):
        board.quiesce_prepared(dict(pid=18),prepared,'sha','boot')
    assert events==[]
    assert board.quiesce_prepared(active,prepared,'sha','boot')['stopped']
    assert events==[('stop',(active,'boot')),('gate',(None,'boot'))]


@pytest.mark.parametrize('name',['../escape','/absolute','C:/bad','a\\b','a/../b','a//b'])
def test_archive_and_manifest_paths_reject_escape(name):
    with pytest.raises(ValueError):board.safe_name(name)


def test_archive_link_rejected_before_extract(tmp_path):
    archive=tmp_path/'bad.tar.gz'
    with tarfile.open(archive,'w:gz') as tar:
        item=tarfile.TarInfo('link');item.type=tarfile.SYMTYPE;item.linkname='/etc/passwd';tar.addfile(item)
    with pytest.raises(ValueError,match='regular'):board.unpack(archive,tmp_path/'dest','0'*64)
    assert not (tmp_path/'dest').exists()


@pytest.mark.parametrize('tamper',[False,True])
def test_large_archive_is_streamed_and_last_chunk_corruption_is_rejected(candidate,tmp_path,monkeypatch,tamper):
    large=candidate/'large-video.s2v'
    data=bytes(range(256))*(12288)+b'last-partial-chunk'
    large.write_bytes(data)
    manifest_path=candidate/'deployment_manifest.json'
    manifest=json.loads(manifest_path.read_text())
    manifest['sha256'][large.name]=hashlib.sha256(data).hexdigest()
    manifest_path.write_text(json.dumps(manifest))
    identity=board.sha(manifest_path)
    if tamper:large.write_bytes(data[:-1]+b'!')
    archive=tmp_path/'large.tar.gz'
    with tarfile.open(archive,'w:gz') as tar:
        for path in sorted(candidate.rglob('*')):
            if path.is_file():tar.add(path,arcname=path.relative_to(candidate).as_posix())
    original=tarfile.ExFileObject.read;reads=[]
    def bounded_read(stream,size=-1):
        if stream.raw.size==len(data):
            assert 0<size<=1024*1024
            reads.append(size)
        return original(stream,size)
    monkeypatch.setattr(tarfile.ExFileObject,'read',bounded_read)
    # The verification pass must also stream files rather than materializing
    # a complete video after the extraction's bounded-memory pass.
    original_bytes=Path.read_bytes
    def no_large_read(path):
        assert path.name!=large.name
        return original_bytes(path)
    monkeypatch.setattr(Path,'read_bytes',no_large_read)
    destination=tmp_path/'unpacked'
    if tamper:
        with pytest.raises(ValueError,match='Archive file mismatch: large-video'):
            board.unpack(archive,destination,identity)
    else:
        board.unpack(archive,destination,identity)
        assert board.sha(destination/large.name)==hashlib.sha256(data).hexdigest()
    assert len(reads)>=4


def test_foreign_owner_is_never_stopped(monkeypatch):
    monkeypatch.setattr(board,'processes',lambda:{123:dict(owner=True,state='S',ppid=1,
        ticks='1',argv=[b'copilot-test.py'],command='copilot-test.py',devices=['/dev/mem'])})
    monkeypatch.setattr(board.os,'kill',lambda *_:pytest.fail('Foreign owner must not be signalled'))
    with pytest.raises(RuntimeError,match='another owner'):board.stop_owned(None,'boot')


def test_upload_permission_is_given_only_to_reserved_file(tmp_path,monkeypatch):
    calls=[]
    monkeypatch.setenv('SUDO_UID','1000');monkeypatch.setenv('SUDO_GID','1000')
    monkeypatch.setattr(board.os,'getuid',lambda:0,raising=False)
    monkeypatch.setattr(board.os,'getgid',lambda:0,raising=False)
    monkeypatch.setattr(board.os,'chown',lambda *args:calls.append(args),raising=False)
    target=tmp_path/'package.tar.gz'
    board.reserve_upload(target)
    assert target.is_file() and calls==[(target,1000,1000)]
    with pytest.raises(FileExistsError):board.reserve_upload(target)


def test_field_requires_observer_before_board_access(candidate,tmp_path):
    def run(*args,**kwargs):pytest.fail('No board access without observer')
    with pytest.raises(ValueError,match='现场观察'):
        SystemLoader(Device(),runner=run).start_field(candidate,tmp_path/'out')
    assert not (tmp_path/'out').exists()


@pytest.mark.parametrize('scenario',['success','wrong_host','hand_fault'])
def test_field_handoff_and_cleanup(candidate,tmp_path,scenario):
    calls=[];device=Device()
    if scenario=='hand_fault':
        device.video_status=lambda:dict(snapshot=dict(vision=dict(hand_session=dict(error='motor unavailable'))))
    def run(argv,**kwargs):
        assert argv[0]=='ssh'  # Reuses the verified system; no SCP/install.
        action=shlex.split(argv[-1])[-3];calls.append(action)
        return json.dumps({'field-check':dict(addresses=['192.168.2.98' if scenario=='wrong_host' else '192.168.2.99']),
            'field-start':dict(pid=42,boot_id='boot'),'stop':dict(running=False)}[action]).encode()
    loader=SystemLoader(device,runner=run)
    if scenario=='success':
        result=loader.start_field(candidate,tmp_path/'out',observer_confirmed=True)
        assert result['result']=='PASS' and result['hand_enabled']
        assert calls==['field-check','field-start']
    else:
        with pytest.raises((ValueError,RuntimeError)):
            loader.start_field(candidate,tmp_path/'out',observer_confirmed=True)
        assert calls==(['field-check'] if scenario=='wrong_host' else ['field-check','field-start','stop'])
        saved=json.loads((tmp_path/'out/receipt.json').read_text(encoding='utf-8'))
        assert saved['result']=='FAIL'
        if scenario=='hand_fault':assert saved['failure_stop']['running'] is False


@pytest.mark.parametrize('motor_ids',[None,list(range(1,17)),list(range(1,18))])
def test_field_shutdown_requires_every_motor_off(tmp_path,monkeypatch,motor_ids):
    reports=tmp_path/'var/vision/session';reports.mkdir(parents=True)
    (reports/'stop_receipt.json').write_text(json.dumps(dict(cleanup_confirmed=True,error=None)))
    if motor_ids is not None:
        (reports/'serial-motion.json').write_text(json.dumps(dict(
            backend_closed=True,release_confirmed=True,release_confirmed_ids=motor_ids)))
    monkeypatch.setattr(board,'gate',lambda *_:set())
    record=dict(root=str(tmp_path),boot_id='boot',started=0,hand_enabled=True)
    if motor_ids==list(range(1,18)):board.stop_owned(record,'boot')
    else:
        with pytest.raises(RuntimeError,match='17 motors OFF'):board.stop_owned(record,'boot')


def test_insufficient_storage_does_not_stop_old_task(candidate,tmp_path):
    calls=[]
    def run(argv,**kwargs):
        calls.append(argv)
        assert argv[0]=='ssh' and shlex.split(argv[-1])[-3]=='prepare'
        return json.dumps(dict(addresses=['192.168.2.99'],archive='/safe/package.tar.gz',
            storage=dict(free=3*1024**3,total=32*1024**3,library_bytes=100))).encode()
    with pytest.raises(OSError,match='旧任务未停止'):
        SystemLoader(Device(),runner=run).load(candidate,tmp_path/'out')
    assert len(calls)==1


def test_failed_start_surfaces_console_instead_of_waiting(candidate,tmp_path):
    device=Device();device.connect=lambda: (_ for _ in ()).throw(TimeoutError('timed out'))
    def run(argv,**kwargs):
        if argv[0]=='scp':return b''
        action=shlex.split(argv[-1])[-3]
        return json.dumps(dict(prepare=dict(addresses=['192.168.2.99'],archive='/safe/package.tar.gz'),
            quiesce=dict(stopped=True,owners=[]),install=dict(boot_id='boot'),
            status=dict(running=False,console=['OSError: free space reserve']))[action]).encode()
    with pytest.raises(RuntimeError,match='free space reserve'):
        SystemLoader(device,runner=run).load(candidate,tmp_path/'out')


def test_resume_uses_existing_install_and_keeps_original_failure(candidate,tmp_path):
    original=tmp_path/'failed.json'
    identity=board.sha(candidate/'deployment_manifest.json')
    value=dict(result='FAIL',hand_enabled=False,candidate=str(candidate),manifest_sha256=identity,
        transaction='a'*32,steps=[dict(name='installed',result=dict(pid=1))],error='old failure')
    original.write_text(json.dumps(value));raw=original.read_bytes();calls=[]
    def run(argv,**kwargs):
        assert argv[0]=='ssh'
        action=shlex.split(argv[-1])[-3];calls.append(action)
        return json.dumps(dict(resume=dict(pid=2,boot_id='boot'),status=dict(running=True,boot_id='boot'))[action]).encode()
    receipt=SystemLoader(Device(),runner=run).resume_installed(original,tmp_path/'recovered')
    assert calls==['resume','status'] and receipt['result']=='PASS'
    assert original.read_bytes()==raw and receipt['recovery_of']==str(original.resolve())
    assert next(s['result']['pid'] for s in receipt['steps'] if s['name']=='installed')==2


def test_confirmation_never_restarts_or_uploads(candidate,tmp_path):
    identity=board.sha(candidate/'deployment_manifest.json');source=tmp_path/'failed.json'
    source.write_text(json.dumps(dict(result='FAIL',candidate=str(candidate),manifest_sha256=identity,
        transaction='a'*32,steps=[dict(name='installed',result=dict(boot_id='boot'))])))
    calls=[]
    def run(argv,**kwargs):
        assert argv[0]=='ssh';calls.append(shlex.split(argv[-1])[-3])
        return json.dumps(dict(running=True,boot_id='boot')).encode()
    raw=source.read_bytes()
    r=SystemLoader(Device(),runner=run).confirm_installed(source,tmp_path/'confirmation')
    assert calls==['status'] and r['result']=='PASS' and source.read_bytes()==raw


@pytest.mark.parametrize('receipt', ['clean','absent','unclean','error','foreign','hand'])
def test_resume_requires_proven_owner_release(tmp_path,monkeypatch,receipt):
    root=tmp_path/'system';session=root/'var/vision/session';session.mkdir(parents=True)
    record=dict(root=str(root),boot_id='boot',pid=123,start_ticks=456,started=0,hand_enabled=receipt=='hand')
    rows={45:dict(owner=True,state='S',command='foreign',devices=['dma'],ppid=1)} if receipt=='foreign' else {}
    monkeypatch.setattr(board,'processes',lambda:rows)
    if receipt!='absent':
        (session/'stop_receipt.json').write_text(json.dumps(dict(
            cleanup_confirmed=receipt!='unclean',error='failure' if receipt=='error' else None)))
    if receipt=='clean':board.resume_release_gate(record,'boot')
    else:
        with pytest.raises(RuntimeError):board.resume_release_gate(record,'boot')


def test_cancelled_retry_keeps_original_and_never_starts(candidate,tmp_path):
    source=tmp_path/'failed.json';identity=board.sha(candidate/'deployment_manifest.json')
    source.write_text(json.dumps(dict(result='FAIL',candidate=str(candidate),manifest_sha256=identity,
        transaction='a'*32,hand_enabled=False,steps=[dict(name='installed',result=dict(boot_id='boot'))])))
    raw=source.read_bytes();stop=threading.Event();stop.set()
    def unexpected(*args,**kwargs):raise AssertionError('No SSH operation allowed after cancellation')
    with pytest.raises(InterruptedError):
        SystemLoader(Device(),runner=unexpected).resume_installed(source,tmp_path/'cancel',stop_event=stop)
    assert source.read_bytes()==raw
    assert json.loads((tmp_path/'cancel/receipt.json').read_text(encoding='utf-8'))['result']=='FAIL'
