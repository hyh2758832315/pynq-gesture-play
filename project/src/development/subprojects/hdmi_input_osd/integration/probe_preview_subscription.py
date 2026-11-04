"""Read-only preview traffic/codec probe, without subscribing to JPEG.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/probe_preview_subscription.py
Output: evidence/r20-b18-preview-subscriptions.json (exclusive).
Next: compare payload counters and codec CPU; open ports alone prove no subscription.
Never stops Studio, vision, HTTP or the encoder and never maps hardware.
"""
import json
from board_common import remote
from deploy_latency_admission import BOARD

CODE = f"import pathlib,json,os,time,subprocess,http.client\nroot=pathlib.Path({BOARD!r})\n"
CODE += r'''
boot=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()
entry=json.loads((root/'var/pl-admission-r20-b01/service-start.json').read_text())
assert entry['boot_id']==boot
agent=pathlib.Path('/proc')/str(entry['pid'])
assert agent.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==entry['start_ticks']
def result():
    client=http.client.HTTPConnection('192.168.2.99',8081,timeout=5)
    try:
        client.request('GET','/result.json');response=client.getresponse();assert response.status==200
        return json.loads(response.read(65537))
    finally:client.close()
initial=result()
codec=pathlib.Path('/proc')/str(initial['preview_health']['codec_pid'])
def codec_stat():
    fields=codec.joinpath('stat').read_text().rsplit(')',1)[1].split()
    return dict(start_ticks=fields[19],cpu_ticks=int(fields[11])+int(fields[12]))
samples=[]
started=time.monotonic()
for index in range(3):
    if index:time.sleep(4)
    raw=subprocess.run(['ss','-tinp'],capture_output=True,text=True,check=True).stdout
    lines=raw.splitlines();records=[]
    for i,line in enumerate(lines):
        if '192.168.2.99:8081' in line:
            records.append(dict(connection=line,tcp_info=lines[i+1] if i+1<len(lines) else ''))
    samples.append(dict(elapsed_s=time.monotonic()-started,codec=codec_stat(),http_connections=records))
final=result()
a,b=samples[0],samples[-1]
assert a['codec']['start_ticks']==b['codec']['start_ticks']
cpu=(b['codec']['cpu_ticks']-a['codec']['cpu_ticks'])/os.sysconf('SC_CLK_TCK')/(b['elapsed_s']-a['elapsed_s'])*100
print(json.dumps(dict(boot_id=boot,agent=entry,hardware_access=False,jpeg_subscription_created=False,
    result_before=initial,result_after=final,samples=samples,codec_one_core_percent=cpu)),flush=True)
'''

if __name__ == '__main__':
    receipt=remote('r20-b18-preview-subscriptions',CODE,timeout=30)
    value=json.loads(receipt['stdout'])
    print(json.dumps(dict(codec_one_core_percent=value['codec_one_core_percent'],
        frame_before=value['result_before']['frame'],frame_after=value['result_after']['frame'],
        samples=value['samples']),indent=2))
