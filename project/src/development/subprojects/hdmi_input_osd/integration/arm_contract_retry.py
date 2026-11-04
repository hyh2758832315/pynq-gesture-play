"""Read system pressure or retry the unchanged20s ARM-only codec contract."""
import argparse
from board_common import remote


if __name__=='__main__':
    parser=argparse.ArgumentParser()
    parser.add_argument('action',choices=('diagnose','retry'))
    parser.add_argument('--label',required=True)
    args=parser.parse_args()
    code='''import json,pathlib,subprocess,os,sys,time
root=pathlib.Path('/home/xilinx/voice-view-game/c6i-vision-volume-osd-r16-20261023-r2')
print(json.dumps(dict(boot=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip(),load=pathlib.Path('/proc/loadavg').read_text(),
    meminfo=pathlib.Path('/proc/meminfo').read_text(),pressure={p.name:p.read_text() for p in pathlib.Path('/proc/pressure').glob('*')})),flush=True)
'''
    if args.action=='retry':
        code+='''environment=dict(os.environ,PYTHONPATH=str(root/'python'))
started=time.monotonic()
result=subprocess.run([sys.executable,'-B',str(root/'tools/osd_preview_shutdown_contract.py')],cwd=root,env=environment,capture_output=True,text=True,encoding='utf-8',timeout=45)
print(json.dumps(dict(returncode=result.returncode,stdout=result.stdout,stderr=result.stderr,elapsed=time.monotonic()-started,hardware_access=False)),flush=True)
assert result.returncode==0
'''
    remote(args.label,code,timeout=60)
