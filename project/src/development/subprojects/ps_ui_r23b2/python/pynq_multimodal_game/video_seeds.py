"""Install the bundled, PC-encoded video without replacing user library content."""
from __future__ import annotations

from pathlib import Path
import hashlib
import json
from zipfile import BadZipFile

from .library import AssetLibrary, LibraryKind
from .video_codec import S2V1Reader

SEED_VIDEO_ID = "default-sunset"
SEED_VIDEO_NAME = "SUNSET"
SEED_VIDEO_PATH = f"seed_videos/{SEED_VIDEO_ID}.s2v"
BUTTON_BUILD_ID = 0xC0061000
LEGACY_VIDEO_SHA='b299cf0a2d58af811a93ea8def4c84307344dc7911bb903f4b19e1ad8bc0dff0'


def seed_video_specs(package_root):
    root=Path(package_root).resolve()
    catalog=root/'seed_videos/catalog.json'
    if not catalog.exists():
        return (dict(item_id=SEED_VIDEO_ID,display_name=SEED_VIDEO_NAME,path=SEED_VIDEO_PATH),)
    value=json.loads(catalog.read_text(encoding='utf-8'))
    specs=value.get('videos')
    if value.get('schema')!=1 or not isinstance(specs,list) or len(specs)!=2:
        raise ValueError('Default video catalog must contain exactly two videos')
    if len({s['item_id'] for s in specs})!=2:raise ValueError('Duplicate default video ID')
    for spec in specs:
        source=(root/spec['path']).resolve(strict=True)
        if not source.is_relative_to(root/'seed_videos') or source.suffix!='.s2v':
            raise ValueError('Default video path escapes package')
        digest=hashlib.sha256()
        with source.open('rb') as stream:
            for chunk in iter(lambda:stream.read(1024*1024),b''):digest.update(chunk)
        if digest.hexdigest()!=spec['sha256']:raise ValueError('Default video identity mismatch')
    return tuple(specs)


def seed_video_order():
    """Read only the tiny catalog for menu ordering; no hashing on menu refresh."""
    path=Path(__file__).resolve().parents[2]/'seed_videos/catalog.json'
    if not path.exists():return (SEED_VIDEO_ID,)
    return tuple(s['item_id'] for s in json.loads(path.read_text(encoding='utf-8'))['videos'])


def ensure_seed_videos(package_root: Path, library: AssetLibrary, *, install: bool) -> tuple[str, ...]:
    """Check-only never creates a library; normal launch installs missing content."""
    specs=seed_video_specs(package_root)
    for spec in specs:
        with S2V1Reader(Path(package_root)/spec['path']):pass
    if not install:
        return tuple(s['item_id'] for s in specs)
    existing = {entry.manifest.item_id: entry
                for entry in library.scan(LibraryKind.VIDEO).entries}
    missing=[]
    for spec in specs:
        item_id=spec['item_id']
        destination=library.root/LibraryKind.VIDEO.directory_name/item_id
        if destination.exists() or destination.is_symlink():
            entry=existing.get(item_id)
            if entry is None:raise RuntimeError('installed default video is invalid; preserve it for inspection')
            if (entry.manifest.target_build_id!=BUTTON_BUILD_ID
                    or (entry.manifest.abi_major,entry.manifest.abi_minor)!=(1,0)):
                raise RuntimeError('installed default video has the wrong runtime contract; refusing replacement')
            try:
                with S2V1Reader(entry.asset):pass
            except (OSError,ValueError,BadZipFile) as error:
                raise RuntimeError('installed default video is invalid; preserve it for inspection') from error
        else:missing.append(spec)
    for spec in missing:
        library.install_file(Path(package_root)/spec['path'],item_id=spec['item_id'],
            display_name=spec['display_name'],kind=LibraryKind.VIDEO,target_build_id=BUTTON_BUILD_ID)
    # Remove only the byte-identical old managed SUNSET after both new defaults
    # are installed. Edited/user content and the four earlier test clips survive.
    legacy=existing.get(SEED_VIDEO_ID)
    if (len(specs)==2 and legacy is not None and legacy.manifest.sha256==LEGACY_VIDEO_SHA
            and legacy.manifest.display_name==SEED_VIDEO_NAME
            and legacy.manifest.target_build_id==BUTTON_BUILD_ID):
        library.remove(LibraryKind.VIDEO,SEED_VIDEO_ID)
    return tuple(s['item_id'] for s in missing)
