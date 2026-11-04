"""Bulk pixel data skips pickle copies, preserving immediate owned snapshots."""
import numpy as np
import pytest
from pynq_multimodal_game.vision_preview import PreviewSnapshot,snapshot_chunks,decode_snapshot

def test_pixels_external_to_metadata_and_decoded_arrays_own_frozen_payload():
    rgb=bytes((9,17,31))*(1280*720);mask=np.arange(640*360,dtype=np.uint8).reshape(360,640)
    result={'mask':mask,'_preview_capture':{'rgb':rgb,'raw':mask}}
    original=PreviewSnapshot(7,frozenset({'video'}),None,result,None)
    chunks=snapshot_chunks(original)
    assert len(chunks[1])<4096
    assert sum(memoryview(value).nbytes for value in chunks)<4_000_000
    payload=b''.join(chunks)
    mask[:]=0
    copied=decode_snapshot(payload)
    assert copied.frame==7
    assert np.array_equal(copied.result['mask'],np.arange(640*360,dtype=np.uint8).reshape(360,640))
    assert bytes(copied.result['_preview_capture']['rgb'])==rgb
    assert result['_preview_capture']['rgb'] is rgb
    assert not copied.result['mask'].flags.writeable
    with pytest.raises(ValueError):decode_snapshot(payload[:-1])


def test_regular_snapshot_also_uses_bounded_transfer_format():
    pixels=np.full((2,2,3),23,np.uint8)
    copied=decode_snapshot(b''.join(snapshot_chunks(PreviewSnapshot(1,frozenset({'video'}),pixels,None,None))))
    assert copied.rgb[0,0].tolist()==[23,23,23]
