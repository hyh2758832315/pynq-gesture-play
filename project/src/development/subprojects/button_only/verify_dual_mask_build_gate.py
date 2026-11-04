"""Exercise the R23 dual-mask BUILD_ID check without PYNQ hardware.

Run: .venv/Scripts/python.exe -B subprojects/button_only/verify_dual_mask_build_gate.py
Output: DUAL_MASK_BUILD_GATE_PASS and exit 0.
Next: rebuild the paired R23 package, then run board gate before loading it.
"""

import importlib.util
from pathlib import Path


source = Path('D:/vvg_button_shared_package_stage/board/pynq_z2/scripts/vision_async_runtime.py')
spec = importlib.util.spec_from_file_location('r23_vision_async_runtime', source)
assert spec is not None and spec.loader is not None
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class Mmio:
    def __init__(self, value):
        self.value = value

    def read(self, _offset):
        return self.value


class Lease:
    ip_dict = {'frame_dma': {'parameters': {'C_INCLUDE_MM2S': 1}}}

    def __init__(self, value):
        self.value = value
        self.retained = []

    def retain(self, obj):
        self.retained.append(obj)

    def mmio(self, _name):
        return Mmio(self.value)


class Session:
    build_id = 0xC0061000

    def __init__(self, value):
        self.lease = Lease(value)

    def borrow(self, _name, *, instances):
        assert instances == module.SharedDualMaskHardware.INSTANCES
        return self.lease


def check(observed, expected_error):
    hardware = object.__new__(module.SharedDualMaskHardware)
    hardware._session = Session(observed)
    hardware.state = 'IDLE'
    try:
        hardware.start()
    except Exception as error:
        assert expected_error in str(error), (observed, error)
    else:
        raise AssertionError('expected later capability gate or BUILD_ID mismatch')
    assert hardware.state == 'RETAINED'


check(0xC0060E00, 'expected 0xC0061000, got 0xC0060E00')
check(0xC0061000, 'dual-mask DMA capability mismatch: frame_dma')
print('DUAL_MASK_BUILD_GATE_PASS')
