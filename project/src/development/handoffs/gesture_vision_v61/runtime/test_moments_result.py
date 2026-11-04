import struct,unittest
from moments_result import decode_snapshot


class ResultTests(unittest.TestCase):
    def test_fractional_centroid(self):
        r=decode_snapshot(struct.pack('<IQQI',3,10,8,19),8,4,19)
        self.assertEqual(r['centroid'],(10/3,8/3))
    def test_empty(self):
        self.assertIsNone(decode_snapshot(struct.pack('<IQQI',0,0,0,1),8,4)['centroid'])
    def test_full_frame(self):
        r=decode_snapshot(struct.pack('<IQQI',921600,589363200,331315200,200),1280,720,200)
        self.assertEqual(r['centroid'],(639.5,359.5))
    def test_reject_bad_frame(self):
        data=struct.pack('<IQQI',1,0,0,2)
        with self.assertRaises(ValueError):decode_snapshot(data,8,4,3)
        with self.assertRaises(ValueError):decode_snapshot(data,8,4,error=True)
    def test_reject_overflow_or_invalid_buffer(self):
        for data in [b'',struct.pack('<IQQI',33,0,0,1),struct.pack('<IQQI',0,1,0,1),struct.pack('<IQQI',1,8,0,1)]:
            with self.assertRaises(ValueError):decode_snapshot(data,8,4)
