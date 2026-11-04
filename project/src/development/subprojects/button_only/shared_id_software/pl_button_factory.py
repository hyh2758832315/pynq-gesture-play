"""Button-only dual-mask vision worker with independent hand OSD observations."""
from uuid import uuid4
from numbers import Integral


BUILD_ID=0xC0061000
PROFILE='C6I_PL_VISION_BUTTON_OSD_V1'


def capture_thresholds(lower,upper):
    if len(lower)!=3 or len(upper)!=3:
        raise ValueError('HSV lower/upper must each contain three components')
    if any(isinstance(value,bool) or not isinstance(value,Integral) for value in (*lower,*upper)):
        raise ValueError('HSV bounds must contain integer bytes')
    result=tuple(int(value) for pair in zip(lower,upper) for value in pair)
    for index,(lo,hi) in enumerate(zip(result[::2],result[1::2])):
        if not 0<=lo<=hi<=(179 if index==0 else 255):
            raise ValueError('HSV bounds must be ordered in H/S/V byte ranges')
    return result


def create_worker(session,provider,osd_hub,args,run_id,runtime,camera,iic_factory):
    if session.build_id!=BUILD_ID or not session.is_open:
        raise ValueError('C0E worker requires the already-open paired session')
    from gesture_control import GestureControl
    from board.pynq_z2.vision_latest_capture import LatestCaptureHardware
    recognizer=runtime.DualMaskFullFrameTracker(dilate_iterations=4)
    thresholds=capture_thresholds(recognizer.lower,recognizer.upper)
    epoch=int(uuid4().hex[-8:],16) or 1
    hardware=runtime.SharedDualMaskHardware(session,camera,iic_factory,epoch=epoch,
                                            config_id=1,thresholds=thresholds)
    hardware=LatestCaptureHardware(hardware)
    worker=runtime.SharedDualMaskWorker(hardware,recognizer,GestureControl(),provider,
        run_id=run_id,config_epoch=f'{PROFILE}-1-{epoch}',capture_order='bgr',
        preview_factory=lambda:runtime.BytesPreview(args.vision_bind,args.vision_port),
        video_fps=args.vision_preview_fps,debug_fps=args.vision_debug_fps,
        run_dir=args.vision_output_dir/run_id)
    worker.capture_validator=hardware.accept_delivery
    worker.capture_snapshot=hardware.snapshot
    worker.osd_observer=osd_hub.publish
    return worker
