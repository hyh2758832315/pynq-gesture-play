import unittest
from unittest.mock import patch
import cv2
import numpy as np
from project1_live_ov5640 import FullFrameTracker


class Backend:
    def __init__(self):self.calls=[];self.corrupt=False
    def run(self,bgr,frame_id,bounds):
        self.calls.append((bgr.copy(),frame_id,bounds))
        hsv=cv2.cvtColor(bgr,cv2.COLOR_BGR2HSV)
        mask=cv2.inRange(hsv,tuple(bounds[::2]),tuple(bounds[1::2]))
        if self.corrupt:mask[0,0]^=255
        return mask,dict(frame_id=frame_id)


class Tests(unittest.TestCase):
    def image(self):
        bgr=np.zeros((360,640,3),np.uint8)
        cv2.rectangle(bgr,(200,80),(350,220),(80,120,180),-1)
        cv2.rectangle(bgr,(500,270),(530,300),(80,120,180),-1)
        return bgr
    def test_selected_same_frame_geometry_and_classification(self):
        cpu=FullFrameTracker();pl=FullFrameTracker();pl.skin_backend=Backend();pl.skin_validate=True
        for fid in range(1,7):
            cpu.result_frame_id=pl.result_frame_id=fid
            a=cpu.infer(self.image());b=pl.infer(self.image())
            for key in ('code','stable','rps','bbox','fingers','centroid','area','touches_roi'):
                self.assertEqual(a[key],b[key],key)
            self.assertTrue(np.array_equal(a['mask'],b['mask']))
            self.assertEqual(a['pixel_stats'],b['pixel_stats'])
            self.assertTrue(b['pl_skin']['same_frame_exact'])
            self.assertEqual(pl.skin_backend.calls[-1][1],fid)
    def test_validation_rejects_changed_mask(self):
        pl=FullFrameTracker();pl.skin_backend=Backend();pl.skin_backend.corrupt=True;pl.skin_validate=True;pl.result_frame_id=1
        with self.assertRaisesRegex(RuntimeError,'same-frame'):pl.infer(self.image())
    def test_performance_does_not_run_software_hsv(self):
        pl=FullFrameTracker();pl.result_frame_id=22;pl.skin_validate=False
        mask=Backend().run(self.image(),22,(0,20,20,255,70,255))[0]
        pl.skin_backend=type('Fixed',(),{'run':lambda self,*args:(mask.copy(),{'frame_id':22})})()
        with patch('cv2.cvtColor',side_effect=AssertionError('duplicate software HSV')):
            b=pl.infer(self.image())
        self.assertIsNone(b['pl_skin']['same_frame_exact'])
        self.assertIsNotNone(b['centroid'])
    def test_empty_and_frame_edge_preserved(self):
        cpu=FullFrameTracker();pl=FullFrameTracker();pl.skin_backend=Backend();pl.skin_validate=True;pl.result_frame_id=1
        for bgr in (np.zeros((360,640,3),np.uint8),np.full((360,640,3),(80,120,180),np.uint8)):
            a=cpu.infer(bgr);b=pl.infer(bgr)
            self.assertEqual(a['code'],b['code']);self.assertEqual(a['touches_roi'],b['touches_roi'])


if __name__=='__main__':unittest.main()
