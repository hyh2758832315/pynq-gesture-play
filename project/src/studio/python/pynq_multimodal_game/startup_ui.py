"""Small HDMI startup display and ordered checks, with no hardware side effects."""

from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
from typing import Callable, Sequence

from .menu import (
    ICON_SIZE, MENU_BACKGROUND, MenuIcon, _GRID_CENTERS,
    _ICON_INDEX, _LABEL_Y, create_menu_assets,
)
from .return_button import RETURN_SIZE
from .scene import Scene, SpriteDescriptor
from .scene_compiler import SceneCompiler


class CheckState(str, Enum):
    WAIT = "WAIT"
    CHECK = "CHECK"
    OK = "OK"
    FAIL = "FAIL"


STAGES = ("GPU", "LIBRARY", "VISION", "HAND")
_ICONS = (MenuIcon.GAME, MenuIcon.VIDEO, MenuIcon.HAND, MenuIcon.RESERVED)
_STATES = tuple(CheckState)
_DISPLAY_STAGES = ("GPU", "LIB", "VISION", "HAND")
_DISPLAY_STATES = ("WAIT", "RUN", "OK", "FAIL")
_LABELS = tuple(f"{stage} {state}" for stage in _DISPLAY_STAGES
                for state in _DISPLAY_STATES)


@dataclass(frozen=True)
class StartupSnapshot:
    states: tuple[CheckState, CheckState, CheckState, CheckState] = (
        CheckState.WAIT, CheckState.WAIT, CheckState.WAIT, CheckState.WAIT,
    )
    error: str | None = None


class StartupSequence:
    """Publish each transition before and after a check; stop on first failure."""

    def __init__(self, checks: Sequence[tuple[str, Callable[[], object]]]) -> None:
        if tuple(name for name, _ in checks) != STAGES:
            raise ValueError("startup checks must be GPU, LIBRARY, VISION, HAND")
        self._checks = tuple(checks)
        self.snapshot = StartupSnapshot()

    def run(self, publish: Callable[[StartupSnapshot], None]) -> StartupSnapshot:
        states = list(self.snapshot.states)
        publish(self.snapshot)
        for index, (_, check) in enumerate(self._checks):
            states[index] = CheckState.CHECK
            self.snapshot = StartupSnapshot(tuple(states))
            publish(self.snapshot)
            try:
                if check() is not True:
                    raise RuntimeError(f"{STAGES[index]} check did not return verified readiness")
            except Exception as error:
                states[index] = CheckState.FAIL
                self.snapshot = StartupSnapshot(tuple(states), f"{type(error).__name__}: {error}")
                publish(self.snapshot)
                raise
            states[index] = CheckState.OK
            self.snapshot = StartupSnapshot(tuple(states))
            publish(self.snapshot)
        return self.snapshot


class StartupRenderer:
    """One atlas upload; each progress update changes only the scene packet."""

    def __init__(self) -> None:
        self.assets = create_menu_assets(_LABELS)
        self.compiler = SceneCompiler(
            sprite_atlas=self.assets.sprite_atlas,
            tile_atlas=self.assets.tile_atlas,
            palettes=self.assets.palettes,
        )

    def scene(self, snapshot: StartupSnapshot, *, frame_id: int) -> Scene:
        sprites = [SpriteDescriptor(
            x=0, y=0, width=RETURN_SIZE, height=RETURN_SIZE,
            atlas_x=_ICON_INDEX[MenuIcon.BACK] * ICON_SIZE, atlas_y=0,
            palette_bank=0, priority=10,
        )]
        for index, (state, icon, center) in enumerate(zip(snapshot.states, _ICONS, _GRID_CENTERS)):
            x, y = center
            sprites.append(SpriteDescriptor(
                x=x - ICON_SIZE // 2, y=y - ICON_SIZE // 2,
                width=ICON_SIZE, height=ICON_SIZE,
                atlas_x=_ICON_INDEX[icon] * ICON_SIZE,
                atlas_y=ICON_SIZE if state is CheckState.CHECK else 0,
                palette_bank=0, priority=11 + index,
            ))
            label = _LABELS[index * len(_STATES) + _STATES.index(state)]
            sprites.append(SpriteDescriptor(
                x=x - (len(label) * 4 - 1) // 2, y=y + 27,
                width=len(label) * 4 - 1, height=5,
                atlas_x=0,
                atlas_y=_LABEL_Y + (index * len(_STATES) + _STATES.index(state)) * 5,
                palette_bank=0, priority=20 + index,
            ))
        return Scene(frame_id=frame_id, camera_x=0,
                     background_color=MENU_BACKGROUND, sprites=tuple(sprites))

    def compile(self, snapshot: StartupSnapshot, *, frame_id: int, generation: int):
        return self.compiler.compile(
            self.scene(snapshot, frame_id=frame_id), submit_seq=0xC6A20000 + frame_id,
            palette_generation=generation, asset_generation=generation,
            tilemap_generation=generation,
        )
