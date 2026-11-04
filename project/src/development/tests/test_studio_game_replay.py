from pynq_multimodal_game.game import GameStatus, game_state_hash
from pynq_multimodal_game.scene import LOGICAL_HEIGHT, LOGICAL_WIDTH
from pynq_multimodal_game.studio.game_replay import DemoReplaySession


def test_demo_replay_matches_frozen_c1_golden() -> None:
    session = DemoReplaySession()

    first = session.step()
    assert first is not None
    assert first.position == 1
    assert first.frame_crc32 == 321335971

    final = session.run_to_end()
    assert final.position == 330
    assert final.status is GameStatus.WON
    assert final.score == 40
    assert final.frame_crc32 == 2706781308
    assert len(final.rgb) == LOGICAL_WIDTH * LOGICAL_HEIGHT * 3
    assert game_state_hash(session.state) == (
        "af10ca2b7564ad16fb59b0ed8bc730335975e618dfc47b3c950de553ac2abd86"
    )
    assert session.step() is None


def test_demo_replay_reset_restores_initial_state() -> None:
    session = DemoReplaySession()
    initial_state = session.state
    session.step()
    session.reset()

    assert session.position == 0
    assert session.current_frame is None
    assert session.finished is False
    assert session.state == initial_state