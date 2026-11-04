"""Real backend ordering: retain the loading scene until all owners are ready."""
from types import SimpleNamespace
import pytest
from pynq_multimodal_game.agent import button_osd_backend as module
from pynq_multimodal_game.startup_ui import CheckState,StartupRenderer,StartupSnapshot
from pynq_multimodal_game.scene_compiler import CommandRenderer
from subprojects.ps_ui_r23b2.test_pause_closure import Sink

@pytest.mark.parametrize('failed',[False,True])
def test_menu_cannot_render_during_osd_or_hand_initialization(monkeypatch,failed):
    from pynq_multimodal_game import button_input
    events=[];sink=Sink();holder={}
    class Session:
        build_id=0xC0061000
        def open(self):events.append('gpu')
        def mmio(self,_):return object()
    class Supervisor:
        input_provider=object()
        def __init__(self):self.frame=0
        def start(self):return self.status()
        def status(self):
            self.frame+=1
            return dict(state='RUNNING',frame_id=self.frame,owner_held=True,last_error=None,
                input_capabilities=dict(schema='local-game-vision-v1',mode='games',games=['game1','game2','game3']))
        def stop(self):events.append('vision-close');return {'cleanup_confirmed':True}
    class Hand:
        checks=0
        def start(self):events.append('hand-start')
        def status(self):
            value=holder['backend'];assert not value._menu_active
            assert value.startup_snapshot.states[3] is CheckState.CHECK
            assert value._menu_frame_id==0
            self.checks+=1
            if self.checks<3:return {'phase':'STARTING','error':None}
            if failed:return {'phase':'FAULT','error':'injected source fault'}
            return {'phase':'ACTIVE','error':None}
        def close(self):events.append('hand-close')
    def osd_open():
        assert not holder['backend']._menu_active
        assert holder['backend']._menu_frame_id==0
        events.append('osd')
    monkeypatch.setattr(module,'HandOsdService',lambda *_:SimpleNamespace(open=osd_open,close=lambda:None))
    monkeypatch.setattr(button_input,'ButtonSampler',lambda *_args,**_kwargs:SimpleNamespace(start=lambda:None,close=lambda:None))
    monkeypatch.setattr(button_input,'ButtonGameInputProvider',lambda *_:object())
    # Only the mock wait is accelerated; real readiness transitions and GPU
    # packets run through the production backend and startup renderer.
    monkeypatch.setattr(module.time,'sleep',lambda _:None)
    backend=module.C6IButtonOsdRuntimeBackend(Session(),Supervisor(),osd_hub=object(),
        startup_hand=lambda:True,hand_session_factory=lambda _:Hand(),menu_fps=0,
        sink_factory=lambda *_:sink)
    holder['backend']=backend
    # Sink's test API has no hardware close; add it without changing submission.
    sink.close=lambda:events.append('sink-close')
    if failed:
        with pytest.raises(RuntimeError,match='injected source fault'):backend.open()
        assert not backend._menu_active and backend._menu_frame_id==0
        assert backend.startup_snapshot.states[3] is CheckState.FAIL
        assert 'injected source fault' in backend.startup_snapshot.error
        assert 'hand-close' in events and 'vision-close' in events
    else:
        backend.open()
        assert backend._menu_active and backend._menu_frame_id==1
        assert backend.startup_snapshot.states==(CheckState.OK,)*4
        backend.close()
    assert events.index('osd')<events.index('hand-start')

def test_loading_heading_and_failed_stage_have_distinct_pixels_and_fixed_assets():
    renderer=StartupRenderer();states=(CheckState.OK,CheckState.OK,CheckState.OK,CheckState.CHECK)
    loading=renderer.compile(StartupSnapshot(states),frame_id=0,generation=1)
    failure=renderer.compile(StartupSnapshot((*states[:3],CheckState.FAIL),'fault'),frame_id=1,generation=1)
    assert loading.assets==failure.assets
    a,b=(CommandRenderer().render(frame) for frame in (loading,failure))
    assert a[320*50*3:320*85*3]!=b[320*50*3:320*85*3]
    assert a!=b


@pytest.mark.parametrize('failed',[False,True])
def test_cosmetic_loading_animates_while_check_blocks_and_stops_before_menu(failed):
    import time
    from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
    sink=Sink();holder={}
    def slow_check():
        backend=holder['backend'];before=backend._startup_frame_id
        time.sleep(.45)
        assert backend._startup_frame_id>before
        assert not backend._menu_active and backend._menu_frame_id==0
        if failed:raise RuntimeError('injected initialization failure')
        return True
    session=SimpleNamespace(build_id=0xC0061000,open=lambda:None)
    backend=C6IShellRuntimeBackend(session,startup_vision=slow_check,
        startup_hand=lambda:True,menu_fps=0,sink_factory=lambda *_:sink)
    holder['backend']=backend
    try:
        if failed:
            with pytest.raises(RuntimeError,match='injected initialization failure'):backend.open()
            assert not backend._menu_active
        else:
            backend.open();assert backend._menu_active
        assert backend._startup_animation_thread is None
        count=backend._startup_frame_id;time.sleep(.25)
        assert backend._startup_frame_id==count
    finally:backend.close()


@pytest.mark.parametrize('failed', [False, True])
def test_content_validation_runs_under_animated_loading_before_vision_and_hand(failed):
    from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
    import time
    events=[];sink=Sink();holder={}
    def library_check():
        value=holder['backend']
        assert value.startup_snapshot.states[1] is CheckState.CHECK
        before=value._startup_frame_id
        time.sleep(.45)
        assert value._startup_frame_id>before and not value._menu_active
        events.append('library')
        if failed:raise RuntimeError('invalid content')
    backend=C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000,open=lambda:None),
        startup_library=library_check,startup_vision=lambda:events.append('vision') or True,
        startup_hand=lambda:events.append('hand') or True,menu_fps=0,sink_factory=lambda *_:sink)
    holder['backend']=backend
    try:
        if failed:
            with pytest.raises(RuntimeError,match='invalid content'):backend.open()
            assert events==['library'] and not backend._menu_active
            assert backend.startup_snapshot.states[1] is CheckState.FAIL
        else:
            backend.open()
            assert events==['library','vision','hand'] and backend._menu_active
        assert backend._startup_animation_thread is None
    finally:backend.close()
