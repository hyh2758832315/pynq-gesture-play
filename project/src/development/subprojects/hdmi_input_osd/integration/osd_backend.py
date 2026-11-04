"""C0D candidate: retain the r15 gameplay and owner lifecycle."""
from dataclasses import replace
import json

from .vision_backend import C6IVolumeRuntimeBackend
from ..input_osd import InputOsdService


class C6IOsdRuntimeBackend(C6IVolumeRuntimeBackend):
    BUILD_ID = 0xC0060D00

    def __init__(self, session, supervisor, *, osd_hub, osd_allow_test=False, **options):
        self._osd_hub, self._osd = osd_hub, None
        self._osd_allow_test = osd_allow_test
        super().__init__(session, supervisor, **options)

    def open(self):
        if self._osd is not None:
            return self
        super().open()
        self._osd = InputOsdService(self._session, self._osd_hub, self._volume.read_observation,
                                    allow_test=self._osd_allow_test, thresholds=self._volume.osd_thresholds)
        try:
            self._osd.open()
            self._vision_supervisor.start()
        except BaseException:
            self.close()
            raise
        return self

    @property
    def snapshot(self):
        base = super().snapshot
        return replace(base, vision={**(base.vision or {}), "hdmi_osd":
            None if self._osd is None else self._osd.status()})

    def set_input_osd(self, payload):
        options = json.loads(payload)
        if type(options) is not dict or set(options) != {"enabled"}:
            raise ValueError("input_osd_set requires only enabled")
        enabled = options["enabled"]
        if type(enabled) is not bool or self._osd is None:
            raise ValueError("input_osd_set requires boolean enabled and an open OSD")
        self._osd.enabled = enabled
        return self.snapshot

    def test_input_osd(self, payload):
        if self._osd is None:
            raise RuntimeError("OSD service is not open")
        self._osd.set_test(json.loads(payload))
        return self.snapshot

    def probe_input_osd(self, payload):
        if payload != b'{}' or self._osd is None:
            raise ValueError("OSD probe requires empty JSON and an open OSD")
        self._osd.request_probe()
        return self.snapshot

    def stop_vision(self):
        super().stop_vision()
        self._osd_hub.clear()
        return self.snapshot

    def close(self):
        if self._osd is not None:
            self._osd.close()
            self._osd = None
        super().close()
