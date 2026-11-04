import argparse
from collections import Counter
from contextlib import contextmanager
from dataclasses import replace
import datetime
import hashlib
import json
import mmap
import os
from pathlib import Path
import resource
import signal
import struct
import sys
import threading
import time


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from pynq_usb_hand.buttons import ButtonSession, STATES
from pynq_usb_hand.controller import Controller
from pynq_usb_hand.motion import MotionSettings
from pynq_usb_hand.orca_backend import OrcaBackend, OrcaModel, SafetyPolicy


class ButtonReader:
    def __init__(self, address):
        self.descriptor = os.open("/dev/mem", os.O_RDONLY | os.O_SYNC)
        try:
            self.memory = mmap.mmap(self.descriptor, mmap.PAGESIZE, flags=mmap.MAP_SHARED,
                                    prot=mmap.PROT_READ, offset=address)
        except BaseException:
            os.close(self.descriptor)
            raise

    def read(self):
        value = struct.unpack_from("<I", self.memory, 0)[0]
        if value & ~15:
            raise ValueError("Unexpected bits in four-button input")
        return value

    def close(self):
        self.memory.close()
        os.close(self.descriptor)


class AuditBackend(OrcaBackend):
    def __init__(self, *arguments, full_audit=True, **options):
        if type(full_audit) is not bool:
            raise ValueError("Full audit must be an explicit boolean")
        super().__init__(*arguments, **options)
        self.full_audit = full_audit
        self.context = "motion"
        self.counts = Counter()
        self.samples = []
        self.releases = []
        self.intervals = []
        if not full_audit:
            return
        original = self.transport.writePort

        def packet_write(packet):
            packet = bytes(packet)
            if len(packet) < 6 or packet[:2] != b"\xff\xff" or packet[-1] != (~sum(packet[2:-1]) & 255):
                raise ValueError("Invalid outgoing servo packet")
            instruction, address = packet[4:6]
            if instruction == 3 and address == 42:
                if len(packet) != 13 or packet[8:10] != b"\0\0" or self.client.servo.scs_makeword(packet[10], packet[11]) != 500:
                    raise ValueError("Position packet does not use speed500/duration0")
            self.counts[f"{self.context}:{instruction}:{address}"] += 1
            return original(packet)

        self.transport.writePort = packet_write

    @contextmanager
    def interval(self, name):
        if not self.full_audit:
            yield
            return
        previous = self.context
        self.context = name
        started, cpu = time.monotonic(), time.process_time()
        try:
            yield
        finally:
            self.intervals.append({"phase": name, "started": started, "finished": time.monotonic(),
                                   "cpu_seconds": time.process_time() - cpu})
            self.context = previous

    def connect(self, cancel):
        with self.interval("connect"):
            super().connect(cancel)

    def arm(self, cancel):
        with self.interval("arm"):
            super().arm(cancel)

    def sample(self, cancel):
        frame = super().sample(cancel)
        if not self.full_audit:
            return frame
        self.samples.append({"phase": self.context, "sequence": frame.sequence,
                             "started": frame.started, "finished": frame.finished,
                             "errors": {state: max(abs(frame.joints[joint] - goal) / (self.roms[joint][1] - self.roms[joint][0])
                                                    for joint, goal in target.items()) for state, target in self.poses.items()},
                             "voltage_min": min(item["voltage"] for item in self.health.values()),
                             "voltage_max": max(item["voltage"] for item in self.health.values()),
                             "temperature_max": max(item["temperature"] for item in self.health.values())})
        return frame

    def release(self):
        with self.interval("release"):
            failed = super().release()
            self.releases.append({"finished": time.monotonic(), "failed_ids": list(failed), "ids": list(self.model.ids)})
            return failed


def playback_settings(options):
    enabled = getattr(options, "fixed_playback", False)
    if enabled != getattr(options, "confirm_startup_only", False):
        raise ValueError("Fixed playback and startup-only confirmation must be selected together")
    waits = getattr(options, "playback_stage_waits", None)
    if enabled:
        if getattr(options, "minimal_interactions", False):
            raise ValueError("Fixed playback and endpoint feedback are separate modes")
        return MotionSettings.fixed_playback(stage_waits=waits or ())
    if waits is not None:
        raise ValueError("Playback stage waits require fixed playback")
    return None


def run(options):
    playback = playback_settings(options)
    minimal = getattr(options, "minimal_interactions", False)
    full_audit = getattr(options, "full_audit", False)
    if minimal and not getattr(options, "confirm_native_trajectory", False):
        raise ValueError("Minimal interactions require reviewed native trajectory")
    report = {"schema": "pynq-usb-hand-buttons-v1", "result": "PENDING", "release_ready": False,
              "board_time": datetime.datetime.now().astimezone().isoformat(), "events": [], "segments": [],
              "boot_id": Path("/proc/sys/kernel/random/boot_id").read_text().strip(),
              "audit": "full" if full_audit else "lean",
              "mapping": dict(enumerate(STATES)), "profile": "endpoints-interpolated-speed500",
              "policy": {"temperature": 40, "scan_age": 2, "feedback_gap": 2, "settle_delay": 0.05,
                         "max_reached_samples": 20, "lease": 5, "renew": 0.5, "hold_before_release": 2,
                         "request_budget": 45, "session_budget": options.seconds, "button_poll": 0.02},
              "completed": []}
    if minimal:
        report["profile"] = "endpoints-native-stages-speed500-release-on-reached"
        report["policy"].update(settle_delay=0.4, sample_interval=0.15, max_reached_samples=10,
                                hold_before_release=0, native_trajectory_confirmed=True,
                                stage_targets=True)
    if playback is not None:
        report["profile"] = "fixed-playback-speed500"
        report["policy"] = {"startup_temperature": 40, "startup_scan_age": 2,
                            "runtime_feedback": False, "reached_confirmation": False,
                            "persistent_torque": True, "write_ack": True, "shutdown_off_readback": True,
                            "stage_waits": playback.stage_waits, "timings_hardware_verified": False,
                            "lease": 5, "renew": 0.5, "request_budget": 45,
                            "session_budget": options.seconds, "button_poll": 0.02}
    controller = reader = backend = None
    with options.output.open("x", encoding="utf-8") as stream:
        try:
            if report["boot_id"] != options.boot_id:
                raise RuntimeError("Board boot changed")
            manifest = json.loads((ROOT / "source_manifest.json").read_text())
            for name, digest in manifest["sha256"].items():
                if hashlib.sha256((ROOT / name).read_bytes()).hexdigest() != digest:
                    raise ValueError(f"Candidate SHA mismatch: {name}")
            # OrcaModel verifies all frozen files before importing the vendor.
            # Build it before opening even the read-only GPIO mapping; do not
            # repeat the same 117 hashes in this single startup path.
            model = OrcaModel(ROOT)
            reader = ButtonReader(options.address)
            reader.read()
            backend = AuditBackend(model, options.port, SafetyPolicy(40, 2), skip_unchanged=True,
                                   speed=500, allow_stage_targets=minimal or playback is not None,
                                   allow_playback=playback is not None, full_audit=full_audit)
            settings = MotionSettings.endpoints(settle_delay=0.4 if minimal else 0.05,
                                                max_reached_samples=10 if minimal else 20,
                                                max_feedback_gap=2, max_age=2, stage_targets=minimal)
            if minimal:
                settings = replace(settings, sample_interval=0.15)
            controller = Controller(lambda: backend, lease_seconds=5,
                                    idle_release_after=None if minimal or playback is not None else 2,
                                    settings=playback if playback is not None else settings)
            controller.wait_connected()
            session = ButtonSession(controller, release_on_reached=minimal, playback=playback is not None)
            started = time.monotonic()
            segment_wall, segment_cpu = started, time.process_time()
            segment_counts = Counter(backend.counts) if full_audit else None
            segment = "idle_off"
            stop = threading.Event()
            print("BUTTONS_READY BTN0=default BTN1=paper BTN2=scissors BTN3=rock; release all buttons first", flush=True)
            while time.monotonic() - started < options.seconds:
                now = time.monotonic()
                for event in session.tick(reader.read(), now):
                    event.update(monotonic=now, cpu=time.process_time())
                    if full_audit:
                        event["counts"] = dict(backend.counts)
                    report["events"].append(event)
                    if full_audit:
                        print(json.dumps(event, sort_keys=True), flush=True)
                    if event["event"] == ("played" if playback is not None else "reached"):
                        report["completed"].append(event["state"])
                next_segment = {"idle": "idle_hold" if playback is not None else "idle_off",
                                "arming": "arm", "moving": "motion", "settled": "hold_release"}[session.phase]
                if segment != next_segment:
                    finished_cpu = time.process_time()
                    report["segments"].append({"phase": segment, "started": segment_wall, "finished": now,
                                               "wall_seconds": now - segment_wall, "cpu_seconds": finished_cpu - segment_cpu,
                                               "packets": dict(backend.counts - segment_counts) if full_audit else {}})
                    segment, segment_wall, segment_cpu = next_segment, now, finished_cpu
                    segment_counts = Counter(backend.counts) if full_audit else None
                if set(report["completed"]) == set(STATES) and session.phase == "idle" and now - segment_wall >= 3:
                    report["result"] = "FOUR_BUTTONS_PLAYBACK_PASS" if playback is not None else "FOUR_BUTTONS_PASS"
                    break
                stop.wait(0.02)
            else:
                report["result"] = "BUTTON_SESSION_INCOMPLETE"
            finished = time.monotonic()
            report["segments"].append({"phase": segment, "started": segment_wall, "finished": finished,
                                       "wall_seconds": finished - segment_wall, "cpu_seconds": time.process_time() - segment_cpu,
                                       "packets": dict(backend.counts - segment_counts) if full_audit else {}})
        except BaseException as error:
            report.update(result="BUTTON_SESSION_STOPPED", error=f"{type(error).__name__}: {error}")
        finally:
            if controller is not None:
                try:
                    controller.release()
                    if not controller.wait_idle(10):
                        raise TimeoutError("Release did not finish")
                except BaseException as error:
                    report["release_error"] = f"{type(error).__name__}: {error}"
                try:
                    controller.close(10)
                except BaseException as error:
                    report["close_error"] = f"{type(error).__name__}: {error}"
                report["final_status"] = controller.status()
            if backend is not None:
                report.update(packet_counts=dict(backend.counts), samples=backend.samples,
                              releases=backend.releases, backend_intervals=backend.intervals,
                              port_closed=not backend.transport.is_open)
            if reader is not None:
                reader.close()
            report["rss_max_kb"] = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
            report["threads"] = threading.active_count()
            clean = (report.get("final_status", {}).get("lifecycle") == "CLOSED"
                     and report["final_status"]["error"] is None and report.get("port_closed")
                     and report.get("releases") and all(not item["failed_ids"] for item in report["releases"])
                     and "release_error" not in report and "close_error" not in report)
            report["cleanup_confirmed"] = bool(clean)
            if not clean:
                report["result"] = "CLEANUP_UNCONFIRMED"
            json.dump(report, stream, indent=2)
            stream.write("\n")
            stream.flush()
            os.fsync(stream.fileno())
    print(json.dumps({key: report[key] for key in ("result", "completed", "cleanup_confirmed")}), flush=True)
    return 0 if report["result"] in ("FOUR_BUTTONS_PASS", "FOUR_BUTTONS_PLAYBACK_PASS") and report["cleanup_confirmed"] else 1


def interrupted(signum, frame):
    raise KeyboardInterrupt(f"Signal {signum}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--boot-id", required=True)
    parser.add_argument("--address", required=True, type=lambda value: int(value, 0))
    parser.add_argument("--port", required=True)
    parser.add_argument("--seconds", type=float, default=180)
    parser.add_argument("--confirm-safety", action="store_true", required=True)
    parser.add_argument("--minimal-interactions", action="store_true")
    parser.add_argument("--confirm-native-trajectory", action="store_true")
    parser.add_argument("--full-audit", action="store_true")
    parser.add_argument("--fixed-playback", action="store_true")
    parser.add_argument("--confirm-startup-only", action="store_true")
    parser.add_argument("--playback-stage-waits", type=float, nargs=3, metavar=("DEFAULT", "MIDPOINT", "TARGET"))
    options = parser.parse_args()
    try:
        playback_settings(options)
    except ValueError as error:
        parser.error(str(error))
    if options.minimal_interactions != options.confirm_native_trajectory:
        parser.error("Minimal interactions and reviewed native trajectory must be selected together")
    if not 10 <= options.seconds <= 300 or options.address % mmap.PAGESIZE:
        parser.error("Expected a 10..300 second budget and aligned GPIO address")
    for signum in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP):
        signal.signal(signum, interrupted)
    raise SystemExit(run(options))
