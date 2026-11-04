"""Anchor preview admission to pre-inference time, not inference completion."""
import time


def scheduled_encoder(base):
    class CaptureTimedEncoder(base):
        def __init__(self, *args, **kwargs):
            self._capture_at = None
            super().__init__(*args, **kwargs)

        def due_modes(self, now=None):
            current = time.monotonic() if now is None else now
            modes = super().due_modes(now=current)
            # The worker calls without an explicit timestamp before inference.
            # submit() rechecks health/demand using this same admission time.
            if now is None:
                self._capture_at = current if modes else None
            return modes

        def submit(self, factory, *, now=None):
            anchor = self._capture_at if now is None else now
            self._capture_at = None  # never reuse a reservation after failure
            if anchor is None:
                return False
            # Base submit advances only modes actually captured and submitted.
            # No catch-up loop: one current snapshot, same bounded codec slots.
            return super().submit(factory, now=anchor)
    return CaptureTimedEncoder


def install(runtime):
    runtime.ProcessPreviewEncoder = scheduled_encoder(runtime.ProcessPreviewEncoder)
