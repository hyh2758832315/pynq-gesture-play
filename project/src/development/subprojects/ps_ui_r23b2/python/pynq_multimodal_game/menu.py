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
    CANVAS = "canvas"
    ALBUM = "album"
    HAND_DEMO = "hand-demo"


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
_HAND_POSES = ("default", "paper", "scissors", "rock")
_HAND_POSE_INDEX = {f"hand:{pose}": index for index, pose in enumerate(_HAND_POSES)}


@dataclass(frozen=True)
class MenuTarget:
    item_id: str
    icon: MenuIcon
    center_x: int
    center_y: int
    hit_radius: int = 34
    enabled: bool = True
    hit_width: int | None = None
    hit_height: int | None = None

    def __post_init__(self) -> None:
        if not self.item_id:
            raise ValueError("menu target item_id must not be empty")
        if self.hit_radius <= 0:
            raise ValueError("menu target hit_radius must be positive")
        if (self.hit_width is None) != (self.hit_height is None):
            raise ValueError('rectangle targets require both dimensions')

    def contains(self, x: int, y: int) -> bool:
        if self.hit_width is not None:
            return abs(x-self.center_x)<=self.hit_width/2 and abs(y-self.center_y)<=self.hit_height/2
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
    MenuTarget("games", MenuIcon.GAME, 86, 83, hit_width=132, hit_height=46),
    MenuTarget("videos", MenuIcon.VIDEO, 234, 83, hit_width=132, hit_height=46),
    MenuTarget("hand", MenuIcon.HAND, 86, 139, hit_width=132, hit_height=46),
    MenuTarget("canvas", MenuIcon.RESERVED, 234, 139, hit_width=132, hit_height=46),
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
        self._confirm_pending = None
        self._last_control_ns = None
        self.confirm_armed = True
        self._release_since = None
        self._release_frame = None

    @property
    def hovered_id(self) -> str | None:
        return self._hovered_id

    @property
    def return_progress(self):
        return self._return_dwell.progress

    def reset(self, *, require_release=False) -> None:
        self._candidate_id = None
        self._candidate_ticks = 0
        self._hovered_id = None
        self._confirm_pending = None
        self._last_control_ns = None
        self._return_dwell.reset()
        self._release_since = self._release_frame = None
        if require_release:
            self.confirm_armed = False

    def update(
        self,
        control: ControlState,
        targets: Sequence[MenuTarget] = HOME_TARGETS,
        *, observation=None,
    ) -> MenuInteraction:
        stale = control.stale_flags & (StaleFlag.GESTURE | StaleFlag.ADAPTER_ERROR)
        if self._last_control_ns is not None and control.timestamp_ns < self._last_control_ns:
            self._confirm_pending = None
            self._return_dwell.reset()
            return MenuInteraction(None, None, None, None)
        self._last_control_ns = control.timestamp_ns
        if not control.hand_valid or stale:
            self._release_since = self._release_frame = None
            self._candidate_id = None
            self._candidate_ticks = 0
            self._hovered_id = None
            self._return_dwell.reset()
            self._confirm_pending = None
            return MenuInteraction(None, None, None, None)

        if not self.confirm_armed:
            # A fresh, sustained release rearms the next page. UNKNOWN, old
            # observations and repeated polls cannot turn a held fist into a click.
            released = not control.fist_event and control.fist_score < .25
            frame = control.timestamp_ns
            if observation is not None:
                source_at = observation.get('source_at')
                released = (released and observation.get('valid') is True
                    and observation.get('gesture') in ('paper','scissors')
                    and isinstance(source_at,(int,float))
                    and 0 <= control.timestamp_ns/1e9-source_at < .5)
                frame=(observation.get('run_id'),observation.get('config_epoch'),observation.get('frame_id'))
            if observation is not None and control.fist_event and control.gesture_seq > self._last_activation_seq:
                # The provider's edge already requires two fresh release frames;
                # this also handles its valid UI-only pointer at camera edges.
                self.confirm_armed=True
                self._release_since=self._release_frame=None
            elif not released:
                self._release_since = self._release_frame = None
            elif self._release_since is None or control.timestamp_ns-self._release_since > 1_000_000_000:
                self._release_since=control.timestamp_ns
                self._release_frame=frame
            elif frame != self._release_frame and control.timestamp_ns-self._release_since>=80_000_000:
                self.confirm_armed=True
                self._release_since=self._release_frame=None

        hand_x = -control.hand_x if self.mirror_horizontal else control.hand_x
        pointer_x = round((hand_x + 1.0) * (LOGICAL_WIDTH - 1) / 2.0)
        pointer_y = round((control.hand_y + 1.0) * (LOGICAL_HEIGHT - 1) / 2.0)
        candidate = next(
            (target.item_id for target in targets if target.enabled and target.contains(pointer_x, pointer_y)),
            None,
        )
        # Retain a confirmed icon across a few pixels of edge jitter. Never
        # transfer the confirmation to another target or expand the back hitbox.
        if candidate is None and self._hovered_id not in (None, 'back'):
            old = next((target for target in targets if target.enabled
                        and target.item_id == self._hovered_id), None)
            if old is not None and (old.contains(pointer_x,pointer_y) if old.hit_width is not None else
                    (pointer_x-old.center_x)**2 + (pointer_y-old.center_y)**2 <= (old.hit_radius+6)**2):
                candidate = old.item_id
        if self._confirm_pending is not None and (
                self._confirm_pending[0] != candidate
                or control.timestamp_ns > self._confirm_pending[2]):
            self._confirm_pending = None
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
            (control.fist_event or control.fist_score >= 1.0)
            and candidate is not None
            and candidate != "back"
            and self.confirm_armed
        ):
            self._confirm_pending = (candidate, control.gesture_seq,
                                     control.timestamp_ns + 200_000_000)
        if self._confirm_pending is not None and self._hovered_id == self._confirm_pending[0]:
            activated = self._hovered_id
            self._last_activation_seq = self._confirm_pending[1]
            self._confirm_pending = None
            self.confirm_armed = False
            self._release_since = self._release_frame = None
        return MenuInteraction(self._hovered_id, activated, pointer_x, pointer_y)


def create_menu_assets(label_texts: Sequence[str] = (), *, hand_poses: bool = False, canvas_home: bool = False) -> MenuAssets:
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
                MenuIcon.HAND if hand_poses and icon is not MenuIcon.BACK else icon,
                selected=selected,
                canvas_home=canvas_home,
                hand_pose=_HAND_POSES[index] if hand_poses and icon is not MenuIcon.BACK else "paper",
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
        MenuTarget(item_id, kind, 160, 58+index*32, hit_width=264, hit_height=26)
        for index, item_id in enumerate(selected)
    )
    return (BACK_TARGET, *targets)


def video_page_targets(item_ids: Sequence[str], *, page: int = 0) -> tuple[MenuTarget, ...]:
    """Expose every installed video with the existing four tile positions."""
    if len(item_ids) <= len(_GRID_CENTERS):
        if page != 0:
            raise ValueError("single-page video library has no later page")
        return library_targets(MenuIcon.VIDEO,
                               tuple(f"video:{item_id}" for item_id in item_ids))
    pages = (len(item_ids) + 1) // 2
    if not 0 <= page < pages:
        raise ValueError("video page is out of range")
    visible = item_ids[page * 2 : page * 2 + 2]
    targets = [MenuTarget(f"video:{item_id}", MenuIcon.VIDEO,160,70+index*44,hit_width=264,hit_height=34)
               for index,item_id in enumerate(visible)]
    if len(targets) == 1:
        targets.append(MenuTarget("video-slot:empty", MenuIcon.RESERVED,
                                  160,114,enabled=False,hit_width=264,hit_height=34))
    targets.extend((
        MenuTarget("video-page:prev", MenuIcon.RESERVED,
                   99,155,enabled=page > 0,hit_width=110,hit_height=24),
        MenuTarget("video-page:next", MenuIcon.RESERVED,
                   221,155,enabled=page + 1 < pages,hit_width=110,hit_height=24),
    ))
    return (BACK_TARGET, *targets)


def game_targets(item_ids: Sequence[str]) -> tuple[MenuTarget, ...]:
    """Four stable rectangular cards; missing games keep disabled placeholders."""
    targets = []
    for index, center in enumerate(((84,78),(236,78),(84,137),(236,137))):
        if index < min(4, len(item_ids)):
            targets.append(MenuTarget(f"game:{item_ids[index]}", MenuIcon.GAME, *center,hit_width=140,hit_height=52))
        else:
            targets.append(MenuTarget(f"game-slot:{index + 1}", MenuIcon.RESERVED,
                                      *center, enabled=False,hit_width=140,hit_height=52))
    return (BACK_TARGET, *targets)


def build_menu_scene(
    frame_id: int,
    targets: Sequence[MenuTarget] = HOME_TARGETS,
    *,
    hovered_id: str | None = None,
    animate: bool = True,
    label_texts: Sequence[str] = (),
    hand_poses: bool = False,
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
                atlas_x=(_HAND_POSE_INDEX.get(target.item_id, _ICON_INDEX[target.icon])
                         if hand_poses else _ICON_INDEX[target.icon]) * ICON_SIZE,
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


HAND_POSE_CAPTION = "INPUT POSE"
HAND_STATUS_LABELS = (
    "VISION ONLY", "MOCK WAIT", "MOCK ACTIVE", "MOCK CLOSED", "MOCK FAULT",
    "HAND WAIT", "HAND CHECK", "HAND ACTIVE", "HAND STOP", "HAND OFF", "HAND FAULT", "STATE ERROR",
)


def hand_session_label(status: Mapping[str, object] | None) -> str:
    """Describe the owner lifecycle; pose tiles continue to show visual input."""
    if not isinstance(status, Mapping):
        return "VISION ONLY"
    mode, phase = status.get("mode"), status.get("phase")
    fault = phase == "FAULT" or bool(status.get("error"))
    if mode == "memory-only":
        return ("MOCK FAULT" if fault else "MOCK CLOSED" if phase == "CLOSED"
                else "MOCK ACTIVE" if phase == "ACTIVE" else "MOCK WAIT")
    if mode != "serial-fixed-playback":
        return "STATE ERROR" if fault else "VISION ONLY"
    if fault or (phase == "CLOSED" and status.get("release_confirmed") is not True
                 and status.get('release_not_required') is not True):
        return "HAND FAULT"
    return {"STARTING": "HAND CHECK", "ACTIVE": "HAND ACTIVE",
            "PAUSING": "HAND STOP", "PAUSED": "HAND OFF", "RESUMING": "HAND CHECK",
            "CLOSING": "HAND STOP", "VERIFYING_RELEASE": "HAND STOP",
            "CLOSED": "HAND OFF"}.get(phase, "HAND WAIT")


def _draw_icon(
    pixels: bytearray,
    stride: int,
    origin_x: int,
    origin_y: int,
    icon: MenuIcon,
    *,
    selected: bool,
    hand_pose: str = "paper",
    canvas_home: bool = False,
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
        _hand_glyph(pixels, stride, origin_x, origin_y, pose=hand_pose)
    elif icon is MenuIcon.RESERVED:
        if canvas_home:
            _rect(pixels,stride,origin_x+12,origin_y+12,24,25,11)
            _rect(pixels,stride,origin_x+15,origin_y+15,18,19,12)
            for dx,dy,color in ((17,20,7),(26,20,13),(17,28,3),(26,28,5)):
                _rect(pixels,stride,origin_x+dx,origin_y+dy,5,5,color)
        else:
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


def _hand_glyph(pixels: bytearray, stride: int, ox: int, oy: int, *, pose: str = "paper") -> None:
    # Reuse the four non-back cells on the hand page; no larger atlas or
    # extra per-frame commands are needed for distinct pose silhouettes.
    if pose == "rock":
        for x, top in ((16, 20), (21, 18), (26, 18), (31, 20)):
            _rect(pixels, stride, ox + x, oy + top, 4, 27 - top, 11)
    elif pose == "scissors":
        for row in range(16):
            _rect(pixels, stride, ox + 16 + row // 5, oy + 10 + row, 4, 1, 11)
            _rect(pixels, stride, ox + 30 - row // 5, oy + 10 + row, 4, 1, 11)
        _rect(pixels, stride, ox + 28, oy + 24, 7, 5, 11)
    else:
        fingers = (((14, 21), (19, 18), (24, 17), (29, 19), (34, 22)) if pose == "default"
                   else ((14, 17), (19, 12), (24, 10), (29, 13), (34, 18)))
        for x, top in fingers:
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
