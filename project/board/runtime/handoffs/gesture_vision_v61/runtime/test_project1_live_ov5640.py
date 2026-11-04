import unittest
import tempfile
import json
import zipfile
from unittest.mock import patch, MagicMock
from pathlib import Path
import cv2
import numpy as np
from project1_live_ov5640 import CalibrationCapture, BytesPreview, OriginalContour, FullFrameTracker, VideoRecorder, original_code, process_rgb, capture_to_rgb, rgb_to_display, selected_pixel_stats


class LiveBaselineTests(unittest.TestCase):
    def test_selected_pixel_centroid_not_box_center(self):
        mask = np.zeros((80,100),np.uint8)
        triangle = np.array([[[10,10]],[[50,10]],[[10,50]]],np.int32)
        cv2.drawContours(mask,[triangle],-1,255,-1)
        mask[15:18,15:18] = 0  # holes do not contribute
        mask[65:70,70:75] = 255  # unrelated blob does not contribute
        stats = selected_pixel_stats(mask,triangle,(100,200,200,280))
        yy,xx = np.nonzero(mask[:55,:55])
        self.assertEqual(stats['area'],len(xx))
        self.assertEqual(stats['sum_x'],int(xx.sum())+100*len(xx))
        self.assertEqual(stats['sum_y'],int(yy.sum())+200*len(yy))
        self.assertAlmostEqual(stats['centroid'][0],100+xx.mean())
        self.assertGreater(abs(stats['centroid'][0]-130),5)
        self.assertIsNone(selected_pixel_stats(np.zeros_like(mask),triangle,(0,0,100,80))['centroid'])

    def test_rps_shape_rules_and_scaled_depth(self):
        tracker = FullFrameTracker()
        for fingers,ratio,code in [(1,5,'0'),(2,35,'2'),(3,23,'5'),(4,25,'5'),(5,20,'5'),
                                   (2,8,'REPOSITION'),(3,5,'REPOSITION'),(3,57,'REPOSITION'),(6,30,'REPOSITION')]:
            self.assertEqual(tracker.classify_shape(fingers,3000,ratio),code)
        self.assertEqual(tracker.classify_shape(5,50,30),'NO_HAND')
        small = np.array([[[0,0]],[[99,0]],[[99,99]],[[0,99]]],np.int32)
        self.assertEqual(tracker.depth_threshold(small),15.)
        self.assertEqual(OriginalContour().depth_threshold(small),30.)

    def test_centroid_rotation_mirror_and_loss(self):
        rgb = np.zeros((720,1280,3),np.uint8)
        skin = cv2.cvtColor(np.array([[[10,150,190]]],np.uint8),cv2.COLOR_HSV2RGB)[0,0].tolist()
        cv2.circle(rgb,(220,260),80,skin,-1)
        for rotation,mirror in [(0,False),(180,False),(0,True),(180,True)]:
            _,r = process_rgb(rgb,FullFrameTracker(),rotation,mirror)
            expected_x = 109.75 if not ((rotation==180)^mirror) else 529.25
            expected_y = 129.75 if rotation==0 else 229.25
            self.assertAlmostEqual(r['centroid'][0],expected_x,delta=1)
            self.assertAlmostEqual(r['centroid'][1],expected_y,delta=1)
            self.assertTrue(all(v>=0 for v in r['timing_ms'].values()))
        r = FullFrameTracker().infer(np.zeros((360,640,3),np.uint8))
        self.assertIsNone(r['centroid'])
        self.assertIsNone(r['pixel_stats'])

    def test_fullframe_moving_box_and_loss(self):
        tracker = FullFrameTracker(min_area=1000)
        skin = cv2.cvtColor(np.array([[[10,150,190]]],np.uint8),cv2.COLOR_HSV2BGR)[0,0].tolist()
        for cx,cy in [(65,70),(140,70),(230,100),(350,180),(480,260),(570,280)]:
            bgr = np.zeros((360,640,3),np.uint8)
            cv2.circle(bgr,(cx,cy),32,skin,-1)
            r = tracker.infer(bgr)
            self.assertIsNotNone(r['bbox'])
            x0,y0,x1,y1 = r['bbox']
            self.assertAlmostEqual((x0+x1)/2,cx,delta=2)
            self.assertAlmostEqual((y0+y1)/2,cy,delta=2)
            self.assertEqual(r['roi'],(0,0,640,360))
            self.assertEqual(r['mask'].shape,(360,640))
        blank = np.zeros((360,640,3),np.uint8)
        r = tracker.infer(blank)
        self.assertIsNone(r['bbox'])
        self.assertEqual(r['stable'],'NO_HAND')
        self.assertIsNone(tracker.previous)
        self.assertEqual(len(tracker.votes),0)
        cv2.circle(blank,(100,100),5,skin,-1)
        self.assertIsNone(tracker.infer(blank)['bbox'])

    def test_tracking_vote_no_stale_gesture(self):
        tracker=FullFrameTracker()
        frame=np.zeros((360,640,3),np.uint8)
        def inferred(code,box=(100,100,200,200)):
            return dict(code=code,bbox=box,stable=code,rps='UNKNOWN')
        states=[]
        for code in ['5','5','4','5','0','0','0','NO_HAND']:
            with patch.object(OriginalContour,'infer',return_value=inferred(code,None if code=='NO_HAND' else (100,100,200,200))):
                states.append(tracker.infer(frame)['stable'])
        self.assertEqual(states,['PENDING','PENDING','PENDING','5','PENDING','PENDING','0','NO_HAND'])

    def test_tracking_prefers_associated_candidate(self):
        tracker=FullFrameTracker(min_area=500)
        skin=cv2.cvtColor(np.array([[[10,150,190]]],np.uint8),cv2.COLOR_HSV2BGR)[0,0].tolist()
        frame=np.zeros((360,640,3),np.uint8)
        cv2.circle(frame,(100,120),35,skin,-1)
        tracker.infer(frame)
        cv2.circle(frame,(500,200),45,skin,-1)
        r=tracker.infer(frame)
        self.assertEqual(r['candidates'],2)
        self.assertLess(r['bbox'][2],200)

    def test_contour_controls_and_roi_edge_hint(self):
        with self.assertRaises(ValueError):
            OriginalContour(dilate_iterations=9)
        with self.assertRaises(ValueError):
            OriginalContour(defect_depth=0)
        frame = np.zeros((360,640,3),np.uint8)
        skin = cv2.cvtColor(np.array([[[10,150,190]]],np.uint8),cv2.COLOR_HSV2BGR)[0,0].tolist()
        cv2.rectangle(frame,(390,120),(500,220),skin,-1)
        r = OriginalContour(confirm=1,dilate_iterations=3).infer(frame)
        self.assertTrue(r['touches_roi'])
        self.assertEqual(r['dilate_iterations'],3)
        self.assertEqual(r['defect_depth'],30.)
        self.assertFalse(OriginalContour().infer(np.zeros_like(frame))['touches_roi'])
        interior = np.zeros_like(frame)
        cv2.circle(interior,(320,180),55,skin,-1)
        self.assertFalse(OriginalContour().infer(interior)['touches_roi'])

    def test_bgr_interpretation_and_display_round_trip(self):
        rgb = np.zeros((720,1280,3),np.uint8)
        rgb[200:500,450:850] = (210,140,100)
        bgr = rgb[:,:,::-1].copy()
        np.testing.assert_array_equal(capture_to_rgb(bgr,'bgr'),rgb)
        self.assertFalse(np.shares_memory(capture_to_rgb(bgr,'bgr'),bgr))
        expected, er = process_rgb(rgb,OriginalContour(confirm=1))
        actual, ar = process_rgb(bgr,OriginalContour(confirm=1),capture_order='bgr')
        np.testing.assert_array_equal(expected,actual)
        self.assertEqual(er['bbox'],ar['bbox'])
        self.assertEqual(er['code'],ar['code'])
        np.testing.assert_array_equal(rgb_to_display(actual,'bgr')[:,:,::-1],actual)
        with self.assertRaises(ValueError):
            capture_to_rgb(bgr,'unknown')

    def test_rps_calibration_channel_order_and_zip(self):
        with tempfile.TemporaryDirectory() as directory:
            Path(directory,'frames.csv').write_text('frame,raw\n1,0\n')
            calibration = CalibrationCapture(directory,capture_order='bgr',rps=True)
            bgr = np.zeros((720,1280,3),np.uint8)
            bgr[:] = (20,100,200)
            overlay,result = process_rgb(bgr,OriginalContour(),capture_order='bgr')
            for index,(due,stage) in enumerate(calibration.schedule):
                calibration.cue(due)
                calibration.capture(bgr,overlay,result,index+1,due+.1)
            calibration.close()
            self.assertEqual(len(calibration.samples),8)
            self.assertEqual(calibration.samples[-1]['requested_scene'],'SCISSORS')
            base = Path(directory)/'calibration'/'scissors_57s'
            np.testing.assert_array_equal(np.load(str(base)+'_capture.npy'),bgr)
            self.assertEqual(cv2.imread(str(base)+'_raw.png')[200,200].tolist(),[20,100,200])
            with zipfile.ZipFile(Path(directory)/'calibration_download.zip') as archive:
                self.assertIn('calibration/frames.csv',archive.namelist())
                manifest=json.loads(archive.read('calibration/manifest.json'))
                self.assertEqual(len(manifest['samples']),8)

    def test_calibration_same_frame_raw_and_orientation(self):
        with tempfile.TemporaryDirectory() as directory:
            calibration = CalibrationCapture(directory)
            rgb = np.zeros((720,1280,3),np.uint8)
            rgb[100:240,100:240] = (255,0,0)
            original = rgb.copy()
            overlay, result = process_rgb(rgb, OriginalContour())
            calibration.cue(10.2)
            calibration.capture(rgb, overlay, result, 40, 10.2)
            base = Path(directory)/'calibration'/'empty_background_10s'
            np.testing.assert_array_equal(np.load(str(base)+'_capture.npy'), original)
            np.testing.assert_array_equal(rgb, original)
            image = cv2.imread(str(base)+'_raw.png')
            self.assertEqual(image[550,1100].tolist(),[0,0,255])
            np.testing.assert_array_equal(cv2.imread(str(base)+'_mask.png',0), result['mask'])
            info = json.loads(Path(str(base)+'_result.json').read_text())
            self.assertEqual(info['frame'],40)
            self.assertFalse(info['scene_verified'])
            calibration.close()
            manifest = json.loads((base.parent/'manifest.json').read_text())
            self.assertEqual(len(manifest['samples']),1)
            self.assertEqual(len(manifest['pending_targets']),5)

    def test_calibration_skips_late_scene(self):
        with tempfile.TemporaryDirectory() as directory:
            calibration = CalibrationCapture(directory)
            rgb = np.zeros((720,1280,3),np.uint8)
            overlay, result = process_rgb(rgb, OriginalContour())
            calibration.capture(rgb, overlay, result, 1, 9.)
            self.assertEqual(len(calibration.pending),6)
            calibration.capture(rgb, overlay, result, 2, 16.)
            self.assertEqual(calibration.missed,[10.])
            self.assertEqual(calibration.samples,[])

    def test_calibration_all_six_samples(self):
        with tempfile.TemporaryDirectory() as directory:
            calibration = CalibrationCapture(directory, rotate=0, mirror=True)
            rgb = np.zeros((720,1280,3),np.uint8)
            overlay, result = process_rgb(rgb, OriginalContour(), rotate=0, mirror=True)
            for index, (due, stage) in enumerate(calibration.schedule):
                calibration.cue(due)
                calibration.capture(rgb, overlay, result, index+1, due+.1)
                self.assertEqual(calibration.samples[-1]['requested_scene'],calibration.stages[stage])
            calibration.close()
            manifest = json.loads((Path(directory)/'calibration'/'manifest.json').read_text())
            self.assertEqual(len(manifest['samples']),6)
            self.assertEqual(manifest['pending_targets'],[])
            self.assertEqual(manifest['missed_targets'],[])

    def test_preview_rejects_dma_or_numpy_frames(self):
        with patch('project1_live_ov5640.ThreadingHTTPServer', return_value=MagicMock()):
            preview = BytesPreview('127.0.0.1', 0)
            try:
                with self.assertRaises(TypeError):
                    preview.publish(np.zeros((360,640,3),np.uint8))
                preview.publish(b'encoded-jpeg')
                preview.publish_result(b'{"detected":false}')
                self.assertEqual(preview.result_json,b'{"detected":false}')
                with self.assertRaises(TypeError):
                    preview.publish_result(np.zeros((1,),np.uint8))
                self.assertEqual(preview.jpeg,b'encoded-jpeg')
                self.assertEqual(preview.generation,1)
            finally:
                preview.close()
            self.assertFalse(preview.thread.is_alive())

    def test_recording_closed_and_decodable(self):
        with tempfile.TemporaryDirectory() as directory:
            recorder = VideoRecorder(directory, fps=8)
            rgb = np.zeros((720,1280,3),np.uint8)
            rgb[:] = (230,20,10)
            self.assertEqual(recorder.write(rgb, 0), 0)
            self.assertIsNone(recorder.write(rgb, .01))
            for index in range(1,8):
                self.assertEqual(recorder.write(rgb, index/8), index)
            recorder.close()
            recorder.close()
            capture = cv2.VideoCapture(str(Path(directory)/'gesture_overlay.avi'))
            try:
                self.assertTrue(capture.isOpened())
                self.assertEqual(int(capture.get(cv2.CAP_PROP_FRAME_COUNT)),8)
                ok, bgr = capture.read()
                self.assertTrue(ok)
                self.assertEqual(bgr.shape,(360,640,3))
                self.assertGreater(float(bgr[:,:,2].mean()),200)
            finally:
                capture.release()
            self.assertTrue((Path(directory)/'video_contact_sheet.jpg').is_file())
            self.assertTrue((Path(directory)/'recording.json').is_file())

    def test_recording_limit(self):
        with tempfile.TemporaryDirectory() as directory:
            recorder = VideoRecorder(directory)
            recorder.max_bytes = 0
            try:
                self.assertIsNone(recorder.write(np.zeros((720,1280,3),np.uint8),0))
                self.assertTrue(recorder.limited)
            finally:
                recorder.close()

    def test_original_boundaries(self):
        for args, expected in [((1,1999,0),'NO_HAND'), ((1,2000,11.99),'0'),
                               ((1,2000,12),'6'), ((1,2000,17.5),'1'),
                               ((2,2000,0),'2'), ((3,2000,26.99),'3'),
                               ((3,2000,27),'7'), ((5,2000,0),'5'), ((6,2000,0),'REPOSITION')]:
            self.assertEqual(original_code(*args), expected)

    def test_blank_and_convex_fist_and_reset(self):
        rec = OriginalContour(confirm=3)
        blank = np.zeros((360,640,3),np.uint8)
        self.assertEqual(rec.infer(blank)['stable'], 'NO_HAND')
        skin = cv2.cvtColor(np.array([[[10,150,190]]],np.uint8),cv2.COLOR_HSV2BGR)[0,0].tolist()
        frame = blank.copy()
        cv2.circle(frame,(320,180),60,skin,-1)
        self.assertEqual(rec.infer(frame)['stable'],'PENDING')
        rec.infer(frame)
        result = rec.infer(frame)
        self.assertEqual(result['rps'],'ROCK')
        self.assertTrue(170 <= result['bbox'][0] < result['bbox'][2] <= 470)
        self.assertEqual(rec.infer(blank)['stable'],'NO_HAND')
        self.assertEqual(rec.infer(frame)['stable'],'PENDING')

    def test_rgb_conversion_rotation_and_owned_output(self):
        rgb = np.zeros((720,1280,3),np.uint8)
        rgb[100:240,100:240] = (255,0,0)
        untouched = rgb.copy()
        out, result = process_rgb(rgb,OriginalContour(),180)
        self.assertEqual(out.shape,rgb.shape)
        self.assertFalse(np.shares_memory(out,rgb))
        np.testing.assert_array_equal(rgb,untouched)
        self.assertGreater(int(out[550,1100,0]),200)
        self.assertEqual(result['mask'].shape,(300,300))


if __name__ == '__main__':
    unittest.main()
