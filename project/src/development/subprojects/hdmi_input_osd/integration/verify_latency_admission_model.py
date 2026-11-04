"""Exhaustively check the proposed three-slot SOF reservation protocol.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/verify_latency_admission_model.py --output build/hosd/c0e-admission-model-r01.json
Output: exclusive JSON receipt containing explored states, edges and assertions.
Next: implement and test pixel-domain admission/CDC against this contract in XSim.
No board access. This abstract model is NOT an RTL, CDC, or timing proof.
"""

import argparse
from collections import deque
from dataclasses import dataclass, replace
import hashlib
import json
from pathlib import Path

CAPACITY = 3
MODULUS = 8
MASK = MODULUS - 1


def distance(new, old):
    return (new - old) & MASK


@dataclass(frozen=True)
class State:
    reserved: int = 0
    granted: int = 0
    completed: int = 0
    released: int = 0
    observed_release: int = 0
    held: bool = False
    closed: bool = False


def occupancy(state):
    return distance(state.reserved, state.released)


def budget(state):
    return distance(state.reserved, state.observed_release)


def check(state):
    pending = distance(state.reserved, state.granted)
    incomplete = distance(state.granted, state.completed)
    available = distance(state.completed, state.released)
    lag = distance(state.released, state.observed_release)
    used = occupancy(state)
    assert pending + incomplete + available == used <= CAPACITY
    assert used + lag == budget(state) <= CAPACITY
    assert not state.held or available > 0
    # A frame that was admitted/reserved must never wait for an owner slot.
    if pending:
        assert distance(state.granted, state.released) < CAPACITY
    # Delayed release information can only withhold, never invent, free slots.
    assert CAPACITY - budget(state) <= CAPACITY - used


def successors(state):
    if not state.closed:
        yield 'close_at_frame_boundary', replace(state, closed=True)
        if budget(state) < CAPACITY:
            yield 'reserve_at_sof', replace(state, reserved=(state.reserved + 1) & MASK)
        else:
            yield 'skip_whole_source_frame', state
    if distance(state.reserved, state.granted):
        yield 'grant_reserved_frame', replace(state, granted=(state.granted + 1) & MASK)
    if distance(state.granted, state.completed):
        yield 'complete_rgb_packet_and_status', replace(state, completed=(state.completed + 1) & MASK)
    if not state.held and distance(state.completed, state.released):
        yield 'claim_oldest_complete_frame', replace(state, held=True)
    if state.held:
        yield 'release_claimed_frame', replace(state, released=(state.released + 1) & MASK, held=False)
    # Arbitrarily stale, ordered CDC samples; allow intermediate values to be skipped.
    # No bound on the number of source frames before a sample becomes visible.
    for advance in range(1, distance(state.released, state.observed_release) + 1):
        yield 'observe_releases', replace(state, observed_release=(state.observed_release + advance) & MASK)
    yield 'arbitrary_consumer_or_cdc_stall', state


def explore():
    initial = State()
    queue = deque([initial])
    visited = {initial}
    edges = 0
    actions = {}
    wrapped = set()
    while queue:
        state = queue.popleft()
        check(state)
        for action, other in successors(state):
            check(other)
            edges += 1
            actions[action] = actions.get(action, 0) + 1
            for field in ('reserved', 'granted', 'completed', 'released', 'observed_release'):
                if getattr(other, field) < getattr(state, field):
                    wrapped.add(field)
            if other not in visited:
                visited.add(other)
                queue.append(other)
    assert len(wrapped) == 5
    assert actions['skip_whole_source_frame'] > 0
    assert any(s.closed and occupancy(s) == 0 and not s.held for s in visited)
    # Constructive recovery: if the consumer resumes, every closed state drains.
    maximum_drain_steps = 0
    for origin in visited:
        if not origin.closed:
            continue
        state = origin
        steps = 0
        while occupancy(state) or state.held:
            choices = dict(successors(state))
            for action in ('release_claimed_frame', 'claim_oldest_complete_frame',
                           'complete_rgb_packet_and_status', 'grant_reserved_frame'):
                if action in choices:
                    state = choices[action]
                    break
            else:
                raise AssertionError(('drain deadlock', state))
            steps += 1
            assert steps <= 12
        maximum_drain_steps = max(maximum_drain_steps, steps)
    return dict(states=len(visited), transitions=edges, actions=actions,
                wrapped_counters=sorted(wrapped), max_constructive_drain_steps=maximum_drain_steps)


def prove_naive_gate_counterexample():
    # grant_ready remains true while accepted pixels are still upstream of owner.
    # Sampling it at SOF without a local reservation admits too many frames.
    reserved = 0
    granted = 0
    trace = []
    for source_frame in range(1, 5):
        assert granted < CAPACITY
        reserved += 1
        trace.append(dict(source_frame=source_frame, downstream_granted=granted,
                          gate_ready=True, reservations_needed=reserved))
    assert reserved > CAPACITY
    return trace


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    repo = Path(__file__).resolve().parents[3]
    output = args.output.resolve()
    assert output.is_relative_to(repo / 'build/hosd')
    assert not output.exists()
    # Registered Gray counter updates must differ in one bit, including wrap.
    for value in range(MODULUS):
        successor = (value + 1) & MASK
        delta = (value ^ (value >> 1)) ^ (successor ^ (successor >> 1))
        assert delta and not delta & (delta - 1)
    result = dict(status='ABSTRACT_ADMISSION_MODEL_PASS', board_access=False,
                  capacity=CAPACITY, modulus=MODULUS, **explore(),
                  naive_ready_gate_counterexample=prove_naive_gate_counterexample(),
                  source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                  assumptions=[
                      'Common reset clears reservations and synchronized release history before open.',
                      'CDC observations are stale but ordered authentic release counts.',
                      'Release occurs only after the oldest complete claimed frame is no longer referenced.',
                      'Each reservation creates exactly one complete frame; no partial-frame admission.',
                      'One completion represents matched RGB, packet and status completion.',
                      'Liveness requires downstream DMA and CPU eventually to resume.',
                  ], exclusions=[
                      'Actual CDC metastability, bit skew, reset recovery and physical timing.',
                      'Pixel-level VSYNC/DE boundary and STOP budget implementation.',
                      'DDR stalls inside an accepted frame; finite FIFOs still have limits.',
                      'Packet CRC, context validation, frame-id exhaustion and numerical equivalence.',
                      'No RTL implementation or bitstream was changed by this model.',
                  ])
    with output.open('x', encoding='utf-8') as handle:
        json.dump(result, handle, indent=2)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
