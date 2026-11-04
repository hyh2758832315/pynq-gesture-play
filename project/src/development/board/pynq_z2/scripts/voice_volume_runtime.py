import multiprocessing
import json
import os
from pathlib import Path
import select
import socket
import struct
import time
from uuid import uuid4

from pynq_multimodal_game.volume_monitor import validate_volume_status
from voice_volume_control import DirectTransport, VolumeControl, VolumeFault, configure_codec


PREPARED, RUNNING, STOPPED, FAULT, ORPHAN = range(1, 6)
START, STOP = 1, 2
FIELDS = (
    "phase", "observed_ns", "monitor_sequence", "epoch", "enabled", "clock_locked",
    "faults", "ack_error", "state", "snapshot_valid", "sample_count", "window_count",
    "l1_sum", "quiet", "soft", "loud", "publication_id", "event_epoch", "event_sequence",
    "event_kind", "event_sample", "event_window", "expires_ns", "acked_ns",
    "monitor_count", "ack_count", "publish_skips", "superseded", "expired_before_publish",
    "max_poll_gap_ns", "last_cycle_ns", "max_cycle_ns", "min_ack_margin_ns", "worker_pid",
    "disabled", "poll_completed_ns",
)
HEADER = struct.Struct("<II16s" + "Q" * len(FIELDS))
DIAGNOSTIC = struct.Struct("<QIIIII")
DIAGNOSTIC_SLOTS = 512
FRAME = struct.Struct("<4sII")


class VolumeSharedPage:
    def __init__(self, context, producer_run):
        self.producer_run = producer_run
        self.storage = context.RawArray("B", 16384)
        self.native_milestones = context.RawArray("Q", 12)
        self.lock = context.Lock()

    def publish(self, values, error=None, diagnostics=None):
        payload = HEADER.pack(0x56564131, 1, bytes.fromhex(self.producer_run),
                              *(values.get(name, 0) for name in FIELDS))
        payload += (error or "").encode("utf-8")[:512].ljust(512, b"\0")
        payload += diagnostics or bytes(DIAGNOSTIC.size * DIAGNOSTIC_SLOTS)
        if not self.lock.acquire(False):
            return False
        try:
            memoryview(self.storage).cast("B")[:len(payload)] = payload
        finally:
            self.lock.release()
        return True

    def read(self):
        if not self.lock.acquire(False):
            return None
        try:
            payload = bytes(memoryview(self.storage).cast("B")[:HEADER.size + 512 + DIAGNOSTIC.size * DIAGNOSTIC_SLOTS])
        finally:
            self.lock.release()
        magic, version, producer, *words = HEADER.unpack_from(payload)
        if magic == 0:
            return None
        if magic != 0x56564131 or version != 1 or producer.hex() != self.producer_run:
            raise VolumeFault("invalid volume shared page identity")
        return {**dict(zip(FIELDS, words)), "producer_run": producer.hex(),
            "error": payload[HEADER.size:HEADER.size + 512].rstrip(b"\0").decode("utf-8", errors="replace") or None,
                "diagnostics": payload[HEADER.size + 512:],
                "native_milestones_best_effort": list(self.native_milestones)}


class VolumeManagementChannel:
    def __init__(self, endpoint):
        self.socket = endpoint
        endpoint.setblocking(False)
        self.incoming = bytearray()
        self.outgoing = bytearray()
        self.closed = False

    def send(self, command, identity):
        if self.outgoing:
            raise VolumeFault("volume management response already pending")
        self.outgoing.extend(FRAME.pack(b"VVA1", command, identity))
        self.flush()

    def flush(self):
        if self.outgoing:
            try:
                sent = self.socket.send(self.outgoing)
            except BlockingIOError:
                return
            if not sent:
                raise VolumeFault("volume management send closed")
            del self.outgoing[:sent]

    def receive(self):
        try:
            chunk = self.socket.recv(FRAME.size - len(self.incoming))
        except BlockingIOError:
            return None
        if not chunk:
            self.closed = True
            return None
        self.incoming.extend(chunk)
        if len(self.incoming) != FRAME.size:
            return None
        magic, command, identity = FRAME.unpack(self.incoming)
        self.incoming.clear()
        if magic != b"VVA1":
            raise VolumeFault("invalid volume management frame")
        return command, identity

    def wait(self, command, identity, deadline, *, ignore=()):
        while time.monotonic() < deadline:
            self.flush()
            response = self.receive()
            if response == (command, identity):
                return
            if response in ignore:
                continue
            if response is not None or self.closed:
                raise VolumeFault("volume management confirmation rejected")
            select.select([self.socket], [self.socket] if self.outgoing else [], [],
                          max(0, deadline - time.monotonic()))
        raise VolumeFault("volume management deadline; retain Overlay lease")


class VolumeProducer:
    def __init__(self, control, page, *, now=time.monotonic_ns):
        self.control, self.page, self.now = control, page, now
        self.values: dict[str, int] = {"phase": RUNNING, "worker_pid": os.getpid()}
        self.error = None
        self._epoch = control.epoch
        self._sequence = 0
        self._previous_started = None
        self._unpublished = False
        self.diagnostics = bytearray(DIAGNOSTIC.size * DIAGNOSTIC_SLOTS)
        self._diagnostic_index = 0
        self._stages = [0, 0, 0]

    def publish(self):
        if self.page.publish(self.values, self.error, self.diagnostics):
            self._unpublished = False
        else:
            self.values["publish_skips"] = self.values.get("publish_skips", 0) + 1

    def poll_once(self):
        started = self.now()
        self._stages = [0, 0, 0]
        offset = self._diagnostic_index % DIAGNOSTIC_SLOTS * DIAGNOSTIC.size
        try:
            self._poll_once()
        finally:
            DIAGNOSTIC.pack_into(self.diagnostics, offset, started,
                min(0xFFFFFFFF, self.now() - started),
                *(min(0xFFFFFFFF, value) for value in self._stages), 0)
            self._diagnostic_index += 1
        published = self.now()
        self.publish()
        struct.pack_into("<I", self.diagnostics, offset + 24,
                         min(0xFFFFFFFF, self.now() - published))

    def _poll_once(self):
        started = self.now()
        if self._previous_started is not None:
            self.values["max_poll_gap_ns"] = max(self.values.get("max_poll_gap_ns", 0),
                                                  started - self._previous_started)
        self._previous_started = started
        if self._unpublished and started >= self.values.get("expires_ns", 0):
            self.values["expired_before_publish"] = self.values.get("expired_before_publish", 0) + 1
            self.values["event_kind"] = 0
            self._unpublished = False
        operation = self.now()
        snapshot = validate_volume_status(self.control.monitor())
        self._stages[0] = self.now() - operation
        if (not snapshot["snapshot_valid"] or not snapshot["enabled"]
                or not snapshot["clock_locked"] or snapshot["faults"] or snapshot["ack_error"]):
            raise VolumeFault("autonomous volume source is not healthy")
        if snapshot["epoch"] != self._epoch:
            raise VolumeFault("autonomous volume source epoch changed")
        for name in ("epoch", "enabled", "clock_locked", "faults", "ack_error", "state",
                     "snapshot_valid", "sample_count", "window_count", "l1_sum"):
            self.values[name] = int(snapshot[name] or 0)
        self.values.update(snapshot["thresholds"])
        self.values["observed_ns"] = started
        self.values["monitor_sequence"] = self.values.get("monitor_sequence", 0) + 1
        self.values["monitor_count"] = self.values["monitor_sequence"]
        source = snapshot["event"]
        if source is not None:
            operation = self.now()
            event = self.control.event()
            self._stages[1] = self.now() - operation
            fields = ("epoch", "sequence", "kind", "source_sample", "source_window")
            if event is None or any(getattr(event, name) != source[name] for name in fields):
                raise VolumeFault("autonomous volume offer changed before reservation")
            if event.sequence <= self._sequence:
                raise VolumeFault("autonomous volume sequence regressed or repeated")
            operation = self.now()
            self.control.acknowledge(event)
            self._stages[2] = self.now() - operation
            acknowledged = self.now()
            expires = int(event.expires * 1_000_000_000)
            if acknowledged >= expires:
                raise VolumeFault("volume ACK completed after original deadline")
            if self.values.get("publication_id", 0):
                self.values["superseded"] = self.values.get("superseded", 0) + 1
            self._sequence = event.sequence
            self.values.update(publication_id=self.values.get("publication_id", 0) + 1,
                               event_epoch=event.epoch, event_sequence=event.sequence,
                               event_kind=1 if event.kind == "SOFT" else 2,
                               event_sample=event.source_sample, event_window=event.source_window,
                               expires_ns=expires, acked_ns=acknowledged,
                               ack_count=self.values.get("ack_count", 0) + 1)
            margin = expires - acknowledged
            previous_margin = self.values.get("min_ack_margin_ns")
            self.values["min_ack_margin_ns"] = margin if previous_margin is None else min(previous_margin, margin)
            self._unpublished = True
        finished = self.now()
        self.values["poll_completed_ns"] = finished
        self.values["last_cycle_ns"] = finished - started
        self.values["max_cycle_ns"] = max(self.values.get("max_cycle_ns", 0), finished - started)


def _volume_worker(endpoint, factory, sums, page, process_guard):
    channel = VolumeManagementChannel(endpoint)
    descriptor = None
    transport = control = producer = None
    values = {"phase": PREPARED, "worker_pid": os.getpid()}
    error = None
    try:
        if process_guard is not None:
            descriptor = process_guard.detach()
            os.fstat(descriptor)
        transport = DirectTransport(factory(), milestones=page.native_milestones)
        control = VolumeControl(transport, exclusive_owner=True)
        control.configure(**sums, enable=False)
        page.publish(values)
        channel.send(PREPARED, 0)
        next_poll = time.monotonic()
        while True:
            channel.flush()
            request = channel.receive()
            if channel.closed:
                if descriptor is None:
                    raise VolumeFault("fixture volume owner disconnected")
                raise VolumeFault("volume parent disconnected; retain entire Overlay")
            if request is not None:
                command, identity = request
                if command == START:
                    if producer is None:
                        configure_codec(transport, stopped=True, straps_confirmed=True, mclk_hz=10_000_000)
                        control.configure(**sums, enable=True)
                        producer = VolumeProducer(control, page)
                        producer.poll_once()
                        values = producer.values
                    channel.send(RUNNING, identity)
                    next_poll = time.monotonic() + 0.02
                elif command == STOP:
                    control.configure(**sums, enable=False)
                    snapshot = control.monitor()
                    if snapshot["enabled"] or snapshot["faults"] or snapshot["ack_error"]:
                        raise VolumeFault("autonomous volume disable unconfirmed")
                    transport.close()
                    values.update(phase=STOPPED, disabled=1)
                    page.publish(values, diagnostics=producer.diagnostics if producer is not None else None)
                    channel.send(STOPPED, identity)
                    deadline = time.monotonic() + 0.5
                    while channel.outgoing and time.monotonic() < deadline:
                        select.select([], [endpoint], [], max(0, deadline - time.monotonic()))
                        channel.flush()
                    if channel.outgoing:
                        raise VolumeFault("volume stop confirmation not sent")
                    return
                else:
                    raise VolumeFault("unexpected volume lifecycle command")
            if producer is not None and time.monotonic() >= next_poll:
                producer.poll_once()
                next_poll = max(next_poll + 0.02, time.monotonic())
            select.select([endpoint], [endpoint] if channel.outgoing else [], [],
                          max(0, next_poll - time.monotonic()) if producer is not None else None)
    except BaseException as failure:
        error = f"{type(failure).__name__}: {failure}"
        values.update(phase=ORPHAN if channel.closed else FAULT, event_kind=0)
        if channel.closed and control is not None and transport is not None and not transport.failed:
            try:
                control.configure(**sums, enable=False)
                snapshot = control.monitor()
                if snapshot["enabled"] or snapshot["faults"] or snapshot["ack_error"]:
                    raise VolumeFault("orphan volume disable unconfirmed")
                transport.close()
                values["disabled"] = 1
            except BaseException as cleanup:
                error += f"; cleanup: {type(cleanup).__name__}: {cleanup}"
        diagnostics = producer.diagnostics if producer is not None else None
        page.publish(values, error, diagnostics)
        if descriptor is not None:
            endpoint.close()
            while True:
                page.publish(values, error, diagnostics)
                select.select([], [], [], 1.0)
    finally:
        endpoint.close()
        if descriptor is not None:
            os.close(descriptor)


class AutonomousVolumeProcess:
    def __init__(self, factory, sums, *, process_guard=None, producer_run=None,
                 diagnostic_root=None, diagnostic_context=None):
        context = multiprocessing.get_context("spawn")
        self.producer_run = producer_run or uuid4().hex
        self.page = VolumeSharedPage(context, self.producer_run)
        parent, child = socket.socketpair()
        self.channel = VolumeManagementChannel(parent)
        self.process = context.Process(target=_volume_worker,
            args=(child, factory, sums, self.page, process_guard), daemon=False)
        self._cached = None
        self._prepared = self._started = self._start_requested = False
        self._stop_requested = self._stop_acknowledged = False
        self._parent_error = None
        self._diagnostic_root = diagnostic_root
        self._diagnostic_context = diagnostic_context
        self._diagnostic_attempted = False
        self.diagnostic_error = None
        self.stopped_confirmed = False
        self.process.start()
        child.close()

    def start(self):
        if self._stop_requested or self.stopped_confirmed:
            raise VolumeFault("volume process requires a fresh lifecycle owner")
        if self._started:
            return self
        if not self._prepared:
            self.channel.wait(PREPARED, 0, time.monotonic() + 30)
            self._prepared = True
        if not self._start_requested:
            self.channel.send(START, 1)
            self._start_requested = True
        self.channel.wait(RUNNING, 1, time.monotonic() + 3)
        self._started = True
        return self

    def read(self):
        snapshot = self.page.read()
        if snapshot is not None:
            self._cached = snapshot
        result = self._cached
        if self._cached is not None and not self.process.is_alive() and not self.stopped_confirmed:
            result = {**self._cached, "error": self._cached.get("error") or
                    "volume worker exited without confirmed cleanup", "phase": FAULT}
        if result is not None and self._parent_error:
            result = {**result, "error": result.get("error") or self._parent_error, "phase": FAULT}
        if result is not None and result.get("error") and self._diagnostic_root is not None and not self._diagnostic_attempted:
            self._diagnostic_attempted = True
            try:
                record = {name: value for name, value in result.items() if name != "diagnostics"}
                record.update(schema="volume-autonomous-fault-v1",
                    diagnostics=list(DIAGNOSTIC.iter_unpack(result["diagnostics"])),
                    vision_stages=[] if self._diagnostic_context is None else list(self._diagnostic_context))
                path = Path(self._diagnostic_root) / ("volume-autonomous-fault-" + self.producer_run + ".json")
                with path.open("x", encoding="utf-8") as output:
                    json.dump(record, output, allow_nan=False)
            except Exception as error:
                self.diagnostic_error = f"{type(error).__name__}: {error}"
        return result

    def close(self):
        if self.stopped_confirmed:
            return
        try:
            if not self._prepared:
                self.channel.wait(PREPARED, 0, time.monotonic() + 30)
                self._prepared = True
            if not self.process.is_alive() and not self._stop_requested:
                raise VolumeFault("volume child exited without disable confirmation; retain Overlay lease")
            if not self._stop_requested:
                self.channel.send(STOP, 2)
                self._stop_requested = True
            if not self._stop_acknowledged:
                self.channel.wait(STOPPED, 2, time.monotonic() + 1, ignore=((RUNNING, 1),))
                self._stop_acknowledged = True
            self.process.join(1)
            if self.process.is_alive() or self.process.exitcode != 0:
                raise VolumeFault("volume child exit unconfirmed; retain Overlay lease")
            self.stopped_confirmed = True
            self.channel.socket.close()
        except BaseException as error:
            self._parent_error = self._parent_error or f"{type(error).__name__}: {error}"
            try:
                self.read()
            except Exception as diagnostic:
                self.diagnostic_error = f"{type(diagnostic).__name__}: {diagnostic}"
            raise