from pynq_multimodal_game.agent import (
    AgentClient,
    AgentCommand,
    AgentController,
    AgentServer,
    ArtifactManifest,
    LatestDataBuffer,
    MockRuntimeBackend,
)
from pynq_multimodal_game.protocol import MessageType, ProtocolFrame
import hashlib
from pathlib import Path
import socket
import threading
import time

from pynq_multimodal_game.agent.cli import _publish_fixtures, build_parser
from pynq_multimodal_game.agent.video_runtime import C6IVideoRuntimeBackend
from pynq_multimodal_game.video_codec import S2V1_HEIGHT, S2V1_WIDTH, encode_rgb_frames


BUILD_ID = 0xC0060700


def test_sdk_action_case_capabilities_and_legacy_refusal(tmp_path, monkeypatch):
    import pytest
    from pynq_multimodal_game.game_package import GamePackageBuilder
    controller = AgentController(MockRuntimeBackend(build_id=BUILD_ID))
    server = AgentServer(controller)
    server.start()
    client = AgentClient(*server.address)
    try:
        hello = client.connect()
        assert hello["game_sdk"] == {"major": 1, "minor": 3}
        assert "supported_volume_schemas" not in hello and not client.supported_volume_schemas
        assert hello["supported_action_schemas"] == []
        assert hello["test_case_schema_versions"] == [1]
        with pytest.raises(RuntimeError, match="test case schema"):
            client.command("case3", AgentCommand.LIBRARY_RUN, test_case_json='{"schema_version":3}')
    finally:
        client.close()
        server.close()
        controller.close()
    root = Path(__file__).resolve().parents[1]
    package = GamePackageBuilder().build(root / "candidates/game1-voice-s2", tmp_path / "candidate.vvg")
    manifest = ArtifactManifest.for_payload(package.path.read_bytes(), artifact_kind="game.vvg",
                                            target_build_id=0xC0060800, abi_major=1, abi_minor=0)
    client = AgentClient("localhost", 1)
    with pytest.raises(RuntimeError, match="candidate SDK"):
        client.upload_file(package.path, manifest, upload_id="refused-before-socket")


def test_volume_sdk13_contract_negotiation_before_upload(tmp_path):
    import pytest
    from pynq_multimodal_game.agent.vision_backend import C6IVolumeRuntimeBackend, SharedVisionSupervisor
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    from pynq_multimodal_game.game_project import GameProject
    from pynq_multimodal_game.game_package import GamePackageBuilder
    from types import SimpleNamespace
    backend = C6IVolumeRuntimeBackend(SimpleNamespace(build_id=0xC0060C00),
        SharedVisionSupervisor(lambda _run: None, GameVisionInputProvider()), volume_factory=lambda _session: None)
    controller = AgentController(backend)
    server = AgentServer(controller)
    server.start()
    client = AgentClient(*server.address)
    try:
        hello = client.connect()
        assert hello["profile"] == "C6I_VISION_VOLUME_V1"
        assert hello["input_schema_version"] == 4 and hello["test_case_schema_versions"] == [1, 2, 3, 4]
        assert hello["supported_volume_schemas"] == ["volume-signal-v1"]
        assert hello["vision_commands"] == ["vision_start", "vision_status", "vision_stop"]
        assert client.supported_volume_schemas == ("volume-signal-v1",)
        status = client.command("volume-vision-status", AgentCommand.VISION_STATUS)
        assert status["ok"], status
    finally:
        client.close()
        server.close()
        controller.close()
    project = GameProject.create(tmp_path / "volume", game_id="volume", display_name="Volume")
    text = project.manifest_path.read_text(encoding="utf-8").replace("sdk_minor = 1", "sdk_minor = 3")
    project.manifest_path.write_text(text + '\n[volume]\nschema = "volume-signal-v1"\nvision_mapping = "game3"\n', encoding="utf-8")
    package = GamePackageBuilder().build(project.root, tmp_path / "volume.vvg", target_build_id=0xC0060C00)
    artifact = ArtifactManifest.for_path(package.path, artifact_kind="game.vvg", target_build_id=0xC0060C00, abi_major=1, abi_minor=0)
    for minor, input_schema, schemas in ((2, 4, ("volume-signal-v1",)), (3, 2, ("volume-signal-v1",)), (3, 4, ())):
        client = AgentClient("localhost", 1)
        client.game_sdk = {"major": 1, "minor": minor}
        client.input_schema_version, client.supported_volume_schemas = input_schema, schemas
        with pytest.raises(RuntimeError, match="volume contract"):
            client.upload_file(package.path, artifact, upload_id="refused-volume-before-socket")


def test_vision_profile_and_commands_over_tcp():
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import VisionRuntimeBackend

    supervisor = MagicMock()
    supervisor.status.return_value = {"state": "STARTING", "session_id": "guard-a",
                                      "owner_held": True, "board_validated": False}
    backend = VisionRuntimeBackend(supervisor)
    controller = AgentController(backend)
    server = AgentServer(controller)
    server.start()
    client = AgentClient(*server.address)
    try:
        hello = client.connect()
        assert hello["profile"] == "VISION_ONLY" and hello["build_id"] == 0
        assert hello["vision_commands"] == ["vision_start", "vision_status", "vision_stop"]
        assert client.command("start-v", AgentCommand.VISION_START)["state"] == "starting"
        client.close()
        client.connect()
        assert client.command("start-v", AgentCommand.VISION_START)["replayed"]
        assert supervisor.start.call_count == 1
        assert not client.command("game-v", AgentCommand.RUN)["ok"]
        supervisor.status.return_value = {"state": "STOPPING", "session_id": "guard-a",
                                          "owner_held": True}
        def stop():
            supervisor.status.return_value = {"state": "IDLE", "owner_held": False,
                                              "cleanup_confirmed": True}
        supervisor.stop.side_effect = stop
        backend.poll_cleanup()
        assert client.command("status-v", AgentCommand.VISION_STATUS)["state"] == "idle"
        assert supervisor.stop.call_count == 1
    finally:
        client.close()
        server.close()
        controller.close()


def test_vision_cleanup_poll_retains_failed_owner_without_retry_storm():
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import VisionRuntimeBackend

    supervisor = MagicMock()
    supervisor.status.return_value = {"state": "FAULT", "session_id": "guard-fault", "owner_held": True}
    supervisor.stop.side_effect = RuntimeError("DMA halt unconfirmed")
    backend = VisionRuntimeBackend(supervisor)
    backend.poll_cleanup()
    backend.poll_cleanup()
    assert supervisor.stop.call_count == 1
    assert backend.snapshot.vision["owner_held"]


def test_agent_client_binds_source_address(monkeypatch) -> None:
    captured: dict[str, object] = {}

    class FakeSocket:
        def settimeout(self, timeout: float) -> None:
            captured["timeout"] = timeout

        def shutdown(self, _how: int) -> None:
            pass

        def close(self) -> None:
            pass

    def create_connection(address, *, timeout, source_address):  # type: ignore[no-untyped-def]
        captured["address"] = address
        captured["source_address"] = source_address
        return FakeSocket()

    monkeypatch.setattr(socket, "create_connection", create_connection)
    client = AgentClient(
        "192.168.2.99",
        8765,
        timeout=5.0,
        source_address="192.168.2.1",
    )
    monkeypatch.setattr(
        client,
        "_exchange",
        lambda *_args: ProtocolFrame(MessageType.HELLO_ACK, b'{"build_id":3221620480}'),
    )

    assert client.connect() == {"build_id": BUILD_ID}
    assert captured == {
        "address": ("192.168.2.99", 8765),
        "source_address": ("192.168.2.1", 0),
        "timeout": 5.0,
    }


def test_latest_data_buffer_is_bounded_and_replaces_same_source() -> None:
    buffer = LatestDataBuffer(capacity=2)
    buffer.put(ProtocolFrame(MessageType.DATA, b"old", source_id=1))
    buffer.put(ProtocolFrame(MessageType.DATA, b"new", source_id=1))
    buffer.put(ProtocolFrame(MessageType.DATA, b"other", source_id=2))

    assert buffer.dropped == 1
    assert buffer.get().payload == b"new"
    assert buffer.get().payload == b"other"
    buffer.close()
    assert buffer.get() is None


def test_localhost_agent_command_reconnect_and_subscription() -> None:
    controller = AgentController(MockRuntimeBackend(build_id=BUILD_ID))
    server = AgentServer(controller)
    server.start()
    client = AgentClient(*server.address)
    try:
        hello = client.connect()
        assert hello["build_id"] == BUILD_ID
        payload = b"opaque artifact"
        manifest = ArtifactManifest.for_payload(
            payload,
            artifact_kind="fixture.opaque",
            target_build_id=BUILD_ID,
            abi_major=1,
            abi_minor=0,
        )
        staged = client.command("stage-1", AgentCommand.STAGE, manifest=manifest, payload=payload)
        assert staged["ok"] is True
        assert staged["state"] == "staged"
        client.close()

        client.connect()
        replayed = client.command(
            "stage-1",
            AgentCommand.STAGE,
            manifest=manifest,
            payload=payload,
        )
        assert replayed["replayed"] is True
        assert replayed["state"] == "staged"
        conflicting = client.command("stage-1", AgentCommand.ACTIVATE)
        assert conflicting["ok"] is False
        assert "different request" in conflicting["message"]
        assert client.command("activate-1", AgentCommand.ACTIVATE)["state"] == "active"
        assert client.subscribe([7]) == {"ok": True, "source_ids": [7]}

        server.publish_data(b"ignored", source_id=8)
        server.publish_data(b"accepted", source_id=7, channel_id=3, timestamp_ns=42)
        frame = client.receive()
        assert frame.message_type is MessageType.DATA
        assert frame.payload == b"accepted"
        assert frame.source_id == 7
        assert frame.channel_id == 3
        assert frame.timestamp_ns == 42

        server.publish_data(b"before-command", source_id=7)
        status = client.command("status-1", AgentCommand.STATUS)
        assert status["ok"] is True
        assert client.receive().payload == b"before-command"
    finally:
        client.close()
        server.close()


def test_agent_cli_fixture_mode_is_explicit() -> None:
    defaults = build_parser().parse_args([])
    enabled = build_parser().parse_args(["--fixtures", "--fixture-rate", "20"])

    assert defaults.fixtures is False
    assert enabled.fixtures is True
    assert enabled.fixture_rate == 20.0


def test_agent_client_encodes_game_test_and_input_fields(monkeypatch) -> None:
    client = AgentClient("127.0.0.1", 8765)
    captured = {}

    def exchange(message_type, body):  # type: ignore[no-untyped-def]
        captured.update(body)
        return ProtocolFrame(message_type, b'{"ok":true}', sequence=1)

    monkeypatch.setattr(client, "_exchange", exchange)

    result = client.command(
        "game-command",
        AgentCommand.LIBRARY_RUN,
        test_case_json='{"test_id":"golden"}',
        input_id="manual-input-1",
    )

    assert result == {"ok": True}
    assert captured["test_case_json"] == '{"test_id":"golden"}'
    assert captured["input_id"] == "manual-input-1"


def test_agent_fixture_publisher_emits_vision_and_audio_sources() -> None:
    server = AgentServer(AgentController(MockRuntimeBackend(build_id=BUILD_ID)))
    server.start()
    client = AgentClient(*server.address)
    stopped = threading.Event()
    publisher = threading.Thread(target=_publish_fixtures, args=(server, stopped, 100.0))
    try:
        client.connect()
        client.subscribe([1, 2])
        publisher.start()
        frames = [client.receive(), client.receive()]
        assert {frame.source_id for frame in frames} == {1, 2}
    finally:
        stopped.set()
        if publisher.ident is not None:
            publisher.join(timeout=1.0)
        client.close()
        server.close()


def test_localhost_chunked_upload_resumes_after_reconnect(tmp_path: Path) -> None:
    backend = MockRuntimeBackend(build_id=BUILD_ID)
    controller = AgentController(backend, upload_directory=tmp_path / "uploads")
    server = AgentServer(controller)
    server.start()
    client = AgentClient(*server.address)
    payload = b"0123456789abcdef" * 160_000
    artifact = tmp_path / "video.s2v.fixture"
    artifact.write_bytes(payload)
    manifest = ArtifactManifest.for_path(
        artifact,
        artifact_kind="fixture.opaque",
        target_build_id=BUILD_ID,
        abi_major=1,
        abi_minor=0,
    )
    prefix = payload[:600_003]
    try:
        client.connect()
        assert client.command(
            "resume-begin",
            AgentCommand.UPLOAD_BEGIN,
            upload_id="resume-network",
            manifest=manifest,
        )["ok"]
        first = client.command(
            "resume-first",
            AgentCommand.UPLOAD_CHUNK,
            upload_id="resume-network",
            offset=0,
            chunk_sha256=hashlib.sha256(prefix).hexdigest(),
            payload=prefix,
        )
        assert first["transfer"]["received_length"] == len(prefix)
        client.close()

        client.connect()
        status = client.command(
            "resume-status",
            AgentCommand.UPLOAD_STATUS,
            upload_id="resume-network",
        )
        assert status["transfer"]["received_length"] == len(prefix)
        committed = client.upload_file(
            artifact,
            manifest,
            upload_id="resume-network",
            chunk_size=512 * 1024,
        )

        assert committed["state"] == "staged"
        assert committed["transfer"]["state"] == "staged"
        assert controller.snapshot.staged_sha256 == manifest.sha256
    finally:
        client.close()
        server.close()
        controller.close()


def test_localhost_c6i_video_runtime_upload_activate_run_and_stop(tmp_path: Path) -> None:
    class Session:
        build_id = BUILD_ID

    class Sink:
        def __init__(self, presented: threading.Event) -> None:
            self.presented = presented

        def upload_tilemap(self, _packet: bytes) -> None:
            pass

        def upload_palette(self, _packet: bytes) -> None:
            pass

        def upload_asset(self, _packet: bytes) -> None:
            pass

        def submit_scene(self, _packet: bytes) -> None:
            self.presented.set()

        def close(self) -> None:
            pass

    video = tmp_path / "fixture.s2v"
    rgb = bytes((16, 32, 48)) * (S2V1_WIDTH * S2V1_HEIGHT)
    encode_rgb_frames([rgb], video)
    manifest = ArtifactManifest.for_path(
        video,
        artifact_kind="video.s2v",
        target_build_id=BUILD_ID,
        abi_major=1,
        abi_minor=0,
    )
    presented = threading.Event()
    runtime = C6IVideoRuntimeBackend(
        Session(),  # type: ignore[arg-type]
        timeout_seconds=0.2,
        sink_factory=lambda _session, _timeout: Sink(presented),
    )
    controller = AgentController(runtime, upload_directory=tmp_path / "uploads")
    server = AgentServer(controller)
    server.start()
    client = AgentClient(*server.address)
    try:
        client.connect()
        staged = client.upload_file(video, manifest, upload_id="tcp-video")
        assert staged["state"] == "staged"
        assert client.command("activate", AgentCommand.ACTIVATE)["state"] == "active"
        assert client.command("run", AgentCommand.RUN)["state"] == "running"
        assert presented.wait(1.0)
        status = client.command("status", AgentCommand.STATUS)
        assert status["snapshot"]["frame_count"] == 1
        assert status["snapshot"]["frame_index"] == 0
        assert status["snapshot"]["presented_frames"] >= 1
        assert client.command("stop", AgentCommand.STOP)["state"] == "idle"
    finally:
        client.close()
        runtime.close()
        server.close()
        controller.close()