import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from verify_package import verify


class PackageTests(unittest.TestCase):
    def fixture(self,directory):
        root=Path(directory)
        mapping={'moments_dma':'0x40400000','moments_reset':'0x41200000',
                 'frame_dma':'0x43000000','hand_osd':'0x43C10000',
                 'camera_iic':'0x41600000','demosaic':'0x43C00000'}
        xml='<ROOT>'
        for name,base in mapping.items():
            xml+=f'<MODULE INSTANCE="{name}"><PARAMETER NAME="C_BASEADDR" VALUE="{base}"/>'
            if name=='moments_dma':xml+='<PARAMETER NAME="C_INCLUDE_SG" VALUE="0"/><PARAMETER NAME="C_SG_LENGTH_WIDTH" VALUE="23"/>'
            if name=='frame_dma':xml+='<PARAMETER NAME="C_INCLUDE_MM2S" VALUE="1"/><PARAMETER NAME="C_ENABLE_DEBUG_INFO_1" VALUE="1"/>'
            xml+='</MODULE>'
            xml+=f'<MEMRANGE INSTANCE="{name}" BASEVALUE="{base}" MASTERBUSINTERFACE="M_AXI_GP0"/>'
        xml+='</ROOT>'
        (root/'camera_hand_accel_v2.hwh').write_text(xml)
        (root/'camera_hand_accel_v2.bit').write_bytes(b'unit-test fixture, never loaded')
        self.manifest(root)
        return root

    def manifest(self,root):
        hashes={p.name:hashlib.sha256(p.read_bytes()).hexdigest().upper()
                for p in root.iterdir() if p.name!='manifest.json'}
        (root/'manifest.json').write_text(json.dumps({'sha256':hashes}))

    def test_corrupted_file_rejected(self):
        with tempfile.TemporaryDirectory() as d:
            root=self.fixture(d);verify(root)
            (root/'camera_hand_accel_v2.bit').write_bytes(b'corrupted')
            with self.assertRaisesRegex(ValueError,'hash mismatch'):verify(root)

    def test_wrong_address_rejected_even_with_updated_hash(self):
        with tempfile.TemporaryDirectory() as d:
            root=self.fixture(d)
            hwh=root/'camera_hand_accel_v2.hwh'
            hwh.write_text(hwh.read_text().replace('0x40400000','0x40410000'))
            self.manifest(root)
            with self.assertRaisesRegex(ValueError,'wrong address'):verify(root)

    def test_v6_requires_matching_kernel_and_paired_hashes(self):
        with tempfile.TemporaryDirectory() as d:
            root=self.fixture(d)
            xml=(root/'camera_hand_accel_v2.hwh').read_text().replace('</ROOT>','<MODULE INSTANCE="skin_kernel" MODTYPE="bgr_skin_dma"/></ROOT>')
            (root/'camera_hand_skin_v6.hwh').write_text(xml)
            (root/'camera_hand_skin_v6.bit').write_bytes(b'unit test fixture only')
            self.manifest(root)
            path=root/'manifest.json';manifest=json.loads(path.read_text())
            manifest.update(protocol='SKN6',hwh='camera_hand_skin_v6.hwh');path.write_text(json.dumps(manifest))
            verify(root)
            del manifest['sha256']['camera_hand_skin_v6.bit'];path.write_text(json.dumps(manifest))
            with self.assertRaisesRegex(ValueError,'paired'):verify(root)


if __name__=='__main__':unittest.main()
