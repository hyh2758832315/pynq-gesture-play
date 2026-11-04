"""Continuously drain one C0E borrower into a single latest-frame mailbox.

The borrower returns copied arrays only after releasing its DMA token. This
adapter never maps hardware or owns a second lease. All borrower operations,
including the sealed STOP drain, execute on the capture thread.
"""
import asyncio
import math
import threading
import time


class LatestCaptureHardware:
    def __init__(self, hardware, *, start_timeout=30., stop_timeout=6.):
        for value in (start_timeout, stop_timeout):
            if isinstance(value, bool) or not math.isfinite(value) or value <= 0:
                raise ValueError('positive finite capture thread timeout required')
        self._hardware = hardware
        self._start_timeout, self._stop_timeout = start_timeout, stop_timeout
        self._condition = threading.Condition()
        self._ready = threading.Event()
        self._stop_requested = threading.Event()
        self._rgb_requested = threading.Event()
        self._thread = None
        self._state, self._failure = 'IDLE', None
        self._pending = self._delivered = None
        self._reader_ident = None
        self._last_capture_id = 0
        self._captured = self._replaced = self._taken = self._drained = 0
        self.preview_demand = None
        # SharedDualMaskWorker may assign its legacy callback here. It must not
        # reach the raw borrower: STOP drains use the fast identity check below.
        self.drain_consumer = None

    def __getattr__(self, name):
        if name in ('profile', 'build_id', 'epoch', 'config_id', 'thresholds',
                    'timeout', 'skin', 'lease', 'pool', 'demosaic'):
            return getattr(self._hardware, name)
        raise AttributeError(name)

    @property
    def state(self):
        with self._condition:
            return self._state

    @property
    def error(self):
        with self._condition:
            return None if self._failure is None else str(self._failure)

    def snapshot(self):
        with self._condition:
            return dict(state=self._state, captured=self._captured,
                        replaced=self._replaced, delivered=self._taken,
                        drained=self._drained, last_capture_id=self._last_capture_id,
                        pending=int(self._pending is not None))

    def _check_identity(self, frame, *, drained=False):
        # Every DMA frame is checked, including frames never used by recognition.
        if frame.frame_id != self._last_capture_id + 1:
            raise RuntimeError('capture reader frame identity is not consecutive')
        if (frame.epoch != self.epoch or frame.config_id != self.config_id
                or tuple(frame.thresholds) != tuple(self.thresholds)):
            raise RuntimeError('capture reader epoch/configuration mismatch')
        with self._condition:
            self._last_capture_id = frame.frame_id
            self._captured += 1
            self._drained += int(drained)

    def _drain_frame(self, frame):
        self._check_identity(frame, drained=True)

    def _run(self):
        loop = None
        try:
            loop = asyncio.new_event_loop()
            asyncio.set_event_loop(loop)
            self._hardware.drain_consumer = self._drain_frame
            self._hardware.preview_demand = self._rgb_requested.is_set
            self._hardware.start()
            with self._condition:
                self._state = 'RUNNING'
                self._ready.set()
                self._condition.notify_all()
            while not self._stop_requested.is_set():
                frame = self._hardware.read()
                ready_ns = time.monotonic_ns()
                self._check_identity(frame)
                # These are CPU-owned copies, never live DMA storage.
                frame.raw.flags.writeable = False
                frame.filtered.flags.writeable = False
                with self._condition:
                    if self._pending is not None:
                        self._replaced += 1
                    self._pending = (frame, ready_ns)
                    self._condition.notify_all()
            with self._condition:
                self._state = 'STOPPING'
            self._hardware.stop()
            with self._condition:
                self._pending = self._delivered = None
                self._state = 'STOPPED'
        except BaseException as error:
            # Retain the original borrower and all its resources. No reset,
            # automatic stop retry, freebuffer, or second owner on this path.
            with self._condition:
                self._failure = error
                self._state = 'RETAINED'
        finally:
            if loop is not None:
                loop.close()
            self._ready.set()
            with self._condition:
                self._condition.notify_all()

    def start(self):
        with self._condition:
            if self._state != 'IDLE':
                raise RuntimeError('capture reader cannot be restarted or retried')
            self._state = 'STARTING'
            self._thread = threading.Thread(target=self._run, name='vision-capture', daemon=True)
            self._thread.start()
        if not self._ready.wait(self._start_timeout):
            self._stop_requested.set()
            raise TimeoutError('capture reader startup incomplete; borrower retained')
        with self._condition:
            self._raise_failure()
            if self._state != 'RUNNING':
                raise RuntimeError('capture reader did not enter RUNNING')

    def _raise_failure(self):
        if self._failure is not None:
            raise RuntimeError('capture reader retained: ' + str(self._failure)) from self._failure

    def read(self):
        want_rgb = bool(self.preview_demand and self.preview_demand())
        deadline = time.monotonic() + self.timeout
        with self._condition:
            ident = threading.get_ident()
            if self._reader_ident not in (None, ident):
                raise RuntimeError('capture mailbox requires one recognition consumer')
            self._reader_ident = ident
            if self._delivered is not None:
                raise RuntimeError('previous capture delivery was not validated')
            if want_rgb:
                self._rgb_requested.set()
            try:
                while True:
                    self._raise_failure()
                    if self._state != 'RUNNING' or self._stop_requested.is_set():
                        raise RuntimeError('capture reader is not running')
                    if self._pending is not None:
                        frame = self._pending[0]
                        if not want_rgb or getattr(frame, 'rgb', None) is not None:
                            self._delivered, self._pending = self._pending, None
                            self._taken += 1
                            return frame
                    remaining = deadline - time.monotonic()
                    if remaining <= 0:
                        raise TimeoutError('latest capture snapshot not available')
                    self._condition.wait(remaining)
            finally:
                self._rgb_requested.clear()

    def accept_delivery(self, frame):
        """Validate the exact mailbox object once; return its observation age base."""
        with self._condition:
            self._raise_failure()
            if (threading.get_ident() != self._reader_ident or self._delivered is None
                    or self._delivered[0] is not frame):
                raise RuntimeError('unowned or repeated capture snapshot delivery')
            ready_ns = self._delivered[1]
            self._delivered = None
            return dict(source_frame_id=frame.frame_id, epoch=frame.epoch,
                        ready_monotonic_ns=ready_ns, captured=self._captured,
                        replaced=self._replaced, delivered=self._taken,
                        age_origin='CPU snapshot ready; excludes sensor and DMA latency')

    def stop(self):
        with self._condition:
            if self._state == 'IDLE':
                self._state = 'STOPPED'
                return
            if self._state == 'STOPPED':
                return
            self._stop_requested.set()
            self._rgb_requested.clear()
            self._condition.notify_all()
            thread = self._thread
        if thread is not None:
            thread.join(self._stop_timeout)
            if thread.is_alive():
                raise TimeoutError('capture reader did not stop; borrower retained')
        with self._condition:
            self._raise_failure()
            if self._state != 'STOPPED':
                raise RuntimeError('capture STOP not confirmed; borrower retained')
