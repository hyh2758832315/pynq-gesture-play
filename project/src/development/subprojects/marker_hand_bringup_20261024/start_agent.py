# Run via remote.py; outputs immutable startup receipts; next inspect_agent.py.
import json,pathlib
assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()=='15a410e0-d375-45ef-8d01-7b9a02e21a8e'
import fcntl,hashlib,os,subprocess,sys
root=pathlib.Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
log=root/'var/marker-hand-20261024-a01'

for process in pathlib.Path('/proc').glob('[0-9]*/maps'):
    try:
        maps=process.read_text()
        assert '/dev/mem' not in maps and '/dev/uio' not in maps,str(process)
    except (FileNotFoundError,ProcessLookupError):pass
journal=pathlib.Path('/var/lock/voice-view-c6i-volume-owner.json')
assert not journal.exists() or json.loads(journal.read_text())['state']=='CLEAN'
for name in ('/var/lock/voice-view-c6i.lock','/run/lock/voice_pcm_audio.lock'):
    if pathlib.Path(name).exists():
        with pathlib.Path(name).open('rb') as stream:fcntl.flock(stream.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB)
manifest=json.loads((root/'deployment_manifest.json').read_text())
assert manifest['build_id']=='0xC0060E00'
for name,digest in manifest['sha256'].items():assert hashlib.sha256((root/name).read_bytes()).hexdigest().upper()==digest
base=json.loads((log/'base-stop.json').read_text())
assert base['boot_id']==pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert log.is_dir() and not (log/'load.attempt').exists()
with (log/'load.attempt').open('x') as output:
    json.dump(dict(boot_id=base['boot_id'],build_id='0xC0060E00'),output);output.flush();os.fsync(output.fileno())
with (log/'agent_entry.py').open('x') as wrapper: wrapper.write("\"\"\"Diagnostic wrapper for the unmodified candidate entry.\nRun on board via start_agent.py. Output startup-trace.jsonl; next inspect ready.\nOnly adds flushed startup timing; does not bypass loading, checks or cleanup.\n\"\"\"\nimport json\nimport os\nfrom pathlib import Path\nimport runpy\nimport sys\nimport time\n\nROOT=Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')\nLOG=ROOT/'var/marker-hand-20261024-a01'\nseen=set()\nfiles={'cli.py','c6i_backend.py','c6i_shell.py','c6i_video.py','vision_backend.py','vision_pl_fusion.py','pl_volume_factory.py','pl_volume_worker.py','transport.py'}\nnames={'open','start','create_worker','_load_shared_vision_overlay','_create_shared_vision_backend','_restore_shared_vision_interrupts'}\ndef trace(frame,event,arg):\n    name=frame.f_code.co_name\n    path=Path(frame.f_code.co_filename)\n    key=(str(path),name,event)\n    if path.name not in files or name not in names or event not in ('call','return') or key in seen:\n        return\n    if not path.is_relative_to(ROOT):\n        return\n    seen.add(key)\n    entry=dict(file=str(path.relative_to(ROOT)),function=name,event=event,pid=os.getpid(),monotonic_ns=time.monotonic_ns())\n    with (LOG/'startup-trace.jsonl').open('a') as stream:\n        stream.write(json.dumps(entry)+'\\n');stream.flush();os.fsync(stream.fileno())\n    if path.name=='transport.py' and name=='start' and event=='return':\n        sys.setprofile(None)\nsys.setprofile(trace)\nsys.argv=[str(ROOT/'start_board_test.py'),'--game-controls','--physical-audio-confirmed','--osd-test-stimuli']\nrunpy.run_path(str(ROOT/'start_board_test.py'),run_name='__main__')\n")
with (log/'stdout.log').open('xb') as out,(log/'stderr.log').open('xb') as err:
    proc=subprocess.Popen([sys.executable,'-u','-B','-c',"import json,os,pathlib,subprocess,sys\nroot=pathlib.Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')\nlog=root/'var/marker-hand-20261024-a01'\n\ncommand=[sys.executable,'-u','-B',str(log/'agent_entry.py')]\ndiagnostics=log/'volume-diagnostic'\ndiagnostics.mkdir()\nos.environ['VVG_C0C_DIAGNOSTIC_DIR']=str(diagnostics)\nworker=subprocess.Popen(command,cwd=root,stdin=subprocess.DEVNULL)\nentry=dict(pid=worker.pid,start_ticks=pathlib.Path('/proc/'+str(worker.pid)+'/stat').read_text().rsplit(')',1)[1].split()[19],\n           command=command,boot_id=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip(),supervisor_pid=os.getpid())\nwith (log/'service-start.json').open('x') as output:\n    json.dump(entry,output);output.flush();os.fsync(output.fileno())\ncode=worker.wait()\nwith (log/'service-exit.json').open('x') as output:\n    json.dump(dict(returncode=code,pid=worker.pid,boot_id=entry['boot_id']),output);output.flush();os.fsync(output.fileno())\nsys.exit(code)\n"],cwd=root,stdin=subprocess.DEVNULL,stdout=out,stderr=err,start_new_session=True)
print(json.dumps(dict(phase='C0E_AGENT_LAUNCH_REQUESTED',supervisor_pid=proc.pid,boot_id=base['boot_id'])),flush=True)
