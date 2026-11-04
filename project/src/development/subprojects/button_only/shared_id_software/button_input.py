"""Low-latency PYNQ-Z2 button events for the audio-free game runtime.

Run: imported by the button-only board backend after the paired overlay loads.
Output: debounced BTN0/BTN1 press events in each GameInput.button field.
Next: inspect button event receipts during the game and verify HDMI effects.
"""

from __future__ import annotations

from collections import deque
from dataclasses import replace
from threading import Event, Lock, Thread

from .game_sdk import ButtonSignal


class ButtonSampler:
    """One read-only GPIO poller, independent of the video and game frame rates."""

    def __init__(self, mmio, *, data_offset: int = 8,
                 poll_seconds: float = 0.004, stable_samples: int = 3):
        if not 0 < poll_seconds <= 0.02 or not 2 <= stable_samples <= 8:
            raise ValueError("invalid button debounce settings")
        if data_offset != 8:
            raise ValueError("R23 buttons must use BUILD_ID GPIO channel 2")
        self._mmio = mmio
        self._data_offset = data_offset
        self._poll_seconds = poll_seconds
        self._stable_samples = stable_samples
        self._stop = Event()
        self._lock = Lock()
        self._queue = deque(maxlen=64)
        self._thread = None
        self._sequence = 0
        self._drops = 0
        self._error = None

    def start(self):
        if self._thread is not None:
            raise RuntimeError("button sampler already started")
        initial = self._read_bits()
        self._stable = self._candidate = initial
        self._candidate_count = 0
        self._stop.clear()
        self._thread = Thread(target=self._poll, name="pynq-buttons", daemon=True)
        self._thread.start()

    def _poll(self):
        try:
            while not self._stop.wait(self._poll_seconds):
                self._accept_sample(self._read_bits())
        except BaseException as error:
            with self._lock:
                self._error = f"{type(error).__name__}: {error}"

    def _accept_sample(self, raw):
        with self._lock:
            if raw != self._candidate:
                self._candidate = raw
                self._candidate_count = 1
            else:
                self._candidate_count += 1
            if self._candidate_count < self._stable_samples or raw == self._stable:
                return
            rising = raw & ~self._stable
            self._stable = raw
            for bit in (0, 1):
                if rising & (1 << bit):
                    self._sequence += 1
                    if len(self._queue) == self._queue.maxlen:
                        self._drops += 1
                    self._queue.append(ButtonSignal(f"BTN{bit}", self._sequence))

    def _read_bits(self):
        return int(self._mmio.read(self._data_offset)) & 3

    def consume(self):
        with self._lock:
            if self._error is not None:
                raise RuntimeError(self._error)
            return self._queue.popleft() if self._queue else None

    def clear(self):
        with self._lock:
            self._queue.clear()

    def status(self):
        with self._lock:
            return {"pending": len(self._queue), "dropped": self._drops,
                    "sequence": self._sequence, "error": self._error}

    def close(self):
        self._stop.set()
        if self._thread is not None:
            self._thread.join(timeout=1)
            self._thread = None
        self.clear()


class ButtonGameInputProvider:
    def __init__(self, visual, sampler, *, manifest=None):
        self._visual = visual
        self._sampler = sampler
        self._manifest = manifest
        self._enabled = manifest is not None and manifest.game_id in (
            "game1-button-v1", "game3-button-v1")
        self._suspended = False

    @property
    def capabilities(self):
        return {"schema": "local-game-buttons-v1", "buttons": ("BTN0", "BTN1"),
                "vision": self._visual.capabilities}

    def new_game_session(self, manifest, game_run_id):
        self._sampler.clear()
        return ButtonGameInputProvider(self._visual, self._sampler, manifest=manifest)

    def sample_current_for_game(self, game_id, *, tick_id):
        return self.sample_for_game(game_id, tick_id=tick_id)

    def sample_for_game(self, game_id, *, tick_id, timestamp_ns=None):
        if self._manifest is None or game_id != self._manifest.game_id:
            raise ValueError("button game session mismatch")
        sample, receipt = self._visual.sample_for_game(
            game_id, tick_id=tick_id, timestamp_ns=timestamp_ns)
        signal = self._sampler.consume() if self._enabled and not self._suspended else None
        receipt["button"] = None if signal is None else {
            "kind": signal.kind, "sequence": signal.sequence}
        receipt["button_input"] = "BTN0_LOW_BTN1_HIGH"
        return replace(sample, button=signal), receipt

    def sample_menu_control(self, *, tick_id):
        return self._visual.sample_menu_control(tick_id=tick_id)

    def suspend(self):
        self._suspended = True
        self._sampler.clear()
        self._visual.suspend()

    def resume(self):
        self._sampler.clear()
        self._suspended = False
        self._visual.resume()

    def release(self, message="Button game input stopped"):
        self._sampler.clear()
        self._visual.release(message)
