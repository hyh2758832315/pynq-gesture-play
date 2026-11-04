"""Small HDMI startup display and ordered checks, with no hardware side effects."""

from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
import math
from typing import Callable, Sequence

from .menu import MENU_BACKGROUND, MenuAssets, _MENU_GLYPHS, create_menu_assets
from .scene import IndexedImage, Scene, SpriteDescriptor, PalettePack
from .shell_theme import PALETTE, draw_wordmark, wordmark
from .scene_compiler import SceneCompiler


class CheckState(str, Enum):
    WAIT = "WAIT"
    CHECK = "CHECK"
    OK = "OK"
    FAIL = "FAIL"
    SKIP = "SKIP"


STAGES = ("GPU", "LIBRARY", "VISION", "HAND")
_CAPTIONS = ("PREPARING DISPLAY", "LOADING GAMES", "STARTING VISION", "CHECKING HAND",
             "DISPLAY FAILED", "GAMES CHECK FAILED", "VISION CHECK FAILED", "HAND CHECK FAILED",
             "GETTING READY")


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
                result = check()
                if result is CheckState.SKIP and index == 3:
                    states[index] = CheckState.SKIP
                    self.snapshot = StartupSnapshot(tuple(states))
                    publish(self.snapshot)
                    continue
                if result is not True:
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
    """Dedicated full-screen loader: one small atlas, scene-only animation.

    The bar is deliberately simulated; it never authorizes leaving startup.
    """
    WIDTH, HEIGHT = 256, 228

    def __init__(self) -> None:
        pixels = bytearray(self.WIDTH * self.HEIGHT)
        def text(value, y, scale=1, color=9):
            for index, character in enumerate(value):
                glyph = _MENU_GLYPHS[character]
                for row, cells in enumerate(glyph):
                    for column, on in enumerate(cells):
                        if on == '1':
                            for dy in range(scale):
                                for dx in range(scale):
                                    pixels[(y+row*scale+dy)*self.WIDTH+index*4*scale+column*scale+dx] = color
        text('LOADING', 0, 4)
        text('START FAIL', 20, 4, 6)
        for index, caption in enumerate(_CAPTIONS):
            text(caption, 80+index*10, 2, 8)
        text('CHECK STUDIO',171,1,8)
        for y in range(12):
            for x in range(216):
                pixels[(40+y)*self.WIDTH+x] = 12 if x in (0,215) or y in (0,11) else 2
        for y in range(8):
            for x in range(212):
                pixels[(52+y)*self.WIDTH+x] = 7
                pixels[(64+y)*self.WIDTH+x] = 6
            for x in range(220,224):
                pixels[(52+y)*self.WIDTH+x] = 2
        for y in range(4):
            for x in range(4):
                pixels[(60+y)*self.WIDTH+x] = 7
        draw_wordmark(pixels,0,176,stride=self.WIDTH)
        base = create_menu_assets()
        self.assets = MenuAssets(IndexedImage(self.WIDTH,self.HEIGHT,bytes(pixels)),
                                 base.tile_atlas,PalettePack((PALETTE,)))
        self.compiler = SceneCompiler(sprite_atlas=self.assets.sprite_atlas,
            tile_atlas=self.assets.tile_atlas,palettes=self.assets.palettes)

    @staticmethod
    def visual_progress(snapshot, elapsed_seconds):
        if not snapshot.error and all(s in (CheckState.OK,CheckState.SKIP) for s in snapshot.states):
            return 1.0
        return .08 + .87 * (1-math.exp(-max(0.,elapsed_seconds)/10.))

    def scene(self, snapshot: StartupSnapshot, *, frame_id: int, elapsed_seconds=0.) -> Scene:
        sprites=[]
        def sprite(x,y,w,h,ax,ay):
            sprites.append(SpriteDescriptor(x,y,w,h,ax,ay,0,10+len(sprites)))
        failed = bool(snapshot.error)
        logo_w,logo_h,_=wordmark()
        sprite((320-logo_w)//2,14,logo_w,logo_h,0,176)
        if failed:
            sprite(82,78,156,20,0,20)
        else:
            sprite(92,78,108,20,0,0)
            for dot in range(int(max(0.,elapsed_seconds)*2)%4):
                sprite(208+dot*8,94,4,4,0,60)
        sprite(52,112,216,12,0,40)
        fill=max(1,round(212*self.visual_progress(snapshot,elapsed_seconds)))
        sprite(54,114,fill,8,0,64 if failed else 52)
        if not failed and fill<212:
            # A small travelling glint keeps long initialization visibly alive
            # even as the simulated fill eases towards its 95% ceiling.
            glint=int(max(0.,elapsed_seconds)*24)%max(1,fill-3)
            sprite(54+glint,114,min(4,fill),8,220,52)
        if failed:
            stage=next((i for i,s in enumerate(snapshot.states) if s is CheckState.FAIL),0)+4
        else:
            stage=next((i for i,s in enumerate(snapshot.states) if s is CheckState.CHECK),
                       next((i for i,s in enumerate(snapshot.states) if s is CheckState.WAIT),8))
        caption=_CAPTIONS[stage]
        sprite((320-(len(caption)*8-2))//2,136,len(caption)*8-2,10,0,80+stage*10)
        if failed:
            sprite(136,158,47,5,0,171)
        return Scene(frame_id=frame_id,camera_x=0,background_color=PALETTE[1],sprites=tuple(sprites))

    def compile(self, snapshot: StartupSnapshot, *, frame_id: int, generation: int, elapsed_seconds=0.):
        return self.compiler.compile(self.scene(snapshot,frame_id=frame_id,elapsed_seconds=elapsed_seconds),
            submit_seq=0xC6A20000+frame_id,palette_generation=generation,
            asset_generation=generation,tilemap_generation=generation)
