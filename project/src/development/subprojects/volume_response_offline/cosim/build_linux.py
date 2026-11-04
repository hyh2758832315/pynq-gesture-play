"""Build prepared offline Linux, without installing or accessing physical devices.

PowerShell:
  wsl -d Ubuntu -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/build_linux.py --prepared /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-linux-prepare-r01/receipt.json --output /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-linux-build-r01
Outputs: build.log, receipt.json, Linux zImage/DTB/initramfs in recorded output.
Next: run a bounded QEMU + SystemC boot smoke; a build PASS is not an audio PASS.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--prepared',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--resume-after',type=Path,help='Closed FAIL receipt from this same prepared build')
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    record=dict(status='RUNNING',board_access=False,guest_started=False)
    start=time.monotonic()
    try:
        prepared=json.loads(a.prepared.read_text());assert prepared['status']=='LINUX_CONFIGURATION_PASS'
        if a.resume_after:
            previous=json.loads(a.resume_after.read_text())
            assert previous['status']=='FAIL'
            assert Path(previous['prepared_receipt']).resolve()==a.prepared.resolve()
            record['resume_after']=str(a.resume_after)
        output=Path(prepared['linux_output'])
        assert output==Path('/root/voice-view-audio-cosim-r01/buildroot-output-r01')
        command=['make','-C','/root/voice-view-audio-cosim-r01/buildroot','O='+str(output),'-j2']
        # WSL appends Windows PATH entries containing spaces; Buildroot rejects
        # them. Change only this subprocess environment, never the user's PATH.
        environment=os.environ.copy()
        environment['PATH']='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
        record.update(command=command,prepared_receipt=str(a.prepared),build_path=environment['PATH'])
        (a.output/'running.json').write_text(json.dumps(dict(pid=os.getpid(),command=command,started=time.time()),indent=2))
        print('Starting isolated Linux build; follow build.log',flush=True)
        with (a.output/'build.log').open('w') as log:
            result=subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,timeout=7200,env=environment)
        record['returncode']=result.returncode
        assert result.returncode==0,'Linux build failed; inspect build.log'
        images=output/'images'
        files=[images/'zImage',images/'voice-view-cosim.dtb',images/'rootfs.cpio.gz']
        record['images']={str(path):dict(bytes=path.stat().st_size,sha256=hashlib.sha256(path.read_bytes()).hexdigest()) for path in files}
        record['status']='LINUX_BUILD_PASS'
    except BaseException as error:
        record.update(status='FAIL',error=repr(error));raise
    finally:
        record['wall_seconds']=time.monotonic()-start
        (a.output/'receipt.json').write_text(json.dumps(record,indent=2))
    print(record['status'],flush=True)


if __name__=='__main__':main()
