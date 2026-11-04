"""Video pause/seek replies must retain the integrated hand/vision state."""
from dataclasses import replace
from types import SimpleNamespace
import pytest
from pynq_multimodal_game.agent.button_osd_backend import C6IButtonOsdRuntimeBackend
from pynq_multimodal_game.agent.c6i_shell import ShellMode
from pynq_multimodal_game.agent.core import AgentState,RuntimeSnapshot

@pytest.mark.parametrize('method',['pause','seek'])
@pytest.mark.parametrize('hand_error',[None,'injected hand fault'])
def test_video_control_returns_current_integrated_status_once(method,hand_error):
    supervisor=SimpleNamespace(input_provider=object(),status=lambda:dict(state='RUNNING',frame_id=17,last_error=None))
    backend=C6IButtonOsdRuntimeBackend(SimpleNamespace(build_id=0xC0061000),supervisor,osd_hub=object(),menu_fps=0)
    backend._mode=ShellMode.VIDEO
    status=dict(mode='serial-fixed-playback',phase='FAULT' if hand_error else 'ACTIVE',error=hand_error,session='same-hand')
    backend._hand_session=SimpleNamespace(status=lambda:dict(status))
    class Video:
        snapshot=RuntimeSnapshot(state=AgentState.RUNNING,build_id=0xC0061000,abi_major=1,abi_minor=0,
            staged_sha256=None,active_sha256='video-sha',generation=3,frame_index=10)
        calls=[]
        def pause(self):
            self.calls.append(('pause',None));self.snapshot=replace(self.snapshot,state=AgentState.PAUSED);return self.snapshot
        def seek(self,index):
            self.calls.append(('seek',index));self.snapshot=replace(self.snapshot,frame_index=index);return self.snapshot
    video=Video();backend._video=video
    result=backend.pause() if method=='pause' else backend.seek(37)
    assert result.vision['hand_session']==status
    assert result.vision['frame_id']==17 and result.runtime_mode=='video'
    assert result.active_sha256=='video-sha'
    assert result.state is (AgentState.ERROR if hand_error else AgentState.PAUSED if method=='pause' else AgentState.RUNNING)
    assert result.last_error==hand_error
    assert video.calls==[(method,None if method=='pause' else 37)]
    if method=='seek':assert result.frame_index==37
