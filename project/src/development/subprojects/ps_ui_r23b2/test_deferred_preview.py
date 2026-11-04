"""Video/debug preparation stays off the recognition thread; pixels unchanged."""
import importlib.util
import pickle
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch
import numpy as np
import pytest
from pynq_multimodal_game.vision_preview import PreviewSnapshot

@pytest.fixture
def runtime():
    path=Path(__file__).parent/'board/pynq_z2/scripts/vision_async_runtime.py'
    spec=importlib.util.spec_from_file_location('r27_deferred_runtime',path)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    return module

@pytest.mark.parametrize('rotate,mirror',[(0,False),(180,False),(180,True)])
@pytest.mark.parametrize('debug',[False,True])
def test_deferred_video_and_debug_match_eager_bytes_without_rgb_work_in_recognition(runtime,rotate,mirror,debug):
    m=runtime;pixels=np.arange(720*1280*3,dtype=np.uint8).reshape(720,1280,3)
    mask=np.zeros((360,640),dtype=np.uint8);mask[80:220,200:340]=255
    filtered=m.cv2.GaussianBlur(m.cv2.dilate(mask,np.ones((3,3),np.uint8),iterations=4),(5,5),100)
    frame=SimpleNamespace(raw=mask,filtered=filtered,rgb=pixels.tobytes())
    old=m.DualMaskFullFrameTracker(dilate_iterations=4);old.debug_enabled=debug
    rgb,expected=m.process_dual_capture(frame,old,rotate,mirror,capture_order='bgr',preview_rgb=True)
    expected['preview_needs_annotation']=True
    expected_snapshot=PreviewSnapshot(1,frozenset({'video','debug'} if debug else {'video'}),rgb,expected,{})
    expected_jpeg=m.encode_preview_snapshot(expected_snapshot,'video')
    current=m.DualMaskFullFrameTracker(dilate_iterations=4);current.debug_enabled=debug;seen=[]
    with patch.object(m.cv2,'resize',side_effect=AssertionError('RGB resize in recognition')), \
         patch.object(m.cv2,'cvtColor',side_effect=AssertionError('RGB color conversion in recognition')):
        deferred,result=m.process_dual_capture(frame,current,rotate,mirror,capture_order='bgr',
            preview_rgb=True,defer_preview=True,on_result=seen.append)
    assert seen==[result]
    assert deferred is None
    assert 'debug_images' not in result
    for key in ('code','stable','rps','bbox','centroid','pixel_stats'):assert result[key]==expected[key]
    result['preview_needs_annotation']=True
    snapshot=PreviewSnapshot(1,expected_snapshot.modes,deferred,result,{})
    # The real codec unpickles from a bounded 4 MB shared-memory slot.
    data=pickle.dumps(snapshot,protocol=pickle.HIGHEST_PROTOCOL)
    assert len(data)<4_000_000
    actual=pickle.loads(data)
    assert m.encode_preview_snapshot(actual,'video')==expected_jpeg
    if debug:
        assert np.array_equal(actual.result['debug_images']['input'],expected['debug_images']['input'])
        assert np.array_equal(actual.result['debug_images']['skin'],expected['debug_images']['skin'])
        assert actual.result['debug_images']['defects']==expected['debug_images']['defects']


@pytest.mark.parametrize('deferred_transfer',[False,True])
def test_live_worker_wires_deferred_same_frame_snapshot(runtime,deferred_transfer):
    m=runtime;mask=np.zeros((360,640),dtype=np.uint8)
    frame=SimpleNamespace(frame_id=1,raw=mask,filtered=mask,rgb=bytes(720*1280*3))
    published=[];snapshots=[]
    class Encoder:
        def due_modes(self):return frozenset({'video'})
        def submit(self,factory):
            assert len(published)==1
            snapshots.append(factory(self.due_modes()))
    if deferred_transfer:
        Encoder.submit_deferred=Encoder.submit
        def forbidden_submit(*args):raise AssertionError('recognition attempted immediate full-frame transfer')
        Encoder.submit=forbidden_submit
    hardware=SimpleNamespace(read=lambda:frame,state='RUNNING')
    provider=SimpleNamespace(publish=lambda packet,**_:published.append(packet))
    controller=SimpleNamespace(update=lambda result,frame_id,now:dict(frame_id=frame_id,valid=False))
    worker=m.SharedDualMaskWorker(hardware,m.DualMaskFullFrameTracker(dilate_iterations=4),
        controller,provider,run_id='live',preview_encoder=Encoder())
    with patch.object(m.cv2,'resize',side_effect=AssertionError('RGB resize on worker')):
        worker.step()
    assert worker.diagnostic_error is None
    assert len(snapshots)==1
    assert snapshots[0].frame==published[0]['frame']==1
    assert snapshots[0].rgb is None
    assert snapshots[0].result['_preview_capture']['rgb'] is frame.rgb
