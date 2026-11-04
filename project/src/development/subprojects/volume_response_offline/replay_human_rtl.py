"""Run: python replay_human_rtl.py --root build/volume-response/acoustic-a03-human --output build/volume-response/human-xsim-r01 --bin D:/Xilinx/Vivado/2026.1/Vivado/bin
Output: bound PCM/golden memories, XSim logs and receipt. Next: compare original
hardware FSM events with a candidate, then validate real PS/provider/skills.
"""
import argparse,hashlib,json,subprocess,time
from pathlib import Path
import numpy as np
from analyze_human_pcm import filtered_windows


def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--root',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--bin',type=Path,required=True);args=p.parse_args()
    args.output=args.output.resolve();args.output.mkdir(parents=True,exist_ok=False)
    repo=Path(__file__).resolve().parents[2];source=repo/'build/volume-response/audit-r01/rtl/voice_volume_core.sv';bench=Path(__file__).with_name('tb_human_replay.sv')
    assert sha(source)=='e25b8109b5d734a72637b732d57f99731abf0c5ad5d66864ab708bb67e4c8ec9'
    raw=args.root/'board-raw.npy';data=np.load(raw,allow_pickle=False).astype(np.int64)&0xffffff
    left=(np.where(data&0x800000,data-0x1000000,data).reshape(-1,2)[:,0]>>8)
    assert len(left)==1536000
    (args.output/'human-left.mem').write_text(''.join(f'{int(v)&0xffff:04x}\n' for v in left))
    sums=np.rint(filtered_windows(left)*977).astype(np.uint32)
    (args.output/'human-sums.mem').write_text(''.join(f'{int(v):08x}\n' for v in sums))
    commands=[[str(args.bin/'xvlog.bat'),'--sv',str(source),str(bench)],
              [str(args.bin/'xelab.bat'),'tb_human_replay','-s','human_replay','--mt','off'],
              [str(args.bin/'xsim.bat'),'human_replay','-runall']]
    receipt=dict(status='RUNNING',passed=False,raw_sha256=sha(raw),rtl_sha256=sha(source),bench_sha256=sha(bench),board_access=False,steps=[])
    try:
        for i,command in enumerate(commands):
            started=time.monotonic();r=subprocess.run(command,cwd=args.output,capture_output=True,timeout=180)
            text=(r.stdout+r.stderr).decode('utf-8',errors='replace');(args.output/f'step-{i}.log').write_text(text)
            receipt['steps'].append(dict(command=command,returncode=r.returncode,seconds=time.monotonic()-started));print('HUMAN_XSIM_STAGE',i,r.returncode,flush=True)
            if r.returncode or 'Fatal:' in text or 'FATAL:' in text:raise RuntimeError(f'XSim stage {i} failed')
            if i==2:
                passed=[s for s in text.splitlines() if s.startswith('TEST_PASS human_replay ')];assert len(passed)==1
                receipt.update(verdict=passed[0],events=[s for s in text.splitlines() if s.startswith('HUMAN_EVENT ')])
        receipt.update(status='HUMAN_PCM_ORIGINAL_RTL_REPLAY_PASS',passed=True);print(receipt['verdict'])
    except BaseException as error:receipt.update(status='FAIL',error=repr(error));raise
    finally:(args.output/'receipt.json').write_text(json.dumps(receipt,indent=2))


if __name__=='__main__':main()
