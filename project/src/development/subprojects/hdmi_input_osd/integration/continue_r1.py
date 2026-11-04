import argparse
import ast
import json

import recover_board
from board_common import BOARD, inspect_source, load, remote


LOG='var/osd-live-vl01'
SAMPLER='''import json,os,pathlib,threading,time
expected=json.loads(__import__('sys').argv[1])
output=pathlib.Path(__import__('sys').argv[2])
duration=float(__import__('sys').argv[3])
interval=float(__import__('sys').argv[4])
process=pathlib.Path('/proc')/str(expected['pid'])
def task_names(process):
    names={}
    for task in process.joinpath('task').iterdir():
        try: names[task.name]=task.joinpath('comm').read_text().strip()
        except FileNotFoundError: pass
    return names
assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()==expected['boot_id']
assert process.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==expected['start_ticks']
samples=0;maximum_threads=0;maximum_size_kb=0;minimum_available_kb=None
started=time.monotonic();cpu_started=time.process_time();error=None
try:
    with (output/'samples.jsonl').open('x') as stream:
        while time.monotonic()-started<duration and not (output/'stop').exists():
            status=dict(line.split(':',1) for line in process.joinpath('status').read_text().splitlines())
            memory=dict(line.split(':',1) for line in pathlib.Path('/proc/meminfo').read_text().splitlines())
            stat=process.joinpath('stat').read_text().rsplit(')',1)[1].split()
            assert stat[19]==expected['start_ticks']
            sample=dict(monotonic=time.monotonic(),status=status,meminfo=memory,
                        utime=int(stat[11]),stime=int(stat[12]),loadavg=pathlib.Path('/proc/loadavg').read_text().strip())
            threads=int(status['Threads']);size=int(status['VmSize'].split()[0]);available=int(memory['MemAvailable'].split()[0])
            if threads!=maximum_threads:
                sample['tasks']=task_names(process)
            maximum_threads=max(maximum_threads,threads);maximum_size_kb=max(maximum_size_kb,size)
            minimum_available_kb=available if minimum_available_kb is None else min(minimum_available_kb,available)
            stream.write(json.dumps(sample)+'\\n');stream.flush();samples+=1
            threading.Event().wait(interval)
except BaseException as failure:
    error=repr(failure)
summary=dict(owner=expected,samples=samples,seconds=time.monotonic()-started,sampler_cpu_seconds=time.process_time()-cpu_started,
             max_threads=maximum_threads,max_vmsize_kb=maximum_size_kb,min_available_kb=minimum_available_kb,error=error)
with (output/'done.json').open('x') as stream: json.dump(summary,stream)
'''


def state(receipt):
    saved=load(receipt)
    if saved['returncode']!=0:
        raise RuntimeError('identity receipt failed')
    return json.loads(saved['stdout'])


def reboot_source(previous,previous_log='var/osd-live-r02'):
    expected=previous['service_start']
    if expected is None or expected['boot_id']!=previous['boot_id']:
        raise ValueError('bound owner required')
    source='import json,os,pathlib,subprocess\n'
    source+=f'expected={expected!r}\nroot=pathlib.Path({BOARD!r})\nprevious_log={previous_log!r}\nrecovery_name={LOG.rsplit("/",1)[1]!r}\n'
    source+='''assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()==expected['boot_id']
process=pathlib.Path('/proc')/str(expected['pid'])
assert process.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==expected['start_ticks']
assert process.joinpath('cmdline').read_bytes().split(bytes([0]))[:-1]==[value.encode() for value in expected['command']]
archive=root/'var'/('visual-latency-recovery-'+recovery_name)
archive.mkdir()
for name in ('stdout.log','stderr.log','service-start.json','service-exit.json'):
    original=root/previous_log/name
    if original.exists():
        with (archive/name).open('xb') as target:
            target.write(original.read_bytes());target.flush();os.fsync(target.fileno())
with (archive/'normal-reboot.attempt').open('x') as output:
    json.dump(dict(owner=expected,forced=False,operator_authorized=True),output)
    output.flush();os.fsync(output.fileno())
print(json.dumps(dict(phase='IDENTITY_BOUND_NORMAL_REBOOT',owner=expected)),flush=True)
result=subprocess.run(['systemctl','reboot'],capture_output=True,text=True,timeout=10)
print(json.dumps(dict(returncode=result.returncode,stdout=result.stdout,stderr=result.stderr)),flush=True)
assert result.returncode==0
'''
    ast.parse(source,feature_version=(3,10))
    return source


def boot_ready_source(old_boot):
    source=inspect_source(current=BOARD,log=LOG)
    source=source[:source.rfind('print(json.dumps(state),flush=True)')]
    source+=f"old_boot={old_boot!r}\n"
    source+='''properties=[dict(line.split('=',1) for line in entry['stdout'].splitlines()) for entry in state['services'].values()]
state['recovery_ready']=bool(state['boot_id']!=old_boot and
    all(values==dict(ActiveState='inactive',MainPID='0',Result='success') for values in properties) and
    not state['processes'] and not state['hardware_mappers'] and
    all(not entry['exists'] or entry['available'] and entry['bytes']==0 for entry in state['locks'].values()) and
    all(':'+str(port) not in state['ports'] for port in (8765,8081,8771)) and
    (state['volume_journal'] is None or state['volume_journal']['state']=='CLEAN'))
print(json.dumps(state),flush=True)
'''
    ast.parse(source,feature_version=(3,10))
    return source


def monitor_source(action,previous,seconds,resource_id='vl01',interval=.25):
    expected=previous['service_start']
    if expected is None or previous['service_exit'] is not None:
        raise ValueError('running bound owner required')
    source=f'import json,pathlib,subprocess\nexpected={expected!r}\nroot=pathlib.Path({BOARD!r})/{LOG!r}\nresource_id={resource_id!r}\n'
    source+='''assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()==expected['boot_id']
process=pathlib.Path('/proc')/str(expected['pid'])
assert process.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==expected['start_ticks']
output=root/('resources-'+resource_id)
'''
    if action=='monitor-start':
        source+=f'sampler={SAMPLER!r}\nseconds={seconds!r}\ninterval={interval!r}\n'
        source+='''output.mkdir()
cgroups={}
for line in process.joinpath('cgroup').read_text().splitlines():
    hierarchy,controllers,name=line.split(':',2)
    current=pathlib.Path('/sys/fs/cgroup')/name.lstrip('/')
    for parent in (current,*current.parents):
        if str(parent).startswith('/sys/fs/cgroup'):
            for key in ('pids.max','pids.current','memory.max','memory.current'):
                entry=parent/key
                if entry.is_file(): cgroups[str(entry)]=entry.read_text().strip()
with (output/'cgroups.json').open('x') as stream: json.dump(cgroups,stream)
with (output/'monitor.stdout').open('xb') as stdout,(output/'monitor.stderr').open('xb') as stderr:
    monitor=subprocess.Popen(['/usr/local/share/pynq-venv/bin/python','-B','-c',sampler,json.dumps(expected),str(output),str(seconds),str(interval)],stdin=subprocess.DEVNULL,stdout=stdout,stderr=stderr,start_new_session=True)
print(json.dumps(dict(sampler_pid=monitor.pid,path=str(output),owner=expected,cgroups=cgroups)),flush=True)
'''
    elif action=='monitor-stop':
        source+="with (output/'stop').open('x') as stream: stream.write('bounded experiment complete\\n')\nprint(json.dumps(dict(stop_requested=True)),flush=True)\n"
    else:
        source+='''summary=json.loads((output/'done.json').read_text())
assert summary['owner']==expected
print(json.dumps(dict(summary=summary,cgroups=json.loads((output/'cgroups.json').read_text()),samples=[json.loads(line) for line in (output/'samples.jsonl').read_text().splitlines()],stderr=(output/'monitor.stderr').read_text())),flush=True)
assert summary['error'] is None
'''
    ast.parse(source,feature_version=(3,10))
    return source


def main():
    global LOG
    parser=argparse.ArgumentParser()
    parser.add_argument('action',choices=('check','inspect','reboot','postboot','base','start','ready','monitor-start','monitor-stop','monitor-fetch'))
    parser.add_argument('--label',required=True)
    parser.add_argument('--state',default='vl01-r1-readonly')
    parser.add_argument('--seconds',type=float,default=600.)
    parser.add_argument('--run-id',default='vl01')
    parser.add_argument('--previous-log',default='var/osd-live-r02')
    parser.add_argument('--base-state',default='vl07-newboot-base-stop')
    parser.add_argument('--resource-id',default='vl01')
    parser.add_argument('--interval',type=float,default=.25)
    args=parser.parse_args()
    if not args.label.replace('-','').isalnum():
        parser.error('unsafe label')
    if not args.run_id.replace('-','').isalnum() or not args.previous_log.startswith('var/osd-live-') or '/' in args.previous_log[4:]:
        parser.error('unsafe run identity or previous log')
    if not args.resource_id.replace('-','').isalnum() or not .1<=args.interval<=10.:
        parser.error('unsafe resource identity or interval')
    LOG='var/osd-live-'+args.run_id
    recover_board.LOG=LOG
    if args.action=='check':
        for name in ('f130-game3-base-normal-stop.json','f131-game3-agent-start.json'):
            ast.parse(recover_board.template(name,'00000000-0000-0000-0000-000000000000'),feature_version=(3,10))
        reboot_source(state(args.state),args.previous_log)
        boot_ready_source(state(args.state)['boot_id'])
        ast.parse(SAMPLER,feature_version=(3,10))
        for action in ('monitor-start','monitor-stop','monitor-fetch'):
            monitor_source(action,state(args.state),600.)
        print('R1_CONTINUATION_AST_IDENTITY_CHECK_PASS')
        return
    if args.action=='inspect':
        source=inspect_source(current=BOARD,log=LOG)
    elif args.action=='reboot':
        source=reboot_source(state(args.state),args.previous_log)
    elif args.action=='postboot':
        source=boot_ready_source(state(args.state)['boot_id'])
    elif args.action.startswith('monitor-'):
        if not 0<args.seconds<=3600:
            parser.error('sampler seconds must be in (0,3600]')
        source=monitor_source(args.action,state(args.state),args.seconds,args.resource_id,args.interval)
    elif args.action in ('base','start'):
        previous=state(args.state)
        if not previous.get('recovery_ready'):
            raise RuntimeError('fresh ready boot receipt required')
        boot=previous['boot_id']
        if args.action=='start':
            stopped=load(args.base_state)
            if stopped['returncode']!=0 or repr(boot) not in stopped['remote_code']:
                raise RuntimeError('matching Base stop receipt required')
        name='f130-game3-base-normal-stop.json' if args.action=='base' else 'f131-game3-agent-start.json'
        source=recover_board.template(name,boot)
        if args.action=='start':
            prefix=f"import fcntl,json,pathlib\nassert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()=={boot!r}\n"
            prefix+='''journal=pathlib.Path('/var/lock/voice-view-c6i-volume-owner.json')
assert not journal.exists() or json.loads(journal.read_text())['state']=='CLEAN'
for name in ('/var/lock/voice-view-c6i.lock','/run/lock/voice_pcm_audio.lock'):
    with pathlib.Path(name).open('rb') as stream:
        fcntl.flock(stream.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB)
        assert not stream.read()
'''
            source=prefix+source
    else:
        source=inspect_source(current=BOARD,log=LOG)
    receipt=remote(args.label,source,timeout=90,hardware_access=args.action in ('base','start'))
    if args.action=='monitor-fetch':
        print(json.dumps(json.loads(receipt['stdout'])['summary'],indent=2))
    if args.action in ('inspect','postboot','ready'):
        current=json.loads(receipt['stdout'])
        print(json.dumps(dict(boot_id=current['boot_id'],recovery_ready=current.get('recovery_ready'),
                              service_start=current['service_start'],service_exit=current['service_exit']),indent=2))


if __name__=='__main__':
    main()