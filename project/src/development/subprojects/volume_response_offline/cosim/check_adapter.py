"""Check SystemC -> Windows Python -> XSI -> real AXI identities, offline only.

PowerShell: wsl -d Ubuntu -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/check_adapter.py --adapter /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-adapter-build-r03/receipt.json --output /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-adapter-check-r01
Outputs: adapter.log, nested RTL evidence and receipt.json. Next: ARM guest run;
identity checks are transport validation, not audio or latency acceptance.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--adapter',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    a.output.mkdir(parents=True,exist_ok=False)
    receipt=dict(status='RUNNING',board_access=False)
    try:
        adapter=json.loads(a.adapter.read_text());assert adapter['status']=='ADAPTER_BUILD_PASS'
        exe=Path(adapter['executable'])
        assert hashlib.sha256(exe.read_bytes()).hexdigest()==adapter['executable_sha256']
        directory=a.output.resolve()/'rtl'
        assert str(directory).startswith('/mnt/e/projects/fpga/voice-view-game/build/volume-response/')
        windows='E:'+str(directory)[len('/mnt/e'):]
        command=[str(exe),'--rpc-selftest',windows];receipt['command']=command
        with (a.output/'adapter.log').open('w') as log:
            result=subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,timeout=180)
        receipt['returncode']=result.returncode
        assert result.returncode==0,'see adapter.log'
        assert 'RPC_SELFTEST_PASS' in (a.output/'adapter.log').read_text()
        rtl=json.loads((directory/'receipt.json').read_text())
        assert rtl['status']=='TRANSPORT_CLOSED' and rtl['transactions']==2,rtl
        assert rtl['serial_errors']==rtl['pixel_errors']==0,rtl
        receipt.update(status='RPC_INTERFACE_PASS',rtl_receipt_sha256=hashlib.sha256((directory/'receipt.json').read_bytes()).hexdigest())
    except BaseException as e:receipt.update(status='FAIL',error=repr(e));raise
    finally:(a.output/'receipt.json').write_text(json.dumps(receipt,indent=2))
    print(receipt['status'],flush=True)


if __name__=='__main__':main()
