"""Compact BGR8 -> skin mask DMA; new SKN6 hardware only.

Run verify_skin_dma.py with paired v6 overlay. Reuses validated bounded polling,
halt-before-free and fixed mapped-owner lifetimes from MomentsDMA.
"""
import time
from pathlib import Path
from xml.etree import ElementTree
import numpy as np
from moments_dma import MomentsDMA, MAX_PIXELS

MAGIC = 0x534b4e36


def verify_skin_hwh(overlay):
    bitfile=getattr(overlay,'bitfile_name',None)
    if not bitfile: raise ValueError('v6 paired overlay required')
    modules={m.get('INSTANCE'):m for m in ElementTree.parse(Path(bitfile).with_suffix('.hwh')).iter('MODULE')}
    if 'skin_kernel' not in modules or modules['skin_kernel'].get('MODTYPE')!='bgr_skin_dma':
        raise ValueError('v6 bgr_skin_dma hardware required; old bitstream rejected')


def validate_input(bgr, frame_id, bounds):
    if bgr.dtype!=np.uint8 or bgr.ndim!=3 or bgr.shape[2]!=3:
        raise ValueError('expected uint8 BGR HxWx3')
    h,w=bgr.shape[:2]
    if not (1<=w<=1280 and 1<=h<=720): raise ValueError('invalid dimensions')
    if not isinstance(frame_id,(int,np.integer)) or not 0<=frame_id<=0xffffffff:
        raise ValueError('frame ID must be uint32')
    if len(bounds)!=6 or any(not isinstance(v,(int,np.integer)) for v in bounds):
        raise ValueError('integer HSV bounds required')
    hl,hh,sl,sh,vl,vh=bounds
    if not (0<=hl<=hh<=179 and 0<=sl<=sh<=255 and 0<=vl<=vh<=255):
        raise ValueError('invalid HSV bounds')
    return h,w


def pack_bgr_into(words,bgr,frame_id,bounds=(0,20,20,255,70,255)):
    h,w=validate_input(bgr,frame_id,bounds)
    needed=5+(3*h*w+3)//4
    if type(words) is not np.ndarray or words.dtype!=np.dtype('<u4') or words.shape!=(needed,) or not words.flags.c_contiguous:
        raise ValueError('ordinary contiguous little-endian scratch required')
    hl,hh,sl,sh,vl,vh=bounds
    words[:5]=[MAGIC,w|(h<<16),frame_id,hl|(hh<<8)|(sl<<16)|(sh<<24),vl|(vh<<8)]
    # One tight byte copy. No per-pixel Python or HSV/gate u32 expansion.
    payload=words[5:].view(np.uint8)
    payload[-4:]=0
    payload[:3*h*w]=bgr.reshape(-1)
    return words


def decode_mask(words,width,height,frame_id):
    n=width*height;payload_words=(n+3)//4
    if type(words) is not np.ndarray or words.dtype!=np.dtype('<u4') or words.size!=payload_words+8:
        raise ValueError('ordinary exact-length DMA reply required')
    tail=words[payload_words:]
    expected=[MAGIC,frame_id,width|(height<<16),n,0,0,0,0]
    if not np.array_equal(tail,np.array(expected,dtype='<u4')):
        raise ValueError('DMA frame ID/dimensions/count/status mismatch')
    raw=words[:payload_words].view(np.uint8)
    if np.any(raw[n:]!=0) or np.any((raw[:n]!=0)&(raw[:n]!=255)):
        raise ValueError('invalid binary mask/padding')
    # Independent normal RAM, never a DMA mapping or reusable scratch alias.
    return raw[:n].reshape(height,width).copy()


class SkinDMA(MomentsDMA):
    def __init__(self,overlay,timeout=2.,allocator=None):
        verify_skin_hwh(overlay)
        super().__init__(overlay,timeout,allocator)

    def run(self,bgr,frame_id,bounds=(0,20,20,255,70,255)):
        if self._closed: raise RuntimeError('DMA driver closed')
        started=time.perf_counter()
        h,w=validate_input(bgr,frame_id,bounds);n=h*w
        nt=5+(3*n+3)//4;nr=8+(n+3)//4
        if self._tx_scratch is None or self._tx_scratch.size!=nt:
            self._tx_scratch=np.empty(nt,dtype='<u4')
            self._rx_scratch=np.empty(nr,dtype='<u4')
        pack_bgr_into(self._tx_scratch,bgr,frame_id,bounds)
        pack_done=time.perf_counter()
        if not self._buffers:
            self._buffers.append(self.allocate(shape=(5+(3*MAX_PIXELS+3)//4,),dtype=np.uint32))
            self._buffers.append(self.allocate(shape=(8+(MAX_PIXELS+3)//4,),dtype=np.uint32))
            self._tx_view=np.asarray(self._buffers[0]);self._rx_view=np.asarray(self._buffers[1])
        tx,rx=self._buffers
        try:
            if any(getattr(b,'freed',False) for b in (tx,rx)): raise RuntimeError('DMA buffer freed unexpectedly')
            for b in (tx,rx):
                if b.physical_address%4 or not 0<=b.physical_address<b.physical_address+b.nbytes<=0x20000000:
                    raise ValueError('aligned buffers inside PYNQ-Z2 DDR required')
            if not (tx.physical_address+tx.nbytes<=rx.physical_address or rx.physical_address+rx.nbytes<=tx.physical_address):
                raise ValueError('TX/RX overlap')
            np.copyto(self._tx_view[:nt],self._tx_scratch);tx.flush();rx.flush()
            copied=time.perf_counter()
            self.dma.write(0x30,1);self.dma.write(0x48,rx.physical_address);self.dma.write(0x58,nr*4)
            self.dma.write(0,1);self.dma.write(0x18,tx.physical_address);self.dma.write(0x28,nt*4)
            self._poll(self._completed,'skin DMA transfer timed out')
            if self.dma.read(0x58)!=nr*4: raise ValueError('short DMA reply')
            rx.invalidate();transferred=time.perf_counter()
            np.copyto(self._rx_scratch,self._rx_view[:nr]);snapshot=time.perf_counter()
            mask=decode_mask(self._rx_scratch,w,h,frame_id);finished=time.perf_counter()
            return mask,dict(frame_id=int(frame_id),pack_ms=(pack_done-started)*1000,
                tx_copy_cache_ms=(copied-pack_done)*1000,dma_cache_ms=(transferred-copied)*1000,
                rx_snapshot_ms=(snapshot-transferred)*1000,decode_ms=(finished-snapshot)*1000,
                total_ms=(finished-started)*1000,tx_bytes=nt*4,rx_bytes=nr*4)
        except BaseException:
            self.recover()
            raise
