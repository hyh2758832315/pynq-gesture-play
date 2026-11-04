"""Button-only board backend: dual-mask vision, hand OSD, and BTN0/BTN1."""

from dataclasses import replace
import json

from .vision_backend import C6IButtonRuntimeBackend
from ..button_osd import HandOsdService


class C6IButtonOsdRuntimeBackend(C6IButtonRuntimeBackend):
    def __init__(self, session, supervisor, *, osd_hub, **options):
        self._osd_hub = osd_hub
        self._osd = None
        super().__init__(session, supervisor, **options)

    def open(self):
        if self._osd is not None:
            return self
        super().open()
        self._osd = HandOsdService(self._session, self._osd_hub)
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
                       None if self._osd is None else self._osd.status(),
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

    def close(self):
        if self._osd is not None:
            self._osd.close()
            self._osd = None
        super().close()
