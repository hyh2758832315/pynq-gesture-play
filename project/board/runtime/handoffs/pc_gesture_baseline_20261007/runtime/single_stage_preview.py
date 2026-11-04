"""Process-local diagnostic policy; no hardware or control changes.

Stage drawing adapted from the frozen gesture runtime debug_view.py;
KPTKleist/Pynq_Gesture_Detect (2019), MIT: see PROJECT1_LICENSE.txt.
"""
from dataclasses import replace
import struct
import time
from urllib.parse import parse_qs, urlsplit
from uuid import uuid4

import cv2
import numpy as np

HEADER = struct.Struct('!4sBQ')
MAGIC = b'V5JP'
_original_encode = None


def stage_image(result, control, frame, stage):
    """Render only the selected original stage at the original tile size."""
    if stage not in range(6):
        raise ValueError('Invalid diagnostic stage')
    images = result['debug_images']
    x0, y0, x1, y1 = result['roi']
    offset = np.array([[[x0, y0]]], np.int32)
    raw = images['input']
    labels = ('Input / ROI', 'Skin threshold', 'Dilate + Gaussian (not binary)',
              'Candidates / selected', 'Hull / accepted defects / centers',
              'Direction / dead zone')
    if stage in (1, 2):
        # Resize grayscale first: avoid constructing a full-resolution BGR mask.
        full = np.zeros(raw.shape[:2], np.uint8)
        full[y0:y1, x0:x1] = images['skin'] if stage == 1 else result['mask']
        tile = cv2.cvtColor(cv2.resize(full, (320, 180), interpolation=cv2.INTER_AREA),
                            cv2.COLOR_GRAY2BGR)
    else:
        image = np.zeros_like(raw) if stage == 5 else raw.copy()
        if stage in (0, 3):
            cv2.rectangle(image, (x0,y0), (x1-1,y1-1), (255,255,0), 1)
        if stage == 3:
            for contour in images['contours']:
                cv2.drawContours(image, [contour+offset], -1, (100,100,100), 1)
            if result['contour'] is not None:
                cv2.drawContours(image, [result['contour']+offset], -1, (0,255,255), 2)
        if stage == 4:
            if result['contour'] is not None:
                cv2.drawContours(image, [result['hull']+offset], -1, (255,0,255), 1)
                for start, end, far in images['defects']:
                    points = [(int(p[0]+x0),int(p[1]+y0)) for p in (start,end,far)]
                    cv2.line(image, points[0], points[2], (0,255,0), 1)
                    cv2.line(image, points[1], points[2], (0,255,0), 1)
                    cv2.circle(image, points[2], 3, (0,0,255), -1)
            if len(control['trajectory']) > 1:
                cv2.polylines(image, [np.asarray(control['trajectory'],np.int32)], False, (0,255,255), 1)
            if result['centroid'] is not None:
                cv2.drawMarker(image, tuple(int(round(v)) for v in result['centroid']),
                               (255,255,255), cv2.MARKER_CROSS, 18, 2)
            cv2.rectangle(image,(0,310),(639,359),(0,0,0),-1)
            cv2.putText(image,'raw='+result['code']+' stable='+result['stable'],(8,328),
                        cv2.FONT_HERSHEY_SIMPLEX,.55,(255,255,255),1)
            cv2.putText(image,'accepted gaps='+str(len(images['defects']))+' fingers='+str(result['fingers']),
                        (8,351),cv2.FONT_HERSHEY_SIMPLEX,.55,(255,255,255),1)
        if stage == 5:
            for threshold,color in [(control['enter'],(0,200,255)),(control['release'],(120,120,120))]:
                cv2.rectangle(image,(int(319.5-threshold*320),int(179.5-threshold*180)),
                              (int(319.5+threshold*320),int(179.5+threshold*180)),color,1)
            cv2.line(image,(320,0),(320,359),(80,80,80),1)
            cv2.line(image,(0,180),(639,180),(80,80,80),1)
            cv2.putText(image,control['direction']+' / '+control['reason'],(12,310),
                        cv2.FONT_HERSHEY_SIMPLEX,.8,(255,255,255),2)
            cv2.putText(image,'event seq='+str(control['action_event_seq']),(12,342),
                        cv2.FONT_HERSHEY_SIMPLEX,.6,(255,255,255),1)
        if stage in (4, 5) and control['smooth_uv'] is not None:
            u,v = control['smooth_uv']
            point = (int(319.5+320*u),int(179.5+180*v))
            if stage == 4:
                cv2.drawMarker(image,point,(0,255,0),cv2.MARKER_DIAMOND,14,1)
            else:
                cv2.arrowedLine(image,(320,180),point,(0,255,0),2)
        tile = cv2.resize(image,(320,180),interpolation=cv2.INTER_AREA)
    cv2.rectangle(tile,(0,0),(319,31),(0,0,0),-1)
    cv2.putText(tile,labels[stage],(5,13),cv2.FONT_HERSHEY_SIMPLEX,.36,(255,255,255),1)
    cv2.putText(tile,'frame='+str(frame),(5,27),cv2.FONT_HERSHEY_SIMPLEX,.35,(255,255,255),1)
    return tile


def encode_snapshot(snapshot, mode, snapshot_dir=None):
    # Top-level callable is spawn-picklable. The child imports the frozen runtime.
    import vision_async_runtime as runtime
    original = _original_encode or runtime.encode_preview_snapshot
    stage = snapshot.result.get('_preview_stage', -1)
    if mode != 'debug' or stage == -1:
        return original(snapshot, mode, snapshot_dir)
    image = stage_image(snapshot.result, snapshot.control, snapshot.frame, stage)
    ok, encoded = cv2.imencode('.jpg', image, [cv2.IMWRITE_JPEG_QUALITY,75])
    if not ok:
        raise OSError('Single-stage JPEG encoding failed')
    return HEADER.pack(MAGIC, stage, snapshot.frame) + encoded.tobytes()


def install(runtime):
    global _original_encode
    _original_encode = runtime.encode_preview_snapshot
    base_preview, base_encoder = runtime.BytesPreview, runtime.ProcessPreviewEncoder
    active = []

    class StagePreview(base_preview):
        def __init__(self, *args, **kwargs):
            self.selected_stage = -1
            self.stage_cache = {}
            self.preview_run = uuid4().hex
            super().__init__(*args, **kwargs)
            active[:] = [self]
            base_handler = self.server.RequestHandlerClass
            owner = self
            class Handler(base_handler):
                def do_GET(self):
                    parsed = urlsplit(self.path)
                    if parsed.path != '/debug-stage.jpg':
                        if self.path == '/debug.jpg':
                            with owner.lock:
                                owner.selected_stage = -1
                        return super().do_GET()
                    try:
                        values = parse_qs(parsed.query, strict_parsing=True)
                        if set(values) != {'stage'} or len(values['stage']) != 1:
                            raise ValueError()
                        stage = int(values['stage'][0])
                        if stage not in range(6):
                            raise ValueError()
                    except ValueError:
                        self.send_error(400, 'Expected stage 0..5')
                        return
                    now = time.monotonic()
                    with owner.lock:
                        owner.selected_stage = stage
                        owner.debug_requested_at = now
                        payload, frame, at = owner.stage_cache.get(stage, (b'', 0, 0))
                        if not owner.diagnostics_enabled or now-at > 1.2:
                            payload = b''
                    self.send_response(200 if payload else 503)
                    self.send_header('Content-Type', 'image/jpeg')
                    self.send_header('Cache-Control', 'no-store')
                    self.send_header('Content-Length', str(len(payload)))
                    self.send_header('X-Vision-Stage', str(stage))
                    self.send_header('X-Vision-Frame', str(frame))
                    self.send_header('X-Vision-Run', owner.preview_run)
                    self.end_headers()
                    try:
                        self.wfile.write(payload)
                    except OSError:
                        pass
            self.server.RequestHandlerClass = Handler

        def publish_debug(self, payload):
            if payload.startswith(MAGIC):
                magic, stage, frame = HEADER.unpack(payload[:HEADER.size])
                if stage not in range(6):
                    raise ValueError('Invalid stage envelope')
                with self.lock:
                    if self.diagnostics_enabled:
                        self.stage_cache[stage] = (payload[HEADER.size:], frame, time.monotonic())
            else:
                super().publish_debug(payload)

        def update_health(self, health):
            super().update_health(health)
            if health['status'] != 'RUNNING':
                with self.lock:
                    self.stage_cache.clear()

    class StageEncoder(base_encoder):
        def submit(self, factory, **kwargs):
            def tagged(modes):
                snapshot = factory(modes)
                stage = -1
                if active and active[0].lock.acquire(False):
                    try:
                        stage = active[0].selected_stage
                    finally:
                        active[0].lock.release()
                result = dict(snapshot.result, _preview_stage=stage)
                return replace(snapshot, result=result)
            return super().submit(tagged, **kwargs)

    runtime.BytesPreview = StagePreview
    runtime.ProcessPreviewEncoder = StageEncoder
    runtime.encode_preview_snapshot = encode_snapshot
