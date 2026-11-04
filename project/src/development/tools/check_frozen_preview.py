"""Exercise the frozen package's actual JPEG process, with no hardware/network.

Run: .venv/Scripts/python.exe -B tools/check_frozen_preview.py --candidate PACKAGE --output REPORT.json
Output: package identity, decoded dimensions, and confirmed codec release.
Next: Studio standard installation and real HDMI/hand acceptance.
"""
import argparse,json,sys,time,hashlib
from pathlib import Path


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args();package=args.candidate.resolve()
    sys.path[:0]=[str(package/'python'),str(package/'board/pynq_z2/scripts')]
    import numpy as np,cv2
    import vision_async_runtime as runtime
    from pynq_multimodal_game.vision_preview import ProcessPreviewEncoder,PreviewSnapshot
    from pynq_multimodal_game.preview_recovery import RecoverablePreviewEncoder
    images=[]
    def factory(recovering):
        encoder=ProcessPreviewEncoder(lambda:frozenset({'video'}),runtime.encode_preview_snapshot,
            lambda mode,payload:images.append(payload),startup_timeout=10)
        encoder.unlimited=True;return encoder
    encoder=RecoverablePreviewEncoder(factory)
    try:
        assert encoder.health().healthy
        rgb=np.zeros((360,640,3),dtype=np.uint8)
        result=dict(roi=(0,0,640,360),bbox=None,tracking=False,preview_needs_annotation=True)
        encoder.submit(lambda modes:PreviewSnapshot(1,modes,rgb,result,{}))
        deadline=time.monotonic()+10
        while not images and time.monotonic()<deadline:time.sleep(.01)
        assert images,'frozen encoder produced no JPEG'
        image=cv2.imdecode(np.frombuffer(images[0],np.uint8),cv2.IMREAD_COLOR)
        assert image.shape==(360,640,3)
    finally:encoder.close()
    assert encoder.release_confirmed
    report=dict(result='PASS',hardware_access=False,network_access=False,
        manifest_sha256=hashlib.sha256((package/'deployment_manifest.json').read_bytes()).hexdigest(),
        runtime=str(Path(runtime.__file__).resolve()),dimensions=[640,360],
        jpeg_bytes=len(images[0]),codec_release_confirmed=encoder.release_confirmed)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(report,indent=2),encoding='utf-8');print(json.dumps(report))


if __name__=='__main__':main()
