"""Aggregate retained R45 evidence; never probes the board.
Run: .venv/Scripts/python.exe tools/r45_acceptance_report.py
Output: build/studio-r45/acceptance.json. Next: review the bringup record.
"""
import json
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/studio-r45'
files=['r45-tests02.xml','r45-tests03.xml','r45-studio02.xml','r45-loader03.xml',
       'r45-tests05.xml','r45-recovery06.xml','r45-native03.xml','r45-native04.xml']
tests={}
for name in files:
    for case in ET.parse(ROOT/'build'/name).iter('testcase'):
        tests[(case.attrib['classname'],case.attrib['name'])]=dict(source=name,
            passed=case.find('failure') is None and case.find('error') is None,
            skipped=case.find('skipped') is not None)
ui=json.loads((OUT/'ui-system.json').read_text(encoding='utf-8'))
load=json.loads(Path(ui['receipt']).read_text(encoding='utf-8'))
board_path=OUT/'exercise/exercise.json'
board=json.loads(board_path.read_text(encoding='utf-8')) if board_path.exists() else None
budget=json.loads((ROOT/'build/r45-shell-preview/budget.json').read_text())
result=dict(schema='r45-shell-acceptance-v1',offline_unique=len(tests),
            offline_passed=sum(t['passed'] and not t['skipped'] for t in tests.values()),
            offline_failures=[list(k) for k,v in tests.items() if not v['passed']],
            native_studio_system_load=ui['result'],manifest_sha256=load['manifest_sha256'],
            transaction=load['transaction'],physical_hand=False,
            board_result=None if board is None else board['result'],
            board_checks=[] if board is None else [dict(name=s['name'],passed=s['passed']) for s in board['steps']],
            max_asset_payload=max(p['payload_bytes'] for p in budget),asset_capacity=32768,
            screenshots='build/r45-shell-preview',visual_review='ship for four scored fixes; PC rendering only',
            scope='HDMI shell and Studio system loader; game rules and frozen PL unchanged',
            first_upload_attempt='Failed before hardware start: root-owned upload file; fixed scoped file ownership',
            unrelated_historical_tests='R23 candidate expects old gesture skills/four game slots; legacy hand owner fixture omits _page_lock. Not included in targeted passing count.')
(OUT/'acceptance.json').write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps({k:result[k] for k in ('offline_unique','offline_passed','offline_failures','native_studio_system_load','board_result','max_asset_payload')}))
