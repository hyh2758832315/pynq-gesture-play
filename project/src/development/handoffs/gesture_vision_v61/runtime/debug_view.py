"""Six same-frame BGR tiles from existing inference intermediates, PS only."""
import cv2
import numpy as np
import time


def encode_debug(result, control, frame, snapshot_path):
    """Encode once; HTTP preview and disk snapshot receive the identical JPEG."""
    started = time.perf_counter()
    panels = six_panel(result, control, frame)
    composed = time.perf_counter()
    ok, encoded = cv2.imencode('.jpg', panels, [cv2.IMWRITE_JPEG_QUALITY,75])
    if not ok:
        raise OSError('debug JPEG encoding failed')
    payload = encoded.tobytes()
    encoded_at = time.perf_counter()
    written = snapshot_path.write_bytes(payload)
    if written != len(payload):
        raise OSError('incomplete debug snapshot')
    finished = time.perf_counter()
    return payload, dict(compose_ms=(composed-started)*1000,
                         encode_ms=(encoded_at-composed)*1000,
                         save_ms=(finished-encoded_at)*1000,
                         total_ms=(finished-started)*1000)


def six_panel(result, control, frame):
    images = result.get('debug_images')
    if images is None:
        raise ValueError('debug capture not enabled')
    raw = images['input']
    input_roi = raw.copy()
    candidates, features = raw.copy(), raw.copy()
    x0, y0, x1, y1 = result['roi']
    offset = np.array([[[x0, y0]]], np.int32)
    cv2.rectangle(input_roi, (x0,y0), (x1-1,y1-1), (255,255,0), 1)
    cv2.rectangle(candidates, (x0,y0), (x1-1,y1-1), (255,255,0), 1)
    for contour in images['contours']:
        cv2.drawContours(candidates, [contour+offset], -1, (100,100,100), 1)
    if result['contour'] is not None:
        cv2.drawContours(candidates, [result['contour']+offset], -1, (0,255,255), 2)
        cv2.drawContours(features, [result['hull']+offset], -1, (255,0,255), 1)
        for start, end, far in images['defects']:
            points = [(int(p[0]+x0), int(p[1]+y0)) for p in (start,end,far)]
            cv2.line(features, points[0], points[2], (0,255,0), 1)
            cv2.line(features, points[1], points[2], (0,255,0), 1)
            cv2.circle(features, points[2], 3, (0,0,255), -1)
    trail = control['trajectory']
    if len(trail) > 1:
        cv2.polylines(features, [np.asarray(trail,np.int32)], False, (0,255,255), 1)
    if result['centroid'] is not None:
        cv2.drawMarker(features, tuple(int(round(v)) for v in result['centroid']),
                       (255,255,255), cv2.MARKER_CROSS, 18, 2)
    # Shape status is independent of direction. Show both to explain pending
    # classifications even when centroid tracking is valid.
    cv2.rectangle(features,(0,310),(639,359),(0,0,0),-1)
    cv2.putText(features,'raw='+result['code']+' stable='+result['stable'],(8,328),
                cv2.FONT_HERSHEY_SIMPLEX,.55,(255,255,255),1)
    cv2.putText(features,'accepted gaps='+str(len(images['defects']))+
                ' fingers='+str(result['fingers']),(8,351),
                cv2.FONT_HERSHEY_SIMPLEX,.55,(255,255,255),1)
    joystick = np.zeros_like(raw)
    for threshold, color in [(control['enter'],(0,200,255)),(control['release'],(120,120,120))]:
        cv2.rectangle(joystick, (int(319.5-threshold*320),int(179.5-threshold*180)),
                      (int(319.5+threshold*320),int(179.5+threshold*180)), color, 1)
    cv2.line(joystick,(320,0),(320,359),(80,80,80),1)
    cv2.line(joystick,(0,180),(639,180),(80,80,80),1)
    if control['smooth_uv'] is not None:
        u,v=control['smooth_uv']
        point=(int(319.5+320*u),int(179.5+180*v))
        cv2.arrowedLine(joystick,(320,180),point,(0,255,0),2)
        cv2.drawMarker(features,point,(0,255,0),cv2.MARKER_DIAMOND,14,1)
    cv2.putText(joystick,control['direction']+' / '+control['reason'],(12,310),
                cv2.FONT_HERSHEY_SIMPLEX,.8,(255,255,255),2)
    cv2.putText(joystick,'event seq='+str(control['action_event_seq']),(12,342),
                cv2.FONT_HERSHEY_SIMPLEX,.6,(255,255,255),1)
    def full_mask(mask):
        full=np.zeros((360,640),np.uint8)
        full[y0:y1,x0:x1]=mask
        return cv2.cvtColor(full,cv2.COLOR_GRAY2BGR)
    tiles=[]
    for label, image in [('Input / ROI',input_roi),
                         ('Skin threshold',full_mask(images['skin'])),
                         ('Dilate + Gaussian (not binary)',full_mask(result['mask'])),
                         ('Candidates / selected',candidates),
                         ('Hull / accepted defects / centers',features),
                         ('Direction / dead zone',joystick)]:
        tile=cv2.resize(image,(320,180),interpolation=cv2.INTER_AREA)
        cv2.rectangle(tile,(0,0),(319,31),(0,0,0),-1)
        cv2.putText(tile,label,(5,13),cv2.FONT_HERSHEY_SIMPLEX,.36,(255,255,255),1)
        cv2.putText(tile,'frame='+str(frame),(5,27),cv2.FONT_HERSHEY_SIMPLEX,.35,(255,255,255),1)
        tiles.append(tile)
    return np.vstack((np.hstack(tiles[:3]),np.hstack(tiles[3:])))
