from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
import hashlib
import itertools
import threading
from time import monotonic
from pathlib import Path
from typing import Any, Callable, Protocol
import uuid

from ..agent import AgentClient, AgentCommand, ArtifactManifest
from ..game_package import validate_game_package
from ..protocol import ProtocolFrame


def video_library_identity(path: Path, display_name: str | None = None) -> tuple[str, str]:
    """Stable IDs distinguish both content and explicitly supplied Unicode titles."""
    digest = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    title = (display_name if display_name is not None else Path(path).stem).strip()[:80] or "Video"
    stem = "".join(c if c.isalnum() else "-" for c in title.lower() if c.isascii()).strip("-")
    if display_name is not None:
        stem = f"{stem[:30] or 'video'}-{hashlib.sha256(title.encode('utf-8')).hexdigest()[:8]}"
    else:
        stem = stem[:48] or "video"
    return f"{stem}-{digest.hexdigest()[:8]}", title


def _require_hello(hello: dict[str, Any], expected_build_id: int) -> None:
    if type(hello.get("build_id")) is not int or hello["build_id"] != expected_build_id:
        raise RuntimeError("Agent BUILD_ID does not match expected runtime")
    if expected_build_id == 0xC0061000 and hello.get("profile") != "C6I_VISION_BUTTON_V1":
        raise RuntimeError("Button candidate requires C6I_VISION_BUTTON_V1 profile")
    if expected_build_id == 0xC0060C00:
        schemas = hello.get("supported_volume_schemas")
        if (hello.get("profile") != "C6I_VISION_VOLUME_V1"
                or type(hello.get("input_schema_version")) is not int or hello["input_schema_version"] != 4
                or type(schemas) is not list or schemas not in ([], ["volume-signal-v1"])):
            raise RuntimeError("C0C requires paired profile, schema4 and explicit volume capabilities")


class DeviceState(str, Enum):
    DISCONNECTED = "disconnected"
    CONNECTING = "connecting"
    READY = "ready"
    ERROR = "error"


@dataclass(frozen=True)
class DeviceSnapshot:
    state: DeviceState
    name: str
    build_id: int | None
    message: str
    generation: int
    protocol_version: tuple[int, int] | None = None


class DeviceSession(Protocol):
    @property
    def snapshot(self) -> DeviceSnapshot: ...

    def connect(self) -> DeviceSnapshot: ...

    def disconnect(self) -> DeviceSnapshot: ...


class SimulatedDeviceSession:
    def __init__(self, name: str = "C4M7 Simulator") -> None:
        self._name = name
        self._generation = 0
        self._snapshot = DeviceSnapshot(
            state=DeviceState.DISCONNECTED,
            name=name,
            build_id=None,
            message="Simulator is offline",
            generation=self._generation,
        )

    @property
    def snapshot(self) -> DeviceSnapshot:
        return self._snapshot

    def connect(self) -> DeviceSnapshot:
        self._set_state(DeviceState.CONNECTING, None, "Opening simulator")
        return self._set_state(
            DeviceState.READY,
            0xC0040700,
            "Frozen C4M7 capability profile loaded",
        )

    def disconnect(self) -> DeviceSnapshot:
        return self._set_state(
            DeviceState.DISCONNECTED,
            None,
            "Simulator is offline",
        )

    def fail(self, message: str) -> DeviceSnapshot:
        if not message.strip():
            raise ValueError("device error message must not be empty")
        return self._set_state(DeviceState.ERROR, None, message)

    def _set_state(
        self,
        state: DeviceState,
        build_id: int | None,
        message: str,
    ) -> DeviceSnapshot:
        self._generation += 1
        self._snapshot = DeviceSnapshot(
            state=state,
            name=self._name,
            build_id=build_id,
            message=message,
            generation=self._generation,
        )
        return self._snapshot


class RemoteDeviceSession:
    def __init__(
        self,
        host: str,
        port: int,
        *,
        expected_build_id: int = 0xC0060700,
        source_ids: tuple[int, ...] | None = None,
        timeout: float = 0.25,
        source_address: str | None = None,
    ) -> None:
        self._name = f"PYNQ Agent {host}:{port}"
        self._expected_build_id = expected_build_id
        # The button-only profile has no protocol image/audio return source.
        # Its optional MJPEG preview is opened separately by Studio's Play UI.
        self._source_ids = (() if expected_build_id == 0xC0061000 else (1, 2)) if source_ids is None else source_ids
        self._client = AgentClient(
            host,
            port,
            timeout=timeout,
            source_address=source_address,
        )
        self._upload_request_namespace = uuid.uuid4().hex
        self._upload_request_sequence = itertools.count(1)
        self._video_request_namespace = uuid.uuid4().hex
        self._video_request_sequence = itertools.count(1)
        self._generation = 0
        self._snapshot = DeviceSnapshot(
            DeviceState.DISCONNECTED,
            self._name,
            None,
            "Agent is offline",
            self._generation,
        )

    @property
    def snapshot(self) -> DeviceSnapshot:
        return self._snapshot

    @property
    def expected_build_id(self) -> int:
        return self._expected_build_id

    @property
    def connection_settings(self) -> tuple[str, int, str | None, int]:
        return (self._client.host, self._client.port,
                self._client.source_address, self._expected_build_id)

    def connect(self) -> DeviceSnapshot:
        self._set_state(DeviceState.CONNECTING, None, "Connecting to PYNQ Agent")
        try:
            hello = self._client.connect()
            build_id = hello.get("build_id")
            if not isinstance(build_id, int):
                raise RuntimeError("Agent HELLO is missing an integer BUILD_ID")
            if build_id != self._expected_build_id:
                raise RuntimeError(
                    f"Agent BUILD_ID 0x{build_id:08X} does not match expected "
                    f"0x{self._expected_build_id:08X}"
                )
            _require_hello(hello, self._expected_build_id)
            if build_id == 0xC0060900 and (hello.get("profile") != "C6I_VISION_VOICE_S3" or hello.get("voice_observation_schema") != "voice-monitor-v1"):
                raise RuntimeError("900 candidate requires paired fusion profile and voice observation capability")
            self._client.subscribe(list(self._source_ids))
        except (ConnectionError, OSError, RuntimeError, ValueError) as error:
            self._client.close()
            return self._set_state(DeviceState.ERROR, None, str(error))
        return self._set_state(
            DeviceState.READY,
            build_id,
            "PYNQ Agent connected",
            protocol_version=(1, 0),
        )

    def disconnect(self) -> DeviceSnapshot:
        self._client.close()
        return self._set_state(DeviceState.DISCONNECTED, None, "Agent is offline")

    def receive(self) -> ProtocolFrame:
        return self._client.receive()

    def upload_s2v(
        self,
        path: Path,
        *,
        progress: Callable[[int, int], None] | None = None,
    ) -> dict[str, Any]:
        manifest = ArtifactManifest.for_path(
            path,
            artifact_kind="video.s2v",
            target_build_id=self._expected_build_id,
            abi_major=1,
            abi_minor=0,
        )
        return self._upload_artifact(path, manifest, progress=progress)

    def upload_game(
        self,
        path: Path,
        *,
        progress: Callable[[int, int], None] | None = None,
    ) -> dict[str, Any]:
        package = validate_game_package(path)
        if package.manifest.target_build_id != self._expected_build_id:
            raise ValueError("game package BUILD_ID does not match the target device")
        manifest = ArtifactManifest.for_path(
            path,
            artifact_kind="game.vvg",
            target_build_id=self._expected_build_id,
            abi_major=package.manifest.abi_major,
            abi_minor=package.manifest.abi_minor,
        )
        return self._upload_artifact(path, manifest, progress=progress,
                         require_volume=package.manifest.volume_inputs is not None)

    def install_game(
        self,
        path: Path,
        *,
        progress: Callable[[int, int], None] | None = None,
    ) -> dict[str, Any]:
        package = validate_game_package(path)
        upload = self.upload_game(path, progress=progress)
        install = self._with_video_client(
            lambda client: self._library_command(
                client,
                AgentCommand.LIBRARY_INSTALL,
                item_id=package.manifest.game_id,
                display_name=package.manifest.display_name,
                library_kind="game",
            ),
            timeout=self._deployment_timeout,
        )
        listing = self.list_library("game")
        items = listing.get("library_items")
        if not isinstance(items, list):
            raise RuntimeError("Agent library list did not return game items")
        installed = next(
            (
                item
                for item in items
                if isinstance(item, dict) and item.get("item_id") == package.manifest.game_id
            ),
            None,
        )
        if installed is None:
            raise RuntimeError("installed game is missing from the PYNQ library")
        if installed.get("sha256") != package.sha256 or installed.get("length") != package.length:
            raise RuntimeError("installed game package identity does not match the local VVG")
        return {
            "upload": upload,
            "install": install,
            "library": installed,
            "snapshot": install.get("snapshot", {}),
        }

    def start_shared_vision(self, *, stop_event: threading.Event, timeout: float = 20.0,
                            game_id: str | None = None) -> dict[str, Any]:
        profiles = {0xC0060800: "C6I_VISION", 0xC0060900: "C6I_VISION_VOICE_S3",
                0xC0060C00: "C6I_VISION_VOLUME_V1",
                0xC0061000: "C6I_VISION_BUTTON_V1"}
        if self._expected_build_id not in profiles:
            raise RuntimeError("Live vision requires the C6I_VISION platform")
        deadline = monotonic() + timeout

        def require_game_mode(result: dict[str, Any]) -> None:
            snapshot = result.get("snapshot", {})
            vision = snapshot.get("vision", {})
            capabilities = vision.get("input_capabilities")
            games = capabilities.get("games") if isinstance(capabilities, dict) else None
            identity_ok = result.get("ok") is True and snapshot.get("profile") == profiles[self._expected_build_id]
            identity_ok = identity_ok and type(snapshot.get("build_id")) is int and snapshot["build_id"] == self._expected_build_id
            mode_ok = isinstance(capabilities, dict) and capabilities.get("schema") == "local-game-vision-v1"
            mode_ok = mode_ok and capabilities.get("mode") == "games"
            games_ok = isinstance(games, list) and bool(games) and all(isinstance(value, str) for value in games)
            games_ok = games_ok and (game_id is None or isinstance(games, list) and game_id in games)
            if not (identity_ok and mode_ok and games_ok):
                raise RuntimeError("Agent lacks the requested native game vision mode; use --game-controls "
                                   "or --vision-game-input with the matching C6I_VISION candidate")

        session: VisionAgentSession | None = None
        try:
            if stop_event.is_set():
                raise RuntimeError("Vision startup cancelled")
            if self._expected_build_id == 0xC0061000:
                result = self.video_status()
                require_game_mode(result)
                if result["snapshot"]["vision"]["state"] != "RUNNING":
                    raise RuntimeError("Button candidate vision is not running; its Agent does not advertise VISION_START")
                return result
            session = VisionAgentSession(self._client.host, self._client.port, timeout=2.0,
                                         source_address=self._client.source_address,
                                         expected_build_id=self._expected_build_id)
            status = session.request(AgentCommand.VISION_STATUS, cancelled=stop_event.is_set)
            require_game_mode(status)
            if status["snapshot"]["vision"]["state"] not in ("IDLE", "STARTING", "RUNNING"):
                raise RuntimeError(f"Vision cleanup required before startup: {status}")
            if stop_event.is_set():
                raise RuntimeError("Vision startup cancelled")
            result = session.request(AgentCommand.VISION_START, cancelled=stop_event.is_set)
            while True:
                status = result["snapshot"]["vision"]
                if not result["ok"] or status["state"] not in ("STARTING", "RUNNING"):
                    raise RuntimeError(f"Vision startup failed: {result}")
                require_game_mode(result)
                if status["state"] == "RUNNING":
                    return result
                if monotonic() >= deadline:
                    raise RuntimeError("Vision startup timed out; explicit VISION_STOP remains available")
                if stop_event.wait(0.1):
                    raise RuntimeError("Vision startup cancelled")
                result = session.request(AgentCommand.VISION_STATUS, cancelled=stop_event.is_set)
        finally:
            if session is not None:
                session.close()

    def run_game(self, item_id: str, *, test_case_json: str | None = None) -> dict[str, Any]:
        return self.play_library_item(
            item_id, library_kind="game", test_case_json=test_case_json
        )

    def pause_game(self) -> dict[str, Any]:
        return self._with_video_client(
            lambda client: self._video_command(client, AgentCommand.GAME_PAUSE),
            timeout=self._game_lifecycle_timeout,
        )

    def resume_game(self) -> dict[str, Any]:
        return self._with_video_client(
            lambda client: self._video_command(client, AgentCommand.GAME_RESUME),
            timeout=self._game_lifecycle_timeout,
        )

    def step_game(self) -> dict[str, Any]:
        return self._with_video_client(
            lambda client: self._video_command(client, AgentCommand.GAME_STEP)
        )

    def reset_game(self) -> dict[str, Any]:
        return self._with_video_client(
            lambda client: self._video_command(client, AgentCommand.GAME_RESET),
            timeout=self._game_lifecycle_timeout,
        )

    def initialize_shell(self) -> dict[str, Any]:
        return self._with_video_client(
            lambda client: self._video_command(client, AgentCommand.SHELL_INITIALIZE)
        )

    def clear_shell_state(self) -> dict[str, Any]:
        return self.stop_video()

    def inject_game_input(
        self,
        *,
        x: int | None = None,
        y: int | None = None,
        fist: bool | None = None,
        frequency_hz: float | None = None,
        duration_ms: int | None = None,
        input_id: str | None = None,
        gesture: str | None = None,
    ) -> dict[str, Any]:
        return self._with_video_client(
            lambda client: self._game_input_command(
                client,
                x=x,
                y=y,
                fist=fist,
                frequency_hz=frequency_hz,
                duration_ms=duration_ms,
                input_id=input_id,
                gesture=gesture,
            )
        )

    def cancel_game_input(self) -> dict[str, Any]:
        return self._with_video_client(
            lambda client: self._video_command(client, AgentCommand.INPUT_CANCEL)
        )

    def _upload_artifact(
        self,
        path: Path,
        manifest: ArtifactManifest,
        *,
        progress: Callable[[int, int], None] | None = None,
        require_volume: bool = False,
    ) -> dict[str, Any]:
        client = AgentClient(
            self._client.host,
            self._client.port,
            timeout=self._deployment_timeout,
            source_address=self._client.source_address,
        )
        try:
            hello = client.connect()
            if hello.get("build_id") != self._expected_build_id:
                raise RuntimeError("upload Agent BUILD_ID does not match expected runtime")
            _require_hello(hello, self._expected_build_id)
            if require_volume and (self._expected_build_id != 0xC0060C00
                                   or "volume-signal-v1" not in hello.get("supported_volume_schemas", [])):
                raise RuntimeError("Agent does not support the volume game contract")
            return client.upload_file(
                path,
                manifest,
                upload_id=(
                    f"artifact-{self._upload_request_namespace}-"
                    f"{next(self._upload_request_sequence)}-{manifest.sha256[:16]}"
                ),
                progress=progress,
            )
        finally:
            client.close()

    def install_s2v(
        self,
        path: Path,
        *,
        progress: Callable[[int, int], None] | None = None,
        display_name: str | None = None,
    ) -> dict[str, Any]:
        result = self.upload_s2v(path, progress=progress)
        item_id, display_name = video_library_identity(path, display_name)
        return self._with_video_client(
            lambda client: self._library_command(
                client,
                AgentCommand.LIBRARY_INSTALL,
                item_id=item_id,
                display_name=display_name,
                library_kind="video",
            ),
            timeout=self._deployment_timeout,
        )

    def list_library(self, library_kind: str | None = None) -> dict[str, Any]:
        # The board scans and hashes the installed files; this is a deployment
        # readback, whose SD-card work can exceed a normal 250 ms status poll.
        return self._with_video_client(
            lambda client: self._library_command(
                client,
                AgentCommand.LIBRARY_LIST,
                library_kind=library_kind,
            ),
            timeout=self._deployment_timeout,
        )

    def remove_library_item(
        self, item_id: str, *, library_kind: str
    ) -> dict[str, Any]:
        return self._with_video_client(
            lambda client: self._library_command(
                client,
                AgentCommand.LIBRARY_REMOVE,
                item_id=item_id,
                library_kind=library_kind,
            ),
            timeout=self._deployment_timeout,
        )

    def play_library_item(
        self,
        item_id: str,
        *,
        library_kind: str,
        test_case_json: str | None = None,
    ) -> dict[str, Any]:
        return self._with_video_client(
            lambda client: self._library_command(
                client,
                AgentCommand.LIBRARY_RUN,
                item_id=item_id,
                library_kind=library_kind,
                test_case_json=test_case_json,
            ),
            timeout=(self._game_lifecycle_timeout if library_kind == "game"
                     else self._video_lifecycle_timeout),
        )

    def start_video(self) -> dict[str, Any]:
        def command(client: AgentClient) -> dict[str, Any]:
            status = self._video_command(client, AgentCommand.STATUS)
            state = status.get("state")
            if state == "staged":
                self._video_command(client, AgentCommand.ACTIVATE)
                state = "active"
            if state in ("active", "paused"):
                return self._video_command(client, AgentCommand.RUN)
            if state == "running":
                return status
            raise RuntimeError(f"video cannot start from Agent state {state!r}")

        return self._with_video_client(command, timeout=self._video_lifecycle_timeout)

    def pause_video(self) -> dict[str, Any]:
        return self._with_video_client(
            lambda client: self._video_command(client, AgentCommand.PAUSE),
            timeout=self._video_lifecycle_timeout,
        )

    def seek_video(self, frame_index: int) -> dict[str, Any]:
        if type(frame_index) is not int or frame_index < 0:
            raise ValueError("frame_index must be a non-negative integer")
        return self._with_video_client(
            lambda client: self._video_command(
                client, AgentCommand.SEEK, frame_index=frame_index
            ),
            timeout=self._video_lifecycle_timeout,
        )

    def stop_video(self) -> dict[str, Any]:
        return self._with_video_client(
            lambda client: self._video_command(client, AgentCommand.STOP),
            timeout=self._game_lifecycle_timeout,
        )

    def video_status(self) -> dict[str, Any]:
        read_status = lambda client: self._video_command(client, AgentCommand.STATUS)
        try:
            return self._with_video_client(read_status)
        except TimeoutError:
            # Completed per-tick reports are much larger than the live snapshot.
            # Retry only this read, once; preserve the fast normal poll budget.
            if self._expected_build_id != 0xC0061000 or self._client.timeout >= 5.0:
                raise
            return self._with_video_client(read_status, timeout=5.0)

    def create_voice_monitor(self) -> VoiceMonitorSession:
        return VoiceMonitorSession(self._client.host, self._client.port, expected_build_id=self._expected_build_id,
                                   source_address=self._client.source_address)

    def create_volume_monitor(self) -> FusedVolumeMonitorSession:
        return FusedVolumeMonitorSession(self._client.host, self._client.port,
            expected_build_id=self._expected_build_id, source_address=self._client.source_address)

    def require_volume_input(self) -> dict[str, Any]:
        from ..volume_monitor import validate_fused_volume_status
        result = self.video_status()
        volume = validate_fused_volume_status(result.get("snapshot"))
        latch = volume["latch"]
        observation = volume.get("observation")
        if (not volume["sampling_enabled"] or not volume["poller_alive"] or not volume["lease_retained"]
            or volume["error"] is not None or latch is None or latch.get("error") is not None
            or observation is None or observation["cache_age_ms"] > 500 or observation.get("error") is not None
            or not observation["snapshot"]["snapshot_valid"]):
            raise RuntimeError("Fused volume sampling is not healthy")
        return result

    def fail(self, message: str) -> DeviceSnapshot:
        self._client.close()
        return self._set_state(DeviceState.ERROR, None, message)

    @property
    def _game_lifecycle_timeout(self) -> float:
        # Worker startup, GPU resource upload and teardown exceed status polling.
        return max(75.0, self._client.timeout)

    @property
    def _deployment_timeout(self) -> float:
        return self._game_lifecycle_timeout

    @property
    def _video_lifecycle_timeout(self) -> float:
        # Full-file validation of long S2V clips on ARM/SD can exceed the
        # game's startup budget. Keep this bounded and separate from status.
        return max(240.0, self._client.timeout)

    def _with_video_client(
        self, action: Callable[[AgentClient], dict[str, Any]], *, timeout: float | None = None
    ) -> dict[str, Any]:
        client = AgentClient(
            self._client.host,
            self._client.port,
            timeout=self._client.timeout if timeout is None else timeout,
            source_address=self._client.source_address,
        )
        try:
            hello = client.connect()
            if hello.get("build_id") != self._expected_build_id:
                raise RuntimeError("video Agent BUILD_ID does not match expected runtime")
            _require_hello(hello, self._expected_build_id)
            return action(client)
        finally:
            client.close()

    def _video_command(
        self,
        client: AgentClient,
        command: AgentCommand,
        *,
        frame_index: int | None = None,
    ) -> dict[str, Any]:
        request_id = (
            f"studio-video-{self._video_request_namespace}-"
            f"{next(self._video_request_sequence)}-{command.value}"
        )
        result = client.command(request_id, command, frame_index=frame_index)
        if result.get("ok") is not True:
            raise RuntimeError(str(result.get("message", "video command failed")))
        return result

    def _library_command(
        self,
        client: AgentClient,
        command: AgentCommand,
        *,
        item_id: str | None = None,
        display_name: str | None = None,
        library_kind: str | None = None,
        test_case_json: str | None = None,
    ) -> dict[str, Any]:
        request_id = (
            f"studio-library-{self._video_request_namespace}-"
            f"{next(self._video_request_sequence)}-{command.value}"
        )
        result = client.command(
            request_id,
            command,
            item_id=item_id,
            display_name=display_name,
            library_kind=library_kind,
            test_case_json=test_case_json,
        )
        if result.get("ok") is not True:
            raise RuntimeError(str(result.get("message", "library command failed")))
        return result

    def _game_input_command(
        self,
        client: AgentClient,
        *,
        x: int | None,
        y: int | None,
        fist: bool | None,
        frequency_hz: float | None,
        duration_ms: int | None,
        input_id: str | None,
        gesture: str | None = None,
    ) -> dict[str, Any]:
        request_id = (
            f"studio-input-{self._video_request_namespace}-"
            f"{next(self._video_request_sequence)}"
        )
        result = client.command(
            request_id,
            AgentCommand.INPUT_INJECT,
            x=x,
            y=y,
            fist=fist,
            frequency_hz=frequency_hz,
            duration_ms=duration_ms,
            input_id=input_id,
            **({"gesture": gesture} if gesture is not None else {}),
        )
        if result.get("ok") is not True:
            raise RuntimeError(str(result.get("message", "input command failed")))
        return result

    def _set_state(
        self,
        state: DeviceState,
        build_id: int | None,
        message: str,
        *,
        protocol_version: tuple[int, int] | None = None,
    ) -> DeviceSnapshot:
        self._generation += 1
        self._snapshot = DeviceSnapshot(
            state,
            self._name,
            build_id,
            message,
            self._generation,
            protocol_version,
        )
        return self._snapshot


class FusedVolumeMonitorSession:
    def __init__(self, host: str, port: int, *, expected_build_id: int,
                 source_address: str | None = None, timeout: float = 0.5) -> None:
        if expected_build_id != 0xC0060C00:
            raise ValueError("Fused volume observation requires explicit C0C selection")
        self.client = AgentClient(host, port, timeout=timeout, source_address=source_address)

    def request(self) -> dict[str, Any]:
        from ..volume_monitor import validate_fused_volume_status
        _require_hello(self.client.connect(), 0xC0060C00)
        result = self.client.command("studio-volume-" + uuid.uuid4().hex, AgentCommand.STATUS)
        if result.get("ok") is not True:
            raise RuntimeError(str(result.get("message", "Volume STATUS failed")))
        validate_fused_volume_status(result.get("snapshot"))
        return result

    def close(self) -> None:
        self.client.close()


class VoiceMonitorSession:
    def __init__(self, host: str, port: int, *, expected_build_id: int,
                 source_address: str | None = None, timeout: float = 0.5) -> None:
        if expected_build_id != 0xC0060900:
            raise ValueError("Voice observation requires explicit 900 candidate selection")
        self.client = AgentClient(host, port, timeout=timeout, source_address=source_address)

    def request(self) -> dict[str, Any]:
        from ..voice_monitor import validate_voice_monitor
        hello = self.client.connect()
        if (hello.get("profile") != "C6I_VISION_VOICE_S3" or type(hello.get("build_id")) is not int
                or hello["build_id"] != 0xC0060900 or hello.get("voice_observation_schema") != "voice-monitor-v1"):
            raise ValueError("Agent does not advertise the paired voice observation candidate")
        result = self.client.command("studio-voice-" + uuid.uuid4().hex, AgentCommand.STATUS)
        if type(result.get("ok")) is not bool:
            raise ValueError("Invalid voice STATUS result")
        if result["ok"] is not True:
            raise RuntimeError(str(result.get("message", "Voice STATUS failed")))
        validate_voice_monitor(result.get("snapshot"))
        return result

    def close(self) -> None:
        self.client.close()


class VisionAgentSession:
    COMMANDS = (AgentCommand.VISION_START, AgentCommand.VISION_STATUS, AgentCommand.VISION_STOP)

    def __init__(self, host: str, port: int, *, timeout: float = 20.0,
                 source_address: str | None = None, expected_build_id: int | None = None) -> None:
        self.client = AgentClient(host, port, timeout=timeout, source_address=source_address)
        self.expected_build_id = expected_build_id

    def request(self, command: AgentCommand, *, request_id: str | None = None,
                cancelled: Callable[[], bool] | None = None) -> dict[str, Any]:
        command = AgentCommand(command)
        if command not in self.COMMANDS:
            raise ValueError("Only vision lifecycle commands are permitted")
        if cancelled is not None and cancelled():
            raise RuntimeError("Vision request cancelled")
        hello = self.client.connect()
        capabilities = hello.get("vision_commands")
        profile = hello.get("profile")
        expected_build_id = ({"VISION_ONLY": 0, "C6I_VISION": 0xC0060800,
                      "C6I_VISION_VOICE_S3": 0xC0060900,
                      "C6I_VISION_VOLUME_V1": 0xC0060C00}.get(profile)
                     if type(profile) is str else None)
        if (expected_build_id is None or type(hello.get("build_id")) is not int
                or hello["build_id"] != expected_build_id or not isinstance(capabilities, list)
            or (expected_build_id in (0xC0060900, 0xC0060C00) and self.expected_build_id != expected_build_id)
            or (self.expected_build_id is not None and self.expected_build_id != expected_build_id)
                or any(value.value not in capabilities for value in self.COMMANDS)):
            raise RuntimeError("Agent does not advertise a valid VISION_ONLY or C6I_VISION lifecycle profile")
        if expected_build_id == 0xC0060C00:
            _require_hello(hello, expected_build_id)
        if cancelled is not None and cancelled():
            raise RuntimeError("Vision request cancelled")
        result = self.client.command(request_id or f"studio-vision-{uuid.uuid4().hex}", command)
        snapshot = result.get("snapshot")
        if (not isinstance(snapshot, dict) or snapshot.get("profile") != profile
            or (profile != "VISION_ONLY" and (type(snapshot.get("build_id")) is not int
                or snapshot["build_id"] != expected_build_id))
                or not isinstance(snapshot.get("vision"), dict)):
            raise RuntimeError("Invalid vision lifecycle receipt")
        status = snapshot["vision"]
        if (type(result.get("ok")) is not bool or type(status.get("state")) is not str
                or status["state"] not in ("IDLE", "STARTING", "RUNNING", "STOPPING", "FAULT")
                or type(status.get("owner_held")) is not bool):
            raise RuntimeError("Invalid vision lifecycle state")
        return result

    def close(self) -> None:
        self.client.close()
