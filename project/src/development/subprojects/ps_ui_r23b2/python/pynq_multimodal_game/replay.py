from __future__ import annotations

import argparse
import hashlib
import json
from dataclasses import asdict, dataclass
from enum import Enum
from pathlib import Path
from time import perf_counter_ns
from typing import Callable, Iterable

from .controls import (
    ControlSource,
    ControlState,
    MockControlAdapter,
    MockInput,
    control_state_from_dict,
    control_state_to_dict,
    write_control_jsonl,
)
from .game import GameEngine, GameState, GameStatus, game_state_hash
from .renderer import GoldenRenderer
from .scene import Scene


class GameEventKind(str, Enum):
    ENEMY_SPAWNED = "ENEMY_SPAWNED"
    ENEMY_DEFEATED = "ENEMY_DEFEATED"
    COIN_COLLECTED = "COIN_COLLECTED"
    PLAYER_DAMAGED = "PLAYER_DAMAGED"
    SHIELD_BLOCKED = "SHIELD_BLOCKED"
    GAME_WON = "GAME_WON"
    GAME_LOST = "GAME_LOST"


@dataclass(frozen=True)
class GameEvent:
    tick_id: int
    kind: GameEventKind
    world_x: int | None = None
    lane_y: int | None = None
    score_delta: int = 0


@dataclass(frozen=True)
class TickMetrics:
    count: int
    p50_ns: int
    p95_ns: int
    p99_ns: int
    max_ns: int


@dataclass(frozen=True)
class ReplayReport:
    controls_sha256: str
    tick_count: int
    first_timestamp_ns: int
    last_timestamp_ns: int
    final_status: GameStatus
    final_score: int
    final_state_sha256: str
    first_frame_crc32: int | None
    last_frame_crc32: int | None
    tick_metrics: TickMetrics


@dataclass(frozen=True)
class ReplayResult:
    report: ReplayReport
    events: tuple[GameEvent, ...]
    final_state: GameState


SceneBuilder = Callable[[GameState, GameEngine], Scene]


def run_replay(
    engine: GameEngine,
    controls: Iterable[ControlState],
    *,
    scene_builder: SceneBuilder | None = None,
    renderer: GoldenRenderer | None = None,
) -> ReplayResult:
    records = tuple(controls)
    if not records:
        raise ValueError("replay requires at least one control state")
    if (scene_builder is None) != (renderer is None):
        raise ValueError("scene_builder and renderer must be provided together")

    state = engine.initial_state()
    events: list[GameEvent] = []
    durations_ns: list[int] = []
    first_frame_crc32: int | None = None
    last_frame_crc32: int | None = None
    for control in records:
        previous = state
        started_ns = perf_counter_ns()
        state = engine.step(state, control)
        durations_ns.append(perf_counter_ns() - started_ns)
        events.extend(_events_from_transition(previous, state))
        if scene_builder is not None and renderer is not None:
            frame_crc32 = renderer.crc32(renderer.render(scene_builder(state, engine)))
            if first_frame_crc32 is None:
                first_frame_crc32 = frame_crc32
            last_frame_crc32 = frame_crc32

    report = ReplayReport(
        controls_sha256=_controls_sha256(records),
        tick_count=len(records),
        first_timestamp_ns=records[0].timestamp_ns,
        last_timestamp_ns=records[-1].timestamp_ns,
        final_status=state.status,
        final_score=state.score,
        final_state_sha256=game_state_hash(state),
        first_frame_crc32=first_frame_crc32,
        last_frame_crc32=last_frame_crc32,
        tick_metrics=_tick_metrics(durations_ns),
    )
    return ReplayResult(report=report, events=tuple(events), final_state=state)


def write_replay_result(result: ReplayResult, output_dir: str | Path, name: str) -> None:
    destination = Path(output_dir)
    destination.mkdir(parents=True, exist_ok=True)
    _write_json(destination / f"{name}.report.json", _report_to_dict(result.report))
    with (destination / f"{name}.events.jsonl").open(
        "w", encoding="ascii", newline="\n"
    ) as stream:
        for event in result.events:
            json.dump(_event_to_dict(event), stream, sort_keys=True, separators=(",", ":"))
            stream.write("\n")


def load_control_jsonl(path: str | Path) -> tuple[ControlState, ...]:
    records = []
    with Path(path).open("r", encoding="utf-8") as stream:
        for line_number, line in enumerate(stream, start=1):
            if not line.strip():
                continue
            try:
                records.append(control_state_from_dict(json.loads(line)))
            except (KeyError, TypeError, ValueError) as error:
                raise ValueError(f"invalid replay record at line {line_number}") from error
    if not records:
        raise ValueError("replay requires at least one control state")
    return tuple(records)


def build_demo_controls(tick_count: int = 330) -> tuple[ControlState, ...]:
    if tick_count <= 0:
        raise ValueError("tick_count must be positive")
    adapter = MockControlAdapter(ControlSource.KEYBOARD)
    controls = []
    for tick_id in range(tick_count):
        up = tick_id < 14
        down = 41 <= tick_id < 49
        controls.append(
            adapter.sample(
                MockInput(
                    right=not up and not down,
                    up=up,
                    down=down,
                    jump=tick_id in (55, 120, 190, 260),
                    shield=145 <= tick_id < 160,
                    attack=tick_id in (30, 85, 150, 215, 280),
                ),
                tick_id=tick_id,
                timestamp_ns=tick_id * 16_666_667,
            )
        )
    return tuple(controls)


def _events_from_transition(
    previous: GameState, current: GameState
) -> tuple[GameEvent, ...]:
    events: list[GameEvent] = []
    spawned_count = len(previous.pending_enemy_spawns) - len(current.pending_enemy_spawns)
    for enemy in current.enemies[-spawned_count:] if spawned_count > 0 else ():
        events.append(
            GameEvent(
                tick_id=current.tick_id,
                kind=GameEventKind.ENEMY_SPAWNED,
                world_x=enemy.world_x,
                lane_y=enemy.lane_y,
            )
        )
    score_delta = current.score - previous.score
    if score_delta:
        coin_count, enemy_count = divmod(score_delta, 10)
        if enemy_count == 5:
            events.append(
                GameEvent(
                    tick_id=current.tick_id,
                    kind=GameEventKind.ENEMY_DEFEATED,
                    score_delta=5,
                )
            )
        for _ in range(coin_count):
            events.append(
                GameEvent(
                    tick_id=current.tick_id,
                    kind=GameEventKind.COIN_COLLECTED,
                    score_delta=10,
                )
            )
    if current.health < previous.health:
        events.append(GameEvent(tick_id=current.tick_id, kind=GameEventKind.PLAYER_DAMAGED))
    elif (
        current.shield_active
        and len(current.enemy_projectiles) < len(previous.enemy_projectiles)
    ):
        events.append(GameEvent(tick_id=current.tick_id, kind=GameEventKind.SHIELD_BLOCKED))
    if current.status is GameStatus.WON and previous.status is not GameStatus.WON:
        events.append(GameEvent(tick_id=current.tick_id, kind=GameEventKind.GAME_WON))
    if current.status is GameStatus.LOST and previous.status is not GameStatus.LOST:
        events.append(GameEvent(tick_id=current.tick_id, kind=GameEventKind.GAME_LOST))
    return tuple(events)


def _controls_sha256(records: tuple[ControlState, ...]) -> str:
    payload = b"\n".join(
        json.dumps(
            control_state_to_dict(record), sort_keys=True, separators=(",", ":")
        ).encode("ascii")
        for record in records
    )
    return hashlib.sha256(payload).hexdigest()


def _tick_metrics(samples_ns: list[int]) -> TickMetrics:
    if not samples_ns:
        raise ValueError("timing samples must not be empty")
    ordered = sorted(samples_ns)

    def percentile(percent: int) -> int:
        index = (len(ordered) * percent + 99) // 100 - 1
        return ordered[index]

    return TickMetrics(
        count=len(ordered),
        p50_ns=percentile(50),
        p95_ns=percentile(95),
        p99_ns=percentile(99),
        max_ns=ordered[-1],
    )


def _report_to_dict(report: ReplayReport) -> dict[str, object]:
    payload = asdict(report)
    payload["final_status"] = report.final_status.value
    return payload


def _event_to_dict(event: GameEvent) -> dict[str, object]:
    payload = asdict(event)
    payload["kind"] = event.kind.value
    return payload


def _write_json(path: Path, payload: dict[str, object]) -> None:
    with path.open("w", encoding="ascii", newline="\n") as stream:
        json.dump(payload, stream, sort_keys=True, separators=(",", ":"))
        stream.write("\n")


def main(arguments: list[str] | None = None) -> None:
    from .demo import build_demo_scene, create_demo_assets, create_demo_engine

    parser = argparse.ArgumentParser(description="Run a deterministic C1 replay.")
    parser.add_argument("controls", nargs="?", type=Path)
    parser.add_argument("--output-dir", type=Path, default=Path("results/replays"))
    parser.add_argument("--name", default="c1_demo")
    parser.add_argument("--write-demo-controls", type=Path)
    args = parser.parse_args(arguments)

    if args.write_demo_controls is not None:
        args.write_demo_controls.parent.mkdir(parents=True, exist_ok=True)
        write_control_jsonl(args.write_demo_controls, build_demo_controls())
        print(f"wrote demo controls: {args.write_demo_controls}")
        return
    if args.controls is None:
        parser.error("controls is required unless --write-demo-controls is used")

    assets = create_demo_assets()
    result = run_replay(
        create_demo_engine(),
        load_control_jsonl(args.controls),
        scene_builder=lambda state, engine: build_demo_scene(state, engine.config, assets),
        renderer=assets.renderer,
    )
    write_replay_result(result, args.output_dir, args.name)
    print(
        f"ticks={result.report.tick_count} status={result.report.final_status.value} "
        f"score={result.report.final_score} hash={result.report.final_state_sha256}"
    )


if __name__ == "__main__":
    main()