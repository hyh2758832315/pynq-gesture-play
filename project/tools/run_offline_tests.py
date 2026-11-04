"""Run relocated Studio/startup checks without connecting physical hardware.

Run: python -B tools/run_offline_tests.py
Output: sim/evidence/normalized_studio.xml. Next: review failures before deployment.
Requires the Studio dependencies plus pytest. Local loopback networking is used.
"""
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
source = ROOT / 'src/development'
output = ROOT / 'sim/evidence'
output.mkdir(parents=True, exist_ok=True)
env = dict(os.environ, PYTHONDONTWRITEBYTECODE='1',
           PYTHONPATH=os.pathsep.join((str(source/'python'), str(source))),
           QT_QPA_PLATFORM='offscreen')
tests = ['test_studio_system_loader.py', 'test_studio_board_connection.py',
         'test_studio_content_flow.py', 'test_studio_ui.py', 'test_studio_autostart.py']
raise SystemExit(subprocess.call([sys.executable, '-B', '-m', 'pytest',
    *['tests/'+name for name in tests], '-q',
    '--junitxml='+str(output/'normalized_studio.xml')], cwd=source, env=env))
