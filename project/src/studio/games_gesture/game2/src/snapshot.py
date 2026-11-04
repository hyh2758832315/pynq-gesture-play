import hashlib
import json

from pynq_multimodal_game.game_sdk import GameSnapshot


def build_snapshot(match) -> GameSnapshot:
    values = {
        "phase": match.phase,
        "round_index": match.round_index,
        "rounds_completed": len(match.history),
        "human_wins": match.human_wins,
        "robot_wins": match.robot_wins,
        "draws": sum(record["outcome"] == "DRAW" for record in match.history),
        "countdown_remaining": match.countdown_remaining,
        "stable_ticks": match.stable_ticks,
        "stability_required": match.stability_ticks,
        "human_live": None if match.human_live is None else match.human_live.value,
        "human_locked": None if match.human_locked is None else match.human_locked.value,
        "robot_locked": None if match.robot_locked is None else match.robot_locked.value,
        "outcome": match.outcome,
        "round_history": [dict(record) for record in match.history],
    }
    values["state_sha256"] = hashlib.sha256(json.dumps(values, sort_keys=True, separators=(",", ":")).encode()).hexdigest()
    return GameSnapshot(max(0, match.tick_id), match.status, match.human_wins, values)