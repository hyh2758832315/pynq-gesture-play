import csv
import json
import sys
import tempfile
import types
import unittest
from pathlib import Path
from threading import Event
from unittest.mock import MagicMock, patch
import numpy as np
import project1_live_ov5640 as live


class HostOnlyTests(unittest.TestCase):
    def test_select_never_touches_output_channel(self):
        read = MagicMock()
        class DMA:
            readchannel = read
            @property
            def writechannel(self):
                raise AssertionError('HDMI channel accessed')
        channel, display = live.select_frame_channels(DMA(), 'mode', True)
        self.assertIs(channel, read)
        self.assertIsNone(display)
        self.assertEqual(read.mode, 'mode')

    def test_disabled_writer_does_no_pixel_work(self):
        with patch.object(live, 'capture_to_rgb', side_effect=AssertionError('conversion')):
            with patch.object(live.np, 'copyto', side_effect=AssertionError('copy')):
                self.assertEqual(live.write_display_frame(None, None, None, 'bgr', 180, True, True), 0.)

    def test_hdmi_fallback_still_writes(self):
        dma = MagicMock()
        read, display = live.select_frame_channels(dma, 'mode')
        self.assertIs(read, dma.readchannel)
        self.assertIs(display, dma.writechannel)
        self.assertEqual(display.mode, 'mode')
        rgb = np.full((2, 3, 3), 42, np.uint8)
        output = np.empty_like(rgb)
        display.newframe.return_value = output
        self.assertGreaterEqual(live.write_display_frame(display, rgb, None, 'rgb', 0, False, False), 0)
        np.testing.assert_array_equal(output, rgb)
        display.writeframe.assert_called_once_with(output)

    def test_conflicting_osd_rejected_before_hardware(self):
        with patch.object(sys, 'argv', ['live', 'missing.bit', 'out.ppm', '--live', '--host-only', '--pl-osd']):
            with self.assertRaises(SystemExit) as exc:
                live.main()
        self.assertEqual(exc.exception.code, 2)

    def test_main_host_only_capture_preview_control_cleanup(self):
        stopped = Event()
        read = MagicMock()
        raw = np.zeros((720,1280,3), np.uint8)
        calls = [0]
        def capture():
            calls[0] += 1
            if calls[0] > 1:
                stopped.set()
            return raw
        read.readframe.side_effect = capture
        class DMA:
            readchannel = read
            @property
            def writechannel(self):
                raise AssertionError('host-only touched HDMI')
        overlay = MagicMock()
        camera = MagicMock(WIDTH=1280, HEIGHT=720, REQUIRED_IP={'frame_dma','camera_iic','demosaic'})
        camera.open_frame_dma.return_value = DMA()
        pynq = types.ModuleType('pynq'); pynq.Overlay = MagicMock(return_value=overlay)
        iic = types.ModuleType('pynq.lib.iic'); iic.AxiIIC = MagicMock()
        video = types.ModuleType('pynq.lib.video'); video.VideoMode = MagicMock(return_value='mode')
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root/'capture_camera_direct_plug.py').touch()
            args = ['live', str(Path(__file__).parent/'camera_hand_skin_v6.bit'), str(root/'first.ppm'),
                    '--live','--host-only','--tracking','--debug-view','--no-record',
                    '--duration','1','--camera-dir', str(root), '--results-dir',str(root/'results')]
            with patch.dict(sys.modules, {'pynq':pynq,'pynq.lib.iic':iic,'pynq.lib.video':video}), \
                 patch.object(sys,'argv',args), patch.object(live.os,'geteuid',return_value=0,create=True), \
                 patch.object(live.importlib,'import_module',return_value=camera), \
                 patch.object(live,'Event',return_value=stopped), patch.object(live,'BytesPreview') as preview, \
                 patch.object(live.signal,'signal'):
                live.main()
            read.start.assert_called_once(); read.stop.assert_called_once()
            preview.return_value.publish.assert_called_once()
            preview.return_value.publish_debug.assert_called_once()
            preview.return_value.close.assert_called_once()
            packet = json.loads(preview.return_value.publish_result.call_args.args[0])
            self.assertFalse(packet['hdmi_enabled'])
            self.assertIn('control',packet)
            run = next((root/'results').iterdir())
            config = json.loads((run/'run_config.json').read_text())
            self.assertFalse(config['hdmi_enabled'])
            self.assertEqual(config['preview_size'],[640,360])
            with (run/'frames.csv').open() as fp:
                rows = list(csv.DictReader(fp))
            self.assertEqual(len(rows),1)
            self.assertEqual(float(rows[0]['display_write_ms']),0)
            self.assertEqual(rows[0]['hdmi_enabled'],'False')
            self.assertEqual(rows[0]['pl_osd_applied'],'False')


if __name__ == '__main__': unittest.main()
