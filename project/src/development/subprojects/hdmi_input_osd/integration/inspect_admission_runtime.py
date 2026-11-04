"""Read only R20 process costs and already-published results; no MMIO.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/inspect_admission_runtime.py
Output: exclusive evidence/r20-b14-runtime-cost.json. Next: offline cost attribution.
"""
from board_common import remote
from deploy_latency_admission import BOARD
import argparse


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--label',default='r20-b14-runtime-cost',choices=('r20-b14-runtime-cost','r20-b17-final-runtime'))
    args = parser.parse_args()
    code = f"import json,pathlib,os,time,http.client,subprocess\nroot=pathlib.Path({BOARD!r})\n"
    code += r'''
assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()=='f56e80d1-0222-4c57-8308-162e279eb32f'
entry=json.loads((root/'var/pl-admission-r20-b01/service-start.json').read_text())
agent=pathlib.Path('/proc')/str(entry['pid'])
assert agent.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==entry['start_ticks']
assert str(root/'start_board_test.py') in agent.joinpath('cmdline').read_bytes().replace(b'\x00',b' ').decode()
def costs():
    rows={}
    for path in pathlib.Path('/proc').glob('[0-9]*'):
        try:
            stat=path.joinpath('stat').read_text().rsplit(')',1)[1].split()
            if int(path.name)!=entry['pid'] and int(stat[1])!=entry['pid']: continue
            status=dict(line.split(':',1) for line in path.joinpath('status').read_text().splitlines() if ':' in line)
            rows[path.name]=dict(start_ticks=stat[19],cpu_ticks=int(stat[11])+int(stat[12]),
                threads=stat[17],rss=status.get('VmRSS'),command=path.joinpath('cmdline').read_bytes().replace(b'\x00',b' ').decode(errors='replace'))
        except (FileNotFoundError,ProcessLookupError): pass
    return rows
a=costs();started=time.monotonic();time.sleep(2);b=costs();seconds=time.monotonic()-started
for pid,row in b.items():
    if pid in a and a[pid]['start_ticks']==row['start_ticks']:
        row['one_core_percent']=(row['cpu_ticks']-a[pid]['cpu_ticks'])/os.sysconf('SC_CLK_TCK')/seconds*100
client=http.client.HTTPConnection('192.168.2.99',8081,timeout=5)
try:
    client.request('GET','/result.json');response=client.getresponse();assert response.status==200
    result=json.loads(response.read(65537))
finally:client.close()
log=root/'var/pl-admission-r20-b01'
connections=[]
for index in range(3):
    connections.append(subprocess.run(['ss','-ntp'],capture_output=True,text=True,check=True).stdout)
    time.sleep(.5)
print(json.dumps(dict(hardware_access=False,seconds=seconds,processes=b,result=result,connections=connections,
    vision_directories=[str(p.relative_to(root)) for p in (root/'var/vision').glob('*')],
    stdout_tail=(log/'stdout.log').read_text(errors='replace')[-6000:],
    stderr_tail=(log/'stderr.log').read_text(errors='replace')[-6000:],
    service_exit=json.loads((log/'service-exit.json').read_text()) if (log/'service-exit.json').exists() else None)),flush=True)
'''
    remote(args.label, code, timeout=30)
