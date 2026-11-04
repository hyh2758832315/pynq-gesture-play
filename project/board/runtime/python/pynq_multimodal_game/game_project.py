from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path


_MANIFEST_TEMPLATE = """[package]
schema_version = 1
id = "{game_id}"
display_name = "{display_name}"
version = "0.1.0"
entrypoint = "src.main:create_game"

[runtime]
sdk_major = 1
sdk_minor = 1
tick_hz = 60
render_hz = 60
logical_width = 320
logical_height = 180

[target]
build_id = 3221620480
abi_major = 1
abi_minor = 0
"""

_BLANK_MAIN_TEMPLATE = """from pynq_multimodal_game.game_sdk import GameAssets, GameContext, GameInput, GameSnapshot
from pynq_multimodal_game.scene import IndexedImage, PalettePack, Scene


class Game:
    def __init__(self) -> None:
        self._tick = 0
        self._x = 160
        self._y = 90

    def reset(self, context: GameContext) -> GameSnapshot:
        self._tick = 0
        self._x = context.logical_width // 2
        self._y = context.logical_height // 2
        return self.snapshot()

    def step(self, game_input: GameInput) -> GameSnapshot:
        self._tick = game_input.tick_id
        if game_input.hand_valid:
            self._x = round((game_input.hand_x + 1.0) * 159.5)
            self._y = round((game_input.hand_y + 1.0) * 89.5)
        return self.snapshot()

    def build_scene(self) -> Scene:
        return Scene(
            frame_id=self._tick,
            camera_x=0,
            background_color=(12, 24, 36),
        )

    def assets(self) -> GameAssets:
        empty = IndexedImage(1, 1, b"\\x00")
        palette = tuple((0, 0, 0) for _ in range(16))
        return GameAssets(empty, empty, PalettePack((palette,)))

    def snapshot(self) -> GameSnapshot:
        return GameSnapshot(
            tick_id=self._tick,
            status="RUNNING",
            values={"x": self._x, "y": self._y},
        )

    def close(self) -> None:
        pass


def create_game() -> Game:
    return Game()
"""

_SIDE_SCROLLER_MAIN_TEMPLATE = """from pynq_multimodal_game.controls import Direction
from pynq_multimodal_game.engine.side_scroller import (
    SideScrollerCommand,
    SideScrollerConfig,
    SideScrollerEngine,
    game_state_hash,
)
from pynq_multimodal_game.game_sdk import GameAssets, GameContext, GameInput, GameSnapshot
from pynq_multimodal_game.scene import HudState, IndexedImage, PalettePack, Scene, SpriteDescriptor


class Game:
    def __init__(self) -> None:
        self._engine = SideScrollerEngine(
            SideScrollerConfig(level_length=304, move_units_per_tick=4)
        )
        self._state = self._engine.initial_state()

    def reset(self, context: GameContext) -> GameSnapshot:
        self._state = self._engine.initial_state()
        return self.snapshot()

    def step(self, game_input: GameInput) -> GameSnapshot:
        direction = Direction.IDLE
        if game_input.hand_valid:
            if abs(game_input.hand_x) >= abs(game_input.hand_y) and abs(game_input.hand_x) >= 0.35:
                direction = Direction.LEFT if game_input.hand_x < 0 else Direction.RIGHT
            elif abs(game_input.hand_y) >= 0.35:
                direction = Direction.UP if game_input.hand_y < 0 else Direction.DOWN
        tone = game_input.tone
        self._state = self._engine.step(
            self._state,
            SideScrollerCommand(
                tick_id=game_input.tick_id,
                direction=direction,
                jump=game_input.fist_event,
                shield=bool(tone and tone.active and tone.frequency_hz <= 500.0),
                attack=bool(
                    tone
                    and tone.active
                    and tone.started
                    and tone.frequency_hz >= 1000.0
                ),
            ),
        )
        return self.snapshot()

    def build_scene(self) -> Scene:
        camera_x = max(0, self._state.world_x - 112)
        return Scene(
            frame_id=self._state.tick_id,
            camera_x=camera_x,
            background_color=(20, 36, 52),
            sprites=(
                SpriteDescriptor(
                    x=self._state.world_x,
                    y=86 + self._state.lane_y - min(12, self._state.z // 12),
                    width=8,
                    height=8,
                    atlas_x=0,
                    atlas_y=0,
                    palette_bank=0,
                    priority=1,
                ),
            ),
            hud=HudState(
                score=self._state.score,
                health=self._state.health,
                max_health=self._engine.config.max_health,
                shield_energy=self._state.shield_energy,
                max_shield_energy=self._engine.config.max_shield_energy,
                attack_cooldown=self._state.attack_cooldown,
                max_attack_cooldown=self._engine.config.attack_cooldown_ticks,
                progress=self._state.world_x,
                progress_max=self._engine.config.level_length,
                hand_valid=True,
                audio_valid=True,
            ),
        )

    def assets(self) -> GameAssets:
        sprite = IndexedImage(8, 8, bytes([1] * 64))
        tile = IndexedImage(1, 1, b"\\x00")
        palette = ((0, 0, 0), (91, 214, 176)) + tuple((0, 0, 0) for _ in range(14))
        return GameAssets(sprite, tile, PalettePack((palette,)))

    def snapshot(self) -> GameSnapshot:
        return GameSnapshot(
            tick_id=max(0, self._state.tick_id),
            status=self._state.status.value,
            score=self._state.score,
            values={
                "world_x": self._state.world_x,
                "lane_y": self._state.lane_y,
                "state_sha256": game_state_hash(self._state),
            },
        )

    def close(self) -> None:
        pass


def create_game() -> Game:
    return Game()
"""

_PROJECT_TEMPLATES = {
    "blank": _BLANK_MAIN_TEMPLATE,
    "side-scroller": _SIDE_SCROLLER_MAIN_TEMPLATE,
}


@dataclass(frozen=True)
class GameProject:
    root: Path

    @classmethod
    def create(
        cls,
        root: Path,
        *,
        game_id: str,
        display_name: str,
        template: str = "blank",
    ) -> GameProject:
        try:
            main_template = _PROJECT_TEMPLATES[template]
        except KeyError as error:
            raise ValueError(f"unknown game project template: {template}") from error
        root = Path(root)
        if root.exists() and any(root.iterdir()):
            raise FileExistsError("game project directory is not empty")
        root.mkdir(parents=True, exist_ok=True)
        source = root / "src"
        source.mkdir()
        (source / "__init__.py").write_text("", encoding="utf-8")
        (source / "main.py").write_text(main_template, encoding="utf-8")
        (root / "assets").mkdir()
        (root / "tests" / "replays").mkdir(parents=True)
        escaped_name = display_name.replace("\\", "\\\\").replace('"', '\\"')
        manifest = _MANIFEST_TEMPLATE.format(
            game_id=game_id, display_name=escaped_name
        )
        (root / "game.toml").write_text(manifest, encoding="utf-8")
        return cls(root)

    @property
    def manifest_path(self) -> Path:
        return self.root / "game.toml"

    def source_files(self) -> tuple[Path, ...]:
        return tuple(sorted((self.root / "src").rglob("*.py")))
