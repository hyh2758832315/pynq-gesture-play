"""Text-free diagnostic geometry for the subscribed preview codec only.

Adapted from the project's debug_view.py; original gesture geometry derives from
KPTKleist/Pynq_Gesture_Detect (MIT), see handoff PROJECT1_LICENSE.txt.
No inference, control state, HTTP polling or HDMI drawing is performed here.
"""
import cv2
import numpy as np


def camera_geometry(bgr, result):
    canvas = bgr.copy()
    x0, y0, x1, y1 = result['roi']
    if not result.get('tracking', False):
        cv2.rectangle(canvas, (x0, y0), (x1 - 1, y1 - 1), (255, 255, 0), 1)
    if result.get('bbox') is not None:
        offset = np.array([[[x0, y0]]], np.int32)
        for key, color in (('contour', (0, 255, 255)), ('hull', (255, 0, 255))):
            contour = result.get(key)
            if contour is not None:
                cv2.drawContours(canvas, [contour + offset], -1, color, 1)
        bx0, by0, bx1, by1 = result['bbox']
        color = (0, 0, 255) if result.get('stable') == '0' else (0, 255, 0)
        if result.get('stable') in ('NO_HAND', 'REPOSITION', 'PENDING'):
            color = (0, 180, 255)
        cv2.rectangle(canvas, (bx0, by0), (bx1 - 1, by1 - 1), color, 2)
        if result.get('centroid') is not None:
            point = tuple(int(round(v)) for v in result['centroid'])
            cv2.drawMarker(canvas, point, color, cv2.MARKER_CROSS, 16, 2)
    return canvas


def six_panel(result, control, frame):
    """Keep six 320x180 tiles in their existing order, with no text or banners."""
    images = result.get('debug_images')
    if images is None:
        raise ValueError('debug capture not enabled')
    raw = images['input']
    input_roi, candidates, features = raw.copy(), raw.copy(), raw.copy()
    x0, y0, x1, y1 = result['roi']
    offset = np.array([[[x0, y0]]], np.int32)
    for image in (input_roi, candidates):
        cv2.rectangle(image, (x0, y0), (x1 - 1, y1 - 1), (255, 255, 0), 1)
    for contour in images['contours']:
        cv2.drawContours(candidates, [contour + offset], -1, (100, 100, 100), 1)
    if result['contour'] is not None:
        cv2.drawContours(candidates, [result['contour'] + offset], -1, (0, 255, 255), 2)
        cv2.drawContours(features, [result['hull'] + offset], -1, (255, 0, 255), 1)
        for start, end, far in images['defects']:
            points = [(int(p[0] + x0), int(p[1] + y0)) for p in (start, end, far)]
            cv2.line(features, points[0], points[2], (0, 255, 0), 1)
            cv2.line(features, points[1], points[2], (0, 255, 0), 1)
            cv2.circle(features, points[2], 3, (0, 0, 255), -1)
    if len(control['trajectory']) > 1:
        cv2.polylines(features, [np.asarray(control['trajectory'], np.int32)], False, (0, 255, 255), 1)
    if result.get('centroid') is not None:
        cv2.drawMarker(features, tuple(int(round(v)) for v in result['centroid']),
                       (255, 255, 255), cv2.MARKER_CROSS, 18, 2)
    joystick = np.zeros_like(raw)
    for threshold, color in ((control['enter'], (0, 200, 255)), (control['release'], (120, 120, 120))):
        cv2.rectangle(joystick, (int(319.5 - threshold * 320), int(179.5 - threshold * 180)),
                      (int(319.5 + threshold * 320), int(179.5 + threshold * 180)), color, 1)
    cv2.line(joystick, (320, 0), (320, 359), (80, 80, 80), 1)
    cv2.line(joystick, (0, 180), (639, 180), (80, 80, 80), 1)
    if control['smooth_uv'] is not None:
        u, v = control['smooth_uv']
        point = (int(319.5 + 320 * u), int(179.5 + 180 * v))
        cv2.arrowedLine(joystick, (320, 180), point, (0, 255, 0), 2)
        cv2.drawMarker(features, point, (0, 255, 0), cv2.MARKER_DIAMOND, 14, 1)

    def full_mask(mask):
        full = np.zeros(raw.shape[:2], np.uint8)
        full[y0:y1, x0:x1] = mask
        return cv2.cvtColor(full, cv2.COLOR_GRAY2BGR)

    tiles = [cv2.resize(image, (320, 180), interpolation=cv2.INTER_AREA) for image in
             (input_roi, full_mask(images['skin']), full_mask(result['mask']), candidates, features, joystick)]
    return np.vstack((np.hstack(tiles[:3]), np.hstack(tiles[3:])))
