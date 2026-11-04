"""Use the existing owner's native PYNQ u32 mapping; never create a mapping.

The installed PYNQ3.1 MMIO.write_mm uses this same array for register stores.
One typed contiguous shadow assignment avoids six Python MMIO wrappers.
COMMIT remains a separate, ordered u32 store. Generic test IO keeps scalar IO.
"""


class OsdRegisters:
    def __init__(self, mmio):
        self.mmio = mmio
        self.array = self.shadow = None
        device = getattr(mmio, "device", None)
        if device is not None and device.has_capability("MEMORY_MAPPED"):
            array = mmio.array
            if (array.ndim != 1 or len(array) < 10 or array.strides != (4,) or
                    array.dtype.kind != "u" or array.dtype.itemsize != 4 or
                    not array.dtype.isnative or not array.flags.c_contiguous):
                raise ValueError("OSD requires native contiguous uint32 MMIO array")
            self.array, self.shadow = array, array[4:10]

    @property
    def mode(self):
        return "native-u32-view" if self.array is not None else "scalar-register-io"

    def read(self, offset):
        if offset not in (0, 4):
            raise ValueError("unexpected OSD control read")
        return int(self.array[offset >> 2]) if self.array is not None else self.mmio.read(offset)

    def write(self, offset, value):
        if offset != 8 or value != 1:
            raise ValueError("unexpected OSD commit")
        if self.array is not None:
            self.array[2] = value
        else:
            self.mmio.write(offset, value)

    def write_shadow(self, words):
        if len(words) != 6 or any(type(v) is not int or not 0 <= v <= 0xFFFFFFFF for v in words):
            raise ValueError("invalid OSD shadow words")
        if self.shadow is not None:
            self.shadow[:] = words
        else:
            for index, value in enumerate(words):
                self.mmio.write(0x10 + index * 4, value)

    def read_shadow(self):
        # Explicit diagnostic only, requested by test-enabled Agent command;
        # not part of the regular one-read/seven-word-write schedule.
        if self.shadow is not None:
            return tuple(int(v) for v in self.shadow)
        return tuple(self.mmio.read(0x10+4*i) for i in range(6))
