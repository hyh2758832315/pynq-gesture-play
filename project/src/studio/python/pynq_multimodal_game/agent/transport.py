from __future__ import annotations

import base64
import json
import socket
import socketserver
import threading
import time
from collections import OrderedDict, deque
from dataclasses import asdict
import hashlib
from pathlib import Path
from typing import Any, Callable

from ..protocol import FrameDecoder, MessageType, ProtocolFrame
from .core import (
    AgentCommand,
    AgentController,
    ArtifactManifest,
    MAX_UPLOAD_CHUNK_SIZE,
)


class LatestDataBuffer:
    def __init__(self, capacity: int = 32) -> None:
        if capacity <= 0:
            raise ValueError("capacity must be positive")
        self._capacity = capacity
        self._frames: OrderedDict[tuple[int, int], ProtocolFrame] = OrderedDict()
        self._condition = threading.Condition()
        self._closed = False
        self.dropped = 0

    def put(self, frame: ProtocolFrame) -> None:
        key = (frame.source_id, frame.channel_id)
        with self._condition:
            if self._closed:
                return
            if key in self._frames:
                del self._frames[key]
                self.dropped += 1
            elif len(self._frames) >= self._capacity:
                self._frames.popitem(last=False)
                self.dropped += 1
            self._frames[key] = frame
            self._condition.notify()

    def get(self) -> ProtocolFrame | None:
        with self._condition:
            while not self._frames and not self._closed:
                self._condition.wait()
            if not self._frames:
                return None
            _, frame = self._frames.popitem(last=False)
            return frame

    def close(self) -> None:
        with self._condition:
            self._closed = True
            self._condition.notify_all()


class _Connection:
    def __init__(self, sock: socket.socket, *, queue_capacity: int) -> None:
        self.sock = sock
        self.subscriptions: set[int] = set()
        self.data = LatestDataBuffer(queue_capacity)
        self._send_lock = threading.Lock()
        self._closed = threading.Event()
        self._writer = threading.Thread(target=self._write_data, name="voice-view-agent-writer", daemon=True)
        self._writer.start()

    def send(self, frame: ProtocolFrame) -> None:
        encoded = frame.to_bytes()
        with self._send_lock:
            self.sock.sendall(encoded)

    def publish(self, frame: ProtocolFrame) -> None:
        if frame.source_id in self.subscriptions:
            self.data.put(frame)

    def close(self) -> None:
        if self._closed.is_set():
            return
        self._closed.set()
        self.data.close()
        try:
            self.sock.shutdown(socket.SHUT_RDWR)
        except OSError:
            pass
        self.sock.close()
        if threading.current_thread() is not self._writer:
            self._writer.join(timeout=1.0)

    def _write_data(self) -> None:
        while not self._closed.is_set():
            frame = self.data.get()
            if frame is None:
                return
            try:
                self.send(frame)
            except OSError:
                self.close()
                return


class _ThreadingTcpServer(socketserver.ThreadingTCPServer):
    allow_reuse_address = True
    daemon_threads = True


class _AgentRequestHandler(socketserver.BaseRequestHandler):
    def handle(self) -> None:
        owner: AgentServer = self.server.owner  # type: ignore[attr-defined]
        connection = owner._register(self.request)
        decoder = FrameDecoder()
        self.request.settimeout(owner.socket_timeout)
        try:
            while True:
                try:
                    chunk = self.request.recv(64 * 1024)
                except socket.timeout:
                    continue
                if not chunk:
                    return
                for frame in decoder.feed(chunk):
                    try:
                        owner._handle_frame(connection, frame)
                    except (KeyError, TypeError, ValueError) as error:
                        connection.send(
                            owner._json_frame(
                                MessageType.ERROR,
                                {"message": str(error)},
                                frame.sequence,
                            )
                        )
        except (OSError, ValueError):
            return
        finally:
            owner._unregister(connection)


class AgentServer:
    def __init__(
        self,
        controller: AgentController,
        *,
        host: str = "127.0.0.1",
        port: int = 0,
        queue_capacity: int = 32,
        socket_timeout: float = 0.5,
    ) -> None:
        self.controller = controller
        self.host = host
        self.port = port
        self.queue_capacity = queue_capacity
        self.socket_timeout = socket_timeout
        self._controller_lock = threading.Lock()
        self._connections_lock = threading.Lock()
        self._connections: set[_Connection] = set()
        self._server: _ThreadingTcpServer | None = None
        self._thread: threading.Thread | None = None
        self._sequence = 0

    @property
    def address(self) -> tuple[str, int]:
        if self._server is None:
            raise RuntimeError("server is not running")
        host, port = self._server.server_address[:2]
        return str(host), int(port)

    def start(self) -> None:
        if self._server is not None:
            raise RuntimeError("server is already running")
        server = _ThreadingTcpServer((self.host, self.port), _AgentRequestHandler)
        server.owner = self  # type: ignore[attr-defined]
        self._server = server
        self._thread = threading.Thread(target=server.serve_forever, name="voice-view-agent", daemon=True)
        self._thread.start()

    def close(self) -> None:
        server = self._server
        thread = self._thread
        if server is None:
            return
        server.shutdown()
        server.server_close()
        with self._connections_lock:
            connections = tuple(self._connections)
        for connection in connections:
            connection.close()
        if thread is not None:
            thread.join(timeout=2.0)
        self._server = None
        self._thread = None

    def publish_data(
        self,
        payload: bytes,
        *,
        source_id: int,
        channel_id: int = 0,
        timestamp_ns: int | None = None,
    ) -> None:
        self._sequence += 1
        frame = ProtocolFrame(
            MessageType.DATA,
            payload=payload,
            sequence=self._sequence,
            timestamp_ns=time.time_ns() if timestamp_ns is None else timestamp_ns,
            source_id=source_id,
            channel_id=channel_id,
        )
        with self._connections_lock:
            connections = tuple(self._connections)
        for connection in connections:
            connection.publish(frame)

    def _register(self, sock: socket.socket) -> _Connection:
        connection = _Connection(sock, queue_capacity=self.queue_capacity)
        with self._connections_lock:
            self._connections.add(connection)
        return connection

    def _unregister(self, connection: _Connection) -> None:
        with self._connections_lock:
            self._connections.discard(connection)
        connection.close()

    def _handle_frame(self, connection: _Connection, frame: ProtocolFrame) -> None:
        if frame.message_type is MessageType.HELLO:
            connection.send(self._json_frame(MessageType.HELLO_ACK, self._hello_payload(), frame.sequence))
        elif frame.message_type is MessageType.PING:
            connection.send(ProtocolFrame(MessageType.PONG, frame.payload, sequence=frame.sequence))
        elif frame.message_type is MessageType.SUBSCRIBE:
            body = _decode_json(frame.payload)
            sources = body.get("source_ids")
            if not isinstance(sources, list) or not all(isinstance(value, int) for value in sources):
                raise ValueError("source_ids must be a list of integers")
            connection.subscriptions = set(sources)
            connection.send(
                self._json_frame(
                    MessageType.COMMAND_RESULT,
                    {"ok": True, "source_ids": sorted(connection.subscriptions)},
                    frame.sequence,
                )
            )
        elif frame.message_type is MessageType.COMMAND:
            response = self._execute_command(_decode_json(frame.payload))
            connection.send(self._json_frame(MessageType.COMMAND_RESULT, response, frame.sequence))
        else:
            connection.send(
                self._json_frame(
                    MessageType.ERROR,
                    {"message": f"unsupported request type {frame.message_type.name}"},
                    frame.sequence,
                )
            )

    def _hello_payload(self) -> dict[str, Any]:
        from ..game_sdk import GAME_SDK_MAJOR, GAME_SDK_MINOR
        snapshot = self.controller.snapshot
        return {
            "agent": "voice-view-agent",
            "build_id": snapshot.build_id,
            "abi_major": snapshot.abi_major,
            "abi_minor": snapshot.abi_minor,
            "state": snapshot.state.value,
            "input_schema_version": self.controller.input_schema_version,
            "game_sdk": {"major": GAME_SDK_MAJOR, "minor": GAME_SDK_MINOR},
            "supported_action_schemas": list(self.controller.supported_action_schemas),
                **({"supported_volume_schemas": list(self.controller.supported_volume_schemas)}
                    if self.controller.supported_volume_schemas else {}),
            "test_case_schema_versions": list(self.controller.test_case_schema_versions),
            "profile": snapshot.profile,
            "vision_commands": (["vision_start", "vision_status", "vision_stop"]
                                if snapshot.profile in ("VISION_ONLY", "C6I_VISION", "C6I_VISION_VOICE_S3", "C6I_VISION_VOLUME_V1") else []),
            "voice_observation_schema": "voice-monitor-v1" if snapshot.voice is not None else None,
        }

    def _execute_command(self, body: dict[str, Any]) -> dict[str, Any]:
        request_id = body.get("request_id")
        command = body.get("command")
        if not isinstance(request_id, str) or not isinstance(command, str):
            raise ValueError("command requires string request_id and command")
        manifest_body = body.get("manifest")
        manifest = None
        if manifest_body is not None:
            if not isinstance(manifest_body, dict):
                raise ValueError("manifest must be an object")
            manifest = ArtifactManifest(**manifest_body)
        encoded_payload = body.get("payload_base64", "")
        if not isinstance(encoded_payload, str):
            raise ValueError("payload_base64 must be a string")
        payload = base64.b64decode(encoded_payload, validate=True)
        upload_id = body.get("upload_id")
        offset = body.get("offset")
        chunk_sha256 = body.get("chunk_sha256")
        frame_index = body.get("frame_index")
        item_id = body.get("item_id")
        display_name = body.get("display_name")
        library_kind = body.get("library_kind")
        x = body.get("x")
        y = body.get("y")
        fist = body.get("fist")
        frequency_hz = body.get("frequency_hz")
        duration_ms = body.get("duration_ms")
        test_case_json = body.get("test_case_json")
        input_id = body.get("input_id")
        with self._controller_lock:
            result = self.controller.execute(
                request_id,
                AgentCommand(command),
                manifest=manifest,
                payload=payload,
                upload_id=upload_id,
                offset=offset,
                chunk_sha256=chunk_sha256,
                frame_index=frame_index,
                item_id=item_id,
                display_name=display_name,
                library_kind=library_kind,
                x=x,
                y=y,
                fist=fist,
                frequency_hz=frequency_hz,
                duration_ms=duration_ms,
                test_case_json=test_case_json,
                input_id=input_id,
                gesture=body.get("gesture"),
            )
        response = asdict(result)
        response["state"] = result.state.value
        response["snapshot"]["state"] = result.snapshot.state.value
        return response

    @staticmethod
    def _json_frame(message_type: MessageType, body: dict[str, Any], sequence: int) -> ProtocolFrame:
        return ProtocolFrame(message_type, _encode_json(body), sequence=sequence)


class AgentClient:
    def __init__(
        self,
        host: str,
        port: int,
        *,
        timeout: float = 2.0,
        source_address: str | None = None,
    ) -> None:
        self.host = host
        self.port = port
        self.timeout = timeout
        self.source_address = source_address
        self._socket: socket.socket | None = None
        self._decoder = FrameDecoder()
        self._pending: deque[ProtocolFrame] = deque()
        self._sequence = 0
        self.input_schema_version = 1
        self.game_sdk = {"major": 1, "minor": 0}
        self.supported_action_schemas = ()
        self.supported_volume_schemas = ()
        self.test_case_schema_versions = (1,)

    @property
    def connected(self) -> bool:
        return self._socket is not None

    def connect(self) -> dict[str, Any]:
        self.close()
        source = (self.source_address, 0) if self.source_address is not None else None
        self._socket = socket.create_connection(
            (self.host, self.port),
            timeout=self.timeout,
            source_address=source,
        )
        self._socket.settimeout(self.timeout)
        self._decoder = FrameDecoder()
        self._pending.clear()
        response = self._exchange(MessageType.HELLO, {})
        if response.message_type is not MessageType.HELLO_ACK:
            raise RuntimeError("agent did not acknowledge HELLO")
        hello = _decode_json(response.payload)
        self.input_schema_version = int(hello.get("input_schema_version", 1))
        self.game_sdk = hello.get("game_sdk", {"major": 1, "minor": 0})
        self.supported_action_schemas = tuple(hello.get("supported_action_schemas", ()))
        self.supported_volume_schemas = tuple(hello.get("supported_volume_schemas", ()))
        self.test_case_schema_versions = tuple(hello.get(
            "test_case_schema_versions", (1, 2) if self.input_schema_version >= 2 else (1,)))
        return hello

    def close(self) -> None:
        sock = self._socket
        self._socket = None
        if sock is not None:
            try:
                sock.shutdown(socket.SHUT_RDWR)
            except OSError:
                pass
            sock.close()

    def subscribe(self, source_ids: list[int]) -> dict[str, Any]:
        response = self._exchange(MessageType.SUBSCRIBE, {"source_ids": source_ids})
        return _decode_json(response.payload)

    def command(
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
    ) -> dict[str, Any]:
        body: dict[str, Any] = {
            "request_id": request_id,
            "command": AgentCommand(command).value,
        }
        if manifest is not None:
            body["manifest"] = asdict(manifest)
        if payload:
            body["payload_base64"] = base64.b64encode(payload).decode("ascii")
        if upload_id is not None:
            body["upload_id"] = upload_id
        if offset is not None:
            body["offset"] = offset
        if chunk_sha256 is not None:
            body["chunk_sha256"] = chunk_sha256
        if frame_index is not None:
            body["frame_index"] = frame_index
        if item_id is not None:
            body["item_id"] = item_id
        if display_name is not None:
            body["display_name"] = display_name
        if library_kind is not None:
            body["library_kind"] = library_kind
        if x is not None:
            body["x"] = x
        if y is not None:
            body["y"] = y
        if fist is not None:
            body["fist"] = fist
        if frequency_hz is not None:
            body["frequency_hz"] = frequency_hz
        if duration_ms is not None:
            body["duration_ms"] = duration_ms
        if test_case_json is not None:
            if json.loads(test_case_json).get("schema_version", 1) == 2 and self.input_schema_version < 2:
                raise RuntimeError("agent does not support gesture input schema 2")
            schema = json.loads(test_case_json).get("schema_version", 1)
            if type(schema) is not int or schema not in self.test_case_schema_versions:
                raise RuntimeError("agent does not support requested test case schema")
            body["test_case_json"] = test_case_json
        if input_id is not None:
            body["input_id"] = input_id
        if gesture is not None:
            if self.input_schema_version < 2:
                raise RuntimeError("agent does not support gesture input schema 2")
            body["gesture"] = gesture
        response = self._exchange(MessageType.COMMAND, body)
        return _decode_json(response.payload)

    def upload_file(
        self,
        path: Path,
        manifest: ArtifactManifest,
        *,
        upload_id: str,
        chunk_size: int = MAX_UPLOAD_CHUNK_SIZE,
        progress: Callable[[int, int], None] | None = None,
    ) -> dict[str, Any]:
        if not 1 <= chunk_size <= MAX_UPLOAD_CHUNK_SIZE:
            raise ValueError("chunk_size is outside the supported range")
        source = Path(path)
        if source.stat().st_size != manifest.length:
            raise ValueError("artifact file length does not match the manifest")
        if source.suffix.lower() == ".vvg" or manifest.artifact_kind == "game.vvg":
            from ..game_package import validate_game_package
            package = validate_game_package(source, require_extension=False)
            contract = package.manifest.inputs
            volume = package.manifest.volume_inputs
            if volume is not None and (
                type(self.game_sdk) is not dict or self.game_sdk.get("major") != package.manifest.sdk_major
                or type(self.game_sdk.get("minor")) is not int or self.game_sdk["minor"] < package.manifest.sdk_minor
                or volume.schema not in self.supported_volume_schemas or self.input_schema_version < 4
            ):
                raise RuntimeError("agent does not support candidate SDK or volume contract")
            if contract is not None and (
                type(self.game_sdk) is not dict or self.game_sdk.get("major") != package.manifest.sdk_major
                or type(self.game_sdk.get("minor")) is not int or self.game_sdk["minor"] < package.manifest.sdk_minor
                or contract.actions_schema not in self.supported_action_schemas
            ):
                raise RuntimeError("agent does not support candidate SDK or action contract")
        begin = self.command(
            f"upload:{upload_id}:begin",
            AgentCommand.UPLOAD_BEGIN,
            upload_id=upload_id,
            manifest=manifest,
        )
        self._raise_upload_error(begin)
        transfer = begin.get("transfer")
        if not isinstance(transfer, dict) or type(transfer.get("received_length")) is not int:
            raise RuntimeError("agent returned an invalid upload snapshot")
        offset = transfer["received_length"]
        if progress is not None:
            progress(offset, manifest.length)
        with source.open("rb") as stream:
            stream.seek(offset)
            while chunk := stream.read(chunk_size):
                chunk_sha256 = hashlib.sha256(chunk).hexdigest()
                result = self.command(
                    f"upload:{upload_id}:chunk:{offset}:{chunk_sha256}",
                    AgentCommand.UPLOAD_CHUNK,
                    upload_id=upload_id,
                    offset=offset,
                    chunk_sha256=chunk_sha256,
                    payload=chunk,
                )
                self._raise_upload_error(result)
                offset += len(chunk)
                if progress is not None:
                    progress(offset, manifest.length)
        committed = self.command(
            f"upload:{upload_id}:commit",
            AgentCommand.UPLOAD_COMMIT,
            upload_id=upload_id,
        )
        self._raise_upload_error(committed)
        return committed

    @staticmethod
    def _raise_upload_error(result: dict[str, Any]) -> None:
        if result.get("ok") is not True:
            raise RuntimeError(str(result.get("message", "artifact upload failed")))

    def receive(self) -> ProtocolFrame:
        if self._pending:
            return self._pending.popleft()
        sock = self._require_socket()
        while True:
            chunk = sock.recv(64 * 1024)
            if not chunk:
                raise ConnectionError("agent disconnected")
            self._pending.extend(self._decoder.feed(chunk))
            if self._pending:
                return self._pending.popleft()

    def _exchange(self, message_type: MessageType, body: dict[str, Any]) -> ProtocolFrame:
        self._sequence += 1
        request = ProtocolFrame(message_type, _encode_json(body), sequence=self._sequence)
        self._require_socket().sendall(request.to_bytes())
        deferred: list[ProtocolFrame] = []
        try:
            while True:
                response = self.receive()
                if response.message_type is MessageType.DATA:
                    deferred.append(response)
                    continue
                if response.sequence != request.sequence:
                    raise RuntimeError("agent response sequence mismatch")
                if response.message_type is MessageType.ERROR:
                    raise RuntimeError(_decode_json(response.payload).get("message", "agent error"))
                return response
        finally:
            self._pending.extendleft(reversed(deferred))

    def _require_socket(self) -> socket.socket:
        if self._socket is None:
            raise ConnectionError("client is not connected")
        return self._socket


def _encode_json(body: dict[str, Any]) -> bytes:
    return json.dumps(body, sort_keys=True, separators=(",", ":")).encode("utf-8")


def _decode_json(payload: bytes) -> dict[str, Any]:
    body = json.loads(payload.decode("utf-8"))
    if not isinstance(body, dict):
        raise ValueError("JSON payload must be an object")
    return body