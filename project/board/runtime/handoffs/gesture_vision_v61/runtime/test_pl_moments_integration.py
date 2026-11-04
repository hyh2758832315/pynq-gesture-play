import unittest
import cv2
import numpy as np
from project1_live_ov5640 import OriginalContour, selected_pixel_stats


class Backend:
    def run(self,hsv,gate,fid,bounds):
        self.fid=fid
        hl,hh,sl,sh,vl,vh=bounds
        mask=((hsv[:,:,0]>=hl)&(hsv[:,:,0]<=hh)&(hsv[:,:,1]>=sl)&
              (hsv[:,:,1]<=sh)&(hsv[:,:,2]>=vl)&(hsv[:,:,2]<=vh)&(gate!=0))
        yy,xx=np.nonzero(mask)
        return mask.astype(np.uint8)*255,dict(area=int(mask.sum()),sum_x=int(xx.sum()),
            sum_y=int(yy.sum()),frame_id=fid,total_ms=1.,pack_cache_ms=.1,dma_cache_ms=.9)


class IntegrationTests(unittest.TestCase):
    def test_same_frame_roi_offset_holes_and_other_skin(self):
        recognizer=OriginalContour(roi=(100,80,106,84))
        recognizer.moments_backend=Backend();recognizer.result_frame_id=39
        hsv=np.full((4,6,3),(10,90,150),dtype=np.uint8)
        hsv[1,1]=(30,90,150)  # hole excluded even within filled contour
        contour=np.array([[[0,0]],[[3,0]],[[3,3]],[[0,3]]],dtype=np.int32)
        skin=cv2.inRange(hsv,recognizer.lower,recognizer.upper)
        got=recognizer.pixel_statistics(hsv,skin,contour)
        gold=selected_pixel_stats(skin,contour,recognizer.roi)
        for key in ('area','sum_x','sum_y','centroid'):self.assertEqual(got[key],gold[key])
        self.assertEqual(got['area'],15)
        self.assertEqual(got['frame_id'],39)
        self.assertTrue(got['same_frame_exact'])

    def test_mismatch_rejected(self):
        recognizer=OriginalContour(roi=(0,0,6,4))
        class Bad(Backend):
            def run(self,*args):
                mask,result=super().run(*args);result['sum_x']+=1
                return mask,result
        recognizer.moments_backend=Bad();recognizer.result_frame_id=1
        hsv=np.full((4,6,3),(10,90,150),dtype=np.uint8)
        contour=np.array([[[0,0]],[[3,0]],[[3,3]],[[0,3]]],dtype=np.int32)
        skin=cv2.inRange(hsv,recognizer.lower,recognizer.upper)
        with self.assertRaisesRegex(RuntimeError,'moments mismatch'):
            recognizer.pixel_statistics(hsv,skin,contour)


if __name__=='__main__':unittest.main()
