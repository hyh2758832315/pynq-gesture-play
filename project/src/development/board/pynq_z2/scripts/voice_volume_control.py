"""VOL1 offline control library. Import never opens hardware or loads overlays.

S06 must bind an exclusive backend factory after confirming the Linux IIC bus,
0x3b straps, 10 MHz MCLK and VOL1 identity. The factory runs in a supervised
spawned process. It supplies read32(offset), write32(offset, value),
codec_read(register, length), codec_write(register, bytes), close(). Native
MMIO/IIC hangs quarantine that process/session, never reset or reload hardware.
"""

from dataclasses import dataclass
import json
import math
import multiprocessing
import os
from pathlib import Path
import time


MAGIC, BUILD_ID, SCHEMA = 0x564F4C31, 0xC00C0001, 0x00010000
PLL = bytes.fromhex("00 00 00 00 28 01")
MIC_PROFILE = (
    (0x40FA, 0), (0x40F6, 0), (0x4008, 0), (0x4009, 0),
    (0x400A, 0), (0x400C, 0), (0x400B, 0x10), (0x400D, 0x10),
    (0x400E, 0xB3), (0x400F, 0xB3), (0x4010, 1),
    (0x4011, 0), (0x4012, 0), (0x4013, 0), (0x4014, 0),
    (0x4015, 0), (0x4016, 0), (0x4017, 0), (0x4018, 0),
    (0x4019, 0x33), (0x401A, 0), (0x401B, 0),
    (0x401C, 0), (0x401D, 0), (0x401E, 0), (0x401F, 0),
    (0x4020, 0), (0x4021, 0), (0x4022, 0), (0x4023, 0xE5), (0x4024, 0xE5),
    (0x4025, 0), (0x4026, 0), (0x4027, 0), (0x4029, 0), (0x402A, 0),
    (0x40EB, 1), (0x40F2, 0), (0x40F3, 1), (0x40F4, 0), (0x40F5, 1),
    (0x40F7, 0), (0x40F8, 0), (0x40F9, 0x7F), (0x40FA, 3),
    (0x400A, 1), (0x400C, 1),
)


class VolumeFault(RuntimeError):
    pass


class _StartupTrace:
    def __init__(self, root, role):
        self.path = Path(root) / f"transport-{role}.jsonl"
        self.remaining = 512
        self.error = None

    def record(self, phase, **details):
        if self.remaining <= 0 or self.error is not None:
            return
        self.remaining -= 1
        entry = {"phase": phase, "pid": os.getpid(), "monotonic_ns": time.monotonic_ns(), **details}
        try:
            with self.path.open("a", encoding="utf-8") as output:
                output.write(json.dumps(entry) + "\n")
        except (OSError, ValueError, TypeError) as error:
            self.error = str(error)


def _record(trace, phase, **details):
    if trace is not None:
        trace.record(phase, **details)


def _milestone(state, phase, request_id):
    if state is not None:
        state[phase + 1] = time.monotonic_ns()
        state[0], state[1] = request_id, phase


def _register_batch(backend, operations, deadline, milestones=None):
    if type(operations) is not tuple or not 1 <= len(operations) <= 32:
        raise VolumeFault("register batch must contain 1..32 operations")
    for operation in operations:
        if type(operation) is not tuple or len(operation) != 2:
            raise VolumeFault("invalid register batch operation")
        name, arguments = operation
        if name not in ("read32", "write32") or type(arguments) is not tuple:
            raise VolumeFault("invalid register batch operation")
        if len(arguments) != (1 if name == "read32" else 2):
            raise VolumeFault("invalid register batch arguments")
        if type(arguments[0]) is not int or not 0 <= arguments[0] <= 0xFFC or arguments[0] % 4:
            raise VolumeFault("invalid register batch offset")
        if name == "write32" and (type(arguments[1]) is not int or not 0 <= arguments[1] <= 0xFFFFFFFF):
            raise VolumeFault("invalid register batch value")
    values = []
    for index, (name, arguments) in enumerate(operations, start=1):
        if time.monotonic() >= deadline:
            raise VolumeFault("register batch deadline exceeded")
        if milestones is not None:
            milestones[8], milestones[9], milestones[10] = index, arguments[0], int(name == "write32")
        values.append(getattr(backend, name)(*arguments))
        if milestones is not None:
            milestones[11] = index
    return tuple(values)


def _acknowledge_event(backend, expected_epoch, sequence, deadline, milestones=None):
    if any(type(value) is not int or not 1 <= value <= 0xFFFFFFFF
           for value in (expected_epoch, sequence)):
        raise VolumeFault("invalid event ACK identity")
    for pending in (True, False):
        epoch, status, faults = _register_batch(backend, tuple(("read32", (offset,))
            for offset in (0x18, 0x10, 0x14)), deadline, milestones)
        if any(type(value) is not int or not 0 <= value <= 0xFFFFFFFF
               for value in (epoch, status, faults)):
            raise VolumeFault("invalid register response")
        if epoch != expected_epoch:
            raise VolumeFault("epoch changed/reset; rebind an authorized session")
        if faults or status & 0x14 or status & 9 != 9:
            raise VolumeFault("audio fault, ACK error, disabled source or MCLK lost")
        if bool(status & 2) != pending:
            raise VolumeFault("event no longer pending" if pending else "ACK did not release event")
        if pending:
            _register_batch(backend, tuple(("write32", (offset, value)) for offset, value in
                ((0x34, expected_epoch), (0x38, sequence), (0x30, 4))), deadline, milestones)
    return True


def _serve(connection, factory, trace_root=None, milestones=None):
    backend = None
    trace = _StartupTrace(trace_root, "worker") if trace_root is not None else None
    request_id = 0
    try:
        _record(trace, "factory_begin")
        backend = factory()
        _record(trace, "factory_returned")
        connection.send((True, None))
        while True:
            operation, arguments = connection.recv()
            request_id += 1
            if milestones is not None:
                milestones[1] = 0
                for index in range(2, 12):
                    milestones[index] = 0
            _milestone(milestones, 1, request_id)
            _record(trace, "child_received", request_id=request_id, operation=operation)
            if operation == "trace_stop":
                _record(trace, "trace_stopped")
                trace = None
                connection.send((True, None))
                continue
            if operation == "close":
                backend.close()
                connection.send((True, None))
                break
            if operation not in {"read32", "write32", "codec_read", "codec_write", "register_batch", "acknowledge_event"}:
                raise VolumeFault("unknown operation")
            details = {"request_id": request_id, "operation": operation, "offset": arguments[0]}
            if operation == "write32":
                details["value"] = arguments[1]
            _record(trace, "native_begin", **details)
            _milestone(milestones, 2, request_id)
            if operation == "register_batch":
                result = _register_batch(backend, *arguments, milestones=milestones)
            elif operation == "acknowledge_event":
                result = _acknowledge_event(backend, *arguments, milestones=milestones)
            else:
                result = getattr(backend, operation)(*arguments)
            _milestone(milestones, 3, request_id)
            _record(trace, "native_returned", **details)
            _record(trace, "reply_begin", request_id=request_id)
            _milestone(milestones, 4, request_id)
            connection.send((True, result))
            _milestone(milestones, 5, request_id)
            _record(trace, "reply_sent", request_id=request_id)
    except Exception as error:
        _milestone(milestones, 6, request_id)
        _record(trace, "worker_error", request_id=request_id, error=str(error)[:512])
        try:
            connection.send((False, str(error)))
        except (BrokenPipeError, EOFError, OSError):
            pass
    finally:
        connection.close()


class DirectTransport:
    def __init__(self, backend, milestones=None):
        self.backend = backend
        self._milestones = milestones
        self._request_id = 0
        self.failed = False
        self.codec_attempted = self.codec_configured = False

    def call(self, operation, *arguments, deadline):
        if (self.failed or type(deadline) not in (int, float)
                or not math.isfinite(deadline) or not 0 < deadline - time.monotonic() <= 2):
            self.failed = True
            raise VolumeFault("expired/quarantined direct transport")
        try:
            self._request_id += 1
            _milestone(self._milestones, 2, self._request_id)
            if operation in ("read32", "write32"):
                result = _register_batch(self.backend, ((operation, arguments),), deadline, self._milestones)[0]
            elif operation == "register_batch":
                result = _register_batch(self.backend, *arguments, deadline, self._milestones)
            elif operation == "acknowledge_event":
                result = _acknowledge_event(self.backend, *arguments, deadline, self._milestones)
            elif operation in ("codec_read", "codec_write"):
                result = getattr(self.backend, operation)(*arguments)
            else:
                raise VolumeFault("unknown direct operation")
            if time.monotonic() >= deadline:
                raise VolumeFault("direct transport deadline exceeded")
            _milestone(self._milestones, 3, self._request_id)
            return result
        except Exception:
            _milestone(self._milestones, 6, self._request_id)
            self.failed = True
            raise

    def register_batch(self, operations, *, deadline):
        return self.call("register_batch", operations, deadline=deadline)

    def acknowledge_event(self, epoch, sequence, *, deadline):
        return self.call("acknowledge_event", epoch, sequence, deadline=deadline)

    def close(self):
        self.backend.close()


class ProcessTransport:
    """Exclusive single-threaded owner; each operation has a hard IPC deadline."""

    def __init__(self, factory, timeout=0.5, *, trace_root=None, diagnostic_root=None, diagnostic_context=None):
        self.failed = False
        self.codec_attempted = self.codec_configured = False
        self.trace = _StartupTrace(trace_root, "parent") if trace_root is not None else None
        self.request_id = 0
        self._seconds(timeout)
        context = multiprocessing.get_context("spawn")
        self._milestones = None if diagnostic_root is None else context.RawArray("Q", 12)
        self._diagnostic_root = diagnostic_root
        self._diagnostic_context = diagnostic_context
        self.diagnostic_error = None
        self._parent_diagnostic = {"operation": "factory", "request_id": 0}
        self.connection, child = context.Pipe()
        self.process = context.Process(target=_serve, args=(child, factory, trace_root, self._milestones), daemon=True)
        self.process.start()
        child.close()
        _record(self.trace, "worker_started", child_pid=self.process.pid)
        self._receive(time.monotonic() + timeout)

    @staticmethod
    def _seconds(value):
        if type(value) not in (int, float) or not math.isfinite(value) or not 0 < value <= 2:
            raise ValueError("timeout must be finite and within (0, 2] seconds")

    def _abort(self):
        first_failure = not self.failed
        milestones = None if self._milestones is None else tuple(self._milestones)
        self.failed = True
        self.connection.close()
        if self.process.is_alive():
            self.process.terminate()
            self.process.join(0.2)
        if self.process.is_alive():
            self.process.kill()
            self.process.join(0.2)
        if first_failure and self._milestones is not None:
            try:
                report = {"schema": "volume-transport-fault-v1", "parent_pid": os.getpid(),
                          "child_pid": self.process.pid, "child_alive": self.process.is_alive(),
                          "parent": self._parent_diagnostic,
                          "vision_stages": [] if self._diagnostic_context is None else list(self._diagnostic_context),
                          "worker": dict(zip(("request_id", "phase", "received_ns", "native_begin_ns",
                              "native_returned_ns", "reply_begin_ns", "reply_sent_ns", "error_ns",
                              "batch_index", "offset", "is_write", "batch_returned"), milestones))}
                with (Path(self._diagnostic_root) / f"transport-fault-{os.getpid()}.json").open("x", encoding="utf-8") as output:
                    json.dump(report, output, indent=2)
            except (OSError, ValueError, TypeError) as error:
                self.diagnostic_error = str(error)
        _record(self.trace, "quarantined", request_id=self.request_id,
                child_pid=self.process.pid, child_alive=self.process.is_alive(), exitcode=self.process.exitcode)

    def _receive(self, deadline):
        try:
            if self._milestones is not None:
                self._parent_diagnostic.update(deadline_ns=int(deadline * 1_000_000_000), wait_ns=time.monotonic_ns())
            remaining = deadline - time.monotonic()
            _record(self.trace, "parent_wait", request_id=self.request_id, remaining_s=remaining)
            remaining = deadline - time.monotonic()
            ready = remaining > 0 and self.connection.poll(remaining)
            if self._milestones is not None:
                self._parent_diagnostic.update(poll_returned_ns=time.monotonic_ns(), ready=ready)
            if not ready:
                raise VolumeFault("native transport deadline exceeded; session quarantined")
            success, result = self.connection.recv()
            if self._milestones is not None:
                self._parent_diagnostic["received_ns"] = time.monotonic_ns()
            _record(self.trace, "parent_received", request_id=self.request_id, success=success,
                    remaining_s=deadline - time.monotonic())
            if not success:
                raise VolumeFault(result)
            if time.monotonic() >= deadline:
                raise VolumeFault("native transport deadline exceeded; session quarantined")
            return result
        except (EOFError, OSError, VolumeFault) as error:
            self._abort()
            raise VolumeFault(str(error)) from error

    def call(self, operation, *arguments, deadline):
        remaining = deadline - time.monotonic()
        if self.failed or not 0 < remaining <= 2:
            self._abort()
            raise VolumeFault("expired/quarantined transport")
        self.request_id += 1
        if self._milestones is not None:
            self._parent_diagnostic = dict(request_id=self.request_id, operation=operation,
                                          arguments=arguments, send_begin_ns=time.monotonic_ns())
        details = {"request_id": self.request_id, "operation": operation, "remaining_s": remaining}
        if arguments:
            details["offset"] = arguments[0]
        if operation == "write32":
            details["value"] = arguments[1]
        _record(self.trace, "parent_send_begin", **details)
        if time.monotonic() >= deadline:
            self._abort()
            raise VolumeFault("native transport deadline exceeded; session quarantined")
        try:
            self.connection.send((operation, arguments))
            if self._milestones is not None:
                self._parent_diagnostic["sent_ns"] = time.monotonic_ns()
            _record(self.trace, "parent_sent", request_id=self.request_id,
                    remaining_s=deadline - time.monotonic())
        except (OSError, EOFError) as error:
            self._abort()
            raise VolumeFault(str(error)) from error
        return self._receive(deadline)

    def stop_trace(self):
        if self.trace is not None:
            self.call("trace_stop", deadline=time.monotonic() + 0.5)
            _record(self.trace, "trace_stopped")
            self.trace = None

    def register_batch(self, operations, *, deadline):
        return self.call("register_batch", operations, deadline, deadline=deadline)

    def acknowledge_event(self, epoch, sequence, *, deadline):
        return self.call("acknowledge_event", epoch, sequence, deadline, deadline=deadline)

    def close(self):
        try:
            if not self.failed:
                self.call("close", deadline=time.monotonic() + 0.5)
                self.process.join(0.2)
        finally:
            self._abort()


def configure_codec(transport, *, stopped, straps_confirmed, mclk_hz, timeout=1.0):
    ProcessTransport._seconds(timeout)
    if stopped is not True or straps_confirmed is not True or mclk_hz != 10_000_000:
        raise ValueError("requires stopped VOL1, confirmed 0x3b straps and 10 MHz MCLK")
    if transport.codec_attempted:
        raise VolumeFault("codec initialization already attempted; create a new authorized session")
    transport.codec_attempted = True
    deadline = time.monotonic() + timeout

    def write(register, payload):
        if transport.call("codec_write", register, payload, deadline=deadline) != len(payload):
            raise VolumeFault("short codec write")

    def read(register, length):
        value = transport.call("codec_read", register, length, deadline=deadline)
        if type(value) is not bytes or len(value) != length:
            raise VolumeFault("short codec read")
        return value

    write(0x4000, b"\x0e")
    write(0x4002, PLL[:-1] + b"\x00")
    write(0x4002, PLL)
    for _ in range(501):
        value = read(0x4002, 6)
        if value[:5] != PLL[:5] or value[5] & 0xFD != 1:
            raise VolumeFault("PLL readback mismatch")
        if value[5] & 2:
            break
        if time.monotonic() >= deadline:
            raise VolumeFault("PLL lock deadline exceeded")
    else:
        raise VolumeFault("PLL lock poll limit exceeded")
    write(0x4000, b"\x0f")
    for register, value in MIC_PROFILE:
        write(register, bytes([value]))
    for register, value in {0x4000: 0x0F, **dict(MIC_PROFILE)}.items():
        if read(register, 1)[0] != value:
            raise VolumeFault(f"codec readback mismatch at {register:#06x}")
    if read(0x4002, 6) != PLL[:-1] + b"\x03":
        raise VolumeFault("PLL lost lock")
    transport.codec_configured = True


@dataclass(frozen=True)
class Event:
    epoch: int
    sequence: int
    kind: str
    source_sample: int
    source_window: int
    expires: float


class VolumeControl:
    """Small snapshots only. Hardware ownership/reset continuity is an S06 precondition."""

    def __init__(self, transport, *, exclusive_owner):
        if exclusive_owner is not True:
            raise ValueError("exclusive owner required")
        self.transport = transport
        self.epoch = None
        self.offered = None
        self.failed = False
        deadline = time.monotonic() + 0.5
        identity = tuple(self._read(offset, deadline) for offset in (0, 4, 8, 0x1C))
        if identity != (MAGIC, BUILD_ID, SCHEMA, 977):
            self.failed = True
            raise VolumeFault("VOL1 identity mismatch")

    def _read(self, offset, deadline):
        value = self.transport.call("read32", offset, deadline=deadline)
        if type(value) is not int or not 0 <= value <= 0xFFFFFFFF:
            raise VolumeFault("invalid register response")
        return value

    def _write(self, offset, value, deadline):
        self.transport.call("write32", offset, value, deadline=deadline)

    def _registers(self, operations, deadline):
        batch = getattr(self.transport, "register_batch", None)
        if callable(batch):
            values = batch(operations, deadline=deadline)
        else:
            values = tuple(self.transport.call(name, *arguments, deadline=deadline)
                           for name, arguments in operations)
        if type(values) is not tuple or len(values) != len(operations):
            raise VolumeFault("invalid register batch response")
        for (name, _arguments), value in zip(operations, values):
            if name == "read32" and (type(value) is not int or not 0 <= value <= 0xFFFFFFFF):
                raise VolumeFault("invalid register response")
        return values

    def _live(self, deadline):
        if self.failed:
            raise VolumeFault("session quarantined")
        epoch, status, faults = self._registers(
            tuple(("read32", (offset,)) for offset in (0x18, 0x10, 0x14)), deadline)
        if self.epoch is not None and epoch != self.epoch:
            self.failed = True
            raise VolumeFault("epoch changed/reset; rebind an authorized session")
        if faults or status & 0x14 or not status & 8:
            self.failed = True
            raise VolumeFault("audio fault, ACK error or MCLK lost")
        return epoch, status

    def configure(self, *, quiet_sum, soft_sum, loud_sum, enable=False):
        if any(type(value) is not int for value in (quiet_sum, soft_sum, loud_sum)) or not 0 <= quiet_sum < soft_sum < loud_sum <= 0xFFFFFFFF:
            raise ValueError("requires 0 <= quiet < soft < loud <= uint32")
        if type(enable) is not bool or (enable and not self.transport.codec_configured):
            raise VolumeFault("enabling requires verified codec")
        deadline = time.monotonic() + 0.5
        epoch, _ = self._live(deadline)
        if epoch == 0xFFFFFFFF:
            raise VolumeFault("epoch exhausted")
        for offset, value in ((0x20, soft_sum), (0x24, loud_sum), (0x28, quiet_sum), (0x2C, int(enable)), (0x30, 1)):
            self._write(offset, value, deadline)
        self.epoch = epoch + 1
        self.offered = None
        self._live(deadline)

    def monitor(self):
        self.offered = None
        started = time.monotonic()
        deadline = started + 0.1
        epoch, status, faults = self._registers(
            tuple(("read32", (offset,)) for offset in (0x18, 0x10, 0x14)), deadline)
        result = {"schema": "voice-volume-status-v1", "profile": "VOICE_VOLUME_ONLY_V1",
                  "build_id": BUILD_ID, "epoch": epoch, "enabled": bool(status & 1),
                  "clock_locked": bool(status & 8), "faults": faults, "ack_error": bool(status & 16),
                  "state": (status >> 8) & 7, "snapshot_valid": False, "sample_count": None,
                  "window_count": None, "l1_sum": None, "mean_abs": None, "thresholds": None,
                  "event": None}
        if faults or status & 0x14 or not status & 1 or not status & 8:
            return result
        offsets = (0x3C, 0x84, *range(0x40, 0x84, 4), 0x18, 0x10, 0x14, 0x3C, 0x84)
        snapshot_requested = time.monotonic()
        values = self._registers((("write32", (0x30, 2)),) +
                    tuple(("read32", (offset,)) for offset in offsets), deadline)
        generation, valid = values[1:3]
        words = values[3:20]
        final_epoch, final_status, final_faults, final_generation, final_valid = values[20:]
        stable = generation == final_generation and valid == final_valid == 1
        if not stable or final_epoch != epoch or words[2] != epoch or words[1] or final_faults or final_status & 0x14 or final_status & 9 != 9:
            raise VolumeFault("monitor snapshot invalidated")
        result.update(snapshot_valid=True, sample_count=words[3] | words[4] << 32,
                      window_count=words[5], l1_sum=words[6] if words[5] else None,
                      mean_abs=words[6] / 977 if words[5] else None,
                      thresholds={"soft": words[14], "loud": words[15], "quiet": words[16]})
        if final_status & 2 and words[9] & 4 and words[8] == epoch and words[7] and words[9] & 3 in (1, 2):
            expires = snapshot_requested + 0.1 - words[13] / 100_000_000
            if time.monotonic() < expires:
                self.offered = Event(epoch, words[7], "SOFT" if words[9] & 3 == 1 else "LOUD",
                                     words[10] | words[11] << 32, words[12], expires)
                result["event"] = {"sequence": words[7], "epoch": epoch,
                                   "kind": "SOFT" if words[9] & 3 == 1 else "LOUD",
                                   "source_sample": words[10] | words[11] << 32,
                                   "source_window": words[12], "age_ms": words[13] / 100_000}
        return result

    def event(self):
        started = time.monotonic()
        deadline = min(started + 0.1, self.offered.expires) if self.offered is not None else started + 0.1
        epoch, status = self._live(deadline)
        if self.epoch is None or not status & 1:
            raise VolumeFault("configure an enabled session first")
        if self.offered is not None:
            if self.offered.epoch != epoch or not status & 2 or time.monotonic() >= self.offered.expires:
                self.offered = None
                raise VolumeFault("monitored event lost or stale")
            return self.offered
        snapshot_requested = time.monotonic()
        self._write(0x30, 2, deadline)
        generation = self._read(0x3C, deadline)
        valid = self._read(0x84, deadline)
        words = [self._read(offset, deadline) for offset in range(0x40, 0x84, 4)]
        current_epoch, live = self._live(deadline)
        stable = generation == self._read(0x3C, deadline) and valid == self._read(0x84, deadline) == 1
        if not stable or current_epoch != epoch or words[2] != epoch or words[1]:
            raise VolumeFault("invalidated snapshot")
        if not live & 2 and not words[9] & 4:
            self.offered = None
            return None
        kind = words[9] & 3
        expires = snapshot_requested + 0.1 - words[13] / 100_000_000
        if not live & 2 or not words[9] & 4 or not words[0] & 2 or words[8] != epoch or not words[7] or kind not in (1, 2) or time.monotonic() >= expires:
            raise VolumeFault("event lost, stale or malformed")
        self.offered = Event(epoch, words[7], "SOFT" if kind == 1 else "LOUD", words[10] | words[11] << 32, words[12], expires)
        return self.offered

    def acknowledge(self, event):
        if event is not self.offered or event is None or time.monotonic() >= event.expires:
            raise VolumeFault("foreign, consumed or stale event")
        deadline = min(event.expires, time.monotonic() + 0.05)
        acknowledge = getattr(self.transport, "acknowledge_event", None)
        if callable(acknowledge):
            if acknowledge(event.epoch, event.sequence, deadline=deadline) is not True:
                raise VolumeFault("invalid event ACK response")
            self.offered = None
            return
        _, status = self._live(deadline)
        if not status & 2:
            raise VolumeFault("event no longer pending")
        self._registers(tuple(("write32", (offset, value)) for offset, value in
                              ((0x34, event.epoch), (0x38, event.sequence), (0x30, 4))), deadline)
        _, status = self._live(deadline)
        if status & 2:
            raise VolumeFault("ACK did not release event")
        self.offered = None