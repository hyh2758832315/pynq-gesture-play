"""Run: python check_xsi.py --output <new-directory> --vivado <Vivado-install>.

Output: XSI compile logs/receipt; next use same verified ABI in the audio cosim.
Only generates and runs local simulation; no board access.
"""
import argparse,json,subprocess,time
from pathlib import Path
from xsi_bridge import Xsi


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output',type=Path,required=True);p.add_argument('--vivado',type=Path,required=True)
    a=p.parse_args();a.output=a.output.resolve();a.output.mkdir(parents=True,exist_ok=False)
    record=dict(status='RUNNING',steps=[],board_access=False)
    source=Path(__file__).with_name('xsi_smoke.sv').resolve()
    commands=[[str(a.vivado/'bin/xvlog.bat'),'--sv',str(source)],
              [str(a.vivado/'bin/xelab.bat'),'xsi_smoke','-s','smoke','-dll','--debug','typical','--mt','off']]
    try:
        for n,command in enumerate(commands):
            start=time.monotonic();r=subprocess.run(command,cwd=a.output,capture_output=True,timeout=180)
            log=(r.stdout+r.stderr).decode(errors='replace');(a.output/f'step-{n}.log').write_text(log,encoding='utf-8')
            record['steps'].append(dict(command=command,returncode=r.returncode,seconds=time.monotonic()-start))
            assert r.returncode==0,log[-1200:]
        x=Xsi(a.vivado,a.output,'smoke')
        try:
            x.put('enable',1);x.run_ns(100);first=x.get('count');assert first==10,first
            x.put('enable',0);x.run_ns(100);assert x.get('count')==10
            x.put('enable',1);x.run_ns(100);assert x.get('count')==20
            record.update(status='XSI_BRIDGE_PASS',count=20,simulation_ns=x.monotonic_ns())
        finally:x.close()
    except BaseException as e:record.update(status='FAIL',error=repr(e));raise
    finally:(a.output/'receipt.json').write_text(json.dumps(record,indent=2),encoding='utf-8')
    print(record['status'])


if __name__=='__main__':main()
