from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
import re


ACTION_SCHEMA = "game-actions-v1"
_ID = re.compile(r"[a-zA-Z0-9][a-zA-Z0-9._:-]{0,127}")


def valid_identity(value: object) -> bool:
    return type(value) is str and _ID.fullmatch(value) is not None


def validate_ns(value: object, name: str) -> None:
    if type(value) is not int or not 0 <= value < 2**63:
        raise ValueError(f"invalid {name}")


class ActionPhase(str, Enum):
    TRIGGER = "TRIGGER"
    STATE = "STATE"


@dataclass(frozen=True)
class GameAction:
    action_id: str
    sequence: int
    phase: ActionPhase
    active: bool
    deadline_ns: int | None = None
    source_sequence: int | None = None

    def __post_init__(self) -> None:
        if not valid_identity(self.action_id):
            raise ValueError("invalid action_id")
        validate_ns(self.sequence, "action sequence")
        if not isinstance(self.phase, ActionPhase) or type(self.active) is not bool:
            raise ValueError("invalid action phase or active flag")
        if self.phase is ActionPhase.TRIGGER and (not self.active or self.deadline_ns is not None):
            raise ValueError("trigger must be active and have no deadline")
        if self.deadline_ns is not None:
            validate_ns(self.deadline_ns, "action deadline")
        if self.phase is ActionPhase.STATE and self.active and self.deadline_ns is None:
            raise ValueError("active state requires a deadline")
        if self.source_sequence is not None:
            validate_ns(self.source_sequence, "source sequence")


@dataclass(frozen=True)
class GameActionFrame:
    game_id: str
    game_run: str
    action_epoch: str
    policy_id: str
    sample_tick: int
    sample_timestamp_ns: int
    status: str
    actions: tuple[GameAction, ...] = ()
    schema: str = ACTION_SCHEMA

    def __post_init__(self) -> None:
        if not all(valid_identity(value) for value in (
            self.game_id, self.game_run, self.action_epoch, self.policy_id
        )):
            raise ValueError("invalid action frame identity")
        validate_ns(self.sample_tick, "action sample tick")
        validate_ns(self.sample_timestamp_ns, "action sample time")
        if self.schema != ACTION_SCHEMA or self.status not in ("RUNNING", "WAITING", "FAULT", "STOPPED"):
            raise ValueError("unsupported action schema or status")
        if (type(self.actions) is not tuple or len(self.actions) > 16
                or any(type(action) is not GameAction for action in self.actions)):
            raise ValueError("invalid action frame capacity or items")
        if len({action.action_id for action in self.actions}) != len(self.actions):
            raise ValueError("duplicate action id in frame")
        if self.status != "RUNNING" and any(action.active for action in self.actions):
            raise ValueError("unhealthy frame cannot grant active actions")
        if any(action.deadline_ns is not None and action.active
               and action.deadline_ns <= self.sample_timestamp_ns for action in self.actions):
            raise ValueError("active action deadline expired")