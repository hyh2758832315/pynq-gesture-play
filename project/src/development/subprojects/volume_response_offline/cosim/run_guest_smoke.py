"""Bounded local QEMU/SystemC smoke. No physical devices or guest networking.

PowerShell:
  wsl -d Ubuntu -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/run_guest_smoke.py --linux-receipt /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-linux-build-r02/receipt.json --modules-receipt /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-modules-image-r01/receipt.json --output /mnt/e/projects/fpga/voice-view-game/build/volume-response/cosim-guest-smoke-r01
Outputs: serial.log, systemc.log, SHA-bound receipt.json and owned-process exit
codes. Next: attach actual audio/OSD RTL; this baseline is NOT an audio PASS.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import time

ROOT=Path(__file__).resolve().parents[3]
NATIVE=Path('/root/voice-view-audio-cosim-r01')


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--linux-receipt',type=Path,required=True)
    parser.add_argument('--modules-receipt',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--audio-adapter',type=Path)
    parser.add_argument('--audio-image-receipt',type=Path)
    parser.add_argument('--baseline-receipt',type=Path)
    args=parser.parse_args();args.output.mkdir(parents=True,exist_ok=False)
    record=dict(status='RUNNING',board_access=False,guest_network=False,
                actual_audio_rtl=False,processes={})
    processes={};logs=[];started=time.monotonic()
    try:
        built=json.loads(args.linux_receipt.read_text())
        assert built['status']=='LINUX_BUILD_PASS'
        for path,expected in built['images'].items():assert sha(path)==expected['sha256'],path
        record['linux_receipt_sha256']=sha(args.linux_receipt)
        qemu_receipt=ROOT/'build/volume-response/cosim-qemu-build-r03/receipt.json'
        systemc_receipt=ROOT/'build/volume-response/cosim-systemc-build-r01/receipt.json'
        systemc=json.loads(systemc_receipt.read_text())
        assert systemc['status']=='SYSTEMC_BUILD_PASS'
        executable=Path(systemc['executable'])
        assert sha(executable)==systemc['executable_sha256']
        qemu=NATIVE/'qemu-build-r01/qemu-system-arm'
        assert sha(qemu)=='e79b3526edc3e23f29f109f0b6f1026e21a4859c40865a589207cb7436558b99'
        record['framework_receipts']={str(p):sha(p) for p in (qemu_receipt,systemc_receipt)}
        assert re.fullmatch('[a-z0-9-]+',args.output.name)
        native=NATIVE/args.output.name;native.mkdir(exist_ok=False)
        socket=native/'pl.sock'
        assert len(str(socket))<100
        images=NATIVE/'buildroot-output-r01/images'
        modules=json.loads(args.modules_receipt.read_text())
        assert modules['status']=='MODULES_IMAGE_PREPARED'
        assert modules['baseline_receipt_sha256']==sha(args.linux_receipt)
        initramfs=Path(modules['image']);assert sha(initramfs)==modules['image_sha256']
        record['modules_receipt_sha256']=sha(args.modules_receipt)
        audio=bool(args.audio_adapter)
        if audio:
            assert args.audio_image_receipt and args.baseline_receipt
            baseline=json.loads(args.baseline_receipt.read_text())
            assert baseline['status']=='ARM_LINUX_BASELINE_PASS'
            custom=json.loads(args.audio_adapter.read_text());assert custom['status']=='ADAPTER_BUILD_PASS'
            executable=Path(custom['executable'])
            assert sha(executable)==custom['executable_sha256']
            prepared=json.loads(args.audio_image_receipt.read_text())
            assert prepared['status']=='AUDIO_IMAGE_PREPARED'
            assert prepared['baseline_receipt_sha256']==sha(args.linux_receipt)
            assert prepared['modules_receipt_sha256']==sha(args.modules_receipt)
            initramfs=Path(prepared['image']);assert sha(initramfs)==prepared['image_sha256']
            record.update(actual_audio_rtl=True,adapter_receipt_sha256=sha(args.audio_adapter),
                          image_receipt_sha256=sha(args.audio_image_receipt),baseline_receipt_sha256=sha(args.baseline_receipt))
        qcommand=[str(qemu),'-M','arm-generic-fdt-7series','-m','512M',
            '-kernel',str(images/'zImage'),'-dtb',str(images/'voice-view-cosim.dtb'),
            '-initrd',str(initramfs),
            '-append','console=ttyPS0,115200 earlycon root=/dev/ram rw loglevel=6',
            '-serial','null','-serial','stdio','-monitor','none','-display','none',
            '-net','none','-no-reboot','-icount','0,sleep=off','-rtc','clock=vm',
            '-sync-quantum','1000000',
            '-chardev','socket,id=pl-rp,path='+str(socket)+',server=on,wait=on']
        scommand=[str(executable),'unix:'+str(socket),'1000000']
        if audio:
            rtl=args.output.resolve()/'rtl'
            assert str(rtl).startswith('/mnt/e/projects/fpga/voice-view-game/build/volume-response/')
            scommand.append('E:'+str(rtl)[len('/mnt/e'):])
        def launch(name,command,logname):
            # DrvFs can report ENODATA while a WSL writer holds a Windows file.
            # Keep live logs on native ext4, copy evidence after owned cleanup.
            log=(native/logname).open('w');logs.append(log)
            child=subprocess.Popen(command,cwd=native,stdin=subprocess.DEVNULL,
                                   stdout=log,stderr=subprocess.STDOUT)
            processes[name]=child
            record['processes'][name]=dict(pid=child.pid,command=command)
        launch('qemu',qcommand,'serial.log')
        deadline=time.monotonic()+15
        while not socket.exists():
            assert processes['qemu'].poll() is None,'QEMU exited before creating local socket'
            assert time.monotonic()<deadline,'QEMU socket timeout'
            time.sleep(.1)
        launch('systemc',scommand,'systemc.log')
        print('Local QEMU/SystemC started; native serial.log records guest progress',flush=True)
        deadline=time.monotonic()+(900 if audio else 300)
        while time.monotonic()<deadline:
            serial=(native/'serial.log').read_text(errors='replace')
            marker='VVG_AUDIO_RESULT' if audio else 'VVG_GUEST_SMOKE_PASS'
            matches=re.findall(marker+r' (\{[^\r\n]+\})',serial)
            if matches:
                record['guest_result']=json.loads(matches[-1])
                assert record['guest_result']['board_access'] is False
                if audio:
                    assert record['guest_result']['status']=='ARM_WORKER_OBSERVED'
                    record['status']='ARM_WORKER_OBSERVED_PENDING_TRACE_CHECKS'
                else:
                    assert record['guest_result']['audio_rtl_connected'] is False
                    record['status']='ARM_LINUX_BASELINE_PASS'
                break
            assert 'Kernel panic' not in serial,'guest kernel panic; see serial.log'
            assert 'Traceback (most recent call last)' not in serial,'guest Python failed; see serial.log'
            for name,child in processes.items():
                assert child.poll() is None,name+' exited before smoke marker'
            time.sleep(.25)
        else:raise TimeoutError('bounded guest run did not complete')
    except BaseException as error:
        record.update(status='FAIL',error=repr(error));raise
    finally:
        # Only terminate children created by this invocation. Never scan or kill
        # other QEMU/SystemC processes, and never use hardware recovery commands.
        for name,child in processes.items():
            if child.poll() is None:child.terminate()
            try:child.wait(timeout=5)
            except subprocess.TimeoutExpired:
                child.kill();child.wait(timeout=5)
                record['processes'][name]['forced_local_cleanup']=True
            record['processes'][name]['exitcode']=child.returncode
        for log in logs:log.close()
        if 'native' in locals():
            for name in ('serial.log','systemc.log'):
                if (native/name).exists():shutil.copyfile(native/name,args.output/name)
        if args.audio_adapter:
            rtl=args.output/'rtl/receipt.json'
            until=time.monotonic()+20
            while not rtl.exists() and time.monotonic()<until:time.sleep(.1)
            if rtl.exists():
                record['rtl_receipt_sha256']=sha(rtl)
                record['rtl_transport_status']=json.loads(rtl.read_text()).get('status')
            elif record['status']=='ARM_WORKER_OBSERVED_PENDING_TRACE_CHECKS':
                record.update(status='FAIL',error='XSI trace receipt missing after owned-process cleanup')
        record['wall_seconds']=time.monotonic()-started
        record['script_sha256']=sha(__file__)
        (args.output/'receipt.json').write_text(json.dumps(record,indent=2))
    print(record['status'],flush=True)


if __name__=='__main__':main()
