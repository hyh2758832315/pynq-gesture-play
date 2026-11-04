from copy import deepcopy
from dataclasses import asdict, replace
import math
import threading
import time
from uuid import uuid4

from .game_sdk import VolumeSignal
from .volume_monitor import validate_volume_status


class VolumeEventLatch:
    def __init__(self, control, *, producer_run=None, now=time.monotonic):
        self._control = control
        self._producer = uuid4().hex if producer_run is None else producer_run
        VolumeSignal(self._producer, 1, 1, "SOFT", 1, 1)
        self._now = now
        self._lock = threading.Lock()
        self._poll_lock = threading.Lock()
        self._pending = None
        self._generation = 1
        self._epoch = None
        self._sequence = 0
        self._suspended = self._released = False
        self._error = None
        self._last_receipt = None
        self._accepted = self._consumed = self._discarded = 0
        self._observation = None
        self._monitor_sequence = 0

    def _discard_locked(self, reason):
        if self._pending is not None:
            self._last_receipt = {**self._pending, "disposition": reason}
            self._discarded += 1
            self._pending = None

    def _fault_locked(self, error):
        if self._error is None:
            self._error = f"{type(error).__name__}: {error}"
        self._discard_locked("FAULT")

    def poll_once(self):
        with self._poll_lock:
            with self._lock:
                if self._error is not None:
                    return False
                if self._pending is not None:
                    if self._now() >= self._pending["expires"]:
                        self._fault_locked(RuntimeError("unconsumed volume event expired"))
                    return False
                generation = self._generation
            snapshot = None
            observed_at = self._now()
            try:
                snapshot = validate_volume_status(self._control.monitor())
                if (not snapshot["snapshot_valid"] or not snapshot["clock_locked"]
                        or not snapshot["enabled"] or snapshot["faults"] or snapshot["ack_error"]):
                    raise RuntimeError("volume source is not healthy")
                with self._lock:
                    if self._epoch is not None and snapshot["epoch"] != self._epoch:
                        raise RuntimeError("volume source epoch changed")
                    self._epoch = snapshot["epoch"]
                source = snapshot["event"]
                if source is None:
                    return False
                event = self._control.event()
                fields = ("epoch", "sequence", "kind", "source_sample", "source_window")
                if event is None or any(getattr(event, field) != source[field] for field in fields):
                    raise RuntimeError("volume event changed before reservation")
                signal = VolumeSignal(self._producer, *(getattr(event, field) for field in fields))
                if (type(event.expires) not in (int, float) or not math.isfinite(event.expires)
                        or not self._now() < event.expires <= self._now() + 0.1):
                    raise RuntimeError("invalid or expired volume deadline")
                with self._lock:
                    if event.sequence <= self._sequence:
                        raise RuntimeError("volume event sequence regressed or repeated")
                    self._pending = {"signal": asdict(signal), "expires": event.expires,
                                     "consumer_generation": generation, "hardware_acked": False}
                self._control.acknowledge(event)
                with self._lock:
                    self._sequence = event.sequence
                    self._accepted += 1
                    if self._pending is None:
                        self._last_receipt = {"signal": asdict(signal), "expires": event.expires,
                                              "consumer_generation": generation, "hardware_acked": True,
                                              "disposition": "lifecycle changed during ACK"}
                        return False
                    self._pending["hardware_acked"] = True
                    if self._now() >= event.expires:
                        raise RuntimeError("volume ACK completed after original deadline")
                    if generation != self._generation or self._suspended or self._released:
                        self._discard_locked("consumer inactive")
                        return False
                return True
            except Exception as error:
                with self._lock:
                    self._fault_locked(error)
                return False
            finally:
                if snapshot is not None:
                    with self._lock:
                        self._monitor_sequence += 1
                        self._observation = {"sequence": self._monitor_sequence,
                                             "observed_at": observed_at, "snapshot": deepcopy(snapshot)}

    def consume(self, tick_id):
        if type(tick_id) is not int or tick_id < 0:
            raise ValueError("volume consumer requires a nonnegative integer tick")
        with self._lock:
            pending = self._pending
            if self._error is not None or self._suspended or self._released or pending is None:
                return None
            if not pending["hardware_acked"]:
                return None
            if self._now() >= pending["expires"]:
                self._fault_locked(RuntimeError("unconsumed volume event expired"))
                return None
            self._pending = None
            self._consumed += 1
            self._last_receipt = {**pending, "disposition": "consumed", "sample_tick": tick_id}
            return VolumeSignal(**pending["signal"])

    def suspend(self):
        with self._lock:
            self._generation += 1
            self._suspended = True
            self._discard_locked("paused")

    def resume(self):
        with self._lock:
            if self._released:
                raise RuntimeError("released volume input requires a new consumer")
            self._generation += 1
            self._suspended = False
            self._discard_locked("resumed")

    def release(self):
        with self._lock:
            self._generation += 1
            self._released = True
            self._discard_locked("released")

    def bind_consumer(self):
        with self._lock:
            if self._error is not None or not self._released:
                raise RuntimeError("new volume consumer requires a released healthy latch")
            self._generation += 1
            self._released = self._suspended = False
            self._discard_locked("new consumer")

    def status(self):
        with self._lock:
            observation = None if self._observation is None else {
                "sequence": self._observation["sequence"],
                "cache_age_ms": max(0.0, self._now() - self._observation["observed_at"]) * 1000,
                "snapshot": self._observation["snapshot"], "error": self._error}
            return deepcopy({"producer_run": self._producer, "consumer_generation": self._generation,
                             "source_epoch": self._epoch, "pending": self._pending,
                             "suspended": self._suspended, "released": self._released,
                             "error": self._error, "accepted": self._accepted,
                             "consumed": self._consumed, "discarded": self._discarded,
                             "last_receipt": self._last_receipt, "observation": observation})


class VolumeInputReader:
    def __init__(self, read, *, producer_run, now=time.monotonic):
        VolumeSignal(producer_run, 1, 1, "SOFT", 1, 1)
        self._read, self._producer, self._now = read, producer_run, now
        self._lock = threading.RLock()
        self._source = None
        self._epoch = None
        self._error = self._last_receipt = None
        self._released, self._suspended = True, False
        self._generation = 0
        self._cutoff = 0
        self._armed_window = None
        self._seen = self._consumed = self._discarded = 0
        self._drops = {"expired_on_read": 0, "old_generation": 0, "duplicate_read": 0,
                       "sequence_gap": 0, "waiting_armed": 0}

    def _refresh(self):
        try:
            source = self._read()
            if source is None:
                return
            if source["producer_run"] != self._producer:
                raise RuntimeError("volume producer identity changed")
            if source.get("error") is not None or source["phase"] in (4, 5):
                raise RuntimeError(source.get("error") or "volume producer fault")
            if source["phase"] not in (1, 2, 3):
                raise RuntimeError("invalid volume lifecycle phase")
            if source["phase"] == 2:
                names = ("observed_ns", "monitor_sequence", "epoch", "state", "sample_count", "window_count",
                         "l1_sum", "quiet", "soft", "loud", "event_sequence", "event_kind")
                if any(type(source[name]) is not int or source[name] < 0 for name in names):
                    raise RuntimeError("invalid volume source counters")
                if (not source["enabled"] or not source["clock_locked"] or source["faults"]
                        or source["ack_error"] or not source["snapshot_valid"] or source["state"] not in range(4)):
                    raise RuntimeError("volume source is not healthy")
                if (source["observed_ns"] > int(self._now() * 1e9) or not source["monitor_sequence"]
                        or not 0 < source["quiet"] < source["soft"] < source["loud"]):
                    raise RuntimeError("invalid volume source time or thresholds")
                if self._source is not None and (source["observed_ns"] < self._source["observed_ns"]
                                                or source["event_sequence"] < self._source["event_sequence"]):
                    raise RuntimeError("volume source time or event sequence regressed")
                if source["event_kind"]:
                    event_fields = ("event_epoch", "event_sample", "event_window", "expires_ns", "acked_ns", "publication_id")
                    if (source["event_kind"] not in (1, 2) or source["event_sequence"] < 1
                            or any(type(source[name]) is not int or source[name] < 1 for name in event_fields)
                            or source["acked_ns"] > int(self._now() * 1e9)
                            or source["expires_ns"] > source["acked_ns"] + 100_000_000):
                        raise RuntimeError("invalid confirmed volume event identity or time")
            if source["monitor_sequence"]:
                if self._epoch is not None and source["epoch"] != self._epoch:
                    raise RuntimeError("volume source epoch changed")
                if self._source is not None and source["monitor_sequence"] < self._source["monitor_sequence"]:
                    raise RuntimeError("volume observation sequence regressed")
                self._epoch = source["epoch"]
            self._source = source
        except Exception as error:
            self._error = self._error or f"{type(error).__name__}: {error}"

    def consume(self, tick_id):
        if type(tick_id) is not int or tick_id < 0:
            raise ValueError("volume consumer requires a nonnegative integer tick")
        with self._lock:
            self._refresh()
            source = self._source
            if self._released or self._suspended or self._error or source is None:
                return None
            current = int(self._now() * 1_000_000_000)
            if (source["phase"] != 2 or not source["snapshot_valid"]
                    or current - source["observed_ns"] > 100_000_000):
                return None
            if self._armed_window is None:
                if (source["state"] == 1 and source["window_count"] > 0
                        and source["l1_sum"] < source["quiet"]
                        and source["observed_ns"] - 20_008_960 >= self._cutoff):
                    self._armed_window = source["window_count"]
                self._drops["waiting_armed"] += 1
                return None
            sequence = source["event_sequence"]
            if not source["event_kind"]:
                return None
            if sequence <= self._seen:
                self._drops["duplicate_read"] += 1
                return None
            self._drops["sequence_gap"] += max(0, sequence - self._seen - 1)
            self._seen = sequence
            reason = None
            if (source["event_epoch"] != self._epoch or source["event_kind"] not in (1, 2)
                    or not 0 < source["acked_ns"] < source["expires_ns"]):
                self._error = "RuntimeError: invalid confirmed volume event"
                return None
            if current >= source["expires_ns"]:
                reason = "expired_on_read"
            elif (source["expires_ns"] - 100_000_000 < self._cutoff
                    or source["event_window"] <= self._armed_window):
                reason = "old_generation"
            if reason is not None:
                self._discarded += 1
                self._drops[reason] += 1
                return None
            signal = VolumeSignal(self._producer, source["event_epoch"], sequence,
                "SOFT" if source["event_kind"] == 1 else "LOUD",
                source["event_sample"], source["event_window"])
            self._consumed += 1
            self._last_receipt = {"signal": asdict(signal), "expires": source["expires_ns"] / 1e9,
                "consumer_generation": self._generation, "hardware_acked": True,
                "acked_ns": source["acked_ns"], "publication_id": source["publication_id"],
                "disposition": "consumed", "sample_tick": tick_id}
            return signal

    def _activate(self):
        self._generation += 1
        self._cutoff = int(self._now() * 1_000_000_000)
        self._armed_window = None
        self._last_receipt = None
        self._suspended = False

    def bind_consumer(self):
        with self._lock:
            self._refresh()
            if self._error or not self._released:
                raise RuntimeError("new volume consumer requires a released healthy latch")
            self._released = False
            self._activate()

    def suspend(self):
        with self._lock:
            self._generation += 1
            self._suspended = True
            self._armed_window = None
            self._last_receipt = None

    def resume(self):
        with self._lock:
            if self._released:
                raise RuntimeError("released volume input requires a new consumer")
            self._activate()

    def release(self):
        with self._lock:
            self._generation += 1
            self._released = True
            self._armed_window = None
            self._last_receipt = None

    def status(self, *, refresh=True):
        with self._lock:
            if refresh:
                self._refresh()
            source = self._source
            observation = None
            if source is not None and source["monitor_sequence"]:
                valid = bool(source["snapshot_valid"])
                windows = source["window_count"]
                snapshot = {"schema": "voice-volume-status-v1", "profile": "VOICE_VOLUME_ONLY_V1",
                    "build_id": 0xC00C0001, "epoch": source["epoch"], "enabled": bool(source["enabled"]),
                    "clock_locked": bool(source["clock_locked"]), "faults": source["faults"],
                    "ack_error": bool(source["ack_error"]), "state": source["state"],
                    "snapshot_valid": valid, "sample_count": source["sample_count"] if valid else None,
                    "window_count": windows if valid else None,
                    "l1_sum": source["l1_sum"] if valid and windows else None,
                    "mean_abs": source["l1_sum"] / 977 if valid and windows else None,
                    "thresholds": {name: source[name] for name in ("quiet", "soft", "loud")} if valid else None,
                    "event": None}
                observation = {"sequence": source["monitor_sequence"], "snapshot": snapshot,
                    "cache_age_ms": max(0, self._now() - source["observed_ns"] / 1e9) * 1000,
                    "error": self._error}
            return deepcopy({"producer_run": self._producer, "source_epoch": self._epoch,
                "consumer_generation": self._generation, "released": self._released,
                "suspended": self._suspended, "error": self._error, "pending": None,
                "accepted": 0 if source is None else source["ack_count"], "consumed": self._consumed,
                "discarded": self._discarded, "last_receipt": self._last_receipt,
                "observation": observation, "drops": self._drops,
                "waiting_armed": self._armed_window is None})


class VolumeGameInputProvider:
    def __init__(self, visual, latch, *, manifest=None, game_run_id=None):
        self._visual, self._latch = visual, latch
        self._manifest, self._game_run = manifest, game_run_id
        self._lock = threading.RLock()
        self._receipt = None
        self._released = self._suspended = False
        contract = None if manifest is None else manifest.volume_inputs
        self._mapping = None if manifest is None else manifest.game_id if contract is None else contract.vision_mapping
        self._enabled = contract is not None

    @property
    def capabilities(self):
        return {"schema": "local-game-volume-v1", "volume_schema": "volume-signal-v1",
                "vision": deepcopy(getattr(self._visual, "capabilities", None))}

    def new_game_session(self, manifest, game_run_id):
        if self._manifest is not None or manifest.inputs is not None:
            raise ValueError("volume provider requires an independent raw game input contract")
        status = self._latch.status()
        if not status["released"] or status["error"] is not None:
            raise RuntimeError("volume game requires a released healthy input latch")
        session = VolumeGameInputProvider(self._visual, self._latch, manifest=manifest, game_run_id=game_run_id)
        if session._enabled:
            self._latch.bind_consumer()
        return session

    def sample_current_for_game(self, game_id, *, tick_id):
        return self.sample_for_game(game_id, tick_id=tick_id)

    def sample(self, *, tick_id, timestamp_ns=None):
        if self._manifest is None:
            raise RuntimeError("volume input requires a per-game session")
        return self.sample_for_game(self._manifest.game_id, tick_id=tick_id, timestamp_ns=timestamp_ns)[0]

    def sample_for_game(self, game_id, *, tick_id, timestamp_ns=None):
        with self._lock:
            if self._manifest is None or game_id != self._manifest.game_id:
                raise ValueError("volume game input session identity mismatch")
            value, visual_receipt = self._visual.sample_for_game(
                self._mapping, tick_id=tick_id, timestamp_ns=timestamp_ns)
            signal = None
            status = None
            if self._enabled and not self._released and not self._suspended:
                signal = self._latch.consume(tick_id)
                status = (self._latch.status(refresh=False) if isinstance(self._latch, VolumeInputReader)
                          else self._latch.status())
                if status["error"] is not None:
                    raise RuntimeError(status["error"])
            self._receipt = {"schema": "volume-input-receipt-v1", "game_run": self._game_run, "game_id": game_id,
                             "sample_tick": value.tick_id, "sample_timestamp_ns": value.timestamp_ns,
                             "signal": None if signal is None else asdict(signal),
                             "input_delivered": signal is not None,
                             "hardware_acked": signal is not None, "logic_consumed": signal is not None,
                             "source_receipt": None if signal is None or status is None else status["last_receipt"]}
            return replace(value, volume=signal), visual_receipt

    def volume_receipt_for_tick(self, tick_id):
        with self._lock:
            if self._receipt is None:
                return None
            if type(tick_id) is not int or self._receipt["sample_tick"] != tick_id:
                raise ValueError("volume receipt tick mismatch")
            return deepcopy(self._receipt)

    def sample_menu_control(self, *, tick_id):
        return self._visual.sample_menu_control(tick_id=tick_id)

    def suspend(self):
        with self._lock:
            if self._enabled:
                self._latch.suspend()
            self._suspended = True
            self._receipt = None
            self._visual.suspend()

    def resume(self):
        with self._lock:
            if self._released:
                raise RuntimeError("released volume game input requires a new session")
            if self._enabled:
                self._latch.resume()
            self._suspended = False
            self._receipt = None
            self._visual.resume()

    def release(self, message="Volume game input stopped"):
        with self._lock:
            if self._enabled:
                self._latch.release()
            self._released = True
            self._receipt = None
            self._visual.release(message)