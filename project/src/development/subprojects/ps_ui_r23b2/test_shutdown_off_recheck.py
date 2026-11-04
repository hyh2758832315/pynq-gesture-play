"""Shutdown recovery retains errors and requires a dead closed identity-bound child."""
import json
from pathlib import Path
from types import SimpleNamespace
import pytest
from pynq_multimodal_game import hand_serial_session as hand
from pynq_multimodal_game import hand_startup


@pytest.mark.parametrize('bad',[None,'alive','backend','session','source','probe'])
def test_shutdown_recheck_never_arms_or_overrides_live_owner(tmp_path,monkeypatch,bad):
    owner=hand.SerialHandActionSession.__new__(hand.SerialHandActionSession)
    owner.session='s';owner._source='g';owner.error='original failure';owner.output_dir=tmp_path
    owner._child=SimpleNamespace(pid=42,poll=lambda:None if bad=='alive' else 1)
    port=tmp_path/'serial';port.touch()
    owner.gate=SimpleNamespace(root=tmp_path,python=Path('python'),port=str(port))
    raw=dict(session='s',game_run='g',backend_closed=True,actuator='serial-fixed-playback')
    if bad=='backend':raw['backend_closed']=False
    if bad=='session':raw['session']='other'
    if bad=='source':raw['game_run']='other'
    (tmp_path/'serial-motion.json').write_text(json.dumps(raw))
    calls=[]
    class Probe:
        def __init__(self,**kwargs):
            calls.append(kwargs);self.report_path=tmp_path/'readonly.json'
        def __call__(self):
            if bad=='probe':raise RuntimeError('motor not OFF')
            self.report_path.write_text('{}');return True
    monkeypatch.setattr(hand_startup,'HandStartupGate',Probe)
    monkeypatch.setattr(hand.sys,'platform','linux')
    if bad is None:
        owner._recheck_closed_child_off(raw,1)
        proof=json.loads((tmp_path/'cleanup-off-recheck.json').read_text())
        assert proof['original_error']=='original failure' and owner.error=='original failure'
        assert len(calls)==1
    else:
        with pytest.raises(RuntimeError):owner._recheck_closed_child_off(raw,1)
        assert not (tmp_path/'cleanup-off-recheck.json').exists()
        if bad!='probe':assert not calls
