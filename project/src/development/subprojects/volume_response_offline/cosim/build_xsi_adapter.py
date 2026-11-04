"""Build a local SystemC adapter without changing official AMD source files.

PowerShell: wsl -d Ubuntu -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/build_xsi_adapter.py --output /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-adapter-build-r01
Outputs: build.log, binary and SHA receipt. Next: --rpc-selftest, then bounded
ARM guest test. Compiling is not a functional simulation result.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shlex
import subprocess

ROOT=Path(__file__).resolve().parents[3]
NATIVE=Path('/root/voice-view-audio-cosim-r01')


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    native=NATIVE/a.output.name;native.mkdir(exist_ok=False)
    original=NATIVE/'systemctlm-cosim-demo';source=Path(__file__).with_name('zynq_xsi.cc')
    receipt=dict(status='RUNNING',board_access=False,commands=[])
    try:
        lines=(ROOT/'build/volume-response/cosim-systemc-build-r01/build.log').read_text().splitlines()
        original_link=shlex.split(next(line for line in reversed(lines) if line.startswith('g++ -L ') and '-o zynq_demo ' in line))
        objects=[original/token for token in original_link if token.endswith('.o') and token!='zynq_demo.o']
        assert objects and all(path.is_file() for path in objects)
        command=['g++','-std=c++17','-O2','-Wall','-I'+str(original),
            '-I'+str(original/'libsystemctlm-soc'),'-I'+str(original/'libsystemctlm-soc/trace'),
            '-I'+str(original/'libsystemctlm-soc/libremote-port'),
            str(source),*map(str,objects),'-pthread','-lsystemc','-o',str(native/'zynq_xsi')]
        receipt['commands'].append(command)
        with (a.output/'build.log').open('w') as log:
            result=subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,timeout=120)
        assert result.returncode==0,'adapter compile failed; see build.log'
        receipt.update(status='ADAPTER_BUILD_PASS',executable=str(native/'zynq_xsi'),
            source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
            executable_sha256=hashlib.sha256((native/'zynq_xsi').read_bytes()).hexdigest())
    except BaseException as e:receipt.update(status='FAIL',error=repr(e));raise
    finally:(a.output/'receipt.json').write_text(json.dumps(receipt,indent=2))
    print(receipt['status'],flush=True)


if __name__=='__main__':main()
