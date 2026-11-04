"""Prepare isolated WSL Ubuntu 24.04 QEMU/SystemC prerequisites; no FPGA access.

PowerShell commands (output directories must be new):
  wsl -d Ubuntu -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/bootstrap_environment.py --stage dependencies --output /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-env-deps-r01
  wsl -d Ubuntu -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/bootstrap_environment.py --stage qemu-source --output /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-env-source-r01
Outputs: command logs and receipt.json; source under the explicit Linux root.
Next: inspect configure-help.txt, then configure/build only ARM system emulation.
Dependency stage requires root and an already refreshed apt index. It installs
build packages, not services. Source stage never resets/deletes an existing tree.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

QEMU_SHA='09c90f09b99af539a56b25fd91e005e1884e8d18'
QEMU_BRANCH='xlnx_rel_v2026.1.1'


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--stage',choices=('dependencies','qemu-source'),required=True)
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--linux-root',type=Path,default=Path('/root/voice-view-audio-cosim-r01'))
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    record=dict(status='RUNNING',board_access=False,stage=a.stage,steps=[],
                source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
    def run(command,name,timeout=1200):
        print('Starting '+name,flush=True);start=time.monotonic()
        env=os.environ.copy();env['DEBIAN_FRONTEND']='noninteractive'
        with (a.output/name).open('w') as log:
            result=subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,env=env,timeout=timeout)
        record['steps'].append(dict(command=command,returncode=result.returncode,seconds=time.monotonic()-start,log=name))
        assert result.returncode==0,name+' failed; inspect log'
        print('Completed '+name,flush=True)
    try:
        if a.stage=='dependencies':
            assert os.getuid()==0,'dependency stage requires root'
            run(['apt-get','install','-y','--no-install-recommends','build-essential','cmake','ninja-build',
                 'pkg-config','libglib2.0-dev','libpixman-1-dev','libsystemc-dev',
                 'device-tree-compiler','zlib1g-dev','python3-venv','libgcrypt20-dev'],'apt-install.log')
            run(['python3',str(Path(__file__).with_name('probe_environment.py'))],'environment.json',60)
        else:
            a.linux_root.mkdir(parents=True,exist_ok=True)
            target=a.linux_root/'qemu';assert not target.exists(),'refuse to overwrite existing source'
            run(['git','clone','--depth','1','--branch',QEMU_BRANCH,'https://github.com/Xilinx/qemu.git',str(target)],'git-clone.log')
            revision=subprocess.check_output(['git','-C',str(target),'rev-parse','HEAD'],text=True).strip()
            assert revision==QEMU_SHA,('official branch changed; re-inspect before building',revision)
            record.update(qemu_commit=revision,qemu_version=(target/'VERSION').read_text().strip(),linux_source=str(target))
            run(['bash',str(target/'configure'),'--help'],'configure-help.txt',60)
        record['status']='PREPARATION_COMPLETE'
    except BaseException as error:
        record.update(status='FAIL',error=repr(error));raise
    finally:(a.output/'receipt.json').write_text(json.dumps(record,indent=2))


if __name__=='__main__':main()
