"""Dedicated simple-mode AXI DMA; never touches camera frame_dma.

Run validation with verify_dma.py after loading the NEW paired overlay.
Input same-frame HSV8 + filled selected-contour gate. Output mask and moments.
No asynchronous calls; caller owns camera/frame lifecycle. Polling is bounded.
"""
import time
import numpy as np

MAGIC = 0x48534D32
MAX_PIXELS = 1280*720
# Keep strong references even if an exception unwinds the driver owner.
# A failed halt requires operator recovery, not garbage-collection of DMA memory.
_UNSAFE_BUFFERS = []


def pack_frame(hsv, gate, frame_id, bounds=(0, 20, 20, 255, 70, 255)):
    if (hsv.ndim != 3 or hsv.dtype != np.uint8 or hsv.shape[2] != 3 or
            not (1 <= hsv.shape[1] <= 1280 and 1 <= hsv.shape[0] <= 720)):
        raise ValueError('invalid HSV dimensions/type')
    words = np.empty(hsv.shape[0]*hsv.shape[1]+5, dtype='<u4')
    return pack_frame_into(words, hsv, gate, frame_id, bounds)


def pack_frame_into(words, hsv, gate, frame_id, bounds=(0, 20, 20, 255, 70, 255)):
    """Pack reusable ordinary RAM with byte stores, preserving the v2 wire ABI."""
    if hsv.dtype != np.uint8 or hsv.ndim != 3 or hsv.shape[2] != 3:
        raise ValueError('HSV must be uint8 HxWx3, not RGB')
    h, w = hsv.shape[:2]
    if not (1 <= w <= 1280 and 1 <= h <= 720) or gate.shape != (h, w):
        raise ValueError('invalid dimensions or gate shape')
    hl, hh, sl, sh, vl, vh = bounds
    if not (0 <= hl <= hh <= 179 and 0 <= sl <= sh <= 255 and 0 <= vl <= vh <= 255):
        raise ValueError('invalid inclusive threshold bounds')
    if not 0 <= frame_id <= 0xffffffff:
        raise ValueError('frame ID must be uint32')
    if (type(words) is not np.ndarray or words.dtype != np.dtype('<u4') or
            words.shape != (h*w+5,) or not words.flags.c_contiguous):
        raise ValueError('ordinary contiguous little-endian uint32 scratch required')
    words[:5] = [MAGIC, w | (h << 16), frame_id,
                 hl | (hh << 8) | (sl << 16) | (sh << 24), vl | (vh << 8)]
    channels = words[5:].view(np.uint8).reshape(h, w, 4)
    channels[:, :, :3] = hsv
    np.not_equal(gate, 0, out=channels[:, :, 3])
    return words


def decode_reply(words, width, height, frame_id):
    # PYNQ buffers are ndarray subclasses mapped to DMA memory. Snapshot once,
    # then perform all vector operations in normal cached RAM, not that mapping.
    if words.dtype != np.uint32 or words.size != width*height+8:
        raise ValueError('wrong DMA reply length/type')
    return _decode_plain_reply(np.array(words, copy=True, subok=False), width, height, frame_id)


def _decode_plain_reply(words, width, height, frame_id):
    from moments_result import decode_snapshot
    n = width*height
    if words.dtype != np.uint32 or words.size != n+8:
        raise ValueError('wrong DMA reply length/type')
    tail = words[n:]
    if int(tail[0]) != MAGIC or int(tail[7]) != 0:
        raise ValueError('bad DMA protocol or frame error')
    if not np.all((words[:n] == 0) | (words[:n] == 255)):
        raise ValueError('invalid returned mask')
    result = decode_snapshot(tail[1:7].astype('<u4').tobytes(), width, height, frame_id)
    return words[:n].astype(np.uint8).reshape(height, width), result


class MomentsDMA:
    def __init__(self, overlay, timeout=2.0, allocator=None):
        if timeout <= 0:
            raise ValueError('positive timeout required')
        self.dma = overlay.moments_dma.mmio
        self.reset = overlay.moments_reset.mmio
        self.timeout = timeout
        self._buffers = []
        self._tx_scratch = None
        self._rx_scratch = None
        self._closed = False
        self._tx_view = None
        self._rx_view = None
        if allocator is None:
            from pynq import allocate
            allocator = allocate
        self.allocate = allocator
        # GPIO channel is statically configured output, set TRI defensively.
        self.reset.write(4, 0)
        self.recover()

    def _poll(self, predicate, message):
        end = time.monotonic()+self.timeout
        while not predicate():
            if time.monotonic() >= end:
                raise TimeoutError(message)
            time.sleep(0.0001)

    def halt(self):
        for cr in (0x00, 0x30):
            self.dma.write(cr, self.dma.read(cr) & ~1)
        try:
            self._poll(lambda: all(self.dma.read(sr) & 1 for sr in (0x04, 0x34)),
                       'DMA halt failed: buffers retained; do not reload overlay or free memory')
        except BaseException:
            retained_ids = {id(buf) for buf in _UNSAFE_BUFFERS}
            _UNSAFE_BUFFERS.extend(buf for buf in self._buffers if id(buf) not in retained_ids)
            raise

    def recover(self):
        self.halt()
        self.reset.write(0, 0)  # clear adapter only after BOTH DMA engines halted
        self.dma.write(0, 4)
        self._poll(lambda: not (self.dma.read(0) & 4), 'DMA reset timed out')
        self.reset.write(0, 1)

    def _completed(self):
        statuses = [self.dma.read(o) for o in (4, 0x34)]
        if any(s & 0x70 for s in statuses):
            raise RuntimeError(f'DMA error status {statuses!r}')
        return all(s & 2 for s in statuses)

    def run(self, hsv, gate, frame_id, bounds=(0, 20, 20, 255, 70, 255)):
        if self._closed:
            raise RuntimeError('DMA driver closed; create a new owner')
        started = time.perf_counter()
        if hsv.ndim != 3:
            raise ValueError('HSV must be uint8 HxWx3, not RGB')
        h, w = hsv.shape[:2]
        if not (1 <= w <= 1280 and 1 <= h <= 720):
            raise ValueError('invalid dimensions')
        if self._tx_scratch is None or self._tx_scratch.size != h*w+5:
            self._tx_scratch = np.empty(h*w+5, dtype='<u4')
            self._rx_scratch = np.empty(h*w+8, dtype='<u4')
        words = pack_frame_into(self._tx_scratch, hsv, gate, frame_id, bounds)
        pack_done = time.perf_counter()
        # Allocate once at the supported maximum. Never unmap/reallocate during
        # a size transition. Packet lengths, not capacity, program DMA BTT.
        if not self._buffers:
            self._buffers.append(self.allocate(shape=(MAX_PIXELS+5,), dtype=np.uint32))
            self._buffers.append(self.allocate(shape=(MAX_PIXELS+8,), dtype=np.uint32))
            self._tx_view = np.asarray(self._buffers[0])
            self._rx_view = np.asarray(self._buffers[1])
        tx, rx = self._buffers
        tx_bytes = words.nbytes
        rx_words = h*w+8
        rx_bytes = rx_words*4
        try:
            if any(getattr(buf, 'freed', False) for buf in (tx, rx)):
                raise RuntimeError('DMA buffer was freed unexpectedly')
            for buf in (tx, rx):
                if not (0 <= buf.physical_address and
                        buf.physical_address+buf.nbytes <= 0x20000000) or buf.physical_address % 4:
                    raise ValueError('requires aligned buffers within mapped PYNQ-Z2 512MB DDR')
            if not (tx.physical_address+tx.nbytes <= rx.physical_address or
                    rx.physical_address+rx.nbytes <= tx.physical_address):
                raise ValueError('TX/RX physical buffers overlap')
            np.copyto(self._tx_view[:words.size], words)
            tx.flush()
            rx.flush()
            packed = time.perf_counter()
            # RX is armed first to avoid stream backpressure deadlock.
            self.dma.write(0x30, 1)
            self.dma.write(0x48, rx.physical_address)
            self.dma.write(0x58, rx_bytes)
            self.dma.write(0x00, 1)
            self.dma.write(0x18, tx.physical_address)
            self.dma.write(0x28, tx_bytes)
            self._poll(self._completed, 'DMA transfer timed out')
            if self.dma.read(0x58) != rx_bytes:
                raise ValueError('short DMA reply')
            rx.invalidate()
            transferred = time.perf_counter()
            np.copyto(self._rx_scratch, self._rx_view[:rx_words])
            snapshot_done = time.perf_counter()
            mask, result = _decode_plain_reply(self._rx_scratch, w, h, frame_id)
            result['pack_cache_ms'] = (packed-started)*1000
            result['dma_cache_ms'] = (transferred-packed)*1000
            result['pack_ms'] = (pack_done-started)*1000
            result['tx_copy_cache_ms'] = (packed-pack_done)*1000
            result['rx_snapshot_ms'] = (snapshot_done-transferred)*1000
            result['decode_ms'] = (time.perf_counter()-snapshot_done)*1000
            result['total_ms'] = (time.perf_counter()-started)*1000
            return mask, result
        except BaseException:
            self.recover()  # If halt fails, retain referenced buffers, never free.
            raise

    def close(self):
        self.halt()
        # Drop all internal ordinary views BEFORE unmapping their owner.
        self._tx_view = None
        self._rx_view = None
        self._closed = True
        ids = {id(buf) for buf in self._buffers}
        for buf in self._buffers:
            buf.freebuffer()
        self._buffers.clear()
        _UNSAFE_BUFFERS[:] = [buf for buf in _UNSAFE_BUFFERS if id(buf) not in ids]

