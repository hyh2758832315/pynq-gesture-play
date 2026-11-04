"""CPU-only Linux codec cleanup check; never imports PYNQ or opens hardware.

Run on the board: python -B r58_preview_release_probe.py --module-dir PATH --output result.json
PATH contains the exact vision_preview.py under test. Output includes named
semaphore lifetime and a post-exec verification. Next: inspect evidence before
the separate normal Studio installation / integrated restart test.
"""
import argparse
import gc
import json
import os
from pathlib import Path
import sys


def encode_empty(snapshot,mode):
    return b''


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--module-dir',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--after-exec',action='store_true')
    args=parser.parse_args()
    if args.after_exec:
        report=json.loads(args.output.read_text())
        report['post_exec_clear']=all(not Path(p).exists() for p in report['semaphores'])
        report['result']='PASS' if report['post_exec_clear'] else 'FAIL'
        args.output.write_text(json.dumps(report,indent=2));print(json.dumps(report),flush=True)
        return 0 if report['result']=='PASS' else 1
    sys.path.insert(0,str(args.module_dir))
    from vision_preview import ProcessPreviewEncoder
    import vision_preview
    kept=[];names=[];checks=[]
    for _ in range(2):
        worker=ProcessPreviewEncoder(lambda:frozenset(),encode_empty,lambda *_:None,startup_timeout=30)
        kept.append(worker)  # deliberately keep diagnostics alive, as production can
        # PS uses Event (five semaphores), root uses a single semaphore.
        wake=worker._wake
        if hasattr(wake,'_cond'):
            condition=wake._cond
            locks=(condition._lock,condition._sleeping_count,condition._woken_count,
                   condition._wait_semaphore,wake._flag,*worker._slots)
        else:
            condition=None
            locks=(wake,*worker._slots)
        current=[str(Path('/dev/shm')/('sem.'+lock._semlock.name.lstrip('/'))) for lock in locks]
        del wake,locks,condition
        try:assert all(Path(p).exists() for p in current)
        finally:worker.close()
        worker.close()
        names.extend(current)
        checks.append(dict(cleanup=worker.health().cleanup,wake_cleared=worker._wake is None,
                           slots_remaining=len(worker._slots),
                           semaphores_released=all(not Path(p).exists() for p in current)))
    gc.collect()
    after_gc=all(not Path(p).exists() for p in names)
    report=dict(scope='CPU only; no GPU, camera or hand',module=vision_preview.__file__,checks=checks,semaphores=names,
                after_gc_clear=after_gc,result='PASS' if after_gc else 'FAIL')
    args.output.write_text(json.dumps(report,indent=2))
    if report['result']=='FAIL':print(json.dumps(report),flush=True);return 1
    os.execv(sys.executable,[sys.executable,'-B',str(Path(__file__).resolve()),*sys.argv[1:],'--after-exec'])


if __name__=='__main__':raise SystemExit(main())
