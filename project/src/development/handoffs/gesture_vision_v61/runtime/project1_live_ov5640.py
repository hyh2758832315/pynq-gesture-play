"""Single-hand PS baseline over the validated OV5640 HDMI capture program.

Adapted from KPTKleist/Pynq_Gesture_Detect (2019), MIT license; see
PROJECT1_LICENSE.txt. No USB camera, PC inference, new bitstream or sensor table.
The original 300x300 ROI algorithm is retained; hardware integration, guards,
short consecutive-frame confirmation and tentative RPS labels are additions.
"""
import argparse
import asyncio
import csv
import importlib
import json
import math
import os
import shutil
import signal
import sys
import time
from collections import deque
from pathlib import Path
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from threading import Event, Lock, Thread

import cv2
import numpy as np


CAMERA_DIR = Path('/home/xilinx/voice-view-game/camera-corrected-hdmi-prototype')
ROI = (170, 30, 470, 330)  # half-open coordinates on the 640x360 PS view


def capture_to_rgb(capture, capture_order='rgb'):
    """Interpret camera memory once; always return owned RGB pixels."""
    if capture.shape != (720, 1280, 3) or capture.dtype != np.uint8:
        raise ValueError('expected uint8 1280x720 capture')
    if capture_order not in ('rgb', 'bgr'):
        raise ValueError('capture order must be rgb or bgr')
    return cv2.cvtColor(capture, cv2.COLOR_BGR2RGB) if capture_order == 'bgr' else capture.copy()


def rgb_to_display(rgb, capture_order):
    # The selected camera overlay uses the same packed order on S2MM/MM2S.
    if capture_order not in ('rgb', 'bgr'):
        raise ValueError('capture order must be rgb or bgr')
    return cv2.cvtColor(rgb, cv2.COLOR_RGB2BGR) if capture_order == 'bgr' else rgb


def select_frame_channels(dma, mode, host_only=False):
    """Host-only never obtains/configures the HDMI MM2S channel."""
    channel = dma.readchannel
    channel.mode = mode
    display = None
    if not host_only:
        display = dma.writechannel
        display.mode = mode
    return channel, display


def write_display_frame(display, processed, raw, capture_order, rotate, mirror, pl_osd):
    """Return zero without conversions, allocation or write in host-only mode."""
    if display is None:
        return 0.
    started = time.perf_counter()
    output = display.newframe()
    hdmi_rgb = processed
    if pl_osd:
        hdmi_rgb = capture_to_rgb(raw, capture_order)
        if rotate == 180:
            hdmi_rgb = cv2.rotate(hdmi_rgb, cv2.ROTATE_180)
        if mirror:
            hdmi_rgb = cv2.flip(hdmi_rgb, 1)
    np.copyto(output, rgb_to_display(hdmi_rgb, capture_order))
    display.writeframe(output)
    return (time.perf_counter()-started)*1000


class CalibrationCapture:
    """Six bounded, same-frame samples; called only by the DMA owner thread."""
    stages = ('EMPTY_BACKGROUND', 'OPEN_HAND', 'FIST')
    schedule = ((10., 0), (12., 0), (25., 1), (27., 1), (40., 2), (42., 2))

    def __init__(self, directory, rotate=180, mirror=False, capture_order='rgb', rps=False):
        if capture_order not in ('rgb', 'bgr'):
            raise ValueError('capture order must be rgb or bgr')
        self.capture_order = capture_order
        if rps:
            self.stages = self.stages + ('SCISSORS',)
            self.schedule = self.schedule + ((55., 3), (57., 3))
        self.directory = Path(directory) / 'calibration'
        self.directory.mkdir(exist_ok=False)
        self.rotate, self.mirror = rotate, mirror
        self.pending, self.samples, self.missed = list(self.schedule), [], []
        self.stage = None

    def cue(self, elapsed):
        stage = min(int(elapsed // 15), len(self.stages)-1)
        if stage != self.stage:
            self.stage = stage
            print(f'CALIBRATION_STAGE={self.stages[stage]} elapsed={elapsed:.1f}s', flush=True)
        return f'CALIBRATION: {self.stages[stage]} t={elapsed:.1f}s'

    def capture(self, raw, overlay, result, frame, elapsed):
        if not self.pending or elapsed < self.pending[0][0]:
            return
        due, stage = self.pending.pop(0)
        # Never label a late frame as an earlier requested gesture.
        if elapsed >= (stage + 1) * 15 or elapsed - due > 3:
            self.missed.append(due)
            self._manifest()
            print(f'CALIBRATION_MISSED=target_{due:.0f}s', flush=True)
            return
        stem = f'{self.stages[stage].lower()}_{int(due):02d}s'
        # NPY preserves the actual DMA channel order, without guessing RGB/BGR.
        np.save(str(self.directory / (stem + '_capture.npy')), raw, allow_pickle=False)
        view = capture_to_rgb(raw, self.capture_order)
        if self.rotate == 180:
            view = cv2.rotate(view, cv2.ROTATE_180)
        if self.mirror:
            view = cv2.flip(view, 1)
        for suffix, array in [('_raw.png', cv2.cvtColor(view, cv2.COLOR_RGB2BGR)),
                              ('_mask.png', result['mask']),
                              ('_overlay.jpg', cv2.cvtColor(overlay, cv2.COLOR_RGB2BGR))]:
            if not cv2.imwrite(str(self.directory / (stem + suffix)), array):
                raise OSError('cannot write calibration sample ' + stem + suffix)
        info = dict(sample=stem, frame=frame, elapsed_s=round(elapsed, 3), target_s=due,
                    requested_scene=self.stages[stage], scene_verified=False,
                    capture_order=self.capture_order, channel_order_hardware_verified=False,
                    capture_shape=list(raw.shape), rotate=self.rotate, mirror=self.mirror,
                    roi_640x360=list(result.get('roi', ROI)), mask_coordinates='ROI local',
                    raw=result['code'], stable=result['stable'], bbox=result['bbox'],
                    area=result['area'], gap_percent=result['ratio'], error=result['error'],
                    touches_roi=result['touches_roi'],
                    dilate_iterations=result['dilate_iterations'], defect_depth=result['defect_depth'],
                    hand_state=result.get('hand_state','UNKNOWN'), tracking=result.get('tracking',False),
                    centroid_640x360=result.get('centroid'), pixel_stats=result.get('pixel_stats'),
                    timing_ms=result.get('timing_ms'), effective_defect_depth=result.get('effective_defect_depth'))
        (self.directory / (stem + '_result.json')).write_text(json.dumps(info, indent=2), encoding='utf-8')
        self.samples.append(info)
        self._manifest()
        print(f'CALIBRATION_SAVED={self.directory / stem} frame={frame}', flush=True)

    def _manifest(self):
        (self.directory / 'manifest.json').write_text(json.dumps(dict(
            samples=self.samples, missed_targets=self.missed,
            pending_targets=[due for due, _ in self.pending]), indent=2), encoding='utf-8')

    def close(self):
        self._manifest()
        # Include the complete temporal log, not only the eight static samples.
        log = self.directory.parent / 'frames.csv'
        if log.is_file():
            shutil.copy2(log, self.directory / 'frames.csv')
        config = self.directory.parent / 'run_config.json'
        if config.is_file():
            shutil.copy2(config, self.directory / config.name)
        archive = shutil.make_archive(str(self.directory.parent / 'calibration_download'),
                                      'zip', root_dir=str(self.directory.parent), base_dir='calibration')
        print(f'CALIBRATION_ZIP={archive}', flush=True)
        print(f'CALIBRATION_COMPLETE={len(self.samples)}/{len(self.schedule)} directory={self.directory}', flush=True)


class VideoRecorder:
    """Bounded MJPEG AVI recording of owned RGB frames, with timestamp mapping."""
    def __init__(self, directory, fps=8., max_mb=128):
        if not 1 <= fps <= 15 or max_mb < 1:
            raise ValueError('invalid recording rate or size limit')
        self.directory = Path(directory)
        self.path = self.directory / 'gesture_overlay.avi'
        self.fps, self.max_bytes = float(fps), int(max_mb * 1024 * 1024)
        self.writer = cv2.VideoWriter(str(self.path), cv2.VideoWriter_fourcc(*'MJPG'), self.fps, (640, 360))
        if not self.writer.isOpened():
            self.writer.release()
            raise RuntimeError('MJPG AVI encoder unavailable; use --no-record for recognition only')
        self.frames, self.next_time, self.samples, self.limited = 0, 0., [], False
        self.closed = False

    def write(self, rgb, elapsed):
        if self.closed or self.limited or elapsed + 1e-9 < self.next_time:
            return None
        if self.path.exists() and self.path.stat().st_size >= self.max_bytes:
            self.limited = True
            print('PROJECT1_RECORDING_SIZE_LIMIT=STOP_RECORDING_ONLY', flush=True)
            return None
        bgr = cv2.cvtColor(cv2.resize(rgb, (640, 360), interpolation=cv2.INTER_AREA), cv2.COLOR_RGB2BGR)
        self.writer.write(bgr)
        index = self.frames
        self.frames += 1
        # Sample at the target cadence without duplicating frames after a slow loop.
        self.next_time = (math.floor(elapsed * self.fps) + 1) / self.fps
        if len(self.samples) < 8 and elapsed >= len(self.samples) * 15:
            tile = cv2.resize(bgr, (320, 180))
            cv2.putText(tile, f't={elapsed:.1f}s', (5, 172), cv2.FONT_HERSHEY_SIMPLEX, .4, (0,255,255), 1)
            self.samples.append(tile)
        return index

    def close(self):
        if self.closed:
            return
        self.closed = True
        self.writer.release()  # AVI index must be written before download/playback
        if self.samples:
            tiles = self.samples + [np.zeros((180,320,3), np.uint8)] * (8-len(self.samples))
            sheet = np.vstack((np.hstack(tiles[:4]), np.hstack(tiles[4:])))
            if not cv2.imwrite(str(self.directory / 'video_contact_sheet.jpg'), sheet):
                raise OSError('cannot write video contact sheet')
        info = dict(file=self.path.name, recorded_frames=self.frames, playback_fps=self.fps,
                    size_limited=self.limited, closed_cleanly=True,
                    timing='sampled fixed-fps AVI; frames.csv maps video_frame to elapsed_s; slow processing shortens playback')
        (self.directory / 'recording.json').write_text(json.dumps(info, indent=2), encoding='utf-8')
        print(f'PROJECT1_VIDEO_SAVED={self.path} frames={self.frames}', flush=True)


class BytesPreview:
    """HTTP workers see immutable JPEG bytes only, never arrays or DMA buffers."""
    def __init__(self, bind, port):
        self.lock, self.stop = Lock(), Event()
        self.jpeg, self.generation = b'', 0
        self.result_json = b'{}'
        self.result_at = None
        self.debug_jpeg = b''
        self.dashboard = (Path(__file__).parent / 'dashboard.html').read_bytes()
        owner = self

        class Handler(BaseHTTPRequestHandler):
            def do_GET(self):
                if self.path in ('/', '/debug.jpg'):
                    with owner.lock:
                        payload = owner.dashboard if self.path == '/' else owner.debug_jpeg
                    self.send_response(200 if payload else 503)
                    self.send_header('Content-Type', 'text/html; charset=utf-8' if self.path == '/' else 'image/jpeg')
                    self.send_header('Cache-Control', 'no-store')
                    self.send_header('Content-Length', str(len(payload)))
                    self.end_headers()
                    try:
                        self.wfile.write(payload)
                    except OSError:
                        pass
                    return
                if self.path == '/result.json':
                    with owner.lock:
                        payload = owner.result_json
                        published_at = owner.result_at
                    sample = json.loads(payload)
                    sample['server_age_ms'] = ((time.monotonic()-published_at)*1000
                                               if published_at is not None else None)
                    payload = json.dumps(sample).encode('utf-8')
                    self.send_response(200)
                    self.send_header('Content-Type', 'application/json')
                    self.send_header('Cache-Control', 'no-store')
                    self.send_header('Content-Length', str(len(payload)))
                    self.end_headers()
                    try:
                        self.wfile.write(payload)
                    except OSError:
                        pass
                    return
                if self.path != '/camera.mjpg':
                    self.send_error(404)
                    return
                self.connection.settimeout(2)
                self.send_response(200)
                self.send_header('Content-Type', 'multipart/x-mixed-replace; boundary=frame')
                self.send_header('Cache-Control', 'no-store')
                self.end_headers()
                last = -1
                try:
                    while not owner.stop.wait(.025):
                        with owner.lock:
                            jpeg, generation = owner.jpeg, owner.generation
                        if not jpeg or generation == last:
                            continue
                        self.wfile.write(b'--frame\r\nContent-Type: image/jpeg\r\nContent-Length: ' +
                                         str(len(jpeg)).encode('ascii') + b'\r\n\r\n' + jpeg + b'\r\n')
                        last = generation
                except OSError:
                    pass  # client closed; acquisition remains independent

            def log_message(self, fmt, *args):
                pass

        self.server = ThreadingHTTPServer((bind, port), Handler)
        self.server.daemon_threads = True  # these threads hold bytes, no hardware
        self.thread = Thread(target=self.server.serve_forever, name='jpeg-bytes-server')
        self.thread.start()

    def publish(self, jpeg):
        if not isinstance(jpeg, bytes):
            raise TypeError('preview accepts immutable JPEG bytes only')
        with self.lock:
            self.jpeg, self.generation = jpeg, self.generation + 1

    def close(self):
        self.stop.set()
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(timeout=3)

    def publish_result(self, payload):
        if not isinstance(payload,bytes):
            raise TypeError('result endpoint accepts immutable JSON bytes only')
        with self.lock:
            self.result_json = payload
            self.result_at = time.monotonic()

    def publish_debug(self, payload):
        if not isinstance(payload, bytes):
            raise TypeError('debug endpoint accepts immutable bytes only')
        with self.lock:
            self.debug_jpeg = payload


def original_code(fingers, area, ratio):
    """Original notebook decision thresholds, including its non-RPS gestures."""
    if fingers == 1:
        if area < 2000:
            return 'NO_HAND'
        return '0' if ratio < 12 else ('6' if ratio < 17.5 else '1')
    if fingers == 3:
        return '3' if ratio < 27 else '7'
    return str(fingers) if fingers in (2, 4, 5) else 'REPOSITION'


def selected_pixel_stats(skin_mask, contour, roi):
    """Moments of observed skin pixels inside ONLY the selected contour.

    Morphology-expanded background pixels and holes in the skin mask are excluded.
    This measures segmented-hand area center, not anatomical palm center.
    """
    x, y, w, h = cv2.boundingRect(contour)
    selected = np.zeros((h, w), np.uint8)
    cv2.drawContours(selected, [contour - np.array([[[x,y]]], np.int32)], -1, 255, -1)
    selected = cv2.bitwise_and(selected, skin_mask[y:y+h, x:x+w])
    moments = cv2.moments(selected, binaryImage=True)
    area = int(moments['m00'])
    ox, oy = x+roi[0], y+roi[1]
    sx = int(round(moments['m10'])) + ox*area
    sy = int(round(moments['m01'])) + oy*area
    return dict(area=area, sum_x=sx, sum_y=sy,
                centroid=(sx/area, sy/area) if area else None)


class OriginalContour:
    def __init__(self, confirm=5, lower=(0, 20, 70), upper=(20, 255, 255),
                 dilate_iterations=4, defect_depth=30., roi=ROI):
        if confirm < 1:
            raise ValueError('confirm must be positive')
        if not 0 <= dilate_iterations <= 8 or not 1 <= defect_depth <= 100:
            raise ValueError('invalid dilation or defect depth')
        self.dilate_iterations, self.defect_depth = dilate_iterations, float(defect_depth)
        self.confirm = confirm
        if len(roi) != 4 or not (0 <= roi[0] < roi[2] <= 640 and 0 <= roi[1] < roi[3] <= 360):
            raise ValueError('invalid ROI')
        self.roi = tuple(roi)
        self.retrieval_mode = cv2.RETR_TREE
        self.lower = np.array(lower, np.uint8)
        self.upper = np.array(upper, np.uint8)
        self.pending, self.count = '', 0

    def select_contour(self, contours):
        return max(contours, key=cv2.contourArea) if contours else None

    def depth_threshold(self, contour):
        return self.defect_depth

    def classify_shape(self, fingers, area, ratio):
        return original_code(fingers, area, ratio)

    def pixel_statistics(self, hsv, skin_mask, contour):
        if getattr(self, 'moments_backend', None) is None:
            return selected_pixel_stats(skin_mask, contour, self.roi)
        gate = np.zeros(skin_mask.shape, np.uint8)
        cv2.drawContours(gate, [contour], -1, 255, -1)
        bounds = tuple(int(v) for v in (self.lower[0], self.upper[0], self.lower[1],
                                       self.upper[1], self.lower[2], self.upper[2]))
        mask, stats = self.moments_backend.run(hsv, gate, self.result_frame_id, bounds)
        # Same-frame reference comparison is mandatory in this validation version.
        if not np.array_equal(mask, cv2.bitwise_and(gate, skin_mask)):
            raise RuntimeError('PL same-frame mask mismatch')
        area = stats['area']
        stats['sum_x'] += self.roi[0]*area
        stats['sum_y'] += self.roi[1]*area
        stats['centroid'] = (stats['sum_x']/area, stats['sum_y']/area) if area else None
        gold = selected_pixel_stats(skin_mask, contour, self.roi)
        if any(stats[key] != gold[key] for key in ('area', 'sum_x', 'sum_y')):
            raise RuntimeError('PL same-frame moments mismatch')
        stats['same_frame_exact'] = True
        return stats

    def infer(self, bgr):
        if bgr.shape != (360, 640, 3) or bgr.dtype != np.uint8:
            raise ValueError('expected uint8 640x360 BGR')
        x0, y0, x1, y1 = self.roi
        t0 = time.perf_counter()
        skin_meta = None
        if getattr(self, 'skin_backend', None) is not None:
            bounds = tuple(int(v) for pair in zip(self.lower, self.upper) for v in pair)
            skin_mask, skin_meta = self.skin_backend.run(bgr[y0:y1, x0:x1], self.result_frame_id, bounds)
            hsv = None
            skin_meta['same_frame_exact'] = None
            if getattr(self, 'skin_validate', True):
                hsv = cv2.cvtColor(bgr[y0:y1, x0:x1], cv2.COLOR_BGR2HSV)
                gold = cv2.inRange(hsv, self.lower, self.upper)
                if not np.array_equal(skin_mask, gold):
                    raise RuntimeError('PL skin same-frame mask mismatch')
                skin_meta['same_frame_exact'] = True
        else:
            hsv = cv2.cvtColor(bgr[y0:y1, x0:x1], cv2.COLOR_BGR2HSV)
            skin_mask = cv2.inRange(hsv, self.lower, self.upper)
        mask = skin_mask
        t1 = time.perf_counter()
        mask = cv2.dilate(mask, np.ones((3, 3), np.uint8), iterations=self.dilate_iterations)
        mask = cv2.GaussianBlur(mask, (5, 5), 100)
        t2 = time.perf_counter()
        contours = cv2.findContours(mask, self.retrieval_mode, cv2.CHAIN_APPROX_SIMPLE)[-2]
        result = dict(code='NO_HAND', bbox=None, fingers=0, area=0., ratio=0.,
                      mask=mask, contour=None, hull=None, error='', touches_roi=False,
                      dilate_iterations=self.dilate_iterations, defect_depth=self.defect_depth,
                      roi=self.roi, tracking=False, centroid=None, pixel_stats=None)
        cnt = self.select_contour(contours)
        debug = getattr(self, 'debug_enabled', False)
        if debug:
            result['debug_images'] = dict(input=bgr.copy(), skin=skin_mask, contours=contours, defects=[])
        t3 = time.perf_counter()
        if cnt is not None:
            area = float(cv2.contourArea(cnt))
            if area > 0:
                hull = cv2.convexHull(cnt)
                ratio = (float(cv2.contourArea(hull)) - area) / area * 100
                approx = cv2.approxPolyDP(cnt, .0005 * cv2.arcLength(cnt, True), True)
                indices = cv2.convexHull(approx, returnPoints=False)
                defects = None
                if len(approx) >= 4 and indices is not None and len(indices) >= 3:
                    try:
                        defects = cv2.convexityDefects(approx, indices)
                    except cv2.error as exc:
                        result['error'] = str(exc)
                count = 0
                depth_threshold = self.depth_threshold(cnt)
                if defects is not None:
                    points = approx[:, 0, :].astype(float)
                    for s, e, f, _ in defects.reshape(-1, 4):
                        start, end, far = points[s], points[e], points[f]
                        a = float(np.linalg.norm(end - start))
                        b = float(np.linalg.norm(far - start))
                        c = float(np.linalg.norm(end - far))
                        if min(a, b, c) <= 1e-9:
                            continue
                        cosine = float(np.clip((b*b + c*c - a*a)/(2*b*c), -1, 1))
                        angle = math.acos(cosine) * 57  # original notebook constant
                        u, v = end - start, far - start
                        depth = abs(u[0]*v[1] - u[1]*v[0]) / a
                        if angle <= 90 and depth > depth_threshold:
                            count += 1
                            if debug:
                                result['debug_images']['defects'].append((start.tolist(),end.tolist(),far.tolist()))
                fingers = count + 1
                bx, by, bw, bh = cv2.boundingRect(cnt)
                code = self.classify_shape(fingers, area, ratio)
                if result['error']:
                    code = 'REPOSITION'  # do not convert invalid defects to a fist
                stats = self.pixel_statistics(hsv, skin_mask, cnt)
                result.update(code=code, fingers=fingers, area=area, ratio=ratio,
                              centroid=stats['centroid'], pixel_stats=stats,
                              effective_defect_depth=depth_threshold,
                              touches_roi=(bx <= 1 or by <= 1 or bx+bw >= x1-x0-1 or by+bh >= y1-y0-1),
                              bbox=(x0+bx, y0+by, x0+bx+bw, y0+by+bh),
                              contour=cnt, hull=hull)
        code = result['code']
        if code in ('NO_HAND', 'REPOSITION'):
            self.pending, self.count = '', 0
            stable = code
        else:
            self.count = min(self.confirm, self.count+1) if code == self.pending else 1
            self.pending = code
            stable = code if self.count >= self.confirm else 'PENDING'
        result['pl_skin'] = skin_meta
        result['stable'] = stable
        result['rps'] = {'0': 'ROCK', '2': 'SCISSORS', '5': 'PAPER'}.get(stable, 'UNKNOWN')
        t4 = time.perf_counter()
        result['timing_ms'] = dict(color_mask=(t1-t0)*1000, morphology=(t2-t1)*1000,
                                  contours_select=(t3-t2)*1000, shape_stats=(t4-t3)*1000)
        return result


class FullFrameTracker(OriginalContour):
    """PS-only extension of project 1; blob continuity inspired by project 2.

    No copied RTL, neural model, prediction-only boxes or PC inference.
    Boxes are the currently observed contours, not stale tracked positions.
    """
    def __init__(self, lower=(0,20,70), upper=(20,255,255), dilate_iterations=3,
                 defect_depth=30., min_area=2000.):
        if min_area <= 0:
            raise ValueError('minimum candidate area must be positive')
        super().__init__(1, lower, upper, dilate_iterations, defect_depth, (0,0,640,360))
        self.min_area = float(min_area)
        self.retrieval_mode = cv2.RETR_EXTERNAL
        self.previous = None
        self.votes = deque(maxlen=5)
        self.candidate_count = 0

    @staticmethod
    def overlap(a, b):
        ix = max(0,min(a[2],b[2])-max(a[0],b[0]))
        iy = max(0,min(a[3],b[3])-max(a[1],b[1]))
        intersection = ix*iy
        union = (a[2]-a[0])*(a[3]-a[1])+(b[2]-b[0])*(b[3]-b[1])-intersection
        return intersection/max(union,1)

    def select_contour(self, contours):
        candidates = sorted((c for c in contours if cv2.contourArea(c) >= self.min_area),
                            key=cv2.contourArea, reverse=True)[:8]
        self.candidate_count = len(candidates)
        if not candidates:
            return None
        largest = cv2.contourArea(candidates[0])
        def score(contour):
            x,y,w,h = cv2.boundingRect(contour)
            box = (x,y,x+w,y+h)
            value = cv2.contourArea(contour)/max(largest,1)
            if self.previous:
                pcx,pcy = (self.previous[0]+self.previous[2])/2,(self.previous[1]+self.previous[3])/2
                distance = math.hypot(x+w/2-pcx,y+h/2-pcy)/math.hypot(640,360)
                value += 2*self.overlap(box,self.previous)+max(0.,1-3*distance)
            return value
        return max(candidates,key=score)

    def depth_threshold(self, contour):
        _, _, w, h = cv2.boundingRect(contour)
        # Keep the configured 300-pixel reference; normalize for hand scale.
        return self.defect_depth * max(.5, min(1.5, max(w,h)/300.))

    def classify_shape(self, fingers, area, ratio):
        # Three-class heuristic, NOT a guarantee or a calibrated probability.
        # Finger count remains a feature; PAPER need not have exactly five.
        if area < self.min_area:
            return 'NO_HAND'
        if fingers == 1 and ratio < 15:
            return '0'
        if fingers == 2 and ratio >= 15:
            return '2'
        if 3 <= fingers <= 5 and 18 <= ratio <= 55:
            return '5'
        return 'REPOSITION'

    def infer(self, bgr):
        result = super().infer(bgr)
        box = result['bbox']
        new_target = box is not None and self.previous is not None and (
            self.overlap(box,self.previous) == 0 and
            math.hypot((box[0]+box[2]-self.previous[0]-self.previous[2])/2,
                       (box[1]+box[3]-self.previous[1]-self.previous[3])/2) > 140)
        if new_target:
            self.votes.clear()
        self.previous = box
        code = result['code']
        if box is None or code == 'NO_HAND':
            self.votes.clear()
            stable = 'NO_HAND'
        else:
            self.votes.append(code)
            # Latest observation must agree: never display stale ROCK on a new PAPER.
            stable = code if code in ('0','2','5') and self.votes.count(code) >= 3 else 'PENDING'
        result.update(stable=stable, tracking=True, candidates=self.candidate_count,
                      rps={'0':'ROCK','2':'SCISSORS','5':'PAPER'}.get(stable,'UNKNOWN'),
                      hand_state={'0':'FIST','2':'TWO_FINGERS','5':'OPEN'}.get(stable,'UNKNOWN'))
        return result


def process_rgb(rgb, recognizer, rotate=180, mirror=False, capture_order='rgb',
                output_size=(1280,720), on_result=None):
    if rgb.shape != (720, 1280, 3) or rgb.dtype != np.uint8:
        raise ValueError('expected validated 1280x720 RGB capture')
    prep_started = time.perf_counter()
    view = cv2.resize(capture_to_rgb(rgb, capture_order), (640, 360), interpolation=cv2.INTER_AREA)
    if rotate == 180:
        view = cv2.rotate(view, cv2.ROTATE_180)
    if mirror:
        view = cv2.flip(view, 1)
    bgr = cv2.cvtColor(view, cv2.COLOR_RGB2BGR)
    prep_done = time.perf_counter()
    result = recognizer.infer(bgr)
    result['timing_ms']['input_prepare'] = (prep_done-prep_started)*1000
    if on_result is not None:
        # Publish control before PS annotations, display write and JPEG work.
        on_result(result)
    draw_started = time.perf_counter()
    canvas = bgr.copy()
    x0, y0, x1, y1 = result['roi']
    if not result['tracking']:
        cv2.rectangle(canvas, (x0, y0), (x1-1, y1-1), (255, 255, 0), 1)
    if result['bbox'] is not None:
        offset = np.array([[[x0, y0]]], np.int32)
        cv2.drawContours(canvas, [result['contour'] + offset], -1, (0, 255, 255), 1)
        cv2.drawContours(canvas, [result['hull'] + offset], -1, (255, 0, 255), 1)
        bx0, by0, bx1, by1 = result['bbox']
        color = (0, 0, 255) if result['stable'] == '0' else (0, 255, 0)
        if result['stable'] in ('NO_HAND', 'REPOSITION', 'PENDING'):
            color = (0, 180, 255)
        cv2.rectangle(canvas, (bx0, by0), (bx1-1, by1-1), color, 2)
        if result['centroid'] is not None:
            cx,cy = result['centroid']
            cv2.drawMarker(canvas, (int(round(cx)),int(round(cy))), (255,255,255),
                           cv2.MARKER_CROSS, 16, 2)
            cv2.putText(canvas, f'C=({cx:.1f},{cy:.1f})', (bx0,max(58,by0-5)),
                        cv2.FONT_HERSHEY_SIMPLEX, .42, (255,255,255), 1)
    if not result['tracking']:
        canvas[45:195, 480:630] = cv2.cvtColor(cv2.resize(result['mask'], (150, 150)), cv2.COLOR_GRAY2BGR)
    cv2.rectangle(canvas, (0, 0), (639, 27), (0, 0, 0), -1)
    text = f"raw={result['code']} stable={result['stable']} RPS?={result['rps']}"
    cv2.putText(canvas, text, (5, 20), cv2.FONT_HERSHEY_SIMPLEX, .48, (255,255,255), 1)
    if result['tracking']:
        cv2.putText(canvas, f"PS TRACKING: {result['hand_state']}", (5, 42),
                    cv2.FONT_HERSHEY_SIMPLEX, .44, (255,255,255), 1)
    cv2.putText(canvas, f"fingers={result['fingers']} area={result['area']:.0f} gap={result['ratio']:.1f}%",
                (5, 351), cv2.FONT_HERSHEY_SIMPLEX, .44, (255,255,255), 1)
    if result['touches_roi']:
        cv2.putText(canvas, 'FRAME EDGE' if result['tracking'] else 'ROI EDGE: contour may be clipped', (5, 335),
                    cv2.FONT_HERSHEY_SIMPLEX, .44, (0,180,255), 1)
    output_bgr = canvas if output_size == (640,360) else cv2.resize(canvas, output_size)
    output = cv2.cvtColor(output_bgr, cv2.COLOR_BGR2RGB)
    result['timing_ms'].update(input_prepare=(prep_done-prep_started)*1000,
                               overlay_resize=(time.perf_counter()-draw_started)*1000)
    return output, result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--camera-dir', type=Path, default=CAMERA_DIR)
    parser.add_argument('--rotate', type=int, choices=(0, 180), default=180)
    parser.add_argument('--mirror', action='store_true')
    parser.add_argument('--capture-order', choices=('rgb', 'bgr'), default='rgb',
                        help='camera memory order; use bgr for the current calibration hardware')
    parser.add_argument('--confirm', type=int, default=5)
    parser.add_argument('--tracking', action='store_true', help='full-frame moving-hand PS tracking; 3-of-5 vote')
    parser.add_argument('--pl-osd', action='store_true', help='clean HDMI pixels; PL draws PS bbox/centroid, requires hand_osd IP')
    parser.add_argument('--host-only', action='store_true', help='browser preview/control only; do not start or write HDMI MM2S')
    parser.add_argument('--pl-moments', action='store_true', help='dedicated DMA same-frame mask/moments, mandatory exact PS comparison; experimental')
    parser.add_argument('--pl-skin', action='store_true', help='v6 PL BGR/HSV/skin frontend; supports HDMI or --host-only')
    parser.add_argument('--pl-skin-mode', choices=('validate','performance'), default='validate')
    parser.add_argument('--debug-view', action='store_true', help='same-frame six-panel browser JPEG, max 1 Hz; PS overhead')
    parser.add_argument('--track-min-area', type=float, default=2000.)
    parser.add_argument('--dilate-iterations', type=int, choices=range(9), default=4)
    parser.add_argument('--defect-depth', type=float, default=30.)
    parser.add_argument('--hue-max', type=int, default=20)
    parser.add_argument('--sat-min', type=int, default=20)
    parser.add_argument('--value-min', type=int, default=70)
    parser.add_argument('--no-record', action='store_true')
    parser.add_argument('--calibration', action='store_true', help='guided 45-second raw/mask capture; disables AVI recording')
    parser.add_argument('--calibration-rps', action='store_true', help='60-second calibration including scissors; disables AVI')
    parser.add_argument('--record-fps', type=float, default=8.)
    parser.add_argument('--record-max-mb', type=int, default=128)
    parser.add_argument('--results-dir', type=Path, default=Path(__file__).resolve().parent / 'project1_recordings')
    parser.add_argument('bitstream', type=Path)
    parser.add_argument('output', type=Path)
    parser.add_argument('--live', action='store_true', required=True)
    parser.add_argument('--bind', default='192.168.2.99')
    parser.add_argument('--port', type=int, default=8088)
    parser.add_argument('--duration', type=float, default=60., help='active processing seconds, excluding overlay/sensor setup')
    options = parser.parse_args()
    if options.host_only and options.pl_osd:
        parser.error('--host-only cannot use HDMI --pl-osd; browser draws geometry in PS')
    if options.pl_skin and options.pl_moments:
        parser.error('PL skin replaces the dedicated moments kernel; do not run both protocols')
    if not 1 <= options.duration <= 600:
        parser.error('duration must be 1..600 seconds')
    if options.calibration_rps:
        options.calibration = True
    if options.calibration:
        minimum_duration = 60 if options.calibration_rps else 45
        if options.duration < minimum_duration:
            parser.error(f'calibration requires --duration {minimum_duration} or longer')
        options.no_record = True
    if not (0 <= options.hue_max <= 179 and 0 <= options.sat_min <= 255 and 0 <= options.value_min <= 255):
        parser.error('invalid HSV bounds')
    if not 1 <= options.record_fps <= 15 or not 1 <= options.record_max_mb <= 512:
        parser.error('record fps must be 1..15 and record max MB must be 1..512')
    if not 1 <= options.defect_depth <= 100:
        parser.error('defect depth must be 1..100 pixels')
    recognizer = OriginalContour(options.confirm, (0, options.sat_min, options.value_min),
                                 (options.hue_max, 255, 255), options.dilate_iterations, options.defect_depth)
    if options.tracking:
        if not 100 <= options.track_min_area <= 100000:
            parser.error('track minimum area must be 100..100000 pixels')
        recognizer = FullFrameTracker((0, options.sat_min, options.value_min),
                                     (options.hue_max,255,255),options.dilate_iterations,
                                     options.defect_depth, options.track_min_area)
    camera_dir = options.camera_dir.resolve()
    recognizer.debug_enabled = options.debug_view
    from gesture_control import GestureControl
    controller = GestureControl()
    if not (camera_dir / 'capture_camera_direct_plug.py').is_file():
        raise FileNotFoundError(camera_dir / 'capture_camera_direct_plug.py')
    sys.path.insert(0, str(camera_dir))
    camera = importlib.import_module('capture_camera_direct_plug')
    if os.geteuid() != 0:
        raise PermissionError('run through the existing root camera guard')
    bitstream = options.bitstream.resolve()
    hwh = bitstream.with_suffix('.hwh')
    if not bitstream.is_file() or not hwh.is_file():
        raise FileNotFoundError('matching camera bit/HWH required')
    # Validate the hardware description without programming PL first.
    from xml.etree import ElementTree
    modules = {m.get('INSTANCE'): m for m in ElementTree.parse(hwh).iter('MODULE')}
    if not camera.REQUIRED_IP <= modules.keys():
        raise RuntimeError('camera IP missing from HWH')
    dma_params = {p.get('NAME'): p.get('VALUE') for p in modules['frame_dma'].iter('PARAMETER')}
    if dma_params.get('C_INCLUDE_MM2S') != '1':
        raise RuntimeError('bidirectional camera HDMI overlay required')
    if (options.pl_moments or options.pl_skin) and not {'moments_dma','moments_reset'} <= modules.keys():
        raise RuntimeError('PL moments requested but dedicated DMA/reset absent')
    if options.pl_skin and 'skin_kernel' not in modules:
        raise RuntimeError('v6 skin_kernel missing; old moments bitstream rejected before programming')
    if options.pl_moments and 'skin_kernel' in modules:
        raise RuntimeError('v6 skin bitstream cannot run old moments protocol')
    if options.pl_osd:
        if 'hand_osd' not in modules:
            raise RuntimeError('PL OSD requested but hand_osd missing from HWH')
        # This validation mode requires the new package verifier and matched pair.
        from importlib import util
        verifier_path = bitstream.parent / 'verify_package.py'
        spec = util.spec_from_file_location('osd_package_verifier', verifier_path)
        verifier = util.module_from_spec(spec)
        spec.loader.exec_module(verifier)
        verifier.verify(bitstream.parent)
        from osd_control import HandOSDControl
        from pl_osd_bridge import metadata_from_result
    options.results_dir.mkdir(parents=True, exist_ok=True)
    if not options.no_record and shutil.disk_usage(options.results_dir).free < (options.record_max_mb + 64) * 1024 * 1024:
        raise OSError('insufficient free space for bounded recording; free space or use --no-record')
    run_dir = options.results_dir / ('project1_results_' + time.strftime('%Y%m%d_%H%M%S'))
    run_dir.mkdir(exist_ok=False)
    calibration = CalibrationCapture(run_dir, options.rotate, options.mirror, options.capture_order,
                                     options.calibration_rps) if options.calibration else None
    (run_dir / 'run_config.json').write_text(json.dumps(dict(
        capture_order=options.capture_order, rotate=options.rotate, mirror=options.mirror,
        hsv_lower=recognizer.lower.tolist(), hsv_upper=recognizer.upper.tolist(),
        confirm=options.confirm, duration=options.duration, calibration_rps=options.calibration_rps,
        dilate_iterations=options.dilate_iterations, defect_depth=options.defect_depth,
        tracking=options.tracking, search_roi=list(recognizer.roi), pl_moments=options.pl_moments,
        track_min_area=options.track_min_area, temporal_mode='3_of_5_latest_agrees' if options.tracking else 'consecutive',
        version='pl_skin_v61_optional_host_preview', pl_osd=options.pl_osd,
        pl_skin=options.pl_skin, pl_skin_mode=options.pl_skin_mode,
        hdmi_enabled=not options.host_only, host_only=options.host_only,
        preview_size=[640,360], control_publish_stage='before overlay / optional HDMI / JPEG',
        classifier='scale_adaptive_rps_shape_v1' if options.tracking else 'original',
        centroid_method='skin threshold pixels intersect selected filled contour; holes excluded',
        note='RPS labels remain heuristic candidates; v6 frontend, sensor table unchanged'), indent=2), encoding='utf-8')
    (run_dir / 'control_config.json').write_text(json.dumps(dict(
        schema='gesture-control-v1', debug_view=options.debug_view, enter=controller.enter,
        release=controller.release, smoothing_tau_s=controller.tau, timeout_s=controller.timeout,
        coordinates='640x360 after rotation/mirror; display left is control left',
        safety='edge/error/no hand/gap releases control; browser independently expires stale frames',
        acceptance='PS control prototype, not connected to external game'), indent=2), encoding='utf-8')

    print(f'PROJECT1_RESULTS={run_dir}', flush=True)
    print('PROJECT1_VERSION=pl_skin_v61_optional_host_preview', flush=True)
    print(f'PROJECT1_OUTPUT_MODE={"HOST_ONLY" if options.host_only else "HDMI_AND_HOST"}; HDMI_ENABLED={int(not options.host_only)}', flush=True)
    print('PROJECT1_LATENCY_MODE=EARLY_CONTROL; browser preview/control preserved', flush=True)
    print(f'PROJECT1_CAPTURE_ORDER={options.capture_order}', flush=True)
    print('PROJECT1_ACCEPTANCE=NOT_YET_BOARD_VALIDATED; RPS labels are heuristic candidates', flush=True)
    stop = Event()
    def request_stop(number, frame):
        stop.set()  # never raise asynchronously inside NumPy/XRT or thread startup
    signal.signal(signal.SIGTERM, request_stop)
    signal.signal(signal.SIGINT, request_stop)
    from pynq import Overlay
    from pynq.lib.iic import AxiIIC
    from pynq.lib.video import VideoMode
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    preview = recorder = channel = display = demosaic = osd = moments_backend = skin_backend = None
    retained = deque(maxlen=12)
    fields = ['frame', 'elapsed_s', 'process_ms', 'raw', 'stable', 'rps_candidate',
              'fingers', 'area', 'gap_percent', 'bbox', 'error', 'video_frame', 'touches_roi',
              'hand_state', 'candidate_count', 'centroid_x', 'centroid_y', 'pixel_area',
              'sum_x', 'sum_y', 'timing_ms', 'capture_copy_ms', 'display_write_ms',
              'pl_osd_applied', 'pl_osd_metadata', 'pl_moments', 'control', 'debug_ms', 'debug_timing',
              'inference_ms', 'capture_to_result_ms', 'preview_encode_ms', 'cycle_to_log_ms','pl_skin', 'hdmi_enabled']
    try:
        # Bind the port/encoder before touching hardware, so errors fail early.
        preview = BytesPreview(options.bind, options.port)
        if not options.no_record:
            recorder = VideoRecorder(run_dir, options.record_fps, options.record_max_mb)
        overlay = Overlay(str(bitstream))
        if options.pl_skin:
            from skin_dma import SkinDMA
            skin_backend = SkinDMA(overlay)
            recognizer.skin_backend = skin_backend
            recognizer.skin_validate = options.pl_skin_mode=='validate'
            print(f'PROJECT1_PL_SKIN=COMPACT_BGR_DMA mode={options.pl_skin_mode}; morphology/contours/RPS remain PS',flush=True)
        if options.pl_moments:
            from moments_dma import MomentsDMA
            moments_backend = MomentsDMA(overlay)
            recognizer.moments_backend = moments_backend
            print('PROJECT1_PL_MOMENTS=DMA_SAME_FRAME_VALIDATION; HSV/morphology/RPS remain PS', flush=True)
        if options.pl_osd:
            osd = HandOSDControl(overlay.hand_osd.mmio)
            print('PROJECT1_PL_OSD_ID=PASS; HDMI geometry is PL, preview/recording geometry is PS', flush=True)
        iic = AxiIIC(overlay.ip_dict['camera_iic'])
        camera.probe_chip_id(iic)
        camera.configure_sensor(iic)
        if stop.is_set():
            return
        demosaic = overlay.demosaic
        demosaic.write(0x10, camera.WIDTH)
        demosaic.write(0x18, camera.HEIGHT)
        demosaic.write(0x28, 1)
        demosaic.write(0, 0x81)
        dma = camera.open_frame_dma(overlay, hwh)
        channel, display = select_frame_channels(dma, VideoMode(camera.WIDTH, camera.HEIGHT, 24), options.host_only)
        channel.start()
        if display is not None:
            display.start()
        else:
            print('PROJECT1_HDMI_SKIPPED=MM2S_not_started; no_output_buffers; browser_OSD=PS', flush=True)
        started, snapshot_at, jpeg_at, frame_id = time.monotonic(), -10., -1., 0
        debug_at = -10.
        print(f'PROJECT1_READY=http://{options.bind}:{options.port}/camera.mjpg duration={options.duration}', flush=True)
        print(f'PROJECT1_DASHBOARD=http://{options.bind}:{options.port}/ debug_view={options.debug_view}', flush=True)
        with (run_dir / 'frames.csv').open('w', newline='', encoding='utf-8') as fp:
            writer = csv.DictWriter(fp, fieldnames=fields)
            writer.writeheader()
            while not stop.is_set() and time.monotonic()-started < options.duration:
                loop_started = time.perf_counter()
                capture_started = time.perf_counter()
                captured = channel.readframe()
                capture_return_at = time.monotonic()
                retained.append(captured)
                raw = np.asarray(captured).copy()
                capture_copy_ms = (time.perf_counter()-capture_started)*1000
                if stop.is_set():
                    break
                if frame_id == 0:
                    camera.save_frame(raw, options.output)
                t0 = time.monotonic()
                recognizer.result_frame_id = frame_id+1
                early = {}
                def publish_control(observed):
                    result_ready_at = time.monotonic()
                    packet_control = controller.update(observed, frame_id+1, result_ready_at)
                    early.update(control=packet_control,
                                 inference_ms=(result_ready_at-t0)*1000,
                                 capture_to_result_ms=(result_ready_at-capture_return_at)*1000)
                    box, centroid = observed['bbox'], observed['centroid']
                    preview.publish_result(json.dumps(dict(
                        frame=frame_id+1, elapsed_s=round(result_ready_at-started,3),
                        inference_ms=early['inference_ms'], capture_to_result_ms=early['capture_to_result_ms'],
                        publication_stage='after inference, before PS overlay / HDMI / JPEG',
                        capture_timestamp_kind='readframe returned, not sensor exposure time',
                        bbox_640x360=box, bbox_1280x720=[int(v)*2 for v in box] if box else None,
                        coordinate_space='display view after rotation/mirror; half-open xyxy',
                        detected=box is not None, raw=observed['code'], stable=observed['stable'],
                        centroid_valid=centroid is not None, centroid_640x360=centroid,
                        centroid_1280x720=[v*2+.5 for v in centroid] if centroid else None,
                        centroid_kind='selected observed skin pixel area center, not palm center',
                        centroid_hdmi_mapping='pixel centers: 2*x+0.5, 2*y+0.5',
                        pixel_stats=observed['pixel_stats'], timing_ms=observed['timing_ms'],
                        pl_skin=observed.get('pl_skin'),
                        rps=observed['rps'], hand_state=observed.get('hand_state','UNKNOWN'),
                        hdmi_enabled=not options.host_only, pl_osd_requested=osd is not None,
                        pl_osd_applied=False, pl_osd_status='disabled host-only' if options.host_only else 'pending current frame; CSV records application',
                        touches_frame_or_roi=observed['touches_roi'], tracking=options.tracking,
                        control=packet_control, run_id=run_dir.name
                    )).encode('utf-8'))
                processed, result = process_rgb(raw, recognizer, options.rotate, options.mirror,
                                                options.capture_order,
                                                output_size=(640,360) if options.host_only or osd is not None else (1280,720),
                                                on_result=publish_control)
                process_ms = (time.monotonic()-t0)*1000
                if calibration:
                    cue = calibration.cue(time.monotonic()-started)
                    cv2.rectangle(processed, (0, 56), (processed.shape[1]-1, 95), (0, 0, 0), -1)
                    cv2.putText(processed, cue, (10, 86), cv2.FONT_HERSHEY_SIMPLEX, .7, (255,255,255), 2)
                display_write_ms = write_display_frame(display, processed, raw, options.capture_order,
                                                       options.rotate, options.mirror, osd is not None)
                frame_id += 1
                osd_metadata = None
                if osd is not None:
                    osd_metadata = metadata_from_result(result, frame_id)
                    osd.publish(osd_metadata, timeout=.5, wait_applied=True)
                    if frame_id == 1 or frame_id % 25 == 0:
                        print(f'PROJECT1_PL_OSD_APPLIED={frame_id} metadata={osd_metadata}', flush=True)
                elapsed = time.monotonic()-started
                box = result['bbox']
                centroid = result['centroid']
                stats = result['pixel_stats'] or {}
                control = early['control']
                debug_ms = 0.
                debug_timing = {}
                if options.debug_view and elapsed-debug_at >= 1.:
                    from debug_view import encode_debug
                    payload, debug_timing = encode_debug(result, control, frame_id, run_dir/'latest_debug.jpg')
                    preview.publish_debug(payload)
                    debug_ms = debug_timing['total_ms']
                    debug_at = elapsed
                if calibration:
                    calibration.capture(raw, processed, result, frame_id, elapsed)
                video_frame = recorder.write(processed, elapsed) if recorder else None
                preview_encode_ms = 0.
                if elapsed-jpeg_at >= .2:
                    encode_started = time.perf_counter()
                    preview_rgb = processed if processed.shape[:2] == (360,640) else cv2.resize(processed,(640,360))
                    bgr = cv2.cvtColor(preview_rgb,cv2.COLOR_RGB2BGR)
                    ok, encoded = cv2.imencode('.jpg',bgr,[cv2.IMWRITE_JPEG_QUALITY,80])
                    if not ok:
                        raise OSError('JPEG encoding failed')
                    preview.publish(encoded.tobytes())
                    preview_encode_ms = (time.perf_counter()-encode_started)*1000
                    jpeg_at = elapsed
                writer.writerow(dict(frame=frame_id, elapsed_s=round(elapsed,3), process_ms=round(process_ms,3),
                    raw=result['code'], stable=result['stable'], rps_candidate=result['rps'],
                    fingers=result['fingers'], area=result['area'], gap_percent=result['ratio'],
                    bbox=result['bbox'], error=result['error'], video_frame=video_frame,
                    touches_roi=result['touches_roi'], hand_state=result.get('hand_state','UNKNOWN'),
                    candidate_count=result.get('candidates',0),
                    centroid_x=centroid[0] if centroid else '', centroid_y=centroid[1] if centroid else '',
                    pixel_area=stats.get('area',0), sum_x=stats.get('sum_x',0), sum_y=stats.get('sum_y',0),
                    timing_ms=json.dumps(result['timing_ms']), capture_copy_ms=capture_copy_ms,
                    display_write_ms=display_write_ms, hdmi_enabled=not options.host_only,
                    pl_osd_applied=osd is not None,
                    pl_osd_metadata=json.dumps(osd_metadata),
                    control=json.dumps(control), debug_ms=debug_ms, debug_timing=json.dumps(debug_timing),
                    inference_ms=early['inference_ms'], capture_to_result_ms=early['capture_to_result_ms'],
                    preview_encode_ms=preview_encode_ms, cycle_to_log_ms=(time.perf_counter()-loop_started)*1000,
                    pl_skin=json.dumps(result.get('pl_skin')),
                    pl_moments=json.dumps({key:stats[key] for key in
                        ('frame_id','same_frame_exact','pack_cache_ms','dma_cache_ms','total_ms',
                         'pack_ms','tx_copy_cache_ms','rx_snapshot_ms','decode_ms') if key in stats})))
                if frame_id == 1 or frame_id % 25 == 0:
                    fp.flush()
                    print(f"PROJECT1_FRAME={frame_id} loop_fps={frame_id/max(elapsed,.001):.2f} "
                          f"raw={result['code']} stable={result['stable']} RPS_CANDIDATE={result['rps']}", flush=True)
                if elapsed-snapshot_at >= 10:
                    if not cv2.imwrite(str(run_dir/'latest_overlay.jpg'),cv2.cvtColor(processed,cv2.COLOR_RGB2BGR)):
                        raise OSError('snapshot write failed')
                    if not cv2.imwrite(str(run_dir/'latest_mask.png'),result['mask']):
                        raise OSError('mask write failed')
                    snapshot_at = elapsed
    finally:
        stop.set()
        # Both channel stops attempted even if one fails; guard is the final safety net.
        errors = []
        # Disable while video SOF still flows; never reload another overlay here.
        if osd is not None and display is not None:
            try:
                osd.disable(timeout=.5, wait_applied=True)
            except Exception as exc:
                errors.append(f'OSD disable: {exc}')
        for name, resource, action in [('skin DMA',skin_backend,'close'), ('moments DMA',moments_backend,'close'), ('display',display,'stop'), ('capture',channel,'stop'),
                                       ('preview',preview,'close'), ('recording',recorder,'close'),
                                       ('calibration',calibration,'close')]:
            if resource is not None:
                try:
                    getattr(resource,action)()
                except Exception as exc:
                    errors.append(f'{name}: {exc}')
        if demosaic is not None:
            try:
                demosaic.write(0,0)
            except Exception as exc:
                errors.append(f'demosaic: {exc}')
        # No DMA-owning worker exists, so interpreter finalizers cannot race a copy.
        loop.close()
        if errors:
            raise RuntimeError('cleanup failed; outer guard must halt DMA: ' + '; '.join(errors))
        retained.clear()
        print('PROJECT1_STOPPED=single-owner cleanup completed', flush=True)


if __name__ == '__main__':
    main()
