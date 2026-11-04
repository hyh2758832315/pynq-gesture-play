"""Album isolation, safe transitions, home restart and frozen resource budgets."""
from dataclasses import replace
from types import SimpleNamespace
import pytest
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
from pynq_multimodal_game.creative_pages import CanvasPage,PixelPageRenderer,album_frame,add_album_control
from pynq_multimodal_game.gpu_abi import pack_assets,COMMAND_CAPACITY
from pynq_multimodal_game.menu import MenuPage,HOME_TARGETS
from pynq_multimodal_game.shell_pages import render_shell_page,home_options
from subprojects.ps_ui_r23b2.test_creative_pages import shell,control,obs,offer

def send(s,x,y,t,pose='paper',frame=1):
    s._live_input=SimpleNamespace(peek_hand_classification=lambda:obs(frame,t,pose))
    return s.handle_control(control(x,y,t,frame))

def save(s,t=10,frame=1):
    send(s,12,12,t,frame=frame)
    assert send(s,12,12,t+2.01,frame=frame+1)=='dialog'
    send(s,122,90,t+2.2,frame=frame+2)
    assert send(s,122,90,t+4.21,frame=frame+3)=='save'

def test_save_is_snapshot_latest_only_and_album_returns_to_unchanged_canvas():
    s=shell();s._select_page_locked(MenuPage.CANVAS);s._canvas.wait_exit=False
    page=s._canvas;page.shape='square'
    send(s,100,90,9,'fist')
    save(s)
    original=s._album_pixels
    assert original==bytes(page.pixels) and len(original)==46080
    send(s,160,90,15,'fist',7)
    assert bytes(page.pixels)!=original and s._album_pixels==original
    save(s,16,8)
    assert s._album_revision==2 and s._album_pixels==bytes(page.pixels)!=original
    send(s,12,168,21,frame=13)
    assert send(s,12,168,23.01,frame=14)=='album'
    assert s.page is MenuPage.ALBUM and s._canvas is page
    saved=s._album_pixels
    # Same universal return; album is read-only even for a fist over the image.
    send(s,100,90,24,'fist',15)
    assert s._album_pixels is saved
    send(s,12,12,25,frame=16)
    assert send(s,12,12,27.01,frame=17)=='back'
    assert s.page is MenuPage.CANVAS and s._canvas is page
    assert s._album_pixels==bytes(page.pixels)
    s._select_page_locked(MenuPage.HOME);s._select_page_locked(MenuPage.CANVAS)
    assert s._canvas is not page and s._album_pixels is saved
    assert shell()._album_pixels is None

def test_album_dwell_resets_on_lost_hand_and_never_paints_icon_area():
    c=CanvasPage();c.shape='star'
    assert offer(c,12,168,10,'fist',1) is None
    c.update(replace(control(12,168,11),hand_valid=False),None)
    assert offer(c,12,168,12,'fist',2) is None
    assert offer(c,12,168,14.01,'fist',3)=='album'
    assert c.revision==0 and set(c.pixels)=={2}

def test_home_options_continue_and_restart_are_dwell_gated_and_restart_is_one_shot():
    s=shell();s._album_pixels=b'x'*46080
    send(s,12,12,10);assert send(s,12,12,12.01)=='back'
    assert s._home_dialog
    send(s,95,95,12.2);assert send(s,95,95,14.21)=='continue'
    assert not s._home_dialog and s._album_pixels is not None
    send(s,100,30,15);send(s,12,12,16);send(s,12,12,18.01)
    callbacks=[];s._restart_callback=lambda:callbacks.append('stop-loop')
    send(s,225,95,18.2)
    assert send(s,225,95,20.21)=='restart'
    assert s._restart_requested and callbacks==['stop-loop']
    assert send(s,225,95,23) is None and callbacks==['stop-loop']
    assert s._hand_session.calls[-1]=='idle'

def test_loading_is_presented_before_page_preparation_and_hand_request(monkeypatch):
    s=shell();events=[]
    monkeypatch.setattr(s,'_show_content_loading',lambda *a:events.append(('loading',a[0])))
    monkeypatch.setattr(s,'_request_hand_page',lambda *a,**kw:events.append(('hand',a[0])))
    for page in (MenuPage.GAMES,MenuPage.VIDEOS,MenuPage.CANVAS,MenuPage.ALBUM,MenuPage.HOME,MenuPage.HAND_DEMO):
        before=len(events);s._select_page_locked(page)
        assert events[before][0]=='loading'
    events.clear();s._hand_session.value=dict(phase='WAITING',off=False)
    s._leave_demo_locked()
    assert events[0][0]=='loading' and events[1]==('hand','idle')
    frame=s._menu_frame_id;s._submit_menu_frame_locked()
    assert s._menu_frame_id==frame

def test_album_home_dialog_and_two_controls_fit_frozen_gpu_budget():
    renderer=PixelPageRenderer()
    for pixels in (album_frame(None),album_frame(bytes([2])*46080),
                   home_options('restart',24),home_options('continue',12)):
        frame=renderer.compile(pixels,1,1)
        assert len(pack_assets(frame.assets,generation=1).payload)<=32768
        assert len(frame.commands)<=COMMAND_CAPACITY
    c=CanvasPage();c.shape='star';c.size_index=5;c.pointer=(25,155)
    c.album_dwell.update(True,1);c.album_dwell.update(True,1_000_000_001)
    assert len(renderer.compile_canvas(c,1,1).commands)<=COMMAND_CAPACITY

def test_wordmark_background_matches_header():
    pixels=render_shell_page(MenuPage.HOME,HOME_TARGETS,('GAME','VIDEO','HAND','CANVAS'))
    assert pixels[1*320+23]==pixels[1*320+150]==11
    assert pixels[50*320+30]==pixels[50*320+150]==1
    from pynq_multimodal_game.shell_theme import wordmark
    width,height,_=wordmark(44)
    assert height==44 and width<wordmark()[0]

def test_video_loading_precedes_expensive_staging(monkeypatch):
    s=shell();s._video_entries={'v':object()};events=[]
    monkeypatch.setattr(s,'_stop_menu',lambda:events.append('stop-menu'))
    monkeypatch.setattr(s,'_show_content_loading',lambda *a:events.append('loading'))
    monkeypatch.setattr(s,'stage_library_video',lambda *_:events.append('stage'))
    monkeypatch.setattr(s,'activate',lambda:events.append('activate'))
    monkeypatch.setattr(s,'run',lambda **kw:events.append(('run',kw['show_loading'])))
    s.play_library_video('v')
    assert events==['stop-menu','loading','stage','activate',('run',False)]

@pytest.mark.parametrize('modal',['canvas','home'])
def test_modal_progress_uses_commands_without_reuploading_background(modal):
    s=shell()
    if modal=='canvas':
        s._select_page_locked(MenuPage.CANVAS)
        s._canvas.dialog=True;s._canvas.dialog_target='save';dwell=s._canvas.dialog_dwell
    else:
        s._home_dialog=True;s._home_dialog_target='restart';dwell=s._home_dialog_dwell
    dwell.update(True,1)
    s._feature_last_submit=-1;s._submit_menu_frame_locked()
    uploads=len(s._sink.assets)
    for n in range(1,20):
        dwell.update(True,1+n*80_000_000)
        s._feature_last_submit=-1;s._submit_menu_frame_locked()
    assert len(s._sink.assets)==uploads


def test_home_restart_presents_boot_renderer_before_cleanup_callback(monkeypatch):
    from pynq_multimodal_game.startup_ui import StartupRenderer,StartupSnapshot
    from pynq_multimodal_game.gpu_abi import pack_command_bank
    s=shell();s._home_dialog=True;s._home_dialog_wait_exit=False
    events=[]
    monkeypatch.setattr(s,'_show_content_loading',lambda *a:pytest.fail('Restart used page transition'))
    def stopping():
        assert s._restart_requested
        assert isinstance(s._startup_renderer,StartupRenderer)
        assert s._startup_snapshot==StartupSnapshot()
        events.append('normal-cleanup-request')
    s._restart_callback=stopping
    send(s,225,95,10)
    assert send(s,225,95,12.01)=='restart'
    expected=s._startup_renderer.compile(StartupSnapshot(),frame_id=0,generation=0xC6A20001,
                                         elapsed_seconds=0.)
    # Initial boot frame has the same assets and commands, without RETURN_COMMANDS.
    actual=s._sink.scenes[-1]
    assert actual==expected.header.to_bytes()+pack_command_bank(expected.commands)
    assert events==['normal-cleanup-request']


def test_transition_loader_has_no_return_commands():
    from pynq_multimodal_game.shell_pages import content_loading
    from pynq_multimodal_game.return_button import RETURN_COMMANDS
    r=PixelPageRenderer();pixels=content_loading('CANVAS','page')
    loading=r.compile(pixels,0,1,show_return=False)
    normal=r.compile(pixels,0,1)
    assert len(normal.commands)==len(loading.commands)+len(RETURN_COMMANDS)
    assert loading.assets==normal.assets
