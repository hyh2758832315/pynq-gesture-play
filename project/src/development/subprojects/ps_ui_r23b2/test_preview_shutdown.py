"""A codec finishing a large send must be drained during normal shutdown."""
from functools import partial
import multiprocessing
from threading import Thread
import time
from pynq_multimodal_game.vision_preview import ProcessPreviewEncoder,PreviewSnapshot

def encode_after_release(entered,release,snapshot,mode):
    entered.set()
    if not release.wait(10):raise RuntimeError('test release timed out')
    return b'x'*(2*1024*1024)

def test_shutdown_drains_an_encode_finishing_after_relay_stop():
    context=multiprocessing.get_context('spawn')
    entered,release=context.Event(),context.Event()
    delivered=[];failures=[]
    worker=ProcessPreviewEncoder(lambda:frozenset({'video'}),
        partial(encode_after_release,entered,release),lambda *a:delivered.append(a))
    try:
        assert worker.submit(lambda modes:PreviewSnapshot(1,modes,None,None,None))
        assert entered.wait(5)
        def close():
            try:worker.close(timeout=2)
            except Exception as error:failures.append(error)
        thread=Thread(target=close);thread.start()
        deadline=time.monotonic()+3
        while not worker._stop.is_set() and time.monotonic()<deadline:time.sleep(.005)
        assert worker._stop.is_set()
        release.set();thread.join(5)
        assert not thread.is_alive()
        assert not failures,[str(e) for e in failures]
        assert worker.health().cleanup=='CLEAN'
        assert not delivered
    finally:
        release.set()
        if not worker._closed:worker.close()


def test_forced_codec_exit_reports_fault_but_confirms_cpu_resource_release():
    from multiprocessing.shared_memory import SharedMemory
    import pytest
    context=multiprocessing.get_context('spawn');entered,release=context.Event(),context.Event()
    worker=ProcessPreviewEncoder(lambda:frozenset({'video'}),
        partial(encode_after_release,entered,release),lambda *a:None)
    name=worker._memory.name
    assert not worker.release_confirmed
    try:
        assert worker.submit(lambda modes:PreviewSnapshot(1,modes,None,None,None))
        assert entered.wait(5)
        with pytest.raises(RuntimeError,match='FORCED'):worker.close(timeout=.05)
        assert worker.release_confirmed
        assert not worker._process.is_alive() and not worker._thread.is_alive()
        with pytest.raises(FileNotFoundError):SharedMemory(name=name)
    finally:
        # A terminated child can leave its Event condition locked. It has no
        # remaining waiter; never touch a synchronization primitive it owned.
        if worker._process.is_alive():release.set()
        if not worker._closed:worker.close()
