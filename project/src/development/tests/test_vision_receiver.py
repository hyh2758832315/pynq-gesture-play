import copy

import pytest

from pynq_multimodal_game.studio.vision_receiver import VisionResultReceiver


def packet(frame=1, seq=0, *, run="run-a", age=0, valid=True, direction="LEFT"):
    return {"run_id": run, "server_age_ms": age, "control": {
        "schema": "gesture-control-v1", "frame_id": frame, "action_event_seq": seq,
        "valid": valid, "direction": direction,
    }}


def test_duplicate_http_success_does_not_extend_frame_freshness():
    receiver = VisionResultReceiver()
    assert receiver.consume(packet(), 1).valid
    assert receiver.consume(packet(), 2).valid
    stale = receiver.consume(packet(), 2.21)
    assert stale.status == "STALE"
    assert stale.direction == "IDLE"
    assert stale.local_age_ms == pytest.approx(1210)
    assert not receiver.consume(packet(), 2.3).valid


def test_hand_classification_peek_is_latest_only_and_does_not_consume_menu_action():
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    now = [10.0]
    provider = GameVisionInputProvider(clock=lambda: now[0])
    assert provider.peek_hand_classification() is None
    paper = packet(frame=1, age=20)
    paper.update(stable="5", rps="PAPER")
    paper["control"]["smooth_uv"] = [0.0, 0.0]
    provider.publish(paper, config_epoch="cfg-a")
    first = provider.peek_hand_classification()
    assert first is not None and first["gesture"] == "paper" and first["valid"]
    now[0] += 0.1
    again = provider.peek_hand_classification()
    assert again is not None and again["frame_id"] == 1
    assert again["source_at"] == pytest.approx(first["source_at"])

    rock = packet(frame=2, age=20)
    rock.update(stable="0", rps="ROCK")
    rock["control"]["smooth_uv"] = [0.0, 0.0]
    provider.publish(rock, config_epoch="cfg-a")
    assert provider.peek_hand_classification()["gesture"] == "fist"
    assert provider.sample_menu_control(tick_id=1).fist_event

    unknown = packet(frame=3, age=20)
    unknown.update(stable="1", rps="UNKNOWN")
    unknown["control"]["smooth_uv"] = [0.0, 0.0]
    provider.publish(unknown, config_epoch="cfg-a")
    latest = provider.peek_hand_classification()
    assert latest is not None and latest["frame_id"] == 3
    assert latest["valid"] and latest["gesture"] is None
    no_hand = packet(frame=4, age=20, valid=False)
    no_hand["control"]["reason"] = "NO_HAND"
    provider.publish(no_hand, config_epoch="cfg-a")
    latest = provider.peek_hand_classification()
    assert latest is not None and latest["frame_id"] == 4
    assert latest["valid"] and latest["gesture"] == "default"
    now[0] += 1.3
    assert provider.peek_hand_classification()["valid"] is False


def test_duplicate_invalid_frame_releases_immediately():
    receiver = VisionResultReceiver()
    receiver.consume(packet(), 1)
    invalid = receiver.consume(packet(valid=False), 1.1)
    assert invalid.status == "INVALID" and invalid.direction == "IDLE"
    assert not receiver.consume(packet(), 1.2).valid
    assert receiver.consume(packet(frame=2), 1.3).valid


def test_expiry_without_any_response_and_server_age_budget():
    receiver = VisionResultReceiver()
    receiver.consume(packet(age=1100), 1)
    assert receiver.expire(1.05).valid
    assert receiver.expire(1.11).status == "STALE"
    receiver.consume(packet(frame=2), 2)
    assert receiver.expire(3.21).status == "STALE"


def test_event_baseline_new_run_reconnect_and_growth():
    receiver = VisionResultReceiver()
    assert not receiver.consume(packet(seq=8), 1).action_event
    assert receiver.consume(packet(frame=2, seq=12), 1.1).action_event
    assert not receiver.consume(packet(frame=2, seq=12), 1.2).action_event
    assert not receiver.consume(packet(run="run-b", seq=40), 1.3).action_event
    receiver.release(1.4, "HTTP failure")
    assert not receiver.consume(packet(frame=2, run="run-b", seq=41), 1.5).action_event
    assert receiver.consume(packet(frame=3, run="run-b", seq=42), 1.6).action_event


def test_duplicate_cannot_reset_original_server_age_budget():
    receiver = VisionResultReceiver()
    receiver.consume(packet(age=1100), 1)
    assert receiver.consume(packet(age=0), 1.05).valid
    assert receiver.expire(1.11).status == "STALE"


def test_old_frames_and_expired_events_do_not_replay():
    receiver = VisionResultReceiver()
    receiver.consume(packet(frame=10, seq=5), 1)
    assert receiver.consume(packet(frame=9, seq=20), 1.1).action_event is False
    assert receiver.expire(2.21).direction == "IDLE"
    assert not receiver.consume(packet(frame=9), 2.3).valid
    fresh = receiver.consume(packet(frame=11, seq=20), 2.4)
    assert fresh.valid and not fresh.action_event


def test_sequence_rollback_invalidates_and_rebaselines():
    receiver = VisionResultReceiver()
    receiver.consume(packet(seq=9), 1)
    assert receiver.consume(packet(frame=2, seq=8), 1.1).status == "INVALID"
    assert not receiver.consume(packet(frame=3, seq=10), 1.2).action_event


@pytest.mark.parametrize("field,value", [
    ("frame_id", True), ("frame_id", 0), ("frame_id", 1.5),
    ("action_event_seq", True), ("action_event_seq", -1),
    ("valid", 1), ("direction", "STOP"), ("schema", "unknown"),
])
def test_strict_control_fields(field, value):
    receiver = VisionResultReceiver()
    sample = packet()
    sample["control"][field] = value
    assert receiver.consume(sample, 1).status == "INVALID"


@pytest.mark.parametrize("age", [True, -1, float("nan"), float("inf"), None, "0"])
def test_strict_server_age(age):
    assert VisionResultReceiver().consume(packet(age=age), 1).status == "INVALID"


def test_empty_result_waits_and_schema_errors_release():
    receiver = VisionResultReceiver()
    assert receiver.consume({"server_age_ms": None}, 1).status == "WAITING"
    receiver.consume(packet(), 2)
    broken = copy.deepcopy(packet())
    del broken["control"]["schema"]
    assert not receiver.consume(broken, 2.1).valid
    assert receiver.consume([], 2.2).status == "INVALID"
    assert receiver.consume(packet(frame=2, age=1201), 2.3).status == "STALE"


def provider_fixture(*, fist_enabled=False):
    from pynq_multimodal_game.vision_input import VisionInputProvider
    now = [1.0]
    return VisionInputProvider(clock=lambda: now[0], fist_enabled=fist_enabled), now


def action_packet(frame=1, seq=0, **kwargs):
    sample = packet(frame, seq, **kwargs)
    sample["control"].update(action_event=True, action_kind="HEURISTIC_OPEN_TO_FIST")
    return sample


def test_menu_pointer_and_confirmation_are_independent_of_game_fist_switch():
    provider, _now = provider_fixture()
    opened = packet()
    opened.update(stable="5", rps="PAPER")
    opened["control"].update(u=.25, v=-.4)
    provider.publish(opened)
    pointer = provider.sample_menu_control(tick_id=0)
    assert pointer.hand_valid and (pointer.hand_x, pointer.hand_y) == (.25, -.4)
    closed = copy.deepcopy(opened)
    closed.update(stable="0", rps="ROCK")
    closed["control"].update(frame_id=2)
    provider.publish(closed)
    assert provider.sample_menu_control(tick_id=1).fist_event
    assert not provider.sample_menu_control(tick_id=2).fist_event
    provider.publish(closed)
    assert not provider.sample_menu_control(tick_id=3).fist_event
    assert not provider.sample(tick_id=0).fist_event


@pytest.mark.parametrize("invalid", ["stale", "lost", "run", "coordinates", "suspended"])
def test_menu_invalid_input_clears_pointer_and_confirmation(invalid):
    provider, now = provider_fixture()
    opened = packet()
    opened.update(stable="5", rps="PAPER")
    opened["control"].update(u=.25, v=-.4)
    provider.publish(opened)
    if invalid == "stale":
        now[0] += 1.21
    elif invalid == "suspended":
        provider.suspend()
    else:
        broken = copy.deepcopy(opened)
        broken["control"]["frame_id"] = 2
        if invalid == "lost":
            broken["control"]["valid"] = False
        elif invalid == "coordinates":
            broken["control"]["u"] = float("nan")
        else:
            broken.update(run_id="new-run", stable="0", rps="ROCK")
        provider.publish(broken)
    control = provider.sample_menu_control(tick_id=1)
    assert not control.fist_event
    if invalid != "run":
        assert not control.hand_valid


def test_ps_provider_samples_direction_without_extending_freshness():
    provider, now = provider_fixture()
    provider.publish(packet())
    for tick in range(5):
        sample = provider.sample(tick_id=tick)
        assert sample.hand_valid and sample.hand_x == -1
        assert sample.tone is None and sample.hand_gesture is None
    now[0] = 2.21
    provider.publish(packet())
    assert not provider.sample(tick_id=5).hand_valid
    assert provider.receipt.result.status == "STALE"


def test_ps_provider_atomic_sample_receipt_preserves_consumed_source():
    provider, now = provider_fixture()
    provider.publish(packet(frame=1, run="sampled"))
    sample, receipt = provider.sample_with_receipt(tick_id=3, timestamp_ns=12345)
    assert sample.hand_valid and sample.hand_x == -1
    assert receipt["run_id"] == "sampled"
    assert receipt["source_frame_id"] == 1 and receipt["sample_tick"] == 3
    assert receipt["sample_timestamp_ns"] == 12345 and not receipt["action_consumed"]
    now[0] += .01
    provider.publish(packet(frame=2, run="sampled", direction="RIGHT"))
    assert provider.receipt.result.frame_id == 2
    assert receipt["source_frame_id"] == 1 and receipt["hand_x"] == -1
    now[0] = 2.3
    stale, stale_receipt = provider.sample_with_receipt(tick_id=4)
    assert not stale.hand_valid and stale.hand_x == 0
    assert stale_receipt["source_status"] == "STALE" and not stale_receipt["hand_valid"]


def test_ps_provider_action_is_consumed_once_and_never_replays_sequence_gap():
    provider, now = provider_fixture(fist_enabled=True)
    provider.publish(action_packet(seq=9))
    assert not provider.sample(tick_id=0).fist_event
    now[0] += .01
    provider.publish(action_packet(frame=2, seq=20))
    first = provider.sample(tick_id=1)
    assert first.fist_event and first.fist_sequence == 1
    assert provider.receipt.consumed_action_seq == 20
    assert provider.receipt.consumed_tick == 1
    provider.publish(action_packet(frame=2, seq=20))
    assert not provider.sample(tick_id=2).fist_event


def test_ps_provider_default_fist_disabled_and_action_kind_gated():
    provider, now = provider_fixture()
    provider.publish(action_packet())
    now[0] += .01
    provider.publish(action_packet(frame=2, seq=1))
    assert not provider.sample(tick_id=1).fist_event
    enabled, _ = provider_fixture(fist_enabled=True)
    enabled.publish(action_packet())
    wrong = action_packet(frame=2, seq=1)
    wrong["control"]["action_kind"] = "RPS"
    enabled.publish(wrong)
    assert not enabled.sample(tick_id=1).fist_event


def test_ps_provider_pending_action_expires_even_when_new_direction_is_fresh():
    provider, now = provider_fixture(fist_enabled=True)
    provider.publish(action_packet())
    now[0] = 1.1
    provider.publish(action_packet(frame=2, seq=1, age=1100))
    now[0] = 1.3
    provider.publish(packet(frame=3, seq=1, direction="RIGHT"))
    sample = provider.sample(tick_id=1)
    assert sample.hand_valid and sample.hand_x == 1 and not sample.fist_event


def test_ps_provider_invalid_pause_resume_and_new_epoch_release_actions():
    provider, now = provider_fixture(fist_enabled=True)
    provider.publish(action_packet())
    now[0] += .01
    provider.publish(action_packet(frame=2, seq=1))
    provider.publish(packet(frame=2, seq=1, valid=False))
    assert not provider.sample(tick_id=1).hand_valid
    provider.suspend()
    provider.publish(action_packet(frame=3, seq=2))
    provider.resume()
    assert not provider.sample(tick_id=2).hand_valid
    provider.publish(action_packet(frame=4, seq=3))
    assert not provider.sample(tick_id=3).fist_event
    provider.publish(action_packet(frame=5, seq=4), config_epoch="new")
    assert not provider.sample(tick_id=4).fist_event
    provider.publish(action_packet(run="run-b", seq=50), config_epoch="new")
    assert not provider.sample(tick_id=5).fist_event


@pytest.mark.parametrize("direction", ["IDLE", "UP", "DOWN"])
def test_ps_provider_first_slice_maps_only_horizontal_direction(direction):
    provider, _ = provider_fixture()
    provider.publish(packet(direction=direction))
    sample = provider.sample(tick_id=0)
    assert sample.hand_x == 0 and sample.hand_y == 0


def test_ps_provider_invalid_action_flag_releases_direction():
    provider, _ = provider_fixture(fist_enabled=True)
    malformed = packet()
    malformed["control"]["action_event"] = 1
    provider.publish(malformed)
    assert not provider.sample(tick_id=0).hand_valid


@pytest.mark.parametrize("stable,label,expected", [("0", "ROCK", "fist"),
                                                  ("2", "SCISSORS", "scissors"),
                                                  ("5", "PAPER", "paper")])
def test_board_game_rps_uses_same_frame_classification_in_idle(stable, label, expected):
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    provider = GameVisionInputProvider(clock=lambda: 1.0)
    result = packet(direction="IDLE")
    result.update(frame=1, stable=stable, rps=label)
    provider.publish(result)
    sample, receipt = provider.sample_for_game("game2", tick_id=0)
    assert sample.hand_valid and sample.hand_gesture.value == expected
    assert sample.hand_x == sample.hand_y == 0 and sample.fist_event is (expected == "fist")
    assert receipt["source_frame_id"] == 1 and receipt["control_mapping"] == "RAW_GESTURE"


@pytest.mark.parametrize("game_id", ["game1", "game2", "game3", "unknown"])
def test_board_game_vertical_direction_is_not_filtered_by_game_id(game_id):
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    provider = GameVisionInputProvider(clock=lambda: 1.0)
    provider.publish(packet(direction="UP"))
    sample, receipt = provider.sample_for_game(game_id, tick_id=0)
    assert sample.hand_y == receipt["hand_y"] == -1.0


@pytest.mark.parametrize("stable,label,expected", [("0", "ROCK", "fist"),
                                                  ("2", "SCISSORS", "scissors"),
                                                  ("5", "PAPER", "paper")])
@pytest.mark.parametrize("game_id", ["game1", "game2", "game3", "reusable-custom-game"])
def test_board_games_pass_current_classification_without_heuristic_action(game_id, stable, label, expected):
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    now = [1.0]
    provider = GameVisionInputProvider(clock=lambda: now[0])
    result = packet(direction="IDLE")
    result.update(frame=1, stable=stable, rps=label)
    provider.publish(result)
    for tick in range(3):
        sample, receipt = provider.sample_for_game(game_id, tick_id=tick)
        assert sample.hand_valid and sample.fist_event is (expected == "fist" and tick == 0)
        assert sample.hand_gesture is not None and sample.hand_gesture.value == expected
        assert receipt["hand_gesture"] == receipt["source_hand_gesture"] == expected
    now[0] += 1.21
    sample, receipt = provider.sample_for_game(game_id, tick_id=3)
    assert not sample.hand_valid and sample.hand_gesture is None and not sample.fist_event
    assert receipt["hand_gesture"] is None


@pytest.mark.parametrize("method", ["sample", "sample_with_receipt", "sample_for_game"])
def test_raw_gesture_facts_are_available_through_every_sample_api(method):
    from pynq_multimodal_game.game_sdk import HandGesture
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    provider = GameVisionInputProvider(clock=lambda: 1.0)
    result = packet(direction="UP")
    result.update(frame=1, stable="0", rps="ROCK")
    provider.publish(result)
    for tick in range(3):
        sample = (provider.sample_for_game("reusable-custom-game", tick_id=tick) if method == "sample_for_game"
                  else getattr(provider, method)(tick_id=tick))
        if isinstance(sample, tuple):
            sample = sample[0]
        assert sample.hand_valid and sample.hand_y == -1.0
        assert sample.hand_gesture is HandGesture.FIST
        assert sample.fist_event is (tick == 0)


def test_board_game_classification_duplicate_mismatch_expiry_and_pause():
    from pynq_multimodal_game.game_sdk import HandGesture
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    now = [1.0]
    provider = GameVisionInputProvider(clock=lambda: now[0])
    result = packet(direction="IDLE")
    result.update(frame=1, stable="5", rps="PAPER")
    provider.publish(result)
    assert provider.sample_for_game("game2", tick_id=0)[0].hand_gesture == HandGesture.PAPER
    duplicate = copy.deepcopy(result)
    duplicate.update(stable="0", rps="ROCK")
    provider.publish(duplicate)
    assert provider.sample_for_game("game2", tick_id=1)[0].hand_gesture == HandGesture.PAPER
    mismatch = packet(frame=2)
    mismatch.update(frame=3, stable="2", rps="SCISSORS")
    provider.publish(mismatch)
    assert provider.sample_for_game("game2", tick_id=2)[0].hand_gesture is None
    now[0] = 2.21
    assert not provider.sample_for_game("game2", tick_id=3)[0].hand_valid
    provider.suspend()
    provider.resume()
    provider.publish(result)
    assert provider.sample_for_game("game2", tick_id=4)[0].hand_gesture is None


@pytest.mark.parametrize("stable,label", [("PENDING", "UNKNOWN"), ("5", "ROCK"),
                                         ([], "PAPER"), (None, "PAPER")])
def test_board_game_unknown_new_classification_releases_previous(stable, label):
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    provider = GameVisionInputProvider(clock=lambda: 1.0)
    first = packet(direction="IDLE")
    first.update(stable="5", rps="PAPER")
    provider.publish(first)
    assert provider.sample_for_game("game2", tick_id=0)[0].hand_gesture is not None
    second = packet(frame=2, direction="IDLE")
    second.update(stable=stable, rps=label)
    provider.publish(second)
    sample, receipt = provider.sample_for_game("game2", tick_id=1)
    assert sample.hand_gesture is None and sample.gesture_changed
    assert receipt["source_frame_id"] == 2


@pytest.mark.parametrize("game_id", ["game1", "game2", "game3"])
def test_board_game_legacy_edge_is_delivered_once_without_game_specific_filter(game_id):
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    provider = GameVisionInputProvider(clock=lambda: 1.0)
    provider.publish(packet())
    provider.sample_for_game(game_id, tick_id=0)
    provider.publish(action_packet(frame=2, seq=1))
    sample, receipt = provider.sample_for_game(game_id, tick_id=1)
    assert sample.fist_event
    assert receipt["action_consumed"]
    assert not provider.sample_for_game(game_id, tick_id=2)[0].fist_event
    provider.publish(action_packet(frame=2, seq=1))
    assert not provider.sample_for_game(game_id, tick_id=3)[0].fist_event


@pytest.mark.parametrize("game_controls", [False, True])
def test_new_consumer_resumes_from_pause_without_old_action(game_controls):
    from pynq_multimodal_game.vision_input import GameVisionInputProvider, VisionInputProvider
    provider_type = GameVisionInputProvider if game_controls else VisionInputProvider
    provider = provider_type(clock=lambda: 1.0, fist_enabled=True)
    provider.publish(packet())
    provider.sample(tick_id=0)
    provider.suspend()
    provider.release("Game runtime stopped")
    assert not provider.sample(tick_id=0).hand_valid
    provider.resume()
    fresh = action_packet(frame=2, seq=1)
    fresh.update(stable="5", rps="PAPER")
    provider.publish(fresh)
    sample = (provider.sample_for_game("game2", tick_id=0)[0] if game_controls
              else provider.sample(tick_id=0))
    assert sample.hand_valid
    assert not sample.fist_event
    if game_controls:
        assert sample.hand_gesture.value == "paper"


def test_shared_vision_advertises_actual_provider_capabilities():
    from pynq_multimodal_game.agent.vision_backend import SharedVisionSupervisor
    from pynq_multimodal_game.vision_input import GameVisionInputProvider, VisionInputProvider

    for provider_type, mode, games in (
        (VisionInputProvider, "legacy_horizontal", []),
        (GameVisionInputProvider, "games", ["game1", "game2", "game3", "game4"]),
    ):
        provider = provider_type()
        supervisor = SharedVisionSupervisor(lambda run_id: None, provider)
        expected = {"schema": "local-game-vision-v1", "mode": mode, "games": games}
        assert supervisor.status()["input_capabilities"] == expected
        provider.capabilities["games"].append("unknown")
        assert supervisor.status()["input_capabilities"] == expected
