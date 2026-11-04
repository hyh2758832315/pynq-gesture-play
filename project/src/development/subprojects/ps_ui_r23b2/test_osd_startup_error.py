"""Preserve the initiating OSD error when hand cleanup also fails."""
import sys
import threading
from pathlib import Path
from types import SimpleNamespace
import pytest
sys.path.insert(0,str(Path(__file__).parent/'python'))
from pynq_multimodal_game.agent import button_osd_backend as module

@pytest.mark.parametrize('cleanup_fails',[False,True])
def test_osd_open_keeps_original_error_and_cleanup_diagnostic(monkeypatch,cleanup_fails):
    backend=module.C6IButtonOsdRuntimeBackend.__new__(module.C6IButtonOsdRuntimeBackend)
    backend._osd=None;backend._session=object();backend._osd_hub=object()
    primary=ValueError('injected OSD startup failure')
    def fail_open():raise primary
    def cleanup():
        if cleanup_fails:raise RuntimeError('injected unconfirmed hand cleanup')
    monkeypatch.setattr(module.C6IButtonRuntimeBackend,'open',lambda self:self)
    monkeypatch.setattr(module,'HandOsdService',lambda *_:SimpleNamespace(open=fail_open))
    monkeypatch.setattr(backend,'close',cleanup)
    with pytest.raises((ValueError,RuntimeError)) as caught:backend.open()
    assert 'injected OSD startup failure' in str(caught.value)
    if cleanup_fails:
        assert 'injected unconfirmed hand cleanup' in str(caught.value)
        assert caught.value.__cause__ is primary
    else:assert caught.value is primary


@pytest.mark.parametrize('fail_osd',[False,True])
def test_real_button_base_defers_hand_until_osd_and_vision_are_ready(monkeypatch,fail_osd):
    from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
    from pynq_multimodal_game import button_input
    events=[]
    backend=module.C6IButtonOsdRuntimeBackend.__new__(module.C6IButtonOsdRuntimeBackend)
    backend._sink=None;backend._osd=None;backend._osd_hub=object();backend._hand_session=None
    backend._lock=threading.RLock()
    backend._complete_startup_locked=lambda:events.append('menu-ready')
    backend._session=SimpleNamespace(mmio=lambda _:object())
    backend._vision_supervisor=SimpleNamespace(input_provider=object(),start=lambda:events.append('vision-ready'))
    backend._hand_session_factory=lambda _:SimpleNamespace(start=lambda:events.append('hand-start'),
        status=lambda:{'phase':'ACTIVE','error':None})
    def shell_open(self):self._sink=object();events.append('gpu-ready');return self
    def osd_open():
        events.append('osd-ready')
        if fail_osd:raise ValueError('injected osd admission failure')
    monkeypatch.setattr(C6IShellRuntimeBackend,'open',shell_open)
    monkeypatch.setattr(button_input,'ButtonSampler',lambda *args,**kwargs:SimpleNamespace(start=lambda:None))
    monkeypatch.setattr(button_input,'ButtonGameInputProvider',lambda *args:object())
    monkeypatch.setattr(module,'HandOsdService',lambda *_:SimpleNamespace(open=osd_open))
    monkeypatch.setattr(backend,'close',lambda:events.append('cleanup'))
    if fail_osd:
        with pytest.raises(ValueError,match='osd admission'):backend.open()
        assert 'hand-start' not in events
    else:
        assert backend.open() is backend
        assert events==['gpu-ready','osd-ready','vision-ready','hand-start','menu-ready']
