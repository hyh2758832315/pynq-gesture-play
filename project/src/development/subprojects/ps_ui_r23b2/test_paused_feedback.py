"""Real paused workers: repaint UI only, never advance playback or steal a modal."""
import threading
import time
from types import SimpleNamespace
import pytest

from subprojects.ps_ui_r23b2.test_pause_closure import game_root, Sink
from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
from pynq_multimodal_game.agent.c6i_shell import _BorrowedSink
from pynq_multimodal_game.agent.video_runtime import C6IVideoRuntimeBackend
from pynq_multimodal_game.agent.core import ArtifactManifest
from pynq_multimodal_game.return_button import add_return_to_game_frame
from pynq_multimodal_game.video_codec import encode_rgb_frames,S2V1_WIDTH,S2V1_HEIGHT

def until(predicate):
    end=time.monotonic()+2
    while not predicate() and time.monotonic()<end:time.sleep(.01)
    assert predicate()

def test_paused_game_redraws_ring_without_tick_resources_or_modal_writes(game_root):
    progress=[None];sink=Sink()
    game=PackagedGameRuntime(game_root/'seed_games/game2.vvg',sink,
        scene_transform=lambda f:add_return_to_game_frame(f,progress[0]))
    try:
        game.start();game.pause()
        tick=game.tick_id;count=game.presented_frames;sink.events.clear()
        progress[0]=.5
        until(lambda:len(sink.events)>0)
        assert {x[0] for x in sink.events}=={'scene'}
        assert game.tick_id==tick and game.presented_frames==count
        n=len(sink.events);time.sleep(.12);assert len(sink.events)==n
        progress[0]=None;until(lambda:len(sink.events)>n)
        game.pause(keep_source_live=True);sink.events.clear();progress[0]=1.
        time.sleep(.12);assert not sink.events  # shell modal now owns the GPU
    finally:game.stop()

def test_paused_video_redraws_ring_without_advancing_frames_or_resources(tmp_path):
    path=tmp_path/'video.s2v'
    encode_rgb_frames([bytes((8,16,24))*(S2V1_WIDTH*S2V1_HEIGHT)],path)
    manifest=ArtifactManifest.for_path(path,artifact_kind='video.s2v',
        target_build_id=0xC0061000,abi_major=1,abi_minor=0)
    progress=[None];sink=Sink()
    runtime=C6IVideoRuntimeBackend(SimpleNamespace(build_id=0xC0061000),
        sink_factory=lambda *_:_BorrowedSink(sink,return_button=True,
            video_palette=True,return_progress=lambda:progress[0]))
    try:
        runtime.stage_file(manifest,path);runtime.activate();runtime.run()
        until(lambda:runtime.stats.presented_frames>0);runtime.pause();time.sleep(.07)
        count=runtime.stats.presented_frames;sink.events.clear();progress[0]=.5
        until(lambda:bool(sink.events))
        assert {x[0] for x in sink.events}=={'scene'}
        assert runtime.stats.presented_frames==count
        n=len(sink.events);time.sleep(.12);assert len(sink.events)==n
        progress[0]=None;until(lambda:len(sink.events)>n)
        assert runtime.stats.presented_frames==count
    finally:runtime.stop()

def test_source_failure_remains_fault_even_with_confirmed_release():
    from pynq_multimodal_game.hand_serial_session import SerialHandActionSession
    receipt=dict(receiver_stop='stale_source',stop_reason='missing_source')
    error=SerialHandActionSession._child_source_error(receipt,expected_stop=True)
    assert 'stale_source' in error
    owner=SerialHandActionSession.__new__(SerialHandActionSession)
    owner.error=error;owner._release_confirmed=True;owner._source_stop_reason='stale_source'
    owner._stop=threading.Event();owner.finished=threading.Event();owner.finished.set()
    owner.feed=SimpleNamespace(revoked=None,revoke=lambda _:None)
    owner._thread=None;owner._child=None;owner._active=True;owner.seconds=None;owner.session='s'
    owner.approval_seconds=None;owner._preview_requested=None;owner._preview_allowed=False
    owner.gate=SimpleNamespace(passed=True)
    owner.close()  # proven OFF allows cleanup without retaining a harmless parent
    assert owner.status()['phase']=='FAULT' and owner.status()['release_confirmed'] is True
    owner._release_confirmed=False
    with pytest.raises(RuntimeError,match='stale_source'):owner.close()
    normal=dict(receiver_stop='producer_revoked',stop_reason='missing_source')
    assert SerialHandActionSession._child_source_error(normal,expected_stop=True) is None
    assert SerialHandActionSession._child_source_error(normal,expected_stop=False) is not None
