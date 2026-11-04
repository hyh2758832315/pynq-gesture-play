"""Append an audio probe to an immutable baseline initramfs, using Linux newc.

PowerShell: wsl -d Ubuntu -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/prepare_audio_guest.py --linux-receipt /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-linux-build-r02/receipt.json --modules-receipt /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-modules-image-r01/receipt.json --output /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-audio-image-r01
Outputs: audio.cpio.gz, full rootfs.cpio.gz and SHA receipt. Next: bounded QEMU
audio run. https://docs.kernel.org/driver-api/early-userspace/buffer-format.html
permits concatenated compressed newc archives. Original baseline is not edited.
"""
import argparse
import gzip
import hashlib
import json
from pathlib import Path
import shutil
import subprocess


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--linux-receipt',type=Path,required=True)
    p.add_argument('--modules-receipt',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    receipt=dict(status='RUNNING',board_access=False)
    try:
        baseline=json.loads(a.linux_receipt.read_text());assert baseline['status']=='LINUX_BUILD_PASS'
        modules=json.loads(a.modules_receipt.read_text());assert modules['status']=='MODULES_IMAGE_PREPARED'
        assert modules['baseline_receipt_sha256']==sha(a.linux_receipt)
        base=Path(modules['image']);assert sha(base)==modules['image_sha256']
        overlay=a.output/'overlay'
        program=overlay/'opt/vvg-cosim/guest_audio.py';program.parent.mkdir(parents=True)
        source=Path(__file__).with_name('guest_audio.py');shutil.copyfile(source,program)
        init=overlay/'etc/init.d/S99vvg-cosim-smoke';init.parent.mkdir(parents=True)
        init.write_text('#!/bin/sh\n/usr/bin/python3 /opt/vvg-cosim/guest_smoke.py && /usr/bin/python3 /opt/vvg-cosim/guest_audio.py\n')
        init.chmod(0o755)
        names='opt/vvg-cosim/guest_audio.py\netc/init.d/S99vvg-cosim-smoke\n'
        result=subprocess.run(['/usr/bin/cpio','--create','--format=newc','--quiet','--owner=0:0'],
            cwd=overlay,input=names.encode(),capture_output=True,timeout=30)
        assert result.returncode==0,result.stderr.decode(errors='replace')
        assert b'TRAILER!!!\0' in result.stdout
        compressed=gzip.compress(result.stdout,mtime=0)
        (a.output/'audio.cpio.gz').write_bytes(compressed)
        image=a.output/'rootfs.cpio.gz';image.write_bytes(base.read_bytes()+compressed)
        receipt.update(status='AUDIO_IMAGE_PREPARED',image=str(image.resolve()),image_sha256=sha(image),
            baseline_receipt_sha256=sha(a.linux_receipt),modules_receipt_sha256=sha(a.modules_receipt),
            baseline_image_sha256=sha(base),
            guest_audio_sha256=sha(source),startup_sha256=sha(init))
    except BaseException as e:receipt.update(status='FAIL',error=repr(e));raise
    finally:(a.output/'receipt.json').write_text(json.dumps(receipt,indent=2))
    print(receipt['status'],flush=True)


if __name__=='__main__':main()
