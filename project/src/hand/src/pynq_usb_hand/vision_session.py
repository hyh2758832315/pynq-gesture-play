"""Explicit, low-rate hand owner for an already checked and armed controller.

Constructing this class does not open a serial port or arm the hand. The caller
owns those decisions and must bind a fresh run/config identity before start.
"""

from __future__ import annotations

import math
import threading
import time

from .gesture_consumer import GestureConsumer, LatestVisionMailbox


class VisionHandSession:
    def __init__(self, controller, provider, *, source_identity,
                 max_age, stable_seconds, renew_interval,
                 poll_seconds=0.1, clock=time.monotonic):
        if (type(poll_seconds) not in (int, float) or not math.isfinite(poll_seconds)
                or not 0.02 <= poll_seconds <= 0.5):
            raise ValueError("hand poll period must be within 20..500 ms")
        self.controller = controller
        self.consumer = GestureConsumer(
            controller, LatestVisionMailbox(provider),
            source_identity=source_identity, max_age=max_age,
            stable_seconds=stable_seconds, renew_interval=renew_interval,
        )
        self.poll_seconds = poll_seconds
        self.clock = clock
        self.error = None
        self._stop = threading.Event()
        self._thread = None

    def start(self):
        if self._thread is not None:
            raise RuntimeError("hand session cannot restart")
        self._thread = threading.Thread(target=self._run, name="usb-hand-vision", daemon=False)
        self._thread.start()

    def _run(self):
        try:
            while not self._stop.wait(self.poll_seconds):
                self.consumer.tick(self.clock)
                if self.consumer.stopped:
                    break
        except Exception as error:
            self.error = f"{type(error).__name__}: {error}"
        finally:
            self.consumer.stop("vision_session_stopped")
            try:
                self.controller.close(timeout=8)
            except Exception as error:
                self.error = self.error or f"{type(error).__name__}: {error}"

    def close(self, timeout=10):
        self._stop.set()
        self.consumer.stop("vision_session_closed")
        if self._thread is not None:
            self._thread.join(timeout)
            if self._thread.is_alive():
                raise TimeoutError("hand vision worker did not exit")
        self.controller.close(timeout=timeout)
        if self.error is not None:
            raise RuntimeError(self.error)
