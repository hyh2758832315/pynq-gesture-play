"""Canvas gestures, bounded rendering and demo page exit through the real shell."""
from dataclasses import replace
from types import SimpleNamespace
import json
from pathlib import Path

import pytest
from pynq_multimodal_game.controls import MockControlAdapter,ControlSource
from pynq_multimodal_game.creative_pages import CanvasPage,PixelPageRenderer,robot_frame,SIZES
from pynq_multimodal_game.gpu_abi import pack_asset_bundle_packet,ASSET_BUNDLE_CAPACITY_BYTES
from pynq_multimodal_game.menu import MenuPage,HOME_TARGETS
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend

def control(x=100,y=90,seconds=10,seq=1):
    return replace(MockControlAdapter(ControlSource.KEYBOARD).read(tick_id=0,timestamp_ns=0),
        hand_valid=True,hand_x=x*2/319-1,hand_y=y*2/179-1,timestamp_ns=round(seconds*1e9),gesture_seq=seq)

def obs(frame,seconds,pose='paper'):
    return dict(valid=True,run_id='r',config_epoch='c',frame_id=frame,source_at=seconds,gesture=pose)

def offer(page,x,y,t,pose,frame,seq=1):
    result=None
    for poll in range(3):
        c=replace(control(x,y,t,seq),timestamp_ns=round(t*1e9)+poll,
                  fist_score=float(pose=='fist'))
        value=page.update(c,obs(frame,t,pose))
        if value is not None:result=value
    return result

def test_shape_select_short_fist_and_moving_brush_only():
    c=CanvasPage()
    assert offer(c,288,31,10,'fist',1)=='select'
    assert c.shape=='triangle'
    assert offer(c,90,90,10.1,'scissors',2) is None
    assert c.revision==0
    assert offer(c,90,90,10.2,'fist',3)=='paint'
    r=c.revision
    assert offer(c,100,90,10.25,'scissors',4) is None
    offer(c,100,90,10.3,None,5)
    assert offer(c,100,90,10.4,'scissors',6) is None
    assert c.revision==r
    offer(c,100,90,10.5,'paper',7)
    assert offer(c,100,90,10.6,'fist',8)=='paint'
    assert offer(c,110,90,10.7,'fist',9)=='paint'
    assert offer(c,110,90,10.8,'fist',10) is None
    assert offer(c,140,90,10.9,'fist',11)=='paint'

def test_sidebar_uses_menu_control_even_if_classification_flickers_and_sequence_stays_constant():
    c=CanvasPage()
    result=None
    for poll in range(3):
        # A confirmed UI fist remains usable when the separate classification
        # snapshot is UNKNOWN. This is the same path used by the main menu.
        value=c.update(replace(control(288,66,10+poll*.01,1),fist_score=1),obs(1,10,None))
        result=value or result
    assert result=='select' and c.shape=='square'
    for poll in range(5):
        assert offer(c,304,167,10.1+poll*.1,'fist',poll+2,1) is None
    assert c.size==16  # Held fist cannot jump to another button or auto-repeat.
    offer(c,304,167,11,'paper',10,1)
    offer(c,304,167,11.1,'paper',11,1)
    assert offer(c,304,167,11.2,'fist',12,1)=='select'
    assert c.size==22


def test_canvas_uses_same_confirmed_fist_as_menu_when_classifier_is_unknown():
    c=CanvasPage();c.shape='square'
    assert c.update(replace(control(100,90,10),fist_score=1),obs(1,10,None))=='paint'
    assert c.pixels[90*256+100]==4


def test_real_edge_ui_fist_paints_but_expired_control_cannot_paint():
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    from subprojects.ps_ui_r23b2.test_menu_confirmation import offer as publish
    clock=[100.];source=GameVisionInputProvider(clock=lambda:clock[0])
    c=CanvasPage();c.shape='circle'
    ui=publish(source,clock,1,100,'fist',x=100,y=90,clipped=True)
    classification=source.peek_hand_classification()
    assert ui.fist_score==1 and classification['gesture'] is None
    assert c.update(ui,classification)=='paint'
    clock[0]+=2
    expired=source.sample_menu_control(tick_id=2)
    assert not expired.hand_valid
    assert c.update(expired,source.peek_hand_classification()) is None
    assert c._last_brush is None and c.revision==1


def test_rate_limit_defers_latest_frame_instead_of_consuming_it():
    c=CanvasPage();c.shape='square'
    assert offer(c,50,90,10,'fist',1)=='paint'
    assert offer(c,100,90,10.02,'fist',2) is None
    assert offer(c,120,90,10.04,'fist',3) is None
    assert offer(c,120,90,10.08,'fist',3)=='paint'
    assert c.pixels[90*256+120]==4
    # Once accepted, repeated polls of the same frame cannot paint elsewhere.
    assert offer(c,170,90,10.2,'fist',3) is None
    assert c.pixels[90*256+170]==2


def test_canvas_hover_only_changes_commands_and_reuses_background_assets():
    c=CanvasPage();renderer=PixelPageRenderer()
    first=renderer.compile_canvas(c,1,3)
    offer(c,288,31,10,'paper',1)
    hovered=renderer.compile_canvas(c,2,3)
    assert hovered.assets is first.assets
    assert hovered.commands!=first.commands


@pytest.mark.parametrize('page',[MenuPage.HOME,MenuPage.GAMES,MenuPage.VIDEOS])
def test_main_and_library_menus_request_existing_live_hand_owner(page):
    s=shell();s._select_page_locked(page)
    assert s._hand_session.calls==['live']
    s._select_page_locked(MenuPage.CANVAS)
    assert s._hand_session.calls[-1]=='idle'


def test_startup_grants_home_follow_after_late_hand_owner_attachment():
    s=shell();s._startup_settle_seconds=0
    s._stop_startup_animation=lambda:None
    def present_menu():assert s._hand_session.calls==['live']
    s._start_menu_locked=present_menu
    s._complete_startup_locked()
    assert s._hand_session.calls==['live']


@pytest.mark.parametrize('outside',[(288,66),(250,90),(100,20)])
def test_real_provider_scissors_never_paints_and_short_fist_does(outside):
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    from subprojects.ps_ui_r23b2.test_pause_closure import packet
    now=[100.];provider=GameVisionInputProvider(clock=lambda:now[0])
    s=shell();s._live_input=provider;s._select_page_locked(MenuPage.CANVAS)
    frame=0
    def send(x,y,pose):
        nonlocal frame
        frame+=1;now[0]+=.15
        p=packet(frame,x,y)
        p['stable'],p['rps']={'fist':('0','ROCK'),'scissors':('2','SCISSORS'),
                              'paper':('5','PAPER'),None:('PENDING','UNKNOWN')}[pose]
        provider.publish(p,config_epoch='cfg')
        result=None
        for poll in range(3):
            now[0]+=.001
            value=s.handle_control(provider.sample_menu_control(tick_id=frame))
            if value is not None:result=value
        return result
    assert send(288,31,'fist')=='select'
    assert s._canvas.shape=='triangle'
    assert send(*outside,'scissors') is None
    assert s._canvas.revision==0
    assert send(100,90,'scissors') is None
    assert s._canvas.revision==0
    assert send(100,90,'fist')=='paint'
    assert s._canvas.pixels[90*256+100]==3
    # Moving the preview, UNKNOWN flicker and leaving/reentering are not new stamps.
    for x,y,pose in ((140,90,'scissors'),(140,90,None),(*outside,'scissors'),(160,90,'scissors')):
        assert send(x,y,pose) is None
    assert s._canvas.revision==1
    assert s._canvas.pixels[90*256+160]==2
    send(180,90,'paper')
    assert send(180,90,'fist')=='paint'
    assert s._canvas.revision==2

def test_identical_overlap_is_clean_and_new_color_overwrites_in_place():
    c=CanvasPage();c.shape='square';c.size_index=5
    assert offer(c,100,90,10,'fist',1)=='paint'
    original=bytes(c.pixels);revision=c.revision
    for n in range(20):
        offer(c,100,90,11+n*.3,'paper',2+n*2)
        assert offer(c,100,90,11.15+n*.3,'fist',3+n*2) is None
    assert bytes(c.pixels)==original and c.revision==revision
    # A smaller same-colored shape wholly inside existing paint is also clean.
    c.size_index=0
    assert offer(c,105,90,20,'fist',50) is None
    c.shape='circle'
    assert offer(c,110,90,21,'fist',51)=='paint'
    assert c.pixels[90*256+110]==5
    assert c.pixels[90*256+85]==4
    assert len(c.pixels)==46080 and c.revision==revision+1

def test_duplicate_stale_and_lost_frames_never_paint_or_bridge():
    c=CanvasPage(); c.shape='square'
    offer(c,40,60,10,'fist',1)
    r=c.revision
    c.update(control(60,60,10.1),obs(1,10,'fist'))
    assert c.revision==r
    c.update(control(70,60,10.6),obs(2,10,'fist'))
    assert c.revision==r and c._last_brush is None
    offer(c,100,60,10.7,'fist',3)
    assert c.pixels[60*256+70]==2
    assert len(c.pixels)==256*180

def test_bounds_sizes_and_clipping_do_not_touch_sidebar():
    c=CanvasPage(); c.shape='star'
    for i in range(10):
        for j,pose in enumerate(('paper','paper','fist')):
            offer(c,310,168,10+i*.3+j*.1,pose,i*3+j+1,i+1)
    assert c.size==max(SIZES)
    offer(c,255,179,14,'fist',40)
    assert len(c.pixels)==46080
    for i in range(10):
        for j,pose in enumerate(('paper','paper','fist')):
            offer(c,265,168,15+i*.3+j*.1,pose,50+i*3+j,i+20)
    assert c.size==min(SIZES)

def test_return_requires_two_seconds_and_clear_stays_on_canvas():
    c=CanvasPage();c.shape='circle'
    offer(c,90,90,10,'fist',1)
    offer(c,12,12,11,'paper',2)
    assert offer(c,12,12,12.9,'paper',3) is None
    assert offer(c,12,12,13,'paper',4)=='dialog'
    offer(c,198,90,13.1,'paper',5)
    assert offer(c,198,90,15.1,'paper',6)=='clear'
    assert not c.dialog and set(c.pixels)=={2}
    assert c.shape=='circle'

def test_preview_is_not_saved_and_render_fits_frozen_gpu_bank():
    c=CanvasPage();c.shape='star';c.pointer=(120,80)
    saved=bytes(c.pixels)
    frame=PixelPageRenderer().compile(c.render(),1,3,.5)
    assert bytes(c.pixels)==saved
    assert len(pack_asset_bundle_packet(frame.assets,generation=3))<ASSET_BUNDLE_CAPACITY_BYTES
    assert len(frame.commands)<128
    geometry=json.loads((Path(__file__).parent/'python/pynq_multimodal_game/data/demo_geometry.json').read_text())
    assert len({robot_frame(k,'PLAYING',i,geometry) for i,k in enumerate(geometry)})==12

def test_fast_page_packet_matches_existing_packer_byte_for_byte():
    import random
    rng=random.Random(43);renderer=PixelPageRenderer()
    for generation in (1,257,258):
        pixels=bytes(rng.randrange(16) for _ in range(320*180))
        frame=renderer.compile(pixels,4,generation)
        assert renderer.pack_assets(frame,generation)==pack_asset_bundle_packet(frame.assets,generation=generation)


def test_right_hand_pose_art_is_cached_and_digits_use_recorded_shapes():
    from pynq_multimodal_game.creative_pages import _robot_hand_pixels
    geometry=json.loads((Path(__file__).parent/'python/pynq_multimodal_game/data/demo_geometry.json').read_text())
    _robot_hand_pixels.cache_clear()
    art={pose:robot_frame(pose,'PLAYING',0,geometry) for pose in geometry}
    # Compare only hand body: text labels cannot make identical poses pass.
    body=lambda pixels:b''.join(pixels[y*320+85:y*320+235] for y in range(52,159))
    assert len({body(pixels) for pixels in art.values()})==12
    for y in range(87,105):
        assert all(art['demo:5'][y*320+x]==1 for x in range(85,114))
    assert any(art['demo:5'][y*320+x]!=1 for y in range(87,105) for x in range(209,234))
    robot_frame('demo:5','DEFAULT',9,geometry)
    assert _robot_hand_pixels.cache_info().hits==1
    assert _robot_hand_pixels.cache_info().currsize==12

class Sink:
    def __init__(self): self.assets=[];self.scenes=[]
    def upload_asset(self,p):self.assets.append(p)
    def upload_palette(self,p):pass
    def upload_tilemap(self,p):pass
    def submit_scene(self,p):self.scenes.append(p)
    def close(self):pass

class Hand:
    def __init__(self):self.generation=0;self.calls=[];self.value=dict(phase='IDLE',off=True)
    def set_page_mode(self,mode,restart=False):
        self.calls.append(mode);self.generation+=1;self.value=dict(phase='WAITING',off=False)
        return self.generation
    def page_status(self):return dict(self.value,pose='default',index=0)
    def status(self):return dict(phase='ACTIVE')

def shell():
    s=C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000),menu_fps=0)
    s._sink=Sink();s._hand_session=Hand()
    return s

def test_menu_fourth_is_canvas_and_demo_returns_only_after_off():
    assert HOME_TARGETS[-1].item_id=='canvas'
    s=shell();s._select_page_locked(MenuPage.HAND_DEMO)
    assert s._hand_session.calls==['demo']
    s.return_to_menu()
    assert s.page is MenuPage.HAND_DEMO and s._hand_session.calls[-1]=='idle'
    with pytest.raises(RuntimeError,match='confirmed OFF'):
        s.start_game('does-not-matter')
    with pytest.raises(RuntimeError,match='confirmed OFF'):
        s.run()
    s._hand_session.value=dict(phase='IDLE',off=True)
    s._submit_menu_frame_locked()
    assert s.page is MenuPage.HOME

def test_catalog_refresh_cannot_restart_active_demo():
    from pynq_multimodal_game.library import AssetLibrary
    import tempfile
    s=shell()
    with tempfile.TemporaryDirectory() as folder:
        s._library=AssetLibrary(Path(folder),minimum_free_bytes=0,minimum_free_fraction=0)
        s._select_page_locked(MenuPage.HAND_DEMO)
        count=len(s._hand_session.calls)
        s.refresh_catalog()
        assert len(s._hand_session.calls)==count
        assert s.page is MenuPage.HAND_DEMO

def test_complete_demo_auto_home_and_canvas_only_uploads_dirty_frame(monkeypatch):
    s=shell();s._select_page_locked(MenuPage.HAND_DEMO)
    s._hand_session.value=dict(phase='DONE',off=True)
    s._submit_menu_frame_locked()
    assert s.page is MenuPage.HOME
    s._select_page_locked(MenuPage.CANVAS)
    monkeypatch.setattr('pynq_multimodal_game.agent.c6i_shell.time.monotonic',lambda:100.)
    s._submit_menu_frame_locked()
    count=len(s._sink.assets)
    s._submit_menu_frame_locked()
    assert len(s._sink.assets)==count
    s._canvas.shape='circle';s._feature_last_submit=0
    s._submit_menu_frame_locked()
    assert len(s._sink.assets)==count+1

