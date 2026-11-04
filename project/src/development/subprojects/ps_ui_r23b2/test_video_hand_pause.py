"""Video may acquire GPU work only after the serial parent's validated OFF."""
from types import SimpleNamespace
from unittest.mock import Mock,PropertyMock,patch
import pytest
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
from pynq_multimodal_game.agent.vision_backend import C6IButtonRuntimeBackend,C6IVisionRuntimeBackend
from pynq_multimodal_game.agent.core import AgentState,RuntimeSnapshot
from pynq_multimodal_game.hand_serial_session import SerialHandActionSession


def test_video_and_preview_pause_reasons_do_not_release_each_other():
    owner=SerialHandActionSession.__new__(SerialHandActionSession)
    preview=[False];owner._preview_requested=lambda:preview[0]
    owner.set_video_paused(True)
    assert owner._requested()
    preview[0]=True;owner.set_video_paused(False)
    assert owner._requested()
    preview[0]=False
    assert not owner._requested()


@pytest.mark.parametrize('phase,allowed,error',[
    ('PAUSED',False,None),('ACTIVE',True,None),('FAULT',True,'failed OFF'),
])
def test_nonconfirmed_hand_cannot_start_video(monkeypatch,phase,allowed,error):
    shell=C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000),menu_fps=0)
    owner=SimpleNamespace(set_video_paused=Mock(),status=lambda:dict(phase=phase,preview_allowed=allowed,error=error))
    shell._hand_session=owner
    ticks=iter((0.,21.))
    monkeypatch.setattr('pynq_multimodal_game.agent.c6i_shell.time.monotonic',lambda:next(ticks))
    with pytest.raises((TimeoutError,RuntimeError)):
        shell._set_video_hand_pause(True)
    owner.set_video_paused.assert_called_once_with(True)


def test_confirmed_off_and_return_reuse_the_existing_parent():
    shell=C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000),menu_fps=0)
    events=[]
    owner=SimpleNamespace(set_video_paused=events.append,status=lambda:dict(phase='PAUSED',preview_allowed=True))
    shell._hand_session=owner
    shell._set_video_hand_pause(True)
    shell._set_video_hand_pause(False)
    assert events==[True,False] and shell._hand_session is owner


def test_runtime_hand_fault_is_isolated_from_healthy_ui_and_vision():
    base=RuntimeSnapshot(state=AgentState.IDLE,build_id=0xC0061000,
        abi_major=1,abi_minor=0,staged_sha256=None,active_sha256=None,
        generation=1,runtime_mode='menu',vision={'state':'RUNNING'})
    backend=C6IButtonRuntimeBackend.__new__(C6IButtonRuntimeBackend)
    backend._hand_session=SimpleNamespace(status=lambda:dict(
        mode='serial-fixed-playback',phase='FAULT',error='serial timeout',
        release_confirmed=True,preview_allowed=True))
    with patch.object(C6IVisionRuntimeBackend,'snapshot',new_callable=PropertyMock,return_value=base):
        snapshot=backend.snapshot
    assert snapshot.state is AgentState.IDLE and snapshot.last_error is None
    assert snapshot.runtime_mode=='menu' and snapshot.vision['state']=='RUNNING'
    assert snapshot.vision['hand_session']['error']=='serial timeout'
