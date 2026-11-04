from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass, fields, replace
from enum import Enum
from functools import cached_property
from typing import Iterable

from ..controls import Direction


class GameStatus(str, Enum):
    RUNNING = "RUNNING"
    WON = "WON"
    LOST = "LOST"


@dataclass(frozen=True)
class SideScrollerCommand:
    tick_id: int
    direction: Direction = Direction.IDLE
    jump: bool = False
    shield: bool = False
    attack: bool = False

    def __post_init__(self) -> None:
        if self.tick_id < 0:
            raise ValueError("tick_id must be non-negative")


@dataclass(frozen=True)
class PlayerProjectile:
    world_x: int
    lane_y: int
    direction: Direction
    remaining_ticks: int


@dataclass(frozen=True)
class Obstacle:
    world_x: int
    lane_y: int


@dataclass(frozen=True)
class EnemySpawn:
    trigger_x: int
    lane_y: int


@dataclass(frozen=True)
class Enemy:
    world_x: int
    lane_y: int
    shoot_cooldown: int


@dataclass(frozen=True)
class EnemyProjectile:
    world_x: int
    lane_y: int
    remaining_ticks: int


@dataclass(frozen=True)
class Coin:
    world_x: int
    lane_y: int
    value: int = 10


@dataclass(frozen=True)
class StepEffects:
    tick_id: int
    fire_requested: bool
    fire_spawned: bool
    fire_capacity_rejected: bool
    fire_surviving: bool
    guard_applied: bool


@dataclass(frozen=True)
class GameConfig:
    ticks_per_second: int = 60
    level_length: int = 2400
    move_units_per_tick: int = 4
    lane_limit: int = 72
    min_lane_y: int | None = None
    max_lane_y: int | None = None
    jump_velocity: int = 18
    gravity_per_tick: int = 1
    max_health: int = 3
    max_shield_energy: int = 300
    shield_drain_per_tick: int = 2
    shield_recharge_per_tick: int = 1
    attack_cooldown_ticks: int = 30
    projectile_units_per_tick: int = 12
    projectile_lifetime_ticks: int = 60
    max_player_projectiles: int = 8
    player_size: int = 16
    obstacle_size: int = 16
    obstacle_clearance_z: int = 8
    enemy_size: int = 16
    enemy_units_per_tick: int = 1
    enemy_shoot_cooldown_ticks: int = 90
    enemy_initial_shoot_delay_ticks: int = 30
    enemy_projectile_units_per_tick: int = 6
    enemy_projectile_lifetime_ticks: int = 120
    max_enemy_projectiles: int = 2
    projectile_size: int = 8
    coin_size: int = 8
    enemy_score: int = 5
    hit_invulnerability_ticks: int = 30
    viewport_width: int = 320
    camera_follow_x: int = 112
    enemy_spawn_margin: int = 16
    action_mode: str = "legacy_energy"

    def __post_init__(self) -> None:
        if self.action_mode not in ("legacy_energy", "policy_timed"):
            raise ValueError("unsupported action mode")
        positive_fields = (
            "ticks_per_second",
            "level_length",
            "move_units_per_tick",
            "lane_limit",
            "jump_velocity",
            "gravity_per_tick",
            "max_health",
            "max_shield_energy",
            "shield_drain_per_tick",
            "shield_recharge_per_tick",
            "attack_cooldown_ticks",
            "projectile_units_per_tick",
            "projectile_lifetime_ticks",
            "max_player_projectiles",
            "player_size",
            "obstacle_size",
            "obstacle_clearance_z",
            "enemy_size",
            "enemy_units_per_tick",
            "enemy_shoot_cooldown_ticks",
            "enemy_initial_shoot_delay_ticks",
            "enemy_projectile_units_per_tick",
            "enemy_projectile_lifetime_ticks",
            "max_enemy_projectiles",
            "projectile_size",
            "coin_size",
            "enemy_score",
            "hit_invulnerability_ticks",
            "viewport_width",
            "camera_follow_x",
            "enemy_spawn_margin",
        )
        if any(getattr(self, name) <= 0 for name in positive_fields):
            raise ValueError("game configuration values must be positive")
        if self.resolved_min_lane_y > self.resolved_max_lane_y:
            raise ValueError("min_lane_y must not exceed max_lane_y")
        if not self.resolved_min_lane_y <= 0 <= self.resolved_max_lane_y:
            raise ValueError("lane bounds must include the initial lane")

    @property
    def resolved_min_lane_y(self) -> int:
        return -self.lane_limit if self.min_lane_y is None else self.min_lane_y

    @property
    def resolved_max_lane_y(self) -> int:
        return self.lane_limit if self.max_lane_y is None else self.max_lane_y


@dataclass(frozen=True)
class GameState:
    tick_id: int
    world_x: int
    lane_y: int
    z: int
    vz: int
    health: int
    score: int
    shield_energy: int
    shield_active: bool
    attack_cooldown: int
    attacks_fired: int
    facing: Direction
    player_projectiles: tuple[PlayerProjectile, ...]
    status: GameStatus
    obstacles: tuple[Obstacle, ...] = ()
    pending_enemy_spawns: tuple[EnemySpawn, ...] = ()
    enemies: tuple[Enemy, ...] = ()
    enemy_projectiles: tuple[EnemyProjectile, ...] = ()
    coins: tuple[Coin, ...] = ()
    invulnerability_ticks: int = 0

    @property
    def grounded(self) -> bool:
        return self.z == 0

    @cached_property
    def _canonical_hash(self) -> str | None:
        return _compute_state_hash(self) if _hash_stable(self) else None


class GameEngine:
    def __init__(
        self,
        config: GameConfig | None = None,
        *,
        obstacles: Iterable[Obstacle] = (),
        enemy_spawns: Iterable[EnemySpawn] = (),
        coins: Iterable[Coin] = (),
    ) -> None:
        self.config = config or GameConfig()
        self.obstacles = tuple(obstacles)
        self.enemy_spawns = tuple(enemy_spawns)
        self.coins = tuple(coins)
        self.last_effects: StepEffects | None = None

    def initial_state(self) -> GameState:
        self.last_effects = None
        return GameState(
            tick_id=-1,
            world_x=0,
            lane_y=0,
            z=0,
            vz=0,
            health=self.config.max_health,
            score=0,
            shield_energy=self.config.max_shield_energy,
            shield_active=False,
            attack_cooldown=0,
            attacks_fired=0,
            facing=Direction.RIGHT,
            player_projectiles=(),
            status=GameStatus.RUNNING,
            obstacles=self.obstacles,
            pending_enemy_spawns=self.enemy_spawns,
            enemies=(),
            enemy_projectiles=(),
            coins=self.coins,
            invulnerability_ticks=0,
        )

    def step(self, state: GameState, control: SideScrollerCommand) -> GameState:
        if control.tick_id != state.tick_id + 1:
            raise ValueError("control ticks must be contiguous")
        if state.status is not GameStatus.RUNNING:
            self.last_effects = StepEffects(control.tick_id, False, False, False, False, False)
            return replace(state, tick_id=control.tick_id)

        z, vz = self._jump(state, control.jump)
        world_x, lane_y = self._move(state, control.direction)
        landed_on_obstacle = self._actor_hits_obstacle(
            state.world_x, state.lane_y, state.obstacles
        )
        if (
            z < self.config.obstacle_clearance_z
            and not landed_on_obstacle
            and self._actor_hits_obstacle(world_x, lane_y, state.obstacles)
        ):
            world_x, lane_y = state.world_x, state.lane_y
        facing = control.direction if control.direction is not Direction.IDLE else state.facing
        timed = self.config.action_mode == "policy_timed"
        shield_energy, shield_active = (state.shield_energy, control.shield) if timed else self._shield(state, control.shield)
        attack_cooldown = 0 if timed else max(0, state.attack_cooldown - 1)
        invulnerability_ticks = max(0, state.invulnerability_ticks - 1)
        attacks_fired = state.attacks_fired
        projectiles = self._advance_projectiles(state.player_projectiles)
        enemy_projectiles = self._advance_enemy_projectiles(
            state.enemy_projectiles, state.obstacles
        )
        pending_enemy_spawns, enemies = self._spawn_enemies(
            world_x, state.pending_enemy_spawns, state.enemies
        )
        enemies, enemy_projectiles = self._advance_enemies(
            enemies, enemy_projectiles, state.obstacles
        )

        spawned = None
        capacity_rejected = False
        if control.attack and attack_cooldown == 0:
            attacks_fired += 1
            attack_cooldown = 0 if timed else self.config.attack_cooldown_ticks
            if len(projectiles) < self.config.max_player_projectiles:
                spawned = PlayerProjectile(
                        world_x=world_x,
                        lane_y=lane_y,
                        direction=facing,
                        remaining_ticks=self.config.projectile_lifetime_ticks,
                    )
                projectiles += (spawned,)
            else:
                capacity_rejected = True

        projectiles = tuple(
            projectile
            for projectile in projectiles
            if not self._projectile_hits_obstacle(projectile, state.obstacles)
        )
        projectiles, enemies, enemy_score = self._hit_enemies(projectiles, enemies)
        health, invulnerability_ticks, enemies, enemy_projectiles = self._hit_player(
            world_x,
            lane_y,
            z,
            shield_active,
            invulnerability_ticks,
            state.health,
            enemies,
            enemy_projectiles,
        )
        coins, coin_score = self._collect_coins(world_x, lane_y, state.coins)
        score = state.score + enemy_score + coin_score
        if health <= 0:
            status = GameStatus.LOST
        elif world_x >= self.config.level_length:
            status = GameStatus.WON
        else:
            status = state.status
        self.last_effects = StepEffects(control.tick_id, control.attack, spawned is not None,
                                        capacity_rejected, any(item is spawned for item in projectiles), shield_active)
        return GameState(
            tick_id=control.tick_id,
            world_x=world_x,
            lane_y=lane_y,
            z=z,
            vz=vz,
            health=health,
            score=score,
            shield_energy=shield_energy,
            shield_active=shield_active,
            attack_cooldown=attack_cooldown,
            attacks_fired=attacks_fired,
            facing=facing,
            player_projectiles=projectiles,
            status=status,
            obstacles=state.obstacles,
            pending_enemy_spawns=pending_enemy_spawns,
            enemies=enemies,
            enemy_projectiles=enemy_projectiles,
            coins=coins,
            invulnerability_ticks=invulnerability_ticks,
        )

    def run(self, controls: Iterable[SideScrollerCommand]) -> GameState:
        state = self.initial_state()
        for control in controls:
            state = self.step(state, control)
        return state

    def _move(self, state: GameState, direction: Direction) -> tuple[int, int]:
        world_x = state.world_x
        lane_y = state.lane_y
        if direction is Direction.LEFT:
            world_x -= self.config.move_units_per_tick
        elif direction is Direction.RIGHT:
            world_x += self.config.move_units_per_tick
        elif direction is Direction.UP:
            lane_y -= self.config.move_units_per_tick
        elif direction is Direction.DOWN:
            lane_y += self.config.move_units_per_tick

        world_x = min(self.config.level_length, max(0, world_x))
        lane_y = min(
            self.config.resolved_max_lane_y,
            max(self.config.resolved_min_lane_y, lane_y),
        )
        return world_x, lane_y

    def _jump(self, state: GameState, fist_event: bool) -> tuple[int, int]:
        vz = self.config.jump_velocity if fist_event and state.grounded else state.vz
        z = state.z + vz
        vz -= self.config.gravity_per_tick
        if z <= 0:
            return 0, 0
        return z, vz

    def _shield(self, state: GameState, requested: bool) -> tuple[int, bool]:
        if requested and state.shield_energy > 0:
            energy = max(0, state.shield_energy - self.config.shield_drain_per_tick)
            return energy, True
        energy = min(
            self.config.max_shield_energy,
            state.shield_energy + self.config.shield_recharge_per_tick,
        )
        return energy, False

    def _advance_projectiles(
        self, projectiles: tuple[PlayerProjectile, ...]
    ) -> tuple[PlayerProjectile, ...]:
        active = []
        projectile_min_lane_y = (
            self.config.resolved_min_lane_y - self.config.projectile_units_per_tick
        )
        projectile_max_lane_y = (
            self.config.resolved_max_lane_y + self.config.projectile_units_per_tick
        )
        for projectile in projectiles:
            world_x = projectile.world_x
            lane_y = projectile.lane_y
            if projectile.direction is Direction.LEFT:
                world_x -= self.config.projectile_units_per_tick
            elif projectile.direction is Direction.RIGHT:
                world_x += self.config.projectile_units_per_tick
            elif projectile.direction is Direction.UP:
                lane_y -= self.config.projectile_units_per_tick
            elif projectile.direction is Direction.DOWN:
                lane_y += self.config.projectile_units_per_tick
            remaining_ticks = projectile.remaining_ticks - 1
            if (
                remaining_ticks > 0
                and 0 <= world_x <= self.config.level_length
                and projectile_min_lane_y <= lane_y <= projectile_max_lane_y
            ):
                active.append(
                    PlayerProjectile(
                        world_x=world_x,
                        lane_y=lane_y,
                        direction=projectile.direction,
                        remaining_ticks=remaining_ticks,
                    )
                )
        return tuple(active)

    def _advance_enemy_projectiles(
        self,
        projectiles: tuple[EnemyProjectile, ...],
        obstacles: tuple[Obstacle, ...],
    ) -> tuple[EnemyProjectile, ...]:
        active = []
        for projectile in projectiles:
            advanced = EnemyProjectile(
                world_x=projectile.world_x
                - self.config.enemy_projectile_units_per_tick,
                lane_y=projectile.lane_y,
                remaining_ticks=projectile.remaining_ticks - 1,
            )
            if (
                advanced.remaining_ticks > 0
                and advanced.world_x >= -self.config.projectile_size
                and not self._enemy_projectile_hits_obstacle(advanced, obstacles)
            ):
                active.append(advanced)
        return tuple(active)

    def _spawn_enemies(
        self,
        player_x: int,
        pending: tuple[EnemySpawn, ...],
        enemies: tuple[Enemy, ...],
    ) -> tuple[tuple[EnemySpawn, ...], tuple[Enemy, ...]]:
        waiting = []
        spawned = list(enemies)
        camera_x = max(0, player_x - self.config.camera_follow_x)
        spawn_x = camera_x + self.config.viewport_width + self.config.enemy_spawn_margin
        for enemy_spawn in pending:
            if enemy_spawn.trigger_x <= player_x:
                spawned.append(
                    Enemy(
                        world_x=spawn_x,
                        lane_y=enemy_spawn.lane_y,
                        shoot_cooldown=self.config.enemy_initial_shoot_delay_ticks,
                    )
                )
            else:
                waiting.append(enemy_spawn)
        return tuple(waiting), tuple(spawned)

    def _advance_enemies(
        self,
        enemies: tuple[Enemy, ...],
        projectiles: tuple[EnemyProjectile, ...],
        obstacles: tuple[Obstacle, ...],
    ) -> tuple[tuple[Enemy, ...], tuple[EnemyProjectile, ...]]:
        active = []
        shots = list(projectiles)
        for enemy in enemies:
            world_x = enemy.world_x - self.config.enemy_units_per_tick
            if world_x < -self.config.enemy_size or self._enemy_hits_obstacle(
                world_x, enemy.lane_y, obstacles
            ):
                continue
            shoot_cooldown = max(0, enemy.shoot_cooldown - 1)
            if shoot_cooldown == 0 and len(shots) < self.config.max_enemy_projectiles:
                shots.append(
                    EnemyProjectile(
                        world_x=world_x,
                        lane_y=enemy.lane_y,
                        remaining_ticks=self.config.enemy_projectile_lifetime_ticks,
                    )
                )
                shoot_cooldown = self.config.enemy_shoot_cooldown_ticks
            active.append(
                Enemy(
                    world_x=world_x,
                    lane_y=enemy.lane_y,
                    shoot_cooldown=shoot_cooldown,
                )
            )
        return tuple(active), tuple(shots)

    def _hit_enemies(
        self,
        projectiles: tuple[PlayerProjectile, ...],
        enemies: tuple[Enemy, ...],
    ) -> tuple[tuple[PlayerProjectile, ...], tuple[Enemy, ...], int]:
        defeated: set[int] = set()
        surviving_projectiles = []
        score = 0
        for projectile in projectiles:
            target = next(
                (
                    index
                    for index, enemy in enumerate(enemies)
                    if index not in defeated
                    and self._intersects(
                        self._projectile_rect(projectile), self._enemy_rect(enemy)
                    )
                ),
                None,
            )
            if target is None:
                surviving_projectiles.append(projectile)
            else:
                defeated.add(target)
                score += self.config.enemy_score
        surviving_enemies = tuple(
            enemy for index, enemy in enumerate(enemies) if index not in defeated
        )
        return tuple(surviving_projectiles), surviving_enemies, score

    def _hit_player(
        self,
        world_x: int,
        lane_y: int,
        z: int,
        shield_active: bool,
        invulnerability_ticks: int,
        health: int,
        enemies: tuple[Enemy, ...],
        projectiles: tuple[EnemyProjectile, ...],
    ) -> tuple[int, int, tuple[Enemy, ...], tuple[EnemyProjectile, ...]]:
        player_rect = self._actor_rect(world_x, lane_y, self.config.player_size)
        surviving_enemies = tuple(
            enemy
            for enemy in enemies
            if not self._intersects(player_rect, self._enemy_rect(enemy))
        )
        surviving_projectiles = tuple(
            projectile
            for projectile in projectiles
            if not (
                z < self.config.obstacle_clearance_z
                and self._intersects(
                    player_rect, self._enemy_projectile_rect(projectile)
                )
            )
        )
        hit = len(surviving_enemies) != len(enemies) or len(
            surviving_projectiles
        ) != len(projectiles)
        if hit and not shield_active and invulnerability_ticks == 0:
            return (
                max(0, health - 1),
                self.config.hit_invulnerability_ticks,
                surviving_enemies,
                surviving_projectiles,
            )
        return health, invulnerability_ticks, surviving_enemies, surviving_projectiles

    def _collect_coins(
        self, world_x: int, lane_y: int, coins: tuple[Coin, ...]
    ) -> tuple[tuple[Coin, ...], int]:
        player_rect = self._actor_rect(world_x, lane_y, self.config.player_size)
        remaining = []
        score = 0
        for coin in coins:
            if self._intersects(player_rect, self._coin_rect(coin)):
                score += coin.value
            else:
                remaining.append(coin)
        return tuple(remaining), score

    def _actor_hits_obstacle(
        self, world_x: int, lane_y: int, obstacles: tuple[Obstacle, ...]
    ) -> bool:
        actor = self._actor_rect(world_x, lane_y, self.config.player_size)
        return any(
            self._intersects(actor, self._obstacle_rect(obstacle))
            for obstacle in obstacles
        )

    def _enemy_hits_obstacle(
        self, world_x: int, lane_y: int, obstacles: tuple[Obstacle, ...]
    ) -> bool:
        actor = self._actor_rect(world_x, lane_y, self.config.enemy_size)
        return any(
            self._intersects(actor, self._obstacle_rect(obstacle))
            for obstacle in obstacles
        )

    def _projectile_hits_obstacle(
        self, projectile: PlayerProjectile, obstacles: tuple[Obstacle, ...]
    ) -> bool:
        return any(
            self._intersects(
                self._projectile_rect(projectile), self._obstacle_rect(obstacle)
            )
            for obstacle in obstacles
        )

    def _enemy_projectile_hits_obstacle(
        self, projectile: EnemyProjectile, obstacles: tuple[Obstacle, ...]
    ) -> bool:
        return any(
            self._intersects(
                self._enemy_projectile_rect(projectile),
                self._obstacle_rect(obstacle),
            )
            for obstacle in obstacles
        )

    def _obstacle_rect(self, obstacle: Obstacle) -> tuple[int, int, int, int]:
        return self._actor_rect(
            obstacle.world_x, obstacle.lane_y, self.config.obstacle_size
        )

    def _enemy_rect(self, enemy: Enemy) -> tuple[int, int, int, int]:
        return self._actor_rect(enemy.world_x, enemy.lane_y, self.config.enemy_size)

    def _projectile_rect(
        self, projectile: PlayerProjectile
    ) -> tuple[int, int, int, int]:
        offset = (self.config.player_size - self.config.projectile_size) // 2
        return (
            projectile.world_x + offset,
            projectile.lane_y - self.config.projectile_size // 2,
            self.config.projectile_size,
            self.config.projectile_size,
        )

    def _enemy_projectile_rect(
        self, projectile: EnemyProjectile
    ) -> tuple[int, int, int, int]:
        offset = (self.config.enemy_size - self.config.projectile_size) // 2
        return (
            projectile.world_x + offset,
            projectile.lane_y - self.config.projectile_size // 2,
            self.config.projectile_size,
            self.config.projectile_size,
        )

    def _coin_rect(self, coin: Coin) -> tuple[int, int, int, int]:
        offset = (self.config.player_size - self.config.coin_size) // 2
        return (
            coin.world_x + offset,
            coin.lane_y - self.config.coin_size // 2,
            self.config.coin_size,
            self.config.coin_size,
        )

    @staticmethod
    def _actor_rect(world_x: int, lane_y: int, size: int) -> tuple[int, int, int, int]:
        return world_x, lane_y - size // 2, size, size

    @staticmethod
    def _intersects(
        first: tuple[int, int, int, int], second: tuple[int, int, int, int]
    ) -> bool:
        first_x, first_y, first_width, first_height = first
        second_x, second_y, second_width, second_height = second
        return (
            first_x < second_x + second_width
            and first_x + first_width > second_x
            and first_y < second_y + second_height
            and first_y + first_height > second_y
        )


def _hash_stable(record) -> bool:
    if isinstance(record, (str, int, bool)):
        return True
    if type(record) is tuple:
        return all(_hash_stable(value) for value in record)
    if type(record) in (GameState, PlayerProjectile, Obstacle, EnemySpawn, Enemy, EnemyProjectile, Coin):
        return all(_hash_stable(getattr(record, field.name)) for field in fields(record))
    return False


def _compute_state_hash(state: GameState) -> str:
    payload = {field.name: getattr(state, field.name) for field in fields(state)}
    payload["status"] = state.status.value
    encoded = json.dumps(payload, sort_keys=True, separators=(",", ":"), default=lambda record: {
        field.name: getattr(record, field.name) for field in fields(record)
    }).encode("ascii")
    return hashlib.sha256(encoded).hexdigest()


def game_state_hash(state: GameState) -> str:
    return state._canonical_hash or _compute_state_hash(state)


SideScrollerConfig = GameConfig
SideScrollerEngine = GameEngine
SideScrollerState = GameState
SideScrollerStatus = GameStatus