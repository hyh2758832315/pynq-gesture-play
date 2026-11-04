"""End-screen UI contract; terminal observations are explicitly injected fixtures."""
from dataclasses import replace
from types import SimpleNamespace
import time

import pytest

from subprojects.ps_ui_r23b2.test_pause_closure import game_root, Sink, control
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend, ShellMode
from pynq_multimodal_game.button_input import ButtonGameInputProvider
from pynq_multimodal_game.game_seeds import ensure_seed_games
from pynq_multimodal_game.library import AssetLibrary
from pynq_multimodal_game.pause_menu import PauseInput, PauseRenderer, RESULT_TARGETS
from pynq_multimodal_game.scene_compiler import CommandRenderer
from pynq_multimodal_game.gpu_abi import COMMAND_CAPACITY, pack_asset_bundle_packet
from pynq_multimodal_game.vision_input import GameVisionInputProvider


def test_studio_timeline_ignores_live_return_dwell_but_live_play_keeps_it():
    """A real camera at Back cannot pause an isolated Studio replay."""
    now=[0.]
    source=SimpleNamespace(peek_menu_control=lambda:control(12,12,now[0]))
    shell=C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000),
        menu_fps=0,live_input=source,sink_factory=lambda *_:Sink())
    shell._mode=ShellMode.GAME
    shell._active_test_case_json='studio-timeline'
    shell._return_armed=True
    paused=[]
    shell.open_game_menu=lambda:paused.append(True)
    for second in (1.,2.,3.1,4.2):
        now[0]=second
        assert shell._poll_return_control() is None
    assert not paused
    assert shell._return_dwell.progress is None
    shell._active_test_case_json=None
    now[0]=5.
    assert shell._poll_return_control() is None
    now[0]=7.01
    assert shell._poll_return_control()=='pause-menu'
    assert paused==[True]


@pytest.mark.parametrize('outcome', ('WON', 'LOST', 'DRAW'))
def test_result_requires_new_dwell_has_no_continue_and_back_means_menu(outcome):
    ui = PauseInput(outcome=outcome)
    assert ui.update(control(96,94,0)) is None
    assert ui.update(control(96,94,5)) is None  # no automatic replay from entry pose
    assert ui.update(control(160,90,6)) is None
    assert ui.update(control(96,94,7)) is None
    assert ui.update(control(96,94,9.01)) == 'restart'
    assert ui.update(control(12,12,10)) is None
    assert ui.update(control(12,12,12.01)) == 'main-menu'
    assert {t.item_id for t in ui.targets} == {'back', 'restart', 'main-menu'}


def test_result_titles_and_resources_are_distinct_and_bounded():
    images=[]
    for outcome in ('WON','LOST','DRAW'):
        renderer=PauseRenderer(outcome=outcome)
        frames=[renderer.compile(1,7,item,.5) for item in (None,'back','restart','main-menu')]
        assert len({pack_asset_bundle_packet(f.assets,generation=7) for f in frames})==1
        assert len(pack_asset_bundle_packet(frames[0].assets,generation=7)) < 32*1024
        assert all(len(f.commands)<=COMMAND_CAPACITY for f in frames)
        images.append(CommandRenderer().render(frames[0]))
    assert len(set(images))==3


@pytest.mark.parametrize('outcome', ('WON','LOST','DRAW'))
def test_completed_outcome_freezes_and_restart_or_exit_closes_loop(game_root,tmp_path,outcome):
    library=AssetLibrary(tmp_path/'library',minimum_free_bytes=0,minimum_free_fraction=0)
    ensure_seed_games(game_root,library,install=True)
    visual=GameVisionInputProvider()
    source=ButtonGameInputProvider(visual,SimpleNamespace(clear=lambda:None,consume=lambda:None))
    session=SimpleNamespace(build_id=0xC0061000,open=lambda:None)
    shell=C6IShellRuntimeBackend(session,library=library,menu_fps=0,
        live_input=source,sink_factory=lambda *_:Sink())
    try:
        shell.open();shell._return_monitor_stop.set();shell._return_monitor_thread.join(2)
        for action in ('restart','main-menu'):
            if shell.mode is not ShellMode.GAME: shell.start_game('game2')
            game=shell._game;game.pause(keep_source_live=True)
            original=game._completed_scene
            terminal=replace(original[0],snapshot=replace(original[0].snapshot,status=outcome,score=260))
            # A submitted/unconfirmed frame must not open the result screen.
            game._last_frame=terminal
            assert game.terminal_status is None
            game._completed_scene=(terminal,*original[1:])
            game._paused.clear()
            game._revoke_terminal(terminal)
            assert game.paused
            # Studio timelines must keep their fixed tick/Scene comparison contract.
            shell._active_test_case_json='timeline-fixture'
            assert shell._poll_return_control() is None
            assert not shell.game_menu_active
            shell._active_test_case_json=None
            assert shell._poll_return_control()=='game-result'
            assert shell.game_menu_active and game.paused
            assert shell._pause_input.outcome==outcome
            assert shell._pause_renderer.score==260
            tick=game.tick_id;time.sleep(.03);assert game.tick_id==tick
            with pytest.raises(RuntimeError,match='finished game'):
                shell.resume_game()
            assert shell.handle_control(control(160,90,100)) is None
            target=next(t for t in RESULT_TARGETS if t.item_id==action)
            assert shell.handle_control(control(target.center_x,target.center_y,101)) is None
            assert shell.handle_control(control(target.center_x,target.center_y,103.01))==action
            assert not shell.game_menu_active
            if action=='restart':
                assert shell.mode is ShellMode.GAME and shell._game._game_run!=game._game_run
                assert shell._game.terminal_status is None
            else:
                assert shell.mode is ShellMode.MENU and shell._game is None
    finally:
        shell.close()
