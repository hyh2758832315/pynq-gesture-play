"""Measure exact packet decoding and concurrent recognition without hardware.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/measure_latency_capture_cpu.py --label c0e-q09-cpu-decode
Output: immutable receipt with real ARM timings and current result.json.
Next: distinguish CPU budget from cache/MMIO and hardware handoff effects.
"""
import argparse
from board_common import remote


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--label', required=True)
    args = parser.parse_args()
    source = '''import hashlib,json,pathlib,sys,time,threading,struct,zlib,http.client
root=pathlib.Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r19-latest-20261023')
assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()=='2817d7c9-de8a-4015-911d-99e2b53d685f'
sys.path.insert(0,str(root/'board/pynq_z2/scripts'))
import vision_async_runtime as runtime
from board.pynq_z2.dual_mask_packet import decode_dual_mask,MAGIC,VERSION_LENGTH,PAIR_FORMAT
import numpy as np
client=http.client.HTTPConnection('192.168.2.99',8081,timeout=3)
client.request('GET','/result.json');response=client.getresponse()
assert response.status==200
print(json.dumps(dict(current_result=json.loads(response.read(65536)))),flush=True)
client.close()
thresholds=(0,20,20,255,70,255);b=bytes(thresholds)
raw=np.zeros((360,640),np.uint8);raw[20:340:20,20:620:20]=255
filtered=runtime.cv2.GaussianBlur(runtime.cv2.dilate(raw,None,iterations=4),(5,5),0)
pairs=np.stack((raw,filtered),axis=2).tobytes()
trailer=struct.pack('<15I',MAGIC,VERSION_LENGTH,1,1,7,(360<<16)|640,230400,460800,0,
    int.from_bytes(b[:4],'little'),int.from_bytes(b[4:],'little'),PAIR_FORMAT,0,0,0)
packet=pairs+trailer;packet+=struct.pack('<I',zlib.crc32(packet))
def decode():return decode_dual_mask(packet,width=640,height=360,frame_id=1,config_id=1,epoch=7,thresholds=thresholds)
rows=[]
def measured(label,operation,count):
    for index in range(count):
        start=time.perf_counter_ns();cpu=time.thread_time_ns()
        operation()
        rows.append(dict(label=label,index=index,wall_ms=(time.perf_counter_ns()-start)/1e6,cpu_ms=(time.thread_time_ns()-cpu)/1e6))
measured('decode',decode,30)
measured('copy_packet',lambda:bytes(memoryview(packet)),30)
stop=threading.Event();recognition=[]
def recognize():
    recognizer=runtime.DualMaskFullFrameTracker(dilate_iterations=4)
    while not stop.is_set():
        start=time.perf_counter_ns();cpu=time.thread_time_ns()
        runtime.process_dual_masks((raw,filtered),recognizer,180,False)
        recognition.append(dict(wall_ms=(time.perf_counter_ns()-start)/1e6,cpu_ms=(time.thread_time_ns()-cpu)/1e6))
thread=threading.Thread(target=recognize)
thread.start()
try:measured('decode_concurrent_recognition',decode,40)
finally:stop.set();thread.join(5)
assert not thread.is_alive()
maps=pathlib.Path('/proc/self/maps').read_text()
assert '/dev/mem' not in maps and '/dev/uio' not in maps
print(json.dumps(dict(status='ARM_CAPTURE_CPU_COST_MEASURED',hardware_access=False,
    cv_version=runtime.cv2.__version__,cv_threads=runtime.cv2.getNumThreads(),rows=rows,recognition=recognition)),flush=True)
'''
    remote(args.label, source, timeout=60)


if __name__ == '__main__':
    main()
