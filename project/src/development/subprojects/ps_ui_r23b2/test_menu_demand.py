"""Retained HDMI scenes still update on every visible interaction/state change."""
from dataclasses import replace
from types import SimpleNamespace
import struct
import pytest

from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
from pynq_multimodal_game.gpu_abi import pack_command_bank
from pynq_multimodal_game.menu import MenuPage
from pynq_multimodal_game.pause_menu import PauseInput, PauseRenderer
from subprojects.ps_ui_r23b2.test_pause_closure import Sink as EventSink, control

class Sink(EventSink):
    @property
    def scenes(self):return [packet for kind,packet in self.events if kind=='scene']
    @property
    def assets(self):return [packet for kind,packet in self.events if kind=='asset']

def shell():
    value=C6IShellRuntimeBackend(object(),menu_fps=0)
    value._sink=Sink();value._select_page_locked(MenuPage.HOME)
    return value

def present(value):
    value._submit_menu_frame_locked()
    # Independent full compilation is the pixel/command oracle; frame IDs may
    # advance only on presentation, so compare the drawing command bank.
    frame=value._compile_menu_frame_locked()
    assert value._sink.scenes[-1][64:]==pack_command_bank(frame.commands)
    return value._sink.scenes[-1][64:]

@pytest.mark.parametrize('page',[MenuPage.HOME,MenuPage.GAMES,MenuPage.VIDEOS,MenuPage.HAND_PLACEHOLDER,MenuPage.RESERVED])
def test_unchanged_menu_has_one_gpu_submission_and_hover_changes_immediately(page):
    value=shell();value._select_page_locked(page);first=present(value)
    initial=len(value._sink.scenes)  # Page transition has its own Loading frame.
    for _ in range(120):present(value)
    assert len(value._sink.scenes)==initial
    value.handle_control(control(12,12,10))
    hovered=present(value)
    assert hovered!=first and len(value._sink.scenes)==initial+1
    # A fresh dwell keeps its original two second clock even while frames skip.
    value.handle_control(control(12,12,11));half=present(value)
    assert half!=hovered
    value.handle_control(control(12,12,11.99));present(value)
    assert value._page is page
    assert value.handle_control(control(12,12,12.01))=='back'
    present(value);assert value._page is MenuPage.HOME

def test_hand_pose_and_owner_phase_change_without_resource_reupload():
    value=shell();value._select_page_locked(MenuPage.HAND_PLACEHOLDER)
    initial_assets=len(value._sink.assets)  # Ignore the preceding Loading artwork.
    source={'valid':True,'gesture':'paper'};state={'mode':'serial-fixed-playback','phase':'ACTIVE'}
    value._live_input=SimpleNamespace(peek_hand_classification=lambda:dict(source))
    value._hand_session=SimpleNamespace(status=lambda:dict(state))
    images=[present(value)]
    for gesture in ('fist','scissors',None):
        source['gesture']=gesture;images.append(present(value))
    for phase in ('PAUSING','PAUSED','RESUMING','ACTIVE'):
        state['phase']=phase;images.append(present(value))
    assert all(a!=b for a,b in zip(images,images[1:]))
    count=len(value._sink.scenes)
    for _ in range(120):present(value)
    assert len(value._sink.scenes)==count
    assert len(value._sink.assets)==initial_assets

@pytest.mark.parametrize('outcome',[None,'WON','LOST','DRAW'])
def test_pause_result_progress_and_resource_restore_are_never_suppressed(outcome):
    value=shell();value._game_menu_active=True
    value._pause_renderer=PauseRenderer(outcome=outcome);value._pause_input=PauseInput(outcome=outcome)
    first=present(value)
    for _ in range(100):present(value)
    assert len(value._sink.scenes)==1
    target=value._pause_renderer.targets[1]
    value._pause_input.update(control(160,60,1))  # leave the entry pose
    value._pause_input.update(control(target.center_x,target.center_y,2));hovered=present(value)
    value._pause_input.update(control(target.center_x,target.center_y,3));half=present(value)
    assert len({first,hovered,half})==3
    value._pause_input.update(control(target.center_x,target.center_y,3.99));present(value)
    assert value._pause_input.update(control(target.center_x,target.center_y,4.01))==target.item_id
    present(value)
    # Restoring shared GPU resources forces a new scene even with the same view.
    before=len(value._sink.scenes);value._upload_menu_resources_locked();present(value)
    assert len(value._sink.scenes)==before+1
    ids=[struct.unpack_from('<I',packet,8)[0] for packet in value._sink.scenes]
    assert all(b>a for a,b in zip(ids,ids[1:]))
