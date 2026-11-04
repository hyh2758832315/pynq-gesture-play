"""Create R21 scripts from the already executed R20 comparison scripts.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/make_r21_compare_scripts.py
Output: exclusive r21_base_stop_c01.py and r21_repeat_id_c01.py beside this file.
Next: review exact diffs and AST before running; do not overwrite evidence.
"""
import ast
from pathlib import Path

HERE = Path(__file__).resolve().parent
COMMON = (
    ('c6i-pl-vision-volume-osd-r20-admission-r03-20261023',
     'c6i-pl-vision-volume-osd-r21-marker-r02-20261023'),
    ('osd-r20-compare-20261024-c01', 'osd-r21-compare-20261024-c01'),
    ('ddab12d94487c01b4b526ed1e73e3bf12efe42301bcce1c0da543e60d6709106',
     '10b01f51e3dc184496c94609d895211215045dac98efdb41b898277f2a10c72f'),
    ("len(manifest['sha256']) == 644", "len(manifest['sha256']) == 628"),
)
TASKS = (
    ('r20_base_stop_c01.py', 'r21_base_stop_c01.py', (
        ('r20-base-stop-c01.json', 'r21-base-stop-c01.json'),
        ("assert not LOG.exists(), 'Comparison log already exists'",
         "assert LOG.is_dir() and (LOG / 'base-restore.jsonl').exists()"),
        ('LOG.mkdir(parents=True)', 'LOG.mkdir(parents=True, exist_ok=True)'),
    )),
    ('r20_repeat_id_c01.py', 'r21_repeat_id_c01.py', (
        ('r20-repeat-id-c01.json', 'r21-repeat-id-c01.json'),
    )),
)

for source_name, target_name, extra in TASKS:
    target = HERE / target_name
    assert not target.exists(), target
    source = (HERE / source_name).read_text(encoding='utf-8')
    output = source
    for old, new in COMMON + extra + ((source_name, target_name), ('R20', 'R21')):
        assert old in output, (source_name, old)
        output = output.replace(old, new)
    ast.parse(output, filename=target_name)
    assert 'r20' not in output.lower(), target_name
    with target.open('x', encoding='utf-8', newline='\n') as stream:
        stream.write(output)
    print(target)
