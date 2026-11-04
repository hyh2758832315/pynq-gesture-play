"""PYNQ root: python3 run_accel_guarded.py SCRIPT BIT OUTPUT --live [options].
Output child exit + halted camera/algorithm DMA states. On halt failure keep a
stopped child alive, retaining its DMA memory; operator recovery is required.
Next: inspect results/frames.csv and measured DMA total_ms, not only kernel time.
"""
import mmap
import os
from pathlib import Path
import signal
import subprocess
import sys
import time
from xml.etree import ElementTree


def halt_engines(hwh, timeout=3.0):
    from pynq import PL
    current = PL.bitfile_name
    if not current or Path(current).resolve()!=Path(hwh).with_suffix('.bit').resolve():
        print('ACCEL_GUARD_SKIP: new overlay not loaded; no unsafe MMIO probe',flush=True)
        return False
    modules={m.get('INSTANCE'):m for m in ElementTree.parse(hwh).iter('MODULE')}
    states={}
    for name in ('moments_dma','frame_dma'):
        module=modules[name]
        params={p.get('NAME'):p.get('VALUE') for p in module.iter('PARAMETER')}
        address=int(params['C_BASEADDR'],0)
        fd=os.open('/dev/mem',os.O_RDWR|os.O_SYNC)
        try:
            with mmap.mmap(fd,4096,offset=address) as regs:
                def read(offset):return int.from_bytes(regs[offset:offset+4],'little')
                for cr in (0,0x30):
                    regs[cr:cr+4]=(read(cr)&~1).to_bytes(4,'little')
                end=time.monotonic()+timeout
                while not all(read(sr)&1 for sr in (4,0x34)):
                    if time.monotonic()>end:raise TimeoutError(f'{name} halt failed')
                    time.sleep(.001)
                states[name]=[read(4),read(0x34)]
        finally:os.close(fd)
    print(f'ACCEL_GUARD_HALTED={states}',flush=True)
    return True


def halt_child_or_retain(child,hwh):
    child.send_signal(signal.SIGSTOP)
    try:
        if halt_engines(hwh) is not True:
            raise RuntimeError('loaded overlay identity not confirmed; refusing unsafe child kill')
    except BaseException as exc:
        raise RuntimeError(f'DMA halt not confirmed; child PID {child.pid} remains STOPPED to retain buffers. '
                           'Do not kill/reload/power-cycle automatically; save logs for operator recovery.') from exc
    child.kill();child.wait()


def main():
    if os.geteuid()!=0 or len(sys.argv)<5 or '--live' not in sys.argv[4:]:
        raise RuntimeError(__doc__)
    script=Path(sys.argv[1]).resolve();bit=Path(sys.argv[2]).resolve()
    if not script.is_file():raise FileNotFoundError(script)
    ancestors=set()
    pid=os.getpid()
    while pid and pid not in ancestors:
        ancestors.add(pid)
        try:pid=int((Path('/proc')/str(pid)/'stat').read_text().rsplit(')',1)[1].split()[1])
        except (OSError,ValueError,IndexError):break
    for command in Path('/proc').glob('[0-9]*/cmdline'):
        if int(command.parent.name) in ancestors:continue
        try:text=command.read_bytes().replace(b'\0',b' ').decode(errors='replace')
        except OSError:continue
        if any(name in text for name in ('project1_live_ov5640.py','capture_camera_direct_plug.py','run_camera_live_guarded.py','run_accel_guarded.py','verify_skin_dma.py','verify_dma.py')):
            raise RuntimeError(f'Another camera owner exists PID={command.parent.name}; stop it first')
    sys.path.insert(0,str(bit.parent))
    from verify_package import verify
    verify(bit.parent)
    if bit.name!='camera_hand_skin_v6.bit':raise ValueError('paired v6 skin bit required')
    stop=[False]
    def request_stop(number,frame):stop[0]=True
    signal.signal(signal.SIGINT,request_stop);signal.signal(signal.SIGTERM,request_stop)
    signal.signal(signal.SIGHUP,request_stop)
    started=time.monotonic()
    child=subprocess.Popen(['/usr/local/share/pynq-venv/bin/python3','-u',str(script),str(bit),*sys.argv[3:]],
                           env={**os.environ,'XILINX_XRT':'/usr','PYTHONFAULTHANDLER':'1'})
    try:
        while child.poll() is None and not stop[0]:time.sleep(.1)
        if stop[0] and child.poll() is None:
            child.send_signal(signal.SIGINT)
            try:child.wait(timeout=10)
            except subprocess.TimeoutExpired:pass
    finally:
        if child.poll() is None:
            # Freeze our child so it cannot restart DMA during the halt sequence.
            halt_child_or_retain(child,bit.with_suffix('.hwh'))
        else:halt_engines(bit.with_suffix('.hwh'))
    print(f'ACCEL_CHILD_EXIT={child.returncode} elapsed={time.monotonic()-started:.3f}',flush=True)
    return child.returncode


if __name__=='__main__':sys.exit(main())
