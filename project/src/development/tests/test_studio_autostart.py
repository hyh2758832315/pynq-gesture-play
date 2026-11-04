"""Boot ordering, immutable package validation and physical-motion authorization."""
import json
from pathlib import Path
from types import SimpleNamespace
import pytest
from pynq_multimodal_game.studio import system_autostart as auto,system_board as board
from pynq_multimodal_game.studio.device import DeviceState
from pynq_multimodal_game.studio.remote_io import AgentIoWorker
from tests.test_studio_system_loader import candidate


@pytest.mark.parametrize('issue',[None,'pending','active','failed','missing'])
def test_boot_ready_requires_completed_services_and_no_pending_jobs(monkeypatch,issue):
    def output(argv,**_):
        if 'list-jobs' in argv:return '123 bootpy.service start waiting' if issue=='pending' else ''
        return ('LoadState='+('not-found' if issue=='missing' else 'loaded')+'\nActiveState='+
                ('activating' if issue=='active' else 'inactive')+'\nMainPID=0\nResult='+
                ('exit-code' if issue=='failed' else 'success'))
    monkeypatch.setattr(auto.subprocess,'check_output',output)
    assert auto.boot_status()['ready']==(issue is None)


@pytest.mark.parametrize('enabled,present',[(False,False),(False,True),(True,False),(True,True)])
def test_boot_uses_installed_package_and_only_explicit_hand_default(candidate,tmp_path,monkeypatch,enabled,present):
    root=candidate.rename(tmp_path/'studio-system-test')
    monkeypatch.setattr(board,'BASE',tmp_path)
    monkeypatch.setattr(board,'gate',lambda *_:set())
    exists=Path.exists
    monkeypatch.setattr(Path,'exists',lambda p:present if p.as_posix().startswith('/dev/serial/') else exists(p))
    active=dict(root=str(root),manifest_sha256=board.sha(root/'deployment_manifest.json'),hand_enabled=True)
    result=auto.launch_plan(active,dict(schema='studio-autostart-v1',hand_enabled=enabled),'boot')
    assert result['hand_enabled']==(enabled and present)
    assert ('--hand-serial-actions' in result['command'])==(enabled and present)
    assert '--hand-serial-seconds' not in result['command']
    assert str(root/'start_board_test.py') in result['command']
    assert bool(result['hand_note'])==(enabled and not present)


@pytest.mark.parametrize('fault',['tamper','owner','config'])
def test_boot_does_not_touch_running_owner_or_accept_unverified_code(candidate,tmp_path,monkeypatch,fault):
    root=candidate.rename(tmp_path/'studio-system-test')
    active=dict(root=str(root),manifest_sha256=board.sha(root/'deployment_manifest.json'))
    monkeypatch.setattr(board,'BASE',tmp_path)
    monkeypatch.setattr(board,'gate',lambda *_:{123} if fault=='owner' else set())
    config=dict(schema='studio-autostart-v1',hand_enabled=False)
    if fault=='config':config['hand_enabled']='yes'
    if fault=='tamper':(root/'start_board_test.py').write_text('wrong file')
    with pytest.raises((ValueError,RuntimeError)):auto.launch_plan(active,config,'boot')


def test_reconnect_backs_off_without_spamming_identical_failure():
    failure=SimpleNamespace(state=DeviceState.ERROR,message='not listening')
    final=SimpleNamespace(state=DeviceState.DISCONNECTED,message='stopped')
    device=SimpleNamespace(connect=lambda:failure,disconnect=lambda:final)
    worker=AgentIoWorker(device);delays=[];observations=[]
    worker.snapshot_changed.connect(observations.append)
    class Stop:
        def is_set(self):return len(delays)>=6
        def wait(self,seconds):delays.append(seconds);return len(delays)>=6
    worker._stopping=Stop();worker.run()
    assert delays==[.25,.5,1,2,4,5]
    assert observations==[failure,final]
