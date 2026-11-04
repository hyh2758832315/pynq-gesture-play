"""Robust fist confirmation through real provider, menu, library and game entry."""
from dataclasses import replace
from types import SimpleNamespace
import pytest

from pynq_multimodal_game.menu import MenuInputController, MenuPage
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend, ShellMode
from pynq_multimodal_game.vision_input import GameVisionInputProvider
from pynq_multimodal_game.library import AssetLibrary
from pynq_multimodal_game.game_seeds import ensure_seed_games
from subprojects.ps_ui_r23b2.test_pause_closure import control, packet, Sink, game_root


def click(x=86,y=83,t=10,seq=1):
    return replace(control(x,y,t),fist_event=True,gesture_seq=seq)


def test_early_fist_survives_hover_confirmation_but_not_target_change_or_timeout():
    ui=MenuInputController()
    assert ui.update(click()).activated_id is None
    assert ui.update(control(86,83,10.033)).activated_id is None
    assert ui.update(control(86,83,10.066)).activated_id=='games'
    assert ui.update(click(t=10.1)).activated_id is None
    ui.reset()
    assert ui.update(click(t=11,seq=2)).activated_id is None
    for t in (11.033,11.066,11.1):
        assert ui.update(control(234,83,t)).activated_id is None
    ui.reset()
    ui.update(click(t=12,seq=3))
    ui.update(control(86,83,12.1))
    assert ui.update(control(86,83,12.21)).activated_id is None
    # A held confirmation cannot cross a page reset.
    ui.reset(require_release=True)
    for _ in range(4):
        assert ui.update(click(t=13,seq=1)).activated_id is None


def test_confirmed_icon_tolerates_small_boundary_jitter_but_never_stale_input():
    ui=MenuInputController()
    for i in range(3):ui.update(control(86,83,10+i*.033))
    assert ui.update(click(x=150,t=10.1)).activated_id=='games'  # inside the card boundary
    assert ui.update(click(x=161,t=10.2,seq=2)).activated_id is None
    ui.reset();ui.update(click(t=11,seq=3))
    ui.update(control(86,83,11.03,False))
    for t in (11.06,11.09,11.12):
        assert ui.update(control(86,83,t)).activated_id is None


def offer(source,clock,frame,t,gesture,*,run='camera',x=86,y=83,clipped=False):
    clock[0]=t
    p=packet(frame,x,y,valid=gesture is not None and not clipped)
    p['run_id']=run
    p['stable'],p['rps']={'paper':('5','PAPER'),'fist':('0','ROCK'),
                        'scissors':('2','SCISSORS'),None:('PENDING','UNKNOWN')}[gesture]
    source.publish(p,config_epoch='epoch')
    return source.sample_menu_control(tick_id=frame)


def test_detected_frame_edge_hand_can_confirm_menu_and_move_without_game_gesture():
    clock=[100.];source=GameVisionInputProvider(clock=lambda:clock[0])
    offer(source,clock,1,100,'paper',clipped=True)
    assert offer(source,clock,2,100.12,'fist',clipped=True).fist_event
    game,_=source.sample_for_game('game1',tick_id=0)
    assert game.hand_valid and not game.fist_event and game.hand_gesture is None
    assert game.hand_gesture is None


@pytest.mark.parametrize('tamper',['stale','error','no-ui','bad-frame','invalid-ui','no-classification'])
def test_ui_only_confirmation_never_accepts_stale_error_or_unidentified_input(tamper):
    clock=[100.];source=GameVisionInputProvider(clock=lambda:clock[0])
    offer(source,clock,1,100,'paper',clipped=True)
    p=packet(2,86,83,valid=False);p.update(stable='0',rps='ROCK')
    if tamper=='stale':p['server_age_ms']=2000
    if tamper=='error':p['control']['reason']='ERROR'
    if tamper=='no-ui':del p['ui_pointer']
    if tamper=='bad-frame':p['frame']=3
    if tamper=='invalid-ui':p['ui_pointer']['u']=float('nan')
    if tamper=='no-classification':p.update(stable='PENDING',rps='UNKNOWN')
    clock[0]=100.1;source.publish(p,config_epoch='epoch')
    assert not source.sample_menu_control(tick_id=2).fist_event


def test_direct_fist_latch_survives_unknown_and_single_release_frame():
    clock=[100.];source=GameVisionInputProvider(clock=lambda:clock[0])
    offer(source,clock,1,100,'paper')
    assert not offer(source,clock,2,100.12,None).fist_event
    assert offer(source,clock,3,100.24,'fist').fist_event
    # One erroneous PAPER frame while fist is held cannot re-arm a second click.
    assert not offer(source,clock,4,100.3,'paper').fist_event
    assert not offer(source,clock,5,100.4,'fist').fist_event
    # Genuine open held over two fresh frames re-arms.
    offer(source,clock,6,100.5,'paper');offer(source,clock,7,100.62,'paper')
    assert offer(source,clock,8,100.7,'fist').fist_event
    offer(source,clock,9,100.8,'paper');offer(source,clock,10,100.92,'paper')
    offer(source,clock,11,101,None)
    assert offer(source,clock,12,101.5,'fist').fist_event
    offer(source,clock,13,101.6,'paper');offer(source,clock,14,101.72,'paper')
    assert not offer(source,clock,15,101.8,'fist',run='new-camera').fist_event


def test_current_fist_can_enter_target_without_prior_open_or_a_new_event():
    clock=[100.];source=GameVisionInputProvider(clock=lambda:clock[0]);ui=MenuInputController()
    first=offer(source,clock,1,100,'fist',x=160,y=90)
    assert first.fist_event and first.fist_score==1
    assert ui.update(first).activated_id is None
    for frame,t in ((2,100.1),(3,100.4)):
        held=offer(source,clock,frame,t,'fist')
        assert not held.fist_event and held.fist_score==1
        assert ui.update(held).activated_id is None
    # Slow polling does not turn a held, fresh fist into a lost one-shot event.
    held=offer(source,clock,4,100.7,'fist')
    assert ui.update(held).activated_id=='games'
    ui.reset()
    for frame in range(5,9):
        assert ui.update(offer(source,clock,frame,100.7+frame*.1,'fist')).activated_id is None


def test_slow_menu_release_needs_distinct_fresh_frames_and_no_stale_gap():
    clock=[100.];source=GameVisionInputProvider(clock=lambda:clock[0])
    assert offer(source,clock,1,100,'fist').fist_event
    offer(source,clock,2,100.1,'paper')
    offer(source,clock,2,100.6,'paper')  # Same frame is not a second release.
    assert not offer(source,clock,3,100.7,'fist').fist_event
    offer(source,clock,4,100.8,'paper')
    offer(source,clock,5,102.2,'paper')  # Old release expired before new one.
    assert not offer(source,clock,6,102.3,'fist').fist_event
    offer(source,clock,7,102.4,'paper')
    offer(source,clock,8,103.2,'paper')  # Two fresh samples at 1.25 fps.
    assert offer(source,clock,9,103.3,'fist').fist_event
    assert not offer(source,clock,10,103.4,'fist').fist_event


@pytest.mark.parametrize('release_gap',[.12,.4,.8])
@pytest.mark.parametrize('game_id,xy',[('game1',(84,78)),('game2',(236,78)),('game3',(84,137))])
@pytest.mark.parametrize('clipped',[False,True])
def test_real_menu_fist_chain_starts_each_installed_game_with_unknown_flicker(game_root,tmp_path,game_id,xy,clipped,release_gap):
    library=AssetLibrary(tmp_path/'library',minimum_free_bytes=0,minimum_free_fraction=0)
    ensure_seed_games(game_root,library,install=True)
    clock=[100.];source=GameVisionInputProvider(clock=lambda:clock[0])
    class Session:
        build_id=0xC0061000
        def open(self):return self
    shell=C6IShellRuntimeBackend(Session(),library=library,menu_fps=0,
        live_input=source,sink_factory=lambda *_:Sink())
    try:
        shell.open();shell._return_monitor_stop.set();shell._return_monitor_thread.join(2)
        shell.handle_control(offer(source,clock,1,100,'fist',clipped=clipped))
        shell.handle_control(offer(source,clock,2,100.04,'fist',clipped=clipped))
        assert shell.handle_control(offer(source,clock,3,100.08,'fist',clipped=clipped))=='games'
        assert shell.page is MenuPage.GAMES
        x,y=xy
        shell.handle_control(offer(source,clock,5,100.2,'paper',x=x,y=y,clipped=clipped))
        shell.handle_control(offer(source,clock,6,100.2+release_gap,'paper',x=x,y=y,clipped=clipped))
        shell.handle_control(offer(source,clock,7,100.28+release_gap,None,x=x,y=y))
        assert shell.handle_control(offer(source,clock,8,100.32+release_gap,'fist',x=x,y=y,clipped=clipped))=='game:'+game_id
        assert shell.mode is ShellMode.GAME and shell._game.running
        assert shell.snapshot.last_error is None
    finally:shell.close()
