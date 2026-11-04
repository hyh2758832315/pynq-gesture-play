"""Build the official Zynq SystemC remote-port demo in the isolated Linux tree.

PowerShell:
  wsl -d Ubuntu -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/build_systemc.py --output /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-systemc-build-r01
Requires the already cloned official demo and its pinned libsystemctlm-soc.
Outputs: build/ldd logs, source identities, executable checksum in receipt.json.
Next: connect to a QEMU Zynq guest. Build PASS is NOT a guest/RTL cosim PASS.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import time


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--linux-root',type=Path,default=Path('/root/voice-view-audio-cosim-r01'))
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    root=a.linux_root/'systemctlm-cosim-demo'
    record=dict(status='RUNNING',board_access=False,guest_started=False,steps=[])
    def run(command,name):
        start=time.monotonic();print('Starting '+name,flush=True)
        with (a.output/name).open('w') as log:
            r=subprocess.run(command,cwd=root,stdout=log,stderr=subprocess.STDOUT,timeout=600)
        record['steps'].append(dict(command=command,returncode=r.returncode,seconds=time.monotonic()-start))
        assert r.returncode==0,name+' failed; inspect log'
    try:
        revision=subprocess.check_output(['git','-C',str(root),'rev-parse','HEAD'],text=True).strip()
        assert revision=='b36e1dd35265528918b32c8924baa6bf2f41e3c6',revision
        pinned=subprocess.check_output(['git','-C',str(root),'ls-tree','HEAD','libsystemctlm-soc'],text=True).split()[2]
        actual=subprocess.check_output(['git','-C',str(root/'libsystemctlm-soc'),'rev-parse','HEAD'],text=True).strip()
        assert actual==pinned,(actual,pinned)
        record.update(demo_commit=revision,library_commit=actual)
        config='CXXFLAGS=-std=c++17\nSYSTEMC_INCLUDE=/usr/include\nSYSTEMC_LIBDIR=/usr/lib/x86_64-linux-gnu\nHAVE_VERILOG=n\nHAVE_VERILOG_VERILATOR=n\nHAVE_VERILOG_VCS=n\nPYTHON=python3\n'
        with (root/'.config.mk').open('x') as f:f.write(config)
        record['config']=config
        run(['make','-j2','zynq_demo'],'build.log')
        run(['ldd',str(root/'zynq_demo')],'libraries.txt')
        assert 'not found' not in (a.output/'libraries.txt').read_text()
        record.update(status='SYSTEMC_BUILD_PASS',executable=str(root/'zynq_demo'),
                      executable_sha256=hashlib.sha256((root/'zynq_demo').read_bytes()).hexdigest())
    except BaseException as error:
        record.update(status='FAIL',error=repr(error));raise
    finally:(a.output/'receipt.json').write_text(json.dumps(record,indent=2))


if __name__=='__main__':main()
