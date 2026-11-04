from __future__ import annotations

import pytest

from pynq_multimodal_game.game_sdk import GameContext, GameInput, ToneSignal, VolumeSignal


def test_volume_package_contract_requires_explicit_sdk13_and_keeps_legacy_metadata(tmp_path):
    from dataclasses import replace
    from pynq_multimodal_game.game_package import GameManifest, GameVolumeInputContract, canonical_manifest
    from pynq_multimodal_game.game_project import GameProject
    project = GameProject.create(tmp_path / "volume", game_id="volume", display_name="Volume")
    legacy = GameManifest.from_toml(project.manifest_path.read_bytes())
    assert "volume_inputs" not in canonical_manifest(legacy)
    contract = GameVolumeInputContract("volume-signal-v1", "game1")
    candidate = replace(legacy, sdk_minor=3, volume_inputs=contract)
    assert canonical_manifest(candidate)["volume_inputs"] == {"schema": "volume-signal-v1", "vision_mapping": "game1"}
    manifest_text = project.manifest_path.read_text(encoding="utf-8").replace("sdk_minor = 1", "sdk_minor = 3")
    manifest_text += '\n[volume]\nschema = "volume-signal-v1"\nvision_mapping = "game1"\n'
    assert GameManifest.from_toml(manifest_text.encode()).volume_inputs == contract
    for changed in (manifest_text.replace('schema = "volume-signal-v1"', 'schema = "tone"'),
                    manifest_text + 'extra = "unexpected"\n'):
        with pytest.raises(ValueError):
            GameManifest.from_toml(changed.encode())
    with pytest.raises(ValueError, match="SDK1.3"):
        replace(candidate, sdk_minor=2)
    for schema, mapping in (("tone", "game1"), ("volume-signal-v1", "unknown")):
        with pytest.raises(ValueError):
            GameVolumeInputContract(schema, mapping)


def test_logical_position_maps_to_normalized_input() -> None:
    top_left = GameInput.from_logical_position(
        tick_id=0, timestamp_ns=0, x=0, y=0
    )
    bottom_right = GameInput.from_logical_position(
        tick_id=1, timestamp_ns=1, x=319, y=179, fist_sequence=3, fist_event=True
    )

    assert (top_left.hand_x, top_left.hand_y) == (-1.0, -1.0)
    assert (bottom_right.hand_x, bottom_right.hand_y) == (1.0, 1.0)
    assert bottom_right.fist_sequence == 3
    assert bottom_right.fist_event is True


def test_game_context_rng_is_deterministic() -> None:
    first = GameContext(seed=42, tick_hz=60)
    second = GameContext(seed=42, tick_hz=60)

    assert [first.random.randrange(1000) for _ in range(8)] == [
        second.random.randrange(1000) for _ in range(8)
    ]


def test_tone_signal_rejects_invalid_transitions() -> None:
    with pytest.raises(ValueError, match="starting tone"):
        ToneSignal(sequence=1, frequency_hz=440.0, active=False, started=True)
    with pytest.raises(ValueError, match="frequency"):
        ToneSignal(sequence=1, frequency_hz=10.0, active=True)


def test_legacy_input_hash_payload_is_unchanged():
    from pynq_multimodal_game.game_sdk import canonical_game_input
    assert canonical_game_input(GameInput(0, 0, True, 0, 0, 0, False)) == {
        "tick_id": 0, "timestamp_ns": 0, "hand_valid": True, "hand_x": 0,
        "hand_y": 0, "fist_sequence": 0, "fist_event": False, "tone": None,
    }


def test_action_contract_binds_tick_and_timestamp():
    from dataclasses import replace
    from pynq_multimodal_game.game_actions import ActionPhase, GameAction, GameActionFrame
    frame = GameActionFrame("candidate", "run", "epoch", "policy", 0, 10, "RUNNING",
                            (GameAction("custom-tool", 1, ActionPhase.TRIGGER, True),))
    assert GameInput(0, 10, True, 0, 0, 0, False, actions=frame).actions is frame
    with pytest.raises(ValueError, match="match"):
        GameInput(1, 10, True, 0, 0, 0, False, actions=frame)
    for changes in ({"sample_tick": True}, {"status": "FAULT"}, {"schema": "unknown"},
                    {"actions": frame.actions * 17}):
        with pytest.raises(ValueError):
            replace(frame, **changes)


def test_action_contract_requires_live_state_deadline():
    from pynq_multimodal_game.game_actions import ActionPhase, GameAction, GameActionFrame
    with pytest.raises(ValueError, match="deadline"):
        GameAction("custom-state", 1, ActionPhase.STATE, True)
    state = GameAction("custom-state", 1, ActionPhase.STATE, True, deadline_ns=10)
    with pytest.raises(ValueError, match="expired"):
        GameActionFrame("candidate", "run", "epoch", "policy", 0, 10, "RUNNING", (state,))


def test_volume_signal_is_explicit_and_preserves_legacy_payload():
    from dataclasses import asdict
    from pynq_multimodal_game.game_sdk import canonical_game_input
    signal = VolumeSignal("a" * 32, 2, 1, "SOFT", 1954, 2)
    game_input = GameInput.from_logical_position(tick_id=1, timestamp_ns=10, x=0, y=0, volume=signal)
    assert game_input.volume is signal and game_input.tone is None
    assert canonical_game_input(game_input)["volume"] == asdict(signal)
    assert "volume" not in canonical_game_input(GameInput(0, 0, True, 0, 0, 0, False))
    with pytest.raises(ValueError, match="VolumeSignal"):
        GameInput(0, 0, True, 0, 0, 0, False, volume=asdict(signal))


@pytest.mark.parametrize("changes", [
    {"producer_run": "run"}, {"producer_run": "G" * 32}, {"kind": "QUIET"}, {"kind": 1},
    {"epoch": 0}, {"epoch": True}, {"sequence": 2**32}, {"sequence": -1},
    {"source_sample": 0}, {"source_sample": 2**64}, {"source_window": 1.0}, {"source_window": 2**32},
])
def test_volume_signal_rejects_unbound_or_invalid_facts(changes):
    from dataclasses import replace
    signal = VolumeSignal("a" * 32, 2, 1, "LOUD", 1954, 2)
    with pytest.raises(ValueError):
        replace(signal, **changes)
