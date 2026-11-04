"""Verify new accelerator package without loading PL. python3 verify_package.py
Outputs PACKAGE_PASS; next run verify_dma.py, then guarded realtime validation.
"""
import hashlib
import json
from pathlib import Path
from xml.etree import ElementTree


def verify(directory):
    directory=Path(directory)
    manifest=json.loads((directory/'manifest.json').read_text(encoding='utf-8-sig'))
    for name,digest in manifest['sha256'].items():
        if Path(name).name!=name:raise ValueError('unsafe manifest name')
        if hashlib.sha256((directory/name).read_bytes()).hexdigest().upper()!=digest:
            raise ValueError(f'package hash mismatch {name}')
    hwh_name=manifest.get('hwh','camera_hand_accel_v2.hwh')
    if Path(hwh_name).name!=hwh_name:raise ValueError('unsafe HWH name')
    tree=ElementTree.parse(directory/hwh_name)
    modules={m.get('INSTANCE'):m for m in tree.iter('MODULE')}
    ranges=list(tree.iter('MEMRANGE'))
    if manifest.get('protocol')=='SKN6':
        if hwh_name!='camera_hand_skin_v6.hwh' or not {'camera_hand_skin_v6.bit',hwh_name}<=manifest['sha256'].keys():
            raise ValueError('v6 paired bit/HWH hashes required')
        if 'skin_kernel' not in modules or modules['skin_kernel'].get('MODTYPE')!='bgr_skin_dma':
            raise ValueError('v6 skin hardware required')
    for name,base in {'moments_dma':0x40400000,'moments_reset':0x41200000,
                      'frame_dma':0x43000000,'hand_osd':0x43c10000,
                      'camera_iic':0x41600000,'demosaic':0x43c00000}.items():
        params={p.get('NAME'):p.get('VALUE') for p in modules[name].iter('PARAMETER')}
        if not any(r.get('INSTANCE')==name and int(r.get('BASEVALUE','0'),0)==base
                   and r.get('MASTERBUSINTERFACE')=='M_AXI_GP0' for r in ranges):
            raise ValueError(f'wrong address {name}')
        if name=='moments_dma':
            if params.get('C_INCLUDE_SG')!='0' or params.get('C_SG_LENGTH_WIDTH')!='23':
                raise ValueError('requires simple DMA with 23-bit lengths')
        if name=='frame_dma' and (params.get('C_INCLUDE_MM2S')!='1' or
                                 params.get('C_ENABLE_DEBUG_INFO_1')!='1'):
            raise ValueError('original HDMI/BRAM FIFO configuration must be preserved')
    print('PACKAGE_PASS: paired hashes/address map; NOT board validated',flush=True)


if __name__=='__main__':verify(Path(__file__).resolve().parent)
