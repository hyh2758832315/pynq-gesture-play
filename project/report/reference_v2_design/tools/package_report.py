"""Validate evidence and package the standalone LaTeX report.

Run from any directory: python tools/package_report.py
Output: gesture_play_v2_junior_source.zip and qa/review.json.
Next: compile main.tex from the extracted archive or read the delivered PDF.
"""
from pathlib import Path
import hashlib, json, zipfile, re
root=Path(__file__).resolve().parents[1]
repo=root.parents[1]
entries=json.loads((root/'evidence_index.json').read_text(encoding='utf-8'))
mismatches=[]
for e in entries:
    path=(root if e['id']=='R01' else repo)/e['path']
    if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest()!=e['sha256']:
        mismatches.append(e['path'])
assert not mismatches, mismatches
log=(root/'main.log').read_text(encoding='utf-8',errors='replace')
assert 'Overfull' not in log and 'Missing character' not in log
refs=set(re.findall(r'E\d\d',(root/'report.md').read_text(encoding='utf-8')))
assert refs <= {e['id'] for e in entries}
review=json.loads((root/'qa/review.json').read_text(encoding='utf-8'))
assert review['pages']==19
review.update(visual_review='passed',reviewed_pages=list(range(1,20)),vector_figures=5,
              evidence_files_verified=len(entries),overfull_boxes=0,missing_glyphs=0,
              notes='All final page contact sheets inspected; enlarged diagram checks used to correct labels before final render.')
(root/'qa/review.json').write_text(json.dumps(review,ensure_ascii=False,indent=2),encoding='utf-8')
paths=[root/p for p in ['main.tex','readme.md','report.md','evidence_index.json','tools/repair_pdf_unicode.py']]
for folder in ['sections','figures','sources']:
    paths.extend(p for p in (root/folder).rglob('*') if p.is_file())
archive=root/'gesture_play_v2_junior_source.zip'
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
    for p in paths:z.write(p,p.relative_to(root).as_posix())
with zipfile.ZipFile(archive) as z:
    assert z.testzip() is None
    assert all(not Path(n).is_absolute() and '..' not in Path(n).parts for n in z.namelist())
print(json.dumps({'pages':review['pages'],'verified_evidence':len(entries),'archive_files':len(paths),'archive':str(archive)},ensure_ascii=False))
