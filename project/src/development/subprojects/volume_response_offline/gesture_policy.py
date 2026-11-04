"""Executable candidate for volume press/hold/release, not a deployed source.

Input is one fresh DC-removed hardware window, in unchanged mean_abs units.
No I/O, adaptive gain, FFT, history queue or claim of hardware ACK. Integration
requires an explicit new source contract; do not relabel these software edges
as the old VOL1 hardware-acked VolumeSignal.
"""
from dataclasses import dataclass
import math


@dataclass(frozen=True)
class GestureFrame:
    window: int
    soft_held: bool
    loud_held: bool
    edge: str | None
    ready_soft: bool
    ready_loud: bool
    reason: str


class VolumeGesturePolicy:
    def __init__(self, *, soft_on=16.0, soft_off=14.0, loud_on=28.0,
                 loud_off=24.0, press_windows=2, release_windows=2):
        values=(soft_on,soft_off,loud_on,loud_off)
        if (any(type(v) not in (int,float) or not math.isfinite(v) for v in values)
                or not 0 <= soft_off < soft_on < loud_off < loud_on
                or type(press_windows) is not int or not 1 <= press_windows <= 5
                or type(release_windows) is not int or not 1 <= release_windows <= 5):
            raise ValueError('ordered finite thresholds and bounded integer windows required')
        self.on=(soft_on,loud_on); self.off=(soft_off,loud_off)
        self.press=press_windows; self.release=release_windows
        self.reset()

    def reset(self):
        self.held=[False,False]; self.ready=[False,False]
        self.up=[0,0]; self.down=[0,0]
        self.previous_window=None; self.previous_ns=None; self.epoch=None

    def sample(self, *, epoch, window, observed_ns, now_ns, mean_abs, healthy=True):
        if any(type(v) is not int or v < 0 for v in (epoch,window,observed_ns,now_ns)) or window < 1 or epoch < 1:
            raise ValueError('positive source identity and monotonic times required')
        if type(mean_abs) not in (int,float) or not math.isfinite(mean_abs) or mean_abs < 0 or type(healthy) is not bool:
            raise ValueError('finite nonnegative amplitude and explicit health required')
        reason='fresh'
        if not healthy or not 0 <= now_ns-observed_ns <= 100_000_000:
            self.reset()
            return GestureFrame(window,False,False,None,False,False,'unavailable')
        if self.epoch is not None and epoch != self.epoch:
            self.reset();reason='new_epoch'
        if self.previous_window is not None:
            if window < self.previous_window or observed_ns < self.previous_ns:
                raise ValueError('source regressed')
            if window == self.previous_window:
                return GestureFrame(window,*self.held,None,*self.ready,'duplicate')
            if window != self.previous_window+1:
                # No synthetic consecutive windows across a polling gap.
                self.up=[0,0];self.down=[0,0];reason='window_gap'
            if observed_ns-self.previous_ns > 100_000_000:
                self.reset();reason='source_gap'
        self.epoch=epoch;self.previous_window=window;self.previous_ns=observed_ns
        edges=[]
        for i in range(2):
            self.down[i]=min(self.release,self.down[i]+1) if mean_abs <= self.off[i] else 0
            if self.down[i] >= self.release:
                self.held[i]=False;self.ready[i]=True
            self.up[i]=min(self.press,self.up[i]+1) if mean_abs >= self.on[i] else 0
            if self.ready[i] and not self.held[i] and self.up[i] >= self.press:
                self.held[i]=True;self.ready[i]=False;edges.append('SOFT' if i==0 else 'LOUD')
        # A simultaneous press emits LOUD once; later SOFT->LOUD is an upgrade.
        edge='LOUD' if 'LOUD' in edges else 'SOFT' if edges else None
        return GestureFrame(window,*self.held,edge,*self.ready,reason)
