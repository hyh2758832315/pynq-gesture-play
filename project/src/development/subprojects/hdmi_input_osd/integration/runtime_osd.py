"""Board-owned, observation-only HDMI overlay service (no game event reads)."""
from __future__ import annotations

import math
from pathlib import Path
import threading
import time
from uuid import uuid4

from .osd_publisher import AudioObservation, HandObservation, OsdPublisher
from .osd_registers import OsdRegisters


class ObservationHub:
    """Single immutable latest value; publishing never waits for MMIO or a queue."""
    def __init__(self):
        self.hand = None
        self.error = None

    def publish(self, observed, *, run_id, config_epoch, frame_id, observed_ns):
        try:
            point = observed.get("centroid")
            valid = observed.get("bbox") is not None and point is not None
            valid = bool(valid and len(point) == 2 and
                         all(type(v) in (int, float) and math.isfinite(v) for v in point) and
                         0 <= point[0] < 640 and 0 <= point[1] < 360)
            # Same display-coordinate transform as the existing preview centroid.
            # 640 -> 1280 maps a source pixel centre to 2*x + 0.5.
            x, y = ((2 * point[0] + .5) / 1279 * 2 - 1,
                    (2 * point[1] + .5) / 719 * 2 - 1) if valid else (0., 0.)
            fist = observed.get("stable") == "0" and observed.get("rps") == "ROCK"
            self.hand = HandObservation(f"{run_id}:{config_epoch}", frame_id,
                                        observed_ns, x, y, valid, bool(valid and fist))
            self.error = None
        except Exception as error:
            self.error = f"{type(error).__name__}: {error}"
            self.clear()

    def clear(self):
        old = self.hand
        if old is not None:
            self.hand = HandObservation(old.producer_run, old.frame_id, old.observed_ns,
                                        old.x, old.y, False, False)


def audio_observation(page):
    if page is None or page.get("observed_ns", 0) == 0:
        return None
    healthy = bool(page["phase"] == 2 and page["enabled"] and page["clock_locked"] and
                   page["snapshot_valid"] and page["window_count"] and
                   not page["faults"] and not page["ack_error"] and not page.get("error"))
    # All three values use the same fixed 977-sample hardware window.
    return AudioObservation(page["producer_run"], page["epoch"], page["sample_count"],
                            page["observed_ns"], page["l1_sum"] / 977,
                            page["soft"] / 977, page["loud"] / 977, healthy)


class InputOsdService:
    INSTANCE = "input_osd_0"

    def __init__(self, session, hub, audio_reader, *, allow_test=False, thresholds=(16., 28.)):
        self.session, self.hub, self.audio_reader = session, hub, audio_reader
        self.lease = self.publisher = self.thread = None
        self.stop_event = threading.Event()
        self.enabled = True
        self.error = None
        self.disabled_confirmed = False
        self.cycles = self.cpu_ns = self.max_cycle_ns = 0
        self.last_hand = self.last_audio = None
        self.last_tick_ns = 0
        self.allow_test = allow_test
        self.test_value = None
        self.fallback_audio = AudioObservation("OSD_UNAVAILABLE", 0, 0, 0, 0., *thresholds, False)
        self.probe_requested = 0
        self.probe_completed = 0
        self.probe = None

    def open(self):
        if self.lease is not None or self.stop_event.is_set():
            raise RuntimeError("OSD service requires a fresh owner")
        self.lease = self.session.borrow("hdmi-input-osd", instances=frozenset({self.INSTANCE}))
        self.lease.retain(self)
        try:
            actual = self.session.ip_address(self.lease, Path(self.lease.bitfile_name).with_suffix(".hwh"), self.INSTANCE)
            if actual != (0x43C20000, 4096):
                raise RuntimeError("OSD HWH address or range mismatch")
            self.publisher = OsdPublisher(OsdRegisters(self.lease.mmio(self.INSTANCE)))
            self.thread = threading.Thread(target=self._run, name="hdmi-input-osd", daemon=True)
            self.thread.start()
        except BaseException:
            if self.thread is None:
                self.lease.close()
                self.lease = None
            raise
        return self

    def _run(self):
        try:
            while not self.stop_event.is_set():
                start, cpu = time.monotonic_ns(), time.thread_time_ns()
                hand = self.hub.hand
                audio = audio_observation(self.audio_reader())
                if audio is None and self.publisher.audio is None:
                    audio = self.fallback_audio
                fixture = self.test_value
                if fixture is not None and start < fixture[0]:
                    _, hand, audio = fixture
                self.publisher.tick(hand, audio, now_ns=start, enabled=self.enabled)
                request = self.probe_requested
                if request != self.probe_completed:
                    self.probe = dict(request=request, observed_ns=time.monotonic_ns(),
                        expected=self.publisher.last_words, actual=self.publisher.io.read_shadow())
                    self.probe_completed = request
                self.last_hand, self.last_audio = self.publisher.hand, self.publisher.audio
                self.last_tick_ns = start
                self.cycles += 1
                self.cpu_ns += time.thread_time_ns() - cpu
                self.max_cycle_ns = max(self.max_cycle_ns, time.monotonic_ns() - start)
                self.stop_event.wait(max(0., (start + 33_333_334 - time.monotonic_ns()) / 1e9))
        except Exception as error:
            self.error = f"{type(error).__name__}: {error}"
        finally:
            try:
                self._disable()
            except Exception as error:
                self.error = self.error or f"disable: {type(error).__name__}: {error}"

    def _disable(self):
        # Only the owning thread touches registers; shutdown confirms the frame
        # boundary ACK before allowing the Overlay lease to be released.
        deadline = time.monotonic() + .25
        committed = False
        while time.monotonic() < deadline:
            now = time.monotonic_ns()
            if committed:
                if not self.publisher.io.read(4) & 1:
                    self.disabled_confirmed = True
                    return
            else:
                committed = self.publisher.tick(None, None, now_ns=now, enabled=False)
            time.sleep(.002)
        raise RuntimeError("OSD disable frame ACK timed out; retain Overlay lease")

    def status(self):
        now = time.monotonic_ns()
        p = self.publisher
        hand, audio = self.last_hand, self.last_audio
        return dict(schema="hdmi-input-osd-v1", enabled=self.enabled, rate_hz=30,
                    test_allowed=self.allow_test,
                    register_io=None if p is None else p.io.mode, probe=self.probe,
                    test_active=self.test_value is not None and now < self.test_value[0],
                    thread_alive=self.thread is not None and self.thread.is_alive(),
                    error=self.error or self.hub.error, cycles=self.cycles,
                    cpu_ns=self.cpu_ns, max_cycle_ns=self.max_cycle_ns,
                    commits=0 if p is None else p.commits,
                    last_submitted_words=None if p is None else p.last_words,
                    busy_skips=0 if p is None else p.busy_skips,
                    last_tick_age_ms=None if not self.last_tick_ns else (now-self.last_tick_ns)/1e6,
                    hand_source=None if hand is None else dict(run=hand.producer_run,
                        frame=hand.frame_id, age_ms=(now-hand.observed_ns)/1e6,
                        position_valid=hand.position_valid, fist=hand.fist, x=hand.x, y=hand.y),
                    audio_source=None if audio is None else dict(run=audio.producer_run,
                        epoch=audio.epoch, sample_count=audio.sample_count,
                        age_ms=(now-audio.observed_ns)/1e6, healthy=audio.healthy,
                        mean_abs=audio.mean_abs, soft=audio.soft, loud=audio.loud),
                    disabled_confirmed=self.disabled_confirmed, lease_retained=self.lease is not None)

    def request_probe(self):
        if not self.allow_test:
            raise RuntimeError("OSD diagnostic readback requires --osd-test-stimuli")
        self.probe_requested += 1

    def set_test(self, options):
        if not self.allow_test:
            raise RuntimeError("OSD-only stimuli require explicit --osd-test-stimuli")
        if type(options) is not dict:
            raise ValueError("OSD test options must be an object")
        if not options:
            self.test_value = None
            return
        if set(options) != {"x", "y", "position_valid", "fist", "mean_abs", "soft", "loud", "hold_ms"}:
            raise ValueError("invalid OSD-only stimulus fields")
        hold = options["hold_ms"]
        if type(hold) is not int or not 1 <= hold <= 5000:
            raise ValueError("OSD fixture hold must be 1..5000ms")
        now, run = time.monotonic_ns(), "OSD_TEST:" + uuid4().hex
        hand = HandObservation(run, 1, now, options["x"], options["y"],
                               options["position_valid"], options["fist"])
        audio = AudioObservation(run, 1, 977, now, options["mean_abs"],
                                  options["soft"], options["loud"], True)
        # One frozen observation: even a long hold must expire by source age.
        self.test_value = (now + hold * 1_000_000, hand, audio)

    def close(self):
        self.stop_event.set()
        if self.thread is not None:
            self.thread.join(1.)
            if self.thread.is_alive() or not self.disabled_confirmed:
                raise RuntimeError(f"{self.error}; OSD cleanup unconfirmed; retain Overlay lease")
        if self.lease is not None:
            self.lease.close()
            self.lease = None
