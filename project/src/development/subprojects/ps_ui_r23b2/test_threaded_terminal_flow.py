"""Threaded Studio pause -> return menu -> restart -> actual game loss -> exit."""
from types import SimpleNamespace
import time
from subprojects.ps_ui_r23b2.test_pause_closure import game_root,Sink,control,packet
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend,ShellMode
from pynq_multimodal_game.button_input import ButtonGameInputProvider
from pynq_multimodal_game.game_sdk import GameInput
from pynq_multimodal_game.game_seeds import ensure_seed_games
from pynq_multimodal_game.library import AssetLibrary
from pynq_multimodal_game.vision_input import GameVisionInputProvider

def test_threaded_restart_then_terminal_keeps_result_input_alive(game_root,tmp_path):
    library=AssetLibrary(tmp_path/'library',minimum_free_bytes=0,minimum_free_fraction=0)
    ensure_seed_games(game_root,library,install=True)
    clock=[100.];visual=GameVisionInputProvider(clock=lambda:clock[0]);frame=[0]
    source=ButtonGameInputProvider(visual,SimpleNamespace(clear=lambda:None,consume=lambda:None))
    original_factory=source.new_game_session
    def factory(manifest,run):
        session=original_factory(manifest,run)
        def sample(game_id,*,tick_id):
            if tick_id<30:value=GameInput.from_logical_position(tick_id=tick_id,timestamp_ns=0,x=319,y=90)
            elif tick_id<48:value=GameInput.from_logical_position(tick_id=tick_id,timestamp_ns=0,x=160,y=179)
            else:value=GameInput(tick_id,0,False,0,0,0,False)
            return value,None
        session.sample_current_for_game=sample;return session
    source.new_game_session=factory
    shell=C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000,open=lambda:None),
        library=library,menu_fps=30,live_input=source,sink_factory=lambda *_:Sink())
    def point(x,y,t):
        frame[0]+=1;clock[0]=t;visual.publish(packet(frame[0],x,y,valid=False),config_epoch='camera')
    def wait(predicate,seconds=4):
        end=time.monotonic()+seconds
        while not predicate() and time.monotonic()<end:time.sleep(.01)
        assert predicate(),dict(mode=shell.mode,modal=shell.game_menu_active,
            outcome=shell._pause_input.outcome,menu=shell._menu_active,
            thread=shell._menu_thread,hover=shell._pause_input.hovered,error=shell.snapshot.last_error)
    try:
        shell.open();shell.start_game('game1');shell.pause_game()
        point(12,12,101);wait(lambda:shell._return_dwell.entered_ns is not None)
        point(12,12,103.1);wait(lambda:shell.game_menu_active)
        point(64,94,104);wait(lambda:shell._pause_input.hovered=='resume')
        point(64,94,106.1);wait(lambda:not shell.game_menu_active)
        point(160,90,107);wait(lambda:shell._return_armed)
        point(12,12,108);wait(lambda:shell._return_dwell.entered_ns is not None)
        point(12,12,110.1);wait(lambda:shell.game_menu_active)
        old=shell._game._game_run
        point(160,94,111);wait(lambda:shell._pause_input.hovered=='restart')
        point(160,94,113.1);wait(lambda:shell._game is not None and shell._game._game_run!=old and not shell.game_menu_active)
        point(160,90,114);wait(lambda:shell.game_menu_active and shell._pause_input.outcome=='LOST')
        point(224,94,115);wait(lambda:shell._pause_input.hovered=='main-menu')
        point(224,94,117.1);wait(lambda:shell.mode is ShellMode.MENU)
    finally:shell.close()
