from __future__ import annotations

from dataclasses import dataclass, replace
import hashlib
import importlib
import json
import os
from pathlib import Path
import threading
import time
from typing import Any, Callable
import xml.etree.ElementTree as ET

from .core import AgentState, ArtifactManifest, RuntimeSnapshot


BUILD_ID_IP = "build_id_gpio"
DMA_IP = "return_dma"
CONTROL_IP = "return_control_gpio"
START_IP = "return_start_gpio"
STATUS_IP = "return_status_gpio"
STATE_IP = "return_state_gpio"
GPIO_DATA_OFFSET = 0x0
GPIO2_DATA_OFFSET = 0x8
S2MM_STATUS_OFFSET = 0x34
DMA_IDLE_MASK = 0x2
DMA_ERROR_MASK = 0x770
UPLOAD_RENDER_OVERLAP_BUILD_ID = 0xC0060760
OVERLAP_CONTROL_IP = "overlap_control_gpio"
OVERLAP_CREDIT = 1 << 0
OVERLAP_READY = 1 << 1
OVERLAP_FILLING = 1 << 2
OVERLAP_COMPLETION_HOLD = 1 << 3
OVERLAP_PRESENT_DONE = 1 << 4
OVERLAP_RELEASE_CONSUMED = 1 << 5
OVERLAP_RESOURCE_IDLE = 1 << 6
OVERLAP_GENERATION_REJECT = 1 << 7


@dataclass(frozen=True)
class C6IReturnStats:
    transfers: int = 0
    total_bytes: int = 0
    last_seed: int | None = None
    last_elapsed_seconds: float | None = None
    dma_status: int | None = None
    packet_count: int | None = None
    rejected_count: int = 0


class C6IOverlaySession:
    def __init__(
        self,
        bitstream: Path,
        *,
        lock_path: Path = Path("/var/lock/voice-view-c6i.lock"),
        expected_build_id: int = 0xC0060700,
        overlay_factory: Callable[..., Any] | None = None,
        mmio_factory: Callable[..., Any] | None = None,
        allocate: Callable[..., Any] | None = None,
        require_root: bool = True,
    ) -> None:
        if not 0 <= expected_build_id <= 0xFFFFFFFF:
            raise ValueError("expected_build_id must fit in 32 bits")
        self._bitstream = Path(bitstream)
        self._lock_path = Path(lock_path)
        self._expected_build_id = expected_build_id
        self._overlay_factory = overlay_factory
        self._mmio_factory = mmio_factory
        self._allocate = allocate
        self._require_root = require_root
        self._lock_file: Any | None = None
        self._fcntl: Any | None = None
        self._overlay: Any | None = None
        self._resource_lock = threading.RLock()
        self._borrowers: dict[int, C6IOverlayLease] = {}
        self._volume_journal = self._lock_path.with_name("voice-view-c6i-volume-owner.json")
        self._volume_guard: dict[str, Any] | None = None
        self._volume_stopped = False

    @property
    def is_open(self) -> bool:
        return self._overlay is not None

    @property
    def build_id(self) -> int:
        return self._expected_build_id

    @property
    def bitstream(self) -> Path:
        return self._bitstream

    def supports_upload_render_overlap(self) -> bool:
        if int(self.mmio(BUILD_ID_IP).read(GPIO_DATA_OFFSET)) != UPLOAD_RENDER_OVERLAP_BUILD_ID:
            return False
        try:
            self.ip_address(None, self.bitstream.with_suffix(".hwh"), OVERLAP_CONTROL_IP)
            manifest = self.bitstream.with_name(self.bitstream.stem + "_manifest.txt")
            entries: dict[str, str] = {}
            for line in manifest.read_text(encoding="utf-8").splitlines():
                key, separator, value = line.partition("=")
                if separator:
                    key = key.strip()
                    if key in entries:
                        return False
                    entries[key] = value.strip()
            return (
                int(entries["BUILD_ID"], 0) == UPLOAD_RENDER_OVERLAP_BUILD_ID
                and entries.get("UPLOAD_RENDER_OVERLAP_ENABLE") == "1"
            )
        except (OSError, KeyError, ValueError, ET.ParseError):
            return False

    def open(self) -> C6IOverlaySession:
        if self._overlay is not None:
            return self
        bitstream = self._bitstream
        hwh = bitstream.with_suffix(".hwh")
        if not bitstream.is_file():
            raise FileNotFoundError(bitstream)
        if not hwh.is_file():
            raise FileNotFoundError(hwh)
        if self._require_root and (
            not hasattr(os, "geteuid") or os.geteuid() != 0
        ):
            raise PermissionError("PYNQ Overlay loading requires root; run with sudo -n")
        try:
            self._fcntl = importlib.import_module("fcntl")
            self._lock_file = self._lock_path.open("a+b")
            self._fcntl.flock(
                self._lock_file.fileno(),
                self._fcntl.LOCK_EX | self._fcntl.LOCK_NB,
            )
            if self._volume_journal.exists():
                record = json.loads(self._volume_journal.read_text(encoding="utf-8"))
                if (type(record) is not dict or record.get("schema") != "c6i-volume-owner-v1"
                        or record.get("state") != "CLEAN"):
                    raise RuntimeError("unclean volume owner journal; operator recovery required")
            overlay_factory = self._overlay_factory
            mmio_factory = self._mmio_factory
            allocate = self._allocate
            if overlay_factory is None or mmio_factory is None or allocate is None:
                pynq = importlib.import_module("pynq")
                overlay_factory = overlay_factory or pynq.Overlay
                mmio_factory = mmio_factory or pynq.MMIO
                allocate = allocate or pynq.allocate
            self._overlay_factory = overlay_factory
            self._mmio_factory = mmio_factory
            self._allocate = allocate
            self._overlay = overlay_factory(str(bitstream), download=True)
            actual_build_id = int(self.mmio(BUILD_ID_IP).read(GPIO_DATA_OFFSET))
            if actual_build_id != self._expected_build_id:
                raise RuntimeError(
                    f"BUILD_ID mismatch: expected 0x{self._expected_build_id:08X}, "
                    f"got 0x{actual_build_id:08X}"
                )
            return self
        except BaseException:
            self.close()
            raise

    def mmio(self, instance: str) -> Any:
        if self._overlay is None or self._mmio_factory is None:
            raise RuntimeError("C6I Overlay session is not open")
        hwh = self._bitstream.with_suffix(".hwh")
        return self._mmio_factory(*self.ip_address(self._overlay, hwh, instance))

    def allocate(self, **kwargs: Any) -> Any:
        if self._overlay is None or self._allocate is None:
            raise RuntimeError("C6I Overlay session is not open")
        return self._allocate(**kwargs)

    def borrow(self, name: str, *, instances: frozenset[str]) -> C6IOverlayLease:
        if not name or not instances:
            raise ValueError("borrower name and IP instances are required")
        with self._resource_lock:
            if self._overlay is None:
                raise RuntimeError("C6I Overlay session is not open")
            lease = C6IOverlayLease(self, name, frozenset(instances))
            self._borrowers[id(lease)] = lease
            return lease

    def close(self) -> None:
        with self._resource_lock:
            if self._borrowers:
                names = ", ".join(lease.name for lease in self._borrowers.values())
                raise RuntimeError(f"Overlay still borrowed by {names}; hardware cleanup required")
            self._close_unborrowed()

    def _close_unborrowed(self) -> None:
        if self._volume_guard is not None:
            if not self._volume_stopped:
                raise RuntimeError("volume process cleanup unconfirmed; retain Overlay owner")
            self._write_volume_journal({**self._volume_guard, "state": "CLEAN"})
            self._volume_guard = None
        self._overlay = None
        lock_file, self._lock_file = self._lock_file, None
        if lock_file is not None:
            try:
                if self._fcntl is not None:
                    self._fcntl.flock(lock_file.fileno(), self._fcntl.LOCK_UN)
            except Exception:
                pass
            finally:
                lock_file.close()
        self._fcntl = None

    def _write_volume_journal(self, record: dict[str, Any]) -> None:
        temporary = self._volume_journal.with_suffix(".tmp")
        with temporary.open("x", encoding="utf-8") as output:
            json.dump(record, output, allow_nan=False)
            output.flush()
            os.fsync(output.fileno())
        os.replace(temporary, self._volume_journal)

    def _export_volume_guard(self, lease: C6IOverlayLease, producer_run: str) -> Any:
        reduction = importlib.import_module("multiprocessing.reduction")

        with self._resource_lock:
            lease._check()
            if (self.build_id != 0xC0060C00 or lease.name != "voice-volume"
                    or self._volume_guard is not None or self._lock_file is None
                    or len(producer_run) != 32
                    or any(character not in "0123456789abcdef" for character in producer_run)):
                raise RuntimeError("exclusive C0C volume process guard required")
            boot = Path("/proc/sys/kernel/random/boot_id").read_text().strip()
            fields = Path(f"/proc/{os.getpid()}/stat").read_text().rsplit(")", 1)[1].split()
            record = {"schema": "c6i-volume-owner-v1", "state": "ACTIVE", "boot_id": boot,
                      "owner_pid": os.getpid(), "owner_start_ticks": int(fields[19]),
                      "producer_run": producer_run,
                      "bit_sha256": hashlib.sha256(self.bitstream.read_bytes()).hexdigest(),
                      "hwh_sha256": hashlib.sha256(self.bitstream.with_suffix(".hwh").read_bytes()).hexdigest()}
            self._write_volume_journal(record)
            self._volume_guard = record
            self._volume_stopped = False
            return reduction.DupFd(self._lock_file.fileno())

    def __enter__(self) -> C6IOverlaySession:
        return self.open()

    def __exit__(self, exc_type: Any, exc_value: Any, traceback: Any) -> None:
        self.close()

    @staticmethod
    def ip_address(overlay: Any, hwh: Path, instance: str) -> tuple[int, int]:
        description = getattr(overlay, "ip_dict", {}).get(instance)
        if description is not None:
            return int(description["phys_addr"]), int(description["addr_range"])
        root = ET.parse(hwh).getroot()
        for memory_range in root.iter("MEMRANGE"):
            if memory_range.get("INSTANCE") == instance:
                base = int(memory_range.attrib["BASEVALUE"], 0)
                high = int(memory_range.attrib["HIGHVALUE"], 0)
                return base, high - base + 1
        raise KeyError(f"{instance!r} has no MEMRANGE in {hwh}")


class C6IOverlayLease:
    def __init__(self, owner: C6IOverlaySession, name: str, instances: frozenset[str]) -> None:
        self._owner = owner
        self.name = name
        self._instances = instances
        self._released = False
        self._resources: list[Any] = []

    def _check(self) -> None:
        if self._released or not self._owner.is_open:
            raise RuntimeError("Overlay borrower is closed")

    @property
    def bitfile_name(self) -> str:
        self._check()
        return str(self._owner.bitstream)

    @property
    def ip_dict(self) -> dict[str, Any]:
        self._check()
        descriptions = getattr(self._owner._overlay, "ip_dict", {})
        return {name: dict(value) for name, value in descriptions.items() if name in self._instances}

    def __getattr__(self, instance: str) -> Any:
        if instance not in self._instances:
            raise AttributeError(f"IP {instance!r} is outside the borrower contract")
        self._check()
        return getattr(self._owner._overlay, instance)

    def mmio(self, instance: str) -> Any:
        with self._owner._resource_lock:
            self._check()
            if instance not in self._instances:
                raise ValueError(f"IP {instance!r} is outside the borrower contract")
            return self._owner.mmio(instance)

    def allocate(self, **kwargs: Any) -> Any:
        with self._owner._resource_lock:
            self._check()
            return self._owner.allocate(**kwargs)

    def retain(self, resource: Any) -> None:
        with self._owner._resource_lock:
            self._check()
            self._resources.append(resource)

    def export_process_guard(self, producer_run: str) -> Any:
        return self._owner._export_volume_guard(self, producer_run)

    def confirm_process_stopped(self, producer_run: str, *, disabled: bool, exited: bool) -> None:
        with self._owner._resource_lock:
            self._check()
            guard = self._owner._volume_guard
            if (guard is None or guard["producer_run"] != producer_run
                    or disabled is not True or exited is not True):
                raise RuntimeError("volume disable and process exit confirmation required")
            self._owner._volume_stopped = True

    def register_process(self, producer_run: str, pid: int) -> None:
        with self._owner._resource_lock:
            self._check()
            guard = self._owner._volume_guard
            if guard is None or guard["producer_run"] != producer_run or type(pid) is not int or pid < 1:
                raise RuntimeError("volume process identity registration rejected")
            fields = Path(f"/proc/{pid}/stat").read_text().rsplit(")", 1)[1].split()
            record = {**guard, "worker_pid": pid, "worker_start_ticks": int(fields[19])}
            self._owner._write_volume_journal(record)
            self._owner._volume_guard = record

    def close(self) -> None:
        with self._owner._resource_lock:
            if self._released:
                return
            if (self.name == "voice-volume" and self._owner._volume_guard is not None
                    and not self._owner._volume_stopped):
                raise RuntimeError("volume process cleanup unconfirmed; retain Overlay lease")
            self._released = True
            self._owner._borrowers.pop(id(self), None)
            self._resources.clear()


class C6IReturnSource:
    def __init__(
        self,
        bitstream: Path | None = None,
        *,
        size: int = 65536,
        timeout_seconds: float = 5,
        lock_path: Path = Path("/var/lock/voice-view-c6i.lock"),
        expected_build_id: int = 0xC0060700,
        overlay_factory: Callable[..., Any] | None = None,
        mmio_factory: Callable[..., Any] | None = None,
        allocate: Callable[..., Any] | None = None,
        require_root: bool = True,
        session: C6IOverlaySession | None = None,
    ) -> None:
        if size < 1:
            raise ValueError("size must be positive")
        if timeout_seconds <= 0:
            raise ValueError("timeout_seconds must be positive")
        if session is None and bitstream is None:
            raise ValueError("bitstream is required without a shared C6I session")
        if session is not None and bitstream is not None:
            raise ValueError("provide either bitstream or session, not both")
        self._size = size
        self._timeout_seconds = timeout_seconds
        self._session = session or C6IOverlaySession(
            Path(bitstream),
            lock_path=lock_path,
            expected_build_id=expected_build_id,
            overlay_factory=overlay_factory,
            mmio_factory=mmio_factory,
            allocate=allocate,
            require_root=require_root,
        )
        self._owns_session = session is None
        self._receive_lock = threading.Lock()
        self._stats = C6IReturnStats()
        self._dma: Any | None = None
        self._control_mmio: Any | None = None
        self._start_mmio: Any | None = None
        self._status_mmio: Any | None = None
        self._state_mmio: Any | None = None
        self._buffer: Any | None = None
        self._rejected_baseline = 0

    @property
    def stats(self) -> C6IReturnStats:
        return self._stats

    @property
    def _lock_file(self) -> Any | None:
        return self._session._lock_file

    @property
    def _overlay(self) -> Any | None:
        return self._session._overlay

    def open(self) -> C6IReturnSource:
        if self._buffer is not None:
            return self
        try:
            self._session.open()
            self._control_mmio = self._session.mmio(CONTROL_IP)
            self._start_mmio = self._session.mmio(START_IP)
            self._status_mmio = self._session.mmio(STATUS_IP)
            self._state_mmio = self._session.mmio(STATE_IP)
            busy = int(self._state_mmio.read(GPIO_DATA_OFFSET))
            if busy != 0:
                raise RuntimeError(f"C6I return source is busy: {busy}")
            self._rejected_baseline = int(
                self._state_mmio.read(GPIO2_DATA_OFFSET)
            )
            self._dma = getattr(self._overlay, DMA_IP)
            self._buffer = self._session.allocate(shape=(self._size,), dtype="u1")
            self._stats = C6IReturnStats(
                rejected_count=self._rejected_baseline
            )
            return self
        except BaseException:
            self.close()
            raise

    def receive(self, seed: int) -> bytes:
        if not 0 <= seed <= 0xFFFFFFFF:
            raise ValueError("seed must fit in 32 bits")
        with self._receive_lock:
            if self._buffer is None:
                raise RuntimeError("C6I return source is not open")
            busy = int(self._state_mmio.read(GPIO_DATA_OFFSET))
            if busy != 0:
                raise RuntimeError(f"C6I return source is busy: {busy}")
            buffer = self._buffer
            buffer[:] = 0
            buffer.flush()
            before_count = int(self._status_mmio.read(GPIO2_DATA_OFFSET))
            expected_count = (before_count + 1) & 0xFFFFFFFF
            self._dma.recvchannel.transfer(buffer)
            self._control_mmio.write(GPIO_DATA_OFFSET, self._size)
            self._control_mmio.write(GPIO2_DATA_OFFSET, seed)
            started = time.perf_counter()
            deadline = started + self._timeout_seconds
            self._start_mmio.write(GPIO_DATA_OFFSET, 1)
            self._start_mmio.write(GPIO_DATA_OFFSET, 0)
            dma_status = self._wait_for_dma(deadline)
            packet_count = self._wait_for_packet(expected_count, deadline)
            elapsed_seconds = time.perf_counter() - started
            buffer.invalidate()
            payload = bytes(buffer)
            returned_bytes = int(self._status_mmio.read(GPIO_DATA_OFFSET))
            if returned_bytes != self._size:
                raise RuntimeError(
                    f"return byte count mismatch: expected {self._size}, "
                    f"got {returned_bytes}"
                )
            busy = int(self._state_mmio.read(GPIO_DATA_OFFSET))
            rejected = int(self._state_mmio.read(GPIO2_DATA_OFFSET))
            if busy != 0 or rejected != self._rejected_baseline:
                raise RuntimeError(
                    "C6I return state mismatch: "
                    f"busy={busy} rejected={rejected} "
                    f"baseline={self._rejected_baseline}"
                )
            self._stats = replace(
                self._stats,
                transfers=self._stats.transfers + 1,
                total_bytes=self._stats.total_bytes + returned_bytes,
                last_seed=seed,
                last_elapsed_seconds=elapsed_seconds,
                dma_status=dma_status,
                packet_count=packet_count,
                rejected_count=rejected,
            )
            return payload

    def close(self) -> None:
        buffer, self._buffer = self._buffer, None
        if buffer is not None:
            try:
                buffer.freebuffer()
            except Exception:
                pass
        self._dma = None
        self._control_mmio = None
        self._start_mmio = None
        self._status_mmio = None
        self._state_mmio = None
        if self._owns_session:
            self._session.close()

    def __enter__(self) -> C6IReturnSource:
        return self.open()

    def __exit__(self, exc_type: Any, exc_value: Any, traceback: Any) -> None:
        self.close()

    @staticmethod
    def _ip_address(overlay: Any, hwh: Path, instance: str) -> tuple[int, int]:
        return C6IOverlaySession.ip_address(overlay, hwh, instance)

    def _wait_for_dma(self, deadline: float) -> int:
        while True:
            status = int(self._dma.mmio.read(S2MM_STATUS_OFFSET))
            if status & DMA_ERROR_MASK:
                raise RuntimeError(f"S2MM DMA error status 0x{status:08X}")
            if status & DMA_IDLE_MASK:
                return status
            if time.perf_counter() >= deadline:
                raise TimeoutError(
                    f"S2MM DMA timeout with status 0x{status:08X}"
                )

    def _wait_for_packet(self, expected_count: int, deadline: float) -> int:
        while True:
            actual = int(self._status_mmio.read(GPIO2_DATA_OFFSET))
            if actual == expected_count:
                return actual
            if time.perf_counter() >= deadline:
                raise TimeoutError(
                    "return packet count timeout: "
                    f"expected {expected_count}, got {actual}"
                )


class C6IReturnBackend:
    def __init__(self, *, build_id: int = 0xC0060700) -> None:
        self._snapshot = RuntimeSnapshot(
            state=AgentState.IDLE,
            build_id=build_id,
            abi_major=1,
            abi_minor=0,
            staged_sha256=None,
            active_sha256=None,
            generation=0,
        )

    @property
    def snapshot(self) -> RuntimeSnapshot:
        return self._snapshot

    def stage(self, manifest: ArtifactManifest, payload: bytes) -> RuntimeSnapshot:
        raise RuntimeError("C6I runtime backend is unavailable until board validation")

    def stage_file(self, manifest: ArtifactManifest, path: Path) -> RuntimeSnapshot:
        raise RuntimeError("C6I runtime backend is unavailable until board validation")

    def activate(self) -> RuntimeSnapshot:
        raise RuntimeError("C6I runtime backend is unavailable until board validation")

    def run(self) -> RuntimeSnapshot:
        raise RuntimeError("C6I runtime backend is unavailable until board validation")

    def pause(self) -> RuntimeSnapshot:
        raise RuntimeError("C6I runtime backend is unavailable until board validation")

    def seek(self, frame_index: int) -> RuntimeSnapshot:
        raise RuntimeError("C6I runtime backend is unavailable until board validation")

    def stop(self) -> RuntimeSnapshot:
        return self._snapshot