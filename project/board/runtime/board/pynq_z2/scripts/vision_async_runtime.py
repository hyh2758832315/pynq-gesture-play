"""Single-hand PS baseline over the validated OV5640 HDMI capture program.

Adapted from KPTKleist/Pynq_Gesture_Detect (2019), MIT license; see
PROJECT1_LICENSE.txt. No USB camera, PC inference, new bitstream or sensor table.
The original 300x300 ROI algorithm is retained; hardware integration, guards,
short consecutive-frame confirmation and tentative RPS labels are additions.
"""
import argparse
import asyncio
import csv
import importlib
from functools import partial
import hashlib
import json
import math
import os
import select
import shutil
import signal
import socket
import sys
import time
from collections import deque
from dataclasses import asdict
from pathlib import Path
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from threading import get_native_id
from threading import Condition, Event, Lock, Thread
from types import SimpleNamespace
from urllib.parse import urlsplit,parse_qs
from xml.etree import ElementTree

import cv2
import numpy as np


PROJECT_ROOT = Path(__file__).resolve().parents[3]
RUNTIME_DIR = Path(os.environ.get('VVG_VISION_RUNTIME_DIR',
                                  PROJECT_ROOT / 'handoffs/gesture_vision_v61/runtime'))
sys.path.insert(0, str(RUNTIME_DIR))
sys.path.insert(0, str(PROJECT_ROOT / 'python'))
from pynq_multimodal_game.vision_preview import ProcessPreviewEncoder, PreviewSnapshot
from pynq_multimodal_game.preview_recovery import RecoverablePreviewEncoder
from pynq_multimodal_game.agent.c6i_backend import BUILD_ID_IP, GPIO_DATA_OFFSET

sys.path.insert(0, str(PROJECT_ROOT))
from board.pynq_z2.dual_mask_packet import read_capture_epoch_status
from board.pynq_z2.vision_capture_control import VisionFrameOwnerControl, capture_context_words
from board.pynq_z2.vision_dma_pool import VisionCapturePool


CAMERA_DIR = Path('/home/xilinx/voice-view-game/camera-corrected-hdmi-prototype')
ROI = (170, 30, 470, 330)  # half-open coordinates on the 640x360 PS view


def write_guard_receipt(path, state, run_id, frame_id, cleanup=None, retaining_buffers=False, primary_error=None):
    if path is None:
        return
    payload = dict(state=state, owner_pid=os.getpid(), session_id=path.parent.name,
                   run_id=run_id, frame_id=frame_id, cleanup=cleanup,
                   retaining_buffers=retaining_buffers,
                   primary_error=dict(type=type(primary_error).__name__, message=str(primary_error))
                   if primary_error is not None else None)
    temporary = path.with_suffix('.tmp')
    temporary.write_text(json.dumps(payload), encoding='utf-8')
    os.replace(temporary, path)


def retain_for_guard():
    Event().wait()


def capture_to_rgb(capture, capture_order='rgb'):
    """Interpret camera memory once; always return owned RGB pixels."""
    if capture.shape != (720, 1280, 3) or capture.dtype != np.uint8:
        raise ValueError('expected uint8 1280x720 capture')
    if capture_order not in ('rgb', 'bgr'):
        raise ValueError('capture order must be rgb or bgr')
    return cv2.cvtColor(capture, cv2.COLOR_BGR2RGB) if capture_order == 'bgr' else capture.copy()


def rgb_to_display(rgb, capture_order):
    # The selected camera overlay uses the same packed order on S2MM/MM2S.
    if capture_order not in ('rgb', 'bgr'):
        raise ValueError('capture order must be rgb or bgr')
    return cv2.cvtColor(rgb, cv2.COLOR_RGB2BGR) if capture_order == 'bgr' else rgb


def select_frame_channels(dma, mode, host_only=False):
    """Host-only never obtains/configures the HDMI MM2S channel."""
    channel = dma.readchannel
    channel.mode = mode
    display = None
    if not host_only:
        display = dma.writechannel
        display.mode = mode
    return channel, display


def prepare_skin_factory(factory, hwh):
    path = Path(hwh).resolve(strict=True)
    data = path.read_bytes()
    digest = hashlib.sha256(data).digest()
    tree = ElementTree.ElementTree(ElementTree.fromstring(data))
    module = sys.modules[factory.__module__]

    def cached_parse(source):
        requested = Path(source).resolve(strict=True)
        if requested != path or hashlib.sha256(requested.read_bytes()).digest() != digest:
            raise ValueError('cached skin HWH paired identity changed')
        return tree

    def create(*arguments, **keywords):
        previous = module.ElementTree
        module.ElementTree = SimpleNamespace(parse=cached_parse)
        try:
            return factory(*arguments, **keywords)
        finally:
            module.ElementTree = previous

    return create


class SharedVisionHardware:
    INSTANCES = frozenset({'camera_iic', 'demosaic', 'frame_dma',
                           'moments_dma', 'moments_reset', 'skin_kernel'})

    def __init__(self, session, camera, skin_factory, iic_factory, mode_factory, timeout=2., skin_frame_shape=None, stage_trace=None):
        if not math.isfinite(timeout) or timeout <= 0:
            raise ValueError('positive finite halt timeout required')
        if skin_frame_shape is not None and (type(skin_frame_shape) is not tuple or len(skin_frame_shape) != 2
                or any(type(size) is not int for size in skin_frame_shape)
                or not 1 <= skin_frame_shape[0] <= 720 or not 1 <= skin_frame_shape[1] <= 1280):
            raise ValueError('bounded skin frame shape required')
        self._session = session
        self.lease = None
        self.camera, self.skin_factory = camera, skin_factory
        self.skin_frame_shape = skin_frame_shape
        self.iic_factory, self.mode_factory = iic_factory, mode_factory
        self.timeout = timeout
        self.skin = self.dma = self.channel = self.demosaic = None
        self.retained = deque(maxlen=12)
        self.recycle_frames = False
        self.cooperative_copy = False
        self.last_read_timing = None
        self.state = 'IDLE'
        self.error = None
        self.stage_trace = stage_trace

    def _stage(self, name):
        if self.stage_trace is not None and len(self.stage_trace) < 64:
            self.stage_trace.append({"stage": name, "monotonic_ns": time.monotonic_ns(),
                                     "native_id": get_native_id()})

    def start(self):
        if self.state != 'IDLE':
            raise RuntimeError('create a new vision hardware borrower for each start')
        self.state = 'STARTING'
        try:
            self._stage('borrow_begin')
            self.lease = self._session.borrow('vision', instances=self.INSTANCES)
            self.lease.retain(self)
            description = self.lease.ip_dict['frame_dma']
            if str(description['parameters']['C_INCLUDE_MM2S']) != '0':
                raise ValueError('shared vision requires a capture-only VDMA')
            if 's2mm_introut' not in description['interrupts']:
                raise ValueError('shared capture HWH must contain S2MM interrupt metadata')
            self._stage('skin_begin')
            self.skin = self.skin_factory(self.lease, allocator=self.lease.allocate)
            self._stage('skin_returned')
            if self.skin_frame_shape is not None:
                if self.skin._buffers:
                    raise RuntimeError('skin root buffers must be fresh before preallocation')
                pixels = math.prod(self.skin_frame_shape)
                for words in (5 + (3 * pixels + 3) // 4, 8 + (pixels + 3) // 4):
                    self.skin._buffers.append(self.lease.allocate(shape=(words,), dtype=np.uint32))
                self.skin._tx_view = np.asarray(self.skin._buffers[0])
                self.skin._rx_view = np.asarray(self.skin._buffers[1])
            self._stage('sensor_begin')
            iic = self.iic_factory(self.lease.ip_dict['camera_iic'])
            self.camera.probe_chip_id(iic)
            self.camera.configure_sensor(iic)
            self._stage('sensor_returned')
            self.demosaic = self.lease.demosaic
            self.demosaic.write(0x10, self.camera.WIDTH)
            self.demosaic.write(0x18, self.camera.HEIGHT)
            self.demosaic.write(0x28, 1)
            self.demosaic.write(0, 0x81)
            self._stage('dma_open_begin')
            self.dma = self.camera.open_frame_dma(self.lease, Path(self.lease.bitfile_name).with_suffix('.hwh'))
            self._stage('dma_open_returned')
            self._stage('mode_begin')
            self.channel, _ = select_frame_channels(
                self.dma, self.mode_factory(self.camera.WIDTH, self.camera.HEIGHT, 24), True)
            self._stage('mode_returned')
            self._stage('channel_start_begin')
            self.channel.start()
            self._stage('channel_start_returned')
            self.state = 'RUNNING'
        except BaseException as error:
            self.state, self.error = 'FAULT', f'{type(error).__name__}: {error}'
            raise

    def read(self):
        if self.state != 'RUNNING':
            raise RuntimeError('shared vision capture is not running')
        started = time.monotonic() if self.recycle_frames else None
        self._stage('readframe_begin')
        captured = self.channel.readframe()
        self._stage('readframe_returned')
        self.retained.append(captured)
        read_finished = time.monotonic() if self.recycle_frames else None
        source = np.asarray(captured)
        self._stage('copy_begin')
        if self.cooperative_copy:
            copied = np.empty_like(source)
            for row in range(0, source.shape[0], 16):
                copied[row:row+16] = source[row:row+16]
                if row+16 < source.shape[0]:
                    time.sleep(.0001)
        else:
            copied = source.copy()
        self._stage('copy_returned')
        if self.recycle_frames:
            copy_finished = time.monotonic()
            captured.freebuffer()
            self.retained.pop()
            self.last_read_timing = dict(readframe_seconds=read_finished-started,
                copy_seconds=copy_finished-read_finished, return_seconds=time.monotonic()-copy_finished)
        return copied

    def stop(self):
        if self.state == 'STOPPED':
            return
        self.state = 'STOPPING'
        errors = []
        if self.skin is not None:
            try:
                self.skin.halt()
            except BaseException as error:
                errors.append(f'SKN6 halt: {type(error).__name__}: {error}')
        if self.dma is not None:
            try:
                mmio = self.dma.mmio
                mmio.write(0x30, mmio.read(0x30) & ~1)
                deadline = time.monotonic() + self.timeout
                while not mmio.read(0x34) & 1:
                    if time.monotonic() >= deadline:
                        raise TimeoutError('capture DMA halt not confirmed')
                    time.sleep(.0001)
            except BaseException as error:
                errors.append(f'capture halt: {type(error).__name__}: {error}')
        if errors:
            self.state, self.error = 'FAULT', '; '.join(errors)
            raise RuntimeError(self.error + '; buffers and Overlay borrower retained')
        try:
            if self.demosaic is not None:
                self.demosaic.write(0, 0)
            if self.skin is not None:
                self.skin.close()
            if self.channel is not None:
                self.channel.stop()
            self.retained.clear()
        except BaseException as error:
            self.state, self.error = 'FAULT', f'cleanup: {type(error).__name__}: {error}'
            raise
        if self.lease is not None:
            self.lease.close()
        self.state, self.error = 'STOPPED', None


class SharedDualMaskHardware:
    profile = 'C6I_PL_VISION_BUTTON_OSD_V1'
    build_id = '0xC0061000'
    INSTANCES = frozenset({'camera_iic', 'demosaic', 'frame_dma', 'moments_dma',
                           'capture_control', 'capture_status', 'moments_reset', BUILD_ID_IP})
    DMA_PARAMETERS = {
        'frame_dma': {'C_INCLUDE_MM2S': 0, 'C_INCLUDE_S2MM': 1, 'C_INCLUDE_SG': 0,
                      'C_NUM_FSTORES': 3, 'C_M_AXI_S2MM_DATA_WIDTH': 64,
                      'C_S_AXIS_S2MM_TDATA_WIDTH': 24, 'C_INCLUDE_S2MM_DRE': 0,
                      'C_INCLUDE_S2MM_SF': 1, 'C_USE_FSYNC': 1},
        'moments_dma': {'C_INCLUDE_MM2S': 0, 'C_INCLUDE_S2MM': 1, 'C_INCLUDE_SG': 1,
                        'C_M_AXI_S2MM_DATA_WIDTH': 64, 'C_S_AXIS_S2MM_TDATA_WIDTH': 64,
                        'C_M_AXI_SG_DATA_WIDTH': 32, 'C_INCLUDE_S2MM_DRE': 0,
                        'C_INCLUDE_S2MM_SF': 1},
    }

    def __init__(self, session, camera, iic_factory, *, epoch, config_id, thresholds, timeout=2.):
        capture_context_words(frame_id=1, config_id=config_id, epoch=epoch, thresholds=thresholds)
        if not math.isfinite(timeout) or timeout <= 0:
            raise ValueError('positive finite dual-mask timeout required')
        self._session, self.camera, self.iic_factory = session, camera, iic_factory
        self.epoch, self.config_id, self.thresholds = epoch, config_id, thresholds
        self.timeout = timeout
        self.lease = self.pool = self.demosaic = None
        self.skin = None
        self.state, self.error = 'IDLE', None
        self.drain_consumer = None
        self.preview_demand = None

    def start(self):
        if self.state != 'IDLE':
            raise RuntimeError('dual-mask borrower cannot be restarted or retried')
        self.state = 'STARTING'
        try:
            self.lease = self._session.borrow('vision-dual-mask', instances=self.INSTANCES)
            self.lease.retain(self)
            observed_build_id = int(self.lease.mmio(BUILD_ID_IP).read(GPIO_DATA_OFFSET))
            expected_build_id = int(self._session.build_id)
            if observed_build_id != expected_build_id:
                raise RuntimeError('dual-mask borrower BUILD_ID mismatch: '
                                   f'expected 0x{expected_build_id:08X}, '
                                   f'got 0x{observed_build_id:08X}')
            for name, expected in self.DMA_PARAMETERS.items():
                parameters = self.lease.ip_dict[name]['parameters']
                if any(int(str(parameters[key]), 0) != value for key, value in expected.items()):
                    raise ValueError('dual-mask DMA capability mismatch: ' + name)
            if (self.camera.WIDTH, self.camera.HEIGHT) != (1280, 720):
                raise ValueError('dual-mask capture requires frozen 1280x720 sensor mode')
            control, status = self.lease.mmio('capture_control'), self.lease.mmio('capture_status')
            rgb, packet = self.lease.mmio('frame_dma'), self.lease.mmio('moments_dma')
            for name, registers, error_mask, halted_mask in (
                    ('frame_dma', rgb, 0xC9F0, 1), ('moments_dma', packet, 0x4770, 9)):
                dma_control, dma_status = registers.read(0x30), registers.read(0x34)
                if dma_control & 5 or dma_status & halted_mask != halted_mask or dma_status & error_mask:
                    raise RuntimeError('dual-mask reset release requires halted error-free ' + name)
            reset = self.lease.mmio('moments_reset')
            if reset.read(0) != 0:
                raise RuntimeError('dual-mask reset GPIO is not freshly asserted')
            reset.write(4, 0)
            reset.write(0, 1)
            if reset.read(0) != 1:
                raise RuntimeError('dual-mask reset release readback failed')
            owner = VisionFrameOwnerControl(control.read, control.write)
            self.pool = VisionCapturePool(owner, self.lease.allocate, rgb.read, rgb.write,
                                          packet.read, packet.write,
                                          lambda: read_capture_epoch_status(status.read), timeout=self.timeout)
            self.lease.retain(self.pool)
            iic = self.iic_factory(self.lease.ip_dict['camera_iic'])
            self.camera.probe_chip_id(iic)
            self.camera.configure_sensor(iic)
            self.demosaic = self.lease.mmio('demosaic')
            self.demosaic.write(0x10, self.camera.WIDTH)
            self.demosaic.write(0x18, self.camera.HEIGHT)
            self.demosaic.write(0x28, 1)
            self.demosaic.write(0, 0x81)
            self.pool.start(epoch=self.epoch, config_id=self.config_id, thresholds=self.thresholds)
            self.state = 'RUNNING'
        except BaseException as error:
            self.state, self.error = 'RETAINED', f'{type(error).__name__}: {error}'
            raise

    def read(self):
        if self.state != 'RUNNING':
            raise RuntimeError('dual-mask borrower is not running')
        try:
            deadline = time.monotonic() + self.timeout
            while True:
                include_rgb = bool(self.preview_demand and self.preview_demand())
                frame = self.pool.read(include_rgb=include_rgb)
                if frame is not None:
                    return frame
                if time.monotonic() >= deadline:
                    raise TimeoutError('dual-mask completed frame not available')
                time.sleep(.001)
        except BaseException as error:
            self.state, self.error = 'RETAINED', f'{type(error).__name__}: {error}'
            raise

    def stop(self):
        if self.state in ('IDLE', 'STOPPED'):
            self.state = 'STOPPED'
            return
        if self.state != 'RUNNING' or not callable(self.drain_consumer):
            raise RuntimeError('dual-mask stop requires a running borrower and drain consumer; resources retained')
        self.state = 'STOPPING'
        try:
            self.pool.stop(self.drain_consumer)
            print('CAPTURE_PACKET_DMA_STOP_MODE=' + str(self.pool.packets.stop_mode), flush=True)
            self.demosaic.write(0, 0)
            # pool.stop has sealed the source, drained writes and halted both DMAs.
            # Recheck independent DMA interfaces before asserting the shared reset.
            for name, error_mask, halted_mask in (('frame_dma', 0xC9F0, 1),
                                                  ('moments_dma', 0x4770, 9)):
                registers = self.lease.mmio(name)
                control, status = registers.read(0x30), registers.read(0x34)
                if control & 5 or status & halted_mask != halted_mask or status & error_mask:
                    raise RuntimeError('dual-mask STOP reset requires halted error-free ' + name)
            reset = self.lease.mmio('moments_reset')
            reset.write(0, 0)
            if reset.read(0) != 0:
                raise RuntimeError('dual-mask STOP reset assertion readback failed')
            self.lease.close()
            self.state = 'STOPPED'
        except BaseException as error:
            self.state, self.error = 'RETAINED', f'{type(error).__name__}: {error}'
            raise


def lower_vision_worker_cpu_priority():
    if not all(hasattr(os, name) for name in ('PRIO_PROCESS', 'getpriority', 'setpriority')):
        raise RuntimeError('Vision CPU scheduling diagnostic requires Linux per-thread priority')
    native_id = get_native_id()
    previous = os.getpriority(os.PRIO_PROCESS, native_id)
    target = max(previous, 5)
    os.setpriority(os.PRIO_PROCESS, native_id, target)
    confirmed = os.getpriority(os.PRIO_PROCESS, native_id)
    if confirmed != target:
        raise RuntimeError('Vision worker CPU priority unconfirmed')
    return dict(native_id=native_id, previous_nice=previous, confirmed_nice=confirmed)


class SharedVisionWorker:
    def __init__(self, hardware, recognizer, controller, input_provider, *, run_id,
                 config_epoch='default', rotate=180, mirror=False, capture_order='rgb',
                 preview_encoder=None, preview_factory=None, video_fps=10., debug_fps=5., run_dir=None,
                 frame_processor=None, preview_unlimited=False):
        if not isinstance(run_id, str) or not run_id or len(run_id) > 256:
            raise ValueError('valid vision run_id required')
        self.hardware, self.recognizer = hardware, recognizer
        self.frame_processor = frame_processor
        self.capture_validator = None
        self.controller, self.input_provider = controller, input_provider
        self.run_id, self.config_epoch = run_id, config_epoch
        self.rotate, self.mirror, self.capture_order = rotate, mirror, capture_order
        self.preview_encoder = preview_encoder
        self.preview_factory = preview_factory
        self.preview = None
        self._preview_prepared = False
        self._preview_preparation_attempted = False
        self.video_fps, self.debug_fps = video_fps, debug_fps
        self.preview_unlimited = preview_unlimited
        self.cooperative_cpu = False
        self.cpu_scheduling = {}
        self.measure_processing = False
        self.processing_timing = {}
        self.run_dir = Path(run_dir) if run_dir is not None else None
        self.frame_id = 0
        self.error = None
        self.diagnostic_error = None
        self._stop = Event()
        self._processing_pause = Event()
        self._processing_paused = Event()
        self._processing_resume = Event()
        self._processing_resume.set()
        self._processing_resumed = Event()
        self._processing_resumed.set()
        self._thread = None

    @property
    def state(self):
        return 'FAULT' if self.error is not None else self.hardware.state

    def step(self):
        if self.measure_processing:
            read_started_ns = time.monotonic_ns()
            read_cpu_started_ns = time.thread_time_ns()
        raw = self.hardware.read()
        if self.measure_processing:
            self.processing_timing['last_read'] = dict(
                wall_ns=time.monotonic_ns() - read_started_ns,
                cpu_ns=time.thread_time_ns() - read_cpu_started_ns)
        self._process_frame(raw)

    def _process_frame(self, raw):
        if self._stop.is_set() and self.frame_processor is None:
            return
        capture = {}
        if self.frame_processor is not None:
            if self.capture_validator is not None:
                capture = self.capture_validator(raw)
            elif raw.frame_id != self.frame_id + 1:
                raise RuntimeError('dual-mask worker frame identity is not consecutive')
        self.frame_id += 1
        self.recognizer.result_frame_id = self.frame_id
        encoder = self.preview_encoder
        modes = frozenset()
        if encoder is not None:
            try:
                health_method = getattr(encoder, 'health', None)
                health = health_method() if health_method is not None else None
                if self.preview is not None and health is not None:
                    self.preview.update_health(asdict(health))
                if health is None or health.healthy:
                    if self.diagnostic_error == 'preview encoder degraded':self.diagnostic_error=None
                    modes = encoder.due_modes()
                else:
                    self.diagnostic_error = 'preview encoder degraded'
            except Exception as error:
                self.diagnostic_error = f'{type(error).__name__}: {error}'
        if self.frame_processor is not None and (self._stop.is_set() or getattr(raw, 'rgb', None) is None):
            modes = frozenset()
        self.recognizer.debug_enabled = 'debug' in modes
        early = {}

        def publish(observed):
            control = self.controller.update(observed, self.frame_id, time.monotonic())
            early['control'] = control
            if not self._stop.is_set():
                observed_ns = capture['ready_monotonic_ns'] if capture else None
                age_ms = max(0., (time.monotonic_ns() - observed_ns) / 1e6) if capture else 0.
                packet = dict(run_id=self.run_id, frame=self.frame_id, server_age_ms=age_ms, control=control,
                              stable=observed.get('stable'), rps=observed.get('rps', 'UNKNOWN'))
                # UI pointing remains available for a detected hand at the
                # frame edge; gameplay validity/classification is unchanged.
                centroid = observed.get('centroid')
                if centroid is not None and observed.get('bbox') is not None:
                    packet['ui_pointer'] = dict(schema='menu-pointer-v1',
                        u=(centroid[0]-319.5)/320., v=(centroid[1]-179.5)/180.)
                if capture:
                    packet['capture'] = dict(capture)
                self.input_provider.publish(packet, config_epoch=self.config_epoch)
                observer = getattr(self, "osd_observer", None)
                if observer is not None:
                    observer(observed, run_id=self.run_id, config_epoch=self.config_epoch,
                             frame_id=self.frame_id, observed_ns=observed_ns if capture else time.monotonic_ns())
                wants_result = getattr(self.preview, 'wants_result', None)
                if self.preview is not None and (not callable(wants_result) or wants_result()):
                    try:
                        box, centroid = observed.get('bbox'), observed.get('centroid')
                        packet.update(
                            bbox_640x360=box, bbox_1280x720=[int(value)*2 for value in box] if box else None,
                            detected=box is not None, raw=observed.get('code'), stable=observed.get('stable'),
                            centroid_valid=centroid is not None, centroid_640x360=centroid,
                            centroid_1280x720=[value*2+.5 for value in centroid] if centroid else None,
                            coordinate_space='display view after rotation/mirror; half-open xyxy',
                            centroid_kind='selected observed skin pixel area center, not palm center',
                            pixel_stats=observed.get('pixel_stats'), timing_ms=observed.get('timing_ms'),
                            fingers=observed.get('fingers'), area=observed.get('area'),
                            ratio=observed.get('ratio'),
                            pl_skin=observed.get('pl_skin'), rps=observed.get('rps', 'UNKNOWN'),
                            hand_state=observed.get('hand_state', 'UNKNOWN'),
                            touches_frame_or_roi=observed.get('touches_roi'),
                            tracking=observed.get('tracking', False), display_owner='GPU')
                        self.preview.publish_result(json.dumps(packet).encode('utf-8'))
                    except Exception as error:
                        self.diagnostic_error = f'{type(error).__name__}: {error}'

        processor = self.frame_processor or process_rgb
        processed, result = processor(raw, self.recognizer, self.rotate, self.mirror,
                          self.capture_order, output_size=(640, 360),
                          on_result=publish, annotate=False,
                          preview_rgb='video' in modes)
        if self.measure_processing:
            self.processing_timing['last_recognition_ms'] = dict(result['timing_ms'])
        result['preview_needs_annotation'] = True
        if encoder is not None and (self.frame_processor is None or modes):
            try:
                submit = (getattr(encoder, 'submit_deferred', encoder.submit)
                          if self.frame_processor is not None else encoder.submit)
                submit(lambda requested: PreviewSnapshot(
                    self.frame_id, requested & modes,
                    processed if 'video' in (requested & modes) else None, result, early['control']))
            except Exception as error:
                self.diagnostic_error = f'{type(error).__name__}: {error}'

    def prepare_preview(self):
        if self._preview_prepared:
            return
        if self._preview_preparation_attempted:
            raise RuntimeError('Preview preparation failed; retain prior evidence')
        self._preview_preparation_attempted = True
        if self.run_dir is not None:
            self.run_dir.mkdir(parents=True, exist_ok=False)
            (self.run_dir / 'run_config.json').write_text(json.dumps(dict(
                schema='shared-vision-run-v1', profile=getattr(self.hardware, 'profile', 'C6I_VISION'), run_id=self.run_id,
                config_epoch=self.config_epoch, build_id=getattr(self.hardware, 'build_id', '0xC0060800'), board_pending=True,
                rotate=self.rotate, mirror=self.mirror, capture_order=self.capture_order,
                recognizer=type(self.recognizer).__name__, search_roi=getattr(self.recognizer, 'roi', None),
                pl_skin_mode='validate' if getattr(self.recognizer, 'skin_validate', True) else 'performance',
                video_fps=self.video_fps, debug_fps=self.debug_fps)), encoding='utf-8')
        if self.preview_factory is not None:
            self.preview = self.preview_factory()

            def publish_snapshot(mode, payload):
                if mode == 'debug':
                    self.preview.publish_debug(payload)
                else:
                    self.preview.publish(payload)

            def make_encoder(recovering=False):
                encoder=ProcessPreviewEncoder(
                    self.preview.demand, encode_preview_snapshot, publish_snapshot,
                    video_fps=self.video_fps, debug_fps=self.debug_fps, startup_timeout=10. if recovering else 30.,
                    startup_log=None if self.run_dir is None else self.run_dir / 'preview-startup.jsonl')
                encoder.unlimited=self.preview_unlimited
                return encoder
            self.preview_encoder=(RecoverablePreviewEncoder(make_encoder) if self.preview_unlimited
                                  else make_encoder())
            self.preview.update_health(asdict(self.preview_encoder.health()))
        self._preview_prepared = True

    def start(self):
        if self._thread is not None:
            raise RuntimeError('create a new vision worker for each start')
        self._thread = Thread(target=self._run, name='voice-view-local-vision', daemon=True)
        self._thread.start()

    def pause_processing(self, timeout=6.):
        if self._thread is None or not self._thread.is_alive() or self._stop.is_set() or self.error:
            raise RuntimeError('running vision worker required for processing pause')
        if not self._processing_resumed.wait(timeout):
            raise RuntimeError('prior vision processing resume not acknowledged')
        self._processing_resume.clear()
        self._processing_pause.set()
        if not self._processing_paused.wait(timeout):
            self.resume_processing()
            raise RuntimeError('vision processing pause not acknowledged')
        if self._stop.is_set() or self.error or not self._thread.is_alive():
            self.resume_processing()
            raise RuntimeError('vision worker stopped during processing pause')

    def resume_processing(self):
        self._processing_pause.clear()
        self._processing_resume.set()

    def _run(self):
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        try:
            self.prepare_preview()
            self.hardware.start()
            self.recognizer.skin_backend = self.hardware.skin
            if self.cooperative_cpu:
                self.cpu_scheduling.update(lower_vision_worker_cpu_priority())
            while not self._stop.is_set():
                if self._processing_pause.is_set():
                    self._processing_resumed.clear()
                    self._processing_paused.set()
                    self._processing_resume.wait()
                    self._processing_paused.clear()
                    self._processing_resumed.set()
                    continue
                if not self.measure_processing:
                    self.step()
                    continue
                started_ns = time.monotonic_ns()
                cpu_started_ns = time.thread_time_ns()
                try:
                    self.step()
                finally:
                    cpu_ns = time.thread_time_ns() - cpu_started_ns
                    finished_ns = time.monotonic_ns()
                    wall_ns = finished_ns - started_ns
                    timing = self.processing_timing
                    timing.update(
                        native_id=get_native_id(), steps=timing.get('steps', 0) + 1,
                        first_started_ns=timing.get('first_started_ns', started_ns),
                        last_finished_ns=finished_ns,
                        wall_ns=timing.get('wall_ns', 0) + wall_ns,
                        cpu_ns=timing.get('cpu_ns', 0) + cpu_ns,
                        max_wall_ns=max(timing.get('max_wall_ns', 0), wall_ns),
                        max_cpu_ns=max(timing.get('max_cpu_ns', 0), cpu_ns),
                        recent_steps=[*timing.get('recent_steps', ())[-15:],
                                      dict(started_ns=started_ns, finished_ns=finished_ns, cpu_ns=cpu_ns)])
        except BaseException as error:
            self.error = f'{type(error).__name__}: {error}'
            self.input_provider.release(self.error)
        finally:
            loop.close()

    def stop(self, timeout=6.):
        self._stop.set()
        self._processing_resume.set()
        errors = []

        def attempt(stage, operation):
            try:
                operation()
            except BaseException as error:
                errors.append((stage, error))

        def failed():
            details = '; '.join(f'{stage}: {type(error).__name__}: {error}'
                                for stage, error in errors)
            self._cleanup_errors = details
            if any(stage in ('preview codec', 'preview HTTP') for stage, _ in errors):
                self.diagnostic_error = self.diagnostic_error or details
            self.error = self.error or details
            raise RuntimeError('vision cleanup incomplete: '+details) from errors[0][1]

        attempt('input suspend', self.input_provider.suspend)
        attempt('input release', lambda: self.input_provider.release('Vision worker stopped'))
        if self._thread is not None:
            self._thread.join(timeout)
            if self._thread.is_alive():
                # Recognition may still access its buffers/codec. Retain all
                # resources until that producer is known to have exited.
                errors.append(('recognition', RuntimeError(
                    'vision worker did not stop; hardware and borrower retained')))
                failed()
            attempt('final input release', lambda: self.input_provider.release('Vision worker stopped'))
        attempt('hardware stop', self.hardware.stop)
        # Once recognition is stopped these CPU-only resources are independent
        # of camera/DMA cleanup. A retained hardware owner need not keep an
        # unused codec process and HTTP worker running as well.
        for stage, resource in (('preview codec', self.preview_encoder), ('preview HTTP', self.preview)):
            close = getattr(resource, 'close', None)
            if close is not None:
                try:
                    close()
                except BaseException as error:
                    # A dead CPU-only codec with closed relay/SHM cannot retain
                    # camera DMA. Preserve the unclean exit as a diagnostic;
                    # unknown, live or incompletely released resources remain
                    # fatal. HTTP and all hardware failures retain ownership.
                    if stage=='preview codec' and getattr(resource,'release_confirmed',False) is True:
                        self.diagnostic_error=f'{stage}: {type(error).__name__}: {error}'
                    else:
                        errors.append((stage,error))
        if errors:
            failed()
        if self.run_dir is not None and self.run_dir.exists():
            (self.run_dir / 'stop_receipt.json').write_text(json.dumps(dict(
                schema='shared-vision-stop-v1', run_id=self.run_id, frames=self.frame_id,
                cleanup_confirmed=True, error=self.error, diagnostic_error=self.diagnostic_error,
                validation_scope='software lifecycle; board validation separate')), encoding='utf-8')


def write_display_frame(display, processed, raw, capture_order, rotate, mirror, pl_osd):
    """Return zero without conversions, allocation or write in host-only mode."""
    if display is None:
        return 0.
    started = time.perf_counter()
    output = display.newframe()
    hdmi_rgb = processed
    if pl_osd:
        hdmi_rgb = capture_to_rgb(raw, capture_order)
        if rotate == 180:
            hdmi_rgb = cv2.rotate(hdmi_rgb, cv2.ROTATE_180)
        if mirror:
            hdmi_rgb = cv2.flip(hdmi_rgb, 1)
    np.copyto(output, rgb_to_display(hdmi_rgb, capture_order))
    display.writeframe(output)
    return (time.perf_counter()-started)*1000


class CalibrationCapture:
    """Six bounded, same-frame samples; called only by the DMA owner thread."""
    stages = ('EMPTY_BACKGROUND', 'OPEN_HAND', 'FIST')
    schedule = ((10., 0), (12., 0), (25., 1), (27., 1), (40., 2), (42., 2))

    def __init__(self, directory, rotate=180, mirror=False, capture_order='rgb', rps=False):
        if capture_order not in ('rgb', 'bgr'):
            raise ValueError('capture order must be rgb or bgr')
        self.capture_order = capture_order
        if rps:
            self.stages = self.stages + ('SCISSORS',)
            self.schedule = self.schedule + ((55., 3), (57., 3))
        self.directory = Path(directory) / 'calibration'
        self.directory.mkdir(exist_ok=False)
        self.rotate, self.mirror = rotate, mirror
        self.pending, self.samples, self.missed = list(self.schedule), [], []
        self.stage = None

    def cue(self, elapsed):
        stage = min(int(elapsed // 15), len(self.stages)-1)
        if stage != self.stage:
            self.stage = stage
            print(f'CALIBRATION_STAGE={self.stages[stage]} elapsed={elapsed:.1f}s', flush=True)
        return f'CALIBRATION: {self.stages[stage]} t={elapsed:.1f}s'

    def capture(self, raw, overlay, result, frame, elapsed):
        if not self.pending or elapsed < self.pending[0][0]:
            return
        due, stage = self.pending.pop(0)
        # Never label a late frame as an earlier requested gesture.
        if elapsed >= (stage + 1) * 15 or elapsed - due > 3:
            self.missed.append(due)
            self._manifest()
            print(f'CALIBRATION_MISSED=target_{due:.0f}s', flush=True)
            return
        stem = f'{self.stages[stage].lower()}_{int(due):02d}s'
        # NPY preserves the actual DMA channel order, without guessing RGB/BGR.
        np.save(str(self.directory / (stem + '_capture.npy')), raw, allow_pickle=False)
        view = capture_to_rgb(raw, self.capture_order)
        if self.rotate == 180:
            view = cv2.rotate(view, cv2.ROTATE_180)
        if self.mirror:
            view = cv2.flip(view, 1)
        for suffix, array in [('_raw.png', cv2.cvtColor(view, cv2.COLOR_RGB2BGR)),
                              ('_mask.png', result['mask']),
                              ('_overlay.jpg', cv2.cvtColor(overlay, cv2.COLOR_RGB2BGR))]:
            if not cv2.imwrite(str(self.directory / (stem + suffix)), array):
                raise OSError('cannot write calibration sample ' + stem + suffix)
        info = dict(sample=stem, frame=frame, elapsed_s=round(elapsed, 3), target_s=due,
                    requested_scene=self.stages[stage], scene_verified=False,
                    capture_order=self.capture_order, channel_order_hardware_verified=False,
                    capture_shape=list(raw.shape), rotate=self.rotate, mirror=self.mirror,
                    roi_640x360=list(result.get('roi', ROI)), mask_coordinates='ROI local',
                    raw=result['code'], stable=result['stable'], bbox=result['bbox'],
                    area=result['area'], gap_percent=result['ratio'], error=result['error'],
                    touches_roi=result['touches_roi'],
                    dilate_iterations=result['dilate_iterations'], defect_depth=result['defect_depth'],
                    hand_state=result.get('hand_state','UNKNOWN'), tracking=result.get('tracking',False),
                    centroid_640x360=result.get('centroid'), pixel_stats=result.get('pixel_stats'),
                    timing_ms=result.get('timing_ms'), effective_defect_depth=result.get('effective_defect_depth'))
        (self.directory / (stem + '_result.json')).write_text(json.dumps(info, indent=2), encoding='utf-8')
        self.samples.append(info)
        self._manifest()
        print(f'CALIBRATION_SAVED={self.directory / stem} frame={frame}', flush=True)

    def _manifest(self):
        (self.directory / 'manifest.json').write_text(json.dumps(dict(
            samples=self.samples, missed_targets=self.missed,
            pending_targets=[due for due, _ in self.pending]), indent=2), encoding='utf-8')

    def close(self):
        self._manifest()
        # Include the complete temporal log, not only the eight static samples.
        log = self.directory.parent / 'frames.csv'
        if log.is_file():
            shutil.copy2(log, self.directory / 'frames.csv')
        config = self.directory.parent / 'run_config.json'
        if config.is_file():
            shutil.copy2(config, self.directory / config.name)
        archive = shutil.make_archive(str(self.directory.parent / 'calibration_download'),
                                      'zip', root_dir=str(self.directory.parent), base_dir='calibration')
        print(f'CALIBRATION_ZIP={archive}', flush=True)
        print(f'CALIBRATION_COMPLETE={len(self.samples)}/{len(self.schedule)} directory={self.directory}', flush=True)


class VideoRecorder:
    """Bounded MJPEG AVI recording of owned RGB frames, with timestamp mapping."""
    def __init__(self, directory, fps=8., max_mb=128):
        if not 1 <= fps <= 15 or max_mb < 1:
            raise ValueError('invalid recording rate or size limit')
        self.directory = Path(directory)
        self.path = self.directory / 'gesture_overlay.avi'
        self.fps, self.max_bytes = float(fps), int(max_mb * 1024 * 1024)
        self.writer = cv2.VideoWriter(str(self.path), cv2.VideoWriter_fourcc(*'MJPG'), self.fps, (640, 360))
        if not self.writer.isOpened():
            self.writer.release()
            raise RuntimeError('MJPG AVI encoder unavailable; use --no-record for recognition only')
        self.frames, self.next_time, self.samples, self.limited = 0, 0., [], False
        self.closed = False

    def write(self, rgb, elapsed):
        if self.closed or self.limited or elapsed + 1e-9 < self.next_time:
            return None
        if self.path.exists() and self.path.stat().st_size >= self.max_bytes:
            self.limited = True
            print('PROJECT1_RECORDING_SIZE_LIMIT=STOP_RECORDING_ONLY', flush=True)
            return None
        bgr = cv2.cvtColor(cv2.resize(rgb, (640, 360), interpolation=cv2.INTER_AREA), cv2.COLOR_RGB2BGR)
        self.writer.write(bgr)
        index = self.frames
        self.frames += 1
        # Sample at the target cadence without duplicating frames after a slow loop.
        self.next_time = (math.floor(elapsed * self.fps) + 1) / self.fps
        if len(self.samples) < 8 and elapsed >= len(self.samples) * 15:
            tile = cv2.resize(bgr, (320, 180))
            cv2.putText(tile, f't={elapsed:.1f}s', (5, 172), cv2.FONT_HERSHEY_SIMPLEX, .4, (0,255,255), 1)
            self.samples.append(tile)
        return index

    def close(self):
        if self.closed:
            return
        self.closed = True
        self.writer.release()  # AVI index must be written before download/playback
        if self.samples:
            tiles = self.samples + [np.zeros((180,320,3), np.uint8)] * (8-len(self.samples))
            sheet = np.vstack((np.hstack(tiles[:4]), np.hstack(tiles[4:])))
            if not cv2.imwrite(str(self.directory / 'video_contact_sheet.jpg'), sheet):
                raise OSError('cannot write video contact sheet')
        info = dict(file=self.path.name, recorded_frames=self.frames, playback_fps=self.fps,
                    size_limited=self.limited, closed_cleanly=True,
                    timing='sampled fixed-fps AVI; frames.csv maps video_frame to elapsed_s; slow processing shortens playback')
        (self.directory / 'recording.json').write_text(json.dumps(info, indent=2), encoding='utf-8')
        print(f'PROJECT1_VIDEO_SAVED={self.path} frames={self.frames}', flush=True)


class BytesPreview:
    """HTTP workers see immutable JPEG bytes only, never arrays or DMA buffers."""
    RESULT_DEMAND_SECONDS = 1.0

    def __init__(self, bind, port):
        self.lock, self.stop = Lock(), Event()
        self.changed=Condition(self.lock)
        self.jpeg, self.generation = b'', 0
        self.result_json = b'{}'
        self.result_at = None
        self.debug_jpeg = b''
        self.debug_generation = 0
        self.debug_requested_at = float('-inf')
        self.result_requested_at = float('-inf')
        self.video_clients = 0
        self.allow_preview = None
        self.diagnostics_enabled = True
        self.preview_health = {'status': 'STARTING'}
        self.dashboard = (RUNTIME_DIR / 'dashboard.html').read_bytes()
        owner = self

        class Handler(BaseHTTPRequestHandler):
            def do_GET(self):
                path=urlsplit(self.path)
                if path.path in ('/', '/debug.jpg'):
                    after=None
                    if path.path=='/debug.jpg':
                        try:after=int(parse_qs(path.query).get('after',[None])[0])
                        except (TypeError,ValueError):pass
                        with owner.lock:owner.debug_requested_at=time.monotonic()
                        if after is not None:
                            # Counters may reset after a board worker restart.
                            with owner.changed:
                                owner.changed.wait_for(lambda:owner.stop.is_set() or
                                    bool(owner.debug_jpeg) and owner.debug_generation!=after,timeout=.5)
                    with owner.lock:
                        if path.path == '/debug.jpg':
                            owner.debug_requested_at = time.monotonic()
                        payload = owner.dashboard if path.path == '/' else owner.debug_jpeg
                        generation=owner.debug_generation
                        if path.path == '/debug.jpg' and (not owner.diagnostics_enabled
                                or owner.allow_preview is not None and not owner.allow_preview()):
                            payload = b''
                    if after is not None and payload and generation==after:
                        self.send_response(204);self.send_header('Content-Length','0');self.end_headers();return
                    self.send_response(200 if payload else 503)
                    self.send_header('Content-Type', 'text/html; charset=utf-8' if path.path == '/' else 'image/jpeg')
                    if path.path=='/debug.jpg':self.send_header('X-Preview-Generation',str(generation))
                    self.send_header('Cache-Control', 'no-store')
                    self.send_header('Content-Length', str(len(payload)))
                    self.end_headers()
                    try:
                        self.wfile.write(payload)
                    except OSError:
                        pass
                    return
                if self.path == '/result.json':
                    with owner.lock:
                        now = time.monotonic()
                        if now - owner.result_requested_at >= owner.RESULT_DEMAND_SECONDS:
                            owner.result_json = b'{}'
                            owner.result_at = None
                        owner.result_requested_at = now
                        payload = owner.result_json
                        published_at = owner.result_at
                        preview_health = dict(owner.preview_health)
                    sample = json.loads(payload)
                    sample['preview_health'] = preview_health
                    sample['server_age_ms'] = ((sample.get('server_age_ms') or 0.) + (time.monotonic()-published_at)*1000
                                               if published_at is not None else None)
                    payload = json.dumps(sample).encode('utf-8')
                    self.send_response(200)
                    self.send_header('Content-Type', 'application/json')
                    self.send_header('Cache-Control', 'no-store')
                    self.send_header('Content-Length', str(len(payload)))
                    self.end_headers()
                    try:
                        self.wfile.write(payload)
                    except OSError:
                        pass
                    return
                if self.path != '/camera.mjpg':
                    self.send_error(404)
                    return
                self.connection.settimeout(2)
                with owner.lock:
                    enabled = owner.diagnostics_enabled
                    if enabled:
                        owner.video_clients += 1
                if not enabled:
                    self.send_error(503, 'Preview diagnostics unavailable')
                    return
                self.send_response(200)
                self.send_header('Content-Type', 'multipart/x-mixed-replace; boundary=frame')
                self.send_header('Cache-Control', 'no-store')
                self.end_headers()
                last = -1
                try:
                    while not owner.stop.is_set():
                        if select.select([self.connection], [], [], 0)[0]:
                            if not self.connection.recv(1, socket.MSG_PEEK):
                                break
                        with owner.changed:
                            owner.changed.wait_for(lambda:owner.stop.is_set() or
                                not owner.diagnostics_enabled or
                                bool(owner.jpeg) and owner.generation!=last,timeout=.5)
                            jpeg, generation = owner.jpeg, owner.generation
                            enabled = owner.diagnostics_enabled
                        if owner.stop.is_set():break
                        if not enabled:
                            break
                        if owner.allow_preview is not None and not owner.allow_preview():
                            owner.stop.wait(.05)
                            continue
                        if not jpeg or generation == last:
                            continue
                        self.wfile.write(b'--frame\r\nContent-Type: image/jpeg\r\nContent-Length: ' +
                                         str(len(jpeg)).encode('ascii') + b'\r\n\r\n' + jpeg + b'\r\n')
                        last = generation
                except OSError:
                    pass  # client closed; acquisition remains independent
                finally:
                    with owner.lock:
                        owner.video_clients -= 1

            def log_message(self, fmt, *args):
                pass

        self.server = ThreadingHTTPServer((bind, port), Handler)
        self.server.daemon_threads = True  # these threads hold bytes, no hardware
        self.thread = Thread(target=self.server.serve_forever, name='jpeg-bytes-server')
        self.thread.start()

    def publish(self, jpeg):
        if not isinstance(jpeg, bytes):
            raise TypeError('preview accepts immutable JPEG bytes only')
        with self.lock:
            if self.diagnostics_enabled:
                self.jpeg, self.generation = jpeg, self.generation + 1
                self.changed.notify_all()

    def update_health(self, health):
        with self.lock:
            self.preview_health = dict(health)
            self.diagnostics_enabled=health['status']=='RUNNING'
            if health['status'] != 'RUNNING':
                self.jpeg, self.debug_jpeg = b'', b''
            self.changed.notify_all()

    def demand(self):
        modes = self.requested_modes()
        if modes and self.allow_preview is not None and not self.allow_preview():
            return frozenset()
        return modes

    def requested_modes(self, *, blocking=False):
        if not self.lock.acquire(blocking=blocking):
            return frozenset()
        try:
            if not self.diagnostics_enabled:
                return frozenset()
            modes = set()
            if self.video_clients:
                modes.add('video')
            if not self.video_clients and time.monotonic() - self.debug_requested_at < 3.:
                modes.add('debug')
            return frozenset(modes)
        finally:
            self.lock.release()

    def wants_result(self):
        if not self.lock.acquire(blocking=False):
            return False
        try:
            return (self.diagnostics_enabled and
                    time.monotonic() - self.result_requested_at < self.RESULT_DEMAND_SECONDS)
        finally:
            self.lock.release()

    def close(self):
        self.stop.set()
        with self.changed:self.changed.notify_all()
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(timeout=3)

    def publish_result(self, payload):
        if not isinstance(payload,bytes):
            raise TypeError('result endpoint accepts immutable JSON bytes only')
        with self.lock:
            self.result_json = payload
            self.result_at = time.monotonic()

    def publish_debug(self, payload):
        if not isinstance(payload, bytes):
            raise TypeError('debug endpoint accepts immutable bytes only')
        with self.lock:
            if self.diagnostics_enabled:
                self.debug_jpeg = payload
                self.debug_generation += 1
                self.changed.notify_all()


def original_code(fingers, area, ratio):
    """Original notebook decision thresholds, including its non-RPS gestures."""
    if fingers == 1:
        if area < 2000:
            return 'NO_HAND'
        return '0' if ratio < 12 else ('6' if ratio < 17.5 else '1')
    if fingers == 3:
        return '3' if ratio < 27 else '7'
    return str(fingers) if fingers in (2, 4, 5) else 'REPOSITION'


def selected_pixel_stats(skin_mask, contour, roi):
    """Moments of observed skin pixels inside ONLY the selected contour.

    Morphology-expanded background pixels and holes in the skin mask are excluded.
    This measures segmented-hand area center, not anatomical palm center.
    """
    x, y, w, h = cv2.boundingRect(contour)
    selected = np.zeros((h, w), np.uint8)
    cv2.drawContours(selected, [contour - np.array([[[x,y]]], np.int32)], -1, 255, -1)
    selected = cv2.bitwise_and(selected, skin_mask[y:y+h, x:x+w])
    moments = cv2.moments(selected, binaryImage=True)
    area = int(moments['m00'])
    ox, oy = x+roi[0], y+roi[1]
    sx = int(round(moments['m10'])) + ox*area
    sy = int(round(moments['m01'])) + oy*area
    return dict(area=area, sum_x=sx, sum_y=sy,
                centroid=(sx/area, sy/area) if area else None)


class OriginalContour:
    def __init__(self, confirm=5, lower=(0, 20, 70), upper=(20, 255, 255),
                 dilate_iterations=4, defect_depth=30., roi=ROI):
        if confirm < 1:
            raise ValueError('confirm must be positive')
        if not 0 <= dilate_iterations <= 8 or not 1 <= defect_depth <= 100:
            raise ValueError('invalid dilation or defect depth')
        self.dilate_iterations, self.defect_depth = dilate_iterations, float(defect_depth)
        self.confirm = confirm
        if len(roi) != 4 or not (0 <= roi[0] < roi[2] <= 640 and 0 <= roi[1] < roi[3] <= 360):
            raise ValueError('invalid ROI')
        self.roi = tuple(roi)
        self.retrieval_mode = cv2.RETR_TREE
        self.lower = np.array(lower, np.uint8)
        self.upper = np.array(upper, np.uint8)
        self.pending, self.count = '', 0

    def select_contour(self, contours):
        return max(contours, key=cv2.contourArea) if contours else None

    def depth_threshold(self, contour):
        return self.defect_depth

    def classify_shape(self, fingers, area, ratio):
        return original_code(fingers, area, ratio)

    def pixel_statistics(self, hsv, skin_mask, contour):
        if getattr(self, 'moments_backend', None) is None:
            return selected_pixel_stats(skin_mask, contour, self.roi)
        gate = np.zeros(skin_mask.shape, np.uint8)
        cv2.drawContours(gate, [contour], -1, 255, -1)
        bounds = tuple(int(v) for v in (self.lower[0], self.upper[0], self.lower[1],
                                       self.upper[1], self.lower[2], self.upper[2]))
        mask, stats = self.moments_backend.run(hsv, gate, self.result_frame_id, bounds)
        # Same-frame reference comparison is mandatory in this validation version.
        if not np.array_equal(mask, cv2.bitwise_and(gate, skin_mask)):
            raise RuntimeError('PL same-frame mask mismatch')
        area = stats['area']
        stats['sum_x'] += self.roi[0]*area
        stats['sum_y'] += self.roi[1]*area
        stats['centroid'] = (stats['sum_x']/area, stats['sum_y']/area) if area else None
        gold = selected_pixel_stats(skin_mask, contour, self.roi)
        if any(stats[key] != gold[key] for key in ('area', 'sum_x', 'sum_y')):
            raise RuntimeError('PL same-frame moments mismatch')
        stats['same_frame_exact'] = True
        return stats

    def infer(self, bgr):
        if bgr.shape != (360, 640, 3) or bgr.dtype != np.uint8:
            raise ValueError('expected uint8 640x360 BGR')
        x0, y0, x1, y1 = self.roi
        t0 = time.perf_counter()
        skin_meta = None
        if getattr(self, 'skin_backend', None) is not None:
            bounds = tuple(int(v) for pair in zip(self.lower, self.upper) for v in pair)
            skin_mask, skin_meta = self.skin_backend.run(bgr[y0:y1, x0:x1], self.result_frame_id, bounds)
            hsv = None
            skin_meta['same_frame_exact'] = None
            if getattr(self, 'skin_validate', True):
                hsv = cv2.cvtColor(bgr[y0:y1, x0:x1], cv2.COLOR_BGR2HSV)
                gold = cv2.inRange(hsv, self.lower, self.upper)
                if not np.array_equal(skin_mask, gold):
                    raise RuntimeError('PL skin same-frame mask mismatch')
                skin_meta['same_frame_exact'] = True
        else:
            hsv = cv2.cvtColor(bgr[y0:y1, x0:x1], cv2.COLOR_BGR2HSV)
            skin_mask = cv2.inRange(hsv, self.lower, self.upper)
        mask = skin_mask
        t1 = time.perf_counter()
        mask = cv2.dilate(mask, np.ones((3, 3), np.uint8), iterations=self.dilate_iterations)
        mask = cv2.GaussianBlur(mask, (5, 5), 100)
        t2 = time.perf_counter()
        contours = cv2.findContours(mask, self.retrieval_mode, cv2.CHAIN_APPROX_SIMPLE)[-2]
        result = dict(code='NO_HAND', bbox=None, fingers=0, area=0., ratio=0.,
                      mask=mask, contour=None, hull=None, error='', touches_roi=False,
                      dilate_iterations=self.dilate_iterations, defect_depth=self.defect_depth,
                      roi=self.roi, tracking=False, centroid=None, pixel_stats=None)
        cnt = self.select_contour(contours)
        debug = getattr(self, 'debug_enabled', False)
        if debug:
            result['debug_images'] = dict(input=bgr.copy(), skin=skin_mask, contours=contours, defects=[])
        t3 = time.perf_counter()
        if cnt is not None:
            area = float(cv2.contourArea(cnt))
            if area > 0:
                hull = cv2.convexHull(cnt)
                ratio = (float(cv2.contourArea(hull)) - area) / area * 100
                approx = cv2.approxPolyDP(cnt, .0005 * cv2.arcLength(cnt, True), True)
                indices = cv2.convexHull(approx, returnPoints=False)
                defects = None
                if len(approx) >= 4 and indices is not None and len(indices) >= 3:
                    try:
                        defects = cv2.convexityDefects(approx, indices)
                    except cv2.error as exc:
                        result['error'] = str(exc)
                count = 0
                depth_threshold = self.depth_threshold(cnt)
                if defects is not None:
                    points = approx[:, 0, :].astype(float)
                    for s, e, f, _ in defects.reshape(-1, 4):
                        start, end, far = points[s], points[e], points[f]
                        a = float(np.linalg.norm(end - start))
                        b = float(np.linalg.norm(far - start))
                        c = float(np.linalg.norm(end - far))
                        if min(a, b, c) <= 1e-9:
                            continue
                        cosine = float(np.clip((b*b + c*c - a*a)/(2*b*c), -1, 1))
                        angle = math.acos(cosine) * 57  # original notebook constant
                        u, v = end - start, far - start
                        depth = abs(u[0]*v[1] - u[1]*v[0]) / a
                        if angle <= 90 and depth > depth_threshold:
                            count += 1
                            if debug:
                                result['debug_images']['defects'].append((start.tolist(),end.tolist(),far.tolist()))
                fingers = count + 1
                bx, by, bw, bh = cv2.boundingRect(cnt)
                code = self.classify_shape(fingers, area, ratio)
                if result['error']:
                    code = 'REPOSITION'  # do not convert invalid defects to a fist
                stats = self.pixel_statistics(hsv, skin_mask, cnt)
                result.update(code=code, fingers=fingers, area=area, ratio=ratio,
                              centroid=stats['centroid'], pixel_stats=stats,
                              effective_defect_depth=depth_threshold,
                              touches_roi=(bx <= 1 or by <= 1 or bx+bw >= x1-x0-1 or by+bh >= y1-y0-1),
                              bbox=(x0+bx, y0+by, x0+bx+bw, y0+by+bh),
                              contour=cnt, hull=hull)
        code = result['code']
        if code in ('NO_HAND', 'REPOSITION'):
            self.pending, self.count = '', 0
            stable = code
        else:
            self.count = min(self.confirm, self.count+1) if code == self.pending else 1
            self.pending = code
            stable = code if self.count >= self.confirm else 'PENDING'
        result['pl_skin'] = skin_meta
        result['stable'] = stable
        result['rps'] = {'0': 'ROCK', '2': 'SCISSORS', '5': 'PAPER'}.get(stable, 'UNKNOWN')
        t4 = time.perf_counter()
        result['timing_ms'] = dict(color_mask=(t1-t0)*1000, morphology=(t2-t1)*1000,
                                  contours_select=(t3-t2)*1000, shape_stats=(t4-t3)*1000)
        return result


class FullFrameTracker(OriginalContour):
    """PS-only extension of project 1; blob continuity inspired by project 2.

    No copied RTL, neural model, prediction-only boxes or PC inference.
    Boxes are the currently observed contours, not stale tracked positions.
    """
    def __init__(self, lower=(0,20,70), upper=(20,255,255), dilate_iterations=3,
                 defect_depth=30., min_area=2000.):
        if min_area <= 0:
            raise ValueError('minimum candidate area must be positive')
        super().__init__(1, lower, upper, dilate_iterations, defect_depth, (0,0,640,360))
        self.min_area = float(min_area)
        self.retrieval_mode = cv2.RETR_EXTERNAL
        self.previous = None
        self.votes = deque(maxlen=5)
        self.candidate_count = 0

    @staticmethod
    def overlap(a, b):
        ix = max(0,min(a[2],b[2])-max(a[0],b[0]))
        iy = max(0,min(a[3],b[3])-max(a[1],b[1]))
        intersection = ix*iy
        union = (a[2]-a[0])*(a[3]-a[1])+(b[2]-b[0])*(b[3]-b[1])-intersection
        return intersection/max(union,1)

    def select_contour(self, contours):
        candidates = sorted((c for c in contours if cv2.contourArea(c) >= self.min_area),
                            key=cv2.contourArea, reverse=True)[:8]
        self.candidate_count = len(candidates)
        if not candidates:
            return None
        largest = cv2.contourArea(candidates[0])
        def score(contour):
            x,y,w,h = cv2.boundingRect(contour)
            box = (x,y,x+w,y+h)
            value = cv2.contourArea(contour)/max(largest,1)
            if self.previous:
                pcx,pcy = (self.previous[0]+self.previous[2])/2,(self.previous[1]+self.previous[3])/2
                distance = math.hypot(x+w/2-pcx,y+h/2-pcy)/math.hypot(640,360)
                value += 2*self.overlap(box,self.previous)+max(0.,1-3*distance)
            return value
        return max(candidates,key=score)

    def depth_threshold(self, contour):
        _, _, w, h = cv2.boundingRect(contour)
        # Keep the configured 300-pixel reference; normalize for hand scale.
        return self.defect_depth * max(.5, min(1.5, max(w,h)/300.))

    def classify_shape(self, fingers, area, ratio):
        # Three-class heuristic, NOT a guarantee or a calibrated probability.
        # Finger count remains a feature; PAPER need not have exactly five.
        if area < self.min_area:
            return 'NO_HAND'
        if fingers == 1 and ratio < 15:
            return '0'
        if fingers == 2 and ratio >= 15:
            return '2'
        if 3 <= fingers <= 5 and 18 <= ratio <= 55:
            return '5'
        return 'REPOSITION'

    def infer(self, bgr):
        result = super().infer(bgr)
        box = result['bbox']
        new_target = box is not None and self.previous is not None and (
            self.overlap(box,self.previous) == 0 and
            math.hypot((box[0]+box[2]-self.previous[0]-self.previous[2])/2,
                       (box[1]+box[3]-self.previous[1]-self.previous[3])/2) > 140)
        if new_target:
            self.votes.clear()
        self.previous = box
        code = result['code']
        if box is None or code == 'NO_HAND':
            self.votes.clear()
            stable = 'NO_HAND'
        else:
            self.votes.append(code)
            # Latest observation must agree: never display stale ROCK on a new PAPER.
            stable = code if code in ('0','2','5') and self.votes.count(code) >= 3 else 'PENDING'
        result.update(stable=stable, tracking=True, candidates=self.candidate_count,
                      rps={'0':'ROCK','2':'SCISSORS','5':'PAPER'}.get(stable,'UNKNOWN'),
                      hand_state={'0':'FIST','2':'TWO_FINGERS','5':'OPEN'}.get(stable,'UNKNOWN'))
        return result


class _DualMaskContour(OriginalContour):
    def infer(self, preprocessed_masks):
        if (self.roi != (0, 0, 640, 360) or self.dilate_iterations != 4 or
                getattr(self, 'skin_backend', None) is not None or
                getattr(self, 'moments_backend', None) is not None or
                getattr(self, 'debug_enabled', False)):
            raise ValueError('dual masks require the full-frame dilation4 CPU-contour profile')
        if type(preprocessed_masks) is not tuple or len(preprocessed_masks) != 2:
            raise ValueError('raw and filtered mask pair required')
        skin_mask, mask = preprocessed_masks
        if any(not isinstance(value, np.ndarray) or value.shape != (360, 640) or
               value.dtype != np.uint8 for value in preprocessed_masks):
            raise ValueError('expected uint8 640x360 raw and filtered masks')
        if np.any((skin_mask != 0) & (skin_mask != 255)):
            raise ValueError('raw mask must be binary')
        x0, y0, x1, y1 = self.roi
        bgr, hsv = None, None
        skin_meta = dict(backend='DMS1_DUAL_MASK', same_frame_exact=None)
        t0 = t1 = time.perf_counter()
        t2 = time.perf_counter()
        contours = cv2.findContours(mask, self.retrieval_mode, cv2.CHAIN_APPROX_SIMPLE)[-2]
        result = dict(code='NO_HAND', bbox=None, fingers=0, area=0., ratio=0.,
                      mask=mask, contour=None, hull=None, error='', touches_roi=False,
                      dilate_iterations=self.dilate_iterations, defect_depth=self.defect_depth,
                      roi=self.roi, tracking=False, centroid=None, pixel_stats=None)
        cnt = self.select_contour(contours)
        debug = getattr(self, 'debug_enabled', False)
        if debug:
            result['debug_images'] = dict(input=bgr.copy(), skin=skin_mask, contours=contours, defects=[])
        t3 = time.perf_counter()
        if cnt is not None:
            area = float(cv2.contourArea(cnt))
            if area > 0:
                hull = cv2.convexHull(cnt)
                ratio = (float(cv2.contourArea(hull)) - area) / area * 100
                approx = cv2.approxPolyDP(cnt, .0005 * cv2.arcLength(cnt, True), True)
                indices = cv2.convexHull(approx, returnPoints=False)
                defects = None
                if len(approx) >= 4 and indices is not None and len(indices) >= 3:
                    try:
                        defects = cv2.convexityDefects(approx, indices)
                    except cv2.error as exc:
                        result['error'] = str(exc)
                count = 0
                depth_threshold = self.depth_threshold(cnt)
                if defects is not None:
                    points = approx[:, 0, :].astype(float)
                    for s, e, f, _ in defects.reshape(-1, 4):
                        start, end, far = points[s], points[e], points[f]
                        a = float(np.linalg.norm(end - start))
                        b = float(np.linalg.norm(far - start))
                        c = float(np.linalg.norm(end - far))
                        if min(a, b, c) <= 1e-9:
                            continue
                        cosine = float(np.clip((b*b + c*c - a*a)/(2*b*c), -1, 1))
                        angle = math.acos(cosine) * 57
                        u, v = end - start, far - start
                        depth = abs(u[0]*v[1] - u[1]*v[0]) / a
                        if angle <= 90 and depth > depth_threshold:
                            count += 1
                            if debug:
                                result['debug_images']['defects'].append((start.tolist(),end.tolist(),far.tolist()))
                fingers = count + 1
                bx, by, bw, bh = cv2.boundingRect(cnt)
                code = self.classify_shape(fingers, area, ratio)
                if result['error']:
                    code = 'REPOSITION'
                stats = self.pixel_statistics(hsv, skin_mask, cnt)
                result.update(code=code, fingers=fingers, area=area, ratio=ratio,
                              centroid=stats['centroid'], pixel_stats=stats,
                              effective_defect_depth=depth_threshold,
                              touches_roi=(bx <= 1 or by <= 1 or bx+bw >= x1-x0-1 or by+bh >= y1-y0-1),
                              bbox=(x0+bx, y0+by, x0+bx+bw, y0+by+bh),
                              contour=cnt, hull=hull)
        code = result['code']
        if code in ('NO_HAND', 'REPOSITION'):
            self.pending, self.count = '', 0
            stable = code
        else:
            self.count = min(self.confirm, self.count+1) if code == self.pending else 1
            self.pending = code
            stable = code if self.count >= self.confirm else 'PENDING'
        result['pl_skin'] = skin_meta
        result['stable'] = stable
        result['rps'] = {'0': 'ROCK', '2': 'SCISSORS', '5': 'PAPER'}.get(stable, 'UNKNOWN')
        t4 = time.perf_counter()
        result['timing_ms'] = dict(color_mask=(t1-t0)*1000, morphology=(t2-t1)*1000,
                                  contours_select=(t3-t2)*1000, shape_stats=(t4-t3)*1000)
        return result


class DualMaskFullFrameTracker(FullFrameTracker, _DualMaskContour):
    pass


def process_dual_masks(masks, recognizer, rotate=180, mirror=False, *, on_result=None):
    if (type(masks) is not tuple or len(masks) != 2
            or any(not isinstance(mask, np.ndarray) or mask.shape != (360, 640)
                   or mask.dtype != np.uint8 for mask in masks)):
        raise ValueError('expected full-frame uint8 raw and filtered mask pair')
    if type(rotate) is not int or rotate not in (0, 180) or type(mirror) is not bool:
        raise ValueError('dual-mask orientation requires rotation0/180 and bool mirror')
    started = time.perf_counter()
    prepared = tuple(cv2.rotate(mask, cv2.ROTATE_180) if rotate == 180 else mask for mask in masks)
    if mirror:
        prepared = tuple(cv2.flip(mask, 1) for mask in prepared)
    prepared_at = time.perf_counter()
    result = recognizer.infer(prepared)
    result['timing_ms']['input_prepare'] = (prepared_at-started)*1000
    result['timing_ms']['overlay_resize'] = 0.
    if on_result is not None:
        on_result(result)
    return result


def process_dual_capture(frame, recognizer, rotate=180, mirror=False, capture_order='rgb',
                         output_size=(640, 360), on_result=None, annotate=False, preview_rgb=False,
                         defer_preview=False):
    if annotate or capture_order not in ('rgb', 'bgr') or output_size != (640, 360):
        raise ValueError('dual-mask acceptance requires the gated mask-only processor')
    debug = bool(getattr(recognizer, 'debug_enabled', False))
    if (debug or preview_rgb) and (type(getattr(frame, 'rgb', None)) is not bytes or len(frame.rgb) != 1280*720*3):
        raise ValueError('dual-mask preview requires the same-token RGB snapshot')
    recognizer.debug_enabled = False
    try:
        result = process_dual_masks((frame.raw, frame.filtered), recognizer, rotate, mirror, on_result=on_result)
    finally:
        recognizer.debug_enabled = debug
    if defer_preview and (debug or preview_rgb):
        # Only immutable owned capture bytes cross to the existing codec. RGB
        # conversion and debug drawing must not delay the next recognition.
        result['_preview_capture'] = dict(rgb=frame.rgb, raw=frame.raw if debug else None,
            rotate=rotate, mirror=mirror, capture_order=capture_order, debug=debug,
            preview_rgb=preview_rgb, retrieval_mode=recognizer.retrieval_mode)
        return None, result
    return prepare_dual_preview(frame, result, rotate=rotate, mirror=mirror,
        capture_order=capture_order, debug=debug, preview_rgb=preview_rgb,
        retrieval_mode=recognizer.retrieval_mode)


def prepare_dual_preview(frame, result, *, rotate, mirror, capture_order,
                         debug, preview_rgb, retrieval_mode):
    processed = None
    if debug or preview_rgb:
        started = time.perf_counter()
        image = np.frombuffer(frame.rgb, dtype=np.uint8).reshape(720, 1280, 3)
        view = cv2.resize(image, (640, 360), interpolation=cv2.INTER_AREA)
        if rotate == 180:
            view = cv2.rotate(view, cv2.ROTATE_180)
        if mirror:
            view = cv2.flip(view, 1)
        bgr = view if capture_order == 'bgr' else cv2.cvtColor(view, cv2.COLOR_RGB2BGR)
        if preview_rgb:
            processed = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
        if debug:
            raw = cv2.rotate(frame.raw, cv2.ROTATE_180) if rotate == 180 else frame.raw
            if mirror:
                raw = cv2.flip(raw, 1)
            contours = cv2.findContours(result['mask'], retrieval_mode, cv2.CHAIN_APPROX_SIMPLE)[-2]
            result['debug_images'] = dict(input=bgr, skin=raw, contours=contours, defects=[])
            selected = result['contour']
            if selected is not None and result['area'] > 0:
                approx = cv2.approxPolyDP(selected, .0005 * cv2.arcLength(selected, True), True)
                indices = cv2.convexHull(approx, returnPoints=False)
                defects = None
                if len(approx) >= 4 and indices is not None and len(indices) >= 3:
                    try:
                        defects = cv2.convexityDefects(approx, indices)
                    except cv2.error:
                        pass
                if defects is not None:
                    points = approx[:, 0, :].astype(float)
                    for start_index, end_index, far_index, _ in defects.reshape(-1, 4):
                        start_point, end_point, far_point = points[start_index], points[end_index], points[far_index]
                        edge = float(np.linalg.norm(end_point-start_point))
                        first = float(np.linalg.norm(far_point-start_point))
                        second = float(np.linalg.norm(end_point-far_point))
                        if min(edge, first, second) <= 1e-9:
                            continue
                        cosine = float(np.clip((first*first+second*second-edge*edge)/(2*first*second), -1, 1))
                        end_vector, far_vector = end_point-start_point, far_point-start_point
                        depth = abs(end_vector[0]*far_vector[1]-end_vector[1]*far_vector[0])/edge
                        if math.acos(cosine)*57 <= 90 and depth > result['effective_defect_depth']:
                            result['debug_images']['defects'].append(
                                (start_point.tolist(), end_point.tolist(), far_point.tolist()))
        result['timing_ms']['diagnostic_rgb_prepare'] = (time.perf_counter()-started)*1000
    return processed, result


class SharedDualMaskWorker(SharedVisionWorker):
    def __init__(self, hardware, recognizer, controller, input_provider, **options):
        super().__init__(hardware, recognizer, controller, input_provider,
                         frame_processor=partial(process_dual_capture, defer_preview=True), **options)
        hardware.drain_consumer = self._process_frame
        hardware.preview_demand = self._preview_needs_rgb

    def _preview_needs_rgb(self):
        if self.preview_encoder is None:
            return False
        try:
            return bool(self.preview_encoder.due_modes() & {'video', 'debug'})
        except Exception as error:
            self.diagnostic_error = f'{type(error).__name__}: {error}'
            return False


def process_rgb(rgb, recognizer, rotate=180, mirror=False, capture_order='rgb',
                output_size=(1280,720), on_result=None, annotate=True, preview_rgb=True):
    if rgb.shape != (720, 1280, 3) or rgb.dtype != np.uint8:
        raise ValueError('expected validated 1280x720 RGB capture')
    if capture_order not in ('rgb', 'bgr'):
        raise ValueError('capture order must be rgb or bgr')
    prep_started = time.perf_counter()
    view = cv2.resize(rgb, (640, 360), interpolation=cv2.INTER_AREA)
    if rotate == 180:
        view = cv2.rotate(view, cv2.ROTATE_180)
    if mirror:
        view = cv2.flip(view, 1)
    bgr = view if capture_order == 'bgr' else cv2.cvtColor(view, cv2.COLOR_RGB2BGR)
    prep_done = time.perf_counter()
    result = recognizer.infer(bgr)
    result['timing_ms']['input_prepare'] = (prep_done-prep_started)*1000
    if on_result is not None:
        # Publish control before PS annotations, display write and JPEG work.
        on_result(result)
    if not annotate:
        result['timing_ms']['overlay_resize'] = 0.
        if not preview_rgb:
            return None, result
        return view if capture_order == 'rgb' else cv2.cvtColor(view, cv2.COLOR_BGR2RGB), result
    return draw_preview(bgr, result, output_size), result


def draw_preview(bgr, result, output_size=(640,360)):
    draw_started = time.perf_counter()
    canvas = bgr.copy()
    x0, y0, x1, y1 = result['roi']
    if not result['tracking']:
        cv2.rectangle(canvas, (x0, y0), (x1-1, y1-1), (255, 255, 0), 1)
    if result['bbox'] is not None:
        offset = np.array([[[x0, y0]]], np.int32)
        cv2.drawContours(canvas, [result['contour'] + offset], -1, (0, 255, 255), 1)
        cv2.drawContours(canvas, [result['hull'] + offset], -1, (255, 0, 255), 1)
        bx0, by0, bx1, by1 = result['bbox']
        color = (0, 0, 255) if result['stable'] == '0' else (0, 255, 0)
        if result['stable'] in ('NO_HAND', 'REPOSITION', 'PENDING'):
            color = (0, 180, 255)
        cv2.rectangle(canvas, (bx0, by0), (bx1-1, by1-1), color, 2)
        if result['centroid'] is not None:
            cx,cy = result['centroid']
            cv2.drawMarker(canvas, (int(round(cx)),int(round(cy))), (255,255,255),
                           cv2.MARKER_CROSS, 16, 2)
            cv2.putText(canvas, f'C=({cx:.1f},{cy:.1f})', (bx0,max(58,by0-5)),
                        cv2.FONT_HERSHEY_SIMPLEX, .42, (255,255,255), 1)
    if not result['tracking']:
        canvas[45:195, 480:630] = cv2.cvtColor(cv2.resize(result['mask'], (150, 150)), cv2.COLOR_GRAY2BGR)
    cv2.rectangle(canvas, (0, 0), (639, 27), (0, 0, 0), -1)
    text = f"raw={result['code']} stable={result['stable']} RPS?={result['rps']}"
    cv2.putText(canvas, text, (5, 20), cv2.FONT_HERSHEY_SIMPLEX, .48, (255,255,255), 1)
    if result['tracking']:
        cv2.putText(canvas, f"PS TRACKING: {result['hand_state']}", (5, 42),
                    cv2.FONT_HERSHEY_SIMPLEX, .44, (255,255,255), 1)
    cv2.putText(canvas, f"fingers={result['fingers']} area={result['area']:.0f} gap={result['ratio']:.1f}%",
                (5, 351), cv2.FONT_HERSHEY_SIMPLEX, .44, (255,255,255), 1)
    if result['touches_roi']:
        cv2.putText(canvas, 'FRAME EDGE' if result['tracking'] else 'ROI EDGE: contour may be clipped', (5, 335),
                    cv2.FONT_HERSHEY_SIMPLEX, .44, (0,180,255), 1)
    output_bgr = canvas if output_size == (640,360) else cv2.resize(canvas, output_size)
    output = cv2.cvtColor(output_bgr, cv2.COLOR_BGR2RGB)
    result['timing_ms']['overlay_resize'] = (time.perf_counter()-draw_started)*1000
    return output


def encode_preview_snapshot(snapshot, mode, snapshot_dir=None):
    deferred = snapshot.result.pop('_preview_capture', None)
    if deferred is not None:
        frame = SimpleNamespace(rgb=deferred.pop('rgb'), raw=deferred.pop('raw'))
        rgb, _ = prepare_dual_preview(frame, snapshot.result, **deferred)
        snapshot.result['_preview_rgb'] = rgb
    if mode == 'debug':
        from pynq_multimodal_game.vision_preview_render import six_panel
        image = six_panel(snapshot.result, snapshot.control, snapshot.frame)
    else:
        rgb = snapshot.result.get('_preview_rgb', snapshot.rgb)
        if rgb.shape[:2] != (360,640):
            rgb = cv2.resize(rgb, (640,360))
        bgr = cv2.cvtColor(rgb, cv2.COLOR_RGB2BGR)
        if snapshot.result.get('preview_needs_annotation', False):
            from pynq_multimodal_game.vision_preview_render import camera_geometry
            image = camera_geometry(bgr, snapshot.result)
        else:
            image = bgr
    ok, encoded = cv2.imencode('.jpg', image, [cv2.IMWRITE_JPEG_QUALITY,75])
    if not ok:
        raise OSError('background JPEG encoding failed')
    payload = encoded.tobytes()
    if snapshot_dir is not None:
        path = Path(snapshot_dir) / ('latest_debug.jpg' if mode == 'debug' else 'latest_overlay.jpg')
        if path.write_bytes(payload) != len(payload):
            raise OSError('incomplete background snapshot write')
    return payload


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--camera-dir', type=Path, default=CAMERA_DIR)
    parser.add_argument('--rotate', type=int, choices=(0, 180), default=180)
    parser.add_argument('--mirror', action='store_true')
    parser.add_argument('--capture-order', choices=('rgb', 'bgr'), default='rgb',
                        help='camera memory order; use bgr for the current calibration hardware')
    parser.add_argument('--confirm', type=int, default=5)
    parser.add_argument('--tracking', action='store_true', help='full-frame moving-hand PS tracking; 3-of-5 vote')
    parser.add_argument('--pl-osd', action='store_true', help='clean HDMI pixels; PL draws PS bbox/centroid, requires hand_osd IP')
    parser.add_argument('--host-only', action='store_true', help='browser preview/control only; do not start or write HDMI MM2S')
    parser.add_argument('--pl-moments', action='store_true', help='dedicated DMA same-frame mask/moments, mandatory exact PS comparison; experimental')
    parser.add_argument('--pl-skin', action='store_true', help='v6 PL BGR/HSV/skin frontend; supports HDMI or --host-only')
    parser.add_argument('--pl-skin-mode', choices=('validate','performance'), default='validate')
    parser.add_argument('--debug-view', action='store_true', help='enable subscribed background six-panel encoding')
    parser.add_argument('--preview-fps', type=float, default=10.)
    parser.add_argument('--debug-fps', type=float, default=5.)
    parser.add_argument('--save-preview-snapshots', action='store_true')
    parser.add_argument('--trace-frames', action='store_true')
    parser.add_argument('--track-min-area', type=float, default=2000.)
    parser.add_argument('--dilate-iterations', type=int, choices=range(9), default=4)
    parser.add_argument('--defect-depth', type=float, default=30.)
    parser.add_argument('--hue-max', type=int, default=20)
    parser.add_argument('--sat-min', type=int, default=20)
    parser.add_argument('--value-min', type=int, default=70)
    parser.add_argument('--no-record', action='store_true')
    parser.add_argument('--calibration', action='store_true', help='guided 45-second raw/mask capture; disables AVI recording')
    parser.add_argument('--calibration-rps', action='store_true', help='60-second calibration including scissors; disables AVI')
    parser.add_argument('--record-fps', type=float, default=8.)
    parser.add_argument('--record-max-mb', type=int, default=128)
    parser.add_argument('--results-dir', type=Path, default=Path(__file__).resolve().parent / 'project1_recordings')
    parser.add_argument('--guard-receipt', type=Path)
    parser.add_argument('bitstream', type=Path)
    parser.add_argument('output', type=Path)
    parser.add_argument('--live', action='store_true', required=True)
    parser.add_argument('--bind', default='192.168.2.99')
    parser.add_argument('--port', type=int, default=8088)
    parser.add_argument('--duration', type=float, default=60., help='active processing seconds, excluding overlay/sensor setup')
    options = parser.parse_args()
    if not all(math.isfinite(rate) and 0 <= rate <= 30 for rate in (options.preview_fps, options.debug_fps)):
        parser.error('preview/debug fps must be finite and within 0..30')
    options.no_record = True
    if options.host_only and options.pl_osd:
        parser.error('--host-only cannot use HDMI --pl-osd; browser draws geometry in PS')
    if options.pl_skin and options.pl_moments:
        parser.error('PL skin replaces the dedicated moments kernel; do not run both protocols')
    if not 1 <= options.duration <= 600:
        parser.error('duration must be 1..600 seconds')
    if options.calibration_rps:
        options.calibration = True
    if options.calibration:
        minimum_duration = 60 if options.calibration_rps else 45
        if options.duration < minimum_duration:
            parser.error(f'calibration requires --duration {minimum_duration} or longer')
        options.no_record = True
    if not (0 <= options.hue_max <= 179 and 0 <= options.sat_min <= 255 and 0 <= options.value_min <= 255):
        parser.error('invalid HSV bounds')
    if not 1 <= options.record_fps <= 15 or not 1 <= options.record_max_mb <= 512:
        parser.error('record fps must be 1..15 and record max MB must be 1..512')
    if not 1 <= options.defect_depth <= 100:
        parser.error('defect depth must be 1..100 pixels')
    recognizer = OriginalContour(options.confirm, (0, options.sat_min, options.value_min),
                                 (options.hue_max, 255, 255), options.dilate_iterations, options.defect_depth)
    if options.tracking:
        if not 100 <= options.track_min_area <= 100000:
            parser.error('track minimum area must be 100..100000 pixels')
        recognizer = FullFrameTracker((0, options.sat_min, options.value_min),
                                     (options.hue_max,255,255),options.dilate_iterations,
                                     options.defect_depth, options.track_min_area)
    camera_dir = options.camera_dir.resolve()
    recognizer.debug_enabled = False
    from gesture_control import GestureControl
    controller = GestureControl()
    if not (camera_dir / 'capture_camera_direct_plug.py').is_file():
        raise FileNotFoundError(camera_dir / 'capture_camera_direct_plug.py')
    sys.path.insert(0, str(camera_dir))
    camera = importlib.import_module('capture_camera_direct_plug')
    if os.geteuid() != 0:
        raise PermissionError('run through the existing root camera guard')
    bitstream = options.bitstream.resolve()
    hwh = bitstream.with_suffix('.hwh')
    if not bitstream.is_file() or not hwh.is_file():
        raise FileNotFoundError('matching camera bit/HWH required')
    # Validate the hardware description without programming PL first.
    from xml.etree import ElementTree
    modules = {m.get('INSTANCE'): m for m in ElementTree.parse(hwh).iter('MODULE')}
    if not camera.REQUIRED_IP <= modules.keys():
        raise RuntimeError('camera IP missing from HWH')
    dma_params = {p.get('NAME'): p.get('VALUE') for p in modules['frame_dma'].iter('PARAMETER')}
    if dma_params.get('C_INCLUDE_MM2S') != '1':
        raise RuntimeError('bidirectional camera HDMI overlay required')
    if (options.pl_moments or options.pl_skin) and not {'moments_dma','moments_reset'} <= modules.keys():
        raise RuntimeError('PL moments requested but dedicated DMA/reset absent')
    if options.pl_skin and 'skin_kernel' not in modules:
        raise RuntimeError('v6 skin_kernel missing; old moments bitstream rejected before programming')
    if options.pl_moments and 'skin_kernel' in modules:
        raise RuntimeError('v6 skin bitstream cannot run old moments protocol')
    if options.pl_osd:
        if 'hand_osd' not in modules:
            raise RuntimeError('PL OSD requested but hand_osd missing from HWH')
        # This validation mode requires the new package verifier and matched pair.
        from importlib import util
        verifier_path = bitstream.parent / 'verify_package.py'
        spec = util.spec_from_file_location('osd_package_verifier', verifier_path)
        verifier = util.module_from_spec(spec)
        spec.loader.exec_module(verifier)
        verifier.verify(bitstream.parent)
        from osd_control import HandOSDControl
        from pl_osd_bridge import metadata_from_result
    options.results_dir.mkdir(parents=True, exist_ok=True)
    if not options.no_record and shutil.disk_usage(options.results_dir).free < (options.record_max_mb + 64) * 1024 * 1024:
        raise OSError('insufficient free space for bounded recording; free space or use --no-record')
    run_dir = options.results_dir / ('project1_results_' + time.strftime('%Y%m%d_%H%M%S'))
    run_dir.mkdir(exist_ok=False)
    calibration = CalibrationCapture(run_dir, options.rotate, options.mirror, options.capture_order,
                                     options.calibration_rps) if options.calibration else None
    (run_dir / 'run_config.json').write_text(json.dumps(dict(
        capture_order=options.capture_order, rotate=options.rotate, mirror=options.mirror,
        hsv_lower=recognizer.lower.tolist(), hsv_upper=recognizer.upper.tolist(),
        confirm=options.confirm, duration=options.duration, calibration_rps=options.calibration_rps,
        dilate_iterations=options.dilate_iterations, defect_depth=options.defect_depth,
        tracking=options.tracking, search_roi=list(recognizer.roi), pl_moments=options.pl_moments,
        track_min_area=options.track_min_area, temporal_mode='3_of_5_latest_agrees' if options.tracking else 'consecutive',
        version='pl_skin_v61_async_preview_candidate', pl_osd=options.pl_osd,
        preview_fps=options.preview_fps, debug_fps=options.debug_fps,
        preview_policy='subscribed_latest_only_background_encoder',
        preview_backend='spawn_process_two_shared_memory_slots',
        save_preview_snapshots=options.save_preview_snapshots,
        trace_frames=options.trace_frames,
        pl_skin=options.pl_skin, pl_skin_mode=options.pl_skin_mode,
        hdmi_enabled=not options.host_only, host_only=options.host_only,
        preview_size=[640,360], control_publish_stage='before overlay / optional HDMI / JPEG',
        classifier='scale_adaptive_rps_shape_v1' if options.tracking else 'original',
        centroid_method='skin threshold pixels intersect selected filled contour; holes excluded',
        note='RPS labels remain heuristic candidates; v6 frontend, sensor table unchanged'), indent=2), encoding='utf-8')
    (run_dir / 'control_config.json').write_text(json.dumps(dict(
        schema='gesture-control-v1', debug_view=options.debug_view, enter=controller.enter,
        release=controller.release, smoothing_tau_s=controller.tau, timeout_s=controller.timeout,
        coordinates='640x360 after rotation/mirror; display left is control left',
        safety='edge/error/no hand/gap releases control; browser independently expires stale frames',
        acceptance='PS control prototype, not connected to external game'), indent=2), encoding='utf-8')

    print(f'PROJECT1_RESULTS={run_dir}', flush=True)
    print('PROJECT1_VERSION=pl_skin_v61_async_preview_candidate', flush=True)
    print(f'PROJECT1_OUTPUT_MODE={"HOST_ONLY" if options.host_only else "HDMI_AND_HOST"}; HDMI_ENABLED={int(not options.host_only)}', flush=True)
    print('PROJECT1_LATENCY_MODE=EARLY_CONTROL; browser preview/control preserved', flush=True)
    print(f'PROJECT1_CAPTURE_ORDER={options.capture_order}', flush=True)
    print('PROJECT1_ACCEPTANCE=NOT_YET_BOARD_VALIDATED; RPS labels are heuristic candidates', flush=True)
    stop = Event()
    def request_stop(number, frame):
        stop.set()  # never raise asynchronously inside NumPy/XRT or thread startup
    signal.signal(signal.SIGTERM, request_stop)
    signal.signal(signal.SIGINT, request_stop)
    from pynq import Overlay
    from pynq.lib.iic import AxiIIC
    from pynq.lib.video import VideoMode
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    preview = recorder = channel = display = demosaic = osd = moments_backend = skin_backend = None
    preview_encoder = None
    performance = {key: deque(maxlen=4096) for key in
                   ('result_interval_ms', 'inference_ms', 'capture_to_result_ms', 'preview_submit_ms')}
    last_result_at = None
    frame_id = 0
    retained = deque(maxlen=12)
    fields = ['frame', 'elapsed_s', 'process_ms', 'raw', 'stable', 'rps_candidate',
              'fingers', 'area', 'gap_percent', 'bbox', 'error', 'video_frame', 'touches_roi',
              'hand_state', 'candidate_count', 'centroid_x', 'centroid_y', 'pixel_area',
              'sum_x', 'sum_y', 'timing_ms', 'capture_copy_ms', 'display_write_ms',
              'pl_osd_applied', 'pl_osd_metadata', 'pl_moments', 'control', 'debug_ms', 'debug_timing',
              'inference_ms', 'capture_to_result_ms', 'preview_encode_ms', 'cycle_to_log_ms','pl_skin', 'hdmi_enabled',
              'preview_submit_ms', 'preview_worker_stats']
    try:
        # Bind the port/encoder before touching hardware, so errors fail early.
        write_guard_receipt(options.guard_receipt, 'STARTING', run_dir.name, 0)
        preview = BytesPreview(options.bind, options.port)
        def publish_snapshot(mode, payload):
            if mode == 'debug':
                preview.publish_debug(payload)
            else:
                preview.publish(payload)
        preview_encoder = ProcessPreviewEncoder(
            preview.demand, partial(encode_preview_snapshot,
                                    snapshot_dir=str(run_dir) if options.save_preview_snapshots else None),
            publish_snapshot,
            video_fps=options.preview_fps, debug_fps=options.debug_fps if options.debug_view else 0.)
        preview.update_health(asdict(preview_encoder.health()))
        if not options.no_record:
            recorder = VideoRecorder(run_dir, options.record_fps, options.record_max_mb)
        overlay = Overlay(str(bitstream))
        if options.pl_skin:
            from skin_dma import SkinDMA
            skin_backend = SkinDMA(overlay)
            recognizer.skin_backend = skin_backend
            recognizer.skin_validate = options.pl_skin_mode=='validate'
            print(f'PROJECT1_PL_SKIN=COMPACT_BGR_DMA mode={options.pl_skin_mode}; morphology/contours/RPS remain PS',flush=True)
        if options.pl_moments:
            from moments_dma import MomentsDMA
            moments_backend = MomentsDMA(overlay)
            recognizer.moments_backend = moments_backend
            print('PROJECT1_PL_MOMENTS=DMA_SAME_FRAME_VALIDATION; HSV/morphology/RPS remain PS', flush=True)
        if options.pl_osd:
            osd = HandOSDControl(overlay.hand_osd.mmio)
            print('PROJECT1_PL_OSD_ID=PASS; HDMI geometry is PL, preview/recording geometry is PS', flush=True)
        iic = AxiIIC(overlay.ip_dict['camera_iic'])
        camera.probe_chip_id(iic)
        camera.configure_sensor(iic)
        if stop.is_set():
            return
        demosaic = overlay.demosaic
        demosaic.write(0x10, camera.WIDTH)
        demosaic.write(0x18, camera.HEIGHT)
        demosaic.write(0x28, 1)
        demosaic.write(0, 0x81)
        dma = camera.open_frame_dma(overlay, hwh)
        channel, display = select_frame_channels(dma, VideoMode(camera.WIDTH, camera.HEIGHT, 24), options.host_only)
        channel.start()
        if display is not None:
            display.start()
        else:
            print('PROJECT1_HDMI_SKIPPED=MM2S_not_started; no_output_buffers; browser_OSD=PS', flush=True)
        started, snapshot_at, jpeg_at, frame_id = time.monotonic(), -10., -1., 0
        debug_at = -10.
        print(f'PROJECT1_READY=http://{options.bind}:{options.port}/camera.mjpg duration={options.duration}', flush=True)
        print(f'PROJECT1_DASHBOARD=http://{options.bind}:{options.port}/ debug_view={options.debug_view}', flush=True)
        with (run_dir / 'frames.csv').open('w', newline='', encoding='utf-8') as fp:
            writer = csv.DictWriter(fp, fieldnames=fields)
            writer.writeheader()
            while not stop.is_set() and time.monotonic()-started < options.duration:
                loop_started = time.perf_counter()
                capture_started = time.perf_counter()
                captured = channel.readframe()
                capture_return_at = time.monotonic()
                retained.append(captured)
                raw = np.asarray(captured).copy()
                capture_copy_ms = (time.perf_counter()-capture_started)*1000
                if stop.is_set():
                    break
                if frame_id == 0:
                    camera.save_frame(raw, options.output)
                t0 = time.monotonic()
                preview_health = preview_encoder.health()
                preview.update_health(asdict(preview_health))
                prepared_modes = preview_encoder.due_modes() if preview_health.healthy else frozenset()
                recognizer.debug_enabled = options.debug_view and 'debug' in prepared_modes
                recognizer.result_frame_id = frame_id+1
                early = {}
                def publish_control(observed):
                    nonlocal last_result_at
                    result_ready_at = time.monotonic()
                    if last_result_at is not None:
                        performance['result_interval_ms'].append((result_ready_at-last_result_at)*1000)
                    last_result_at = result_ready_at
                    packet_control = controller.update(observed, frame_id+1, result_ready_at)
                    early.update(control=packet_control,
                                 inference_ms=(result_ready_at-t0)*1000,
                                 capture_to_result_ms=(result_ready_at-capture_return_at)*1000)
                    box, centroid = observed['bbox'], observed['centroid']
                    preview.publish_result(json.dumps(dict(
                        frame=frame_id+1, elapsed_s=round(result_ready_at-started,3),
                        inference_ms=early['inference_ms'], capture_to_result_ms=early['capture_to_result_ms'],
                        publication_stage='after inference, before PS overlay / HDMI / JPEG',
                        capture_timestamp_kind='readframe returned, not sensor exposure time',
                        bbox_640x360=box, bbox_1280x720=[int(v)*2 for v in box] if box else None,
                        coordinate_space='display view after rotation/mirror; half-open xyxy',
                        detected=box is not None, raw=observed['code'], stable=observed['stable'],
                        centroid_valid=centroid is not None, centroid_640x360=centroid,
                        centroid_1280x720=[v*2+.5 for v in centroid] if centroid else None,
                        centroid_kind='selected observed skin pixel area center, not palm center',
                        centroid_hdmi_mapping='pixel centers: 2*x+0.5, 2*y+0.5',
                        pixel_stats=observed['pixel_stats'], timing_ms=observed['timing_ms'],
                        pl_skin=observed.get('pl_skin'),
                        rps=observed['rps'], hand_state=observed.get('hand_state','UNKNOWN'),
                        hdmi_enabled=not options.host_only, pl_osd_requested=osd is not None,
                        pl_osd_applied=False, pl_osd_status='disabled host-only' if options.host_only else 'pending current frame; CSV records application',
                        touches_frame_or_roi=observed['touches_roi'], tracking=options.tracking,
                        control=packet_control, run_id=run_dir.name
                    )).encode('utf-8'))
                processed, result = process_rgb(raw, recognizer, options.rotate, options.mirror,
                                                options.capture_order,
                                                output_size=(640,360) if options.host_only or osd is not None else (1280,720),
                                                on_result=publish_control,
                                                annotate=not options.host_only or options.calibration)
                result['preview_needs_annotation'] = options.host_only and not options.calibration
                process_ms = (time.monotonic()-t0)*1000
                if calibration:
                    cue = calibration.cue(time.monotonic()-started)
                    cv2.rectangle(processed, (0, 56), (processed.shape[1]-1, 95), (0, 0, 0), -1)
                    cv2.putText(processed, cue, (10, 86), cv2.FONT_HERSHEY_SIMPLEX, .7, (255,255,255), 2)
                display_write_ms = write_display_frame(display, processed, raw, options.capture_order,
                                                       options.rotate, options.mirror, osd is not None)
                frame_id += 1
                if frame_id == 1:
                    write_guard_receipt(options.guard_receipt, 'RUNNING', run_dir.name, frame_id)
                osd_metadata = None
                if osd is not None:
                    osd_metadata = metadata_from_result(result, frame_id)
                    osd.publish(osd_metadata, timeout=.5, wait_applied=True)
                    if frame_id == 1 or frame_id % 25 == 0:
                        print(f'PROJECT1_PL_OSD_APPLIED={frame_id} metadata={osd_metadata}', flush=True)
                elapsed = time.monotonic()-started
                box = result['bbox']
                centroid = result['centroid']
                stats = result['pixel_stats'] or {}
                control = early['control']
                debug_ms = 0.
                debug_timing = {}
                submit_started = time.perf_counter()
                if preview_health.healthy:
                    preview_encoder.submit(lambda modes: PreviewSnapshot(
                        frame_id, modes & prepared_modes,
                        processed if 'video' in modes else None,
                        result, control))
                preview_submit_ms = (time.perf_counter()-submit_started)*1000
                performance['preview_submit_ms'].append(preview_submit_ms)
                performance['inference_ms'].append(early['inference_ms'])
                performance['capture_to_result_ms'].append(early['capture_to_result_ms'])
                if calibration:
                    calibration.capture(raw, processed, result, frame_id, elapsed)
                video_frame = recorder.write(processed, elapsed) if recorder else None
                preview_encode_ms = 0.
                if options.trace_frames:
                    writer.writerow(dict(frame=frame_id, elapsed_s=round(elapsed,3), process_ms=round(process_ms,3),
                    raw=result['code'], stable=result['stable'], rps_candidate=result['rps'],
                    fingers=result['fingers'], area=result['area'], gap_percent=result['ratio'],
                    bbox=result['bbox'], error=result['error'], video_frame=video_frame,
                    touches_roi=result['touches_roi'], hand_state=result.get('hand_state','UNKNOWN'),
                    candidate_count=result.get('candidates',0),
                    centroid_x=centroid[0] if centroid else '', centroid_y=centroid[1] if centroid else '',
                    pixel_area=stats.get('area',0), sum_x=stats.get('sum_x',0), sum_y=stats.get('sum_y',0),
                    timing_ms=json.dumps(result['timing_ms']), capture_copy_ms=capture_copy_ms,
                    display_write_ms=display_write_ms, hdmi_enabled=not options.host_only,
                    pl_osd_applied=osd is not None,
                    pl_osd_metadata=json.dumps(osd_metadata),
                    control=json.dumps(control), debug_ms=debug_ms, debug_timing=json.dumps(debug_timing),
                    inference_ms=early['inference_ms'], capture_to_result_ms=early['capture_to_result_ms'],
                    preview_encode_ms=preview_encode_ms, cycle_to_log_ms=(time.perf_counter()-loop_started)*1000,
                    preview_submit_ms=preview_submit_ms,
                    preview_worker_stats=json.dumps(preview_encoder.stats()),
                    pl_skin=json.dumps(result.get('pl_skin')),
                    pl_moments=json.dumps({key:stats[key] for key in
                        ('frame_id','same_frame_exact','pack_cache_ms','dma_cache_ms','total_ms',
                         'pack_ms','tx_copy_cache_ms','rx_snapshot_ms','decode_ms') if key in stats})))
                if options.trace_frames and (frame_id == 1 or frame_id % 25 == 0):
                    fp.flush()
                    print(f"PROJECT1_FRAME={frame_id} loop_fps={frame_id/max(elapsed,.001):.2f} "
                          f"raw={result['code']} stable={result['stable']} RPS_CANDIDATE={result['rps']}", flush=True)
    finally:
        primary_error = sys.exc_info()[1]
        stop.set()
        diagnostic_errors, hardware_errors, service_errors = [], [], []
        if preview_encoder is not None:
            try:
                preview_encoder.close()
            except Exception as exc:
                diagnostic_errors.append(f'preview encoder: {exc}')
        # Disable while video SOF still flows; never reload another overlay here.
        if osd is not None and display is not None:
            try:
                osd.disable(timeout=.5, wait_applied=True)
            except Exception as exc:
                hardware_errors.append(f'OSD disable: {exc}')
        for name, resource, action in [('skin DMA',skin_backend,'close'), ('moments DMA',moments_backend,'close'), ('display',display,'stop'), ('capture',channel,'stop'),
                                       ('preview',preview,'close'), ('recording',recorder,'close'),
                                       ('calibration',calibration,'close')]:
            if resource is not None:
                try:
                    getattr(resource,action)()
                except Exception as exc:
                    target = hardware_errors if name in ('skin DMA', 'moments DMA', 'display', 'capture') else service_errors
                    target.append(f'{name}: {exc}')
        if demosaic is not None:
            try:
                demosaic.write(0,0)
            except Exception as exc:
                hardware_errors.append(f'demosaic: {exc}')
        try:
            loop.close()
        except Exception as exc:
            service_errors.append(f'event loop: {exc}')
        try:
            write_guard_receipt(options.guard_receipt,
                                'FAULT' if hardware_errors or service_errors or primary_error else 'STOPPED',
                                run_dir.name, frame_id,
                                dict(diagnostic=diagnostic_errors, hardware=hardware_errors, services=service_errors),
                                retaining_buffers=bool(hardware_errors), primary_error=primary_error)
        except Exception as exc:
            service_errors.append(f'guard receipt: {exc}')
        if not hardware_errors:
            retained.clear()
        summary = {}
        for key, values in performance.items():
            if values:
                summary[key] = dict(count=len(values), mean=float(np.mean(values)),
                                    p50=float(np.percentile(values,50)),
                                    p95=float(np.percentile(values,95)),
                                    p99=float(np.percentile(values,99)), maximum=float(max(values)))
        try:
            (run_dir/'performance_summary.json').write_text(json.dumps(dict(
                samples='latest up to 4096 completed frames, not sensor exposure latency',
                metrics=summary, preview_worker=preview_encoder.stats() if preview_encoder else {},
                cleanup=dict(diagnostic=diagnostic_errors, hardware=hardware_errors, services=service_errors),
                primary_error=str(primary_error) if primary_error else None,
                board_validated=False), indent=2), encoding='utf-8')
        except Exception as exc:
            service_errors.append(f'performance summary: {exc}')
        failures = []
        if diagnostic_errors:
            failures.append('diagnostic cleanup: ' + '; '.join(diagnostic_errors))
        if hardware_errors:
            failures.append('hardware cleanup failed; outer guard must halt DMA: ' + '; '.join(hardware_errors))
        if service_errors:
            failures.append('service cleanup: ' + '; '.join(service_errors))
        if failures:
            message = ' | '.join(failures)
            print('PROJECT1_CLEANUP_ERRORS=' + message, flush=True)
            if primary_error is not None:
                add_note = getattr(primary_error, 'add_note', None)
                if add_note is not None:
                    add_note(message)
            elif hardware_errors or service_errors:
                if hardware_errors and options.guard_receipt is not None:
                    retain_for_guard()
                raise RuntimeError(message)
        if hardware_errors and options.guard_receipt is not None:
            retain_for_guard()
        marker = 'incomplete' if hardware_errors or service_errors else 'completed'
        print(f'PROJECT1_STOPPED=single-owner hardware/service cleanup {marker}', flush=True)


if __name__ == '__main__':
    main()
