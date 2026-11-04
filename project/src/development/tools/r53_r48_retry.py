"""Continue video acceptance after the existing native Studio startup check.
Run: .venv/Scripts/python.exe -B -u tools/r53_r48_retry.py
Output: build/studio-r53-r48-final/closure.json and video/native receipts.
Next: retain the normal installed service; report any failed evidence unchanged.
"""
from pathlib import Path
import json
import subprocess
import sys
import time

root=Path(__file__).resolve().parents[1]
out=root/'build/studio-r53-r48-final'
record=dict(result='RUNNING',retry_reason='read-only receipt permissions fixed',steps=[])
def save():
    (out/'closure.json').write_text(json.dumps(record,indent=2),encoding='utf-8')
try:
    save()
    startup=out/'retry-start/after-restart.json'
    deadline=time.monotonic()+700
    while not startup.exists():
        if time.monotonic()>deadline:
            raise TimeoutError('Existing native Studio startup check did not finish')
        time.sleep(2)
    assert json.loads(startup.read_text(encoding='utf-8'))['result']=='PASS'
    record['startup_receipt']=str(startup);save()
    final=out/'final-studio';final.mkdir(exist_ok=True)
    for args in [
        ['tools/r53_video_accept.py'],
        ['tools/studio_r48_connect_check.py','--tag','after-restart',
         '--candidate','build/ps-ui-r53-video-hand-pause-candidate-r48',
         '--output',str(final),'--allow-hand-wait'],
    ]:
        print('START '+args[0],flush=True)
        subprocess.run([sys.executable,'-B','-u',*args],cwd=root,check=True)
        record['steps'].append(args);save()
    record['result']='PASS'
except BaseException as error:
    record.update(result='FAIL',error=str(error));raise
finally:
    save()
