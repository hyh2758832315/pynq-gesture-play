from __future__ import annotations

import hashlib
import ctypes
import importlib
import json
import struct
import sys
import threading
import time
from pathlib import Path
from types import SimpleNamespace
from xml.etree import ElementTree as ET

from ..voice_observations import VoiceObservationBus
from ..voice_service import VENDOR_ROOT, VoiceRecognitionService, verify_frozen_source
from .voice_fusion import AUDIO_IPS, verify_audio_hwh


DRIVER_SHA256 = {
    "voice_owner.py": "6d49de92c2e9aa02df7832d4290705be20837128b8a717a03e7bd72b1d64d598",
    "voice_axi_iic.py": "6bddf92c5b74516575902b2450f6b524ed554b1ca7a535e3f2013079369f240b",
    "voice_codec_init.py": "d68f373b4aefcd5e742c7fe29b220a4b4400eb8d51939dbad4b7bd16020b81df",
    "voice_pcm_sg.py": "12d00c7571e778b0ffca55156378823eaadc3e69bc1b4b84f18a0944a6db6775",
    "voice_pynq_binding.py": "6b0142bbacf21acc563df1513fc09aa131c800d8c4713f872031607f408bcc5a",
    "voice_status_reader.py": "e498f54e3ab36560b262d50b49a6a775a8d069b8570431aa2242638fdd8c2837",
}
_RETAINED = {}


def verify_driver_sources(root: Path) -> None:
    root = Path(root).resolve(strict=True)
    executables = set()
    for source in root.rglob("*"):
        if source.is_file() and source.suffix in (".py", ".pyc", ".pyd", ".so"):
            executables.add(source.relative_to(root).as_posix())
    if executables != set(DRIVER_SHA256):
        raise ValueError("Require the six-file isolated voice driver snapshot")
    for name, digest in DRIVER_SHA256.items():
        path = (root / name).resolve(strict=True)
        if path.parent != root or hashlib.sha256(path.read_bytes()).hexdigest() != digest:
            raise ValueError(f"Frozen voice driver mismatch: {name}")


def load_driver_sources(root: Path) -> dict:
    verify_driver_sources(root)
    root = Path(root).resolve()
    for name in DRIVER_SHA256:
        module = sys.modules.get(Path(name).stem)
        if module is not None and Path(module.__file__).resolve() != root / name:
            raise ImportError(f"Conflicting voice driver origin: {name}")
    original = sys.path[:]
    try:
        sys.path.insert(0, str(root))
        return {Path(name).stem: importlib.import_module(Path(name).stem) for name in DRIVER_SHA256}
    finally:
        sys.path[:] = original


def _diagnostic_iic_module(module, diagnostics):
    class DiagnosticIIC(module.VoiceAxiIIC):
        def _budget(self, timeout):
            budget = super()._budget(timeout)
            self._diagnostic_budget = budget
            return budget

        def _trace(self, operation, register, value, timeout, callback):
            record = {"operation": operation, "register": f"{register:#06x}",
                      "bytes": value if operation == "read" else len(value), "timeout_seconds": timeout}
            self._diagnostic_budget = None
            begun, cpu = self.clock(), time.thread_time()
            try:
                return callback(register, value, timeout)
            except BaseException as error:
                record["error"] = f"{type(error).__name__}: {error}"
                raise
            finally:
                ended = self.clock()
                record.update(wall_seconds=ended - begun, cpu_seconds=time.thread_time() - cpu)
                budget = self._diagnostic_budget
                if budget is not None:
                    record.update(poll_budget_remaining=budget[1], deadline_expired=ended >= budget[0],
                                  poll_limit_exceeded=budget[1] < 0)
                records = diagnostics["iic_operations"]
                if len(records) == 256:
                    records.pop(0)
                    diagnostics["iic_operations_dropped"] += 1
                records.append(record)

        def read(self, register, length, timeout):
            return self._trace("read", register, length, timeout, super().read)

        def write(self, register, payload, timeout):
            return self._trace("write", register, payload, timeout, super().write)

    return SimpleNamespace(VoiceAxiIIC=DiagnosticIIC, IICFault=module.IICFault)


def _diagnostic_capture_mmio(mmio, diagnostics):
    names = {0x2C: "live", 0x30: "hardware_epoch", 0x18: "dropped_low", 0x1C: "dropped_high",
             0x10: "observed_low", 0x14: "observed_high", 0x34: "accepted_low", 0x38: "accepted_high"}

    def read(offset):
        value = mmio.read(offset)
        if offset in names:
            diagnostics.setdefault("capture_snapshot", {})[names[offset]] = value
        return value

    return SimpleNamespace(read=read, write=mmio.write)


def cooperative_capture_types(modules: dict, *, diagnostics=None) -> tuple[type, type, type]:
    verify_frozen_source()
    extensions = {}
    for name in ("voice_receive_optimized", "voice_control_budget", "voice_pll_budget", "voice_cooperative_deadlines"):
        module = importlib.import_module(f"pynq_multimodal_game._vendor.{VENDOR_ROOT.name}.{name}")
        origin = module.__file__
        if origin is None or Path(origin).resolve() != VENDOR_ROOT / (name + ".py"):
            raise ImportError(f"Unexpected cooperative capture origin: {name}")
        extensions[name] = module
    binding_module = modules["voice_pynq_binding"]
    driver_type = extensions["voice_receive_optimized"].build_driver(modules["voice_pcm_sg"], binding_module.PynqMemory)
    cooperative = extensions["voice_cooperative_deadlines"]
    reader_type = cooperative.build_reader(binding_module)
    binding_type, driver_type = extensions["voice_control_budget"].build_types(
        binding_module, driver_type, status_reader_type=reader_type, control_ceiling=.05)
    iic_module = modules["voice_axi_iic"]
    if diagnostics is not None:
        iic_module = _diagnostic_iic_module(iic_module, diagnostics)
    iic_type, driver_type = extensions["voice_pll_budget"].build_types(
        iic_module, driver_type, stage_ceiling=.05)
    return binding_type, iic_type, cooperative.build_driver(driver_type)


class NativeVoiceLibrary:
    def __init__(self, path: Path, *, sha256: str) -> None:
        self.path = Path(path).resolve(strict=True)
        if hashlib.sha256(self.path.read_bytes()).hexdigest() != sha256:
            raise ValueError("Native voice library SHA mismatch")
        self.sha256 = sha256
        self.library = ctypes.CDLL(str(self.path))
        pointer, uint32, uint64 = ctypes.c_void_p, ctypes.c_uint32, ctypes.c_uint64
        specifications = {
            "abi": ([], uint32), "error": ([], ctypes.c_char_p),
            "roots_create": ([ctypes.c_int, ctypes.c_char_p, uint32, uint64, uint64], pointer),
            "root_info": ([pointer, uint32, ctypes.POINTER(uint64), ctypes.POINTER(uint64), ctypes.POINTER(uint32)], ctypes.c_int),
            "root_sync": ([pointer, uint32, ctypes.c_int], ctypes.c_int),
            "roots_mark_armed": ([pointer], ctypes.c_int),
            "roots_release_stopped": ([pointer], ctypes.c_int),
            "loop_create": ([pointer, uint32, uint32, uint64, uint64, ctypes.c_double, ctypes.c_double], pointer),
            "loop_run": ([pointer, uint32], ctypes.c_int),
            "loop_pop": ([pointer, ctypes.POINTER(uint32), ctypes.POINTER(ctypes.c_double), ctypes.POINTER(ctypes.c_int32)], ctypes.c_int),
            "loop_info": ([pointer, ctypes.POINTER(uint64), ctypes.POINTER(ctypes.c_double)], ctypes.c_int),
            "loop_finished": ([pointer], ctypes.c_int),
            "loop_stopped": ([pointer], ctypes.c_int),
            "loop_request_stop": ([pointer], None), "loop_destroy": ([pointer], ctypes.c_int),
        }
        for name, (arguments, result) in specifications.items():
            function = getattr(self.library, "vvg_voice_native_" + name)
            function.argtypes, function.restype = arguments, result
        if self.library.vvg_voice_native_abi() != 0x00010000:
            raise RuntimeError("Native voice private software ABI mismatch")

    def require(self, result):
        if result != 0:
            raw = self.library.vvg_voice_native_error()
            raise RuntimeError("Native voice: " + (raw.decode("utf-8", errors="replace") if raw else "operation failed"))

    def allocate(self, owner):
        if owner.state != "ACTIVE" or owner.confirmed() is not True:
            raise RuntimeError("Native allocation requires original active AudioOwner")
        backend = owner.backend
        journal = backend.read()
        if journal != owner._record("ACTIVE"):
            raise RuntimeError("Native allocation journal does not match authorized AudioOwner")
        context = self.library.vvg_voice_native_roots_create(
            backend.fd, journal, len(journal), *backend.inode)
        if not context:
            self.require(-1)
        return context

    def info(self, context, index):
        address, pointer, size = ctypes.c_uint64(), ctypes.c_uint64(), ctypes.c_uint32()
        self.require(self.library.vvg_voice_native_root_info(
            context, index, ctypes.byref(address), ctypes.byref(pointer), ctypes.byref(size)))
        return address.value, pointer.value, size.value

    def sync(self, context, index, to_device):
        self.require(self.library.vvg_voice_native_root_sync(context, index, int(to_device)))

    def release(self, context):
        self.require(self.library.vvg_voice_native_roots_release_stopped(context))


class NativePcmMemory:
    def __init__(self, pool, index):
        self.pool, self.index, self.owner = pool, index, pool.owner
        self.physical_address, self.pointer, self.nbytes = pool.transport.info(pool.context, index)
        if self.nbytes != (64 if index % 2 == 0 else 3840) or not self.pointer:
            raise RuntimeError("Native root PCM allocation size/pointer mismatch")

    def _check(self):
        self.pool._check()
        if self.pool.transport.info(self.pool.context, self.index) != (self.physical_address, self.pointer, self.nbytes):
            raise RuntimeError("Native root PCM allocation identity changed")

    def read_bytes(self):
        self._check()
        data = ctypes.string_at(self.pointer, self.nbytes)
        self._check()
        return data

    def write_bytes(self, data):
        self._check()
        if type(data) is not bytes or len(data) != self.nbytes:
            raise ValueError("Whole native root allocation bytes required")
        ctypes.memmove(self.pointer, data, self.nbytes)
        self._check()

    def flush(self):
        self._check()
        self.pool.transport.sync(self.pool.context, self.index, True)
        self._check()

    def invalidate(self):
        self._check()
        self.pool.transport.sync(self.pool.context, self.index, False)
        self._check()


class NativePcmBufferPool:
    def __init__(self, transport, audio_owner, *, owner_confirmed):
        self.transport, self.owner = transport, owner_confirmed
        self.context, self.driver = None, None
        self.released, self.quarantined = False, False
        self._thread_id = threading.get_ident()
        self._check()
        _RETAINED[id(self)] = self
        self.context = transport.allocate(audio_owner)
        self.slots = tuple((NativePcmMemory(self, index * 2), NativePcmMemory(self, index * 2 + 1))
                           for index in range(4))

    def _check(self):
        if threading.get_ident() != self._thread_id or self.released or self.owner() is not True:
            raise RuntimeError("Native root requires the original active producer owner")

    def attach(self, driver):
        self._check()
        if self.driver is not None or driver.state != "NEW" or driver.slots != self.slots or driver.owner is not self.owner:
            raise RuntimeError("Native driver must attach to this exact unarmed pool")
        self.driver = driver

    def release(self):
        if self.released:
            return
        try:
            self._check()
            if self.driver is None or self.driver.stop().get("release_safe") is not True:
                raise RuntimeError("Native pool release lacks fresh DMA/source stop")
            self.transport.release(self.context)
            self.context, self.released, self.quarantined = None, True, False
            _RETAINED.pop(id(self), None)
        except BaseException:
            self.quarantined = True
            raise


class BorrowedVoiceCapture:
    def _verify_hwh(self, path):
        verify_audio_hwh(path)

    def __init__(self, session, driver_root: Path, *, allow_dma_reset: bool = False,
                 physical_audio_confirmed: bool = False) -> None:
        self.session, self.driver_root = session, Path(driver_root)
        self.allow_dma_reset, self.physical_audio_confirmed = allow_dma_reset, physical_audio_confirmed
        self.lease = self.owner = self.pool = self.driver = None
        self._pool_allocation_started = False
        self.initialization = {"phase": "NEW", "iic_operations": [], "iic_operations_dropped": 0}
        self.state, self.first_error = "NEW", None
        self.index, self.epoch = 0, None
        self.native_transport = None
        self._native_loop = None
        self._native_stop_attempted, self._native_stop_succeeded = False, False
        self._thread_id = threading.get_ident()

    def _thread(self):
        if threading.get_ident() != self._thread_id:
            raise RuntimeError("Voice capture must remain on its creating producer thread")

    def open(self) -> None:
        self._thread()
        if self.state != "NEW" or not self.session.is_open:
            raise RuntimeError("A fresh capture and an open shared session are required")
        if self.allow_dma_reset is not True or self.physical_audio_confirmed is not True:
            raise RuntimeError("Explicit audio reset and physical MCLK/Codec confirmation required")
        self._verify_hwh(self.session.bitstream.with_suffix(".hwh"))
        modules = load_driver_sources(self.driver_root)
        binding_type, iic_type, driver_type = cooperative_capture_types(modules, diagnostics=self.initialization)
        if modules["voice_owner"]._HELD_OWNERS or modules["voice_pynq_binding"]._HELD_POOLS:
            raise RuntimeError("A retained audio owner or pool requires operator recovery")
        self.lease = self.session.borrow("voice", instances=AUDIO_IPS)
        _RETAINED[id(self)] = self
        try:
            cap, dma, iic = (self.lease.mmio(name) for name in
                             ("voice_capture", "voice_pcm_dma", "voice_codec_iic"))
            self._dma_mmio = dma

            def stopped(locked):
                if locked() is not True:
                    return False
                self.lease._check()
                return (cap.read(0) == 0x56535431 and cap.read(0x24) == 0x10001
                        and cap.read(0x28) == 0 and cap.read(0x2C) == 0
                        and dma.read(0x34) & 9 == 9 and not dma.read(0x34) & 0x4770
                        and not dma.read(0x30) & 0x1D and locked() is True)

            self._stopped = stopped

            def startup_stopped(locked):
                return (stopped(locked) and iic.read(0x104) in (0xC0, 0xC8)
                        and iic.read(0x100) in (1, 9) and not iic.read(0x20) & 3
                        and locked() is True)

            self._startup_stopped = startup_stopped
            self.owner = modules["voice_owner"].AudioOwner()
            self.initialization["phase"] = "owner_acquire"
            self.owner.acquire(stopped)

            def owned():
                self.lease._check()
                return self.owner.confirmed()

            self._owned = owned
            self.initialization["phase"] = "dma_reset"
            dma.write(0x30, 4)
            deadline = time.monotonic() + 1.0
            for _ in range(2048):
                if not owned():
                    raise RuntimeError("Audio owner lost during explicit reset")
                control, status = dma.read(0x30), dma.read(0x34)
                if not control & 4:
                    if control & 0x1D or status & 9 != 9 or status & 0x4770 or not stopped(owned):
                        raise RuntimeError("Explicit audio reset lacked clean stopped proof")
                    break
                if time.monotonic() >= deadline:
                    raise RuntimeError("Explicit audio reset timed out; no retry")
                time.sleep(.001)
            else:
                raise RuntimeError("Explicit audio reset poll ceiling")
            document = ET.parse(self.session.bitstream.with_suffix(".hwh"))
            descriptions = {}
            for module in document.iter("MODULE"):
                name = module.get("INSTANCE")
                if name in AUDIO_IPS:
                    base, size = self.session.ip_address(None, self.session.bitstream.with_suffix(".hwh"), name)
                    descriptions[name] = {"type": module.get("VLNV"), "phys_addr": base,
                                          "addr_range": size, "parameters": {
                                              item.get("NAME").lower(): item.get("VALUE")
                                              for item in module.iter("PARAMETER")}}
            transport = iic_type(
                iic.read, iic.write, description=descriptions["voice_codec_iic"],
                owner_confirmed=owned, stopped_confirmed=lambda: stopped(owned))
            self.initialization["phase"] = "iic_initialize"
            transport.initialize(timeout=.05)
            codec = modules["voice_codec_init"].MicrophoneCodec(
                transport, capture_stopped=lambda: stopped(owned), mclk_hz=10_000_000,
                address_straps_confirmed=self.physical_audio_confirmed)
            self.initialization["phase"] = "codec_configure"
            begun, cpu = time.monotonic(), time.thread_time()
            try:
                codec.configure_microphone()
            finally:
                self.initialization.update(codec_wall_seconds=time.monotonic() - begun,
                                           codec_cpu_seconds=time.thread_time() - cpu)

            def pll_ready():
                value = transport.read(0x4002, 6, .01)
                return value[:5] == modules["voice_codec_init"].PLL[:5] and value[5] == 3

            binding = binding_type(
                _diagnostic_capture_mmio(cap, self.initialization), descriptions["voice_capture"], owner_confirmed=owned)
            self.binding = binding
            self.initialization["phase"] = "pool_allocate"
            self._pool_allocation_started = True
            if self.native_transport is None:
                self.pool = modules["voice_pynq_binding"].PcmBufferPool(
                    self.lease.allocate, owner_confirmed=owned, count=4)
            else:
                self.pool = NativePcmBufferPool(self.native_transport, self.owner, owner_confirmed=owned)
            self.initialization["pcm_slots"] = len(self.pool.slots)
            self.lease.retain(self.pool)
            self.initialization["phase"] = "driver_construct"
            self.driver = driver_type(
                dma.read, dma.write, descriptions["voice_pcm_dma"], self.pool.slots,
                owner_confirmed=owned, capture_stopped=binding.stopped,
                set_capture=binding.set_capture, health=binding.health, codec_ready=pll_ready)
            self.pool.attach(self.driver)
            self.state = "READY"
            self.initialization["phase"] = "READY"
        except BaseException as error:
            self.state, self.first_error = "RETAINED", str(error)
            self.initialization["first_error"] = f"{type(error).__name__}: {error}"
            raise
        finally:
            print("VOICE_INITIALIZATION_DIAGNOSTIC " + json.dumps(self.initialization), flush=True)

    def start(self) -> None:
        self._thread()
        if self.state != "READY":
            raise RuntimeError("Voice capture is not prepared")
        if self.native_transport is not None:
            self.native_transport.require(
                self.native_transport.library.vvg_voice_native_roots_mark_armed(self.pool.context))
        if self.native_transport is None:
            self.driver.start()
        else:
            owner = self.driver.owner
            timing = {"owner_calls": 0, "owner_wall_seconds": 0.0, "owner_cpu_seconds": 0.0}

            def measured_owner():
                wall, cpu = time.monotonic(), time.thread_time()
                try:
                    return owner()
                finally:
                    timing["owner_calls"] += 1
                    timing["owner_wall_seconds"] += time.monotonic() - wall
                    timing["owner_cpu_seconds"] += time.thread_time() - cpu

            self.driver.owner = measured_owner
            wall, cpu = time.monotonic(), time.thread_time()
            try:
                self.driver.start()
            finally:
                timing["wall_seconds"] = time.monotonic() - wall
                timing["cpu_seconds"] = time.thread_time() - cpu
                self.driver.owner = owner
                self.initialization["start_timing"] = timing
        self.initialization["capture_started_at"] = time.monotonic()
        self.epoch, self.state = self.driver.epoch, "RUNNING"
        if self.native_transport is not None:
            previous = self.binding.reader.previous
            self._native_loop = self.native_transport.library.vvg_voice_native_loop_create(
                self.pool.context, previous.sequence, previous.hardware_epoch,
                previous.observed, previous.accepted, self.driver.last_poll, self.driver.last_packet)
            if not self._native_loop:
                self.native_transport.require(-1)

    def run_native(self, limit):
        self._thread()
        if self.state != "RUNNING" or not self._native_loop:
            raise RuntimeError("Native voice loop is not prepared")
        library = self.native_transport.library
        self._native_stop_attempted = True
        result = library.vvg_voice_native_loop_run(self._native_loop, limit)
        self._native_stop_succeeded = bool(library.vvg_voice_native_loop_stopped(self._native_loop))
        counters, timing = (ctypes.c_uint64 * 7)(), (ctypes.c_double * 3)()
        self.native_transport.require(library.vvg_voice_native_loop_info(self._native_loop, counters, timing))
        self.index = self.driver.index = int(counters[0])
        self.initialization["native_loop"] = {
            "produced": self.index, "sequence": int(counters[1]), "hardware_epoch": int(counters[2]),
            "observed": int(counters[3]), "accepted": int(counters[4]), "dropped": int(counters[5]),
            "flags": int(counters[6]), "max_poll_wall_seconds": timing[0],
            "max_poll_cpu_seconds": timing[1], "max_service_gap_seconds": timing[2],
            "library_sha256": self.native_transport.sha256,
            "stopped_before_python_return": self._native_stop_succeeded}
        if result != 0:
            self.driver.state, self.driver.release_safe = "FAULT", False
            self.native_transport.require(result)

    def pop_native(self):
        if not self._native_loop:
            raise RuntimeError("Native PCM consumer started before capture")
        index, copied_at, samples = ctypes.c_uint32(), ctypes.c_double(), (ctypes.c_int32 * 960)()
        result = self.native_transport.library.vvg_voice_native_loop_pop(
            self._native_loop, ctypes.byref(index), ctypes.byref(copied_at), samples)
        if result < 0:
            raise RuntimeError("Native producer invalidated the queued PCM epoch")
        if result == 0:
            return None
        return SimpleNamespace(epoch=self.epoch, index=index.value, copied_at=copied_at.value,
                               data=bytes(samples))

    def native_finished(self):
        return bool(self._native_loop and
                    self.native_transport.library.vvg_voice_native_loop_finished(self._native_loop))

    def request_native_stop(self):
        if self._native_loop:
            self.native_transport.library.vvg_voice_native_loop_request_stop(self._native_loop)

    def close_native_loop(self):
        self._thread()
        if self._native_loop:
            self.native_transport.require(
                self.native_transport.library.vvg_voice_native_loop_destroy(self._native_loop))
            self._native_loop = None

    def native_source_stopped(self):
        self._thread()
        if self._native_stop_attempted and not self._native_stop_succeeded:
            return False
        return self._stopped(self._owned) is True

    def poll(self):
        self._thread()
        if self.state != "RUNNING":
            raise RuntimeError("Voice capture is not running")
        begun = time.monotonic()
        previous = self.initialization.get("last_poll_finished_at", begun)
        self.initialization["max_service_gap_seconds"] = max(
            self.initialization.get("max_service_gap_seconds", 0.), begun - previous)
        if "first_poll_at" not in self.initialization:
            self.initialization["first_poll_at"] = begun
        try:
            packet = self.driver.poll_packet(timeout=.015)
        except BaseException:
            self._record_fault_transport()
            raise
        finally:
            self.initialization["last_poll_finished_at"] = time.monotonic()
        if packet is not None:
            if (type(packet.index) is not int or packet.index != self.index
                    or packet.epoch != self.epoch or type(packet.data) is not bytes or len(packet.data) != 3840):
                raise RuntimeError("PCM packet sequence/epoch/length mismatch")
            self.index += 1
        return packet

    def _record_fault_transport(self):
        snapshot = {"phase": "after_poll_fault_before_stop", "packet_index": self.index,
                    "started_at": time.monotonic(), "dma": {}, "descriptors": []}
        self.initialization["fault_transport"] = snapshot
        try:
            if self._owned() is not True:
                raise RuntimeError("Audio owner lost before fault snapshot")
            for name, offset in (("control", 0x30), ("status", 0x34), ("current", 0x38), ("tail", 0x40)):
                if self._owned() is not True:
                    raise RuntimeError("Audio owner lost during fault snapshot")
                snapshot["dma"][name] = hex(int(self._dma_mmio.read(offset)))
            for descriptor, _ in self.pool.slots:
                if time.monotonic() - snapshot["started_at"] >= .015:
                    raise RuntimeError("Fault snapshot inspection budget exceeded")
                if self._owned() is not True:
                    raise RuntimeError("Audio owner lost during fault snapshot")
                descriptor.invalidate()
                raw = descriptor.read_bytes()
                snapshot["descriptors"].append({"address": hex(descriptor.physical_address),
                    "words": list(struct.unpack("<16I", raw))})
            if self._owned() is not True:
                raise RuntimeError("Audio owner lost after fault snapshot")
        except BaseException as error:
            snapshot["diagnostic_error"] = f"{type(error).__name__}: {error}"
        finally:
            snapshot["finished_at"] = time.monotonic()

    def stop(self) -> dict:
        self._thread()
        if self.state == "CLOSED":
            return {"stopped_confirmed": True, "buffers_released": True, "owner_released": True}
        try:
            if self._native_stop_attempted and not self._native_stop_succeeded:
                raise RuntimeError("Native DMA/source stop failed; retain without automatic retry")
            if self.driver is None or self.pool is None:
                if (self.driver is not None or self.pool is not None or self._pool_allocation_started
                        or self.owner is None or self.owner.confirmed() is not True):
                    raise RuntimeError("Incomplete startup retained for operator recovery")
                self.owner.release(self._startup_stopped,
                    buffers_safe=lambda: self.pool is None and not self._pool_allocation_started)
            else:
                receipt = self.driver.stop()
                if receipt.get("release_safe") is not True:
                    raise RuntimeError("DMA/source stop not confirmed")
                if self._native_loop is not None:
                    raise RuntimeError("Native CPU consumer must join and destroy its loop before buffer release")
                self.pool.release()
                if self.pool.released is not True:
                    raise RuntimeError("Audio buffers not confirmed released")
                self.owner.release(self._stopped, buffers_safe=lambda: self.pool.released)
            self.lease.close()
            self.state = "CLOSED"
            _RETAINED.pop(id(self), None)
            return {"stopped_confirmed": True, "buffers_released": True, "owner_released": True}
        except BaseException as error:
            self.state, self.first_error = "RETAINED", self.first_error or str(error)
            _RETAINED[id(self)] = self
            raise


class VoiceSupervisor:
    def __init__(self, capture_factory, *, service_factory=VoiceRecognitionService,
                 bus: VoiceObservationBus | None = None, packet_limit: int = 900,
                 stop_requested=lambda: False, record_pcm: bool = False) -> None:
        if type(packet_limit) is not int or not 1 <= packet_limit <= 900:
            raise ValueError("Finite capture requires 1..900 packets")
        self.bus = bus if bus is not None else VoiceObservationBus()
        self._capture_factory, self._service_factory = capture_factory, service_factory
        self.packet_limit = packet_limit
        self._stop_requested = stop_requested
        self._record_pcm, self._pcm = record_pcm, []
        self._thread_handle = None
        self._ready, self._start, self._stop = threading.Event(), threading.Event(), threading.Event()
        self._started = threading.Event()
        self._capture_started = False
        self._lock = threading.RLock()
        self._state, self._error, self._packets = "IDLE", None, 0
        self._cleanup, self._statistics = {}, {}
        self._fault_diagnostic = None
        self._waveform, self._last_observation = (), None

    def status(self) -> dict:
        with self._lock:
            return {"state": self._state, "first_error": self._error, "packets": self._packets,
                    "samples": self._packets * 960, "nominal_sample_hz": 48000,
                    "source_age_verified": False, "board_validated": False,
                    "cpu": dict(self._statistics), "fault_diagnostic": self._fault_diagnostic, **self._cleanup}

    def observation(self) -> dict:
        from dataclasses import asdict
        with self._lock:
            status = self.status()
            identity = self.bus.status
            latest = self._last_observation
            return {**status, "schema": "voice-monitor-v1", "producer_run": identity.producer_run,
                    "audio_epoch": identity.audio_epoch, "runtime_registered": False,
                    "board_pending": True, "release_ready": False,
                    "recognition": None if latest is None else asdict(latest),
                    "decision_age_ns": None if latest is None else max(0, time.perf_counter_ns() - latest.decision_ns),
                    "pcm": None if not self._waveform else {"packet_index": self._packets - 1,
                        "sample_hz": 48000, "stride": 4, "samples": list(self._waveform),
                        "historical": self._state != "RUNNING"}}

    @property
    def recorded_pcm(self) -> bytes:
        if self._thread_handle is not None and self._thread_handle.is_alive():
            raise RuntimeError("PCM export requires a stopped producer")
        return b"".join(self._pcm)

    def prepare(self) -> None:
        if self._thread_handle is not None:
            raise RuntimeError("Voice supervisor is one-shot; use a fresh epoch")
        with self._lock:
            self._state = "STARTING"
        self._thread_handle = threading.Thread(target=self._run, name="voice-fusion-producer", daemon=True)
        self._thread_handle.start()
        if not self._ready.wait(60):
            self._stop.set()
            raise RuntimeError("Voice producer preparation timed out; cleanup required")
        if self.status()["state"] != "READY":
            raise RuntimeError(self.status()["first_error"] or "Voice preparation failed")

    def start(self) -> None:
        if self.status()["state"] != "READY":
            raise RuntimeError("Prepare voice producer before first game Scene")
        self._start.set()
        if not self._started.wait(1):
            self._stop.set()
            raise RuntimeError("Voice producer startup acknowledgement timed out; cleanup required")
        if not self._capture_started:
            raise RuntimeError(self.status()["first_error"] or "Voice producer did not start")

    def stop(self) -> dict:
        self._stop.set()
        self._start.set()
        thread = self._thread_handle
        if thread is not None:
            if thread is threading.current_thread():
                raise RuntimeError("Voice producer cannot join itself")
            thread.join(10)
            if thread.is_alive():
                raise RuntimeError("Voice producer join unconfirmed; retain shared owner")
        status = self.status()
        if thread is not None and (status.get("owner_released") is not True or status["state"] == "RETAINED"):
            raise RuntimeError(status["first_error"] or "Voice cleanup unconfirmed")
        return status

    def _run(self) -> None:
        service = capture = None
        phase = "cpu_prepare"
        try:
            service = self._service_factory(bus=self.bus)
            capture = self._capture_factory()
            phase = "capture_prepare"
            capture.open()
            with self._lock:
                self._state = "READY"
            self._ready.set()
            phase = "first_scene_wait"
            self._start.wait()
            if not self._stop.is_set():
                phase = "capture_start"
                capture.start()
                with self._lock:
                    self._state = "RUNNING"
                    self._capture_started = True
                self._started.set()
                phase = "receive"
                while self._packets < self.packet_limit:
                    if self._stop.is_set() or self._stop_requested():
                        break
                    packet = capture.poll()
                    if packet is None:
                        self._stop.wait(.001)
                        continue
                    if packet.index != self._packets or type(packet.data) is not bytes or len(packet.data) != 3840:
                        raise RuntimeError("Voice producer PCM sequence/length mismatch")
                    samples = [value[0] for value in struct.iter_unpack("<i", packet.data)]
                    if any(not -32768 <= value <= 32767 for value in samples):
                        raise RuntimeError("Voice PCM must be sign-extended signed16")
                    service.process(samples)
                    with self._lock:
                        self._waveform = tuple(samples[::4])
                        latest = self.bus.observe(time.perf_counter_ns()).latest
                        if latest is not None:
                            self._last_observation = latest
                        if self._record_pcm:
                            self._pcm.append(packet.data)
                        self._packets += 1
                        self._statistics = service.statistics
        except BaseException as error:
            driver = getattr(capture, "driver", None)
            previous = getattr(getattr(getattr(capture, "binding", None), "reader", None), "previous", None)
            with self._lock:
                self._error = f"{type(error).__name__}: {error}"
                self._state = "FAULT"
                self._fault_diagnostic = {"phase": phase,
                    "transport_before_stop": getattr(capture, "initialization", {}).get("fault_transport"),
                    "max_service_gap_seconds": getattr(capture, "initialization", {}).get("max_service_gap_seconds"),
                    "capture_snapshot": dict(getattr(capture, "initialization", {}).get("capture_snapshot", {})),
                    "capture_started_at": getattr(capture, "initialization", {}).get("capture_started_at"),
                    "first_poll_at": getattr(capture, "initialization", {}).get("first_poll_at"),
                    "last_validated_capture_status": None if previous is None else {
                        name: getattr(previous, name) for name in ("sequence", "hardware_epoch", "observed", "accepted",
                                                                   "dropped", "flags", "requested_at", "completed_at")},
                    "driver_state": getattr(driver, "state", None),
                    "fault_elapsed": getattr(driver, "fault_elapsed", None),
                    "callback_trace": tuple(getattr(driver, "fault_callback_trace", ())),
                    "last_poll_cpu_ms": getattr(driver, "last_poll_cpu_ms", None),
                    "last_poll_wall_ms": getattr(driver, "last_poll_wall_ms", None)}
            self.bus.invalidate(self._error)
        finally:
            self._ready.set()
            self._started.set()
            try:
                if service is not None and self._error is None:
                    service.end_observations()
                if capture is not None:
                    cleanup = capture.stop()
                    if not all(cleanup.get(name) is True for name in
                               ("stopped_confirmed", "buffers_released", "owner_released")):
                        raise RuntimeError("Voice capture cleanup receipt incomplete")
                    with self._lock:
                        self._cleanup = cleanup
                if service is not None:
                    if self._error is None:
                        service.finish(source_stopped=True)
                        stats = service.statistics
                        if stats["submitted"] != self._packets or stats["received"] != self._packets:
                            raise RuntimeError("Voice producer CPU submitted/received mismatch")
                        with self._lock:
                            self._statistics = stats
            except BaseException as error:
                with self._lock:
                    self._error = self._error or f"{type(error).__name__}: {error}"
                    self._state = "RETAINED" if not self._cleanup else "FAULT"
                self.bus.invalidate(self._error)
            finally:
                if service is not None:
                    try:
                        service.close()
                    except BaseException as error:
                        with self._lock:
                            self._error = self._error or str(error)
                            self._state = "RETAINED"
                        _RETAINED[id(self)] = self
                        self._service = service
                with self._lock:
                    if self._error is None:
                        self._state = "STOPPED"


class NativeVoiceSupervisor(VoiceSupervisor):
    def status(self) -> dict:
        status = super().status()
        capture = getattr(self, "_native_capture", None)
        status["native"] = dict(getattr(capture, "initialization", {}).get("native_loop", {}))
        return status

    @property
    def recorded_pcm(self) -> bytes:
        thread = getattr(self, "_cpu_thread", None)
        if thread is not None and thread.is_alive():
            raise RuntimeError("PCM export requires a joined native CPU consumer")
        return super().recorded_pcm

    def _run(self) -> None:
        prepared, available, drained = threading.Event(), threading.Event(), threading.Event()
        producer_done, cleanup_done = threading.Event(), threading.Event()
        cpu_error, capture_holder = [], []
        source_stopped = [False]
        self._native_capture = None

        def consume():
            service = None
            publishing = True
            try:
                import numpy as np
                service = self._service_factory(bus=self.bus)
                self._service = service
                prepared.set()
                while not available.wait(.001):
                    if producer_done.is_set():
                        break
                if available.is_set():
                    capture = capture_holder[0]
                    while True:
                        if publishing and capture.native_finished():
                            service.end_observations()
                            publishing = False
                        if self._stop.is_set() or self._stop_requested():
                            capture.request_native_stop()
                        service.drain()
                        if service.pending_packets >= 4:
                            time.sleep(.001)
                            continue
                        packet = capture.pop_native()
                        if packet is None:
                            if capture.native_finished():
                                break
                            time.sleep(.001)
                            continue
                        if packet.index != self._packets or type(packet.data) is not bytes or len(packet.data) != 3840:
                            raise RuntimeError("Native CPU consumer PCM sequence/length mismatch")
                        samples = np.frombuffer(packet.data, dtype="<i4")
                        if np.any(samples < -32768) or np.any(samples > 32767):
                            raise RuntimeError("Native CPU consumer PCM must be sign-extended signed16")
                        service.process(samples)
                        with self._lock:
                            self._waveform = tuple(samples[::4].tolist())
                            latest = self.bus.observe(time.perf_counter_ns()).latest
                            if latest is not None:
                                self._last_observation = latest
                            if self._record_pcm:
                                self._pcm.append(packet.data)
                            self._packets += 1
                            self._statistics = service.statistics
                drained.set()
                cleanup_done.wait()
                if self._error is None and source_stopped[0]:
                    if publishing:
                        service.end_observations()
                    service.finish(source_stopped=True)
                    statistics = service.statistics
                    if statistics["submitted"] != self._packets or statistics["received"] != self._packets:
                        raise RuntimeError("Native CPU submitted/received mismatch")
                    with self._lock:
                        self._statistics = statistics
            except BaseException as error:
                cpu_error.append(error)
                self.bus.invalidate(str(error))
                if capture_holder and available.is_set():
                    capture_holder[0].request_native_stop()
            finally:
                prepared.set()
                drained.set()
                if service is not None:
                    try:
                        service.close()
                    except BaseException as error:
                        cpu_error.append(error)
                        _RETAINED[id(self)] = self

        capture = None
        phase = "cpu_prepare"
        self._cpu_thread = threading.Thread(target=consume, name="voice-native-cpu-consumer", daemon=True)
        self._cpu_thread.start()
        try:
            if not prepared.wait(60):
                raise RuntimeError("Native CPU preparation timeout")
            if cpu_error:
                raise cpu_error[0]
            capture = self._capture_factory()
            self._native_capture = capture
            capture_holder.append(capture)
            phase = "capture_prepare"
            capture.open()
            with self._lock:
                self._state = "READY"
            self._ready.set()
            phase = "first_scene_wait"
            self._start.wait()
            if not self._stop.is_set():
                phase = "capture_start"
                capture.start()
                with self._lock:
                    self._state, self._capture_started = "RUNNING", True
                available.set()
                self._started.set()
                phase = "native_receive"
                capture.run_native(self.packet_limit)
                if cpu_error:
                    raise cpu_error[0]
        except BaseException as error:
            driver = getattr(capture, "driver", None)
            with self._lock:
                self._error, self._state = f"{type(error).__name__}: {error}", "FAULT"
                self._fault_diagnostic = {"phase": phase, "native_loop":
                    dict(getattr(capture, "initialization", {}).get("native_loop", {})),
                    "driver_state": getattr(driver, "state", None),
                    "fault_elapsed": getattr(driver, "fault_elapsed", None),
                    "callback_trace": tuple(getattr(driver, "fault_callback_trace", ())),
                    "capture_snapshot": dict(getattr(capture, "initialization", {}).get("capture_snapshot", {})),
                    "start_timing": dict(getattr(capture, "initialization", {}).get("start_timing", {}))}
            self.bus.invalidate(self._error)
        finally:
            producer_done.set()
            self._ready.set()
            self._started.set()
            try:
                if not drained.wait(10):
                    raise RuntimeError("Native CPU drain unconfirmed; retain root buffers")
                if capture is not None:
                    source_stopped[0] = capture.native_source_stopped()
                cleanup_done.set()
                self._cpu_thread.join(10)
                if self._cpu_thread.is_alive():
                    raise RuntimeError("Native CPU consumer join unconfirmed; retain root buffers")
                if cpu_error and self._error is None:
                    with self._lock:
                        self._error, self._state = f"{type(cpu_error[0]).__name__}: {cpu_error[0]}", "FAULT"
                if capture is not None:
                    capture.close_native_loop()
                    cleanup = capture.stop()
                    if not all(cleanup.get(name) is True for name in
                               ("stopped_confirmed", "buffers_released", "owner_released")):
                        raise RuntimeError("Native capture cleanup receipt incomplete")
                    with self._lock:
                        self._cleanup = cleanup
            except BaseException as error:
                with self._lock:
                    self._error = self._error or f"{type(error).__name__}: {error}"
                    self._state = "RETAINED"
                _RETAINED[id(self)] = self
                self.bus.invalidate(self._error)
            finally:
                cleanup_done.set()
                self._cpu_thread.join(10)
                with self._lock:
                    if self._cpu_thread.is_alive():
                        self._error = self._error or "Native CPU consumer join unconfirmed"
                        self._state = "RETAINED"
                        _RETAINED[id(self)] = self
                    elif cpu_error:
                        self._error = self._error or f"{type(cpu_error[0]).__name__}: {cpu_error[0]}"
                        if self._state != "RETAINED":
                            self._state = "FAULT"
                    elif self._error is None:
                        self._state = "STOPPED"


from dataclasses import replace

from ..multimodal_input import MultimodalGameInputProvider
from .core import AgentState
from .c6i_shell import ShellMode
from .vision_backend import C6IVisionRuntimeBackend


class C6IVoiceFusionRuntimeBackend(C6IVisionRuntimeBackend):
    BUILD_ID = 0xC0060900
    profile = "C6I_VISION_VOICE_S3"
    PAUSE_VISION_FOR_NATIVE_START = True

    def __init__(self, session, supervisor, *, voice_factory, **shell_options):
        self._voice_factory, self._voice = voice_factory, None
        self._voice_bus = VoiceObservationBus()
        self._voice_lock = threading.RLock()
        self._voice_starting = False
        super().__init__(session, supervisor, **shell_options)
        self._live_input = MultimodalGameInputProvider(
            supervisor.input_provider, self._voice_bus, max_audio_age_ns=100_000_000)

    @property
    def voice_status(self):
        return {"state": "IDLE", "board_validated": False} if self._voice is None else self._voice.status()

    @property
    def voice_observation(self):
        if self._voice is not None:
            return self._voice.observation()
        return {"schema": "voice-monitor-v1", "state": "IDLE", "packets": 0, "samples": 0,
                "nominal_sample_hz": 48000, "source_age_verified": False, "board_validated": False,
                "runtime_registered": False, "board_pending": True, "release_ready": False,
                "producer_run": None, "audio_epoch": None, "cpu": {}, "pcm": None,
                "recognition": None, "decision_age_ns": None, "first_error": None}

    @property
    def snapshot(self):
        base = super().snapshot
        voice = self.voice_status
        error = voice.get("first_error")
        return replace(base, state=AgentState.ERROR if error else base.state,
                       last_error=error or base.last_error, voice=self.voice_observation)

    def _game_voice_ended(self):
        if self._voice_starting:
            return False
        game = self._game
        if game is None:
            return False
        permit = game.action_permit
        return isinstance(permit, dict) and permit.get("armed") is not True

    def _vision_ready_for_voice(self):
        vision = self._vision_supervisor.status()
        vision_deadline = time.monotonic() + 30
        while vision["state"] == "STARTING":
            if time.monotonic() >= vision_deadline:
                raise RuntimeError("Vision startup not ready before voice preparation")
            threading.Event().wait(.02)
            vision = self._vision_supervisor.status()
        if vision["state"] == "FAULT":
            raise RuntimeError("Prior vision cleanup must complete before voice preparation")
        return vision

    def _prepare_voice(self):
        if self._voice is not None and (self.voice_status.get("owner_released") is not True
                                        or self.voice_status.get("first_error") is not None):
            raise RuntimeError("Prior voice cleanup must complete before a new epoch")
        vision = self._vision_ready_for_voice()
        resume_vision = vision.get("owner_held") is True
        if resume_vision:
            stopped = self._vision_supervisor.stop()
            if stopped.get("cleanup_confirmed") is not True or stopped.get("owner_held") is not False:
                raise RuntimeError("Vision stop unconfirmed before voice preparation")
        self._voice = self._voice_factory(bus=self._voice_bus, stop_requested=self._game_voice_ended)
        self._voice.prepare()
        if resume_vision:
            try:
                self._vision_supervisor.start()
                self._vision_ready_for_voice()
            except BaseException:
                self._stop_voice()
                raise

    def _stop_voice(self):
        if self._voice is not None:
            game = self._game
            if game is not None:
                revoke = getattr(getattr(game, "_live_input", None), "revoke_actions", None)
                if callable(revoke):
                    revoke("voice producer stopping")
            self._voice.stop()

    def _start_voice(self):
        game = self._game
        self._voice_starting = True
        try:
            stage = getattr(self, "_diagnostic_startup_stage", None) or (lambda _stage: None)
            stage("game_pause_begin")
            game.pause()
            stage("game_pause_complete")
            if getattr(self, "_diagnostic_preview_upload_overlap", False):
                game.enable_preview_upload_overlap()
            prepare_rearm = getattr(getattr(game, "_live_input", None), "prepare_audio_rearm", None)
            if callable(prepare_rearm):
                prepare_rearm()
            processing_paused = False
            if isinstance(self._voice, NativeVoiceSupervisor) and self.PAUSE_VISION_FOR_NATIVE_START:
                vision = self._vision_ready_for_voice()
                if vision.get("owner_held") is True:
                    self._vision_supervisor.pause_processing()
                    processing_paused = True
            try:
                stage("voice_capture_start_begin")
                self._voice.start()
                stage("voice_capture_start_complete")
            finally:
                if processing_paused:
                    self._vision_supervisor.resume_processing()
            resume_audio = getattr(game, "resume_audio", None)
            if callable(resume_audio):
                stage("game_audio_resume_begin")
                resume_audio()
            else:
                stage("game_audio_resume_begin")
                game.resume()
                rearm = getattr(getattr(game, "_live_input", None), "rearm_audio", None)
                if callable(rearm):
                    rearm()
            stage("game_audio_resume_complete")
        finally:
            self._voice_starting = False

    def start_game(self, item_id, test_case_json=None):
        with self._voice_lock:
            if self.mode in (ShellMode.GAME, ShellMode.VIDEO):
                self.return_to_menu()
            if test_case_json is not None:
                return super().start_game(item_id, test_case_json)
            self._stop_menu()
            self._prepare_voice()
            try:
                super().start_game(item_id)
                game = self._game
                if game.input_consumptions["presented_frames"] < 1:
                    raise RuntimeError("First completed game Scene required before voice enable")
                self._start_voice()
            except BaseException:
                self._stop_voice()
                raise

    def pause_game(self):
        with self._voice_lock:
            result = super().pause_game()
            self._stop_voice()
            return result

    def resume_game(self):
        with self._voice_lock:
            if self._active_test_case_json is not None:
                return super().resume_game()
            self._prepare_voice()
            try:
                self._start_voice()
                return self.snapshot
            except BaseException:
                self._stop_voice()
                raise

    def return_to_menu(self):
        with self._voice_lock:
            self._stop_voice()
            return super().return_to_menu()

    def close(self):
        with self._voice_lock:
            self._stop_voice()
            super().close()