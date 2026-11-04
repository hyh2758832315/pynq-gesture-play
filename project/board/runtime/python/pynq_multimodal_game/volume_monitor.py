"""VOL1 small-status HTTP observation, independent of game and PCM pipelines."""

from collections import deque
from http.client import HTTPConnection, HTTPException
from http.server import BaseHTTPRequestHandler, HTTPServer
import ipaddress
import json
import math
import socket
import sys
import threading
import time
import uuid
from urllib.parse import urlsplit


SCHEMA = "voice-volume-status-v1"
PROFILE = "VOICE_VOLUME_ONLY_V1"
BUILD_ID = 0xC00C0001
MAX_BODY = 8192


def validate_volume_status(value):
    if type(value) is not dict or value.get("schema") != SCHEMA or value.get("profile") != PROFILE or type(value.get("build_id")) is not int or value["build_id"] != BUILD_ID:
        raise ValueError("expected VOL1 status identity")
    for key in ("enabled", "clock_locked", "ack_error", "snapshot_valid"):
        if type(value.get(key)) is not bool:
            raise ValueError(f"invalid {key}")
    for key, maximum in (("epoch", 0xFFFFFFFF), ("faults", 255), ("state", 4)):
        if type(value.get(key)) is not int or not 0 <= value[key] <= maximum:
            raise ValueError(f"invalid {key}")
    if value["snapshot_valid"]:
        if not value["enabled"] or not value["clock_locked"] or value["faults"] or value["ack_error"]:
            raise ValueError("healthy snapshot contradicts live status")
        for key, maximum in (("sample_count", 0xFFFFFFFFFFFFFFFF), ("window_count", 0xFFFFFFFF)):
            if type(value.get(key)) is not int or not 0 <= value[key] <= maximum:
                raise ValueError(f"invalid {key}")
        if value["sample_count"] < value["window_count"] * 977:
            raise ValueError("window count exceeds source samples")
        if value["window_count"]:
            if type(value.get("l1_sum")) is not int or not 0 <= value["l1_sum"] <= 64027695:
                raise ValueError("invalid L1 window")
            if type(value.get("mean_abs")) not in (float, int) or not math.isfinite(value["mean_abs"]) or abs(value["mean_abs"] - value["l1_sum"] / 977) > 1e-6:
                raise ValueError("invalid mean absolute amplitude")
        elif value.get("l1_sum") is not None or value.get("mean_abs") is not None:
            raise ValueError("amplitude without a complete window")
        thresholds = value.get("thresholds")
        if type(thresholds) is not dict or any(type(thresholds.get(key)) is not int for key in ("quiet", "soft", "loud")) or not 0 <= thresholds["quiet"] < thresholds["soft"] < thresholds["loud"] <= 0xFFFFFFFF:
            raise ValueError("invalid active thresholds")
    elif any(value.get(key) is not None for key in ("sample_count", "window_count", "l1_sum", "mean_abs", "thresholds", "event")):
        raise ValueError("invalid snapshot contains live measurements")
    event = value.get("event")
    if event is not None:
        if type(event) is not dict or event.get("kind") not in ("SOFT", "LOUD") or type(event.get("epoch")) is not int or event["epoch"] != value["epoch"]:
            raise ValueError("invalid event identity")
        for key, maximum in (("sequence", 0xFFFFFFFF), ("source_sample", 0xFFFFFFFFFFFFFFFF), ("source_window", 0xFFFFFFFF)):
            if type(event.get(key)) is not int or not 1 <= event[key] <= maximum:
                raise ValueError("invalid event counters")
        age = event.get("age_ms")
        if type(age) not in (int, float) or not math.isfinite(age) or not 0 <= age < 100:
            raise ValueError("expired event")
    return value


def validate_fused_volume_status(snapshot):
    if (type(snapshot) is not dict or snapshot.get("profile") != "C6I_PL_VISION_VOLUME_OSD_V1"
            or type(snapshot.get("build_id")) is not int or snapshot["build_id"] != 0xC0060E00):
        raise ValueError("expected paired C0C volume status")
    volume = snapshot.get("volume")
    if (type(volume) is not dict or volume.get("profile") != "C6I_PL_VISION_VOLUME_OSD_V1"
            or type(volume.get("build_id")) is not int or volume["build_id"] != 0xC0060E00):
        raise ValueError("invalid fused volume identity")
    for key in ("sampling_enabled", "poller_alive", "lease_retained"):
        if type(volume.get(key)) is not bool:
            raise ValueError("invalid fused volume " + key)
    if volume.get("error") is not None and type(volume["error"]) is not str:
        raise ValueError("invalid fused volume error")
    latch = volume.get("latch")
    if latch is not None:
        if (type(latch) is not dict or type(latch.get("producer_run")) is not str
                or len(latch["producer_run"]) != 32
                or any(character not in "0123456789abcdef" for character in latch["producer_run"])):
            raise ValueError("invalid fused volume producer")
        if latch.get("error") is not None and type(latch["error"]) is not str:
            raise ValueError("invalid fused latch error")
    observation = volume.get("observation")
    if observation is not None:
        if type(observation) is not dict or type(observation.get("sequence")) is not int or observation["sequence"] < 1:
            raise ValueError("invalid fused observation sequence")
        age = observation.get("cache_age_ms")
        if type(age) not in (int, float) or not math.isfinite(age) or age < 0:
            raise ValueError("invalid fused observation cache age")
        if observation.get("error") is not None and type(observation["error"]) is not str:
            raise ValueError("invalid fused observation error")
        component = validate_volume_status(observation.get("snapshot"))
        if latch is None or type(latch.get("source_epoch")) is not int or component["epoch"] != latch["source_epoch"]:
            raise ValueError("fused observation epoch mismatch")
    return volume


class VolumeStatusPublisher:
    def __init__(self, reader, *, consume_event=None, source_kind="unverified"):
        self.reader, self.consume_event = reader, consume_event
        if source_kind not in ("fixture", "control", "unverified"):
            raise ValueError("invalid volume source kind")
        self.source_kind = source_kind
        self.run_id = uuid.uuid4().hex
        self._lock = threading.Lock()
        self._stopping = threading.Event()
        self._thread = None
        self._snapshot = None
        self._error = None
        self._sequence = 0
        self._updated = None
        self._events = deque(maxlen=8)
        self._event_identity = None

    @classmethod
    def from_control(cls, control):
        def consume(snapshot_event):
            event = control.event()
            if event is None or (event.epoch, event.sequence, event.kind) != (snapshot_event["epoch"], snapshot_event["sequence"], snapshot_event["kind"]):
                raise RuntimeError("local VOL1 event changed before ACK")
            control.acknowledge(event)
        return cls(control.monitor, consume_event=consume, source_kind="control")

    def sample_once(self):
        try:
            snapshot = validate_volume_status(self.reader())
            event = snapshot.get("event")
            if event is not None and self.consume_event is not None:
                self.consume_event(event)
            snapshot = json.loads(json.dumps(snapshot, allow_nan=False))
            with self._lock:
                self._snapshot, self._error = snapshot, None
                self._sequence += 1
                self._updated = time.monotonic()
                if self._events and self._events[-1]["epoch"] != snapshot["epoch"]:
                    self._events.clear()
                    self._event_identity = None
                if event is not None:
                    identity = (event["epoch"], event["sequence"])
                    if identity != self._event_identity:
                        self._events.append(dict(event))
                        self._event_identity = identity
        except (OSError, ValueError, RuntimeError) as error:
            with self._lock:
                self._snapshot = None
                self._error = f"{type(error).__name__}: {error}"
                self._sequence += 1
                self._updated = time.monotonic()
            self._stopping.set()

    def status(self):
        with self._lock:
            return {"schema": SCHEMA, "profile": PROFILE, "build_id": BUILD_ID,
                    "producer_run": self.run_id, "sequence": self._sequence,
                    "source_kind": self.source_kind, "local_ack": self.consume_event is not None,
                    "cache_age_ms": None if self._updated is None else (time.monotonic() - self._updated) * 1000,
                    "snapshot": self._snapshot, "error": self._error, "recent_events": list(self._events)}

    def start(self):
        if self._thread is not None:
            raise RuntimeError("publisher already started")
        self.sample_once()
        self._thread = threading.Thread(target=self._run, name="vol1-status", daemon=True)
        self._thread.start()

    def _run(self):
        while not self._stopping.wait(0.02):
            self.sample_once()

    def close(self):
        self._stopping.set()
        if self._thread is not None:
            self._thread.join(1)
            if self._thread.is_alive():
                raise RuntimeError("VOL1 reader exit unconfirmed; retain owner")


def make_volume_server(publisher, host="127.0.0.1", port=8771):
    class Handler(BaseHTTPRequestHandler):
        def setup(self):
            self.request.settimeout(0.5)
            super().setup()

        def do_GET(self):
            if self.path != "/status":
                self.send_error(404)
                return
            body = json.dumps(publisher.status(), allow_nan=False, separators=(",", ":")).encode("utf-8")
            if len(body) > MAX_BODY:
                self.send_error(503)
                return
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            self.wfile.write(body)

        def log_message(self, format, *arguments):
            pass

    return HTTPServer((host, port), Handler)


class VolumeMonitorSession:
    def __init__(self, url, *, source_address=None, timeout=0.5):
        address = urlsplit(url)
        if address.scheme != "http" or not address.hostname or address.username or address.password or address.query or address.fragment or address.path not in ("", "/status"):
            raise ValueError("expected HTTP VOL1 /status URL")
        self.host, self.port = address.hostname, address.port or 80
        ipaddress.ip_address(self.host)
        if source_address:
            ipaddress.ip_address(source_address)
        if type(timeout) not in (int, float) or not 0 < timeout <= 0.5:
            raise ValueError("VOL1 timeout must be at most 500ms")
        self.source_address, self.timeout = source_address, timeout
        self._last_run = None
        self._last_sequence = -1
        self._last_source = None

    def request(self):
        source = {"source_address": (self.source_address, 0)} if self.source_address else {}
        connection = HTTPConnection(self.host, self.port, timeout=self.timeout, **source)
        started = time.monotonic()
        connected_socket = None
        def interrupt():
            if connected_socket is not None:
                try:
                    connected_socket.shutdown(socket.SHUT_RDWR)
                except OSError:
                    pass
        timer = threading.Timer(self.timeout, interrupt)
        try:
            connection.connect()
            connected_socket = connection.sock
            remaining = self.timeout - (time.monotonic() - started)
            if remaining <= 0:
                raise TimeoutError("VOL1 connection deadline")
            connection.sock.settimeout(remaining)
            timer.interval = remaining
            timer.start()
            connection.request("GET", "/status")
            response = connection.getresponse()
            if response.status != 200 or response.headers.get_content_type() != "application/json":
                raise ValueError("invalid VOL1 HTTP response")
            length = response.getheader("Content-Length")
            if length is None or not 0 < int(length) <= MAX_BODY:
                raise ValueError("invalid VOL1 response size")
            data = response.read(MAX_BODY + 1)
            if len(data) != int(length) or time.monotonic() - started > self.timeout:
                raise ValueError("truncated/late VOL1 response")
            result = json.loads(data)
            if type(result) is not dict or result.get("schema") != SCHEMA or result.get("profile") != PROFILE or type(result.get("build_id")) is not int or result["build_id"] != BUILD_ID:
                raise ValueError("wrong volume service identity")
            run_id, sequence, age = result.get("producer_run"), result.get("sequence"), result.get("cache_age_ms")
            if type(run_id) is not str or len(run_id) != 32 or any(character not in "0123456789abcdef" for character in run_id) or type(sequence) is not int or sequence < 0:
                raise ValueError("invalid volume producer identity")
            if type(age) not in (int, float) or not math.isfinite(age) or not 0 <= age <= 500:
                raise ValueError("stale volume producer cache")
            if self._last_run == run_id and sequence < self._last_sequence:
                raise ValueError("volume status sequence regressed")
            if result.get("source_kind") not in ("fixture", "control", "unverified") or type(result.get("local_ack")) is not bool:
                raise ValueError("invalid volume source provenance")
            events = result.get("recent_events")
            if type(events) is not list or len(events) > 8:
                raise ValueError("invalid volume event history")
            for event in events:
                if type(event) is not dict or event.get("kind") not in ("SOFT", "LOUD") or any(type(event.get(key)) is not int or not 0 < event[key] <= 0xFFFFFFFF for key in ("epoch", "sequence")):
                    raise ValueError("invalid historical volume event")
            if result.get("snapshot") is not None:
                snapshot = validate_volume_status(result["snapshot"])
                if snapshot["snapshot_valid"]:
                    source_id = (run_id, snapshot["epoch"], snapshot["sample_count"], snapshot["window_count"])
                    if self._last_source is not None and source_id[:2] == self._last_source[:2] and any(current < previous for current, previous in zip(source_id[2:], self._last_source[2:])):
                        raise ValueError("volume source counters regressed")
                    self._last_source = source_id
            elif not isinstance(result.get("error"), str):
                raise ValueError("volume status has neither snapshot nor fault")
            self._last_run, self._last_sequence = run_id, sequence
            return result
        except HTTPException as error:
            raise ConnectionError(str(error)) from error
        finally:
            timer.cancel()
            if timer.ident is not None:
                timer.join(0.1)
            connection.close()

    def close(self):
        pass


def main(arguments=None):
    import argparse
    from contextlib import nullcontext
    import importlib

    if getattr(main, "retained_session", None) is not None:
        raise RuntimeError("previous VOL1 monitor owner still retained")
    parser = argparse.ArgumentParser(description="VOL1 read-only small-status monitor")
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--fixture", action="store_true", help="explicit synthetic source; no hardware")
    mode.add_argument("--control-factory", help="authorized module:function returning a managed VolumeControl context")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8771)
    options = parser.parse_args(arguments)
    context = nullcontext()
    if options.control_factory:
        module_name, function_name = options.control_factory.split(":", 1)
        context = getattr(importlib.import_module(module_name), function_name)()
    started = time.monotonic()

    def fixture():
        windows = max(1, int((time.monotonic() - started) / 0.02000896))
        level = int((1 + math.sin(windows / 12)) * 70)
        return {"schema": SCHEMA, "profile": PROFILE, "build_id": BUILD_ID, "epoch": 1,
                "enabled": True, "clock_locked": True, "faults": 0, "ack_error": False,
                "state": 1, "snapshot_valid": True, "sample_count": windows * 977,
                "window_count": windows, "l1_sum": level * 977, "mean_abs": level,
                "thresholds": {"quiet": 10 * 977, "soft": 50 * 977, "loud": 100 * 977}, "event": None}

    control = context.__enter__()
    publisher = server = None
    try:
        publisher = VolumeStatusPublisher(fixture, source_kind="fixture") if options.fixture else VolumeStatusPublisher.from_control(control)
        server = make_volume_server(publisher, options.host, options.port)
        try:
            publisher.start()
            print(f"VOL1 {publisher.source_kind} http://{options.host}:{server.server_port}/status", flush=True)
            server.serve_forever(poll_interval=0.1)
        except KeyboardInterrupt:
            pass
        finally:
            server.server_close()
            publisher.close()
    except BaseException:
        if publisher is not None and publisher._thread is not None and publisher._thread.is_alive():
            main.retained_session = (context, control, publisher, server)
        else:
            context.__exit__(*sys.exc_info())
        raise
    else:
        context.__exit__(None, None, None)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())