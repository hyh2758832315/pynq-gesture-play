"""Build a deterministic complete project archive without hardware/network access.

Run: python -B restore_assets.py; python -B package_release.py --out dist
Requires Python 3.13. Outputs: dist/contest_v3.zip, .sha256 and package_result.json.
Next: compare SHA, then upload to a draft Release. Does not modify project files.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import sys
import zipfile

ROOT=Path(__file__).resolve().parent
if sys.platform=='win32' and not str(ROOT).startswith('\\\\?\\'):
    ROOT=Path('\\\\?\\'+str(ROOT))

def sha(path):
    with path.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--out',type=Path,default=Path('dist'))
    args=parser.parse_args()
    project=ROOT/'project'
    manifest=json.loads((project/'manifest.json').read_text('utf-8'))
    for name,item in manifest['files'].items():
        path=(project/name).resolve()
        if not path.is_relative_to(project) or not path.is_file():raise ValueError(name)
        if path.stat().st_size!=item['bytes'] or sha(path)!=item['sha256']:raise ValueError(name)
    args.out.mkdir(parents=True,exist_ok=True)
    archive=args.out/'contest_v3.zip'
    with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED,compresslevel=6,allowZip64=True) as z:
        for name in ['manifest.json',*sorted(manifest['files'])]:
            info=zipfile.ZipInfo('contest_v3/'+name,date_time=(2026,11,1,0,0,0))
            info.create_system=3
            info.external_attr=0o100644 << 16
            info.compress_type=zipfile.ZIP_DEFLATED
            with (project/name).open('rb') as src,z.open(info,'w',force_zip64=True) as dst:
                shutil.copyfileobj(src,dst,length=1024*1024)
    with zipfile.ZipFile(archive) as z:
        if z.testzip() is not None:raise ValueError('ZIP CRC failed')
        for name,item in manifest['files'].items():
            with z.open('contest_v3/'+name) as f:
                if hashlib.file_digest(f,'sha256').hexdigest()!=item['sha256']:raise ValueError(name)
    digest=sha(archive)
    (args.out/'contest_v3.zip.sha256').write_text(digest+'  contest_v3.zip\n',encoding='ascii',newline='\n')
    result={'result':'PASS','files':len(manifest['files']),'bytes':archive.stat().st_size,
            'sha256':digest,'manifest_sha256':sha(project/'manifest.json'),
            'runtime_metadata_or_media_changed':True,
            'hardware_config_changed':False,'physical_retest':False,'board_access':False}
    (args.out/'package_result.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8',newline='\n')
    print(json.dumps(result))

if __name__=='__main__':main()
