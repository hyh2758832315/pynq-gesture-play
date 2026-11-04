"""Unattended board test adapter: real serial-owner code, memory device only.

Run only via r43_unattended_board.py; first argument is the verified child entry.
Outputs: original owner receipts plus sdk-memory-evidence.json. Physical serial
open is forbidden. Next: inspect OFF, zero playback reads and ordered stages.
"""
import importlib.util
import json
from pathlib import Path
import sys

entry=Path(sys.argv.pop(1)).resolve(strict=True)
root=Path(sys.argv[sys.argv.index('--hand-root')+1]).resolve(strict=True)
out=Path(sys.argv[sys.argv.index('--output-dir')+1])
sys.path[:0]=[str(root/'src'),str(root/'tests')]
import serial
def forbidden(*args,**kwargs):
    raise AssertionError('UNATTENDED_REAL_SERIAL_FORBIDDEN')
serial.Serial.open=forbidden
from memory_hand import MemoryHand
import pynq_usb_hand.orca_backend as backend
devices=[]
def memory_factory(model,*args,**kwargs):
    device=MemoryHand(model)
    devices.append(device)
    return device
backend.OrcaBackend=memory_factory
spec=importlib.util.spec_from_file_location('checked_serial_child',entry)
child=importlib.util.module_from_spec(spec)
spec.loader.exec_module(child)
child.verify_serial_device=lambda args: None
original_write=child.write_new
def labelled_write(path,value):
    original_write(path,dict(value,hardware_mode=False,test_backend='sdk-memory',mechanical_verified=False))
child.write_new=labelled_write
result=1
try:
    result=child.main()
finally:
    evidence=dict(schema='r43-sdk-memory-board-v1',physical_serial_open_forbidden=True,
                  hardware_mode=False,devices=len(devices),result=result,
                  playback_reads=sum(p[4]==2 for d in devices for phase,p in d.packets if phase=='playback'),
                  packet_count=sum(len(d.packets) for d in devices),
                  all_off=all(not any(d.torque.values()) for d in devices),
                  all_closed=all(d.closed for d in devices))
    (out/'sdk-memory-evidence.json').write_text(json.dumps(evidence,indent=2),encoding='utf-8')
raise SystemExit(result)
