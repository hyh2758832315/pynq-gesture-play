import pytest
from pathlib import Path

from pynq_multimodal_game.agent import (
    AgentCommand,
    AgentController,
    AgentServer,
    MockRuntimeBackend,
)
from pynq_multimodal_game.studio.device import (
    DeviceState,
    RemoteDeviceSession,
    SimulatedDeviceSession,
)


@pytest.mark.parametrize("profile, valid", (("C6I_VISION_BUTTON_V1", True),
                                            ("C6I_VISION", False), (None, False)))
def test_button_candidate_hello_requires_paired_profile(monkeypatch, profile, valid):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.studio import device as module

    client = MagicMock()
    client.connect.return_value = {"build_id": 0xC0061000, "profile": profile,
                                   "vision_commands": []}
    monkeypatch.setattr(module, "AgentClient", MagicMock(return_value=client))
    session = RemoteDeviceSession("localhost", 8765, expected_build_id=0xC0061000)
    assert (session.connect().state is DeviceState.READY) is valid
    if valid:
        client.subscribe.assert_called_once_with([])


def test_button_candidate_subscribes_to_no_return_sources_by_default(monkeypatch):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.studio import device as module

    client = MagicMock()
    client.connect.return_value = {"build_id": 0xC0061000,
                                   "profile": "C6I_VISION_BUTTON_V1", "vision_commands": []}
    monkeypatch.setattr(module, "AgentClient", MagicMock(return_value=client))
    session = RemoteDeviceSession("localhost", 8765, expected_build_id=0xC0061000)
    assert session.connect().state is DeviceState.READY
    client.subscribe.assert_called_once_with([])
    session.disconnect()


@pytest.mark.parametrize("state, accepted", (("RUNNING", True), ("IDLE", False)))
def test_button_candidate_live_vision_uses_existing_status_only(monkeypatch, state, accepted):
    import threading

    session = RemoteDeviceSession("localhost", 8765, expected_build_id=0xC0061000)
    snapshot = {"profile": "C6I_VISION_BUTTON_V1", "build_id": 0xC0061000,
                "vision": {"state": state, "input_capabilities": {
                    "schema": "local-game-vision-v1", "mode": "games", "games": ["game1"]}}}
    observed = []
    monkeypatch.setattr(session, "video_status", lambda: observed.append("status") or
                        {"ok": True, "snapshot": snapshot})
    if accepted:
        assert session.start_shared_vision(stop_event=threading.Event(), game_id="game1")["snapshot"] is snapshot
    else:
        with pytest.raises(RuntimeError, match="does not advertise VISION_START"):
            session.start_shared_vision(stop_event=threading.Event(), game_id="game1")
    assert observed == ["status"]
from pynq_multimodal_game.game_package import GamePackageBuilder
from pynq_multimodal_game.game_project import GameProject
from pynq_multimodal_game.video_codec import S2V1_HEIGHT, S2V1_WIDTH, encode_rgb_frames


@pytest.mark.parametrize("build_id, control_timeout", (
    (0xC0060700, 75.0), (0xC0060800, 75.0), (0xC0060900, 75.0),
    (0xC0060C00, 75.0), (0xC0061000, 75.0)))
def test_game_lifecycle_budget_does_not_extend_status_or_voice_poll(monkeypatch, build_id, control_timeout):
    from pynq_multimodal_game.studio import device as module
    session = RemoteDeviceSession("localhost", 8765, expected_build_id=build_id)

    class Client:
        def __init__(self, host, port, *, timeout, source_address=None):
            self.timeout = timeout

        def connect(self):
            if build_id == 0xC0060C00:
                return {"build_id": build_id, "profile": "C6I_VISION_VOLUME_V1",
                        "input_schema_version": 4, "supported_volume_schemas": []}
            return {"build_id": build_id, "profile": "C6I_VISION_BUTTON_V1"}

        def command(self, *args, **kwargs):
            return {"ok": True, "timeout": self.timeout}

        def close(self):
            pass

    monkeypatch.setattr(module, "AgentClient", Client)
    for command in (lambda: session.run_game("probe"), session.pause_game, session.resume_game,
                    session.reset_game, session.stop_video):
        assert command()["timeout"] == control_timeout
    assert session.video_status()["timeout"] == 0.25
    if build_id == 0xC0060900:
        assert session.create_voice_monitor().client.timeout == 0.5
    session._client.timeout = 90.0
    assert session.run_game("probe")["timeout"] == 90.0


@pytest.mark.parametrize('library_kind',['game','video'])
def test_button_library_launch_ack_survives_startup_longer_than_status_poll(library_kind):
    from dataclasses import replace
    from time import sleep

    class Backend(MockRuntimeBackend):
        @property
        def snapshot(self):
            return replace(super().snapshot, profile="C6I_VISION_BUTTON_V1")

        def run_library_item(self, item_id, library_kind, *, test_case_json=None):
            sleep(0.6)  # Process startup/resource upload exceeds the 250 ms poll budget.
            self.launched = item_id
            self.launch_count = getattr(self,'launch_count',0)+1
            return self.snapshot

    backend = Backend(build_id=0xC0061000)
    controller = AgentController(backend)
    server = AgentServer(controller)
    server.start()
    session = RemoteDeviceSession(*server.address, expected_build_id=0xC0061000)
    try:
        assert session.connect().state is DeviceState.READY
        assert session.play_library_item("probe",library_kind=library_kind)["ok"] is True
        assert backend.launched == "probe"
        assert backend.launch_count == 1
        assert session._client.timeout == 0.25
        assert session.video_status()["ok"] is True
    finally:
        session.disconnect()
        server.close()
        controller.close()


@pytest.mark.parametrize('build_id,budget',[
    (0xC0060700,240.), (0xC0060800,240.), (0xC0060900,240.),
    (0xC0060C00,240.), (0xC0061000,240.)])
def test_video_lifecycle_budget_preserves_fast_status_on_all_profiles(monkeypatch,build_id,budget):
    from pynq_multimodal_game.studio import device as module
    class Client:
        def __init__(self,host,port,*,timeout,source_address=None):
            self.host,self.port,self.timeout,self.source_address=host,port,timeout,source_address
        def connect(self):
            if build_id == 0xC0060C00:
                return {"build_id": build_id, "profile": "C6I_VISION_VOLUME_V1",
                        "input_schema_version": 4, "supported_volume_schemas": []}
            return {'build_id':build_id,'profile':'C6I_VISION_BUTTON_V1'}
        def command(self,*args,**kwargs):return {'ok':True,'state':'active','timeout':self.timeout}
        def close(self):pass
    monkeypatch.setattr(module,'AgentClient',Client)
    session=RemoteDeviceSession('localhost',8765,expected_build_id=build_id)
    for action in (lambda:session.play_library_item('video',library_kind='video'),
                   session.start_video,session.pause_video,lambda:session.seek_video(0)):
        assert action()['timeout']==budget
    assert session.video_status()['timeout']==.25


def test_button_status_can_read_slow_completed_report_without_changing_poll_timeout():
    from dataclasses import replace
    from time import sleep

    class Backend(MockRuntimeBackend):
        @property
        def snapshot(self):
            return replace(super().snapshot, profile="C6I_VISION_BUTTON_V1")

    class SlowStatus(AgentController):
        def execute(self, request_id, command, **kwargs):
            assert command is AgentCommand.STATUS
            sleep(0.4)
            return super().execute(request_id, command, **kwargs)

    controller = SlowStatus(Backend(build_id=0xC0061000))
    server = AgentServer(controller)
    server.start()
    session = RemoteDeviceSession(*server.address, expected_build_id=0xC0061000)
    try:
        assert session.connect().state is DeviceState.READY
        assert session.video_status()["ok"] is True
        assert session._client.timeout == 0.25
    finally:
        session.disconnect()
        server.close()
        controller.close()


@pytest.mark.parametrize("slow_command", (AgentCommand.UPLOAD_COMMIT, AgentCommand.LIBRARY_INSTALL,
                                         AgentCommand.LIBRARY_LIST))
def test_button_deployment_waits_for_commit_and_install_once(tmp_path, slow_command):
    from dataclasses import replace
    from time import sleep
    from pynq_multimodal_game.agent.core import LibraryItemSnapshot

    class Backend(MockRuntimeBackend):
        installed = ()

        @property
        def snapshot(self):
            return replace(super().snapshot, profile="C6I_VISION_BUTTON_V1")

        def install_staged_library_item(self, item_id, display_name, library_kind):
            manifest = self._staged[0]
            item = LibraryItemSnapshot(item_id, display_name, library_kind, manifest.length, manifest.sha256)
            self.installed = (item,)
            return item

        def list_library_items(self, library_kind):
            return self.installed

    class SlowDeployment(AgentController):
        calls = []

        def execute(self, request_id, command, **kwargs):
            self.calls.append(command)
            if command is slow_command:
                sleep(0.4)
            return super().execute(request_id, command, **kwargs)

    project = GameProject.create(tmp_path / "project", game_id="slow-install", display_name="Slow Install")
    package = GamePackageBuilder().build(project.root, tmp_path / "slow.vvg", target_build_id=0xC0061000)
    controller = SlowDeployment(Backend(build_id=0xC0061000), upload_directory=tmp_path / "uploads")
    server = AgentServer(controller)
    server.start()
    session = RemoteDeviceSession(*server.address, expected_build_id=0xC0061000)
    try:
        assert session.connect().state is DeviceState.READY
        assert session.install_game(package.path)["library"]["sha256"] == package.sha256
        assert controller.calls.count(slow_command) == 1
        assert session.list_library("game")["library_items"][0]["sha256"] == package.sha256
        assert controller.calls.count(slow_command) == (2 if slow_command is AgentCommand.LIBRARY_LIST else 1)
        assert session._client.timeout == 0.25
    finally:
        session.disconnect()
        server.close()
        controller.close()


def test_voice_monitor_status_error_is_not_presented_as_fresh_snapshot():
    from types import SimpleNamespace
    from pynq_multimodal_game.studio.device import VoiceMonitorSession
    session = VoiceMonitorSession("localhost", 8765, expected_build_id=0xC0060900)
    session.client = SimpleNamespace(connect=lambda: {"build_id": 0xC0060900,
        "profile": "C6I_VISION_VOICE_S3", "voice_observation_schema": "voice-monitor-v1"},
        command=lambda *args: {"ok": False, "message": "STATUS rejected", "snapshot": {}})
    with pytest.raises(RuntimeError, match="STATUS rejected"):
        session.request()


def test_simulated_device_connect_disconnect_cycle() -> None:
    session = SimulatedDeviceSession()

    assert session.snapshot.state is DeviceState.DISCONNECTED
    assert session.snapshot.generation == 0

    ready = session.connect()
    assert ready.state is DeviceState.READY
    assert ready.build_id == 0xC0040700
    assert ready.generation == 2

    disconnected = session.disconnect()
    assert disconnected.state is DeviceState.DISCONNECTED
    assert disconnected.build_id is None
    assert disconnected.generation == 3


@pytest.mark.parametrize("fault", (None, "profile", "schema", "schemas", "bool_build"))
def test_volume_candidate_requires_paired_hello_even_on_status(monkeypatch, fault):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.studio import device as module
    client = MagicMock()
    hello = {"build_id": 0xC0060C00, "profile": "C6I_VISION_VOLUME_V1",
             "input_schema_version": 4, "supported_volume_schemas": []}
    if fault == "profile": hello["profile"] = "C6I_VISION"
    if fault == "schema": hello["input_schema_version"] = True
    if fault == "schemas": hello["supported_volume_schemas"] = "volume-signal-v1"
    if fault == "bool_build": hello["build_id"] = True
    client.connect.return_value = hello
    client.command.return_value = {"ok": True}
    monkeypatch.setattr(module, "AgentClient", MagicMock(return_value=client))
    session = RemoteDeviceSession("localhost", 8765, expected_build_id=0xC0060C00)
    if fault is None:
        assert session.connect().state is DeviceState.READY
        assert session.video_status()["ok"]
    else:
        assert session.connect().state is DeviceState.ERROR
        with pytest.raises(RuntimeError):
            session.video_status()
        client.command.assert_not_called()

@pytest.mark.parametrize("fault", (None, "stale", "missing", "error", "poller", "disabled", "lease"))
def test_fused_live_preflight_requires_fresh_healthy_source(monkeypatch, fault):
    from test_volume_monitor import fused_volume_fixture
    snapshot = fused_volume_fixture()
    volume = snapshot["volume"]
    if fault == "stale": volume["observation"]["cache_age_ms"] = 501
    if fault == "missing": volume["observation"] = None
    if fault == "error": volume["latch"]["error"] = "source fault"
    if fault == "poller": volume["poller_alive"] = False
    if fault == "disabled": volume["sampling_enabled"] = False
    if fault == "lease": volume["lease_retained"] = False
    session = RemoteDeviceSession("localhost", 8765, expected_build_id=0xC0060C00)
    monkeypatch.setattr(session, "video_status", lambda: {"ok": True, "snapshot": snapshot})
    if fault is None:
        assert session.require_volume_input()["snapshot"] is snapshot
    else:
        with pytest.raises(RuntimeError, match="not healthy"):
            session.require_volume_input()


def test_voice_monitor_real_tcp_is_read_only_and_disconnect_keeps_runtime():
    from dataclasses import replace
    from pynq_multimodal_game.agent.voice_backend import VoiceSupervisor
    from pynq_multimodal_game.studio.device import VoiceMonitorSession

    class Backend(MockRuntimeBackend):
        @property
        def snapshot(self):
            return replace(super().snapshot, profile="C6I_VISION_VOICE_S3", voice=VoiceSupervisor(lambda: None).observation())

    backend = Backend(build_id=0xC0060900)
    controller = AgentController(backend)
    server = AgentServer(controller)
    server.start()
    session = VoiceMonitorSession(*server.address, expected_build_id=0xC0060900)
    try:
        for _ in range(3):
            result = session.request()
            assert result["snapshot"]["voice"]["schema"] == "voice-monitor-v1"
        session.close()
        assert controller.snapshot.state.value == "idle" and controller.snapshot.vision is None
        assert session.request()["snapshot"]["build_id"] == 0xC0060900
        with pytest.raises(ValueError, match="explicit"):
            VoiceMonitorSession(*server.address, expected_build_id=0xC0060800)
    finally:
        session.close()
        server.close()
        controller.close()


@pytest.mark.parametrize("fault", ("profile", "build", "schema", "release", "samples", "pcm"))
def test_voice_monitor_rejects_malformed_identity_and_data(fault):
    from pynq_multimodal_game.agent.voice_backend import VoiceSupervisor
    from pynq_multimodal_game.voice_monitor import validate_voice_monitor
    snapshot = {"profile": "C6I_VISION_VOICE_S3", "build_id": 0xC0060900,
                "voice": VoiceSupervisor(lambda: None).observation()}
    if fault == "profile":
        snapshot["profile"] = "C6I_VISION"
    elif fault == "build":
        snapshot["build_id"] = 0xC0060800
    elif fault == "schema":
        snapshot["voice"]["schema"] = "invalid"
    elif fault == "release":
        snapshot["voice"]["release_ready"] = True
    elif fault == "samples":
        snapshot["voice"]["samples"] = 1
    else:
        snapshot["voice"]["pcm"] = {"samples": [0] * 241}
    with pytest.raises(ValueError):
        validate_voice_monitor(snapshot)


@pytest.mark.parametrize("shared", (False, True))
def test_vision_session_uses_explicit_profile_and_preserves_failure_receipt(shared):
    from types import SimpleNamespace
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import C6IVisionRuntimeBackend, VisionRuntimeBackend
    from pynq_multimodal_game.vision_input import VisionInputProvider
    from pynq_multimodal_game.studio.device import VisionAgentSession

    supervisor = MagicMock()
    supervisor.status.return_value = {"state": "STARTING", "owner_held": True,
                                      "cleanup_confirmed": False, "board_validated": False}
    if shared:
        supervisor.input_provider = VisionInputProvider()
        backend = C6IVisionRuntimeBackend(SimpleNamespace(build_id=0xC0060800), supervisor)
    else:
        backend = VisionRuntimeBackend(supervisor)
    controller = AgentController(backend)
    server = AgentServer(controller)
    server.start()
    session = VisionAgentSession(*server.address)
    try:
        result = session.request(AgentCommand.VISION_START)
        assert result["snapshot"]["vision"]["state"] == "STARTING"
        if shared:
            assert result["state"] == "idle" and result["snapshot"]["build_id"] == 0xC0060800
        session.close()
        supervisor.status.return_value = {"state": "FAULT", "owner_held": True,
                                          "cleanup_confirmed": False}
        supervisor.stop.side_effect = RuntimeError("DMA halt unconfirmed")
        result = session.request(AgentCommand.VISION_STOP)
        assert not result["ok"] and result["snapshot"]["vision"]["owner_held"]
        with pytest.raises(ValueError, match="Only vision"):
            session.request(AgentCommand.RUN)
    finally:
        session.close()
        server.close()
        controller.close()


def test_vision_session_rejects_gpu_before_start():
    from pynq_multimodal_game.studio.device import VisionAgentSession

    controller = AgentController(MockRuntimeBackend(build_id=0xC0060700))
    server = AgentServer(controller)
    server.start()
    session = VisionAgentSession(*server.address)
    try:
        with pytest.raises(RuntimeError, match="VISION_ONLY"):
            session.request(AgentCommand.VISION_START)
        assert controller.snapshot.state.value == "idle"
    finally:
        session.close()
        server.close()
        controller.close()


@pytest.mark.parametrize("fault", ("hello_build", "hello_profile", "receipt_build", "receipt_profile"))
def test_vision_session_rejects_mismatched_fusion_identity(fault):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.studio.device import VisionAgentSession

    session = VisionAgentSession("127.0.0.1", 1)
    session.client = MagicMock()
    session.client.connect.return_value = {
        "profile": ["C6I_VISION"] if fault == "hello_profile" else "C6I_VISION",
        "build_id": 0xC0060700 if fault == "hello_build" else 0xC0060800,
        "vision_commands": [command.value for command in session.COMMANDS]}
    session.client.command.return_value = {"ok": True, "snapshot": {
        "profile": "VISION_ONLY" if fault == "receipt_profile" else "C6I_VISION",
        "build_id": 0 if fault == "receipt_build" else 0xC0060800,
        "vision": {"state": "RUNNING", "owner_held": True}}}
    with pytest.raises(RuntimeError, match="profile|receipt"):
        session.request(AgentCommand.VISION_START)
    if fault in ("hello_build", "hello_profile"):
        session.client.command.assert_not_called()


def test_vision_cancel_during_handshake_does_not_send_start():
    from threading import Event
    from unittest.mock import MagicMock
    from pynq_multimodal_game.studio.device import VisionAgentSession

    session = VisionAgentSession("127.0.0.1", 1)
    client = MagicMock()
    session.client = client
    cancelled = Event()
    def connect():
        cancelled.set()
        return {"profile": "VISION_ONLY", "build_id": 0,
                "vision_commands": [command.value for command in session.COMMANDS]}
    client.connect.side_effect = connect
    with pytest.raises(RuntimeError, match="cancelled"):
        session.request(AgentCommand.VISION_START, cancelled=cancelled.is_set)
    client.command.assert_not_called()


def test_vision_session_rejects_malformed_state():
    from unittest.mock import MagicMock
    from pynq_multimodal_game.studio.device import VisionAgentSession

    session = VisionAgentSession("127.0.0.1", 1)
    session.client = MagicMock()
    session.client.connect.return_value = {"profile": "VISION_ONLY", "build_id": 0,
        "vision_commands": [command.value for command in session.COMMANDS]}
    session.client.command.return_value = {"ok": True, "snapshot": {"profile": "VISION_ONLY",
        "vision": {"state": ["RUNNING"], "owner_held": "false"}}}
    with pytest.raises(RuntimeError, match="Invalid vision lifecycle state"):
        session.request(AgentCommand.VISION_STATUS)


@pytest.mark.parametrize("state", ("RUNNING", "FAULT"))
@pytest.mark.parametrize("build_id", (0xC0060800, 0xC0060900))
def test_live_vision_start_waits_for_ready_and_retains_failure(monkeypatch, state, build_id):
    from threading import Event
    from unittest.mock import MagicMock
    from pynq_multimodal_game.studio import device as module

    vision = MagicMock()
    identity = {"profile": "C6I_VISION" if build_id == 0xC0060800 else "C6I_VISION_VOICE_S3", "build_id": build_id}
    capabilities = {"schema": "local-game-vision-v1", "mode": "games", "games": ["game1", "game2", "game3"]}
    vision.request.side_effect = [
        {"ok": True, "snapshot": {**identity, "vision": {"state": "IDLE", "input_capabilities": capabilities}}},
        {"ok": True, "snapshot": {**identity, "vision": {"state": "STARTING", "input_capabilities": capabilities}}},
        {"ok": state == "RUNNING", "snapshot": {**identity, "vision": {"state": state, "input_capabilities": capabilities}}},
    ]
    monkeypatch.setattr(module, "VisionAgentSession", MagicMock(return_value=vision))
    session = RemoteDeviceSession("127.0.0.1", 8765, expected_build_id=build_id)
    if state == "RUNNING":
        assert session.start_shared_vision(stop_event=Event())["snapshot"]["vision"]["state"] == state
    else:
        with pytest.raises(RuntimeError, match="Vision startup failed"):
            session.start_shared_vision(stop_event=Event())
    assert [call.args[0] for call in vision.request.call_args_list] == [AgentCommand.VISION_STATUS, AgentCommand.VISION_START, AgentCommand.VISION_STATUS]
    vision.close.assert_called_once()


@pytest.mark.parametrize("fault", (None, "default", "hello_build", "hello_profile", "receipt_build", "receipt_profile"))
def test_voice_candidate_vision_requires_explicit_paired_identity(fault):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.studio.device import VisionAgentSession
    session = VisionAgentSession("127.0.0.1", 1, expected_build_id=None if fault == "default" else 0xC0060900)
    session.client = MagicMock()
    profile = "C6I_VISION_VOICE_S3"
    session.client.connect.return_value = {"profile": "C6I_VISION" if fault == "hello_profile" else profile,
        "build_id": 0xC0060800 if fault == "hello_build" else 0xC0060900,
        "vision_commands": [command.value for command in session.COMMANDS]}
    session.client.command.return_value = {"ok": True, "snapshot": {
        "profile": "C6I_VISION" if fault == "receipt_profile" else profile,
        "build_id": 0xC0060800 if fault == "receipt_build" else 0xC0060900,
        "vision": {"state": "RUNNING", "owner_held": True}}}
    if fault is None:
        assert session.request(AgentCommand.VISION_STATUS)["ok"] is True
    else:
        with pytest.raises(RuntimeError, match="profile|receipt"):
            session.request(AgentCommand.VISION_START)
        if fault in ("default", "hello_build", "hello_profile"):
            session.client.command.assert_not_called()


@pytest.mark.parametrize("capabilities", [
    None, {}, {"schema": "local-game-vision-v1", "mode": "legacy_horizontal", "games": []},
    {"schema": "unknown", "mode": "games", "games": ["game2"]},
    {"schema": "local-game-vision-v1", "mode": "games", "games": "game2"},
    {"schema": "local-game-vision-v1", "mode": "games", "games": [True]},
    {"schema": "local-game-vision-v1", "mode": "games", "games": ["game1"]},
])
def test_live_vision_rejects_missing_legacy_or_wrong_game_before_start(monkeypatch, capabilities):
    from threading import Event
    from unittest.mock import MagicMock
    from pynq_multimodal_game.studio import device as module

    vision = MagicMock()
    vision.request.return_value = {"ok": True, "snapshot": {"profile": "C6I_VISION", "build_id": 0xC0060800,
        "vision": {"state": "IDLE", "input_capabilities": capabilities}}}
    monkeypatch.setattr(module, "VisionAgentSession", MagicMock(return_value=vision))
    session = RemoteDeviceSession("127.0.0.1", 8765, expected_build_id=0xC0060800)
    with pytest.raises(RuntimeError, match="native game vision mode"):
        session.start_shared_vision(stop_event=Event(), game_id="game2")
    assert [call.args[0] for call in vision.request.call_args_list] == [AgentCommand.VISION_STATUS]
    vision.close.assert_called_once()


@pytest.mark.parametrize("version", [1, 2])
def test_remote_gesture_injection_negotiates_input_schema(version: int) -> None:
    class InputBackend(MockRuntimeBackend):
        input_schema_version = version

        def inject_test_input(self, **values):
            self.received = values
            return self.snapshot

    backend = InputBackend(build_id=0xC0060700)
    server = AgentServer(AgentController(backend))
    server.start()
    session = RemoteDeviceSession(*server.address)
    try:
        session.connect()
        if version == 1:
            with pytest.raises(RuntimeError, match="schema 2"):
                session.inject_game_input(x=280, y=90, gesture="scissors")
        else:
            assert session.inject_game_input(x=280, y=90, gesture="scissors")["ok"]
            assert backend.received["gesture"] == "scissors"
    finally:
        session.disconnect()
        server.close()


def test_simulated_device_requires_an_error_message() -> None:
    session = SimulatedDeviceSession()

    with pytest.raises(ValueError, match="must not be empty"):
        session.fail(" ")

    failed = session.fail("Simulated transport failure")
    assert failed.state is DeviceState.ERROR
    assert failed.message == "Simulated transport failure"


def test_remote_device_connects_and_checks_build_id() -> None:
    server = AgentServer(AgentController(MockRuntimeBackend(build_id=0xC0060700)))
    server.start()
    try:
        session = RemoteDeviceSession(*server.address)
        ready = session.connect()
        assert ready.state is DeviceState.READY
        assert ready.build_id == 0xC0060700
        assert ready.protocol_version == (1, 0)
        assert session.disconnect().state is DeviceState.DISCONNECTED

        mismatch = RemoteDeviceSession(*server.address, expected_build_id=0xC0040700)
        failed = mismatch.connect()
        assert failed.state is DeviceState.ERROR
        assert "BUILD_ID" in failed.message
    finally:
        server.close()


def test_remote_device_uploads_s2v_on_independent_connection(tmp_path: Path) -> None:
    backend = MockRuntimeBackend(build_id=0xC0060700)
    controller = AgentController(backend, upload_directory=tmp_path / "uploads")
    server = AgentServer(controller)
    server.start()
    session = RemoteDeviceSession(*server.address)
    video = tmp_path / "fixture.s2v"
    encode_rgb_frames(
        [bytes((24, 48, 72)) * (S2V1_WIDTH * S2V1_HEIGHT)],
        video,
    )
    progress: list[tuple[int, int]] = []
    try:
        assert session.connect().state is DeviceState.READY
        result = session.upload_s2v(
            video,
            progress=lambda received, total: progress.append((received, total)),
        )

        assert result["state"] == "staged"
        assert result["transfer"]["state"] == "staged"
        assert progress[-1][0] == progress[-1][1] == video.stat().st_size
        assert session.snapshot.state is DeviceState.READY
    finally:
        session.disconnect()
        server.close()
        controller.close()


def test_remote_device_uploads_valid_vvg_on_independent_connection(
    tmp_path: Path,
) -> None:
    backend = MockRuntimeBackend(build_id=0xC0060700)
    controller = AgentController(backend, upload_directory=tmp_path / "uploads")
    server = AgentServer(controller)
    server.start()
    session = RemoteDeviceSession(*server.address)
    project = GameProject.create(
        tmp_path / "project", game_id="remote-game", display_name="Remote Game"
    )
    package = GamePackageBuilder().build(project.root, tmp_path / "remote.vvg")
    try:
        assert session.connect().state is DeviceState.READY
        result = session.upload_game(package.path)

        assert result["state"] == "staged"
        assert result["transfer"]["artifact_kind"] == "game.vvg"
        assert backend.snapshot.staged_sha256 == package.sha256
    finally:
        session.disconnect()
        server.close()
        controller.close()


def test_remote_device_verifies_game_install_by_listing_library(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    project = GameProject.create(
        tmp_path / "project", game_id="verified-game", display_name="Verified Game"
    )
    package = GamePackageBuilder().build(project.root, tmp_path / "verified.vvg")
    session = RemoteDeviceSession("127.0.0.1", 8765)
    monkeypatch.setattr(session, "upload_game", lambda *_args, **_kwargs: {"state": "staged"})
    monkeypatch.setattr(
        session,
        "_with_video_client",
        lambda action, **_kwargs: action(object()),
    )
    monkeypatch.setattr(
        session,
        "_library_command",
        lambda _client, _command, **_kwargs: {"ok": True, "snapshot": {}},
    )
    monkeypatch.setattr(
        session,
        "list_library",
        lambda _kind=None: {
            "library_items": [
                {
                    "item_id": "verified-game",
                    "sha256": package.sha256,
                    "length": package.length,
                }
            ]
        },
    )

    result = session.install_game(package.path)

    assert result["library"]["item_id"] == "verified-game"


def test_remote_device_rejects_install_missing_from_library(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    project = GameProject.create(
        tmp_path / "project", game_id="missing-game", display_name="Missing Game"
    )
    package = GamePackageBuilder().build(project.root, tmp_path / "missing.vvg")
    session = RemoteDeviceSession("127.0.0.1", 8765)
    monkeypatch.setattr(session, "upload_game", lambda *_args, **_kwargs: {})
    monkeypatch.setattr(session, "_with_video_client", lambda action, **_kwargs: action(object()))
    monkeypatch.setattr(
        session,
        "_library_command",
        lambda _client, _command, **_kwargs: {"ok": True, "snapshot": {}},
    )
    monkeypatch.setattr(
        session, "list_library", lambda _kind=None: {"library_items": []}
    )

    with pytest.raises(RuntimeError, match="missing from the PYNQ library"):
        session.install_game(package.path)


def test_remote_device_controls_staged_video_on_independent_connection(tmp_path: Path) -> None:
    backend = MockRuntimeBackend(build_id=0xC0060700)
    controller = AgentController(backend, upload_directory=tmp_path / "uploads")
    server = AgentServer(controller)
    server.start()
    session = RemoteDeviceSession(*server.address)
    video = tmp_path / "fixture.s2v"
    encode_rgb_frames(
        [bytes((24, 48, 72)) * (S2V1_WIDTH * S2V1_HEIGHT)],
        video,
    )
    try:
        assert session.connect().state is DeviceState.READY
        assert session.upload_s2v(video)["state"] == "staged"
        assert session.start_video()["state"] == "running"
        assert session.pause_video()["state"] == "paused"
        assert session.seek_video(0)["state"] == "paused"
        assert session.start_video()["state"] == "running"
        assert session.stop_video()["state"] == "active"

        repeated = session.upload_s2v(video)
        assert repeated["state"] == "staged"
        assert repeated["replayed"] is False
        assert session.start_video()["state"] == "running"
    finally:
        session.disconnect()
        server.close()
        controller.close()


def test_remote_video_request_ids_are_unique_across_sessions() -> None:
    class RecordingClient:
        def __init__(self) -> None:
            self.request_ids: list[str] = []

        def command(self, request_id, command, *, frame_index=None):
            self.request_ids.append(request_id)
            return {"ok": True}

    first = RemoteDeviceSession("127.0.0.1", 9000)
    second = RemoteDeviceSession("127.0.0.1", 9000)
    first_client = RecordingClient()
    second_client = RecordingClient()

    first._video_command(first_client, AgentCommand.STATUS)
    second._video_command(second_client, AgentCommand.STATUS)

    assert first_client.request_ids[0] != second_client.request_ids[0]
