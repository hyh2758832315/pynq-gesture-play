from dataclasses import replace
import unittest

from pynq_multimodal_game.controls import ControlSource, Direction, MockControlAdapter, MockInput
from pynq_multimodal_game.demo import (
    ARENA_WIDTH,
    COIN_ATLAS_X,
    ENEMY_ATLAS_X,
    ENEMY_PROJECTILE_ATLAS_X,
    LANE_POSITIONS,
    MAX_VISIBLE_COINS,
    MAX_VISIBLE_ENEMIES,
    MAX_VISIBLE_ENEMY_PROJECTILES,
    MAX_VISIBLE_OBSTACLES,
    MAX_VISIBLE_PLAYER_PROJECTILES,
    OBSTACLE_ATLAS_X,
    PLAYER_WIDTH,
    PLAYER_ATLAS_X,
    PLAYER_LANE_MAX,
    PLAYER_LANE_MIN,
    PROJECTILE_ATLAS_X,
    build_demo_scene,
    create_demo_assets,
    create_demo_engine,
)
from pynq_multimodal_game.game import (
    Coin,
    Enemy,
    EnemyProjectile,
    GameConfig,
    GameEngine,
    Obstacle,
    PlayerProjectile,
)
from pynq_multimodal_game.scene import LOGICAL_HEIGHT, LOGICAL_WIDTH, MAX_SPRITES


class DemoSceneTests(unittest.TestCase):
    def test_demo_lane_bounds_match_wall_inner_edges(self) -> None:
        self.assertEqual(-56, PLAYER_LANE_MIN)
        self.assertEqual(72, PLAYER_LANE_MAX)

    def test_demo_level_ends_at_map_right_edge(self) -> None:
        self.assertEqual(1024, ARENA_WIDTH)
        self.assertEqual(1008, ARENA_WIDTH - PLAYER_WIDTH)

    def test_demo_entities_use_five_evenly_spaced_lanes(self) -> None:
        state = create_demo_engine().initial_state()

        self.assertEqual((-56, -24, 8, 40, 72), LANE_POSITIONS)
        self.assertEqual(9, len(state.obstacles))
        self.assertEqual(11, len(state.pending_enemy_spawns))
        self.assertEqual(12, len(state.coins))
        for entities in (state.obstacles, state.pending_enemy_spawns, state.coins):
            self.assertTrue(entities)
            self.assertTrue(all(entity.lane_y in LANE_POSITIONS for entity in entities))

    def test_demo_enemies_attack_more_frequently(self) -> None:
        config = create_demo_engine().config

        self.assertEqual(15, config.enemy_initial_shoot_delay_ticks)
        self.assertEqual(45, config.enemy_shoot_cooldown_ticks)

    def test_demo_scene_renders_at_logical_resolution(self) -> None:
        config = GameConfig(level_length=960, move_units_per_tick=8)
        engine = GameEngine(config)
        adapter = MockControlAdapter(ControlSource.KEYBOARD)
        state = engine.initial_state()
        controls = (
            adapter.sample(MockInput(up=True), tick_id=0, timestamp_ns=0),
            adapter.sample(MockInput(up=True, attack=True), tick_id=1, timestamp_ns=1),
        )
        for control in controls:
            state = engine.step(state, control)
        assets = create_demo_assets()

        scene = build_demo_scene(state, config, assets)
        frame = assets.renderer.render(scene)

        self.assertEqual(1, scene.frame_id)
        self.assertEqual(Direction.UP, state.facing)
        self.assertEqual(1, len(state.player_projectiles))
        self.assertGreaterEqual(len(scene.sprites), 3)
        self.assertEqual(LOGICAL_WIDTH * LOGICAL_HEIGHT * 3, len(frame))
        self.assertNotEqual((37, 58, 94) * (LOGICAL_WIDTH * LOGICAL_HEIGHT), frame)

    def test_camera_transform_is_applied_once(self) -> None:
        config = GameConfig(level_length=960, move_units_per_tick=4, lane_limit=56)
        engine = GameEngine(config)
        adapter = MockControlAdapter(ControlSource.KEYBOARD)
        state = engine.initial_state()
        for tick_id in range(30):
            control = adapter.sample(
                MockInput(right=True), tick_id=tick_id, timestamp_ns=tick_id
            )
            state = engine.step(state, control)

        scene = build_demo_scene(state, config, create_demo_assets())
        player = scene.sprites[1]

        self.assertGreater(scene.camera_x, 0)
        self.assertEqual(112, player.x - scene.camera_x)

    def test_scene_respects_sprite_budgets_and_invulnerability_blink(self) -> None:
        engine = create_demo_engine()
        config = engine.config
        state = replace(
            engine.initial_state(),
            tick_id=4,
            world_x=120,
            shield_active=True,
            invulnerability_ticks=10,
            obstacles=tuple(Obstacle(120 + index, 8) for index in range(5)),
            coins=tuple(Coin(120 + index, 8) for index in range(5)),
            enemies=tuple(Enemy(120 + index, 8, 30) for index in range(5)),
            enemy_projectiles=tuple(
                EnemyProjectile(120 + index, 8, 30) for index in range(5)
            ),
            player_projectiles=tuple(
                PlayerProjectile(120 + index, 8, Direction.RIGHT, 30)
                for index in range(5)
            ),
        )

        scene = build_demo_scene(state, config, create_demo_assets())
        atlas_counts = {
            atlas_x: sum(sprite.atlas_x == atlas_x for sprite in scene.sprites)
            for atlas_x in (
                OBSTACLE_ATLAS_X,
                COIN_ATLAS_X,
                ENEMY_ATLAS_X,
                ENEMY_PROJECTILE_ATLAS_X,
                PROJECTILE_ATLAS_X[Direction.RIGHT],
            )
        }

        self.assertEqual(MAX_SPRITES, len(scene.sprites))
        self.assertEqual(MAX_VISIBLE_OBSTACLES, atlas_counts[OBSTACLE_ATLAS_X])
        self.assertEqual(MAX_VISIBLE_COINS, atlas_counts[COIN_ATLAS_X])
        self.assertEqual(MAX_VISIBLE_ENEMIES, atlas_counts[ENEMY_ATLAS_X])
        self.assertEqual(
            MAX_VISIBLE_ENEMY_PROJECTILES,
            atlas_counts[ENEMY_PROJECTILE_ATLAS_X],
        )
        self.assertEqual(
            MAX_VISIBLE_PLAYER_PROJECTILES,
            atlas_counts[PROJECTILE_ATLAS_X[Direction.RIGHT]],
        )
        player = next(
            sprite
            for sprite in scene.sprites
            if sprite.atlas_x == PLAYER_ATLAS_X[Direction.RIGHT]
        )
        self.assertFalse(player.visible)

        visible_scene = build_demo_scene(replace(state, tick_id=8), config, create_demo_assets())
        visible_player = next(
            sprite
            for sprite in visible_scene.sprites
            if sprite.atlas_x == PLAYER_ATLAS_X[Direction.RIGHT]
        )
        self.assertTrue(visible_player.visible)

    def test_camera_stops_with_player_at_level_right_edge(self) -> None:
        engine = create_demo_engine()
        state = replace(
            engine.initial_state(),
            tick_id=0,
            world_x=engine.config.level_length,
        )

        scene = build_demo_scene(state, engine.config, create_demo_assets())

        self.assertEqual(LOGICAL_WIDTH - PLAYER_WIDTH, state.world_x - scene.camera_x)


if __name__ == "__main__":
    unittest.main()