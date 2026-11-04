from __future__ import annotations

from collections.abc import Callable, Iterable
from dataclasses import dataclass
from time import monotonic_ns, sleep

from .controls import ControlState
from .game import GameEngine, GameState, GameStatus, game_state_hash
from .renderer import GoldenRenderer
from .replay import TickMetrics
from .scene import Scene


TICK_PERIOD_NS = 1_000_000_000 // 60
SceneBuilder = Callable[[GameState, GameEngine], Scene]


@dataclass(frozen=True)
class HeadlessReport:
    tick_count: int
    elapsed_ns: int
    audit_render_ns: int
    deadline_miss_count: int
    tick_metrics: TickMetrics
    final_status: GameStatus
    final_score: int
    final_state_sha256: str
    first_frame_crc32: int
    last_frame_crc32: int


@dataclass(frozen=True)
class HeadlessResult:
    report: HeadlessReport
    final_state: GameState


def run_headless_replay(
    engine: GameEngine,
    controls: Iterable[ControlState],
    *,
    scene_builder: SceneBuilder,
    renderer: GoldenRenderer,
    pace: bool = False,
    now_ns: Callable[[], int] = monotonic_ns,
    sleep_seconds: Callable[[float], None] = sleep,
) -> HeadlessResult:
    records = tuple(controls)
    if not records:
        raise ValueError("headless replay requires at least one control state")

    state = engine.initial_state()
    durations_ns: list[int] = []
    deadline_miss_count = 0
    started_ns = now_ns()
    first_state: GameState | None = None
    for tick_index, control in enumerate(records):
        deadline_ns = started_ns + tick_index * TICK_PERIOD_NS
        tick_started_ns = now_ns()
        state = engine.step(state, control)
        if tick_index == 0:
            first_state = state
        tick_finished_ns = now_ns()
        durations_ns.append(tick_finished_ns - tick_started_ns)
        if tick_finished_ns > deadline_ns + TICK_PERIOD_NS:
            deadline_miss_count += 1
        if pace:
            remaining_ns = deadline_ns + TICK_PERIOD_NS - now_ns()
            if remaining_ns > 0:
                sleep_seconds(remaining_ns / 1_000_000_000)

    elapsed_ns = now_ns() - started_ns
    if first_state is None:
        raise RuntimeError("headless replay did not produce a first state")

    audit_started_ns = now_ns()
    first_frame_crc32 = renderer.crc32(renderer.render(scene_builder(first_state, engine)))
    if len(records) == 1:
        last_frame_crc32 = first_frame_crc32
    else:
        last_frame_crc32 = renderer.crc32(renderer.render(scene_builder(state, engine)))
    audit_render_ns = now_ns() - audit_started_ns
    report = HeadlessReport(
        tick_count=len(records),
        elapsed_ns=elapsed_ns,
        audit_render_ns=audit_render_ns,
        deadline_miss_count=deadline_miss_count,
        tick_metrics=_tick_metrics(durations_ns),
        final_status=state.status,
        final_score=state.score,
        final_state_sha256=game_state_hash(state),
        first_frame_crc32=first_frame_crc32,
        last_frame_crc32=last_frame_crc32,
    )
    return HeadlessResult(report=report, final_state=state)


def _tick_metrics(samples_ns: list[int]) -> TickMetrics:
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