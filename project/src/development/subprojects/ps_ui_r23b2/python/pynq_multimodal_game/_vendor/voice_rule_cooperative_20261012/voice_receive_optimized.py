"""Narrow receive optimization; factory binds the original verified driver types."""
import struct
import numpy as np


def build_driver(driver_module, memory_type):
    base = driver_module.VoicePcmSG
    DmaFault = driver_module.DmaFault
    COMPLETE, FRAME, PACKET_BYTES = driver_module.COMPLETE, driver_module.FRAME, driver_module.PACKET_BYTES
    PcmPacket = driver_module.PcmPacket
    guarded = frozenset(getattr(memory_type, n) for n in
                        ('invalidate', 'read_bytes', 'write_bytes', 'flush'))

    class OptimizedVoicePcmSG(base):
        def _call(self, callback, *args):
            memory = getattr(callback, '__self__', None)
            function = getattr(callback, '__func__', None)
            checked_memory = (getattr(self, '_optimized_poll_active', False)
                              and type(memory) is memory_type
                              and function in guarded
                              and memory.owner is self.owner)
            if not checked_memory:
                return super()._call(callback, *args)
            # Exact original PynqMemory methods already prove ownership before
            # AND after cache/copy, plus allocation identity. Remove only the
            # adjacent duplicate outer proof. No TTL, grace period or cached
            # lease; raw MMIO/health/tail writes retain the original _call.
            if self.clock() >= self.deadline:
                raise DmaFault("operation deadline")
            started = self.clock()
            value = callback(*args)
            elapsed = self.clock()-started
            self.callback_trace.append((callback.__qualname__, elapsed))
            self.callback_trace = self.callback_trace[-16:]
            if self.clock() >= self.deadline:
                raise DmaFault("callback exceeded deadline: %s %.6fs" %
                               (self.callback_trace[-1][0], elapsed))
            return value

        def poll_packet(self, timeout=.01):
            """Return immutable completed packet/None, never gameplay permission.

            Service at <=20ms. >50ms service gap/stall invalidates the session.
            A fault requires explicit stop; no packet from that call is returned.
            """
            self._begin(timeout)
            self._optimized_poll_active = True
            try:
                if self.state != "RUNNING":
                    raise DmaFault("session not running")
                now = self.clock()
                if now - self.last_poll > .05 or now - self.last_packet > .05:
                    raise DmaFault("DMA service gap or packet stall")
                self._status(running=True)
                if self._call(self.read32, 0x30) & 0x1D != 1:
                    raise DmaFault("DMA control changed")
                i = self.index % len(self.slots)
                desc, data = self.slots[i]
                self._call(desc.invalidate)
                raw = self._call(desc.read_bytes)
                if not isinstance(raw, bytes) or len(raw) != 64:
                    raise DmaFault("descriptor read length")
                words = struct.unpack("<16I", raw)
                if words[:7] != struct.unpack("<16I", self._descriptor(i))[:7]:
                    raise DmaFault("descriptor ownership/address/control corruption")
                status = words[7]
                if status & 0x70000000:
                    raise DmaFault("descriptor transfer error")
                if not status & COMPLETE:
                    # Keep source-fault detection while waiting. A complete
                    # packet instead gets its fresh snapshot AFTER payload copy,
                    # before recycling or returning anything. Two snapshots in
                    # the same complete-packet call were redundant work under
                    # the unchanged10ms total budget.
                    self._check_health()
                    self.last_poll = self.clock()
                    return None
                if status != COMPLETE | FRAME | PACKET_BYTES:
                    raise DmaFault("not one complete 960-sample PCM packet")
                self._call(data.invalidate)
                pcm = self._call(data.read_bytes)
                if not isinstance(pcm, bytes) or len(pcm) != PACKET_BYTES:
                    raise DmaFault("PCM read length")
                samples = np.frombuffer(pcm, dtype="<i4")
                if np.any(samples < -32768) or np.any(samples > 32767):
                    raise DmaFault("PCM is not sign-extended signed16")
                self._check_health()
                self._status(running=True)
                packet = PcmPacket(self.epoch, self.index, self.clock(), pcm)
                self._call(data.flush)
                self._call(desc.write_bytes, self._descriptor(i))
                self._call(desc.flush)
                self._call(self.write32, 0x40, desc.physical_address)
                self.index += 1
                self.last_poll = self.last_packet = self.clock()
                return packet
            except Exception as exc:
                self._fail(exc)
                raise
            finally:
                self._optimized_poll_active = False
                self.lock.release()


    return OptimizedVoicePcmSG

