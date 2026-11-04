from pynq_multimodal_game.controls import Direction
from pynq_multimodal_game.engine.side_scroller import (
    SideScrollerCommand,
    SideScrollerConfig,
    SideScrollerEngine,
    SideScrollerStatus,
    game_state_hash,
)


def test_state_hash_matches_original_deep_asdict_for_nested_states():
    from dataclasses import asdict, replace
    import hashlib
    import json
    from pynq_multimodal_game.engine.side_scroller import (
        Coin, Enemy, EnemyProjectile, EnemySpawn, Obstacle, PlayerProjectile,
    )
    initial = SideScrollerEngine().initial_state()
    directions, statuses = tuple(Direction), tuple(SideScrollerStatus)
    for index in range(200):
        state = replace(initial, tick_id=index, world_x=index*4, z=index % 20,
            vz=10-index % 21, score=index*10, health=index % 4,
            shield_active=bool(index % 2), shield_energy=index % 301,
            facing=directions[index % len(directions)], status=statuses[index % len(statuses)],
            player_projectiles=tuple(PlayerProjectile(index+offset, offset-4,
                directions[offset % len(directions)], 60-offset) for offset in range(index % 8)),
            obstacles=tuple(Obstacle(index+offset*10, offset) for offset in range(index % 13)),
            pending_enemy_spawns=(EnemySpawn(index+30, -4),),
            enemies=(Enemy(index+40, 4, index % 90),),
            enemy_projectiles=(EnemyProjectile(index+10, -2, index % 120),),
            coins=(Coin(index+20, 3, index % 100),), invulnerability_ticks=index % 30)
        payload = asdict(state)
        payload["status"] = state.status.value
        expected = hashlib.sha256(json.dumps(payload, sort_keys=True,
            separators=(",", ":")).encode("ascii")).hexdigest()
        assert game_state_hash(state) == expected


def test_state_hash_reuses_only_same_immutable_state_and_keeps_serialized_fields(monkeypatch):
    from dataclasses import asdict, fields, replace
    from pynq_multimodal_game.engine import side_scroller

    original, calls = side_scroller._compute_state_hash, []

    def compute(state):
        calls.append(state)
        return original(state)

    monkeypatch.setattr(side_scroller, "_compute_state_hash", compute)
    state = SideScrollerEngine().initial_state()
    serialized, names = asdict(state), tuple(field.name for field in fields(state))
    first = game_state_hash(state)
    assert game_state_hash(state) == first and len(calls) == 1
    changed = replace(state, tick_id=0)
    assert game_state_hash(changed) != first
    assert game_state_hash(changed) != first and len(calls) == 2
    assert asdict(state) == serialized and tuple(field.name for field in fields(state)) == names
    assert game_state_hash(state) == first and len(calls) == 2


def test_state_hash_keeps_mutable_containers_and_nested_records_uncached():
    from dataclasses import asdict, replace
    import hashlib
    import json
    from pynq_multimodal_game.engine.side_scroller import Obstacle

    initial = SideScrollerEngine().initial_state()
    for nested in (False, True):
        values = [1]
        state = replace(initial, obstacles=(Obstacle(values, 0),) if nested else values)
        first = game_state_hash(state)
        values.append(2)
        payload = asdict(state)
        payload["status"] = state.status.value
        expected = hashlib.sha256(json.dumps(payload, sort_keys=True, separators=(",", ":")).encode("ascii")).hexdigest()
        assert game_state_hash(state) == expected and expected != first


def test_side_scroller_engine_runs_without_legacy_control_state() -> None:
    engine = SideScrollerEngine(
        SideScrollerConfig(level_length=8, move_units_per_tick=4)
    )
    commands = (
        SideScrollerCommand(tick_id=0, direction=Direction.RIGHT, jump=True),
        SideScrollerCommand(tick_id=1, direction=Direction.RIGHT, attack=True),
    )

    first = engine.run(commands)
    second = engine.run(commands)

    assert first.status is SideScrollerStatus.WON
    assert first.world_x == 8
    assert first.attacks_fired == 1
    assert game_state_hash(first) == game_state_hash(second)