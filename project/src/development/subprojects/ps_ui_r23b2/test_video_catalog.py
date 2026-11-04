"""Both bundled defaults validate before installation; user edits survive."""
import hashlib
import json
import pytest
from pynq_multimodal_game.library import AssetLibrary,LibraryKind
from pynq_multimodal_game.video_codec import encode_rgb_frames
from pynq_multimodal_game import video_seeds


def catalog(tmp_path):
    root=tmp_path/'package';folder=root/'seed_videos';folder.mkdir(parents=True)
    specs=[]
    for n in (1,2):
        path=folder/f'default-{n}.s2v'
        encode_rgb_frames([bytes((n*60,20,30))*57600],path)
        specs.append(dict(item_id=f'default-{n}',display_name=f'VIDEO {n}',
            path='seed_videos/'+path.name,sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
    (folder/'catalog.json').write_text(json.dumps(dict(schema=1,videos=specs)),encoding='utf-8')
    return root,AssetLibrary(tmp_path/'library',minimum_free_bytes=0,minimum_free_fraction=0)


def test_two_defaults_check_only_then_idempotent_install(tmp_path):
    root,library=catalog(tmp_path)
    assert video_seeds.ensure_seed_videos(root,library,install=False)==('default-1','default-2')
    assert not library.root.exists()
    assert video_seeds.ensure_seed_videos(root,library,install=True)==('default-1','default-2')
    assert video_seeds.ensure_seed_videos(root,library,install=True)==()
    assert len(library.scan(LibraryKind.VIDEO).entries)==2


def test_invalid_second_video_prevents_all_installation(tmp_path):
    root,library=catalog(tmp_path)
    (root/'seed_videos/default-2.s2v').write_bytes(b'bad')
    with pytest.raises(ValueError,match='identity mismatch'):
        video_seeds.ensure_seed_videos(root,library,install=True)
    assert not library.root.exists()


def test_legacy_cleanup_only_removes_known_managed_video_and_preserves_custom(tmp_path,monkeypatch):
    root,library=catalog(tmp_path)
    source=root/'seed_videos/default-1.s2v'
    digest=hashlib.sha256(source.read_bytes()).hexdigest()
    monkeypatch.setattr(video_seeds,'LEGACY_VIDEO_SHA',digest)
    library.install_file(source,item_id='default-sunset',display_name='SUNSET',kind=LibraryKind.VIDEO,target_build_id=0xC0061000)
    video_seeds.ensure_seed_videos(root,library,install=True)
    assert 'default-sunset' not in {e.manifest.item_id for e in library.scan(LibraryKind.VIDEO).entries}
    library.install_file(source,item_id='default-sunset',display_name='User renamed',kind=LibraryKind.VIDEO,target_build_id=0xC0061000)
    video_seeds.ensure_seed_videos(root,library,install=True)
    assert 'default-sunset' in {e.manifest.item_id for e in library.scan(LibraryKind.VIDEO).entries}
