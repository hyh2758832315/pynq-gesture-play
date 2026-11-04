"""Independent cleanup continues after faults; hardware owners stay retained."""
import importlib.util
from pathlib import Path
import sys
import threading
from types import SimpleNamespace
from unittest.mock import Mock

import pytest

from pynq_multimodal_game.agent.c6i_shell import ShellMode
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
from pynq_multimodal_game.agent.vision_backend import C6IVisionRuntimeBackend, SharedVisionSupervisor
from pynq_multimodal_game.agent.button_osd_backend import C6IButtonOsdRuntimeBackend
from pynq_multimodal_game.vision_preview import ProcessPreviewEncoder


class IdleEncode:
    def __call__(self, snapshot, mode):
        return b'jpeg'


@pytest.fixture(scope='module')
def runtime():
    path = Path(__file__).parent/'board/pynq_z2/scripts/vision_async_runtime.py'
    spec = importlib.util.spec_from_file_location('r31_cleanup_runtime', path)
    value = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = value
    spec.loader.exec_module(value)
    value.RUNTIME_DIR = Path(__file__).resolve().parents[2]/'handoffs/gesture_vision_v61/runtime'
    return value


def worker(runtime, tmp_path):
    value = object.__new__(runtime.SharedVisionWorker)
    value._stop = threading.Event()
    value._processing_resume = threading.Event()
    value.input_provider = SimpleNamespace(suspend=Mock(), release=Mock())
    value._thread = None
    value.hardware = SimpleNamespace(stop=Mock())
    value.preview_encoder = SimpleNamespace(close=Mock())
    value.preview = SimpleNamespace(close=Mock())
    value.run_dir, value.run_id, value.frame_id = tmp_path, 'source', 73
    value.error = value.diagnostic_error = None
    return value


@pytest.mark.parametrize('fault', ['hardware', 'input'])
def test_worker_fault_still_closes_independent_cpu_diagnostics(runtime, tmp_path, fault):
    value = worker(runtime, tmp_path)
    primary = RuntimeError('unconfirmed '+fault)
    if fault == 'hardware':
        value.hardware.stop.side_effect = primary
    else:
        value.input_provider.suspend.side_effect = primary
    with pytest.raises(RuntimeError, match='unconfirmed '+fault):
        value.stop()
    value.hardware.stop.assert_called_once()
    value.preview_encoder.close.assert_called_once()
    value.preview.close.assert_called_once()
    assert not (tmp_path/'stop_receipt.json').exists()
    assert value.hardware is not None  # unknown ownership remains retryable


def test_worker_does_not_free_diagnostics_while_recognition_is_still_alive(runtime, tmp_path):
    value = worker(runtime, tmp_path)
    value._thread = SimpleNamespace(join=Mock(), is_alive=lambda: True)
    with pytest.raises(RuntimeError, match='retained'):
        value.stop()
    value.hardware.stop.assert_not_called()
    value.preview_encoder.close.assert_not_called()
    value.preview.close.assert_not_called()


def test_supervisor_release_failure_still_attempts_worker_and_retains_it():
    source = SimpleNamespace(suspend=Mock(), release=Mock(side_effect=RuntimeError('release failed')),
                             capabilities={})
    child = SimpleNamespace(stop=Mock(), error=None, state='IDLE', frame_id=0, diagnostic_error=None)
    owner = SharedVisionSupervisor(lambda _: child, source)
    owner._worker, owner._started = child, True
    with pytest.raises(RuntimeError, match='release failed'):
        owner.stop()
    child.stop.assert_called_once()
    assert owner._worker is child and owner.status()['state'] == 'FAULT'
    assert not owner.status()['cleanup_confirmed']
    source.release.side_effect = None
    assert owner.stop()['cleanup_confirmed']


class Sink:
    def __init__(self):
        self.drain = Mock()
        self.close = Mock()


def test_vision_fault_stops_cpu_game_and_retains_gpu_until_explicit_retry(monkeypatch):
    primary = RuntimeError('vision stop unconfirmed')
    stop_vision = Mock(side_effect=primary)
    supervisor = SimpleNamespace(input_provider=object(), stop=stop_vision)
    value = C6IVisionRuntimeBackend(SimpleNamespace(build_id=0xC0060800), supervisor, menu_fps=0)
    sink, preview = Sink(), SimpleNamespace(stop=Mock())
    value._sink = sink
    monkeypatch.setattr(PackagedGameRuntime, '_create_preview', lambda *_a, **_k: preview)
    game = PackagedGameRuntime(Path('unused.vvg'), sink)
    game._thread = threading.Thread(target=game._stop.wait)
    thread = game._thread
    thread.start()
    value._game, value._mode = game, ShellMode.GAME
    try:
        with pytest.raises(RuntimeError, match='vision stop unconfirmed'):
            value.close()
        assert not thread.is_alive()
        preview.stop.assert_called_once()
        sink.drain.assert_not_called()
        sink.close.assert_not_called()
        assert value._game is game and value._sink is sink
        stop_vision.side_effect = None
        value.close()
        sink.drain.assert_called_once()
        sink.close.assert_called_once()
        assert value._game is None and value._sink is None
    finally:
        game._stop.set()
        thread.join(1)


def test_osd_fault_does_not_skip_hand_buttons_vision_and_retains_gpu():
    supervisor = SimpleNamespace(input_provider=object(), stop=Mock())
    value = C6IButtonOsdRuntimeBackend(SimpleNamespace(build_id=0xC0061000), supervisor,
                                     osd_hub=object(), menu_fps=0)
    sink = Sink()
    value._sink = sink
    value._osd = SimpleNamespace(close=Mock(side_effect=RuntimeError('OSD still active')))
    hand, button = SimpleNamespace(close=Mock()), SimpleNamespace(close=Mock())
    value._hand_session, value._button_sampler = hand, button
    with pytest.raises(RuntimeError, match='OSD still active'):
        value.close()
    hand.close.assert_called_once()
    button.close.assert_called_once()
    supervisor.stop.assert_called_once()
    sink.drain.assert_not_called()
    sink.close.assert_not_called()
    assert value._osd is not None and value._sink is sink
    value._osd.close.side_effect = None
    value.close()
    sink.close.assert_called_once()


def test_button_stop_failure_retains_gpu_and_retryable_sampler():
    supervisor = SimpleNamespace(input_provider=object(), stop=Mock())
    value = C6IButtonOsdRuntimeBackend(SimpleNamespace(build_id=0xC0061000), supervisor,
                                     osd_hub=object(), menu_fps=0)
    sink = Sink()
    value._sink = sink
    value._osd = None
    sampler = SimpleNamespace(close=Mock(side_effect=RuntimeError('GPIO thread alive')))
    value._button_sampler = sampler
    with pytest.raises(RuntimeError, match='GPIO thread alive'):
        value.close()
    supervisor.stop.assert_called_once()
    assert value._button_sampler is sampler and value._sink is sink
    sink.close.assert_not_called()
    sampler.close.side_effect = None
    value.close()
    sink.close.assert_called_once()


def test_stop_without_drain_cancels_completed_cpu_step_before_new_scene(monkeypatch):
    entered, release = threading.Event(), threading.Event()
    calls = []
    def step(_input):
        entered.set()
        assert release.wait(2)
        return SimpleNamespace(snapshot=SimpleNamespace(status='RUNNING'))
    preview = SimpleNamespace(step=step, stop=lambda: calls.append('preview-stop'))
    monkeypatch.setattr(PackagedGameRuntime, '_create_preview', lambda *_a, **_k: preview)
    value = PackagedGameRuntime(Path('unused.vvg'), object())
    value._submit = lambda *_a, **_k: calls.append('new-scene')
    value._drain = lambda: calls.append('drain')
    value._thread = threading.Thread(target=value._run, args=(60,))
    value._thread.start()
    try:
        assert entered.wait(1)
        # Release the CPU step only after the stop request has been published.
        notifier = threading.Thread(target=lambda: (value._stop.wait(1), release.set()))
        notifier.start()
        value.stop(drain=False)
        notifier.join(1)
        assert calls == ['preview-stop']
        value.stop()  # later explicit retry can drain retained GPU work
        assert calls == ['preview-stop', 'drain', 'preview-stop']
    finally:
        release.set()
        value._stop.set()
        if value._thread is not None:
            value._thread.join(1)


def test_worker_multiple_cleanup_faults_preserve_primary_and_are_retryable(runtime, tmp_path):
    value = worker(runtime, tmp_path)
    value.hardware.stop.side_effect = RuntimeError('first hardware failure')
    value.preview_encoder.close.side_effect = ValueError('second codec failure')
    with pytest.raises(RuntimeError) as error:
        value.stop()
    assert isinstance(error.value.__cause__, RuntimeError)
    assert str(error.value.__cause__) == 'first hardware failure'
    assert 'first hardware failure' in str(error.value) and 'second codec failure' in str(error.value)
    value.preview.close.assert_called_once()
    assert not (tmp_path/'stop_receipt.json').exists()
    value.hardware.stop.side_effect = value.preview_encoder.close.side_effect = None
    value.stop()
    import json
    receipt = json.loads((tmp_path/'stop_receipt.json').read_text())
    assert receipt['cleanup_confirmed']
    assert 'first hardware failure' in receipt['error']  # cleanup is not history erasure


def test_hardware_error_still_stops_real_codec_and_http_workers(runtime, tmp_path):
    value = worker(runtime, tmp_path)
    codec = http = None
    try:
        codec = ProcessPreviewEncoder(lambda: frozenset(), IdleEncode(), lambda *_: None)
        http = runtime.BytesPreview('127.0.0.1', 0)
        value.preview_encoder, value.preview = codec, http
        value.hardware.stop.side_effect = RuntimeError('unconfirmed DMA halt')
        with pytest.raises(RuntimeError, match='unconfirmed DMA halt'):
            value.stop()
        assert codec.health().cleanup == 'CLEAN'
        assert not codec._process.is_alive() and not codec._thread.is_alive()
        assert not http.thread.is_alive()
        assert not (tmp_path/'stop_receipt.json').exists()
        assert value.hardware is not None
    finally:
        if codec is not None:
            codec.close()
        if http is not None:
            http.close()


def test_supervisor_multiple_errors_keep_both_messages_and_original_cause():
    first = RuntimeError('first source failure')
    source = SimpleNamespace(suspend=Mock(), release=Mock(side_effect=first), capabilities={})
    child = SimpleNamespace(stop=Mock(side_effect=ValueError('second worker failure')),
                            error=None, state='IDLE', frame_id=0, diagnostic_error=None)
    owner = SharedVisionSupervisor(lambda _: child, source)
    owner._worker, owner._started = child, True
    with pytest.raises(RuntimeError) as error:
        owner.stop()
    assert error.value.__cause__ is first
    assert 'first source failure' in str(error.value) and 'second worker failure' in str(error.value)
    assert owner._worker is child and owner.status()['state'] == 'FAULT'


def test_vision_and_shell_errors_keep_original_cause_and_all_diagnostics(monkeypatch):
    first = RuntimeError('first vision failure')
    value = C6IVisionRuntimeBackend(SimpleNamespace(build_id=0xC0060800),
        SimpleNamespace(input_provider=object(), stop=Mock(side_effect=first)), menu_fps=0)
    def fail_close(self, **options):
        assert options['retain_sink']
        raise ValueError('second shell failure')
    monkeypatch.setattr(C6IShellRuntimeBackend, 'close', fail_close)
    with pytest.raises(RuntimeError) as error:
        value.close()
    assert error.value.__cause__ is first
    assert 'first vision failure' in str(error.value) and 'second shell failure' in str(error.value)
    assert value._last_error.startswith('RuntimeError: first vision failure')


@pytest.mark.parametrize('released',[False,True])
def test_preview_exit_only_releases_owner_when_cpu_resources_confirmed(runtime,tmp_path,released):
    value=worker(runtime,tmp_path)
    value.preview_encoder.release_confirmed=released
    value.preview_encoder.close.side_effect=RuntimeError('Preview cleanup FORCED: codec exit code -15')
    if released:
        value.stop()
        import json
        receipt=json.loads((tmp_path/'stop_receipt.json').read_text())
        assert receipt['cleanup_confirmed'] and receipt['error'] is None
        assert 'FORCED' in receipt['diagnostic_error']
    else:
        with pytest.raises(RuntimeError,match='FORCED'):value.stop()
        assert not (tmp_path/'stop_receipt.json').exists()
    value.hardware.stop.assert_called_once();value.preview.close.assert_called_once()


def test_released_preview_never_hides_hardware_failure(runtime,tmp_path):
    value=worker(runtime,tmp_path)
    value.hardware.stop.side_effect=RuntimeError('DMA ownership unknown')
    value.preview_encoder.release_confirmed=True
    value.preview_encoder.close.side_effect=RuntimeError('Preview cleanup FORCED')
    with pytest.raises(RuntimeError,match='DMA ownership unknown'):value.stop()
    assert not (tmp_path/'stop_receipt.json').exists()
