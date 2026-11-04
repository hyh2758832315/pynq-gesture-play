"""Publish the verified v3 snapshot via an isolated Git clone and GitHub Release.

Run: .venv/Scripts/python.exe -B tools/publish_v3_release.py --repo build/v3-release-repo
Output: build/voice-view-v3-github-release.json; v3.0 tag, full ZIP and checksum.
Next: read back remote commit, release assets and digests. Never print/save tokens.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import urllib.error
import urllib.parse
import urllib.request

p=argparse.ArgumentParser(description=__doc__);p.add_argument('--repo',type=Path,required=True)
a=p.parse_args();repo=a.repo.resolve();parent=repo.parent
def git(*args):return subprocess.check_output(['git',*args],cwd=repo,text=True).strip()
assert git('remote','get-url','origin')=='https://github.com/HH-bit-dev/pynq-audiovisual-diagnostics.git'
commit=git('rev-parse','HEAD')
assert git('ls-remote','origin','refs/heads/main').split()[0]==commit,'Push/readback must precede Release publication'
seal=json.loads((parent/'voice-view-v3-release-receipt.json').read_text(encoding='utf-8'))
accept=json.loads((repo/'releases/v3.0/verification/acceptance-summary.json').read_text(encoding='utf-8'))
assert accept['result']=='PASS' and accept['manifest_sha256']=='5efd63005162b7871fcce7c658b4a28b16f6002a567000f7513112c15d96ed8b'
credentials=subprocess.run(['git','credential','fill'],cwd=repo,
    input='protocol=https\nhost=github.com\n\n',capture_output=True,text=True,check=True)
token=dict(line.split('=',1) for line in credentials.stdout.splitlines() if '=' in line)['password']
api='https://api.github.com/repos/HH-bit-dev/pynq-audiovisual-diagnostics'
def request(url,method='GET',payload=None,data=None,content_type='application/json'):
    parsed=urllib.parse.urlparse(url)
    assert parsed.scheme=='https' and parsed.hostname in ('api.github.com','uploads.github.com')
    headers={'Authorization':'Bearer '+token,'Accept':'application/vnd.github+json',
      'User-Agent':'voice-view-v3-publisher','X-GitHub-Api-Version':'2022-11-28'}
    if payload is not None:data=json.dumps(payload,ensure_ascii=False).encode('utf-8')
    if data is not None:headers['Content-Type']=content_type
    try:
        with urllib.request.urlopen(urllib.request.Request(url,method=method,headers=headers,data=data),timeout=600) as response:
            return json.load(response)
    except urllib.error.HTTPError as error:raise RuntimeError(f'GitHub {method} {parsed.path}: HTTP {error.code}') from None
assert request(api+'/commits/v3.0')['sha']==commit
body=(repo/'releases/v3.0/RELEASE_NOTES.md').read_text(encoding='utf-8')

existing=[r for r in request(api+'/releases?per_page=100') if r['tag_name']=='v3.0']
if existing:
    release=existing[0];assert release['draft'],'Refuse to change an already published release'
else:release=request(api+'/releases','POST',payload=dict(tag_name='v3.0',target_commitish=commit,
    name='完整版 v3.0 · Studio–PYNQ',body=body,draft=True,prerelease=False))
assets=[]
for name,kind in (('voice-view-full-v3.0.zip','application/zip'),('voice-view-full-v3.0.sha256','text/plain')):
    data=(parent/name).read_bytes();digest=hashlib.sha256(data).hexdigest()
    if name.endswith('.zip'):assert digest==seal['sha256']
    known=[v for v in request(api+f'/releases/{release["id"]}/assets') if v['name']==name]
    asset=known[0] if known else request(release['upload_url'].split('{')[0]+'?name='+urllib.parse.quote(name),
                                       'POST',data=data,content_type=kind)
    assert asset['state']=='uploaded' and asset['size']==len(data)
    assert asset.get('digest')=='sha256:'+digest
    assets.append(dict(name=name,size=len(data),sha256=digest,url=asset['browser_download_url'],remote_digest=asset['digest']))
    print('Verified uploaded asset: '+name,flush=True)
release=request(api+f'/releases/{release["id"]}','PATCH',payload=dict(draft=False,make_latest='true',body=body))
assert not release['draft'] and not release['prerelease']
result=dict(result='PASS',tag='v3.0',commit=commit,url=release['html_url'],assets=assets,
            published_at=release['published_at'])
(parent/'voice-view-v3-github-release.json').write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps(result,ensure_ascii=False))
