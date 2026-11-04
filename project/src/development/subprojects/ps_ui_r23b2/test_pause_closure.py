"""Production game/scene paths with deterministic UI observations; no hardware."""
from dataclasses import replace
from types import SimpleNamespace
import time

import pytest

from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend, ShellMode
from pynq_multimodal_game.button_input import ButtonGameInputProvider
from pynq_multimodal_game.controls import ControlState, ControlSource, Direction, StaleFlag
from pynq_multimodal_game.game_seeds import ensure_seed_games
from pynq_multimodal_game.library import AssetLibrary
from pynq_multimodal_game.menu import MenuPage
from pynq_multimodal_game.pause_menu import PauseInput, PauseRenderer
from pynq_multimodal_game.vision_input import GameVisionInputProvider
from subprojects.ps_ui_r23b2.test_seed_helpers import build_bundled_games


def packet(frame, x, y, *, valid=True):
    return dict(run_id='camera', frame=frame, server_age_ms=10,
        stable='5' if valid else 'PENDING', rps='PAPER' if valid else 'UNKNOWN',
        ui_pointer=dict(schema='menu-pointer-v1',u=x*2/319-1,v=y*2/179-1),
        control=dict(schema='gesture-control-v1',frame_id=frame,action_event_seq=0,
            direction='IDLE',valid=valid,reason='OK' if valid else 'FRAME_EDGE',
            u=x*2/319-1,v=y*2/179-1,action_event=False))


def control(x,y,seconds,valid=True):
    return ControlState(tick_id=0,timestamp_ns=int(seconds*1e9),
        gesture_source=ControlSource.REAL,gesture_seq=0,hand_valid=valid,
        hand_x=x*2/319-1,hand_y=y*2/179-1,direction=Direction.IDLE,
        fist_score=0,fist_event=False,voice_source=ControlSource.REAL,
        voice_seq=0,audio_valid=False,low_voice_active=False,high_voice_event=False,
        low_confidence=0,high_confidence=0)


def test_pause_dwell_requires_exit_entry_fresh_hand_and_stable_target():
    ui=PauseInput()
    assert ui.update(control(12,12,0)) is None
    assert ui.update(control(12,12,5)) is None
    assert ui.update(control(64,94,6)) is None
    assert ui.update(control(64,94,7.99)) is None
    assert ui.update(control(64,94,8.01))=='resume'
    assert ui.update(control(64,94,12)) is None
    assert ui.update(control(160,94,13)) is None
    assert ui.update(control(256,94,14)) is None
    assert ui.update(control(256,94,15,False)) is None
    assert ui.update(control(256,94,16)) is None
    assert ui.update(control(256,94,18.01))=='main-menu'
    ui=PauseInput()
    assert ui.update(control(160,94,20)) is None
    assert ui.update(replace(control(160,94,22.1),stale_flags=StaleFlag.GESTURE)) is None


def test_frame_edge_ui_can_return_and_move_without_gesture_or_refreshing_old_frame():
    clock=[100.]
    source=GameVisionInputProvider(clock=lambda:clock[0])
    p=packet(1,12,12,valid=False)
    source.publish(p)
    assert source.peek_menu_control().hand_valid
    game,_=source.sample_for_game('game1',tick_id=0)
    assert game.hand_valid and game.hand_gesture is None and not game.fist_event
    assert not source.peek_menu_control().fist_event
    clock[0]=100.8
    source.publish(p)  # replay cannot extend the coordinate lease
    clock[0]=101.3
    assert not source.peek_menu_control().hand_valid
    p=packet(2,12,12,valid=False)
    source.publish(p)
    assert source.peek_menu_control().hand_valid
    source.suspend()
    assert not source.peek_menu_control().hand_valid


@pytest.fixture(scope='module')
def game_root(tmp_path_factory):
    root=tmp_path_factory.mktemp('pause-games')
    build_bundled_games(root)
    return root


class Sink:
    def __init__(self):self.events=[]
    def upload_asset(self,packet):self.events.append(('asset',packet))
    def upload_palette(self,packet):self.events.append(('palette',packet))
    def upload_tilemap(self,packet):self.events.append(('tilemap',packet))
    def submit_scene(self,packet):self.events.append(('scene',packet))
    def close(self):pass


@pytest.mark.parametrize('game_id',('game1','game2','game3'))
def test_actual_game_pause_continue_restart_and_home_close_loop(game_root,tmp_path,game_id):
    library=AssetLibrary(tmp_path/'library',minimum_free_bytes=0,minimum_free_fraction=0)
    ensure_seed_games(game_root,library,install=True)
    clock=[100.]
    visual=GameVisionInputProvider(clock=lambda:clock[0])
    sampler=SimpleNamespace(clear=lambda:None,consume=lambda:None)
    source=ButtonGameInputProvider(visual,sampler)
    class Session:
        build_id=0xC0061000
        def open(self):return self
    sink=Sink()
    shell=C6IShellRuntimeBackend(Session(),library=library,menu_fps=0,
        live_input=source,sink_factory=lambda *_:sink)
    frame=[0]
    def point(x,y,seconds):
        clock[0]=seconds;frame[0]+=1
        visual.publish(packet(frame[0],x,y,valid=False),config_epoch='same-camera')
        return source.peek_menu_control()
    def enter(start):
        point(12,12,start)
        assert shell._poll_return_control() is None
        point(12,12,start+1.99)
        assert shell._poll_return_control() is None
        point(12,12,start+2.01)
        assert shell._poll_return_control()=='pause-menu'
        assert shell.game_menu_active and shell._game.paused
    try:
        shell.open()
        shell._return_monitor_stop.set()
        shell._return_monitor_thread.join(2)
        shell.start_game(game_id)
        game=shell._game
        enter(101)
        tick=game.tick_id
        time.sleep(.08)
        assert game.tick_id==tick  # gameplay clock is frozen
        assert source.peek_menu_control().hand_valid
        before_refresh=len(sink.events)
        shell.refresh_catalog()
        assert shell.game_menu_active and shell.mode is ShellMode.GAME
        assert len(sink.events)==before_refresh
        assert shell.handle_control(point(12,12,106)) is None
        expected=dict(game._resource_packets)
        sink.events.clear()
        assert shell.handle_control(point(64,94,107)) is None
        assert shell.handle_control(point(64,94,109.01))=='resume'
        assert shell._game is game and not game.paused and not shell.game_menu_active
        assert [kind for kind,_ in sink.events[:4]]==['asset','palette','tilemap','scene']
        # Loading is presented first; all game resource banks are then restored.
        resources=[event for event in sink.events if event[0] in ('asset','palette','tilemap')]
        assert resources[3:6]==[(k,expected[k]) for k in ('asset','palette','tilemap')]
        assert sink.events[3][0]=='scene'
        assert game.tick_id>=tick
        # A new entry needs a real leave; stale dwell from before resume is gone.
        point(160,90,110);shell._poll_return_control()
        enter(111)
        old_run=game._game_run
        shell.handle_control(point(160,94,114))
        assert shell.handle_control(point(160,94,116.01))=='restart'
        assert shell.mode is ShellMode.GAME and shell._game._game_run!=old_run
        assert not shell.game_menu_active and shell._game.tick_id<5
        assert source.peek_menu_control().hand_valid  # stop/reset did not revoke shared camera
        point(160,90,117);shell._poll_return_control()
        enter(118)
        shell.handle_control(point(256,94,121))
        assert shell.handle_control(point(256,94,123.01))=='main-menu'
        assert shell.mode is ShellMode.MENU and shell.page is MenuPage.HOME and shell._game is None
        assert source.peek_menu_control().hand_valid
        shell.start_game(game_id)
        assert shell.mode is ShellMode.GAME and shell._game.running
        enter(124)  # previous game's Back-release latch must not leak into a new game
    finally:shell.close()


def test_pause_resources_are_bounded_static_and_compile_through_real_packer():
    from pynq_multimodal_game.gpu_abi import pack_asset_bundle_packet,COMMAND_CAPACITY
    from pynq_multimodal_game.scene_compiler import CommandRenderer
    renderer=PauseRenderer()
    frames=[renderer.compile(1,5,item) for item in (None,'resume','restart','main-menu')]
    assert len({pack_asset_bundle_packet(f.assets,generation=5) for f in frames})==1
    assert len(pack_asset_bundle_packet(frames[0].assets,generation=5))<32*1024
    assert all(len(f.commands)<COMMAND_CAPACITY for f in frames)
    assert len({CommandRenderer().render(f) for f in frames})==4


def test_real_return_and_menu_threads_switch_without_consuming_game_action(game_root,tmp_path):
    library=AssetLibrary(tmp_path/'thread-library',minimum_free_bytes=0,minimum_free_fraction=0)
    ensure_seed_games(game_root,library,install=True)
    clock=[100.]
    visual=GameVisionInputProvider(clock=lambda:clock[0])
    source=ButtonGameInputProvider(visual,SimpleNamespace(clear=lambda:None,consume=lambda:None))
    class Session:
        build_id=0xC0061000
        def open(self):return self
    shell=C6IShellRuntimeBackend(Session(),library=library,menu_fps=30,
        live_input=source,sink_factory=lambda *_:Sink())
    frame=[0]
    def point(x,y,seconds):
        frame[0]+=1;clock[0]=seconds
        visual.publish(packet(frame[0],x,y,valid=False),config_epoch='camera-thread')
    def until(predicate):
        deadline=time.monotonic()+2
        while not predicate() and time.monotonic()<deadline:time.sleep(.01)
        assert predicate(), shell.snapshot.last_error
    try:
        shell.open();shell.start_game('game1')
        point(12,12,101)
        until(lambda:shell._return_dwell.entered_ns is not None)
        point(12,12,103.1)
        until(lambda:shell.game_menu_active)
        assert shell.snapshot.state.value=='paused'
        point(64,94,104)
        until(lambda:shell._pause_input.hovered=='resume')
        point(64,94,106.1)
        until(lambda:not shell.game_menu_active)
        assert shell.mode is ShellMode.GAME and not shell._game.paused
        assert shell.snapshot.last_error is None
        point(160,90,107)
        until(lambda:shell._return_armed)
        point(12,12,108)
        until(lambda:shell._return_dwell.entered_ns is not None)
        point(12,12,110.1)
        until(lambda:shell.game_menu_active)
        point(256,94,111)
        until(lambda:shell._pause_input.hovered=='main-menu')
        point(256,94,113.1)
        until(lambda:shell.mode is ShellMode.MENU)
        assert shell.page is MenuPage.HOME and shell.snapshot.last_error is None
    finally:shell.close()
