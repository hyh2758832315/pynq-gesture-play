"""Owned snapshots: slow optional transfer never blocks the recognition caller."""
import json,os,sys,threading,time
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import Mock,patch
import numpy as np
import pytest
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'subprojects/ps_ui_r23b2/python'))
from pynq_multimodal_game.vision_preview import ProcessPreviewEncoder,PreviewSnapshot

class EncodeProbe:
    def __call__(self,snapshot,mode):
        return json.dumps(dict(frame=snapshot.frame,mask=int(snapshot.result['mask'][0,0]),
            tag=snapshot.result['tag'],rgb=int(snapshot.result['_preview_capture']['rgb'][0]),
            pid=os.getpid())).encode()

def wait_until(predicate,seconds=5):
    end=time.monotonic()+seconds
    while not predicate():
        assert time.monotonic()<end,'condition deadline'
        time.sleep(.01)

def test_slow_transfer_runs_on_existing_relay_keeps_only_latest_and_owns_arrays():
    received=[];entered=threading.Event();release=threading.Event()
    worker=ProcessPreviewEncoder(lambda:frozenset({'video'}),EncodeProbe(),
        lambda _,payload:received.append(json.loads(payload)))
    original=worker._write_chunks;main=threading.get_ident();first=[True]
    def gated(*args,**kwargs):
        assert threading.get_ident()!=main,'large transfer ran on recognition caller'
        if first[0]:
            first[0]=False;entered.set();assert release.wait(5)
        return original(*args,**kwargs)
    worker._write_chunks=gated
    mask=np.full((360,640),7,np.uint8);rgb=bytes([31])*(1280*720*3)
    result=dict(mask=mask,tag='before',_preview_capture=dict(rgb=rgb))
    def offer(frame):
        return worker.submit_deferred(lambda modes:PreviewSnapshot(frame,modes,None,result,{}),now=frame)
    try:
        assert offer(1);assert entered.wait(5)
        assert not worker.idle()  # Local relay handoff has not reached a slot yet.
        mask[:]=22;result['tag']='after'
        assert offer(2) and offer(3)
        assert worker._pending_transfer is not None
        assert worker.stats()['deferred_pending']==1
        assert worker.stats()['deferred_replaced']==1
        assert any(value.obj is rgb for value in worker._pending_transfer[0])
        assert not received
        release.set();wait_until(lambda:any(value['frame']==3 for value in received))
        assert received[-1]['frame']==3 and received[-1]['mask']==22
        assert received[-1]['tag']=='after' and received[-1]['rgb']==31
        assert all(value['frame']!=2 for value in received)
        for value in received:
            assert value['pid']==worker.stats()['codec_pid']!=os.getpid()
            if value['frame']==1:assert value['mask']==7 and value['tag']=='before'
    finally:
        release.set();worker.close()
    assert worker.health().cleanup=='CLEAN' and worker.stats()['deferred_pending']==0

def test_cancelled_chunk_copy_invalidates_old_slot_header():
    worker=ProcessPreviewEncoder.__new__(ProcessPreviewEncoder)
    worker._transfer_lock=threading.Lock();worker._slots=[threading.Lock(),threading.Lock()]
    worker._sequence=0;worker._received_sequence=0;worker._headers=[2,16,0,0]
    worker._slot_bytes=1024*1024;worker._memory=SimpleNamespace(buf=bytearray(2*worker._slot_bytes))
    worker._stats={'replaced':0};worker._stop=threading.Event();worker._wake=Mock()
    with patch('pynq_multimodal_game.vision_preview.time.sleep',side_effect=lambda _:worker._stop.set()):
        assert not worker._write_chunks([bytes(512*1024)],512*1024,cooperative=True)
    assert worker._headers[:2]==[0,0]
    assert worker._sequence==0
    worker._wake.release.assert_not_called()

def test_deferred_rejects_mutable_rgb_and_skips_unsubscribed_factory():
    demand=[frozenset({'video'})]
    worker=ProcessPreviewEncoder(lambda:demand[0],EncodeProbe(),lambda *_:None)
    try:
        assert not worker.submit_deferred(lambda modes:PreviewSnapshot(1,modes,None,
            {'_preview_capture':{'rgb':bytearray(8)}},{}),now=1.)
        assert worker.stats()['errors']==1
        demand[0]=frozenset()
        assert not worker.submit_deferred(lambda _:pytest.fail('unsubscribed copy'),now=2.)
        assert worker._pending_transfer is None
    finally:worker.close()


class BlockVideoAfterDebug:
    def __init__(self,entered,release):self.entered,self.release=entered,release
    def __call__(self,snapshot,mode):
        if mode=='video':
            self.entered.set()
            if not self.release.wait(5):raise TimeoutError('test release missing')
        return b'jpeg'

def test_idle_waits_for_all_modes_even_after_first_mode_acked_same_sequence():
    import multiprocessing
    context=multiprocessing.get_context('spawn');entered=context.Event();release=context.Event()
    worker=ProcessPreviewEncoder(lambda:frozenset({'video','debug'}),
        BlockVideoAfterDebug(entered,release),lambda *_:None)
    try:
        assert worker.submit(lambda modes:PreviewSnapshot(1,modes,None,None,None))
        assert entered.wait(5)
        wait_until(lambda:worker.stats()['encoded']>=1)
        assert worker.stats()['pending']==0
        assert not worker.idle(),'debug acknowledgement hid ongoing video encoding'
        release.set();wait_until(worker.idle)
    finally:release.set();worker.close()
