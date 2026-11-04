"""PC-only brand/preview regression; no board connections or motor actions."""
import ast
import copy
import os
from pathlib import Path
from types import SimpleNamespace

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

import cv2
import numpy as np
import pytest
from PySide6.QtCore import QSettings
from PySide6.QtWidgets import QApplication

from pynq_multimodal_game.studio.vision_receiver import VisionResultReceiver
from pynq_multimodal_game.vision_preview_render import camera_geometry, six_panel

ROOT = Path(__file__).resolve().parents[1]


def packet(frame=1, *, valid=True, stable="5"):
    return dict(run_id="preview-a", server_age_ms=0, raw="5", stable=stable, rps="PAPER",
                centroid_640x360=[300, 160], fingers=5, area=10000, ratio=28.5,
                touches_frame_or_roi=False, control=dict(schema="gesture-control-v1",
                frame_id=frame, action_event_seq=1, valid=valid, direction="RIGHT",
                smooth_uv=[0.2, -0.1], reason="TRACKING"))


def diagnostic_fixture():
    raw = np.full((360, 640, 3), (44, 72, 96), dtype=np.uint8)
    contour = np.array([[[20, 20]], [[120, 20]], [[120, 120]], [[20, 120]]], np.int32)
    result = dict(roi=(50, 40, 450, 340), bbox=(70, 60, 170, 160), contour=contour,
                  hull=contour.copy(), centroid=(110, 110), tracking=True, code="5", stable="5",
                  rps="PAPER", fingers=5, area=10000, ratio=28.5, touches_roi=False,
                  mask=np.full((300, 400), 255, np.uint8), timing_ms={},
                  preview_needs_annotation=True, debug_images=dict(input=raw, skin=np.full((300, 400), 255, np.uint8),
                  contours=[contour], defects=[((20, 20), (120, 20), (70, 60))]))
    control = dict(trajectory=[(100, 100), (110, 115)], enter=.25, release=.15,
                   smooth_uv=(.2, -.3), direction="UP", reason="TRACKING", action_event_seq=2)
    return raw, result, control


@pytest.mark.parametrize("runtime", ["board/pynq_z2/scripts/vision_async_runtime.py",
    "subprojects/ps_ui_r23b2/board/pynq_z2/scripts/vision_async_runtime.py"])
@pytest.mark.parametrize("mode", ["video", "debug"])
def test_real_encoder_has_no_text_or_banners(runtime, mode, monkeypatch):
    # Execute the actual codec entry without importing camera/Overlay dependencies.
    tree = ast.parse((ROOT / runtime).read_text(encoding="utf-8"))
    node = next(n for n in tree.body if isinstance(n, ast.FunctionDef) and n.name == "encode_preview_snapshot")
    namespace = dict(cv2=cv2, np=np, Path=Path)
    exec(compile(ast.Module(body=[node], type_ignores=[]), runtime, "exec"), namespace)
    raw, result, control = diagnostic_fixture()
    before = raw.copy()
    monkeypatch.setattr(cv2, "putText", lambda *a, **k: pytest.fail("text was baked into the JPEG"))
    payload = namespace["encode_preview_snapshot"](SimpleNamespace(
        rgb=cv2.cvtColor(raw, cv2.COLOR_BGR2RGB), result=result, control=control, frame=17), mode)
    image = cv2.imdecode(np.frombuffer(payload, np.uint8), cv2.IMREAD_COLOR)
    assert image.shape == ((360, 640, 3) if mode == "video" else (360, 960, 3))
    # The top and bottom camera strips remain content, not opaque text banners.
    assert np.max(np.abs(image[5, 100].astype(int) - before[5, 100].astype(int))) <= 5
    assert np.array_equal(raw, before)
    assert np.array_equal(result['debug_images']['input'], before)


def test_geometry_keeps_original_pixels_outside_annotations():
    raw, result, control = diagnostic_fixture()
    assert np.array_equal(camera_geometry(raw, result)[:25], raw[:25])
    sheet = six_panel(result, control, 1)
    assert np.array_equal(sheet[0:15, 100:200], raw[0:30:2, 200:400:2])
    assert np.any(sheet[200:350, 640:] != 0)  # direction/dead-zone geometry retained


def test_details_follow_new_frames_and_preserve_expiry():
    receiver = VisionResultReceiver()
    first = receiver.consume(packet(), 1)
    details = dict(first.details)
    assert details['中心坐标'] == '300, 160' and details['手指数'] == '5'
    assert details['原始 / 稳定'] == '5 / 5' and details['接触边界'] == '否'
    assert receiver.consume(packet(stable="0"), 1.1).details == first.details
    assert receiver.expire(2.21).status == 'STALE'
    assert receiver.expire(2.22).details == first.details
    second = receiver.consume(packet(frame=2, stable="0"), 2.3)
    assert dict(second.details)['原始 / 稳定'] == '5 / 0'
    malformed = packet(frame=3)
    malformed.update(fingers=float('nan'), centroid_640x360={'bad': 'data'})
    assert receiver.consume(malformed, 2.4).valid
    assert dict(receiver.expire(2.4).details)['手指数'] == '--'


def test_native_logo_and_sidebar_keep_camera_pixels_unmodified(tmp_path, monkeypatch):
    from pynq_multimodal_game.studio import main_window
    from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET
    from PySide6.QtGui import QImage
    app = QApplication.instance() or QApplication([])
    monkeypatch.setattr(main_window, "QSettings", lambda: QSettings(str(tmp_path / 'studio.ini'), QSettings.IniFormat))
    window = main_window.StudioMainWindow(agent_build_id=0xC0061000)
    window.setStyleSheet(STUDIO_STYLESHEET)
    try:
        assert not window.windowIcon().isNull() and not window.brand_logo.pixmap().isNull()
        page = window.vision_workspace
        image = QImage(640, 360, QImage.Format.Format_RGB888)
        image.fill(0x283848)
        before = image.copy()
        page._preview_image = image
        page._show_vision_view()
        receiver = VisionResultReceiver()
        page._result_snapshot = receiver.consume(packet(), 1)
        page._render_result(True)
        assert page._image == before
        assert '源帧 1' in page.result_details_value.toPlainText()
        assert '轮廓面积  10000' in page.result_details_value.toPlainText()
        assert not page.canvas.parentWidget().isAncestorOf(page.canvas_source)
        page._result_snapshot = receiver.expire(2.21)
        page._render_result(True)
        assert '历史' in page.result_details_value.toPlainText()
        assert page.result_direction_value.text() == 'IDLE'
    finally:
        window.close()
        app.processEvents()


def test_candidate_contains_same_preview_renderer():
    path = Path('python/pynq_multimodal_game/vision_preview_render.py')
    assert (ROOT / path).read_bytes() == (ROOT / 'subprojects/ps_ui_r23b2' / path).read_bytes()
