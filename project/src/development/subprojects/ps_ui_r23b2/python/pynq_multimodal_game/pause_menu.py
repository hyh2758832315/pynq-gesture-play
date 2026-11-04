"""Full-screen game pause controls; cached pixel page, no game assets copied."""
from dataclasses import replace

from .controls import StaleFlag
from .menu import BACK_TARGET, MenuIcon, MenuTarget
from .return_button import ReturnDwell, return_contains
from .gpu_abi import GpuCommand
from .return_button import add_return_progress_to_compiled

PAUSE_TARGETS = (BACK_TARGET,
    MenuTarget('resume', MenuIcon.GAME, 64, 94, hit_width=80, hit_height=54),
    MenuTarget('restart', MenuIcon.VIDEO, 160, 94, hit_width=80, hit_height=54),
    MenuTarget('main-menu', MenuIcon.HAND, 256, 94, hit_width=80, hit_height=54))
PAUSE_LABELS = ('CONTINUE', 'RESTART', 'MAIN MENU', 'PAUSED', 'HOLD 2 SEC')
RESULT_TITLES = {'WON': 'YOU WIN', 'LOST': 'GAME OVER', 'DRAW': 'DRAW'}
RESULT_TARGETS = (BACK_TARGET,
    MenuTarget('restart', MenuIcon.VIDEO, 96, 94, hit_width=80, hit_height=54),
    MenuTarget('main-menu', MenuIcon.HAND, 224, 94, hit_width=80, hit_height=54))


class PauseInput:
    def __init__(self, *, outcome=None):
        if outcome is not None and outcome not in RESULT_TITLES:
            raise ValueError('unsupported game outcome')
        self.outcome = outcome
        self.targets = PAUSE_TARGETS if outcome is None else RESULT_TARGETS
        self.dwell = ReturnDwell()
        self.hovered = None
        self.wait_exit = True
        self.timestamp_ns = 0

    @property
    def progress(self):
        return (0. if self.dwell.entered_ns is None else
                min(1., max(0., (self.timestamp_ns-self.dwell.entered_ns)/2_000_000_000)))

    def update(self, control):
        self.timestamp_ns = control.timestamp_ns
        valid = control.hand_valid and not control.stale_flags & (StaleFlag.GESTURE | StaleFlag.ADAPTER_ERROR)
        if not valid:
            self.hovered = None
            self.dwell.reset()
            return None
        x = round((control.hand_x + 1) * 319 / 2)
        y = round((control.hand_y + 1) * 179 / 2)
        # An end screen requires leaving every action before a fresh dwell.
        if self.wait_exit:
            if (return_contains(control) if self.outcome is None else
                    any(t.contains(x, y) for t in self.targets)):
                return None
            self.wait_exit = False
        target = next((t.item_id for t in self.targets if t.contains(x, y)), None)
        if target != self.hovered:
            self.dwell.reset()
            self.hovered = target
        if self.dwell.update(target is not None, control.timestamp_ns):
            return ('resume' if self.outcome is None else 'main-menu') if target == 'back' else target
        return None


class PauseRenderer:
    def __init__(self, *, outcome=None, score=0):
        if outcome is not None and outcome not in RESULT_TITLES:
            raise ValueError('unsupported game outcome')
        self.outcome = outcome
        if type(score) is not int or score < 0:
            raise ValueError('result score must be a non-negative integer')
        self.score = score
        self.targets = PAUSE_TARGETS if outcome is None else RESULT_TARGETS
        self.labels = (PAUSE_LABELS if outcome is None else
                       ('RESTART', 'MAIN MENU', RESULT_TITLES[outcome], 'HOLD 2 SEC'))
        from .creative_pages import PixelPageRenderer
        self.renderer = PixelPageRenderer()

    def compile(self, frame_id, generation, hovered=None, progress=0.):
        from .shell_pages import pause_page, highlight_frame
        frame = self.renderer.compile(pause_page(self.outcome, self.targets, None, self.score),
                                      frame_id, generation)
        target = next((t for t in self.targets if t.item_id == hovered), None)
        frame = highlight_frame(frame, target)
        if target is None:
            return frame
        if hovered == 'back':
            return add_return_progress_to_compiled(frame, progress)
        width = 20 if hovered == 'back' else 48
        x, y = target.center_x-width//2, (25 if hovered == 'back' else target.center_y+38)
        bars = [GpuCommand.fill_rect(x=x,y=y,width=width,height=2,token=12)]
        filled = min(width, max(0, round(width*progress)))
        if filled:
            bars.append(GpuCommand.fill_rect(x=x,y=y,width=filled,height=2,token=7))
        commands = (*frame.commands[:-1], *bars, frame.commands[-1])
        cycles = sum(8+(bar.words[3]&0xffff)*(bar.words[3]>>16) for bar in bars)
        return replace(frame, commands=commands, header=replace(frame.header,
            command_count=len(commands), predicted_cycles=frame.header.predicted_cycles+cycles))
