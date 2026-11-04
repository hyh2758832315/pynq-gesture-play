from __future__ import annotations

import pytest

from pynq_multimodal_game.gpu_abi import COMMAND_CAPACITY, pack_asset_bundle_packet
from pynq_multimodal_game.return_button import RETURN_SIZE
from pynq_multimodal_game.scene_compiler import CommandRenderer
from pynq_multimodal_game.startup_ui import (
    CheckState, STAGES, StartupRenderer, StartupSequence, StartupSnapshot,
)


def test_startup_checks_publish_order_and_stop_before_later_hardware_on_failure():
    operations = []
    updates = []

    def record(name):
        operations.append(name)
        return True

    checks = tuple((name, lambda name=name: record(name)) for name in STAGES)
    result = StartupSequence(checks).run(updates.append)
    assert operations == list(STAGES)
    assert len(updates) == 1 + 2 * len(STAGES)
    assert result.states == (CheckState.OK,) * 4
    assert all(update.states[index] is CheckState.CHECK and
               all(state is CheckState.WAIT for state in update.states[index + 1:])
               for index, update in enumerate(updates[1::2]))

    operations.clear()
    updates.clear()

    def fail_vision():
        operations.append("VISION")
        raise RuntimeError("camera unavailable")

    checks = (("GPU", lambda: record("GPU")),
              ("LIBRARY", lambda: record("LIBRARY")),
              ("VISION", fail_vision),
              ("HAND", lambda: record("HAND")))
    sequence = StartupSequence(checks)
    with pytest.raises(RuntimeError, match="camera unavailable"):
        sequence.run(updates.append)
    assert operations == ["GPU", "LIBRARY", "VISION"]
    assert sequence.snapshot.states == (CheckState.OK, CheckState.OK,
                                        CheckState.FAIL, CheckState.WAIT)
    assert "camera unavailable" in sequence.snapshot.error


def test_startup_check_cannot_claim_ready_with_starting_status():
    checks = (("GPU", lambda: True), ("LIBRARY", lambda: True),
              ("VISION", lambda: {"state": "STARTING"}),
              ("HAND", lambda: pytest.fail("hand check must not run")))
    sequence = StartupSequence(checks)
    with pytest.raises(RuntimeError, match="did not return verified readiness"):
        sequence.run(lambda _: None)
    assert sequence.snapshot.states == (CheckState.OK, CheckState.OK,
                                        CheckState.FAIL, CheckState.WAIT)


def test_startup_screen_is_dedicated_large_title_and_small_simulated_bar_scene():
    renderer = StartupRenderer()
    first = StartupSnapshot()
    working = StartupSnapshot((CheckState.OK, CheckState.OK,
                               CheckState.CHECK, CheckState.WAIT))
    frame_a = renderer.compile(first, frame_id=0, generation=7)
    frame_b = renderer.compile(working, frame_id=1, generation=7)
    assert frame_a.assets == frame_b.assets
    assert len(pack_asset_bundle_packet(frame_a.assets, generation=7)) < 32 * 1024
    assert len(frame_a.commands) == len(frame_b.commands) < COMMAND_CAPACITY
    assert frame_a.header.predicted_cycles < 100_000
    title=renderer.scene(first, frame_id=0).sprites[0]
    assert title.width==108 and title.height==20 and title.y==58
    assert not any(s.width==48 and s.height==48 for s in renderer.scene(first,frame_id=0).sprites)
    late=renderer.compile(working,frame_id=2,generation=7,elapsed_seconds=60)
    assert frame_a.assets==late.assets
    assert CommandRenderer().render(frame_a)!=CommandRenderer().render(late)
    assert .9<renderer.visual_progress(working,60)<1
    assert len(CommandRenderer().render(frame_b)) == 320 * 180 * 3
