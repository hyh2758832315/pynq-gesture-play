"""Build the pinned AMD QEMU in an isolated WSL tree, without board access.

PowerShell:
  wsl -d Ubuntu -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/build_qemu.py --output /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-qemu-build-r01
Prerequisites: bootstrap_environment.py dependency/source stages completed.
Outputs: configure/build/machine logs, receipt.json, qemu-system-arm/aarch64 in
the Linux build directory. Next: SystemC remote-port + Zynq Linux image smoke.
No install to /usr, no service registration, no guest started by this script.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

EXPECTED='09c90f09b99af539a56b25fd91e005e1884e8d18'


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--linux-root',type=Path,default=Path('/root/voice-view-audio-cosim-r01'))
    p.add_argument('--resume-after',type=Path,help='resume recorded gcrypt header/link configuration failures')
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    source=a.linux_root/'qemu';build=a.linux_root/'qemu-build-r01'
    record=dict(status='RUNNING',board_access=False,guest_started=False,steps=[],
                source_script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
    def run(command,name,timeout):
        print('Starting '+name,flush=True);start=time.monotonic()
        with (a.output/name).open('w') as log:
            result=subprocess.run(command,cwd=build,stdout=log,stderr=subprocess.STDOUT,timeout=timeout)
        record['steps'].append(dict(command=command,returncode=result.returncode,seconds=time.monotonic()-start,log=name))
        assert result.returncode==0,name+' failed; inspect log'
        print('Completed '+name,flush=True)
    try:
        revision=subprocess.check_output(['git','-C',str(source),'rev-parse','HEAD'],text=True).strip()
        assert revision==EXPECTED,revision
        record['qemu_commit']=revision
        configure=[str(source/'configure'),'--target-list=arm-softmmu,aarch64-softmmu',
                   '--without-default-features','--enable-tcg','--enable-fdt=internal',
                   '--enable-gcrypt','--prefix='+str(a.linux_root/'tools')]
        if a.resume_after is None:
            build.mkdir(exist_ok=False)
            run(configure,'configure.log',600)
        else:
            previous=json.loads(a.resume_after.read_text())
            assert previous['status']=='FAIL' and previous['qemu_commit']==EXPECTED
            log=(a.resume_after.parent/'build.log').read_text()
            header_failure='fatal error: gcrypt.h: No such file or directory' in log
            link_failure="undefined reference to `rsa_do_add'" in log and "undefined reference to `gcry_mpi_release'" in log
            assert header_failure or link_failure,'not the diagnosed gcrypt build failure'
            assert Path('/usr/include/gcrypt.h').exists(),'required header still missing'
            assert (build/'build.ninja').exists(),'missing configured build'
            record['resumes_receipt']=str(a.resume_after)
            run(configure,'configure.log',600)
        run(['ninja','-j2'],'build.log',1800)
        run([str(build/'qemu-system-arm'),'--version'],'version.txt',30)
        run([str(build/'qemu-system-arm'),'-machine','help'],'arm-machines.txt',30)
        machines=(a.output/'arm-machines.txt').read_text()
        assert 'arm-generic-fdt-7series' in machines,'missing AMD Zynq machine'
        record.update(status='QEMU_BUILD_PASS',linux_build=str(build),
                      executable_sha256=hashlib.sha256((build/'qemu-system-arm').read_bytes()).hexdigest())
    except BaseException as error:
        record.update(status='FAIL',error=repr(error));raise
    finally:(a.output/'receipt.json').write_text(json.dumps(record,indent=2))


if __name__=='__main__':main()
