"""Windows XSI worker for local SystemC stdin/stdout transport; never uses a board.

Command (normally launched by the native SystemC adapter):
  .venv/Scripts/python subprojects/volume_response_offline/cosim/xsi_rpc.py --output build/volume-response/cosim-rpc-r01 --vivado D:/Xilinx/Vivado/2026.1/Vivado
Input lines: id time_ns write_boolean address value. Output: @VVG id value delay_ns.
First @VVG READY follows compilation. EOF closes XSI and saves receipt/traces.
Outputs are transport evidence only; no PASS until guest and independent trace
checks complete. Next: run guest_audio.py through the SystemC adapter.
"""
import argparse
import json
import os
from pathlib import Path
import sys
import time

from run_cosim import Backend,prepare,stimulus,digest
from xsi_bridge import Xsi

BASE=0x41000000


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--vivado',type=Path,required=True)
    args=parser.parse_args();args.output=args.output.resolve();args.vivado=args.vivado.resolve()
    args.output.mkdir(parents=True,exist_ok=False)
    receipt=dict(status='RUNNING',board_access=False,transport_only=True,
                 simulation_origin='first emulated MMIO minus 3000 ns reset warmup',
                 codec_model='register profile and ideal PLL only; no electrical I2C/ADC')
    x=backend=None;started=time.monotonic();time_base=None;mailbox={};count=0
    transaction_log=(args.output/'remote-mmio.jsonl').open('w')
    try:
        receipt['source_hashes'],receipt['compile_steps']=prepare(args.output,args.vivado)
        values,receipt['stimulus']=stimulus(args.output,'nominal',repetitions=2)
        os.chdir(args.output)
        x=Xsi(args.vivado,args.output,'audio_hdmi')
        for name,value in dict(resetn=0,codec_locked=1,codec_active=0,request=0,address=0,
            write_data=0,write_request=0,target_osd=0,sample_length=len(values),
            source_mode=0,scene_mode=0).items():x.put(name,value)
        x.run_ns(2000);x.put('resetn',1);x.run_ns(1000)
        backend=Backend(x,args.output)
        print('@VVG READY',flush=True)
        for line in sys.stdin:
            identity,now,write,address,value=map(int,line.split())
            assert identity==count+1 and write in (0,1)
            assert BASE<=address<BASE+0x3000 and address%4==0
            if time_base is None:time_base=now-x.monotonic_ns()
            target_time=now-time_base
            assert target_time>=x.monotonic_ns(),('time reversal',target_time,x.monotonic_ns())
            assert target_time<=3_000_000_000,'bounded 3 s RTL simulation exceeded'
            x.run_ns(target_time-x.monotonic_ns())
            aperture,offset=divmod(address-BASE,0x1000)
            if aperture<2:
                result=backend.transfer(aperture,offset,value if write else None)
            else:
                # A simulation-only mailbox carries original codec transactions.
                # It does not claim to emulate the Zynq I2C controller.
                if write:
                    mailbox[offset]=value;result=0
                    if offset==16:
                        register,length=mailbox[0],mailbox[4]
                        assert 1<=length<=8
                        if value==1:
                            response=backend.codec_read(register,length).ljust(8,b'\0')
                            mailbox[24]=int.from_bytes(response[:4],'little')
                            mailbox[28]=int.from_bytes(response[4:],'little')
                        elif value==2:
                            payload=mailbox.get(8,0).to_bytes(4,'little')+mailbox.get(12,0).to_bytes(4,'little')
                            backend.codec_write(register,payload[:length])
                        else:raise ValueError('invalid codec transaction')
                else:result=mailbox.get(offset,0)
                x.run_ns(100)
            count=identity
            delay=x.monotonic_ns()-target_time
            transaction_log.write(json.dumps(dict(id=identity,systemc_ns=now,rtl_ns=target_time,
                address=address,write=value if write else None,result=result,delay_ns=delay))+'\n')
            print(f'@VVG {identity} {result} {delay}',flush=True)
        receipt.update(status='TRANSPORT_CLOSED',transactions=count,systemc_time_origin_ns=time_base,
            simulation_ns=x.monotonic_ns(),pixel_errors=x.get('pixel_errors'),serial_errors=x.get('serial_errors'),
            decoded_count=x.get('decoded_count'),background_pixels_checked=x.get('background_pixels_checked'),
            sync_cycles_checked=x.get('sync_cycles_checked'))
    except BaseException as error:
        receipt.update(status='FAIL',error=repr(error));raise
    finally:
        if x:x.close()
        if backend:backend.close()
        transaction_log.close()
        receipt.update(wall_seconds=time.monotonic()-started,script_sha256=digest(__file__))
        (args.output/'receipt.json').write_text(json.dumps(receipt,indent=2))


if __name__=='__main__':main()
