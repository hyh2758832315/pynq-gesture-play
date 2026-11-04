from __future__ import annotations

from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from enum import Enum
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import uuid


DEFAULT_LIBRARY_ROOT = Path("/home/xilinx/voice-view-game/library")
DEFAULT_MINIMUM_FREE_BYTES = 2 * 1024 * 1024 * 1024
DEFAULT_MINIMUM_FREE_FRACTION = 0.10
LIBRARY_SCHEMA_VERSION = 1
_SAFE_ID = re.compile(r"[a-z0-9][a-z0-9._-]{0,63}")
_SHA256 = re.compile(r"[0-9a-f]{64}")


class LibraryKind(str, Enum):
    GAME = "game"
    VIDEO = "video"
    IMAGE = "image"

    @property
    def directory_name(self) -> str:
        return f"{self.value}s"


@dataclass(frozen=True)
class LibraryManifest:
    schema_version: int
    item_id: str
    display_name: str
    kind: LibraryKind
    asset_path: str
    length: int
    sha256: str
    target_build_id: int
    abi_major: int
    abi_minor: int
    installed_at: str

    def __post_init__(self) -> None:
        if self.schema_version != LIBRARY_SCHEMA_VERSION:
            raise ValueError("unsupported library manifest schema")
        _validate_item_id(self.item_id)
        if not self.display_name.strip() or len(self.display_name) > 80:
            raise ValueError("display_name must contain 1-80 visible characters")
        if not isinstance(self.kind, LibraryKind):
            raise ValueError("kind must be a LibraryKind")
        _validate_relative_asset_path(self.asset_path)
        if self.length < 0:
            raise ValueError("length must be non-negative")
        if not _SHA256.fullmatch(self.sha256):
            raise ValueError("sha256 must be 64 lowercase hexadecimal characters")
        if not 0 <= self.target_build_id <= 0xFFFFFFFF:
            raise ValueError("target_build_id must fit in 32 bits")
        if not 0 <= self.abi_major <= 0xFFFF or not 0 <= self.abi_minor <= 0xFFFF:
            raise ValueError("ABI versions must fit in 16 bits")
        try:
            installed_at = datetime.fromisoformat(self.installed_at)
        except ValueError as error:
            raise ValueError("installed_at must be an ISO-8601 timestamp") from error
        if installed_at.tzinfo is None:
            raise ValueError("installed_at must include a timezone")

    def to_json(self) -> str:
        payload = asdict(self)
        payload["kind"] = self.kind.value
        return json.dumps(payload, sort_keys=True, separators=(",", ":")) + "\n"

    @classmethod
    def from_json(cls, payload: str) -> LibraryManifest:
        try:
            values = json.loads(payload)
        except json.JSONDecodeError as error:
            raise ValueError("library manifest is not valid JSON") from error
        if not isinstance(values, dict):
            raise ValueError("library manifest root must be an object")
        expected = {
            "schema_version",
            "item_id",
            "display_name",
            "kind",
            "asset_path",
            "length",
            "sha256",
            "target_build_id",
            "abi_major",
            "abi_minor",
            "installed_at",
        }
        if set(values) != expected:
            raise ValueError("library manifest fields do not match the schema")
        try:
            values["kind"] = LibraryKind(values["kind"])
            return cls(**values)
        except (TypeError, ValueError) as error:
            raise ValueError(f"invalid library manifest: {error}") from error


@dataclass(frozen=True)
class LibraryEntry:
    manifest: LibraryManifest
    directory: Path
    asset: Path


@dataclass(frozen=True)
class LibraryIssue:
    path: Path
    message: str


@dataclass(frozen=True)
class LibraryScanResult:
    entries: tuple[LibraryEntry, ...]
    issues: tuple[LibraryIssue, ...]


class AssetLibrary:
    def __init__(
        self,
        root: Path = DEFAULT_LIBRARY_ROOT,
        *,
        minimum_free_bytes: int = DEFAULT_MINIMUM_FREE_BYTES,
        minimum_free_fraction: float = DEFAULT_MINIMUM_FREE_FRACTION,
    ) -> None:
        if minimum_free_bytes < 0:
            raise ValueError("minimum_free_bytes must be non-negative")
        if not 0 <= minimum_free_fraction < 1:
            raise ValueError("minimum_free_fraction must be within [0, 1)")
        self.root = Path(root)
        self.minimum_free_bytes = minimum_free_bytes
        self.minimum_free_fraction = minimum_free_fraction

    @property
    def staging_directory(self) -> Path:
        return self.root / ".staging"

    def initialize(self) -> None:
        self.root.mkdir(parents=True, exist_ok=True)
        for kind in LibraryKind:
            (self.root / kind.directory_name).mkdir(exist_ok=True)
        self.staging_directory.mkdir(exist_ok=True)
        for candidate in self.staging_directory.iterdir():
            if candidate.is_dir() and not candidate.is_symlink():
                shutil.rmtree(candidate)
            else:
                candidate.unlink(missing_ok=True)

    def install_file(
        self,
        source: Path,
        *,
        item_id: str,
        display_name: str,
        kind: LibraryKind,
        target_build_id: int,
        abi_major: int = 1,
        abi_minor: int = 0,
        installed_at: datetime | None = None,
        replace: bool = False,
    ) -> LibraryEntry:
        self.initialize()
        _validate_item_id(item_id)
        source = Path(source)
        if not source.is_file() or source.is_symlink():
            raise ValueError("source must be a regular file")
        kind = LibraryKind(kind)
        destination = self.root / kind.directory_name / item_id
        if destination.is_symlink():
            raise ValueError("library destination must not be a symbolic link")
        if destination.exists() and not replace:
            raise FileExistsError(destination)
        source_length = source.stat().st_size
        self._require_space(source_length)
        stage = self.staging_directory / uuid.uuid4().hex
        stage.mkdir()
        backup: Path | None = None
        try:
            asset_name = _safe_asset_name(source.name)
            staged_asset = stage / asset_name
            digest = _copy_with_digest(source, staged_asset)
            timestamp = installed_at or datetime.now(timezone.utc)
            manifest = LibraryManifest(
                schema_version=LIBRARY_SCHEMA_VERSION,
                item_id=item_id,
                display_name=display_name,
                kind=kind,
                asset_path=asset_name,
                length=source_length,
                sha256=digest,
                target_build_id=target_build_id,
                abi_major=abi_major,
                abi_minor=abi_minor,
                installed_at=timestamp.isoformat(),
            )
            _write_text(stage / "manifest.json", manifest.to_json())
            if destination.exists():
                backup = self.staging_directory / uuid.uuid4().hex
                os.replace(destination, backup)
            try:
                os.replace(stage, destination)
                installed = self._load_entry(destination, expected_kind=kind)
            except BaseException:
                if destination.exists():
                    shutil.rmtree(destination, ignore_errors=True)
                if backup is not None and backup.exists():
                    os.replace(backup, destination)
                raise
            if backup is not None:
                shutil.rmtree(backup, ignore_errors=True)
            return installed
        finally:
            if stage.exists():
                shutil.rmtree(stage, ignore_errors=True)
            if backup is not None and backup.exists():
                shutil.rmtree(backup, ignore_errors=True)

    def remove(self, kind: LibraryKind, item_id: str) -> None:
        kind = LibraryKind(kind)
        _validate_item_id(item_id)
        destination = self.root / kind.directory_name / item_id
        if destination.is_symlink():
            raise ValueError("library entry must not be a symbolic link")
        if not destination.is_dir():
            raise FileNotFoundError(destination)
        shutil.rmtree(destination)

    def scan(self, kind: LibraryKind | None = None) -> LibraryScanResult:
        self.initialize()
        kinds = tuple(LibraryKind) if kind is None else (LibraryKind(kind),)
        entries: list[LibraryEntry] = []
        issues: list[LibraryIssue] = []
        for current_kind in kinds:
            directory = self.root / current_kind.directory_name
            for candidate in sorted(directory.iterdir(), key=lambda path: path.name):
                try:
                    entries.append(
                        self._load_entry(candidate, expected_kind=current_kind)
                    )
                except (OSError, ValueError) as error:
                    issues.append(LibraryIssue(candidate, str(error)))
        entries.sort(key=lambda entry: (entry.manifest.display_name.casefold(), entry.manifest.item_id))
        return LibraryScanResult(tuple(entries), tuple(issues))

    def _load_entry(self, directory: Path, *, expected_kind: LibraryKind) -> LibraryEntry:
        if directory.is_symlink() or not directory.is_dir():
            raise ValueError("library entry must be a regular directory")
        manifest_path = directory / "manifest.json"
        if manifest_path.is_symlink() or not manifest_path.is_file():
            raise ValueError("library entry has no regular manifest.json")
        manifest = LibraryManifest.from_json(manifest_path.read_text(encoding="utf-8"))
        if manifest.kind is not expected_kind:
            raise ValueError("manifest kind does not match its library directory")
        if manifest.item_id != directory.name:
            raise ValueError("manifest item_id does not match its directory")
        asset = directory / Path(PurePosixPath(manifest.asset_path))
        if asset.is_symlink() or not asset.is_file():
            raise ValueError("library asset must be a regular file")
        if asset.resolve().parent != directory.resolve():
            raise ValueError("library asset escapes its entry directory")
        if asset.stat().st_size != manifest.length:
            raise ValueError("library asset length mismatch")
        if _file_sha256(asset) != manifest.sha256:
            raise ValueError("library asset SHA-256 mismatch")
        return LibraryEntry(manifest, directory, asset)

    def _require_space(self, incoming_bytes: int) -> None:
        usage = shutil.disk_usage(self.root)
        reserve = max(
            self.minimum_free_bytes,
            int(usage.total * self.minimum_free_fraction),
        )
        if usage.free - incoming_bytes < reserve:
            raise OSError(
                f"install would reduce free space below the {reserve}-byte reserve"
            )


def _validate_item_id(item_id: str) -> None:
    if not isinstance(item_id, str) or not _SAFE_ID.fullmatch(item_id):
        raise ValueError("item_id must be 1-64 lowercase safe ASCII characters")


def _validate_relative_asset_path(asset_path: str) -> None:
    if not isinstance(asset_path, str) or not asset_path:
        raise ValueError("asset_path must not be empty")
    path = PurePosixPath(asset_path)
    if path.is_absolute() or len(path.parts) != 1 or path.parts[0] in (".", ".."):
        raise ValueError("asset_path must be a single relative filename")


def _safe_asset_name(name: str) -> str:
    if not name or name in (".", "..") or Path(name).name != name:
        raise ValueError("source filename is not safe")
    if not name.isascii() or any(character in '<>:"/\\|?*' for character in name):
        raise ValueError("source filename must use safe ASCII characters")
    return name


def _copy_with_digest(source: Path, destination: Path) -> str:
    digest = hashlib.sha256()
    with source.open("rb") as input_stream, destination.open("xb") as output_stream:
        for chunk in iter(lambda: input_stream.read(1024 * 1024), b""):
            output_stream.write(chunk)
            digest.update(chunk)
        output_stream.flush()
        os.fsync(output_stream.fileno())
    return digest.hexdigest()


def _write_text(path: Path, payload: str) -> None:
    with path.open("x", encoding="utf-8", newline="\n") as stream:
        stream.write(payload)
        stream.flush()
        os.fsync(stream.fileno())


def _file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()