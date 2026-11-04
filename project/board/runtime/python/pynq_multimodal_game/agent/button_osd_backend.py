"""Button-only board backend: dual-mask vision, hand OSD, and BTN0/BTN1."""

from dataclasses import replace
import json
import time

from .vision_backend import C6IButtonRuntimeBackend
from ..button_osd import HandOsdService
from ..startup_ui import CheckState


class C6IButtonOsdRuntimeBackend(C6IButtonRuntimeBackend):
    START_HAND_AFTER_OSD = True
    DEFER_STARTUP_MENU = True
    def __init__(self, session, supervisor, *, osd_hub, **options):
        self._osd_hub = osd_hub
        self._osd = None
        super().__init__(session, supervisor, **options)

    def open(self):
        if self._osd is not None:
            return self
        super().open()
        self._osd = HandOsdService(self._session, self._osd_hub)
        stage = 2
        try:
            self._osd.open()
            self._vision_supervisor.start()
            if self._hand_session is not None:
                stage = 3
                self._hand_session.start()
                self._wait_hand_startup()
            snapshot = getattr(self, '_startup_snapshot', None)
            if snapshot is not None and snapshot.states[3] is CheckState.CHECK:
                self._set_startup_check(3, CheckState.OK)
            stage = 0
            with self._lock:
                self._complete_startup_locked()
        except BaseException as error:
            try:
                self._set_startup_check(stage, CheckState.FAIL, f'{type(error).__name__}: {error}')
            except BaseException:
                pass  # Preserve the initiating error and physical cleanup path.
            try:
                self.close()
            except BaseException as cleanup:
                raise RuntimeError(
                    f'{type(error).__name__}: {error}; hand OSD cleanup failed: '
                    f'{type(cleanup).__name__}: {cleanup}') from error
            raise
        return self

    def _wait_hand_startup(self):
        read_status = getattr(self._hand_session, 'status', None)
        if not callable(read_status):
            # The legacy passive shadow owns no actuator and exposes no ACTIVE
            # handshake. Its independent diagnostic lifecycle remains unchanged.
            if getattr(getattr(self._hand_session, 'entry', None), 'name', None) == 'shadow_receiver.py':
                return
            raise TypeError('hand action session must expose startup status')
        deadline = time.monotonic()+30
        while True:
            status = read_status()
            if status.get('error') or status.get('phase') in ('FAULT','CLOSED','CLOSING'):
                raise RuntimeError(f'hand startup failed: {status}')
            if status.get('phase') in ('ACTIVE','RUNNING'):
                return
            if status.get('phase') == 'PAUSED' and status.get('preview_allowed') is True:
                return
            if time.monotonic()>=deadline:
                raise TimeoutError('hand did not become ready during loading')
            time.sleep(.05)

    @property
    def snapshot(self):
        base = super().snapshot
        worker = getattr(self._vision_supervisor, '_worker', None)
        # Existing thread identifiers let an external /proc observer attribute
        # CPU without installing wrappers, timers, or another polling worker.
        threads = {
            'recognition': getattr(worker, '_thread', None),
            'capture': getattr(getattr(worker, 'hardware', None), '_thread', None),
            'preview_relay': getattr(getattr(worker, 'preview_encoder', None), '_thread', None),
            'menu': self._menu_thread,
            'return_monitor': self._return_monitor_thread,
            'buttons': getattr(self._button_sampler, '_thread', None),
            'hand_osd': getattr(self._osd, 'thread', None),
            'hand_publisher': getattr(self._hand_session, '_thread', None),
        }
        return replace(base, vision={**(base.vision or {}), "hdmi_osd":
                       None if self._osd is None else self._osd.status(),
                       'runtime_threads': {name:getattr(thread,'native_id',None) for name,thread in threads.items()},
                       "buttons": None if self._button_sampler is None else
                       self._button_sampler.status()})

    def set_input_osd(self, payload):
        options = json.loads(payload)
        if type(options) is not dict or set(options) != {"enabled"} or type(options["enabled"]) is not bool:
            raise ValueError("input_osd_set requires boolean enabled")
        if self._osd is None:
            raise RuntimeError("hand OSD is closed")
        self._osd.enabled = options["enabled"]
        return self.snapshot

    def stop_vision(self):
        super().stop_vision()
        self._osd_hub.clear()
        return self.snapshot

    def close(self, *, retain_sink=False):
        previous_error = self._last_error
        errors = []
        if self._osd is not None:
            try:
                self._osd.close()
            except BaseException as error:
                errors.append(error)
            else:
                self._osd = None
        try:
            if retain_sink or errors:
                super().close(retain_sink=True)
            else:
                super().close()
        except BaseException as error:
            errors.append(error)
        if errors:
            detail = "; ".join(f'{type(error).__name__}: {error}' for error in errors)
            self._last_error = previous_error or detail
            self._cleanup_errors = detail
            if len(errors) == 1:
                raise errors[0]
            raise RuntimeError('OSD/backend cleanup failed: '+detail) from errors[0]
