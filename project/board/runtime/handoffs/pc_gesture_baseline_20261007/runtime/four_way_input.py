"""Process-local four-way opt-in; keep the frozen provider's safety gates."""
from dataclasses import replace

from pynq_multimodal_game.vision_input import VisionInputProvider


class FourWayVisionInputProvider(VisionInputProvider):
    def __init__(self, **kwargs):
        kwargs.setdefault('fist_enabled', True)
        super().__init__(**kwargs)

    def sample_with_receipt(self, *, tick_id, timestamp_ns=None):
        # The base lock is reentrant. Hold it across both axes and the receipt
        # so a concurrent publish cannot mix directions from different frames.
        with self._lock:
            sample, receipt = super().sample_with_receipt(
                tick_id=tick_id, timestamp_ns=timestamp_ns)
            vertical = ({'UP': -1.0, 'DOWN': 1.0}.get(
                receipt['source_direction'], 0.0) if sample.hand_valid else 0.0)
            sample = replace(sample, hand_y=vertical)
            receipt['hand_y'] = vertical
            receipt['control_mapping'] = 'FOUR_WAY_OPEN_TO_FIST'
            return sample, receipt
