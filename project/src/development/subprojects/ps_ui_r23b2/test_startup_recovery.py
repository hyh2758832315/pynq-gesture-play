"""Finite retry is conditional on confirmed release, never a second owner."""
from threading import Event
from types import SimpleNamespace
import pytest
from pynq_multimodal_game import startup_checks as module


@pytest.mark.parametrize('failures,expected',[(1,'recovered'),(2,'exhausted')])
def test_verified_timeout_retry_is_finite(monkeypatch,failures,expected):
    calls=[]
    supervisor=SimpleNamespace(status=lambda:dict(cleanup_confirmed=True,owner_held=False))
    def once(*_,**__):
        calls.append('start')
        if len(calls)<=failures:raise TimeoutError('first frame deadline')
        return True
    monkeypatch.setattr(module,'start_vision_until_ready',once)
    if expected=='recovered':assert module.start_vision_with_recovery(supervisor)
    else:
        with pytest.raises(TimeoutError,match='after 2 verified attempts'):
            module.start_vision_with_recovery(supervisor)
    assert len(calls)==2


@pytest.mark.parametrize('release,owner',[(False,False),(True,True),(True,None)])
def test_unconfirmed_or_retained_owner_cannot_retry(monkeypatch,release,owner):
    calls=[]
    def fail(*_,**__):calls.append(1);raise TimeoutError('first frame deadline')
    monkeypatch.setattr(module,'start_vision_until_ready',fail)
    supervisor=SimpleNamespace(status=lambda:dict(cleanup_confirmed=release,owner_held=owner))
    with pytest.raises(RuntimeError,match='release unconfirmed'):module.start_vision_with_recovery(supervisor)
    assert len(calls)==1


def test_cancel_and_contract_errors_do_not_retry(monkeypatch):
    event=Event();event.set();calls=[]
    def fail(*_,**__):calls.append(1);raise RuntimeError('vision startup cancelled')
    monkeypatch.setattr(module,'start_vision_until_ready',fail)
    with pytest.raises(RuntimeError,match='cancelled'):
        module.start_vision_with_recovery(object(),stop_event=event)
    assert len(calls)==1
