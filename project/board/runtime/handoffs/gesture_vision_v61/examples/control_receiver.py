"""Run: python examples/control_receiver.py --url http://192.168.2.99:8088/result.json
Output: normalized direction/action JSON to stdout; no keyboard injection.
Next: replace stdout consumer with the teammate's game adapter. Python 3.10+.
"""
import argparse
import json
import math
import time
import urllib.request


class Receiver:
    def __init__(self):
        self.run_id = None
        self.frame = 0
        self.fresh_at = None
        self.seq = None
        self.direction = 'IDLE'

    def release(self):
        self.direction = 'IDLE'
        self.seq = None  # reconnect establishes a baseline, never replays an event
        return {'direction': 'IDLE', 'action_event': False}

    def consume(self, packet, now):
        try:
            c = packet['control']
            age = packet['server_age_ms']
            run = packet['run_id']
            frame = c['frame_id']
            seq = c['action_event_seq']
            if (not isinstance(run, str) or not run or
                c['schema'] != 'gesture-control-v1' or
                type(frame) is not int or frame < 1 or
                type(seq) is not int or seq < 0 or
                type(age) not in (int, float) or not math.isfinite(age) or
                age < 0 or age > 1200 or type(c['valid']) is not bool or
                c['direction'] not in ('IDLE', 'LEFT', 'RIGHT', 'UP', 'DOWN')):
                return self.release()
            if run != self.run_id:
                self.run_id, self.frame, self.fresh_at, self.seq = run, 0, None, None
            if frame <= self.frame:
                if self.fresh_at is None or now - self.fresh_at > 1.2:
                    return self.release()
                return {'direction': self.direction, 'action_event': False}
            if self.fresh_at is not None and now - self.fresh_at > 1.2:
                self.seq = None
            self.frame, self.fresh_at = frame, now
            if not c['valid']:
                return self.release()
            if self.seq is not None and seq < self.seq:
                return self.release()
            event = self.seq is not None and seq > self.seq
            self.seq = seq
            self.direction = c['direction']
            return {'direction': self.direction, 'action_event': event}
        except (KeyError, TypeError, ValueError):
            return self.release()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--url', default='http://192.168.2.99:8088/result.json')
    args = parser.parse_args()
    receiver = Receiver()
    try:
        while True:
            try:
                request = urllib.request.Request(args.url, headers={'Cache-Control': 'no-cache'})
                with urllib.request.urlopen(request, timeout=0.8) as response:
                    packet = json.load(response)
                result = receiver.consume(packet, time.monotonic())
            except (OSError, ValueError, TimeoutError):
                result = receiver.release()
            print(json.dumps(result), flush=True)
            time.sleep(0.05)
    except KeyboardInterrupt:
        print(json.dumps(receiver.release()), flush=True)


if __name__ == '__main__':
    main()
