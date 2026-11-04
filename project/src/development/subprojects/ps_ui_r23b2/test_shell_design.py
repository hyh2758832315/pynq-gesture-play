"""HDMI design contracts: real packer budget, release gate and loading ownership."""
from dataclasses import replace
from types import SimpleNamespace
import pytest
from pynq_multimodal_game.agent import c6i_shell
from pynq_multimodal_game.menu import MenuInputController,HOME_TARGETS,game_targets
from pynq_multimodal_game.gpu_abi import pack_assets,pack_asset_bundle_packet
from pynq_multimodal_game.creative_pages import PixelPageRenderer
from subprojects.ps_ui_r23b2.tools.preview_shell_pages import frames
from subprojects.ps_ui_r23b2.test_pause_closure import control,Sink


def test_all_pages_fit_real_bank_and_fast_packer_is_exact():
    packer=PixelPageRenderer()
    for name,frame in frames():
        assert len(pack_assets(frame.assets,generation=1).payload)<=32768,name
        assert frame.header.command_count==len(frame.commands)
        if frame.assets[0].width==320:
            assert packer.pack_assets(frame,1)==pack_asset_bundle_packet(frame.assets,generation=1),name


def test_rectangle_hitboxes_match_layout_without_overlapping():
    for targets in (HOME_TARGETS,game_targets(('a','b','c','d'))):
        for y in range(180):
            for x in range(320):
                assert sum(t.contains(x,y) for t in targets)<=1


def test_held_fist_unknown_and_duplicate_release_do_not_cross_page():
    ui=MenuInputController(stable_ticks=1)
    fist=replace(control(86,83,1),fist_event=True,fist_score=1,gesture_seq=10)
    assert ui.update(fist).activated_id=='games'
    ui.reset(require_release=True)
    target=game_targets(('a','b','c'))
    for t in (1.2,1.4,2):
        assert ui.update(replace(fist,hand_x=84*2/319-1,hand_y=78*2/179-1,
            timestamp_ns=int(t*1e9),fist_event=False),target).activated_id is None
    release=control(84,78,2.1)
    obs=dict(valid=True,gesture='paper',source_at=2.1,frame_id=1,run_id='cam',config_epoch='a')
    ui.update(release,target,observation=obs)
    ui.update(replace(release,timestamp_ns=2_200_000_000),target,observation=obs)
    assert not ui.confirm_armed
    ui.update(control(84,78,2.3),target,observation=dict(obs,gesture=None,frame_id=2))
    assert not ui.confirm_armed
    ui.update(control(84,78,2.4),target,observation=dict(obs,source_at=2.4,frame_id=3))
    ui.update(control(84,78,2.5),target,observation=dict(obs,source_at=2.5,frame_id=4))
    assert ui.confirm_armed
    assert ui.update(replace(control(84,78,2.6),fist_score=1),target).activated_id=='game:a'


@pytest.mark.parametrize('failure',['validation','constructor','start',None])
def test_loading_is_presented_before_preparation_and_failures_restore_menu(monkeypatch,failure):
    sink=Sink();events=[]
    class Game:
        def __init__(self,*args,**kwargs):
            events.append('construct')
            if failure=='constructor':raise ValueError('constructor failed')
        def start(self):
            events.append('start')
            if failure=='start':raise ValueError('start failed')
        def stop(self):events.append('stop')
    def validate(*args,**kwargs):
        assert any(kind=='scene' for kind,_ in sink.events)
        assert events==['drain','drain']
        events.append('validate')
        if failure=='validation':raise ValueError('validation failed')
        return SimpleNamespace(manifest=SimpleNamespace(volume_inputs=None))
    shell=c6i_shell.C6IShellRuntimeBackend(object(),menu_fps=0)
    shell._sink=sink;shell._game_ids=('g',)
    shell._game_entries={'g':SimpleNamespace(asset='package',manifest=SimpleNamespace(display_name='TEST'))}
    monkeypatch.setattr(shell,'_drain_sink',lambda:events.append('drain'))
    monkeypatch.setattr(shell,'_stop_menu',lambda:None)
    monkeypatch.setattr(shell,'_resume_menu',lambda:events.append('menu'))
    monkeypatch.setattr(c6i_shell,'validate_game_package',validate)
    monkeypatch.setattr(c6i_shell,'PackagedGameRuntime',Game)
    if failure:
        with pytest.raises(ValueError):shell.start_game('g')
        assert events[-1]=='menu'
    else:
        shell.start_game('g')
        assert shell.mode is c6i_shell.ShellMode.GAME
        assert events[-2:]==['construct','start']
    assert sum(kind=='scene' for kind,_ in sink.events)==1
