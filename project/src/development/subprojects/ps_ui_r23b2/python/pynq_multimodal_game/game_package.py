from __future__ import annotations

import ast
from dataclasses import asdict, dataclass
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo

try:
    import tomllib
except ModuleNotFoundError:
    import tomli as tomllib

from .game_sdk import GAME_SDK_MAJOR, GAME_SDK_MINOR
from .game_actions import ACTION_SCHEMA, valid_identity
from .scene import LOGICAL_HEIGHT, LOGICAL_WIDTH


GAME_PACKAGE_SCHEMA_VERSION = 1
GAME_PACKAGE_METADATA = "package.json"
GAME_PACKAGE_MANIFEST = "game.toml"
_SAFE_ID = re.compile(r"[a-z0-9][a-z0-9._-]{0,63}")
_SAFE_VERSION = re.compile(r"[0-9A-Za-z][0-9A-Za-z.+-]{0,31}")
_ENTRYPOINT = re.compile(
    r"src(?:\.[a-zA-Z_][a-zA-Z0-9_]*)*:[a-zA-Z_][a-zA-Z0-9_]*"
)
_ZIP_TIMESTAMP = (1980, 1, 1, 0, 0, 0)
_FORBIDDEN_IMPORT_ROOTS = {
    "ctypes",
    "multiprocessing",
    "os",
    "pathlib",
    "shutil",
    "socket",
    "subprocess",
}


@dataclass(frozen=True)
class GameInputContract:
    actions_schema: str
    policy_id: str
    vision_mapping: str
    required_audio_capabilities: tuple[str, ...] = ("audio.edges",)

    def __post_init__(self) -> None:
        if self.actions_schema != ACTION_SCHEMA or not valid_identity(self.policy_id):
            raise ValueError("unsupported actions schema or policy identity")
        if self.vision_mapping not in ("game1", "game2", "game3"):
            raise ValueError("unsupported vision mapping")
        if (type(self.required_audio_capabilities) is not tuple
                or len(self.required_audio_capabilities) > 8
                or len(set(self.required_audio_capabilities)) != len(self.required_audio_capabilities)
                or any(not valid_identity(value) for value in self.required_audio_capabilities)):
            raise ValueError("invalid audio capability list")


@dataclass(frozen=True)
class GameVolumeInputContract:
    schema: str
    vision_mapping: str

    def __post_init__(self) -> None:
        if self.schema != "volume-signal-v1" or self.vision_mapping not in ("game1", "game2", "game3"):
            raise ValueError("unsupported explicit volume input contract")


@dataclass(frozen=True)
class GameManifest:
    schema_version: int
    game_id: str
    display_name: str
    version: str
    entrypoint: str
    sdk_major: int
    sdk_minor: int
    target_build_id: int
    abi_major: int
    abi_minor: int
    tick_hz: int
    render_hz: int
    logical_width: int
    logical_height: int
    inputs: GameInputContract | None = None
    volume_inputs: GameVolumeInputContract | None = None

    def __post_init__(self) -> None:
        if self.schema_version != GAME_PACKAGE_SCHEMA_VERSION:
            raise ValueError("unsupported game package schema")
        if not _SAFE_ID.fullmatch(self.game_id):
            raise ValueError("game_id must be a safe lowercase identifier")
        if not self.display_name.strip() or len(self.display_name) > 80:
            raise ValueError("display_name must contain 1-80 visible characters")
        if not _SAFE_VERSION.fullmatch(self.version):
            raise ValueError("version must be a safe package version")
        if not _ENTRYPOINT.fullmatch(self.entrypoint):
            raise ValueError("entrypoint must use src.module:function form")
        if self.sdk_major != GAME_SDK_MAJOR or self.sdk_minor > GAME_SDK_MINOR:
            raise ValueError("game SDK version is not supported")
        if self.inputs is not None and (type(self.inputs) is not GameInputContract or self.sdk_minor < 2):
            raise ValueError("action contract requires SDK1.2")
        if self.volume_inputs is not None and (type(self.volume_inputs) is not GameVolumeInputContract
                or self.sdk_minor < 3 or self.inputs is not None):
            raise ValueError("volume input contract requires SDK1.3 and independent raw inputs")
        if not 0 <= self.target_build_id <= 0xFFFFFFFF:
            raise ValueError("target_build_id must fit in 32 bits")
        if self.abi_major != 1 or self.abi_minor > 0:
            raise ValueError("GPU ABI version is not supported")
        if self.tick_hz <= 0 or self.render_hz <= 0:
            raise ValueError("tick and render rates must be positive")
        if self.logical_width != LOGICAL_WIDTH or self.logical_height != LOGICAL_HEIGHT:
            raise ValueError("game logical resolution is not supported")

    @classmethod
    def from_toml(cls, payload: bytes) -> GameManifest:
        try:
            root = tomllib.loads(payload.decode("utf-8"))
            package = root["package"]
            runtime = root["runtime"]
            target = root["target"]
            inputs = root.get("inputs")
            volume = root.get("volume")
            if volume is not None:
                if type(volume) is not dict or set(volume) != {"schema", "vision_mapping"}:
                    raise ValueError("invalid volume contract fields")
                volume = GameVolumeInputContract(volume["schema"], volume["vision_mapping"])
            if inputs is not None:
                if type(inputs) is not dict or set(inputs) - {
                    "actions_schema", "policy_id", "vision_mapping", "required_audio_capabilities"
                }:
                    raise ValueError("invalid input contract fields")
                inputs = GameInputContract(
                    inputs["actions_schema"], inputs["policy_id"], inputs["vision_mapping"],
                    tuple(inputs.get("required_audio_capabilities", ["audio.edges"])),
                )
            return cls(
                schema_version=package["schema_version"],
                game_id=package["id"],
                display_name=package["display_name"],
                version=package["version"],
                entrypoint=package["entrypoint"],
                sdk_major=runtime["sdk_major"],
                sdk_minor=runtime["sdk_minor"],
                target_build_id=target["build_id"],
                abi_major=target["abi_major"],
                abi_minor=target["abi_minor"],
                tick_hz=runtime["tick_hz"],
                render_hz=runtime["render_hz"],
                logical_width=runtime["logical_width"],
                logical_height=runtime["logical_height"],
                inputs=inputs,
                volume_inputs=volume,
            )
        except (KeyError, TypeError, UnicodeDecodeError, tomllib.TOMLDecodeError) as error:
            raise ValueError(f"invalid game manifest: {error}") from error


@dataclass(frozen=True)
class GamePackageInfo:
    path: Path
    manifest: GameManifest
    length: int
    sha256: str
    files: tuple[str, ...]


def canonical_manifest(manifest: GameManifest) -> dict:
    payload = asdict(manifest)
    if manifest.volume_inputs is None:
        payload.pop("volume_inputs")
    if manifest.inputs is None:
        payload.pop("inputs")
    else:
        payload["inputs"]["required_audio_capabilities"] = list(manifest.inputs.required_audio_capabilities)
    return payload


class GamePackageBuilder:
    def build(self, project_root: Path, output: Path, *, target_build_id: int | None = None) -> GamePackageInfo:
        project_root = Path(project_root).resolve()
        manifest_path = project_root / GAME_PACKAGE_MANIFEST
        if not manifest_path.is_file() or manifest_path.is_symlink():
            raise ValueError("game project has no regular game.toml")
        files = _collect_project_files(project_root)
        if target_build_id is not None:
            import tomli_w

            if type(target_build_id) is not int or not 0 <= target_build_id <= 0xFFFFFFFF:
                raise ValueError("target BUILD_ID must fit uint32")
            document = tomllib.loads(files[GAME_PACKAGE_MANIFEST].decode("utf-8"))
            document["target"]["build_id"] = target_build_id
            files[GAME_PACKAGE_MANIFEST] = tomli_w.dumps(document).encode("utf-8")
        manifest = GameManifest.from_toml(files[GAME_PACKAGE_MANIFEST])
        _validate_entrypoint(manifest, files)
        for name, payload in files.items():
            if name.endswith(".py"):
                _validate_python(name, payload)
        metadata = _metadata_payload(manifest, files)
        package_files = {**files, GAME_PACKAGE_METADATA: metadata}
        output = Path(output)
        if output.suffix.lower() != ".vvg":
            raise ValueError("game package output must use the .vvg extension")
        output.parent.mkdir(parents=True, exist_ok=True)
        temporary = output.with_name(f".{output.name}.tmp")
        try:
            with ZipFile(temporary, "w") as archive:
                for name in sorted(package_files):
                    info = ZipInfo(name, date_time=_ZIP_TIMESTAMP)
                    info.create_system = 0
                    info.compress_type = ZIP_DEFLATED
                    info.external_attr = 0o100644 << 16
                    archive.writestr(info, package_files[name], compresslevel=9)
            temporary.replace(output)
        finally:
            temporary.unlink(missing_ok=True)
        return validate_game_package(output)


def validate_game_package(
    path: Path, *, require_extension: bool = True
) -> GamePackageInfo:
    path = Path(path)
    if not path.is_file() or path.is_symlink():
        raise ValueError("game package must be a regular file")
    if require_extension and path.suffix.lower() != ".vvg":
        raise ValueError("game package must use the .vvg extension")
    with ZipFile(path, "r") as archive:
        names = [entry.filename for entry in archive.infolist()]
        if len(names) != len(set(names)):
            raise ValueError("game package contains duplicate paths")
        for entry in archive.infolist():
            _validate_archive_path(entry.filename)
            mode = entry.external_attr >> 16
            if mode and mode & 0o170000 not in (0, 0o100000):
                raise ValueError("game package contains a non-regular entry")
        if GAME_PACKAGE_MANIFEST not in names or GAME_PACKAGE_METADATA not in names:
            raise ValueError("game package is missing required metadata")
        payloads = {name: archive.read(name) for name in names}
    manifest = GameManifest.from_toml(payloads.pop(GAME_PACKAGE_MANIFEST))
    try:
        metadata = json.loads(payloads.pop(GAME_PACKAGE_METADATA))
    except (UnicodeDecodeError, json.JSONDecodeError) as error:
        raise ValueError("game package metadata is invalid") from error
    manifest_payload = canonical_manifest(manifest)
    if metadata.get("schema_version") != GAME_PACKAGE_SCHEMA_VERSION:
        raise ValueError("game package metadata schema is not supported")
    if metadata.get("manifest") != manifest_payload:
        raise ValueError("game package manifest metadata does not match")
    file_hashes = metadata.get("files")
    actual_payloads = {GAME_PACKAGE_MANIFEST: _read_member(path, GAME_PACKAGE_MANIFEST), **payloads}
    if not isinstance(file_hashes, dict) or set(file_hashes) != set(actual_payloads):
        raise ValueError("game package file inventory does not match")
    for name, payload in actual_payloads.items():
        if file_hashes[name] != _sha256(payload):
            raise ValueError(f"game package hash mismatch for {name}")
    _validate_entrypoint(manifest, actual_payloads)
    return GamePackageInfo(
        path=path,
        manifest=manifest,
        length=path.stat().st_size,
        sha256=_sha256(path.read_bytes()),
        files=tuple(sorted(actual_payloads)),
    )


def extract_game_package(
    path: Path, destination: Path, *, require_extension: bool = True
) -> GamePackageInfo:
    info = validate_game_package(path, require_extension=require_extension)
    destination = Path(destination)
    destination.mkdir(parents=True, exist_ok=True)
    if any(destination.iterdir()):
        raise ValueError("game extraction directory must be empty")
    with ZipFile(path, "r") as archive:
        for entry in archive.infolist():
            target = destination.joinpath(*PurePosixPath(entry.filename).parts)
            target.parent.mkdir(parents=True, exist_ok=True)
            flags = os.O_WRONLY | os.O_CREAT | os.O_EXCL
            descriptor = os.open(target, flags, 0o600)
            with os.fdopen(descriptor, "wb") as stream:
                stream.write(archive.read(entry.filename))
    return info


def _collect_project_files(root: Path) -> dict[str, bytes]:
    files: dict[str, bytes] = {}
    for candidate in sorted(root.rglob("*")):
        if candidate.is_symlink():
            raise ValueError("game project must not contain symbolic links")
        if not candidate.is_file():
            continue
        relative = candidate.relative_to(root).as_posix()
        _validate_archive_path(relative)
        if not _include_project_file(relative):
            raise ValueError(f"game project contains unsupported file {relative}")
        files[relative] = candidate.read_bytes()
    if not any(name.startswith("src/") and name.endswith(".py") for name in files):
        raise ValueError("game project must contain Python source under src/")
    return files


def _include_project_file(name: str) -> bool:
    return (
        name == GAME_PACKAGE_MANIFEST
        or name == "thumbnail.png"
        or (name.startswith("src/") and name.endswith(".py"))
        or name.startswith("assets/")
        or name.startswith("tests/replays/")
    )


def _validate_archive_path(name: str) -> None:
    if "\\" in name:
        raise ValueError("game package paths must use forward slashes")
    path = PurePosixPath(name)
    if path.is_absolute() or not path.parts or any(part in ("", ".", "..") for part in path.parts):
        raise ValueError("game package contains an unsafe path")


def _validate_entrypoint(manifest: GameManifest, files: dict[str, bytes]) -> None:
    module_name, _factory = manifest.entrypoint.split(":", 1)
    source_name = module_name.replace(".", "/") + ".py"
    package_name = module_name.replace(".", "/") + "/__init__.py"
    if source_name not in files and package_name not in files:
        raise ValueError("game entrypoint module is missing")


def _validate_python(name: str, payload: bytes) -> None:
    try:
        source = payload.decode("utf-8")
        tree = ast.parse(source, filename=name)
    except (UnicodeDecodeError, SyntaxError) as error:
        raise ValueError(f"invalid Python source {name}: {error}") from error
    for node in ast.walk(tree):
        modules: tuple[str, ...] = ()
        if isinstance(node, ast.Import):
            modules = tuple(alias.name for alias in node.names)
        elif isinstance(node, ast.ImportFrom) and node.module:
            modules = (node.module,)
        for module in modules:
            if module.split(".", 1)[0] in _FORBIDDEN_IMPORT_ROOTS:
                raise ValueError(f"forbidden import {module!r} in {name}")


def _metadata_payload(manifest: GameManifest, files: dict[str, bytes]) -> bytes:
    metadata = {
        "schema_version": GAME_PACKAGE_SCHEMA_VERSION,
        "manifest": canonical_manifest(manifest),
        "files": {name: _sha256(payload) for name, payload in sorted(files.items())},
    }
    return (json.dumps(metadata, sort_keys=True, separators=(",", ":")) + "\n").encode()


def _read_member(path: Path, name: str) -> bytes:
    with ZipFile(path, "r") as archive:
        return archive.read(name)


def _sha256(payload: bytes) -> str:
    return hashlib.sha256(payload).hexdigest()
