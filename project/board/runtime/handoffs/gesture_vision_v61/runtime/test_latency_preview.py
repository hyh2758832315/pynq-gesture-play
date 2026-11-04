"""Regression checks for inference/preview split; no PYNQ hardware touched."""
import unittest
from unittest.mock import patch
import cv2
import numpy as np
from project1_live_ov5640 import process_rgb, FullFrameTracker


class LatencyPreviewTests(unittest.TestCase):
    def scene(self):
        raw=np.zeros((720,1280,3),np.uint8)
        skin=cv2.cvtColor(np.array([[[10,150,190]]],np.uint8),cv2.COLOR_HSV2RGB)[0,0].tolist()
        cv2.ellipse(raw,(480,300),(100,140),0,0,360,skin,-1)
        return raw

    def test_native_preview_preserves_inference_rotation_and_channels(self):
        raw=self.scene()
        for rotate,mirror,order in [(180,False,'rgb'),(0,True,'rgb'),(180,True,'bgr')]:
            capture=raw[:,:,::-1].copy() if order=='bgr' else raw
            old,a=process_rgb(capture,FullFrameTracker(),rotate,mirror,order)
            new,b=process_rgb(capture,FullFrameTracker(),rotate,mirror,order,output_size=(640,360))
            self.assertEqual(old.shape,(720,1280,3));self.assertEqual(new.shape,(360,640,3))
            for key in ('bbox','centroid','pixel_stats','code','stable','fingers'):
                self.assertEqual(a[key],b[key])
            np.testing.assert_array_equal(a['mask'],b['mask'])
            self.assertIsNotNone(b['centroid'])

    def test_result_callback_precedes_annotation(self):
        events=[]
        raw=self.scene()
        recognizer=FullFrameTracker()
        _,fixed=process_rgb(raw,recognizer)
        recognizer.infer=lambda bgr: {**fixed,'timing_ms':{}}
        def ready(result):
            events.append(('result',result['centroid']))
            self.assertNotIn('overlay_resize',result['timing_ms'])
            self.assertIn('input_prepare',result['timing_ms'])
        def drawing(*args,**kwargs):
            self.assertTrue(events)
            raise RuntimeError('mock expensive annotation')
        with patch('project1_live_ov5640.cv2.drawContours',side_effect=drawing):
            # Selected-pixel stats also draws a contour, so use a recognizer
            # whose inference does not call drawing; patch only output phase.
            with self.assertRaisesRegex(RuntimeError,'mock expensive annotation'):
                process_rgb(raw,recognizer,output_size=(640,360),on_result=ready)
        self.assertEqual(len(events),1)

    def test_native_preview_avoids_upscale(self):
        sizes=[]
        original=cv2.resize
        def resize(image,size,*args,**kwargs):
            sizes.append(size)
            return original(image,size,*args,**kwargs)
        with patch('project1_live_ov5640.cv2.resize',side_effect=resize):
            process_rgb(self.scene(),FullFrameTracker(),output_size=(640,360))
        self.assertNotIn((1280,720),sizes)
        self.assertEqual(sizes,[(640,360)])


if __name__=='__main__':unittest.main()
