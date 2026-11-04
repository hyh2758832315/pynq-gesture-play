"""Recheck saved traces for complete I2S cadence and no lost/duplicate samples.

Run from workspace root:
  .venv/Scripts/python subprojects/volume_response_offline/cosim/recheck_integrity.py --output build/volume-response/cosim-integrity-r01
Output: separately SHA-bound receipt.json; never changes original run receipts.
Next: retain both original run receipt and this additional offline verification.
"""
import argparse
import hashlib
import json
from pathlib import Path
from run_cosim import ROOT,validate


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    report=dict(status='RUNNING',board_access=False,checks=[])
    try:
        for name,scenario in [('cosim-r03','nominal'),('cosim-left-missing-r01','left_missing'),
                              ('cosim-human-r01','human'),('cosim-publisher-paused-r01','publisher_paused')]:
            root=ROOT/'build/volume-response'/name
            original=json.loads((root/'receipt.json').read_text())
            assert original['status']=='DIGITAL_FUNCTIONAL_COSIM_PASS'
            values=[int(x,16) for x in (root/'left.mem').read_text().splitlines()]
            values=[v-0x1000000 if v>=0x800000 else v for v in values]
            commits=json.loads((root/'commits.json').read_text())
            result=validate(root,values,commits,scenario)
            bound={n:hashlib.sha256((root/n).read_bytes()).hexdigest() for n in
                   ('receipt.json','serialized.csv','pcm.csv','windows.csv','frames.csv','bar.csv','commits.json','left.mem')}
            report['checks'].append(dict(run=name,input_hashes=bound,result=result))
        report.update(status='TRACE_INTEGRITY_PASS',validator_sha256=hashlib.sha256(Path(__file__).with_name('run_cosim.py').read_bytes()).hexdigest())
    except BaseException as error:
        report.update(status='FAIL',error=repr(error));raise
    finally:(a.output/'receipt.json').write_text(json.dumps(report,indent=2))
    print(report['status'])


if __name__=='__main__':main()
