"""Cache correctness against the pre-change real package and authored victory."""
from dataclasses import asdict
import importlib,json
from pathlib import Path
from subprojects.ps_ui_r23b2.test_pause_closure import game_root
from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_testing import GameTestCase
from pynq_multimodal_game.game_validation import GameTestPlayback,canonical_scene_sha256
from pynq_multimodal_game.return_button import add_return_to_game_frame

ROOT=Path(__file__).resolve().parents[2]

def test_full_victory_and_death_match_prechange_snapshots_and_scene_bytes(game_root):
    suite=json.loads((ROOT/'build/r27-closure-suite-r02.json').read_text())
    for item in (c for c in suite['cases'] if c['game_id']=='game3'):
        with GameRunner(game_root/'seed_games/game3.vvg',render_rgb=False) as runner:
            playback=GameTestPlayback(GameTestCase.from_json(json.dumps(item['case'])),tick_hz=60)
            for row in item['oracle']:
                frame=add_return_to_game_frame(runner.step(playback.input_at(row['tick'])))
                assert json.loads(json.dumps(asdict(frame.snapshot)))==row['snapshot']
                assert canonical_scene_sha256(frame.scene_packet)==row['scene']
            playback.close()

def test_single_map_cache_updates_gate_and_bricks_and_reset(game_root):
    old=ROOT/'build/ps-ui-r27-closure-20261025-board-candidate-r02/seed_games/game3.vvg'
    with GameRunner(old,render_rgb=False) as before, GameRunner(game_root/'seed_games/game3.vvg',render_rgb=False) as after:
        module=importlib.import_module(after._plugin.__class__.__module__.rsplit('.',1)[0]+'.scene_builder')
        for opened,bricks in ((False,()),(False,(3,)),(True,(3,4)),(True,()),(False,())):
            for game in (before._plugin._game,after._plugin._game):
                game.status='RUNNING';game.gate_open=opened;game.used_bricks=set(bricks)
            expected=before._plugin.build_scene().tile_layer
            actual=after._plugin.build_scene().tile_layer
            assert actual==expected
            assert after._plugin.build_scene().tile_layer is actual
            assert module._background_layer.cache_info().currsize==1
