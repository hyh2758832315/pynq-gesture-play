"""PC regression for the shell resume path and the RTL resource-generation gate.

Run with PYTHONPATH=subprojects/ps_ui_r23b2/python;python;.
  .venv/Scripts/python.exe -B -m pytest -q subprojects/ps_ui_r23b2/test_video_resume_resources.py
Output: assertions only; no board access. Next: Studio package and board acceptance.
"""
import struct
import threading
from types import SimpleNamespace

import pytest

from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend, ShellMode
from pynq_multimodal_game.agent.core import AgentState, ArtifactManifest
from pynq_multimodal_game.gpu_abi import unpack_resource_packet
from pynq_multimodal_game.video_codec import encode_rgb_frames


class GenerationSink:
    """Mirror c4m3 renderer_start: all three resource generations must match."""
    def __init__(self):
        self.generations = {}
        self.presented = threading.Event()
        self.failure = None
        self.uploads = []

    def upload(self, kind, packet):
        header, _ = unpack_resource_packet(packet)
        self.generations[kind] = header.generation
        self.uploads.append((kind, header.generation))

    def upload_palette(self, packet): self.upload('palette', packet)
    def upload_asset(self, packet): self.upload('asset', packet)
    def upload_tilemap(self, packet): self.upload('tilemap', packet)
    def close(self): pass
    def drain(self): pass

    def submit_scene(self, packet):
        header = struct.unpack_from('<16I', packet)
        required = dict(palette=header[8], asset=header[10], tilemap=header[11])
        if required != self.generations:
            self.failure = (required, dict(self.generations))
            raise TimeoutError(f'render completed count timeout: generations {self.failure}')
        self.presented.set()


@pytest.mark.parametrize('seek', [False, True])
def test_resume_preserves_owned_video_resources_and_can_return(tmp_path, seek):
    path = tmp_path / 'resume.s2v'
    encode_rgb_frames([bytes((8, 16, 24)) * (320 * 180)] * 4, path)
    manifest = ArtifactManifest.for_path(path, artifact_kind='video.s2v',
        target_build_id=0xC0061000, abi_major=1, abi_minor=0)
    sink = GenerationSink()
    shell = C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000), menu_fps=0)
    shell._sink = sink
    hand_pauses = []
    shell._hand_session = SimpleNamespace(set_video_paused=hand_pauses.append,
        status=lambda: dict(phase='PAUSED', preview_allowed=True))
    loading=[]
    def progress(value):
        loading.append(value)
        shell._video_loading_progress(value)
    shell._video.loading_progress=progress
    shell._video.stage_file(manifest, path)
    shell.activate()
    parked = threading.Event()
    original_wait = shell._video._wait_for_playback_slot

    def wait(*args, **kwargs):
        refresh = kwargs['paused_refresh']
        def paused_refresh():
            refresh()
            parked.set()
        kwargs['paused_refresh'] = paused_refresh
        return original_wait(*args, **kwargs)

    shell._video._wait_for_playback_slot = wait
    try:
        shell.run()
        assert sink.presented.wait(2)
        # Loading itself presents a frame; wait for the actual video worker.
        for _ in range(200):
            if shell._video.stats.presented_frames:
                break
            threading.Event().wait(.01)
        assert shell._video.stats.presented_frames
        assert loading==sorted(loading) and loading[-1]==1
        assert hand_pauses == [True]
        shell.pause()
        assert parked.wait(2)
        if seek:
            shell.seek(2)
        # Pause/resume must never upload a menu tilemap into the live video.
        before = len([u for u in sink.uploads if u[0] == 'tilemap'])
        completed_loading=list(loading)
        frames_before = shell._video.stats.presented_frames
        sink.presented.clear()
        shell.run()
        for _ in range(200):
            if sink.failure or shell._video.stats.presented_frames > frames_before:
                break
            threading.Event().wait(.01)
        assert sink.failure is None
        assert loading==completed_loading
        assert shell._video.stats.presented_frames > frames_before
        assert len([u for u in sink.uploads if u[0] == 'tilemap']) == before
        assert shell._video.snapshot.state is AgentState.RUNNING
        shell.run()  # An already-running START is also resource-preserving.
        assert hand_pauses == [True]
        assert len([u for u in sink.uploads if u[0] == 'tilemap']) == before
        shell.return_to_menu()
        assert shell.mode is ShellMode.MENU and shell._video._thread is None
        assert hand_pauses == [True, False]
        assert sink.failure is None
        # A later Studio upload validates content while the menu owns the GPU.
        # A playback loading callback must not survive into that validation.
        uploads_before=len(sink.uploads)
        threading.Event().wait(.55)
        shell.stage_file(manifest,path)
        assert len(sink.uploads)==uploads_before
        assert shell._video.loading_progress is None
    finally:
        shell.close()


def test_stop_during_video_open_validation_releases_worker_without_gpu(monkeypatch):
    import time
    from pynq_multimodal_game.agent import video_runtime as module
    entered=threading.Event()
    class Reader:
        def __init__(self,path,*,progress):
            entered.set()
            for _ in range(300):
                time.sleep(.01)
                progress(.1)
        def __enter__(self):return self
        def __exit__(self,*args):pass
    monkeypatch.setattr(module,'S2V1Reader',Reader)
    runtime=module.C6IVideoRuntimeBackend(SimpleNamespace(build_id=0xC0061000),
        timeout_seconds=.1,sink_factory=lambda *args:pytest.fail('GPU acquired after cancel'))
    runtime._active=(SimpleNamespace(sha256="test"),None)
    runtime.run()
    assert entered.wait(1)
    result=runtime.stop()
    assert runtime._thread is None and result.last_error is None
    assert result.state is AgentState.IDLE

