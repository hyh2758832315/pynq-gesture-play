"""Actual staged package: safe preparation, progress spawns, normal defeat."""
from subprojects.ps_ui_r23b2.test_pause_closure import game_root
from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_sdk import GameInput


def test_preparation_does_not_spawn_enemy_but_playing_still_can_lose(game_root):
    with GameRunner(game_root/'seed_games/game1.vvg',render_rgb=False) as runner:
        for tick in range(600):
            frame=runner.step(GameInput(tick,0,False,0,0,0,False))
            assert frame.snapshot.status=='RUNNING'
            assert frame.snapshot.values['health']==3
            assert frame.snapshot.values['world_x']==0
            assert not runner._plugin._state.enemies
            assert not runner._plugin._state.enemy_projectiles
        spawned=False
        for tick in range(600,1200):
            if tick<630:
                sample=GameInput.from_logical_position(tick_id=tick,timestamp_ns=0,x=319,y=90)
            elif tick<648:
                sample=GameInput.from_logical_position(tick_id=tick,timestamp_ns=0,x=160,y=179)
            else:
                sample=GameInput(tick,0,False,0,0,0,False)
            frame=runner.step(sample)
            if runner._plugin._state.enemies:
                spawned=True
                assert frame.snapshot.values['world_x']>=90
            if frame.snapshot.status=='LOST':break
        assert spawned and frame.snapshot.status=='LOST'
        assert frame.snapshot.values['health']==0
