from dataclasses import replace
from pathlib import Path
import struct
import pytest

from pynq_multimodal_game.gpu_abi import COMMAND_CAPACITY,GpuCommand,pack_command_bank
from pynq_multimodal_game.menu import create_menu_assets,build_menu_scene
from pynq_multimodal_game.return_button import (ReturnDwell,RETURN_COMMANDS,
    add_return_to_scene_packet,add_return_to_game_frame,return_progress_commands)
from pynq_multimodal_game.scene_compiler import SceneCompiler,CommandRenderer,SYSTEM_COLORS


def test_clockwise_ring_matches_elapsed_fraction_resets_and_does_not_extend_time():
    dwell=ReturnDwell()
    assert dwell.progress is None
    dwell.update(True,100)
    assert dwell.progress==0
    dwell.update(True,1_000_000_100)
    assert dwell.progress==.5
    assert dwell.update(True,2_000_000_100)
    assert dwell.progress==1
    dwell.update(False,2_100_000_000)
    assert dwell.progress is None
    dwell.update(True,3_000_000_000)
    dwell.update(True,2_900_000_000)
    assert dwell.progress==0
    assets=create_menu_assets()
    compiler=SceneCompiler(sprite_atlas=assets.sprite_atlas,tile_atlas=assets.tile_atlas,palettes=assets.palettes)
    frame=compiler.compile(build_menu_scene(0,(),animate=False))
    base=frame.header.to_bytes()+pack_command_bank(frame.commands)
    images=[]
    for progress in (0,.5,1):
        packet=add_return_to_scene_packet(base,progress)
        assert len(packet)==len(base)
        assert add_return_to_scene_packet(packet,progress)==packet
        count=struct.unpack_from('<I',packet,16)[0]
        commands=tuple(GpuCommand(struct.unpack_from('<8I',packet,64+i*32)) for i in range(count))
        images.append(CommandRenderer().render(replace(frame,commands=commands)))
    def rgb(image,x,y):return image[(y*320+x)*3:(y*320+x+1)*3]
    assert rgb(images[0],12,1)==bytes(SYSTEM_COLORS[4])
    assert rgb(images[1],12,1)==bytes(SYSTEM_COLORS[7])
    assert rgb(images[1],23,12)==bytes(SYSTEM_COLORS[7])
    assert rgb(images[1],1,12)==bytes(SYSTEM_COLORS[4])
    assert rgb(images[2],1,12)==bytes(SYSTEM_COLORS[7])
    assert len(set(images))==3
    half=add_return_to_scene_packet(base,.5)
    full=add_return_to_scene_packet(half,1.)
    assert full==add_return_to_scene_packet(base,1.)
    assert add_return_to_scene_packet(full,None)==add_return_to_scene_packet(base,None)
    assert len(return_progress_commands(.5))==35


@pytest.fixture(scope='module')
def packages(tmp_path_factory):
    from subprojects.ps_ui_r23b2.test_seed_helpers import build_bundled_games
    root=tmp_path_factory.mktemp('ring-packages');build_bundled_games(root)
    return root


@pytest.mark.parametrize('game_id',('game1','game2','game3'))
def test_real_bundled_frames_have_headroom_with_ring_and_2s_caption(packages,game_id):
    from pynq_multimodal_game.game_runner import GameRunner
    from pynq_multimodal_game.game_sdk import GameInput,HandGesture
    runner=GameRunner(packages/'seed_games'/f'{game_id}.vvg',render_rgb=False)
    counts=[]
    try:
        for tick in range(180):
            frame=runner.step(GameInput(tick_id=tick,timestamp_ns=tick*16_666_667,
                hand_valid=True,hand_x=0,hand_y=0,fist_sequence=1,
                fist_event=tick==0,hand_gesture=(HandGesture.FIST,HandGesture.PAPER,
                HandGesture.SCISSORS)[tick//60]))
            decorated=add_return_to_game_frame(frame,(tick%120)/120.)
            counts.append(decorated.command_count)
            assert decorated.command_count<=COMMAND_CAPACITY
            assert decorated.command_count==frame.command_count+len(RETURN_COMMANDS)+35
            assert decorated.predicted_cycles>frame.predicted_cycles
    finally:runner.close()
