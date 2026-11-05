"""Verify the submission's Skill, template, data and document entrypoints, offline.

Run: python -X utf8 -B tools/check_submission.py (Python 3.11+).
Output: JSON PASS/FAIL on stdout; no file, network or board mutations.
Next: verify_package.py for all sealed files; README.md for actual reproduction.
"""
from pathlib import Path
import csv
import hashlib
import json
import re
import subprocess
import sys
from urllib.parse import unquote
import zipfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    failures = []
    required = [
        'skill/README.md', 'skill/report.md', 'skill/inventory.json',
        'skill/pynq-pl-preserve/SKILL.md', 'skill/pynq-pl-preserve/LICENSE',
        'skill/pynq-debug-cards/SKILL.md', 'skill/pynq-debug-cards/LICENSE',
        'skill/pynq-debug-cards/origins.json',
        'skill/validation/evidence/delivery_replay/result.json',
        'report/submission_checklist.md', 'report/report_materials.md',
        'report/templates/official_report_template.docx',
        'report/requirements/recheck_20261104.json', 'data/report_metrics.csv',
        'report/ai_collaboration.md', 'report/gpu_optimization.md',
        'report/设计报告与大模型协作记录.md',
        'board/voice-view-shell.service',
        'src/development/board/pynq_z2/studio_autostart.conf',
        'build/scripts/apply_gpu_profile.tcl', 'tools/prepare_runtime.py',
        'data/gpu_optimization/measurements.csv', 'data/gpu_optimization/resources.csv',
        'sim/gpu_optimization/run_compare.tcl',
    ]
    failures.extend('missing: '+name for name in required if not (ROOT/name).is_file())
    if failures:
        print(json.dumps({'result':'FAIL', 'failures':failures})); return 1

    template=ROOT/'report/templates/official_report_template.docx'
    expected='4c70c9294d3b302c8035547bf692cad8a4a815f3f17c6c39ddf1c9ded6c841b7'
    if hashlib.sha256(template.read_bytes()).hexdigest()!=expected:
        failures.append('official Word template SHA differs')
    with zipfile.ZipFile(template) as z:
        if z.testzip() or 'word/document.xml' not in z.namelist():
            failures.append('invalid Word template')

    with (ROOT/'data/report_metrics.csv').open(encoding='utf-8-sig',newline='') as f:
        metrics=list(csv.DictReader(f))
    for row in metrics:
        p=(ROOT/row['evidence']).resolve()
        if not p.is_relative_to(ROOT) or not p.is_file():
            failures.append('metric evidence: '+row['id'])

    docs=[ROOT/'README.md', *(ROOT/'skill').rglob('*.md')]
    docs += [ROOT/'report'/n for n in ('submission_checklist.md','report_materials.md',
                                     'licensing.md','publication_trace.md','missing_items.md',
                                     '设计报告与大模型协作记录.md','design_report.md',
                                     'ai_collaboration.md','gpu_optimization.md')]
    docs.append(ROOT/'board/README.md')
    links=0
    for doc in docs:
        for match in re.finditer(r'(?<!!)\[[^\]\n]+\]\(([^)\n]+)\)', doc.read_text('utf-8')):
            target=match.group(1).strip().strip('<>')
            if not target or re.match(r'^[a-zA-Z][a-zA-Z0-9+.-]*:',target) or target.startswith('#'):
                continue
            target=unquote(target.split('#',1)[0])
            if target and not (doc.parent/target).resolve().exists():
                failures.append('broken link: '+doc.relative_to(ROOT).as_posix()+' -> '+target)
            links+=1

    checks=[]
    for name in ['skill/validation/verify_files.py',
                 'report/figures/hand_communication_handoff/scripts/check_data.py',
                 'report/figures/vision_dual_follow_handoff/scripts/check_package.py',
                 'report/figures/gpu_buffer_timing_handoff/scripts/check_package.py']:
        p=subprocess.run([sys.executable,'-X','utf8','-B',str(ROOT/name)],
                         capture_output=True,text=True,encoding='utf-8',timeout=120)
        checks.append({'script':name,'exit_code':p.returncode,'stdout':p.stdout.strip(),'stderr':p.stderr.strip()})
        if p.returncode: failures.append('nested check: '+name)
    guide=json.loads((ROOT/'report/requirements/recheck_20261104.json').read_text('utf-8'))
    actual=hashlib.sha256((ROOT/'report/requirements/open_topic_guide.md').read_bytes()).hexdigest()
    if not guide['matches'] or actual!=guide['sha256']:
        failures.append('official guide snapshot mismatch')
    result={'result':'FAIL' if failures else 'PASS','metrics':len(metrics),
            'local_links_checked':links,'template_sha256':expected,
            'hardware_access':False,'nested_checks':checks,'failures':failures}
    print(json.dumps(result,ensure_ascii=False,indent=2))
    return bool(failures)


if __name__=='__main__':
    raise SystemExit(main())
