import json
import tempfile
from pathlib import Path
from unittest.mock import patch
import unittest
from urllib.request import urlopen
import numpy as np
import cv2
from gesture_control import GestureControl
from debug_view import six_panel, encode_debug
from project1_live_ov5640 import FullFrameTracker, process_rgb, BytesPreview


def sample(x=319.5,y=179.5,stable='PENDING',**extra):
    return dict(centroid=(x,y),code='2',stable=stable,error='',touches_roi=False,**extra)


class ControlTests(unittest.TestCase):
    def test_five_directions(self):
        for x,y,d in [(320,180,'IDLE'),(100,180,'LEFT'),(540,180,'RIGHT'),
                      (320,50,'UP'),(320,310,'DOWN')]:
            self.assertEqual(GestureControl().update(sample(x,y),1,1)['direction'],d)

    def test_dead_zone_hysteresis(self):
        control=GestureControl(tau=.001)
        self.assertEqual(control.update(sample(460),1,1)['direction'],'RIGHT')
        self.assertEqual(control.update(sample(420),2,1.1)['direction'],'RIGHT')
        self.assertEqual(control.update(sample(380),3,1.2)['direction'],'IDLE')
        self.assertEqual(control.update(sample(420),4,1.3)['direction'],'IDLE')

    def test_loss_edge_error_gap_release(self):
        for bad in [dict(centroid=None,code='NO_HAND',stable='NO_HAND'),
                    dict(touches_roi=True),dict(error='failure')]:
            control=GestureControl();control.update(sample(100),1,1)
            result=sample();result.update(bad)
            packet=control.update(result,2,1.5)
            self.assertFalse(packet['valid']);self.assertEqual(packet['direction'],'IDLE')
        control=GestureControl();control.update(sample(100),1,1)
        self.assertEqual(control.update(sample(100),2,3)['reason'],'FRAME_GAP')

    def test_one_event_no_replay_on_reacquisition(self):
        control=GestureControl()
        for i,stable in enumerate(['0','5','0','0','0'],1):
            packet=control.update(sample(stable=stable),i,i*.4)
        self.assertEqual(packet['action_event_seq'],1)
        result=sample();result['centroid']=None
        control.update(result,6,2.4)
        self.assertEqual(control.update(sample(stable='0'),7,2.8)['action_event_seq'],1)

    def test_invalid_coordinates_and_sample_order(self):
        for point in [(float('nan'),1),(640,1),(1,-1)]:
            self.assertFalse(GestureControl().update(sample(*point),1,1)['valid'])
        control=GestureControl();control.update(sample(),1,1)
        with self.assertRaises(ValueError):control.update(sample(),1,2)

    def test_debug_mode_same_inference_and_owned_output(self):
        raw=np.zeros((720,1280,3),np.uint8)
        skin=cv2.cvtColor(np.array([[[10,150,190]]],np.uint8),cv2.COLOR_HSV2RGB)[0,0].tolist()
        cv2.ellipse(raw,(700,360),(90,110),0,0,360,skin,-1)
        a,b=FullFrameTracker(),FullFrameTracker();b.debug_enabled=True
        _,ra=process_rgb(raw,a);_,rb=process_rgb(raw,b)
        for key in ('code','stable','bbox','centroid','pixel_stats'):
            self.assertEqual(ra[key],rb[key])
        control=GestureControl().update(rb,1,1)
        panels=six_panel(rb,control,1)
        self.assertEqual(panels.shape,(360,960,3))
        self.assertFalse(np.shares_memory(panels,raw))
        self.assertEqual(len(rb['debug_images']['defects']),0)
        self.assertIsNotNone(rb['centroid'])

    def test_http_dashboard_debug_and_age(self):
        preview=BytesPreview('127.0.0.1',0)
        base='http://127.0.0.1:'+str(preview.server.server_port)
        try:
            preview.publish_debug(b'jpeg-fixture')
            preview.publish_result(b'{"frame":1}')
            with urlopen(base+'/') as response:self.assertIn(b'/result.json',response.read())
            with urlopen(base+'/debug.jpg') as response:self.assertEqual(response.read(),b'jpeg-fixture')
            with urlopen(base+'/result.json') as response:
                self.assertGreaterEqual(json.load(response)['server_age_ms'],0)
            with self.assertRaises(TypeError):preview.publish_debug(bytearray())
        finally:preview.close()

    def test_debug_encoded_once_and_snapshot_matches_preview(self):
        raw=np.zeros((720,1280,3),np.uint8)
        tracker=FullFrameTracker();tracker.debug_enabled=True
        _,result=process_rgb(raw,tracker)
        control=GestureControl().update(result,1,1)
        with tempfile.TemporaryDirectory() as directory:
            target=Path(directory)/'debug.jpg'
            with patch('debug_view.cv2.imencode', wraps=cv2.imencode) as encoder:
                payload, timings=encode_debug(result,control,1,target)
                self.assertEqual(encoder.call_count,1)
            self.assertEqual(target.read_bytes(),payload)
            self.assertEqual(cv2.imdecode(np.frombuffer(payload,np.uint8),cv2.IMREAD_COLOR).shape,(360,960,3))
            self.assertTrue(all(v>=0 for v in timings.values()))


if __name__=='__main__':unittest.main()
