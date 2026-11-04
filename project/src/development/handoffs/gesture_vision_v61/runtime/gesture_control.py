"""Display-coordinate virtual controller; no keyboard/network side effects."""
import math


class GestureControl:
    def __init__(self, enter=.36, release=.24, tau=.18, timeout=1.2):
        if not 0 < release < enter < 1 or tau <= 0 or timeout <= 0:
            raise ValueError('invalid controller thresholds')
        self.enter, self.release, self.tau, self.timeout = enter, release, tau, timeout
        self.smooth = None
        self.direction = 'IDLE'
        self.last_time = None
        self.last_frame = 0
        self.armed = False
        self.event_seq = 0
        self.history = []

    @staticmethod
    def axis(u, v, threshold):
        if max(abs(u), abs(v)) < threshold:
            return 'IDLE'
        if abs(u) >= abs(v):
            return 'RIGHT' if u > 0 else 'LEFT'
        return 'DOWN' if v > 0 else 'UP'

    def update(self, result, frame, now):
        if frame <= self.last_frame or (self.last_time is not None and now <= self.last_time):
            raise ValueError('non-monotonic control sample')
        gap = self.last_time is not None and now - self.last_time > self.timeout
        dt = now - self.last_time if self.last_time is not None else 0
        self.last_frame, self.last_time = frame, now
        centroid = result.get('centroid')
        reason = ('FRAME_GAP' if gap else 'ERROR' if result.get('error') else
                  'FRAME_EDGE' if result.get('touches_roi') else
                  'NO_HAND' if centroid is None or result.get('code') == 'NO_HAND' else 'OK')
        valid = reason == 'OK' and all(math.isfinite(float(v)) for v in centroid)
        if valid and not (0 <= centroid[0] < 640 and 0 <= centroid[1] < 360):
            valid, reason = False, 'COORDINATES'
        if not valid:
            if reason == 'OK':
                reason = 'COORDINATES'
            self.smooth, self.direction, self.armed = None, 'IDLE', False
            self.history = []
            raw_direction = 'IDLE'
            u = v = None
        else:
            u, v = (centroid[0]-319.5)/320, (centroid[1]-179.5)/180
            raw_direction = self.axis(u, v, self.enter)
            alpha = 1-math.exp(-dt/self.tau)
            self.smooth = (u, v) if self.smooth is None else tuple(
                old + alpha*(new-old) for old, new in zip(self.smooth, (u, v)))
            threshold = self.release if self.direction != 'IDLE' else self.enter
            self.direction = self.axis(*self.smooth, threshold)
            self.history = (self.history + [list(centroid)])[-20:]
        event = False
        if valid:
            if result.get('stable') == '5':
                self.armed = True
            elif result.get('stable') == '0':
                event = self.armed
                self.armed = False
                if event:
                    self.event_seq += 1
        return dict(schema='gesture-control-v1', frame_id=frame, sample_monotonic_s=now,
                    valid=valid, reason=reason, raw_direction=raw_direction,
                    direction=self.direction, u=u, v=v,
                    smooth_uv=list(self.smooth) if self.smooth else None,
                    enter=self.enter, release=self.release, timeout_ms=int(self.timeout*1000),
                    action_event=event, action_event_seq=self.event_seq,
                    action_kind='HEURISTIC_OPEN_TO_FIST', armed=self.armed,
                    trajectory=self.history.copy())
