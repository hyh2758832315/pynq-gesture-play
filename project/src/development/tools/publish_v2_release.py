"""Publish the verified v2 snapshot via an isolated Git clone and GitHub Release.

Run: .venv/Scripts/python.exe -B tools/publish_v2_release.py --repo build/v2-release-repo
Output: build/voice-view-v2-github-release.json; v2.0 tag, full ZIP and checksum.
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
seal=json.loads((parent/'voice-view-v2-release-receipt.json').read_text(encoding='utf-8'))
accept=json.loads((repo/'releases/v2.0/verification/acceptance-summary.json').read_text(encoding='utf-8'))
assert accept['result']=='PASS' and accept['manifest_sha256']=='5f53d85d5bcdb8c871d387683cbf7b6b12c899b380b9370642c9bd2ff41e9d56'
credentials=subprocess.run(['git','credential','fill'],cwd=repo,
    input='protocol=https\nhost=github.com\n\n',capture_output=True,text=True,check=True)
token=dict(line.split('=',1) for line in credentials.stdout.splitlines() if '=' in line)['password']
api='https://api.github.com/repos/HH-bit-dev/pynq-audiovisual-diagnostics'
def request(url,method='GET',payload=None,data=None,content_type='application/json'):
    parsed=urllib.parse.urlparse(url)
    assert parsed.scheme=='https' and parsed.hostname in ('api.github.com','uploads.github.com')
    headers={'Authorization':'Bearer '+token,'Accept':'application/vnd.github+json',
      'User-Agent':'voice-view-v2-publisher','X-GitHub-Api-Version':'2022-11-28'}
    if payload is not None:data=json.dumps(payload,ensure_ascii=False).encode('utf-8')
    if data is not None:headers['Content-Type']=content_type
    try:
        with urllib.request.urlopen(urllib.request.Request(url,method=method,headers=headers,data=data),timeout=600) as response:
            return json.load(response)
    except urllib.error.HTTPError as error:raise RuntimeError(f'GitHub {method} {parsed.path}: HTTP {error.code}') from None
assert request(api+'/commits/v2.0')['sha']==commit
body='''完整版 v2.0：原生 Studio–PYNQ 闭环，冻结 R23b2 PL（0xC0061000）及 R09 灵巧手。

包含完整运行包、配对 bit/HWH/DCP、四游戏及 PC 示例、双默认视频、灵巧手 0–9＋比心展示、握拳画布/临时相册、源码和校验清单。

修复画板红圈但漏画及限频丢帧；悬停改用轻量 GPU 命令；主菜单/游戏列表/视频列表启用已有灵巧手跟随。视频/回传/画布与实体手继续互斥，正常版本无实验会话总时限。

离线、Studio 标准整包/内容、真实 GPU 与实体串口协议验收见随包 verification。当前修改的机械姿态未新增真人目视验收；协议测试不等同机械目视结论。默认视频来源与第三方许可证随包保留。不含操作系统镜像或虚拟环境。

下载 voice-view-full-v2.0.zip 后运行 verify_release.py；大文件会从包内 SHA 校验块离线重建。源码入口：[releases/v2.0](https://github.com/HH-bit-dev/pynq-audiovisual-diagnostics/tree/v2.0/releases/v2.0)。v1.0 保留。
'''
existing=[r for r in request(api+'/releases?per_page=100') if r['tag_name']=='v2.0']
if existing:
    release=existing[0];assert release['draft'],'Refuse to change an already published release'
else:release=request(api+'/releases','POST',payload=dict(tag_name='v2.0',target_commitish=commit,
    name='完整版 v2.0 · Studio–PYNQ',body=body,draft=True,prerelease=False))
assets=[]
for name,kind in (('voice-view-full-v2.0.zip','application/zip'),('voice-view-full-v2.0.sha256','text/plain')):
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
result=dict(result='PASS',tag='v2.0',commit=commit,url=release['html_url'],assets=assets,
            published_at=release['published_at'])
(parent/'voice-view-v2-github-release.json').write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps(result,ensure_ascii=False))
