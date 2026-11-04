from __future__ import annotations

import hashlib
import os
from collections import OrderedDict
from dataclasses import dataclass
from enum import Enum
from pathlib import Path
import tempfile
from typing import Any, Mapping, Protocol

from ..game_sdk import HandGesture

MAX_ARTIFACT_SIZE = 4 * 1024 * 1024 * 1024
MAX_UPLOAD_CHUNK_SIZE = 1024 * 1024


class AgentState(str, Enum):
    IDLE = "idle"
    STARTING = "starting"
    STAGED = "staged"
    ACTIVE = "active"
    RUNNING = "running"
    PAUSED = "paused"
    STOPPING = "stopping"
    ERROR = "error"


class AgentCommand(str, Enum):
    STAGE = "stage"
    ACTIVATE = "activate"
    RUN = "run"
    PAUSE = "pause"
    SEEK = "seek"
    STOP = "stop"
    STATUS = "status"
    UPLOAD_BEGIN = "upload_begin"
    UPLOAD_CHUNK = "upload_chunk"
    UPLOAD_COMMIT = "upload_commit"
    UPLOAD_ABORT = "upload_abort"
    UPLOAD_STATUS = "upload_status"
    LIBRARY_INSTALL = "library_install"
    LIBRARY_LIST = "library_list"
    LIBRARY_REMOVE = "library_remove"
    LIBRARY_RUN = "library_run"
    SHELL_INITIALIZE = "shell_initialize"
    INPUT_INJECT = "input_inject"
    INPUT_CANCEL = "input_cancel"
    GAME_PAUSE = "game_pause"
    GAME_RESUME = "game_resume"
    GAME_STEP = "game_step"
    GAME_RESET = "game_reset"
    VISION_START = "vision_start"
    VISION_STATUS = "vision_status"
    VISION_STOP = "vision_stop"


@dataclass(frozen=True)
class ArtifactManifest:
    artifact_kind: str
    sha256: str
    target_build_id: int
    abi_major: int
    abi_minor: int
    length: int

    def __post_init__(self) -> None:
        if not self.artifact_kind or not self.artifact_kind.isascii():
            raise ValueError("artifact_kind must be non-empty ASCII")
        if len(self.sha256) != 64 or any(character not in "0123456789abcdef" for character in self.sha256):
            raise ValueError("sha256 must be lowercase hexadecimal")
        if not 0 <= self.target_build_id <= 0xFFFFFFFF:
            raise ValueError("target_build_id must fit in 32 bits")
        if not 0 <= self.abi_major <= 0xFFFF or not 0 <= self.abi_minor <= 0xFFFF:
            raise ValueError("ABI version must fit in 16 bits")
        if not 0 <= self.length <= MAX_ARTIFACT_SIZE:
            raise ValueError("artifact length is outside the supported range")

    @classmethod
    def for_payload(
        cls,
        payload: bytes,
        *,
        artifact_kind: str,
        target_build_id: int,
        abi_major: int,
        abi_minor: int,
    ) -> ArtifactManifest:
        return cls(
            artifact_kind=artifact_kind,
            sha256=hashlib.sha256(payload).hexdigest(),
            target_build_id=target_build_id,
            abi_major=abi_major,
            abi_minor=abi_minor,
            length=len(payload),
        )

    @classmethod
    def for_path(
        cls,
        path: Path,
        *,
        artifact_kind: str,
        target_build_id: int,
        abi_major: int,
        abi_minor: int,
    ) -> ArtifactManifest:
        source = Path(path)
        digest = hashlib.sha256()
        length = 0
        with source.open("rb") as stream:
            for chunk in iter(lambda: stream.read(MAX_UPLOAD_CHUNK_SIZE), b""):
                digest.update(chunk)
                length += len(chunk)
        return cls(
            artifact_kind=artifact_kind,
            sha256=digest.hexdigest(),
            target_build_id=target_build_id,
            abi_major=abi_major,
            abi_minor=abi_minor,
            length=length,
        )


@dataclass(frozen=True)
class RuntimeSnapshot:
    state: AgentState
    build_id: int
    abi_major: int
    abi_minor: int
    staged_sha256: str | None
    active_sha256: str | None
    generation: int
    frame_index: int | None = None
    frame_count: int | None = None
    presented_frames: int | None = None
    completed_loops: int | None = None
    last_error: str | None = None
    runtime_mode: str | None = None
    catalog_generation: int | None = None
    game_tick: int | None = None
    game_status: str | None = None
    game_score: int | None = None
    game_values: Mapping[str, Any] | None = None
    scene_sha256: str | None = None
    command_count: int | None = None
    predicted_cycles: int | None = None
    accepted_input_id: str | None = None
    consumed_input_id: str | None = None
    assertions_passed: int | None = None
    assertions_failed: int | None = None
    test_complete: bool | None = None
    game_test_report: Mapping[str, Any] | None = None
    profile: str = "GPU"
    vision: Mapping[str, Any] | None = None
    vision_consumption: Mapping[str, Any] | None = None
    audio_consumption: Mapping[str, Any] | None = None
    volume_consumption: Mapping[str, Any] | None = None
    action_permit: Mapping[str, Any] | None = None
    voice: Mapping[str, Any] | None = None
    volume: Mapping[str, Any] | None = None


class RuntimeBackend(Protocol):
    @property
    def snapshot(self) -> RuntimeSnapshot: ...

    def stage(self, manifest: ArtifactManifest, payload: bytes) -> RuntimeSnapshot: ...

    def stage_file(self, manifest: ArtifactManifest, path: Path) -> RuntimeSnapshot: ...

    def activate(self) -> RuntimeSnapshot: ...

    def run(self) -> RuntimeSnapshot: ...

    def pause(self) -> RuntimeSnapshot: ...

    def seek(self, frame_index: int) -> RuntimeSnapshot: ...

    def stop(self) -> RuntimeSnapshot: ...


class MockRuntimeBackend:
    def __init__(self, *, build_id: int, abi_major: int = 1, abi_minor: int = 0) -> None:
        self._build_id = build_id
        self._abi_major = abi_major
        self._abi_minor = abi_minor
        self._generation = 0
        self._state = AgentState.IDLE
        self._staged: tuple[ArtifactManifest, bytes] | None = None
        self._active: tuple[ArtifactManifest, bytes] | None = None

    @property
    def snapshot(self) -> RuntimeSnapshot:
        return RuntimeSnapshot(
            state=self._state,
            build_id=self._build_id,
            abi_major=self._abi_major,
            abi_minor=self._abi_minor,
            staged_sha256=None if self._staged is None else self._staged[0].sha256,
            active_sha256=None if self._active is None else self._active[0].sha256,
            generation=self._generation,
        )

    def stage(self, manifest: ArtifactManifest, payload: bytes) -> RuntimeSnapshot:
        candidate = bytes(payload)
        if self._state is AgentState.RUNNING:
            raise RuntimeError("cannot stage while runtime is running")
        if manifest.target_build_id != self._build_id:
            raise ValueError("artifact BUILD_ID mismatch")
        if (manifest.abi_major, manifest.abi_minor) != (self._abi_major, self._abi_minor):
            raise ValueError("artifact ABI mismatch")
        if manifest.length != len(candidate):
            raise ValueError("artifact length mismatch")
        if manifest.sha256 != hashlib.sha256(candidate).hexdigest():
            raise ValueError("artifact SHA-256 mismatch")
        self._staged = (manifest, candidate)
        self._set_state(AgentState.STAGED)
        return self.snapshot

    def stage_file(self, manifest: ArtifactManifest, path: Path) -> RuntimeSnapshot:
        return self.stage(manifest, path.read_bytes())

    def activate(self) -> RuntimeSnapshot:
        if self._state is AgentState.RUNNING:
            raise RuntimeError("cannot activate while runtime is running")
        if self._staged is None:
            raise RuntimeError("no staged artifact")
        self._active = self._staged
        self._staged = None
        self._set_state(AgentState.ACTIVE)
        return self.snapshot

    def run(self) -> RuntimeSnapshot:
        if self._active is None:
            raise RuntimeError("no active artifact")
        if self._state is not AgentState.RUNNING:
            self._set_state(AgentState.RUNNING)
        return self.snapshot

    def pause(self) -> RuntimeSnapshot:
        if self._state is AgentState.RUNNING:
            self._set_state(AgentState.PAUSED)
        elif self._state is not AgentState.PAUSED:
            raise RuntimeError("runtime is not running")
        return self.snapshot

    def seek(self, frame_index: int) -> RuntimeSnapshot:
        if type(frame_index) is not int or frame_index < 0:
            raise ValueError("seek requires a non-negative frame_index")
        if self._active is None:
            raise RuntimeError("no active artifact")
        if self._state in (AgentState.IDLE, AgentState.STAGED, AgentState.STOPPING, AgentState.ERROR):
            raise RuntimeError("runtime is not seekable")
        self._generation += 1
        return self.snapshot

    def stop(self) -> RuntimeSnapshot:
        if self._state in (AgentState.RUNNING, AgentState.PAUSED):
            self._set_state(AgentState.STOPPING)
            self._set_state(AgentState.ACTIVE)
        return self.snapshot

    def _set_state(self, state: AgentState) -> None:
        self._state = state
        self._generation += 1


@dataclass(frozen=True)
class AgentResult:
    request_id: str
    ok: bool
    state: AgentState
    message: str
    snapshot: RuntimeSnapshot
    replayed: bool = False
    transfer: ArtifactTransferSnapshot | None = None
    library_items: tuple[LibraryItemSnapshot, ...] | None = None


@dataclass(frozen=True)
class LibraryItemSnapshot:
    item_id: str
    display_name: str
    kind: str
    length: int
    sha256: str


@dataclass(frozen=True)
class ArtifactTransferSnapshot:
    upload_id: str
    artifact_kind: str
    expected_length: int
    received_length: int
    state: str


@dataclass
class _PendingUpload:
    upload_id: str
    manifest: ArtifactManifest
    path: Path
    received_length: int = 0


class AgentController:
    def __init__(
        self,
        backend: RuntimeBackend,
        *,
        result_cache_size: int = 256,
        upload_directory: Path | None = None,
    ) -> None:
        if result_cache_size <= 0:
            raise ValueError("result_cache_size must be positive")
        self._backend = backend
        self._result_cache_size = result_cache_size
        self._results: OrderedDict[str, tuple[tuple[object, ...], AgentResult]] = OrderedDict()
        if upload_directory is not None:
            Path(upload_directory).mkdir(parents=True, exist_ok=True)
        self._upload_root = tempfile.TemporaryDirectory(
            prefix="voice-view-upload-",
            dir=None if upload_directory is None else Path(upload_directory),
        )
        self._pending_upload: _PendingUpload | None = None

    @property
    def snapshot(self) -> RuntimeSnapshot:
        return self._backend.snapshot

    @property
    def input_schema_version(self) -> int:
        return getattr(self._backend, "input_schema_version", 1)

    @property
    def supported_action_schemas(self):
        return tuple(getattr(self._backend, "supported_action_schemas", ()))

    @property
    def supported_volume_schemas(self):
        return tuple(getattr(self._backend, "supported_volume_schemas", ()))

    @property
    def test_case_schema_versions(self):
        return tuple(getattr(self._backend, "test_case_schema_versions",
                             (1, 2) if self.input_schema_version >= 2 else (1,)))

    def execute(
        self,
        request_id: str,
        command: AgentCommand,
        *,
        manifest: ArtifactManifest | None = None,
        payload: bytes = b"",
        upload_id: str | None = None,
        offset: int | None = None,
        chunk_sha256: str | None = None,
        frame_index: int | None = None,
        item_id: str | None = None,
        display_name: str | None = None,
        library_kind: str | None = None,
        x: int | None = None,
        y: int | None = None,
        fist: bool | None = None,
        frequency_hz: float | None = None,
        duration_ms: int | None = None,
        test_case_json: str | None = None,
        input_id: str | None = None,
        gesture: str | None = None,
    ) -> AgentResult:
        if not request_id:
            raise ValueError("request_id must not be empty")
        command = AgentCommand(command)
        signature = (
            command,
            manifest,
            hashlib.sha256(payload).digest(),
            upload_id,
            offset,
            chunk_sha256,
            frame_index,
            item_id,
            display_name,
            library_kind,
            x,
            y,
            fist,
            frequency_hz,
            duration_ms,
            test_case_json,
            input_id,
            gesture,
        )
        cached = self._results.get(request_id)
        if cached is not None:
            self._results.move_to_end(request_id)
            cached_signature, cached_result = cached
            if cached_signature != signature:
                snapshot = self._backend.snapshot
                return AgentResult(
                    request_id,
                    False,
                    snapshot.state,
                    "request_id was reused with a different request",
                    snapshot,
                    transfer=self._transfer_snapshot(),
                )
            return AgentResult(
                request_id=cached_result.request_id,
                ok=cached_result.ok,
                state=cached_result.state,
                message=cached_result.message,
                snapshot=cached_result.snapshot,
                replayed=True,
                transfer=cached_result.transfer,
                library_items=cached_result.library_items,
            )
        transfer = None
        library_items = None
        try:
            if (getattr(self._backend, "profile", None) == "VISION_ONLY"
                    and command not in (AgentCommand.VISION_START, AgentCommand.VISION_STATUS,
                                        AgentCommand.VISION_STOP, AgentCommand.STATUS)):
                raise RuntimeError("VISION_ONLY does not support GPU, game or upload commands")
            if command in (AgentCommand.VISION_START, AgentCommand.VISION_STOP):
                method_name = "start_vision" if command is AgentCommand.VISION_START else "stop_vision"
                method = getattr(self._backend, method_name, None)
                if method is None:
                    raise RuntimeError("runtime does not support vision lifecycle")
                snapshot = method()
            elif command is AgentCommand.VISION_STATUS:
                if getattr(self._backend, "profile", None) not in ("VISION_ONLY", "C6I_VISION", "C6I_VISION_VOICE_S3", "C6I_VISION_VOLUME_V1"):
                    raise RuntimeError("runtime does not support vision lifecycle")
                snapshot = self._backend.snapshot
            elif command is AgentCommand.STAGE:
                if manifest is None:
                    raise ValueError("stage requires an artifact manifest")
                snapshot = self._backend.stage(manifest, payload)
            elif command is AgentCommand.ACTIVATE:
                snapshot = self._backend.activate()
            elif command is AgentCommand.RUN:
                snapshot = self._backend.run()
            elif command is AgentCommand.PAUSE:
                snapshot = self._backend.pause()
            elif command is AgentCommand.SEEK:
                snapshot = self._backend.seek(self._validate_frame_index(frame_index))
            elif command is AgentCommand.STOP:
                snapshot = self._backend.stop()
            elif command is AgentCommand.UPLOAD_BEGIN:
                if manifest is None:
                    raise ValueError("upload_begin requires an artifact manifest")
                transfer = self._begin_upload(upload_id, manifest)
                snapshot = self._backend.snapshot
            elif command is AgentCommand.UPLOAD_CHUNK:
                transfer = self._append_upload_chunk(
                    upload_id, offset, chunk_sha256, payload
                )
                snapshot = self._backend.snapshot
            elif command is AgentCommand.UPLOAD_COMMIT:
                transfer, snapshot = self._commit_upload(upload_id)
            elif command is AgentCommand.UPLOAD_ABORT:
                transfer = self._abort_upload(upload_id)
                snapshot = self._backend.snapshot
            elif command is AgentCommand.UPLOAD_STATUS:
                transfer = self._require_upload(upload_id)
                snapshot = self._backend.snapshot
            elif command is AgentCommand.LIBRARY_INSTALL:
                method = getattr(self._backend, "install_staged_library_item", None)
                if method is None:
                    raise RuntimeError("runtime does not support a persistent library")
                library_items = (method(item_id, display_name, library_kind),)
                snapshot = self._backend.snapshot
            elif command is AgentCommand.LIBRARY_LIST:
                method = getattr(self._backend, "list_library_items", None)
                if method is None:
                    raise RuntimeError("runtime does not support a persistent library")
                library_items = method(library_kind)
                snapshot = self._backend.snapshot
            elif command is AgentCommand.LIBRARY_REMOVE:
                method = getattr(self._backend, "remove_library_item", None)
                if method is None:
                    raise RuntimeError("runtime does not support a persistent library")
                method(item_id, library_kind)
                list_method = getattr(self._backend, "list_library_items")
                library_items = list_method(library_kind)
                snapshot = self._backend.snapshot
            elif command is AgentCommand.LIBRARY_RUN:
                if test_case_json is not None:
                    import json
                    schema = json.loads(test_case_json).get("schema_version", 1)
                    if type(schema) is not int or schema not in self.test_case_schema_versions:
                        raise RuntimeError("runtime does not support requested test case schema")
                method = getattr(self._backend, "run_library_item", None)
                if method is None:
                    raise RuntimeError("runtime does not support persistent library playback")
                snapshot = method(item_id, library_kind, test_case_json=test_case_json)
            elif command is AgentCommand.SHELL_INITIALIZE:
                method = getattr(self._backend, "initialize_shell", None)
                if method is None:
                    raise RuntimeError("runtime does not support shell initialization")
                snapshot = method()
            elif command is AgentCommand.INPUT_INJECT:
                method = getattr(self._backend, "inject_test_input", None)
                if method is None:
                    raise RuntimeError("runtime does not support test input injection")
                gesture_fields = {}
                if gesture is not None:
                    if self.input_schema_version < 2:
                        raise RuntimeError("runtime does not support gesture input schema 2")
                    gesture_fields["gesture"] = HandGesture(gesture).value
                snapshot = method(
                    x=x,
                    y=y,
                    fist=fist,
                    frequency_hz=frequency_hz,
                    duration_ms=duration_ms,
                    input_id=input_id,
                    **gesture_fields,
                )
            elif command is AgentCommand.INPUT_CANCEL:
                method = getattr(self._backend, "cancel_test_input", None)
                if method is None:
                    raise RuntimeError("runtime does not support test input cancellation")
                snapshot = method()
            elif command is AgentCommand.GAME_PAUSE:
                snapshot = self._game_debug_command("pause_game")
            elif command is AgentCommand.GAME_RESUME:
                snapshot = self._game_debug_command("resume_game")
            elif command is AgentCommand.GAME_STEP:
                snapshot = self._game_debug_command("step_game")
            elif command is AgentCommand.GAME_RESET:
                snapshot = self._game_debug_command("reset_game")
            else:
                snapshot = self._backend.snapshot
                transfer = self._transfer_snapshot()
            result = AgentResult(
                request_id,
                True,
                snapshot.state,
                "ok",
                snapshot,
                transfer=transfer,
                library_items=library_items,
            )
        except (KeyError, OSError, RuntimeError, ValueError) as error:
            snapshot = self._backend.snapshot
            result = AgentResult(
                request_id,
                False,
                snapshot.state,
                str(error),
                snapshot,
                transfer=self._transfer_snapshot(),
            )
        self._results[request_id] = (signature, result)
        self._results.move_to_end(request_id)
        while len(self._results) > self._result_cache_size:
            self._results.popitem(last=False)
        return result

    def _game_debug_command(self, method_name: str) -> RuntimeSnapshot:
        method = getattr(self._backend, method_name, None)
        if method is None:
            raise RuntimeError(f"runtime does not support {method_name}")
        return method()

    def close(self) -> None:
        self._pending_upload = None
        self._upload_root.cleanup()

    def _begin_upload(
        self,
        upload_id: str | None,
        manifest: ArtifactManifest,
    ) -> ArtifactTransferSnapshot:
        upload_id = self._validate_upload_id(upload_id)
        snapshot = self._backend.snapshot
        if manifest.target_build_id != snapshot.build_id:
            raise ValueError("artifact BUILD_ID does not match the runtime")
        if (manifest.abi_major, manifest.abi_minor) != (
            snapshot.abi_major,
            snapshot.abi_minor,
        ):
            raise ValueError("artifact ABI does not match the runtime")
        pending = self._pending_upload
        if pending is not None:
            if pending.upload_id == upload_id and pending.manifest == manifest:
                return self._snapshot_for(pending)
            raise RuntimeError("another artifact upload is already in progress")
        path = Path(self._upload_root.name) / "pending.part"
        path.unlink(missing_ok=True)
        path.touch(exist_ok=False)
        pending = _PendingUpload(upload_id, manifest, path)
        self._pending_upload = pending
        return self._snapshot_for(pending)

    def _append_upload_chunk(
        self,
        upload_id: str | None,
        offset: int | None,
        chunk_sha256: str | None,
        payload: bytes,
    ) -> ArtifactTransferSnapshot:
        pending = self._pending(upload_id)
        if type(offset) is not int or offset < 0:
            raise ValueError("upload_chunk requires a non-negative offset")
        if not payload:
            raise ValueError("upload chunk must not be empty")
        if len(payload) > MAX_UPLOAD_CHUNK_SIZE:
            raise ValueError("upload chunk exceeds the supported size")
        actual_sha256 = hashlib.sha256(payload).hexdigest()
        if chunk_sha256 != actual_sha256:
            raise ValueError("upload chunk SHA-256 mismatch")
        end = offset + len(payload)
        if end > pending.manifest.length:
            raise ValueError("upload chunk exceeds the artifact length")
        if offset < pending.received_length:
            if end > pending.received_length:
                raise ValueError("upload chunk overlaps the received boundary")
            with pending.path.open("rb") as stream:
                stream.seek(offset)
                existing = stream.read(len(payload))
            if existing != payload:
                raise ValueError("upload chunk conflicts with received data")
            return self._snapshot_for(pending)
        if offset != pending.received_length:
            raise ValueError("upload chunk offset creates a gap")
        with pending.path.open("ab") as stream:
            stream.write(payload)
            stream.flush()
            os.fsync(stream.fileno())
        pending.received_length = end
        return self._snapshot_for(pending)

    def _commit_upload(
        self, upload_id: str | None
    ) -> tuple[ArtifactTransferSnapshot, RuntimeSnapshot]:
        pending = self._pending(upload_id)
        if pending.received_length != pending.manifest.length:
            raise RuntimeError("artifact upload is incomplete")
        digest = hashlib.sha256()
        with pending.path.open("rb") as stream:
            for chunk in iter(lambda: stream.read(MAX_UPLOAD_CHUNK_SIZE), b""):
                digest.update(chunk)
        if digest.hexdigest() != pending.manifest.sha256:
            raise ValueError("artifact SHA-256 mismatch")
        if pending.manifest.artifact_kind == "video.s2v":
            from ..video_codec import S2V1Reader

            try:
                with S2V1Reader(pending.path):
                    pass
            except Exception as error:
                raise ValueError(f"S2V1 validation failed: {error}") from error
        elif pending.manifest.artifact_kind == "game.vvg":
            from ..game_package import validate_game_package

            try:
                package = validate_game_package(pending.path, require_extension=False)
            except Exception as error:
                raise ValueError(f"VVG validation failed: {error}") from error
            if package.manifest.target_build_id != pending.manifest.target_build_id:
                raise ValueError("VVG BUILD_ID does not match the upload manifest")
            if (package.manifest.abi_major, package.manifest.abi_minor) != (
                pending.manifest.abi_major,
                pending.manifest.abi_minor,
            ):
                raise ValueError("VVG ABI does not match the upload manifest")
        staged_path = Path(self._upload_root.name) / (
            f"{pending.manifest.sha256}.artifact"
        )
        os.replace(pending.path, staged_path)
        try:
            snapshot = self._backend.stage_file(pending.manifest, staged_path)
        except BaseException:
            os.replace(staged_path, pending.path)
            raise
        transfer = ArtifactTransferSnapshot(
            pending.upload_id,
            pending.manifest.artifact_kind,
            pending.manifest.length,
            pending.received_length,
            "staged",
        )
        self._pending_upload = None
        return transfer, snapshot

    def _abort_upload(self, upload_id: str | None) -> ArtifactTransferSnapshot:
        pending = self._pending(upload_id)
        snapshot = ArtifactTransferSnapshot(
            pending.upload_id,
            pending.manifest.artifact_kind,
            pending.manifest.length,
            pending.received_length,
            "aborted",
        )
        pending.path.unlink(missing_ok=True)
        self._pending_upload = None
        return snapshot

    def _pending(self, upload_id: str | None) -> _PendingUpload:
        upload_id = self._validate_upload_id(upload_id)
        pending = self._pending_upload
        if pending is None or pending.upload_id != upload_id:
            raise RuntimeError("artifact upload was not found")
        return pending

    def _require_upload(self, upload_id: str | None) -> ArtifactTransferSnapshot:
        return self._snapshot_for(self._pending(upload_id))

    def _transfer_snapshot(self) -> ArtifactTransferSnapshot | None:
        pending = self._pending_upload
        return None if pending is None else self._snapshot_for(pending)

    @staticmethod
    def _snapshot_for(pending: _PendingUpload) -> ArtifactTransferSnapshot:
        return ArtifactTransferSnapshot(
            pending.upload_id,
            pending.manifest.artifact_kind,
            pending.manifest.length,
            pending.received_length,
            "receiving",
        )

    @staticmethod
    def _validate_upload_id(upload_id: str | None) -> str:
        if (
            not isinstance(upload_id, str)
            or not 1 <= len(upload_id) <= 64
            or not upload_id.isascii()
            or any(not (character.isalnum() or character in "-_.") for character in upload_id)
        ):
            raise ValueError("upload_id must be 1-64 safe ASCII characters")
        return upload_id

    @staticmethod
    def _validate_frame_index(frame_index: int | None) -> int:
        if type(frame_index) is not int or frame_index < 0:
            raise ValueError("seek requires a non-negative frame_index")
        return frame_index
