from types import SimpleNamespace

import cv2
import numpy as np
import pytest

from performance_policy import configure_tracker
from board.pynq_z2.scripts import vision_async_runtime as runtime


class FakeSkin:
    def __init__(self, mask, error=None):
        self.mask, self.error = mask, error
    def run(self, bgr, frame_id, bounds):
        if self.error:
            raise self.error
        return self.mask.copy(), {'frame_id': frame_id}


def tracker(mode, mask, error=None):
    module = SimpleNamespace(FullFrameTracker=runtime.FullFrameTracker)
    cls = configure_tracker(module, mode)
    obj = cls(dilate_iterations=4)
    obj.skin_backend = FakeSkin(mask, error)
    obj.result_frame_id = 1
    return obj


@pytest.mark.parametrize('left', [20, 270, 500])
def test_performance_matches_validation_with_same_pl_mask(left):
    image = np.zeros((360, 640, 3), np.uint8)
    image[90:260, left:left+100] = (80, 120, 180)
    base = runtime.FullFrameTracker()
    mask = cv2.inRange(cv2.cvtColor(image, cv2.COLOR_BGR2HSV), base.lower, base.upper)
    reference = tracker('validation', mask).infer(image)
    actual = tracker('performance', mask).infer(image)
    for key in ('code', 'stable', 'bbox', 'fingers', 'area', 'ratio', 'centroid', 'pixel_stats'):
        assert actual[key] == reference[key]
    assert np.array_equal(actual['mask'], reference['mask'])
    assert actual['pl_skin']['same_frame_exact'] is None
    assert reference['pl_skin']['same_frame_exact'] is True


def test_cpu_golden_not_called_in_performance(monkeypatch):
    image = np.zeros((360, 640, 3), np.uint8)
    mask = np.zeros((360, 640), np.uint8)
    obj = tracker('performance', mask)
    def forbidden(*args, **kwargs):
        raise AssertionError('CPU HSV must not run with PL in performance mode')
    monkeypatch.setattr(runtime.cv2, 'cvtColor', forbidden)
    obj.infer(image)


def test_validation_still_rejects_wrong_pl_mask():
    image = np.zeros((360, 640, 3), np.uint8)
    mask = np.full((360, 640), 255, np.uint8)
    with pytest.raises(RuntimeError, match='same-frame mask mismatch'):
        tracker('validation', mask).infer(image)


def test_dma_failure_not_suppressed():
    image = np.zeros((360, 640, 3), np.uint8)
    with pytest.raises(TimeoutError, match='DMA timeout'):
        tracker('performance', image[:, :, 0], TimeoutError('DMA timeout')).infer(image)


def test_original_default_not_modified_and_invalid_mode_rejected():
    base = runtime.FullFrameTracker
    module = SimpleNamespace(FullFrameTracker=base)
    configure_tracker(module, 'performance')
    assert runtime.FullFrameTracker is base
    assert getattr(base(), 'skin_validate', True) is True
    with pytest.raises(ValueError):
        configure_tracker(module, 'unsafe')
