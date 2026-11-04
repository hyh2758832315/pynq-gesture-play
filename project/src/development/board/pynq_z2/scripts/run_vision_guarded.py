from __future__ import annotations

import hashlib
import ipaddress
import math
import argparse
import importlib
import importlib.util
import json
import os
import signal
import subprocess
import sys
import time
import uuid
from dataclasses import dataclass
from dataclasses import replace
from pathlib import Path
from threading import Event


ROOT = Path(__file__).resolve().parents[3]
RUNTIME = ROOT / "handoffs/gesture_vision_v61/runtime"
CANDIDATE = Path(__file__).with_name("vision_async_runtime.py")
OWNER_SCRIPTS = frozenset({
    "project1_live_ov5640.py", "vision_async_runtime.py", "run_vision_guarded.py",
    "capture_camera_direct_plug.py", "run_camera_live_guarded.py", "run_accel_guarded.py",
    "verify_skin_dma.py", "verify_dma.py",
})


@dataclass(frozen=True)
class VisionLaunch:
    bitstream: Path
    camera_dir: Path
    camera_sha256: str
    output_dir: Path
    bind: str = "127.0.0.1"
    port: int = 8081
    duration: float = 3600.
    preview_fps: float = 10.
    debug_fps: float = 5.
    python: str = "/usr/local/share/pynq-venv/bin/python3"

    def command(self) -> list[str]:
        bit = self.bitstream.resolve()
        if bit.name != "camera_hand_skin_v6.bit" or not bit.is_file() or not bit.with_suffix(".hwh").is_file():
            raise ValueError("Paired camera_hand_skin_v6 bit/HWH required")
        digest = self.camera_sha256.lower()
        if len(digest) != 64 or any(character not in "0123456789abcdef" for character in digest):
            raise ValueError("Camera module SHA-256 required")
        camera = self.camera_dir.resolve() / "capture_camera_direct_plug.py"
        if hashlib.sha256(camera.read_bytes()).hexdigest() != digest:
            raise ValueError("Camera module SHA-256 mismatch")
        if not isinstance(ipaddress.ip_address(self.bind), ipaddress.IPv4Address):
            raise ValueError("IPv4 preview bind required")
        if type(self.port) is not int or not 1 <= self.port <= 65535:
            raise ValueError("Preview port must be within 1..65535")
        if isinstance(self.duration, bool) or not math.isfinite(self.duration) or not 0 < self.duration <= 86400:
            raise ValueError("Duration must be finite and within 0..86400 seconds")
        if any(isinstance(rate, bool) or not math.isfinite(rate) or not 0 <= rate <= 30
               for rate in (self.preview_fps, self.debug_fps)):
            raise ValueError("Preview rates must be finite and within 0..30 Hz")
        return [self.python, "-u", str(CANDIDATE), str(bit), str(self.output_dir.resolve() / "first.ppm"),
                "--live", "--host-only", "--pl-skin", "--tracking", "--debug-view", "--no-record",
                "--bind", self.bind, "--port", str(self.port), "--duration", str(self.duration),
                "--camera-dir", str(self.camera_dir.resolve()), "--results-dir", str(self.output_dir.resolve()),
                "--preview-fps", str(self.preview_fps), "--debug-fps", str(self.debug_fps),
                "--guard-receipt", str(self.output_dir.resolve() / "worker_lifecycle.json")]


def conflicting_owners(proc_root: Path, excluded: set[int]) -> list[int]:
    conflicts = []
    for command in proc_root.glob("[0-9]*/cmdline"):
        pid = int(command.parent.name)
        if pid in excluded:
            continue
        try:
            arguments = command.read_bytes().decode(errors="replace").split("\0")
        except OSError:
            continue
        scripts = {Path(argument).name for argument in arguments}
        gpu_agent = bool({"pynq_multimodal_game.agent", "pynq_multimodal_game.agent.cli", "voice-view-agent"}
                         & (scripts | set(arguments))) and any(
            argument in ("c6i-video", "c6i-shell", "c6i", "--backend=c6i-video", "--backend=c6i-shell",
                         "--return-source=c6i") for argument in arguments)
        if OWNER_SCRIPTS & scripts or gpu_agent:
            conflicts.append(pid)
    return sorted(conflicts)


def _frozen_module(name):
    spec = importlib.util.spec_from_file_location("_vision_guard_" + name, RUNTIME / (name + ".py"))
    if spec is None or spec.loader is None:
        raise ImportError(name)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def verify_package(directory):
    manifest = json.loads((Path(directory) / "manifest.json").read_text(encoding="utf-8-sig"))
    if manifest.get("protocol") != "SKN6":
        raise ValueError("Frozen SKN6 package required")
    trusted = json.loads((RUNTIME / "manifest.json").read_text(encoding="utf-8-sig"))
    for name in ("camera_hand_skin_v6.bit", "camera_hand_skin_v6.hwh"):
        if manifest.get("sha256", {}).get(name) != trusted["sha256"][name]:
            raise ValueError(f"Frozen hardware identity mismatch: {name}")
    _frozen_module("verify_package").verify(directory)


def halt_engines(hwh):
    return _frozen_module("run_accel_guarded").halt_engines(hwh)


def kill_group(pid):
    try:
        getattr(os, "killpg")(pid, getattr(signal, "SIGKILL"))
    except ProcessLookupError:
        pass


class HardwareLease:
    def __init__(self, path):
        fcntl = importlib.import_module("fcntl")
        path.parent.mkdir(parents=True, exist_ok=True)
        self.stream = path.open("a+b")
        try:
            fcntl.flock(self.stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BaseException:
            self.stream.close()
            raise

    def fileno(self):
        return self.stream.fileno()

    def close(self):
        self.stream.close()


def ancestors(proc_root=Path("/proc")):
    result = set()
    pid = os.getpid()
    while pid and pid not in result:
        result.add(pid)
        try:
            pid = int((proc_root / str(pid) / "stat").read_text().rsplit(")", 1)[1].split()[1])
        except (OSError, ValueError, IndexError):
            break
    return result


class GuardedVisionProcess:
    def __init__(self, launch, *, lock_path=Path("/var/lock/voice-view-c6i.lock"),
                 startup_timeout=30., stop_timeout=10., lease_factory=HardwareLease,
                 process_factory=subprocess.Popen, verifier=verify_package, halt=halt_engines,
                 terminate_group=kill_group, scan=None):
        if any(not math.isfinite(timeout) or timeout <= 0 for timeout in (startup_timeout, stop_timeout)):
            raise ValueError("Lifecycle timeouts must be finite and positive")
        self.config = launch
        self.lock_path = lock_path
        self.startup_timeout, self.stop_timeout = startup_timeout, stop_timeout
        self._lease_factory, self._process_factory = lease_factory, process_factory
        self._verify, self._halt, self._kill_group = verifier, halt, terminate_group
        self._scan = scan if scan is not None else lambda: conflicting_owners(Path("/proc"), ancestors())
        self._lease = self._child = self._log = None
        self._launch = None
        self._started = 0.
        self.state, self.last_error = "IDLE", ""
        self.cleanup_confirmed = True

    def _receipt(self):
        if self._launch is None or self._child is None:
            return {}
        try:
            with (self._launch.output_dir / "worker_lifecycle.json").open("rb") as stream:
                payload = stream.read(16385)
            if len(payload) > 16384:
                return {}
            receipt = json.loads(payload)
            if (not isinstance(receipt, dict) or type(receipt.get("owner_pid")) is not int
                    or receipt["owner_pid"] != self._child.pid
                    or receipt.get("session_id") != self._launch.output_dir.name):
                return {}
            return receipt
        except (OSError, ValueError):
            return {}

    def status(self):
        receipt = self._receipt()
        if self._child is not None and self.state in ("STARTING", "RUNNING", "STOPPING"):
            exitcode = self._child.poll()
            if exitcode is not None:
                ready = self.state != "STARTING" or (
                    receipt.get("state") == "STOPPED" and type(receipt.get("frame_id")) is int
                    and receipt["frame_id"] > 0)
                if exitcode == 0 and ready:
                    self.state = "STOPPING"
                else:
                    self.state, self.last_error = "FAULT", f"Vision worker exited with code {exitcode}; cleanup unconfirmed"
            elif receipt.get("state") == "FAULT":
                self.state, self.last_error = "FAULT", "Vision worker reported failure"
            elif (self.state == "STARTING" and receipt.get("state") == "RUNNING"
                  and type(receipt.get("frame_id")) is int and receipt["frame_id"] > 0):
                self.state = "RUNNING"
            elif self.state == "STARTING" and time.monotonic() - self._started > self.startup_timeout:
                self.state, self.last_error = "FAULT", "Vision worker readiness timed out"
        return dict(profile="VISION_ONLY", state=self.state, last_error=self.last_error,
                    worker_pid=self._child.pid if self._child else None,
                    exitcode=self._child.poll() if self._child else None,
                    session_id=self._launch.output_dir.name if self._launch else None,
                    cleanup_confirmed=self.cleanup_confirmed, owner_held=self._lease is not None,
                    worker=receipt, board_validated=False)

    def start(self):
        if self._lease is not None:
            if self.state in ("STARTING", "RUNNING"):
                return self.status()
            raise RuntimeError("Hardware owner retained; recovery required before start")
        self.config.command()
        self._verify(self.config.bitstream.resolve().parent)
        conflicts = self._scan()
        if conflicts:
            raise RuntimeError(f"Another hardware owner exists PID={conflicts}")
        lease = self._lease_factory(self.lock_path)
        try:
            conflicts = self._scan()
            if conflicts:
                raise RuntimeError(f"Another hardware owner exists PID={conflicts}")
            launch = replace(self.config, output_dir=self.config.output_dir.resolve() / ("guard-" + uuid.uuid4().hex))
            launch.output_dir.mkdir(parents=True, exist_ok=False)
            self._log = (launch.output_dir / "worker.log").open("wb")
            self._child = self._process_factory(
                launch.command(), stdin=subprocess.DEVNULL, stdout=self._log, stderr=subprocess.STDOUT,
                start_new_session=True, pass_fds=(lease.fileno(),),
                env={**os.environ, "XILINX_XRT": "/usr", "PYTHONFAULTHANDLER": "1",
                     "VVG_VISION_RUNTIME_DIR": str(RUNTIME)})
            self._lease, self._launch = lease, launch
        except BaseException:
            if self._log is not None:
                self._log.close()
                self._log = None
            lease.close()
            raise
        self.state, self.last_error, self.cleanup_confirmed = "STARTING", "", False
        self._started = time.monotonic()
        return self.status()

    def stop(self):
        if self._lease is None:
            return self.status()
        child = self._child
        if child is None:
            self.state, self.last_error = "FAULT", "Missing child identity; hardware owner retained"
            raise RuntimeError(self.last_error)
        prior_error = self.last_error
        self.state = "STOPPING"
        try:
            if child.poll() is None:
                if not self._receipt().get("retaining_buffers"):
                    child.send_signal(signal.SIGINT)
                    try:
                        child.wait(timeout=self.stop_timeout)
                    except subprocess.TimeoutExpired:
                        pass
                if child.poll() is None:
                    child.send_signal(getattr(signal, "SIGSTOP"))
            if self._halt(self.config.bitstream.resolve().with_suffix(".hwh")) is not True:
                raise RuntimeError("Overlay identity or DMA halt unconfirmed")
            self._kill_group(child.pid)
            child.wait(timeout=2.)
            if child.poll() is None:
                raise RuntimeError("Vision worker exit unconfirmed")
        except BaseException as error:
            self.state, self.last_error = "FAULT", f"{type(error).__name__}: {error}"
            raise RuntimeError(self.last_error + "; hardware owner retained") from error
        self.cleanup_confirmed = True
        self._lease.close()
        self._lease = None
        if self._log is not None:
            self._log.close()
            self._log = None
        exitcode = child.poll()
        self.state = "IDLE" if exitcode == 0 and not prior_error else "FAULT"
        if prior_error:
            self.last_error = prior_error
        elif exitcode != 0:
            self.last_error = f"Vision worker exited with code {exitcode}; DMA cleanup confirmed"
        return self.status()


def main(argv=None):
    parser = argparse.ArgumentParser(description="Isolated VISION_ONLY candidate guard")
    parser.add_argument("bitstream", type=Path)
    parser.add_argument("output_dir", type=Path)
    parser.add_argument("--camera-dir", type=Path, required=True)
    parser.add_argument("--camera-sha256", required=True)
    parser.add_argument("--bind", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8081)
    parser.add_argument("--duration", type=float, default=3600.)
    parser.add_argument("--preview-fps", type=float, default=10.)
    parser.add_argument("--debug-fps", type=float, default=5.)
    parser.add_argument("--lock-path", type=Path, default=Path("/var/lock/voice-view-c6i.lock"))
    parser.add_argument("--check-only", action="store_true")
    options = parser.parse_args(argv)
    launch = VisionLaunch(options.bitstream, options.camera_dir, options.camera_sha256, options.output_dir,
                          options.bind, options.port, options.duration, options.preview_fps, options.debug_fps)
    launch.command()
    if options.check_only:
        verify_package(launch.bitstream.resolve().parent)
        print(json.dumps(dict(profile="VISION_ONLY", preflight="PASS", board_validated=False)))
        return 0
    if sys.platform != "linux" or os.geteuid() != 0:
        parser.error("Live guard requires root on the PYNQ Linux host")
    stopped = Event()
    def request_stop(*_):
        stopped.set()
    for number in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP):
        signal.signal(number, request_stop)
    worker = GuardedVisionProcess(launch, lock_path=options.lock_path)
    worker.start()
    try:
        while not stopped.wait(.1):
            state = worker.status()
            if state["state"] in ("FAULT", "STOPPING"):
                break
    finally:
        try:
            result = worker.stop()
        except RuntimeError:
            print(json.dumps(worker.status()), file=sys.stderr, flush=True)
            print("VISION_GUARD_RETAINED: operator recovery required; do not kill or reload automatically",
                  file=sys.stderr, flush=True)
            Event().wait()
            raise
    print(json.dumps(result), flush=True)
    return 0 if result["state"] == "IDLE" else 1


if __name__ == "__main__":
    sys.exit(main())