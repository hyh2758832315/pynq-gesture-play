"""Reproduce output-pipe backpressure during an in-flight codec shutdown."""
from functools import partial
import multiprocessing
import threading
import time

from pynq_multimodal_game.vision_preview import ProcessPreviewEncoder, PreviewSnapshot


def encode_in_flight(entered, release, snapshot, mode):
    entered.set()
    if not release.wait(5):
        raise RuntimeError("test release deadline")
    return b'x' * 2_000_000  # larger than OS pipe capacity; reader must remain alive


def test_shutdown_drains_in_flight_codec_before_stopping_relay():
    context=multiprocessing.get_context('spawn')
    entered,release=context.Event(),context.Event()
    worker=ProcessPreviewEncoder(lambda: frozenset({'video'}),partial(encode_in_flight,entered,release),
                                 lambda *_: None,startup_timeout=20)
    errors=[]
    def close():
        try: worker.close(timeout=1.)
        except Exception as error: errors.append(error)
    try:
        assert worker.submit(lambda modes: PreviewSnapshot(1,modes,None,None,None))
        assert entered.wait(5)
        thread=threading.Thread(target=close)
        thread.start()
        time.sleep(.2)  # original relay timeout is100ms, codec is still in encode
        release.set()
        thread.join(5)
        assert not thread.is_alive()
        assert not errors,errors
        assert worker.health().cleanup=='CLEAN'
        assert worker._process.exitcode==0
    finally:
        release.set()
        if not worker._closed:
            worker.close()


if __name__=='__main__':
    test_shutdown_drains_in_flight_codec_before_stopping_relay()
    print('PREVIEW_SHUTDOWN_BACKPRESSURE_CLEAN_PASS',flush=True)
