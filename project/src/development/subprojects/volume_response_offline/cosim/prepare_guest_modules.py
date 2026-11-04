"""Add exact frozen package imports to a built baseline initramfs, offline.

PowerShell: wsl -d Ubuntu -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/prepare_guest_modules.py --linux-receipt /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-linux-build-r02/receipt.json --output /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-modules-image-r01
Outputs: rootfs.cpio.gz, module hashes, receipt.json. Next: boot baseline QEMU.
The frozen __init__.py imports these modules even for audio-only consumers;
their original source bytes are added, never replaced by a test stub.
"""
import argparse
import gzip
import hashlib
import json
from pathlib import Path
import shutil
import subprocess

ROOT=Path(__file__).resolve().parents[3]
PACKAGE=ROOT/'deliveries/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'
MODULES=('controls.py','game.py','renderer.py','scene.py','engine/__init__.py','engine/side_scroller.py')


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--linux-receipt',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    receipt=dict(status='RUNNING',board_access=False)
    try:
        built=json.loads(a.linux_receipt.read_text());assert built['status']=='LINUX_BUILD_PASS'
        base=Path('/root/voice-view-audio-cosim-r01/buildroot-output-r01/images/rootfs.cpio.gz')
        assert sha(base)==built['images'][str(base)]['sha256']
        manifest=json.loads((PACKAGE/'deployment_manifest.json').read_text())['sha256']
        overlay=a.output/'overlay';prefix=Path('opt/vvg-cosim/python/pynq_multimodal_game')
        (overlay/prefix/'engine').mkdir(parents=True)
        receipt['source_hashes']={}
        original_hashes=json.loads((Path('/root/voice-view-audio-cosim-r01/linux-config-r01')/
            'rootfs-overlay/opt/vvg-cosim/source-hashes.json').read_text())
        for name in MODULES:
            source=PACKAGE/'python/pynq_multimodal_game'/name
            key='python/pynq_multimodal_game/'+name
            assert sha(source)==manifest[key].lower(),key
            target=overlay/prefix/name;shutil.copyfile(source,target)
            receipt['source_hashes'][key]=sha(target)
            original_hashes[key]=sha(target)
        guest=overlay/'opt/vvg-cosim/guest_smoke.py'
        shutil.copyfile(Path(__file__).with_name('guest_smoke.py'),guest)
        original_hashes['guest_smoke.py']=sha(guest)
        receipt['source_hashes']['guest_smoke.py']=sha(guest)
        hashfile=overlay/'opt/vvg-cosim/source-hashes.json'
        hashfile.write_text(json.dumps(original_hashes,indent=2))
        names=[str(prefix/'engine'),*(str(prefix/name) for name in MODULES),
               'opt/vvg-cosim/guest_smoke.py','opt/vvg-cosim/source-hashes.json']
        result=subprocess.run(['/usr/bin/cpio','--create','--format=newc','--quiet','--owner=0:0'],
            cwd=overlay,input=('\n'.join(names)+'\n').encode(),capture_output=True,timeout=30)
        assert result.returncode==0,result.stderr.decode(errors='replace')
        assert b'TRAILER!!!\0' in result.stdout
        compressed=gzip.compress(result.stdout,mtime=0)
        (a.output/'modules.cpio.gz').write_bytes(compressed)
        image=a.output/'rootfs.cpio.gz';image.write_bytes(base.read_bytes()+compressed)
        receipt.update(status='MODULES_IMAGE_PREPARED',image=str(image.resolve()),image_sha256=sha(image),
            baseline_receipt_sha256=sha(a.linux_receipt),baseline_image_sha256=sha(base))
    except BaseException as e:receipt.update(status='FAIL',error=repr(e));raise
    finally:(a.output/'receipt.json').write_text(json.dumps(receipt,indent=2))
    print(receipt['status'],flush=True)


if __name__=='__main__':main()
