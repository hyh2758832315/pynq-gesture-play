import unittest
from dataclasses import replace

from pynq_multimodal_game.controls import (
    ControlSource,
    Direction,
    MockControlAdapter,
    MockInput,
)
from pynq_multimodal_game.game import (
    Coin,
    Enemy,
    EnemyProjectile,
    EnemySpawn,
    GameConfig,
    GameEngine,
    GameStatus,
    Obstacle,
    PlayerProjectile,
    game_state_hash,
)


def controls_for(inputs):
    adapter = MockControlAdapter(ControlSource.KEYBOARD)
    return [
        adapter.sample(item, tick_id=tick_id, timestamp_ns=tick_id * 16_666_667)
        for tick_id, item in enumerate(inputs)
    ]


class GameEngineTests(unittest.TestCase):
    def test_movement_stays_inside_world_and_lane_bounds(self) -> None:
        config = GameConfig(level_length=8, move_units_per_tick=4, lane_limit=4)
        engine = GameEngine(config)
        state = engine.run(controls_for([MockInput(left=True), MockInput(down=True)]))

        self.assertEqual(0, state.world_x)
        self.assertEqual(4, state.lane_y)

        state = engine.run(controls_for([MockInput(right=True)] * 2))
        self.assertEqual(8, state.world_x)
        self.assertEqual(GameStatus.WON, state.status)

    def test_movement_supports_asymmetric_lane_bounds(self) -> None:
        config = GameConfig(
            move_units_per_tick=4,
            min_lane_y=-4,
            max_lane_y=8,
        )
        engine = GameEngine(config)

        upward = engine.run(controls_for([MockInput(up=True)] * 3))
        downward = engine.run(controls_for([MockInput(down=True)] * 3))

        self.assertEqual(-4, upward.lane_y)
        self.assertEqual(8, downward.lane_y)

    def test_jump_only_starts_while_grounded(self) -> None:
        engine = GameEngine()
        controls = controls_for(
            [MockInput(jump=True), MockInput(), MockInput(jump=True)]
            + [MockInput()] * 40
        )
        states = []
        state = engine.initial_state()
        for control in controls:
            state = engine.step(state, control)
            states.append(state)

        self.assertEqual(engine.config.jump_velocity, states[0].z)
        self.assertLess(states[2].vz, engine.config.jump_velocity)
        self.assertTrue(states[-1].grounded)

    def test_obstacle_is_easy_to_clear_with_one_jump(self) -> None:
        obstacle = Obstacle(world_x=16, lane_y=0)
        engine = GameEngine(GameConfig(move_units_per_tick=4), obstacles=(obstacle,))

        blocked = engine.step(
            engine.initial_state(), controls_for([MockInput(right=True)])[0]
        )
        jumped = engine.step(
            engine.initial_state(),
            controls_for([MockInput(right=True, jump=True)])[0],
        )

        self.assertEqual(0, blocked.world_x)
        self.assertEqual(4, jumped.world_x)
        self.assertGreaterEqual(jumped.z, engine.config.obstacle_clearance_z)

    def test_player_can_move_out_after_landing_on_obstacle(self) -> None:
        obstacle = Obstacle(world_x=16, lane_y=0)
        engine = GameEngine(GameConfig(move_units_per_tick=4), obstacles=(obstacle,))
        state = replace(engine.initial_state(), world_x=16)
        controls = controls_for(
            [MockInput(right=True)] * 4 + [MockInput(left=True)]
        )

        for control in controls[:4]:
            state = engine.step(state, control)

        self.assertEqual(32, state.world_x)
        state = engine.step(state, controls[4])
        self.assertEqual(32, state.world_x)

    def test_shield_drains_and_recharges_energy(self) -> None:
        config = GameConfig(max_shield_energy=10, shield_drain_per_tick=2)
        engine = GameEngine(config)
        states = []
        state = engine.initial_state()
        for control in controls_for([MockInput(shield=True)] * 3 + [MockInput()] * 2):
            state = engine.step(state, control)
            states.append(state)

        self.assertTrue(states[2].shield_active)
        self.assertEqual(4, states[2].shield_energy)
        self.assertFalse(states[-1].shield_active)
        self.assertEqual(6, states[-1].shield_energy)

    def test_attack_event_respects_cooldown(self) -> None:
        config = GameConfig(attack_cooldown_ticks=3)
        engine = GameEngine(config)
        inputs = [
            MockInput(attack=True),
            MockInput(),
            MockInput(attack=True),
            MockInput(),
            MockInput(attack=True),
        ]
        state = engine.run(controls_for(inputs))

        self.assertEqual(2, state.attacks_fired)
        self.assertEqual(3, state.attack_cooldown)
        self.assertEqual(2, len(state.player_projectiles))

    def test_attack_fires_in_last_movement_direction(self) -> None:
        engine = GameEngine(GameConfig(attack_cooldown_ticks=1))
        states = []
        state = engine.initial_state()
        inputs = [
            MockInput(up=True),
            MockInput(up=True, attack=True),
            MockInput(),
        ]
        for control in controls_for(inputs):
            state = engine.step(state, control)
            states.append(state)

        projectile = states[1].player_projectiles[0]
        advanced = states[2].player_projectiles[0]
        self.assertEqual(Direction.UP, states[1].facing)
        self.assertEqual(Direction.UP, projectile.direction)
        self.assertLess(advanced.lane_y, projectile.lane_y)

    def test_projectile_reaches_lane_wall_before_removal(self) -> None:
        config = GameConfig(
            lane_limit=8,
            projectile_units_per_tick=12,
            attack_cooldown_ticks=1,
        )
        engine = GameEngine(config)
        state = engine.initial_state()
        controls = controls_for(
            [MockInput(up=True), MockInput(up=True, attack=True), MockInput(), MockInput()]
        )
        states = []
        for control in controls:
            state = engine.step(state, control)
            states.append(state)

        self.assertEqual(-20, states[2].player_projectiles[0].lane_y)
        self.assertEqual(0, len(state.player_projectiles))

    def test_obstacle_removes_player_and_enemy_projectiles(self) -> None:
        obstacle = Obstacle(world_x=16, lane_y=0)
        engine = GameEngine(obstacles=(obstacle,))
        state = replace(
            engine.initial_state(),
            player_projectiles=(PlayerProjectile(0, 0, Direction.RIGHT, 10),),
            enemy_projectiles=(EnemyProjectile(22, 0, 10),),
        )

        state = engine.step(state, controls_for([MockInput()])[0])

        self.assertEqual((), state.player_projectiles)
        self.assertEqual((), state.enemy_projectiles)

    def test_enemy_spawns_beyond_right_edge_and_only_moves_left(self) -> None:
        config = GameConfig(enemy_initial_shoot_delay_ticks=10)
        engine = GameEngine(config, enemy_spawns=(EnemySpawn(0, 8),))

        state = engine.step(engine.initial_state(), controls_for([MockInput()])[0])

        self.assertGreater(state.enemies[0].world_x, config.viewport_width)
        self.assertEqual(8, state.enemies[0].lane_y)

        next_state = engine.step(state, controls_for([MockInput(), MockInput()])[1])
        self.assertLess(next_state.enemies[0].world_x, state.enemies[0].world_x)
        self.assertEqual(state.enemies[0].lane_y, next_state.enemies[0].lane_y)

    def test_enemy_shoots_left_on_cooldown(self) -> None:
        config = GameConfig(enemy_shoot_cooldown_ticks=5)
        engine = GameEngine(config)
        state = replace(
            engine.initial_state(), enemies=(Enemy(100, 8, shoot_cooldown=1),)
        )

        state = engine.step(state, controls_for([MockInput()])[0])

        self.assertEqual(99, state.enemies[0].world_x)
        self.assertEqual(5, state.enemies[0].shoot_cooldown)
        self.assertEqual(99, state.enemy_projectiles[0].world_x)
        self.assertEqual(8, state.enemy_projectiles[0].lane_y)

    def test_enemy_disappears_when_it_hits_an_obstacle(self) -> None:
        obstacle = Obstacle(16, 8)
        engine = GameEngine(obstacles=(obstacle,))
        state = replace(
            engine.initial_state(), enemies=(Enemy(32, 8, shoot_cooldown=10),)
        )

        state = engine.step(state, controls_for([MockInput()])[0])

        self.assertEqual((), state.enemies)

    def test_player_projectile_defeats_one_enemy_and_scores_five(self) -> None:
        engine = GameEngine(GameConfig(enemy_score=5))
        state = replace(
            engine.initial_state(),
            player_projectiles=(PlayerProjectile(84, 8, Direction.RIGHT, 10),),
            enemies=(
                Enemy(99, 8, shoot_cooldown=10),
                Enemy(99, 8, shoot_cooldown=10),
            ),
        )

        state = engine.step(state, controls_for([MockInput()])[0])

        self.assertEqual(5, state.score)
        self.assertEqual(1, len(state.enemies))
        self.assertEqual((), state.player_projectiles)

    def test_coin_is_collected_once_and_scores_ten(self) -> None:
        engine = GameEngine(coins=(Coin(4, 0),))

        state = engine.step(engine.initial_state(), controls_for([MockInput()])[0])
        state = engine.step(state, controls_for([MockInput(), MockInput()])[1])

        self.assertEqual(10, state.score)
        self.assertEqual((), state.coins)

    def test_player_damage_shield_and_invulnerability(self) -> None:
        config = GameConfig(hit_invulnerability_ticks=30)
        engine = GameEngine(config)
        first_hit = replace(
            engine.initial_state(), enemy_projectiles=(EnemyProjectile(0, 0, 10),)
        )
        first_hit = engine.step(first_hit, controls_for([MockInput()])[0])
        immune_hit = replace(
            first_hit, enemy_projectiles=(EnemyProjectile(0, 0, 10),)
        )
        immune_hit = engine.step(
            immune_hit, controls_for([MockInput(), MockInput()])[1]
        )
        shielded = replace(
            engine.initial_state(), enemy_projectiles=(EnemyProjectile(0, 0, 10),)
        )
        shielded = engine.step(
            shielded, controls_for([MockInput(shield=True)])[0]
        )

        self.assertEqual(config.max_health - 1, first_hit.health)
        self.assertEqual(30, first_hit.invulnerability_ticks)
        self.assertEqual(first_hit.health, immune_hit.health)
        self.assertEqual(config.max_health, shielded.health)

    def test_jump_avoids_enemy_projectile(self) -> None:
        engine = GameEngine()
        airborne = replace(
            engine.initial_state(), enemy_projectiles=(EnemyProjectile(6, 0, 10),)
        )
        grounded = replace(
            engine.initial_state(), enemy_projectiles=(EnemyProjectile(6, 0, 10),)
        )
        controls = controls_for([MockInput(jump=True)])

        airborne = engine.step(airborne, controls[0])
        grounded = engine.step(grounded, controls_for([MockInput()])[0])

        self.assertGreaterEqual(airborne.z, engine.config.obstacle_clearance_z)
        self.assertEqual(engine.config.max_health, airborne.health)
        self.assertEqual(1, len(airborne.enemy_projectiles))
        self.assertEqual(engine.config.max_health - 1, grounded.health)

    def test_entity_simulation_remains_deterministic(self) -> None:
        config = GameConfig(enemy_initial_shoot_delay_ticks=3)
        obstacles = (Obstacle(160, -24),)
        spawns = (EnemySpawn(8, 8),)
        coins = (Coin(20, 0),)
        inputs = [MockInput(right=True)] * 20

        first = GameEngine(
            config, obstacles=obstacles, enemy_spawns=spawns, coins=coins
        ).run(controls_for(inputs))
        second = GameEngine(
            config, obstacles=obstacles, enemy_spawns=spawns, coins=coins
        ).run(controls_for(inputs))

        self.assertEqual(first, second)
        self.assertEqual(game_state_hash(first), game_state_hash(second))

    def test_same_control_sequence_has_same_final_hash(self) -> None:
        inputs = (
            [MockInput(right=True)] * 15
            + [MockInput(right=True, jump=True), MockInput(right=True)]
            + [MockInput(shield=True)] * 8
            + [MockInput(attack=True), MockInput()]
        )
        first = GameEngine().run(controls_for(inputs))
        second = GameEngine().run(controls_for(inputs))

        self.assertEqual(first, second)
        self.assertEqual(game_state_hash(first), game_state_hash(second))

    def test_rejects_skipped_ticks(self) -> None:
        engine = GameEngine()
        control = MockControlAdapter(ControlSource.KEYBOARD).sample(
            MockInput(), tick_id=1, timestamp_ns=0
        )

        with self.assertRaises(ValueError):
            engine.step(engine.initial_state(), control)


if __name__ == "__main__":
    unittest.main()