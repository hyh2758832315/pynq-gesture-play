"""Duel collision, input, fairness, replay and frozen GPU resource checks."""
from collections import deque
import random
from games.game4.src.rules import Duel,WIDTH,HEIGHT,MAX_LENGTH,DIRECTIONS,advance
from games.game4.src.main import Game
from pynq_multimodal_game.game_sdk import GameContext,GameInput,HandGesture
from pynq_multimodal_game.scene_compiler import SceneCompiler,CommandRenderer
from pynq_multimodal_game.gpu_abi import pack_assets,pack_tilemap_packet,COMMAND_CAPACITY


def layout(player,robot=((25,12),(26,12),(27,12)),direction=(1,0)):
    d=Duel(random.Random(0));d.player=deque(player);d.robot=deque(robot)
    d.player_direction=d.pending_direction=direction;d.fruits={(20,2),(21,2),(22,2)}
    return d


def test_four_walls_wrap_without_collision():
    for head,direction,expected in [((37,3),(1,0),(0,3)),((0,3),(-1,0),(37,3)),
                                    ((5,17),(0,1),(5,0)),((5,0),(0,-1),(5,17))]:
        d=layout([head],direction=direction);d.move(True,False)
        assert d.status=='RUNNING' and d.player[0]==expected


def test_self_and_enemy_body_collision_fail_and_freeze():
    for body,robot in [([(2,2),(2,3),(3,3),(3,2),(4,2)],[(25,12)]),
                       ([(2,2),(1,2)],[(4,2),(3,2),(3,3)])]:
        d=layout(body,robot);before=list(d.player);d.move(True,False)
        assert d.status=='LOST' and list(d.player)==before


def test_vacating_own_tail_is_legal_but_stationary_enemy_tail_is_solid():
    d=layout([(2,2),(2,3),(3,3),(3,2)]);d.move(True,False)
    assert d.status=='RUNNING' and len(d.player)==4
    d=layout([(2,2)],[(4,2),(3,2)]);d.move(True,False)
    assert d.status=='LOST'


def test_moving_enemy_tail_vacates_unless_eating(monkeypatch):
    for eating in (False,True):
        d=layout([(2,2)],[(4,2),(3,2)])
        d.robot_direction=(1,0)
        monkeypatch.setattr(d,'robot_turn',lambda:None)
        if eating:d.fruits.add((5,2))
        d.move(True,True)
        assert d.status==('LOST' if eating else 'RUNNING')


def test_simultaneous_same_head_and_swapped_heads_fail_player(monkeypatch):
    for player,robot in [([(2,2)],[(4,2)]), ([(2,2)],[(3,2)])]:
        d=layout(player,robot);d.robot_direction=(-1,0)
        monkeypatch.setattr(d,'robot_turn',lambda:None)
        d.move(True,True)
        assert d.status=='LOST'


def test_robot_only_crash_wins(monkeypatch):
    d=layout([(3,2),(3,3)],[(4,2)]);d.robot_direction=(-1,0)
    monkeypatch.setattr(d,'robot_turn',lambda:None)
    d.move(False,True)
    assert d.status=='LOST'  # Contact with a stationary player's head is head-on.
    d=layout([(3,3),(3,2)],[(4,2)]);d.robot_direction=(-1,0)
    monkeypatch.setattr(d,'robot_turn',lambda:None)
    d.move(False,True)
    assert d.status=='WON'


def test_input_jitter_cannot_queue_two_turns_and_reverse_before_a_move():
    d=layout([(5,5),(4,5),(3,5)])
    d.steer((0,-1));d.steer((-1,0));d.move(True,False)
    assert d.player[0]==(6,5) and d.status=='RUNNING'


def test_screen_direction_does_not_depend_on_snake_position():
    for point,direction,heading in (((-.9,.1),(-1,0),(0,1)),((.9,.1),(1,0),(0,1)),
                                    ((.1,-.9),(0,-1),(1,0)),((.1,.9),(0,1),(1,0))):
        for head in ((1,2),(35,16)):
            game=Game();game.duel.player=deque([head])
            game.duel.player_direction=game.duel.pending_direction=heading
            game.step(GameInput(0,0,True,*point,0,False))
            assert game.duel.pending_direction==direction


def test_neutral_or_missing_latest_hand_clears_unconsumed_turn():
    for valid,x,y in ((False,1,1),(True,.1,-.1)):
        game=Game();game.duel.pending_direction=(0,-1)
        game.step(GameInput(0,0,valid,x,y,0,False))
        assert game.duel.pending_direction==game.duel.player_direction==(1,0)


def test_fruit_growth_replacement_and_finite_full_board():
    d=layout([(2,2),(1,2)]);d.fruits={(3,2),(20,2),(21,2)}
    d.move(True,False)
    assert d.score==10 and len(d.player)==3 and len(d.fruits)==3
    assert not (d.fruits & (set(d.player)|set(d.robot)))
    d.player=deque((x,y) for y in range(HEIGHT) for x in range(WIDTH));d.robot=deque();d.fruits=set()
    d.refill();assert not d.fruits


def test_startup_grace_boost_and_lost_hand_neutrality():
    games=[Game(),Game()]
    for tick in range(150):
        for i,g in enumerate(games):
            g.step(GameInput(tick,tick*16_666_667,True,1.,-.3,0,False,
                             hand_gesture=HandGesture.FIST if i else HandGesture.PAPER))
        if tick==119:assert all(g.duel.moves==0 for g in games)
    assert games[1].duel.moves>games[0].duel.moves
    g=games[1];g.step(GameInput(150,150*16_666_667,False,0.,0.,0,False,hand_gesture=HandGesture.FIST))
    assert not g.duel.boosted


def test_determinism_reset_and_small_static_assets():
    a,b=Game(),Game();a.reset(GameContext(seed=123,tick_hz=60));b.reset(GameContext(seed=123,tick_hz=60))
    for tick in range(500):
        value=GameInput(tick,tick*16_666_667,True,.8 if tick%80<40 else -.8,.1,0,False)
        assert a.step(value)==b.step(value)
    assets=a.assets();compiler=SceneCompiler(sprite_atlas=assets.sprite_atlas,
        tile_atlas=assets.tile_atlas,palettes=assets.palettes)
    frame=compiler.compile(a.build_scene())
    assert len(pack_assets(frame.assets,generation=1).payload)<16000
    assert len(frame.commands)<COMMAND_CAPACITY-30
    packet=pack_tilemap_packet(frame.tilemaps[0],target_id=0,generation=1)
    assert len(packet)<8192
    assert len(CommandRenderer().render(frame))==320*180*3
    a.reset(GameContext(seed=123,tick_hz=60));assert a.duel.moves==0 and a.duel.status=='RUNNING'


def test_random_play_preserves_bounded_nonoverlapping_occupancy():
    for seed in range(80):
        r=random.Random(seed);d=Duel(random.Random(seed))
        for tick in range(1800):
            d.step(tick,r.choice(DIRECTIONS),bool(tick%3))
            assert len(d.player)==len(set(d.player))<=MAX_LENGTH
            assert len(d.robot)==len(set(d.robot))<=MAX_LENGTH
            assert not (set(d.player)&set(d.robot))
            assert not ((set(d.player)|set(d.robot))&d.fruits)
            if d.status!='RUNNING':break


def test_length_cap_keeps_fruit_scoring_without_growing_past_budget():
    body=[(x,y) for y in range(3) for x in range(32)]
    d=layout(body,robot=[(37,10)],direction=(0,-1))
    d.fruits={(0,HEIGHT-1),(20,8),(21,8)}
    d.move(True,False)
    assert d.status=='RUNNING' and len(d.player)==MAX_LENGTH
    assert d.player[0]==(0,HEIGHT-1) and d.score==10
    assert len(d.fruits)==3 and not d.fruits.intersection(set(d.player)|set(d.robot))


def test_time_limit_compares_scores_and_preserves_frozen_board():
    for player_score,robot_score,expected in ((20,10,'WON'),(10,20,'LOST'),(10,10,'DRAW')):
        d=layout([(3,2),(2,2)])
        d.score=player_score;d.robot_score=robot_score;d.tick=122*d.tick_hz-1
        d.step(d.tick+1)
        assert d.status==expected and d.reason=='TIME UP'
        before=(list(d.player),list(d.robot),set(d.fruits),d.score,d.robot_score,d.moves)
        d.step(d.tick+1,direction=(1,0),boost=True)
        assert before==(list(d.player),list(d.robot),set(d.fruits),d.score,d.robot_score,d.moves)


def test_single_snake_reaching_fruit_target_finishes_match():
    d=layout([(2,2),(1,2)])
    d.score=190;d.fruits={(3,2),(20,8),(21,8)}
    d.move(True,False)
    assert d.status=='WON' and d.reason=='FRUIT TARGET' and d.score==200
    d=layout([(2,2),(1,2)],robot=[(25,12),(26,12)])
    d.robot_score=190;d.fruits={(24,12),(20,8),(21,8)}
    d.robot_turn=lambda:None;d.robot_direction=(-1,0)
    d.move(False,True)
    assert d.status=='LOST' and d.reason=='FRUIT TARGET' and d.robot_score==200


def test_tile_atlas_obeys_frozen_rtl_power_of_two_addressing():
    game=Game();assets=game.assets();image=assets.tile_atlas
    assert image.width==128
    assert image.width//8==16
    assert (image.width//2)&(image.width//2-1)==0

