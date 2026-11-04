from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
import math
from typing import Mapping, Sequence

from .controls import ControlState, StaleFlag
from .return_button import RETURN_CENTER, RETURN_HIT_RADIUS, RETURN_SIZE, ReturnDwell
from .scene import (
    LOGICAL_HEIGHT,
    LOGICAL_WIDTH,
    IndexedImage,
    PalettePack,
    Scene,
    SpriteDescriptor,
)


ICON_SIZE = 48
ICONS_PER_ROW = 5
MENU_BACKGROUND = (13, 18, 27)
_GRID_CENTERS = ((92, 56), (228, 56), (92, 132), (228, 132))
_LABEL_Y = ICON_SIZE * 2
_LABEL_MAX_CHARACTERS = 11
_MENU_GLYPHS = {
    "0": ("111", "101", "101", "101", "111"),
    "1": ("010", "110", "010", "010", "111"),
    "2": ("111", "001", "111", "100", "111"),
    "3": ("111", "001", "111", "001", "111"),
    "4": ("101", "101", "111", "001", "001"),
    "5": ("111", "100", "111", "001", "111"),
    "6": ("111", "100", "111", "101", "111"),
    "7": ("111", "001", "010", "010", "010"),
    "8": ("111", "101", "111", "101", "111"),
    "9": ("111", "101", "111", "001", "111"),
    "A": ("010", "101", "111", "101", "101"),
    "B": ("110", "101", "110", "101", "110"),
    "C": ("111", "100", "100", "100", "111"),
    "D": ("110", "101", "101", "101", "110"),
    "E": ("111", "100", "110", "100", "111"),
    "F": ("111", "100", "110", "100", "100"),
    "G": ("111", "100", "101", "101", "111"),
    "H": ("101", "101", "111", "101", "101"),
    "I": ("111", "010", "010", "010", "111"),
    "J": ("001", "001", "001", "101", "111"),
    "K": ("101", "101", "110", "101", "101"),
    "L": ("100", "100", "100", "100", "111"),
    "M": ("101", "111", "111", "101", "101"),
    "N": ("101", "111", "111", "111", "101"),
    "O": ("111", "101", "101", "101", "111"),
    "P": ("111", "101", "111", "100", "100"),
    "Q": ("111", "101", "101", "111", "001"),
    "R": ("110", "101", "110", "101", "101"),
    "S": ("111", "100", "111", "001", "111"),
    "T": ("111", "010", "010", "010", "010"),
    "U": ("101", "101", "101", "101", "111"),
    "V": ("101", "101", "101", "101", "010"),
    "W": ("101", "101", "111", "111", "101"),
    "X": ("101", "101", "010", "101", "101"),
    "Y": ("101", "101", "010", "010", "010"),
    "Z": ("111", "001", "010", "100", "111"),
    "-": ("000", "000", "111", "000", "000"),
    " ": ("000", "000", "000", "000", "000"),
}


class MenuPage(str, Enum):
    HOME = "home"
    GAMES = "games"
    VIDEOS = "videos"
    HAND_PLACEHOLDER = "hand-placeholder"
    RESERVED = "reserved"


class MenuIcon(str, Enum):
    GAME = "game"
    VIDEO = "video"
    HAND = "hand"
    RESERVED = "reserved"
    BACK = "back"


_ICON_INDEX = {
    MenuIcon.GAME: 0,
    MenuIcon.VIDEO: 1,
    MenuIcon.HAND: 2,
    MenuIcon.RESERVED: 3,
    MenuIcon.BACK: 4,
}


@dataclass(frozen=True)
class MenuTarget:
    item_id: str
    icon: MenuIcon
    center_x: int
    center_y: int
    hit_radius: int = 34
    enabled: bool = True

    def __post_init__(self) -> None:
        if not self.item_id:
            raise ValueError("menu target item_id must not be empty")
        if self.hit_radius <= 0:
            raise ValueError("menu target hit_radius must be positive")

    def contains(self, x: int, y: int) -> bool:
        return (x - self.center_x) ** 2 + (y - self.center_y) ** 2 <= self.hit_radius**2


@dataclass(frozen=True)
class MenuInteraction:
    hovered_id: str | None
    activated_id: str | None
    pointer_x: int | None
    pointer_y: int | None


@dataclass(frozen=True)
class MenuAssets:
    sprite_atlas: IndexedImage
    tile_atlas: IndexedImage
    palettes: PalettePack
    label_texts: tuple[str, ...] = ()


BACK_TARGET = MenuTarget("back", MenuIcon.BACK, *RETURN_CENTER, hit_radius=RETURN_HIT_RADIUS)
HOME_TARGETS = (
    BACK_TARGET,
    MenuTarget("games", MenuIcon.GAME, *_GRID_CENTERS[0]),
    MenuTarget("videos", MenuIcon.VIDEO, *_GRID_CENTERS[1]),
    MenuTarget("hand", MenuIcon.HAND, *_GRID_CENTERS[2]),
    MenuTarget("reserved", MenuIcon.RESERVED, *_GRID_CENTERS[3]),
)


class MenuInputController:
    def __init__(self, *, stable_ticks: int = 3, mirror_horizontal: bool = False) -> None:
        if stable_ticks <= 0:
            raise ValueError("stable_ticks must be positive")
        self.stable_ticks = stable_ticks
        self.mirror_horizontal = mirror_horizontal
        self._candidate_id: str | None = None
        self._candidate_ticks = 0
        self._hovered_id: str | None = None
        self._last_activation_seq = -1
        self._return_dwell = ReturnDwell()

    @property
    def hovered_id(self) -> str | None:
        return self._hovered_id

    def reset(self) -> None:
        self._candidate_id = None
        self._candidate_ticks = 0
        self._hovered_id = None
        self._last_activation_seq = -1
        self._return_dwell.reset()

    def update(
        self,
        control: ControlState,
        targets: Sequence[MenuTarget] = HOME_TARGETS,
    ) -> MenuInteraction:
        stale = control.stale_flags & (StaleFlag.GESTURE | StaleFlag.ADAPTER_ERROR)
        if not control.hand_valid or stale:
            self._candidate_id = None
            self._candidate_ticks = 0
            self._hovered_id = None
            self._return_dwell.reset()
            return MenuInteraction(None, None, None, None)

        hand_x = -control.hand_x if self.mirror_horizontal else control.hand_x
        pointer_x = round((hand_x + 1.0) * (LOGICAL_WIDTH - 1) / 2.0)
        pointer_y = round((control.hand_y + 1.0) * (LOGICAL_HEIGHT - 1) / 2.0)
        candidate = next(
            (target.item_id for target in targets if target.enabled and target.contains(pointer_x, pointer_y)),
            None,
        )
        if candidate == self._candidate_id:
            self._candidate_ticks += 1
        else:
            self._candidate_id = candidate
            self._candidate_ticks = 1
        self._hovered_id = (
            candidate if candidate is not None and self._candidate_ticks >= self.stable_ticks else None
        )

        activated = None
        # Count from entry into the hit circle, not from the later visual
        # hover confirmation.  The back button itself does not use a fist.
        back_inside = candidate == "back"
        if self._return_dwell.update(back_inside, control.timestamp_ns):
            activated = "back"
        if (
            control.fist_event
            and self._hovered_id is not None
            and self._hovered_id != "back"
            and control.gesture_seq > self._last_activation_seq
        ):
            activated = self._hovered_id
            self._last_activation_seq = control.gesture_seq
        return MenuInteraction(self._hovered_id, activated, pointer_x, pointer_y)


def create_menu_assets(label_texts: Sequence[str] = ()) -> MenuAssets:
    normalized_labels = tuple(normalize_menu_label(text) for text in label_texts)
    width = ICON_SIZE * ICONS_PER_ROW
    height = ICON_SIZE * 2 + len(normalized_labels) * 5
    pixels = bytearray(width * height)
    for selected in (False, True):
        row_y = ICON_SIZE if selected else 0
        for icon, index in _ICON_INDEX.items():
            _draw_icon(
                pixels,
                width,
                index * ICON_SIZE,
                row_y,
                icon,
                selected=selected,
            )
    for index, text in enumerate(normalized_labels):
        _draw_label(pixels, width, 0, _LABEL_Y + index * 5, text)
    palettes = PalettePack(
        (
            (
                (0, 0, 0),
                MENU_BACKGROUND,
                (236, 244, 246),
                (33, 184, 168),
                (16, 110, 105),
                (239, 91, 79),
                (157, 47, 52),
                (244, 190, 62),
                (170, 116, 25),
                (126, 137, 151),
                (70, 79, 92),
                (255, 255, 255),
                (21, 27, 35),
                (52, 112, 226),
                (31, 71, 154),
                (127, 235, 224),
            ),
        )
    )
    return MenuAssets(
        sprite_atlas=IndexedImage(width, height, bytes(pixels)),
        tile_atlas=IndexedImage(1, 1, b"\x00"),
        palettes=palettes,
        label_texts=normalized_labels,
    )


def library_targets(
    kind: MenuIcon,
    item_ids: Sequence[str],
    *,
    page: int = 0,
) -> tuple[MenuTarget, ...]:
    if kind not in (MenuIcon.GAME, MenuIcon.VIDEO):
        raise ValueError("library targets support game or video entries")
    if page < 0:
        raise ValueError("page must be non-negative")
    start = page * len(_GRID_CENTERS)
    selected = item_ids[start : start + len(_GRID_CENTERS)]
    targets = tuple(
        MenuTarget(item_id, kind, *center)
        for item_id, center in zip(selected, _GRID_CENTERS)
    )
    return (BACK_TARGET, *targets)


def game_targets(item_ids: Sequence[str]) -> tuple[MenuTarget, ...]:
    """Three installable game slots plus one visibly unavailable future slot."""
    targets = []
    for index, center in enumerate(_GRID_CENTERS):
        if index < min(3, len(item_ids)):
            targets.append(MenuTarget(f"game:{item_ids[index]}", MenuIcon.GAME, *center))
        else:
            targets.append(MenuTarget(f"game-slot:{index + 1}", MenuIcon.RESERVED,
                                      *center, enabled=False))
    return (BACK_TARGET, *targets)


def build_menu_scene(
    frame_id: int,
    targets: Sequence[MenuTarget] = HOME_TARGETS,
    *,
    hovered_id: str | None = None,
    animate: bool = True,
    label_texts: Sequence[str] = (),
) -> Scene:
    sprites = []
    label_index = 0
    for index, target in enumerate(targets):
        selected = target.item_id == hovered_id
        float_offset = 0
        if animate and target.item_id != "back":
            float_offset = round(math.sin((frame_id + index * 7) / 12.0) * 2)
        size = RETURN_SIZE if target.icon is MenuIcon.BACK else ICON_SIZE
        sprites.append(
            SpriteDescriptor(
                x=target.center_x - size // 2,
                y=target.center_y - size // 2 + float_offset,
                width=size,
                height=size,
                atlas_x=_ICON_INDEX[target.icon] * ICON_SIZE,
                atlas_y=ICON_SIZE if selected else 0,
                palette_bank=0,
                priority=10 + index,
            )
        )
        if target.icon is MenuIcon.BACK:
            continue
        if label_index < len(label_texts):
            text = normalize_menu_label(label_texts[label_index])
            if text:
                label_width = len(text) * 4 - 1
                sprites.append(
                    SpriteDescriptor(
                        x=target.center_x - label_width // 2,
                        y=target.center_y + 27,
                        width=label_width,
                        height=5,
                        atlas_x=0,
                        atlas_y=_LABEL_Y + label_index * 5,
                        palette_bank=0,
                        priority=30 + index,
                    )
                )
        label_index += 1
    return Scene(
        frame_id=frame_id,
        camera_x=0,
        background_color=MENU_BACKGROUND,
        sprites=tuple(sprites),
    )


def normalize_menu_label(text: str) -> str:
    normalized = "".join(
        character if character in _MENU_GLYPHS else " "
        for character in text.upper()
    )
    return " ".join(normalized.split())[:_LABEL_MAX_CHARACTERS]


def placeholder_targets(page: MenuPage) -> tuple[MenuTarget, ...]:
    if page is MenuPage.HAND_PLACEHOLDER:
        icon = MenuIcon.HAND
    elif page is MenuPage.RESERVED:
        icon = MenuIcon.RESERVED
    else:
        raise ValueError("placeholder page must be hand or reserved")
    return (
        BACK_TARGET,
        MenuTarget(page.value, icon, LOGICAL_WIDTH // 2, LOGICAL_HEIGHT // 2, 40),
    )


def hand_display_targets() -> tuple[MenuTarget, ...]:
    """Four display-only poses; physical hand control is owned elsewhere."""
    return (BACK_TARGET, *(
        MenuTarget(f"hand:{pose}", MenuIcon.HAND, *center, enabled=False)
        for pose, center in zip(("default", "paper", "scissors", "rock"), _GRID_CENTERS)
    ))


def hand_display_selection(snapshot: Mapping[str, object] | None) -> str:
    gesture = snapshot.get("gesture") if isinstance(snapshot, Mapping) and snapshot.get("valid") is True else None
    return "hand:" + {"paper": "paper", "scissors": "scissors", "fist": "rock"}.get(gesture, "default")


def _draw_icon(
    pixels: bytearray,
    stride: int,
    origin_x: int,
    origin_y: int,
    icon: MenuIcon,
    *,
    selected: bool,
) -> None:
    if icon is MenuIcon.BACK:
        _draw_back_icon(pixels, stride, origin_x, origin_y, selected=selected)
        return
    colors = {
        MenuIcon.GAME: (3, 4),
        MenuIcon.VIDEO: (5, 6),
        MenuIcon.HAND: (7, 8),
        MenuIcon.RESERVED: (9, 10),
        MenuIcon.BACK: (13, 14),
    }
    fill, shadow = colors[icon]
    center = ICON_SIZE // 2
    for y in range(ICON_SIZE):
        for x in range(ICON_SIZE):
            distance = (x - center) ** 2 + (y - center) ** 2
            if distance <= 22**2:
                color = fill if y < center + 8 else shadow
                if distance >= 20**2:
                    color = 15 if selected else 2
                _set(pixels, stride, origin_x + x, origin_y + y, color)
    if icon is MenuIcon.GAME:
        _game_glyph(pixels, stride, origin_x, origin_y)
    elif icon is MenuIcon.VIDEO:
        _video_glyph(pixels, stride, origin_x, origin_y)
    elif icon is MenuIcon.HAND:
        _hand_glyph(pixels, stride, origin_x, origin_y)
    elif icon is MenuIcon.RESERVED:
        _more_glyph(pixels, stride, origin_x, origin_y)
    else:
        _back_glyph(pixels, stride, origin_x, origin_y)


def _draw_back_icon(pixels: bytearray, stride: int, ox: int, oy: int, *, selected: bool) -> None:
    center = RETURN_SIZE // 2
    for y in range(RETURN_SIZE):
        for x in range(RETURN_SIZE):
            distance = (x - center) ** 2 + (y - center) ** 2
            if distance <= 12**2:
                color = 13 if y < center + 4 else 14
                if distance >= 10**2:
                    color = 15 if selected else 2
                _set(pixels, stride, ox + x, oy + y, color)
    _rect(pixels, stride, ox + 6, oy + 10, 13, 4, 11)
    for offset in range(5):
        _rect(pixels, stride, ox + 5 + offset, oy + 11 - offset, 3, 2, 11)
        _rect(pixels, stride, ox + 5 + offset, oy + 11 + offset, 3, 2, 11)


def _game_glyph(pixels: bytearray, stride: int, ox: int, oy: int) -> None:
    _rect(pixels, stride, ox + 11, oy + 19, 26, 13, 11)
    _rect(pixels, stride, ox + 15, oy + 22, 3, 7, 12)
    _rect(pixels, stride, ox + 13, oy + 24, 7, 3, 12)
    _rect(pixels, stride, ox + 29, oy + 22, 3, 3, 12)
    _rect(pixels, stride, ox + 33, oy + 26, 3, 3, 12)


def _video_glyph(pixels: bytearray, stride: int, ox: int, oy: int) -> None:
    for row in range(18):
        width = row // 2 + 1 if row < 9 else (17 - row) // 2 + 1
        _rect(pixels, stride, ox + 19, oy + 15 + row, width + 6, 1, 11)


def _hand_glyph(pixels: bytearray, stride: int, ox: int, oy: int) -> None:
    # Five fingers and a palm, drawn inside the existing indexed icon cell.
    for x, top in ((14, 17), (19, 12), (24, 10), (29, 13), (34, 18)):
        _rect(pixels, stride, ox + x, oy + top, 3, 27 - top, 11)
    _rect(pixels, stride, ox + 15, oy + 25, 21, 10, 11)
    _rect(pixels, stride, ox + 11, oy + 23, 5, 7, 11)
    _rect(pixels, stride, ox + 18, oy + 35, 15, 3, 11)


def _more_glyph(pixels: bytearray, stride: int, ox: int, oy: int) -> None:
    for center_x in (17, 24, 31):
        _rect(pixels, stride, ox + center_x - 2, oy + 22, 4, 4, 11)


def _back_glyph(pixels: bytearray, stride: int, ox: int, oy: int) -> None:
    _rect(pixels, stride, ox + 14, oy + 22, 21, 5, 11)
    for offset in range(8):
        _rect(pixels, stride, ox + 12 + offset, oy + 17 + offset, 3, 3, 11)
        _rect(pixels, stride, ox + 12 + offset, oy + 30 - offset, 3, 3, 11)


def _draw_label(
    pixels: bytearray,
    stride: int,
    origin_x: int,
    origin_y: int,
    text: str,
) -> None:
    for character_index, character in enumerate(text):
        for row, bits in enumerate(_MENU_GLYPHS[character]):
            for column, enabled in enumerate(bits):
                if enabled == "1":
                    _set(
                        pixels,
                        stride,
                        origin_x + character_index * 4 + column,
                        origin_y + row,
                        2,
                    )


def _rect(
    pixels: bytearray,
    stride: int,
    x: int,
    y: int,
    width: int,
    height: int,
    color: int,
) -> None:
    for row in range(y, y + height):
        start = row * stride + x
        pixels[start : start + width] = bytes((color,)) * width


def _set(pixels: bytearray, stride: int, x: int, y: int, color: int) -> None:
    pixels[y * stride + x] = color
