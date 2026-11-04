import unittest
from pl_osd_bridge import metadata_from_result


class BridgeTests(unittest.TestCase):
    def test_box_and_centroid_mapping(self):
        m = metadata_from_result(dict(bbox=(10,20,40,50),centroid=(15.25,30.5),rps='SCISSORS'),7)
        self.assertEqual((m['x0'],m['y0'],m['x1'],m['y1']),(20,40,80,100))
        self.assertEqual((m['cx'],m['cy']),(31,62))
        self.assertEqual((m['state'],m['result_frame_id']),(3,7))

    def test_loss_clears_previous_geometry(self):
        m = metadata_from_result(dict(bbox=None,centroid=None,rps='ROCK'),8)
        self.assertEqual((m['bbox_valid'],m['centroid_valid'],m['state']),(0,0,0))

    def test_edge_and_fractional_centroid(self):
        m = metadata_from_result(dict(bbox=(0,0,640,360),centroid=(639.9,359.9),rps='PAPER'),2**32)
        self.assertEqual((m['x1'],m['y1'],m['cx'],m['cy']),(1280,720,1279,719))
        self.assertEqual(m['result_frame_id'],0)

    def test_invalid_coordinates_rejected(self):
        for box in [(0,0,641,360),(10,0,5,20),(0,0,float('nan'),20)]:
            with self.assertRaises(ValueError):
                metadata_from_result(dict(bbox=box),1)
        with self.assertRaises(ValueError):
            metadata_from_result(dict(bbox=(0,0,20,20),centroid=(float('inf'),0)),1)

    def test_unknown_state_and_error(self):
        m = metadata_from_result(dict(bbox=(1,1,20,20),rps='UNKNOWN'),1)
        self.assertEqual((m['state'],m['centroid_valid']),(0,0))
        m = metadata_from_result(dict(bbox=(1,1,20,20),error='failed'),1)
        self.assertEqual(m['bbox_valid'],0)
