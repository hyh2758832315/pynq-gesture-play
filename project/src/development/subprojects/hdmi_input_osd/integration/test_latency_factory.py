import importlib.util
from pathlib import Path
import sys
from types import SimpleNamespace
import unittest
from unittest.mock import patch


ROOT=Path(__file__).resolve().parents[3]/'deliveries/c6i-pl-vision-volume-osd-r17-20261023'
SPEC=importlib.util.spec_from_file_location('c0e_factory',ROOT/'python/pynq_multimodal_game/agent/pl_volume_factory.py')
FACTORY=importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(FACTORY)


class FactoryTests(unittest.TestCase):
    def test_threshold_byte_order_matches_actual_rtl_fields(self):
        self.assertEqual(FACTORY.capture_thresholds((0,20,70),(20,255,255)),(0,20,20,255,70,255))

    def test_legacy_literal_cannot_be_reinterpreted_as_valid_bounds(self):
        with self.assertRaises(ValueError):
            FACTORY.capture_thresholds((0,70,255),(20,20,255))

    def test_bad_types_order_and_hue_are_rejected(self):
        for lower,upper in (((False,20,70),(20,255,255)),((0.,20,70),(20,255,255)),
                            ((0,20),(20,255)),((0,20,70),(180,255,255)),
                            ((0,20,70),(20,19,255))):
            with self.subTest(lower=lower,upper=upper),self.assertRaises(ValueError):
                FACTORY.capture_thresholds(lower,upper)

    def test_wrong_or_closed_session_refuses_before_constructing_hardware(self):
        for session in (SimpleNamespace(build_id=0xC0060D00,is_open=True),
                        SimpleNamespace(build_id=0xC0060E00,is_open=False)):
            with self.assertRaises(ValueError):
                FACTORY.create_worker(session,None,None,None,'run',None,None,None)

    def test_worker_factory_uses_one_session_provider_and_r1_osd_observer(self):
        calls={}
        def tracker(**kwargs):
            self.assertEqual(kwargs,dict(dilate_iterations=4))
            return SimpleNamespace(lower=(0,20,70),upper=(20,255,255))
        def hardware(*args,**kwargs):
            calls['hardware']=(args,kwargs)
            return object()
        def worker(*args,**kwargs):
            calls['worker']=(args,kwargs)
            return SimpleNamespace()
        session=SimpleNamespace(build_id=0xC0060E00,is_open=True)
        provider,observer,camera,iic=object(),object(),object(),object()
        runtime=SimpleNamespace(DualMaskFullFrameTracker=tracker,SharedDualMaskHardware=hardware,
                                SharedDualMaskWorker=worker,BytesPreview=lambda *a:None)
        args=SimpleNamespace(vision_bind='host',vision_port=8081,vision_preview_fps=10,
                             vision_debug_fps=5,vision_output_dir=Path('/run'))
        with patch.dict(sys.modules,gesture_control=SimpleNamespace(GestureControl=lambda:object())):
            result=FACTORY.create_worker(session,provider,SimpleNamespace(publish=observer),args,'run1',runtime,camera,iic)
        self.assertIs(calls['hardware'][0][0],session)
        self.assertEqual(calls['hardware'][1]['thresholds'],(0,20,20,255,70,255))
        self.assertGreater(calls['hardware'][1]['epoch'],0)
        self.assertIs(calls['worker'][0][3],provider)
        self.assertEqual(calls['worker'][1]['capture_order'],'bgr')
        self.assertIs(result.osd_observer,observer)


if __name__=='__main__': unittest.main()
