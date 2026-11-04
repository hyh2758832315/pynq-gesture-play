"""Editable Studio defaults; removing a video is a persistent user choice."""
from pathlib import Path

DEFAULT_VIDEO_VERSION='v3-procedural-1'
DEFAULT_VIDEO_FILES=('test_pattern_1.mp4','test_pattern_2.mp4')
DEFAULT_VIDEO_TITLES=('VIDEO 1 TEST PATTERN','VIDEO 2 TEST PATTERN')


def default_video_paths():
    root=Path(__file__).resolve().parents[3]/'media/default_videos'
    return tuple(root/name for name in DEFAULT_VIDEO_FILES)


def initial_video_sources(settings):
    saved=list(settings.value('content/videos',[],type=list))
    if settings.value('content/default-video-version','')!=DEFAULT_VIDEO_VERSION:
        saved=list(dict.fromkeys([str(p) for p in default_video_paths()]+saved))
        settings.setValue('content/videos',saved)
        settings.setValue('content/default-video-version',DEFAULT_VIDEO_VERSION)
    return saved


def video_title(path):
    resolved=Path(path).resolve()
    for source,title in zip(default_video_paths(),DEFAULT_VIDEO_TITLES):
        if source.resolve()==resolved:return title
    return Path(path).name
