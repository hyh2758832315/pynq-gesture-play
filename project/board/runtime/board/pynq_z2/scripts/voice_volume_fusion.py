from functools import partial
from pathlib import Path
import threading
from uuid import uuid4

from pynq_multimodal_game.volume_input import VolumeEventLatch, VolumeInputReader
from voice_volume_board import LinuxBackend, threshold_sums
from voice_volume_control import ProcessTransport, VolumeControl, VolumeFault
from voice_volume_runtime import AutonomousVolumeProcess


BUILD_ID = 0xC0060E00
PROFILE = "C6I_PL_VISION_VOLUME_OSD_V1"
INSTANCE = "voice_volume_0"
BASE_ADDRESS = 0x43C10000


class BorrowedVolumeControl:
    def __init__(self, session, *, thresholds, sampling_enabled=True, diagnostic_root=None, diagnostic_context=None):
        if type(sampling_enabled) is not bool:
            raise ValueError("sampling_enabled must be boolean")
        self._session = session
        self._sampling_enabled = sampling_enabled
        self._diagnostic_options = {} if diagnostic_root is None else {
            "diagnostic_root": diagnostic_root, "diagnostic_context": diagnostic_context}
        self._sums = threshold_sums(thresholds)
        self._lease = self._transport = self._control = self._latch = self._thread = None
        self._stopping = threading.Event()
        self._error = None
        self._worker = None
        self._producer_run = uuid4().hex

    @property
    def latch(self):
        if self._latch is None:
            raise RuntimeError("fused volume source is not open")
        return self._latch

    def open(self):
        if self._lease is not None or self._stopping.is_set():
            raise RuntimeError("fused volume source requires a fresh owner")
        if self._session.build_id != BUILD_ID or not self._session.is_open:
            raise VolumeFault("fused volume requires the already-open C6I_VOLUME session")
        self._lease = self._session.borrow("voice-volume", instances=frozenset({INSTANCE}))
        self._lease.retain(self)
        try:
            address = self._session.ip_address(self._lease, Path(self._lease.bitfile_name).with_suffix(".hwh"), INSTANCE)
            if address != (BASE_ADDRESS, 4096):
                raise VolumeFault("fused VOL1 HWH address or range mismatch")
            if self._sampling_enabled:
                guard = self._lease.export_process_guard(self._producer_run)
                self._worker = AutonomousVolumeProcess(partial(LinuxBackend, base_address=BASE_ADDRESS),
                    self._sums, process_guard=guard, producer_run=self._producer_run, **self._diagnostic_options)
                self._lease.register_process(self._producer_run, self._worker.process.pid)
                self._worker.start()
                self._latch = VolumeInputReader(self._worker.read, producer_run=self._producer_run)
                return self
            self._transport = ProcessTransport(partial(LinuxBackend, base_address=BASE_ADDRESS), timeout=2,
                                               **self._diagnostic_options)
            self._control = VolumeControl(self._transport, exclusive_owner=True)
            self._control.configure(**self._sums, enable=False)
            snapshot = self._control.monitor()
            if snapshot["enabled"] or snapshot["faults"] or snapshot["ack_error"]:
                raise VolumeFault("disabled baseline sampling state unconfirmed")
            self._latch = VolumeEventLatch(self._control)
            self._latch.release()
            return self
        except BaseException as error:
            self._error = f"{type(error).__name__}: {error}"
            try:
                self.close()
            except BaseException as cleanup:
                raise VolumeFault(f"{self._error}; volume cleanup failed: {cleanup}") from error
            raise

    @property
    def osd_thresholds(self):
        return self._sums["soft_sum"] / 977, self._sums["loud_sum"] / 977

    def read_observation(self):
        return None if self._worker is None else self._worker.page.read_observation()

    def status(self):
        latch = None if self._latch is None else self._latch.status()
        observation = None if latch is None else latch.pop("observation", None)
        worker = None if self._worker is None else self._worker.read()
        error = self._error or (None if latch is None else latch["error"])
        if worker is not None:
            error = error or worker.get("error")
        return {"profile": PROFILE, "build_id": BUILD_ID, "error": error,
                "sampling_enabled": self._sampling_enabled,
                "latch": latch, "observation": observation,
                "poller_alive": (self._worker.process.is_alive() if self._worker is not None else
                                 self._thread is not None and self._thread.is_alive()),
                "worker": None if worker is None else {name: value for name, value in worker.items() if name != "diagnostics"},
                "diagnostic_error": None if self._worker is None else self._worker.diagnostic_error,
                "lease_retained": self._lease is not None}

    def close(self):
        self._stopping.set()
        if self._worker is not None:
            if self._latch is not None:
                self._latch.release()
            try:
                self._worker.close()
                self._lease.confirm_process_stopped(self._producer_run,
                    disabled=self._worker.stopped_confirmed, exited=not self._worker.process.is_alive())
                self._lease.close()
            except BaseException as error:
                self._error = self._error or f"{type(error).__name__}: {error}"
                raise VolumeFault(f"{self._error}; retain Overlay lease") from error
            self._lease = None
            self._worker = None
            return
        if self._thread is not None:
            self._thread.join(1)
            if self._thread.is_alive():
                raise VolumeFault("volume poller exit unconfirmed; retain Overlay lease")
        if self._latch is not None:
            self._latch.release()
        errors = []
        if self._control is not None:
            try:
                self._control.configure(**self._sums, enable=False)
                snapshot = self._control.monitor()
                if snapshot["enabled"] or snapshot["faults"] or snapshot["ack_error"]:
                    raise VolumeFault("volume sampling disable unconfirmed")
            except BaseException as error:
                errors.append(f"disable: {type(error).__name__}: {error}")
        if self._transport is not None:
            try:
                self._transport.close()
                if self._transport.process.is_alive():
                    raise VolumeFault("volume transport child exit unconfirmed")
            except BaseException as error:
                errors.append(f"transport: {type(error).__name__}: {error}")
        if errors:
            self._error = self._error or "; ".join(errors)
            raise VolumeFault("; ".join(errors) + "; retain Overlay lease")
        if self._lease is not None:
            self._lease.close()
            self._lease = None
        self._control = self._transport = None
