"""Make an immutable diagnostics-only software branch of the paired C0E ZIP.
Run: .venv/Scripts/python.exe -B .../prepare_latency_diagnostics.py
Output: r17-d01 ZIP/tree, revised full manifest and receipt. No board access.
Next: preserve failed live owner, normal recovery, stage new branch; hardware bytes must remain identical.
"""
import hashlib,json,ast,zipfile,subprocess,sys,os
from pathlib import Path
HERE=Path(__file__).resolve().parent;REPO=HERE.parents[2]
PARENT=REPO/'deliveries/c6i-pl-vision-volume-osd-r17-20261023.zip'
TARGET=PARENT.with_suffix('').with_name(PARENT.stem+'-d02')
def sha(b):return hashlib.sha256(b).hexdigest()
def main():
    receipt=HERE/'evidence/latency-diagnostics-package-r02.json'
    assert not TARGET.exists() and not TARGET.with_suffix('.zip').exists() and not receipt.exists()
    assert sha(PARENT.read_bytes())=='1ee6753e96d6fd8a8ba759646a01f4c5d991dfec43b126e3cd70ef8ed83f80d1'
    with zipfile.ZipFile(PARENT) as z:
        assert z.testzip() is None
        prefix=PARENT.stem+'/'
        for member in z.namelist():
            assert member.startswith(prefix)
            relative=member[len(prefix):]
            p=(TARGET/relative).resolve();assert p.is_relative_to(TARGET)
            p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(z.read(member))
    path=TARGET/'board/pynq_z2/vision_dma_pool.py'
    original_bytes=path.read_bytes()
    original=original_bytes.decode('utf-8').replace('\r\n','\n')
    marker='    def _status(self) -> CaptureEpochStatus:\n'
    assert original.count(marker)==1
    helper='''    def _reject_epoch(self, reason, status):
        # Error path only: reads use the existing owner's handles; never a second MMIO owner.
        diagnostic = dict(expected_epoch=self._epoch, actual=repr(status), pool_state=self._state)
        try:
            diagnostic['owner_words'] = {hex(offset): int(self._owner._word(offset))
                for offset in (0x08, 0x4c, 0x50, 0x5c, 0x60, 0x64)}
            diagnostic['rgb_dma'] = {hex(offset): int(self._rgb_io[0](offset)) for offset in (0x30, 0x34)}
            diagnostic['packet_dma'] = {hex(offset): int(self._packet_io[0](offset)) for offset in (0x30, 0x34)}
        except Exception as error:
            diagnostic['read_error'] = repr(error)
        raise RuntimeError(reason + ': ' + repr(diagnostic))

'''
    changed=original.replace(marker,helper+marker).replace(
        'raise RuntimeError("capture pool epoch status rejected")',
        'self._reject_epoch("capture pool epoch status rejected", status)').replace(
        'raise RuntimeError("capture epoch fault during ARM")',
        'self._reject_epoch("capture epoch fault during ARM", status)')
    assert changed.count('self._reject_epoch(')==2
    ast.parse(changed,feature_version=(3,10));path.write_text(changed,encoding='utf-8')
    manifest=json.loads((TARGET/'deployment_manifest.json').read_text())
    name=path.relative_to(TARGET).as_posix()
    assert manifest['sha256'][name]==sha(original_bytes).upper()
    manifest['sha256'][name]=sha(path.read_bytes()).upper()
    manifest['diagnostics_parent_sha256']=sha(PARENT.read_bytes())
    (TARGET/'deployment_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    hardware={n:sha((TARGET/'overlay'/n).read_bytes()) for n in ('c6v_candidate.bit','c6v_candidate.hwh','c6v_candidate.xsa')}
    with zipfile.ZipFile(PARENT) as z:
        for n,digest in hardware.items():assert sha(z.read(PARENT.stem+'/overlay/'+n))==digest
    archive=TARGET.with_suffix('.zip')
    with zipfile.ZipFile(archive,'x',compression=zipfile.ZIP_DEFLATED) as z:
        for p in sorted(TARGET.rglob('*')):
            if p.is_file():z.write(p,TARGET.name+'/'+p.relative_to(TARGET).as_posix())
    result=subprocess.run([sys.executable,'-B',str(TARGET/'start_board_test.py'),'--check-only','--game-controls'],
        capture_output=True,text=True,cwd=TARGET,env=dict(os.environ,PYTHONPATH=str(TARGET/'python')),timeout=120)
    out=dict(status='DIAGNOSTICS_ONLY_PACKAGE_PASS' if result.returncode==0 else 'FAIL',board_access=False,
        candidate=str(TARGET),sha256=sha(archive.read_bytes()),bytes=archive.stat().st_size,manifest_files=len(manifest['sha256']),
        changed_file=name,before_sha256=sha(original_bytes),after_sha256=sha(path.read_bytes()),hardware_sha256=hardware,
        preflight=dict(returncode=result.returncode,stdout=result.stdout,stderr=result.stderr))
    with receipt.open('x') as f:json.dump(out,f,indent=2)
    assert result.returncode==0,result.stdout+result.stderr
    print(out['status'],out['sha256'],out['manifest_files'])
if __name__=='__main__':main()

