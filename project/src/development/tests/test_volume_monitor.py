from contextlib import contextmanager
import threading
import time
import unittest
from unittest.mock import patch

from pynq_multimodal_game.volume_monitor import BUILD_ID, PROFILE, SCHEMA, VolumeMonitorSession, VolumeStatusPublisher, make_volume_server, validate_volume_status, validate_fused_volume_status


def test_fused_disabled_baseline_never_configures_codec_or_starts_poller(tmp_path, monkeypatch):
    import importlib
    from pathlib import Path
    from types import SimpleNamespace
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import C6IVolumeRuntimeBackend, SharedVisionSupervisor
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    monkeypatch.syspath_prepend(str(Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts"))
    module = importlib.import_module("voice_volume_fusion")
    transport, control, codec = MagicMock(), MagicMock(), MagicMock()
    transport.process.is_alive.return_value = False
    control.monitor.return_value = {"enabled": False, "faults": 0, "ack_error": False}
    monkeypatch.setattr(module, "ProcessTransport", MagicMock(return_value=transport))
    monkeypatch.setattr(module, "VolumeControl", MagicMock(return_value=control))
    monkeypatch.setattr("voice_volume_runtime.configure_codec", codec)
    lease = MagicMock(bitfile_name=str(tmp_path / "fusion.bit"))
    session = SimpleNamespace(build_id=0xC0060C00, is_open=True,
        borrow=MagicMock(return_value=lease), ip_address=MagicMock(return_value=(0x43C10000, 4096)))
    volume = module.BorrowedVolumeControl(session, thresholds=(11, 16, 28), sampling_enabled=False)
    volume.open()
    assert volume.status()["sampling_enabled"] is False
    assert module.ProcessTransport.call_args.kwargs["timeout"] == 2
    assert not volume.status()["poller_alive"]
    assert volume.status()["lease_retained"]
    codec.assert_not_called()
    assert all(call.kwargs["enable"] is False for call in control.configure.call_args_list)
    volume.close()
    transport.close.assert_called_once()
    lease.close.assert_called_once()
    backend = C6IVolumeRuntimeBackend(session, SharedVisionSupervisor(lambda _run: None, GameVisionInputProvider()),
                                    volume_factory=lambda _owner: volume, volume_sampling_enabled=False)
    assert backend.supported_volume_schemas == ()


def test_fused_sampling_uses_autonomous_owner_and_readonly_latch(tmp_path, monkeypatch):
    import importlib
    from pathlib import Path
    from types import SimpleNamespace
    from unittest.mock import MagicMock
    from pynq_multimodal_game.volume_input import VolumeInputReader
    monkeypatch.syspath_prepend(str(Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts"))
    module = importlib.import_module("voice_volume_fusion")
    worker = MagicMock()
    worker.read.return_value = None
    worker.process.is_alive.return_value = True
    factory = MagicMock(return_value=worker)
    monkeypatch.setattr(module, "AutonomousVolumeProcess", factory)
    monkeypatch.setattr(module, "ProcessTransport", MagicMock(side_effect=AssertionError("parent RPC used")))
    lease = MagicMock(bitfile_name=str(tmp_path / "fusion.bit"))
    session = SimpleNamespace(build_id=0xC0060C00, is_open=True,
        borrow=MagicMock(return_value=lease), ip_address=MagicMock(return_value=(0x43C10000, 4096)))
    volume = module.BorrowedVolumeControl(session, thresholds=(11, 16, 28))
    volume.open()
    assert isinstance(volume.latch, VolumeInputReader)
    worker.start.assert_called_once()
    lease.export_process_guard.assert_called_once_with(factory.call_args.kwargs["producer_run"])
    assert volume.status()["poller_alive"]
    assert volume._thread is None and volume._control is None
    worker.stopped_confirmed = True
    worker.process.is_alive.return_value = False
    volume.close()
    worker.close.assert_called_once()
    lease.confirm_process_stopped.assert_called_once_with(volume._producer_run, disabled=True, exited=True)
    lease.close.assert_called_once()


def test_fused_autonomous_close_failure_retains_lease(tmp_path, monkeypatch):
    import importlib
    from pathlib import Path
    from types import SimpleNamespace
    from unittest.mock import MagicMock
    import pytest
    monkeypatch.syspath_prepend(str(Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts"))
    module = importlib.import_module("voice_volume_fusion")
    worker = MagicMock()
    worker.read.return_value = None
    worker.close.side_effect = RuntimeError("disable unconfirmed")
    monkeypatch.setattr(module, "AutonomousVolumeProcess", MagicMock(return_value=worker))
    lease = MagicMock(bitfile_name=str(tmp_path / "fusion.bit"))
    session = SimpleNamespace(build_id=0xC0060C00, is_open=True,
        borrow=MagicMock(return_value=lease), ip_address=MagicMock(return_value=(0x43C10000, 4096)))
    volume = module.BorrowedVolumeControl(session, thresholds=(11, 16, 28)).open()
    with pytest.raises(RuntimeError, match="disable unconfirmed.*retain Overlay lease"):
        volume.close()
    lease.confirm_process_stopped.assert_not_called()
    lease.close.assert_not_called()
    assert volume.status()["lease_retained"]


def test_fused_volume_sampling_starts_after_gpu_and_vision_cold_initialization(monkeypatch):
    from types import SimpleNamespace
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import C6IVolumeRuntimeBackend, SharedVisionSupervisor
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    operations = []
    volume = MagicMock()
    volume.status.return_value = {"error": None}
    volume.open.side_effect = lambda: operations.append("sampling-enabled")
    session = SimpleNamespace(build_id=0xC0060C00, open=MagicMock())
    def cold_gpu(_session, _timeout):
        volume.open.assert_not_called()
        operations.append("gpu-initialized")
        return MagicMock()
    worker = MagicMock(state="IDLE", error=None, diagnostic_error=None, frame_id=0)
    worker.prepare_preview.side_effect = lambda: operations.append("preview-prepared")
    def cold_vision(_run):
        volume.open.assert_not_called()
        assert operations == ["gpu-initialized"]
        operations.append("vision-initialized")
        return worker
    factory = MagicMock(side_effect=cold_vision)
    backend = C6IVolumeRuntimeBackend(session, SharedVisionSupervisor(factory, GameVisionInputProvider()),
        volume_factory=lambda _owner: volume, sink_factory=cold_gpu, menu_fps=0)
    monkeypatch.setattr(backend, "_start_menu_locked", MagicMock())
    try:
        backend.open()
        assert operations == ["gpu-initialized", "vision-initialized", "preview-prepared", "sampling-enabled"]
        worker.start.assert_not_called()
        backend.start_vision()
        backend.start_vision()
        factory.assert_called_once()
        worker.prepare_preview.assert_called_once()
        worker.start.assert_called_once()
    finally:
        backend.close()


def test_fused_vision_cold_prepare_failure_keeps_sampling_off_and_cleans_up(monkeypatch):
    import pytest
    from types import SimpleNamespace
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import C6IVolumeRuntimeBackend, SharedVisionSupervisor
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    worker = MagicMock(state="IDLE", error=None, diagnostic_error=None, frame_id=0)
    worker.prepare_preview.side_effect = RuntimeError("vision cold preparation failed")
    volume, sink = MagicMock(), MagicMock()
    volume.status.return_value = {"error": None}
    session = SimpleNamespace(build_id=0xC0060C00, open=MagicMock())
    backend = C6IVolumeRuntimeBackend(session,
        SharedVisionSupervisor(lambda _run: worker, GameVisionInputProvider()),
        volume_factory=lambda _owner: volume, sink_factory=lambda *_args: sink, menu_fps=0)
    monkeypatch.setattr(backend, "_start_menu_locked", MagicMock())
    with pytest.raises(RuntimeError, match="vision cold preparation failed"):
        backend.open()
    volume.open.assert_not_called()
    worker.start.assert_not_called()
    worker.stop.assert_called_once()
    volume.close.assert_called_once()
    sink.close.assert_called_once()
    assert backend._volume is None and backend._sink is None


def test_packaged_stop_releases_terminal_input_only_once():
    from pathlib import Path
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime

    operations = []
    def resume():
        assert "release" not in operations
        operations.append("resume")
    def release(_message):
        operations.append("release")
    runtime = PackagedGameRuntime(Path("unused.vvg"), SimpleNamespace(),
                                  live_input=SimpleNamespace(resume=resume, release=release))
    runtime.stop()
    runtime.stop()
    assert operations == ["resume", "release"]


def volume_fixture(**changes):
    value = {"schema": SCHEMA, "profile": PROFILE, "build_id": BUILD_ID, "epoch": 1,
             "enabled": True, "clock_locked": True, "faults": 0, "ack_error": False,
             "state": 1, "snapshot_valid": True, "sample_count": 977, "window_count": 1,
             "l1_sum": 9770, "mean_abs": 10.0, "thresholds": {"quiet": 1000, "soft": 20000, "loud": 80000}, "event": None}
    value.update(changes)
    return value


def fused_volume_fixture(**changes):
    identity = {"profile": "C6I_VISION_VOLUME_V1", "build_id": 0xC0060C00}
    volume = {**identity, "error": None, "sampling_enabled": True, "poller_alive": True,
        "lease_retained": True, "latch": {"producer_run": "a" * 32, "source_epoch": 1,
            "error": None, "last_receipt": None},
        "observation": {"sequence": 1, "cache_age_ms": 0., "error": None, "snapshot": volume_fixture()}}
    volume.update(changes)
    return {**identity, "volume": volume}


def test_fused_status_preserves_outer_component_identity_and_rejects_malformed_cache():
    from copy import deepcopy
    import pytest
    snapshot = fused_volume_fixture()
    assert validate_fused_volume_status(snapshot) is snapshot["volume"]
    assert validate_fused_volume_status(fused_volume_fixture(observation=None, latch=None, sampling_enabled=False))["observation"] is None
    changes = (((), "profile", PROFILE), (("volume",), "build_id", BUILD_ID),
        (("volume",), "poller_alive", 1), (("volume", "latch"), "source_epoch", True),
        (("volume", "latch"), "producer_run", "wrong"), (("volume", "latch"), "error", False),
        (("volume", "observation"), "sequence", True), (("volume", "observation"), "cache_age_ms", float("nan")),
        (("volume", "observation"), "cache_age_ms", -1),
        (("volume", "observation", "snapshot"), "profile", "C6I_VISION_VOLUME_V1"),
        (("volume", "observation", "snapshot"), "epoch", 2))
    for path, key, value in changes:
        malformed = deepcopy(snapshot)
        target = malformed
        for member in path:
            target = target[member]
        target[key] = value
        with pytest.raises(ValueError):
            validate_fused_volume_status(malformed)


class VolumeReaderTests(unittest.TestCase):
    def test_corrupt_cache_is_neutral_and_sticky_fault_without_consumer_ack(self):
        changes = ({"faults": 0x10}, {"ack_error": 1}, {"clock_locked": 0},
            {"observed_ns": 200_000_000_000}, {"monitor_sequence": 0},
            {"event_sequence": -1}, {"event_sample": 0}, {"event_kind": 9},
            {"acked_ns": 200_000_000_000}, {"expires_ns": 200_000_000_000})
        for change in changes:
            with self.subTest(change=change):
                self.setUp()
                self.offer()
                self.source.update(change)
                self.assertIsNone(self.reader.consume(1))
                self.assertIsNotNone(self.reader.status(refresh=False)["error"])

    def setUp(self):
        from pynq_multimodal_game.volume_input import VolumeInputReader
        self.clock = 100.0
        self.source = {"producer_run": "a" * 32, "phase": 2, "error": None,
            "observed_ns": 100_000_000_000, "monitor_sequence": 1, "epoch": 2,
            "enabled": 1, "clock_locked": 1, "faults": 0, "ack_error": 0,
            "state": 1, "snapshot_valid": 1, "sample_count": 9770, "window_count": 10,
            "l1_sum": 977, "quiet": 10747, "soft": 15632, "loud": 27356,
            "event_sequence": 0, "event_kind": 0, "ack_count": 0}
        self.reads = 0
        def read():
            self.reads += 1
            return dict(self.source)
        self.reader = VolumeInputReader(read, producer_run="a" * 32, now=lambda: self.clock)
        self.reader.bind_consumer()
        self.clock = 100.04
        self.source.update(observed_ns=100_040_000_000, monitor_sequence=2)
        self.assertIsNone(self.reader.consume(0))
        self.assertFalse(self.reader.status()["waiting_armed"])

    def offer(self, sequence=1):
        self.clock += 0.02
        self.source.update(observed_ns=int(self.clock * 1e9), monitor_sequence=sequence + 2,
            event_sequence=sequence, event_kind=1, event_epoch=2, event_sample=11724 + sequence * 977,
            event_window=12 + sequence, expires_ns=int((self.clock + 0.08) * 1e9),
            acked_ns=int(self.clock * 1e9), publication_id=sequence, ack_count=sequence)

    def test_reads_confirmed_event_once_and_preserves_original_deadline(self):
        self.offer()
        self.reads = 0
        signal = self.reader.consume(1)
        self.assertEqual(signal.kind, "SOFT")
        self.assertEqual(self.reads, 1)
        self.assertEqual(self.reader.status(refresh=False)["last_receipt"]["sample_tick"], 1)
        self.assertIsNone(self.reader.consume(2))
        self.assertIsNone(self.reader.status()["error"])

    def test_expired_acknowledged_event_drops_without_fault_and_next_event_works(self):
        self.offer()
        self.source["expires_ns"] = int((self.clock - 0.001) * 1e9)
        self.source["acked_ns"] = self.source["expires_ns"] - 1_000_000
        self.assertIsNone(self.reader.consume(1))
        self.assertEqual(self.reader.status()["drops"]["expired_on_read"], 1)
        self.assertIsNone(self.reader.status()["error"])
        self.offer(2)
        self.assertEqual(self.reader.consume(2).sequence, 2)

    def test_resume_requires_new_armed_window_and_never_replays_saved_event(self):
        self.offer()
        self.reader.suspend()
        self.reader.resume()
        self.assertIsNone(self.reader.consume(1))
        self.clock += 0.04
        self.source.update(observed_ns=int(self.clock * 1e9), event_kind=0,
                           window_count=15, sample_count=14655, monitor_sequence=5)
        self.assertIsNone(self.reader.consume(2))
        self.offer(2)
        self.source["monitor_sequence"] = 6
        self.source["event_window"] = 16
        self.assertEqual(self.reader.consume(3).sequence, 2)

    def test_pre_switch_event_published_late_never_enters_new_generation(self):
        self.reader.release()
        self.reader.bind_consumer()
        self.clock += 0.04
        self.source.update(observed_ns=int(self.clock * 1e9), monitor_sequence=3,
                           window_count=14, sample_count=13678)
        self.assertIsNone(self.reader.consume(1))
        self.offer()
        self.source["monitor_sequence"] = 4
        self.source["event_window"] = 13
        self.assertIsNone(self.reader.consume(2))
        self.assertEqual(self.reader.status()["drops"]["old_generation"], 1)

    def test_true_source_fault_is_sticky_but_stale_cache_is_only_neutral(self):
        self.clock += 0.6
        self.assertIsNone(self.reader.consume(1))
        self.assertIsNone(self.reader.status()["error"])
        self.source.update(phase=4, error="exact ACK rejected")
        self.assertIsNone(self.reader.consume(2))
        self.assertIn("exact ACK rejected", self.reader.status()["error"])

    def test_status_keeps_component_contract_and_does_not_refresh_source_age(self):
        self.clock += 0.04
        status = self.reader.status()
        self.assertAlmostEqual(status["observation"]["cache_age_ms"], 40)
        validate_volume_status(status["observation"]["snapshot"])
        status["observation"]["snapshot"]["mean_abs"] = 999
        self.assertEqual(self.reader.status()["observation"]["snapshot"]["mean_abs"], 1)


class VolumeMonitorTests(unittest.TestCase):
    def test_schema_and_invalid_measurements(self):
        self.assertEqual(validate_volume_status(volume_fixture())["mean_abs"], 10)
        for changes in ({"build_id": 0xC0060900}, {"clock_locked": 1}, {"mean_abs": float("nan")}, {"mean_abs": 12}, {"faults": 2}, {"window_count": 0}):
            with self.subTest(changes=changes), self.assertRaises(ValueError):
                validate_volume_status(volume_fixture(**changes))

    def test_fault_has_no_live_level(self):
        value = volume_fixture(faults=2, state=4, snapshot_valid=False, sample_count=None, window_count=None, l1_sum=None, mean_abs=None, thresholds=None)
        self.assertEqual(validate_volume_status(value)["faults"], 2)

    def test_cached_get_never_reads_hardware_and_event_is_local(self):
        value = volume_fixture(event={"kind": "SOFT", "epoch": 1, "sequence": 1, "source_sample": 7816, "source_window": 8, "age_ms": 1})
        calls, acknowledgements = [], []
        publisher = VolumeStatusPublisher(lambda: calls.append(1) or value, consume_event=lambda event: acknowledgements.append(event))
        publisher.sample_once()
        for _ in range(30): publisher.status()
        self.assertEqual(len(calls), 1)
        self.assertEqual(len(acknowledgements), 1)
        value["l1_sum"] = 0
        value["mean_abs"] = 0
        self.assertEqual(publisher.status()["snapshot"]["l1_sum"], 9770)
        publisher.sample_once()
        self.assertEqual(len(publisher.status()["recent_events"]), 1)
        self.assertIsNone(publisher.status()["error"])

    def test_real_http_and_restart(self):
        publisher = VolumeStatusPublisher(volume_fixture)
        publisher.sample_once()
        server = make_volume_server(publisher, port=0)
        thread = threading.Thread(target=server.serve_forever, kwargs={"poll_interval": 0.02})
        thread.start()
        try:
            session = VolumeMonitorSession(f"http://127.0.0.1:{server.server_port}/status")
            first = session.request()
            self.assertEqual(first["snapshot"]["mean_abs"], 10)
            with patch("pynq_multimodal_game.volume_monitor.time.monotonic", return_value=publisher._updated + 1):
                with self.assertRaisesRegex(ValueError, "stale"):
                    session.request()
            session.close()
            publisher.start()
            self.assertTrue(publisher._thread.is_alive())
        finally:
            server.shutdown(); server.server_close(); thread.join(1); publisher.close()
        self.assertFalse(thread.is_alive())
        self.assertFalse(publisher._thread.is_alive())

    def test_slow_http_body_is_bounded_by_total_deadline(self):
        from http.server import BaseHTTPRequestHandler, HTTPServer
        release = threading.Event()
        class Handler(BaseHTTPRequestHandler):
            def do_GET(self):
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.send_header("Content-Length", "100")
                self.end_headers()
                self.wfile.write(b"{")
                self.wfile.flush()
                release.wait(1)
            def log_message(self, *arguments): pass
        server = HTTPServer(("127.0.0.1", 0), Handler)
        thread = threading.Thread(target=server.serve_forever, kwargs={"poll_interval": 0.01})
        thread.start()
        started = time.monotonic()
        try:
            with self.assertRaises((OSError, ConnectionError, ValueError)):
                VolumeMonitorSession(f"http://127.0.0.1:{server.server_port}", timeout=0.1).request()
            self.assertLess(time.monotonic() - started, 0.5)
        finally:
            release.set(); server.shutdown(); server.server_close(); thread.join(1)

    def test_http_rejects_wrong_identity_history_and_counter_regression(self):
        from copy import deepcopy
        publisher = VolumeStatusPublisher(volume_fixture)
        publisher.sample_once()
        envelope = publisher.status()
        publisher.status = lambda: envelope
        server = make_volume_server(publisher, port=0)
        thread = threading.Thread(target=server.serve_forever, kwargs={"poll_interval": 0.01})
        thread.start()
        session = VolumeMonitorSession(f"http://127.0.0.1:{server.server_port}")
        try:
            self.assertEqual(session.request()["sequence"], 1)
            for changes in ({"build_id": True}, {"recent_events": [{}]}, {"source_kind": "real-board-pass"}, {"cache_age_ms": 501}, {"sequence": 0}):
                saved = deepcopy(envelope)
                envelope.update(changes)
                with self.assertRaises(ValueError): session.request()
                envelope = saved
            envelope["snapshot"].update(sample_count=0, window_count=0, l1_sum=None, mean_abs=None)
            with self.assertRaisesRegex(ValueError, "counters regressed"): session.request()
            envelope["producer_run"] = "a" * 32
            self.assertEqual(session.request()["snapshot"]["sample_count"], 0)
        finally:
            server.shutdown(); server.server_close(); thread.join(1)

    def test_sampler_error_invalidates_old_reading(self):
        publisher = VolumeStatusPublisher(volume_fixture)
        publisher.sample_once()
        def fail(): raise RuntimeError("codec source lost")
        publisher.reader = fail
        publisher.sample_once()
        self.assertIsNone(publisher.status()["snapshot"])
        self.assertIn("source lost", publisher.status()["error"])
        self.assertTrue(publisher._stopping.is_set())

    def test_control_ack_without_studio_and_reject_changed_event(self):
        from types import SimpleNamespace
        event = {"kind": "SOFT", "epoch": 1, "sequence": 1, "source_sample": 7816, "source_window": 8, "age_ms": 1}
        offered = SimpleNamespace(epoch=1, sequence=1, kind="SOFT")
        acknowledgements = []
        control = SimpleNamespace(monitor=lambda: volume_fixture(event=event), event=lambda: offered,
                                  acknowledge=lambda value: acknowledgements.append(value))
        publisher = VolumeStatusPublisher.from_control(control)
        publisher.sample_once()
        self.assertEqual(acknowledgements, [offered])
        self.assertEqual(publisher.status()["source_kind"], "control")
        offered.sequence = 2
        publisher.sample_once()
        self.assertIsNone(publisher.status()["snapshot"])
        self.assertIn("changed before ACK", publisher.status()["error"])

    def test_cli_fixture_has_no_factory_or_hardware_import(self):
        from pynq_multimodal_game.volume_monitor import main
        class Server:
            server_port = 12345
            def serve_forever(self, **keywords): raise KeyboardInterrupt
            def server_close(self): pass
        with patch("pynq_multimodal_game.volume_monitor.make_volume_server", return_value=Server()), patch("importlib.import_module", side_effect=AssertionError("fixture imported a backend")):
            self.assertEqual(main(["--fixture", "--port", "0"]), 0)

    def test_cli_managed_control_close_order(self):
        from types import SimpleNamespace
        from pynq_multimodal_game.volume_monitor import main
        operations = []
        @contextmanager
        def factory():
            operations.append("owner_enter")
            try: yield SimpleNamespace(monitor=volume_fixture)
            finally: operations.append("owner_exit")
        class Server:
            server_port = 12345
            def serve_forever(self, **keywords): raise KeyboardInterrupt
            def server_close(self): operations.append("http_closed")
        with patch("pynq_multimodal_game.volume_monitor.make_volume_server", return_value=Server()), patch("importlib.import_module", return_value=SimpleNamespace(create=factory)):
            self.assertEqual(main(["--control-factory", "authorized:create"]), 0)
        self.assertEqual(operations, ["owner_enter", "http_closed", "owner_exit"])

    def test_cli_unconfirmed_sampler_does_not_release_owner(self):
        from types import SimpleNamespace
        from pynq_multimodal_game.volume_monitor import main
        operations = []
        @contextmanager
        def factory():
            operations.append("owner_enter")
            try: yield SimpleNamespace(monitor=volume_fixture)
            finally: operations.append("owner_exit")
        class Server:
            server_port = 12345
            def serve_forever(self, **keywords): raise KeyboardInterrupt
            def server_close(self): pass
        try:
            with patch("pynq_multimodal_game.volume_monitor.make_volume_server", return_value=Server()), patch("importlib.import_module", return_value=SimpleNamespace(create=factory)), patch.object(VolumeStatusPublisher, "close", side_effect=RuntimeError("sampler not confirmed")):
                with self.assertRaisesRegex(RuntimeError, "not confirmed"):
                    main(["--control-factory", "authorized:create"])
            self.assertEqual(operations, ["owner_enter"])
            with self.assertRaisesRegex(RuntimeError, "owner still retained"):
                main(["--fixture"])
        finally:
            context, control, publisher, server = main.retained_session
            publisher.close()
            context.__exit__(None, None, None)
            del main.retained_session
        self.assertEqual(operations, ["owner_enter", "owner_exit"])

    def test_url_rejects_credentials_and_wrong_path(self):
        for url in ("https://localhost/status", "http://user:password@localhost/status", "http://localhost/reset", "http://localhost/status?enable=1"):
            with self.subTest(url=url), self.assertRaises(ValueError): VolumeMonitorSession(url)


class VolumeInputTests(unittest.TestCase):
    def setUp(self):
        from types import SimpleNamespace
        from pynq_multimodal_game.volume_input import VolumeEventLatch
        self.clock = 10.0
        self.event = SimpleNamespace(epoch=1, sequence=1, kind="SOFT", source_sample=7816,
                                     source_window=8, expires=10.08)
        self.offered = self.event
        self.reads, self.acks = [], []
        def monitor():
            self.reads.append(1)
            fields = None if self.offered is None else {
                key: getattr(self.offered, key) for key in
                ("epoch", "sequence", "kind", "source_sample", "source_window")}
            return volume_fixture(event=None if fields is None else {**fields, "age_ms": 20})
        def acknowledge(event):
            self.assertIs(event, self.offered)
            self.assertIsNotNone(self.latch.status()["pending"])
            self.assertFalse(self.latch.status()["pending"]["hardware_acked"])
            self.assertIsNone(self.latch.consume(0))
            self.acks.append(event)
            self.offered = None
        self.control = SimpleNamespace(monitor=monitor, event=lambda: self.offered,
                                       acknowledge=acknowledge)
        self.latch = VolumeEventLatch(self.control, producer_run="a" * 32, now=lambda: self.clock)

    def game_provider(self, mapping="game1", *, enabled=True):
        from types import SimpleNamespace
        from pynq_multimodal_game.game_sdk import GameInput
        from pynq_multimodal_game.game_package import GameVolumeInputContract
        from pynq_multimodal_game.volume_input import VolumeGameInputProvider
        self.visual_calls = []
        def sample(game_id, *, tick_id, timestamp_ns=None):
            self.visual_calls.append(game_id)
            return GameInput(tick_id=tick_id, timestamp_ns=0 if timestamp_ns is None else timestamp_ns,
                             hand_valid=False, hand_x=0.0, hand_y=0.0, fist_sequence=0,
                             fist_event=False), {"mapping": game_id}
        visual = SimpleNamespace(sample_for_game=sample, suspend=lambda: None, resume=lambda: None,
                                 release=lambda _message: None)
        self.latch.release()
        manifest = SimpleNamespace(game_id="volume-test", inputs=None,
            volume_inputs=GameVolumeInputContract("volume-signal-v1", mapping) if enabled else None)
        root = VolumeGameInputProvider(visual, self.latch)
        return root, manifest, root.new_game_session(manifest, "b" * 32)

    def test_volume_game_session_maps_visual_and_consumes_local_signal_once(self):
        root, manifest, session = self.game_provider()
        self.assertTrue(self.latch.poll_once())
        reads = len(self.reads)
        value, visual = session.sample_for_game("volume-test", tick_id=0, timestamp_ns=20)
        self.assertEqual(value.volume.kind, "SOFT")
        self.assertIsNone(value.tone)
        self.assertEqual(visual["mapping"], "game1")
        receipt = session.volume_receipt_for_tick(0)
        self.assertTrue(receipt["hardware_acked"] and receipt["logic_consumed"])
        self.assertEqual(receipt["game_run"], "b" * 32)
        receipt["signal"]["kind"] = "LOUD"
        self.assertEqual(session.volume_receipt_for_tick(0)["signal"]["kind"], "SOFT")
        self.assertIsNone(session.sample_current_for_game("volume-test", tick_id=1)[0].volume)
        self.assertEqual(len(self.reads), reads)
        with self.assertRaisesRegex(RuntimeError, "released healthy"):
            root.new_game_session(manifest, "c" * 32)
        with self.assertRaises(ValueError):
            session.volume_receipt_for_tick(0)
        session.release()
        self.assertIsNone(root.new_game_session(manifest, "c" * 32).sample_current_for_game("volume-test", tick_id=0)[0].volume)

    def test_declared_volume_is_independent_of_vision_mapping(self):
        for mapping in ("game1", "game2", "game3"):
            with self.subTest(mapping=mapping):
                self.setUp()
                _, _, session = self.game_provider(mapping)
                self.assertTrue(self.latch.poll_once())
                value, _ = session.sample_current_for_game("volume-test", tick_id=0)
                self.assertEqual(value.volume.kind, "SOFT")
                self.assertIsNone(session.sample_current_for_game("volume-test", tick_id=1)[0].volume)
                self.assertEqual(self.visual_calls, [mapping, mapping])

    def test_legacy_packages_without_volume_contract_never_receive_volume(self):
        _, _, session = self.game_provider(enabled=False)
        self.assertFalse(self.latch.poll_once())
        value, _ = session.sample_current_for_game("volume-test", tick_id=0)
        self.assertIsNone(value.volume)
        self.assertEqual(len(self.acks), 1)
        self.assertEqual(self.latch.status()["discarded"], 1)
        self.assertEqual(self.visual_calls, ["volume-test"])

    def test_real_gesture_and_volume_share_one_input_for_every_mapping(self):
        from types import SimpleNamespace
        from pynq_multimodal_game.game_package import GameVolumeInputContract
        from pynq_multimodal_game.game_sdk import HandGesture
        from pynq_multimodal_game.vision_input import GameVisionInputProvider
        from pynq_multimodal_game.volume_input import VolumeGameInputProvider

        for mapping in ("game1", "game2", "game3"):
            with self.subTest(mapping=mapping):
                self.setUp()
                visual = GameVisionInputProvider(clock=lambda: self.clock)
                self.latch.release()
                manifest = SimpleNamespace(game_id="reusable-custom-game", inputs=None,
                    volume_inputs=GameVolumeInputContract("volume-signal-v1", mapping))
                session = VolumeGameInputProvider(visual, self.latch).new_game_session(manifest, "b" * 32)
                visual.publish({"run_id": "real-shared", "server_age_ms": 0,
                    "frame": 1, "stable": "0", "rps": "ROCK",
                    "control": {"schema": "gesture-control-v1", "frame_id": 1,
                                "valid": True, "direction": "UP", "action_event_seq": 0}})
                self.assertTrue(self.latch.poll_once())
                value, receipt = session.sample_current_for_game("reusable-custom-game", tick_id=0)
                self.assertTrue(value.hand_valid and value.fist_event)
                self.assertIs(value.hand_gesture, HandGesture.FIST)
                self.assertEqual(value.hand_y, -1.0)
                self.assertEqual(value.volume.kind, "SOFT")
                self.assertEqual(receipt["hand_gesture"], receipt["source_hand_gesture"])
                self.assertTrue(session.volume_receipt_for_tick(0)["input_delivered"])
                value, _ = session.sample_current_for_game("reusable-custom-game", tick_id=1)
                self.assertIs(value.hand_gesture, HandGesture.FIST)
                self.assertFalse(value.fist_event)
                self.assertIsNone(value.volume)

    def test_volume_game_pause_discards_and_resume_keeps_original_deadline(self):
        _, _, session = self.game_provider("game3")
        self.assertTrue(self.latch.poll_once())
        session.suspend()
        session.resume()
        self.assertIsNone(session.sample_current_for_game("volume-test", tick_id=1)[0].volume)
        self.assertEqual(self.latch.status()["discarded"], 1)
        self.event.sequence = 2
        self.offered = self.event
        self.assertTrue(self.latch.poll_once())
        self.clock = self.event.expires
        with self.assertRaisesRegex(RuntimeError, "expired"):
            session.sample_current_for_game("volume-test", tick_id=2)
        session.release()
        with self.assertRaisesRegex(RuntimeError, "new session"):
            session.resume()

    def test_reserve_before_exact_ack_then_consume_once_without_hardware(self):
        self.assertTrue(self.latch.poll_once())
        self.assertFalse(self.latch.poll_once())
        self.assertEqual(len(self.reads), 1)
        signal = self.latch.consume(7)
        self.assertEqual((signal.sequence, signal.kind), (1, "SOFT"))
        self.assertIsNone(self.latch.consume(8))
        self.assertEqual(self.acks, [self.event])
        self.assertEqual(self.latch.status()["last_receipt"]["sample_tick"], 7)

    def test_fused_observation_is_read_only_and_keeps_original_cache_age(self):
        self.assertIsNone(self.latch.status()["observation"])
        self.assertTrue(self.latch.poll_once())
        observation = self.latch.status()["observation"]
        self.assertEqual(observation["sequence"], 1)
        self.assertEqual(observation["cache_age_ms"], 0)
        observation["snapshot"]["mean_abs"] = 999
        self.clock += 0.04
        for _ in range(30):
            current = self.latch.status()["observation"]
            self.assertAlmostEqual(current["cache_age_ms"], 40)
            self.assertEqual(current["snapshot"]["mean_abs"], 10)
        self.assertFalse(self.latch.poll_once())
        self.assertEqual(len(self.reads), 1)
        self.assertEqual(len(self.acks), 1)
        self.assertEqual(self.latch.status()["pending"]["expires"], 10.08)
        self.clock = 10.08
        self.assertFalse(self.latch.poll_once())
        current = self.latch.status()["observation"]
        self.assertEqual(current["sequence"], 1)
        self.assertIn("expired", current["error"])

    def test_full_slot_never_reads_or_overwrites_and_original_deadline_expires(self):
        self.assertTrue(self.latch.poll_once())
        self.offered = self.event
        self.clock = 10.08
        self.assertFalse(self.latch.poll_once())
        self.assertEqual(len(self.reads), 1)
        self.assertIsNone(self.latch.consume(1))
        self.assertIn("expired", self.latch.status()["error"])
        self.assertEqual(self.latch.status()["discarded"], 1)

    def test_ack_failure_rejects_game_delivery_and_keeps_first_fault(self):
        def fail(event):
            raise RuntimeError("exact ACK rejected")
        self.control.acknowledge = fail
        self.assertFalse(self.latch.poll_once())
        self.assertIsNone(self.latch.consume(1))
        self.assertIn("exact ACK rejected", self.latch.status()["error"])
        self.assertFalse(self.latch.poll_once())
        self.assertEqual(len(self.reads), 1)

    def test_pause_resume_release_do_not_replay_saved_event(self):
        self.assertTrue(self.latch.poll_once())
        self.latch.suspend()
        self.assertIsNone(self.latch.consume(1))
        self.latch.resume()
        self.assertIsNone(self.latch.consume(2))
        self.assertFalse(self.latch.poll_once())
        self.latch.release()
        with self.assertRaisesRegex(RuntimeError, "new consumer"):
            self.latch.resume()

    def test_paused_source_is_acked_but_never_delivered(self):
        self.latch.suspend()
        self.assertFalse(self.latch.poll_once())
        self.assertEqual(self.acks, [self.event])
        self.latch.resume()
        self.assertIsNone(self.latch.consume(1))
        self.assertEqual(self.latch.status()["last_receipt"]["disposition"], "consumer inactive")

    def test_changed_offer_and_duplicate_sequence_fault_before_ack(self):
        original = self.control.event
        def changed():
            result = original()
            result.source_window += 1
            return result
        self.control.event = changed
        self.assertFalse(self.latch.poll_once())
        self.assertEqual(self.acks, [])
        self.assertIn("changed before reservation", self.latch.status()["error"])

    def test_lifecycle_change_during_ack_cannot_reenter_new_game_generation(self):
        original = self.control.acknowledge
        def pause_in_ack(event):
            original(event)
            self.latch.suspend()
            self.latch.resume()
        self.control.acknowledge = pause_in_ack
        self.assertFalse(self.latch.poll_once())
        self.assertIsNone(self.latch.consume(1))
        self.assertTrue(self.latch.status()["last_receipt"]["hardware_acked"])

    def test_menu_release_keeps_source_acked_and_new_consumer_has_no_old_event(self):
        self.latch.release()
        self.assertFalse(self.latch.poll_once())
        self.assertEqual(self.acks, [self.event])
        self.assertIsNone(self.latch.consume(1))
        self.latch.bind_consumer()
        self.assertIsNone(self.latch.consume(2))
        self.assertEqual(self.latch.status()["accepted"], 1)

    def test_duplicate_sequence_after_consumption_is_not_acked_again(self):
        self.assertTrue(self.latch.poll_once())
        self.assertIsNotNone(self.latch.consume(1))
        self.offered = self.event
        self.assertFalse(self.latch.poll_once())
        self.assertEqual(self.acks, [self.event])
        self.assertIn("repeated", self.latch.status()["error"])

    def test_source_epoch_loss_is_an_explicit_fault(self):
        self.assertTrue(self.latch.poll_once())
        self.assertIsNotNone(self.latch.consume(1))
        self.control.monitor = lambda: volume_fixture(epoch=2)
        self.assertFalse(self.latch.poll_once())
        self.assertIn("epoch changed", self.latch.status()["error"])

    def test_ack_that_returns_after_original_deadline_never_reaches_game(self):
        original = self.control.acknowledge
        def late(event):
            original(event)
            self.clock = event.expires
        self.control.acknowledge = late
        self.assertFalse(self.latch.poll_once())
        self.assertIsNone(self.latch.consume(1))
        self.assertIn("after original deadline", self.latch.status()["error"])
        self.assertTrue(self.latch.status()["last_receipt"]["hardware_acked"])


if __name__ == "__main__":
    unittest.main()