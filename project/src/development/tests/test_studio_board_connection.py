import json
import threading
import builtins
import os
from pathlib import Path
from types import SimpleNamespace

import pytest

from pynq_multimodal_game.studio import board_connection as connection
from pynq_multimodal_game.studio.device import DeviceState
from pynq_multimodal_game.studio.remote_io import AgentIoWorker


def test_readonly_probe_recognizes_autostart_lock_before_active_record_changes(tmp_path,capsys):
    """Execute the actual SSH payload against a redirected /proc and disk."""
    base=tmp_path/'home/xilinx/voice-view-game/.studio-system'
    base.mkdir(parents=True);(base/'loader.lock').touch()
    (base/'active.json').write_text(json.dumps(dict(boot_id='old',pid=99,root='/old',start_ticks='1')))
    (base/'boot').mkdir();(base/'boot/config.json').write_text('{"hand_enabled":true}')
    proc=tmp_path/'proc';(proc/'sys/kernel/random').mkdir(parents=True)
    (proc/'sys/kernel/random/boot_id').write_text('new')
    stat=(base/'loader.lock').stat()
    (proc/'locks').write_text('1: FLOCK ADVISORY WRITE 732 %x:%x:%d 0 EOF\n' %
        (8,1,stat.st_ino))
    def imported(name,*args,**kwargs):
        if name=='os':return SimpleNamespace(major=lambda _:8,minor=lambda _:1)
        if name=='pathlib':return SimpleNamespace(Path=lambda path:tmp_path/str(path).lstrip('/'))
        if name=='subprocess':return SimpleNamespace(PIPE=-1,DEVNULL=-3,TimeoutExpired=TimeoutError,
            run=lambda *a,**kw:SimpleNamespace(stdout='ActiveState=active\nMainPID=732\nResult=success\n'),
            check_output=lambda *a,**kw:b'192.0.2.1')
        return builtins.__import__(name,*args,**kwargs)
    environment={'__builtins__':dict(vars(builtins),__import__=imported)}
    exec(compile(connection.PROBE,'readonly-probe','exec'),environment)
    value=json.loads(capsys.readouterr().out)
    assert value['loader_busy'] and value['loader_pid']==732 and not value['running']
    assert value['hand_default'] and not value['hand_available']
    assert '自动等待' in connection.board_startup_message(value)


@pytest.mark.parametrize('address,allowed',[('192.0.2.1',True),('192.0.2.2',False)])
def test_probe_requires_authenticated_matching_board(monkeypatch,address,allowed):
    commands=[]
    class Child:
        returncode=0
        def __init__(self,argv,**kwargs):commands.append(argv)
        def __enter__(self):return self
        def __exit__(self,*a):pass
        def communicate(self,data=None,timeout=None):
            return json.dumps(dict(ssh_ready=True,addresses=[address],installed=None,running=False)).encode(),b''
    monkeypatch.setattr(connection.subprocess,'Popen',Child)
    device=SimpleNamespace(connection_settings=('192.0.2.1',8765,'192.0.2.10',0xC0061000))
    if allowed:
        assert connection.probe_board(device)['installed'] is None
    else:
        with pytest.raises(ValueError,match='同一块'):connection.probe_board(device)
    assert 'BatchMode=yes' in commands[0] and commands[0][-1]=='sudo -n python3 -B -'


def test_probe_cancellation_reaps_local_ssh_child(monkeypatch):
    events=[]
    class Child:
        def __init__(self,*a,**kw):pass
        def __enter__(self):return self
        def __exit__(self,*a):pass
        def kill(self):events.append('kill')
        def communicate(self):events.append('reap')
    monkeypatch.setattr(connection.subprocess,'Popen',Child)
    stop=threading.Event();stop.set()
    device=SimpleNamespace(connection_settings=('192.0.2.1',8765,None,0xC0061000))
    with pytest.raises(TimeoutError):connection.probe_board(device,stop_event=stop)
    assert events==['kill','reap']


def test_offline_agent_emits_independent_board_state_and_stops_without_polling():
    snapshots=[];boards=[];calls=[]
    failed=SimpleNamespace(state=DeviceState.ERROR,message='connection refused')
    class Session:
        def connect(self):return failed
        def disconnect(self):return SimpleNamespace(state=DeviceState.DISCONNECTED)
    def probe(**kwargs):
        calls.append('ssh')
        return dict(ssh_ready=True,installed=None,running=False)
    worker=AgentIoWorker(Session(),board_probe=probe)
    worker.snapshot_changed.connect(snapshots.append)
    worker.board_changed.connect(lambda info:(boards.append(info),worker.stop()))
    worker.run()
    assert calls==['ssh'] and boards[0]['ssh_ready']
    assert snapshots[0].state is DeviceState.ERROR


def test_ready_agent_does_not_add_ssh_or_hardware_polling():
    class Session:
        def connect(self):return SimpleNamespace(state=DeviceState.READY)
        def disconnect(self):return SimpleNamespace(state=DeviceState.DISCONNECTED)
    worker=AgentIoWorker(Session(),board_probe=lambda **kw:pytest.fail('no probe when ready'))
    worker.snapshot_changed.connect(lambda snap:worker.stop() if snap.state is DeviceState.READY else None)
    worker.run()
