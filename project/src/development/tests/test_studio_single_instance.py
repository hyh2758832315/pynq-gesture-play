from __future__ import annotations

import os
import uuid

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

from PySide6.QtWidgets import QApplication

from pynq_multimodal_game.studio.single_instance import StudioSingleInstance


def test_second_studio_launch_activates_first() -> None:
    app = QApplication.instance() or QApplication([])
    name = f"voice-view-studio-test-{uuid.uuid4().hex}"
    activations: list[bool] = []
    first = StudioSingleInstance(name, lambda: activations.append(True))
    second = StudioSingleInstance(name, lambda: None)
    try:
        assert first.claim()
        assert not second.claim()
        app.processEvents()
        assert activations == [True]
    finally:
        second.close()
        first.close()


def test_studio_endpoint_can_be_reclaimed_after_close() -> None:
    QApplication.instance() or QApplication([])
    name = f"voice-view-studio-test-{uuid.uuid4().hex}"
    first = StudioSingleInstance(name, lambda: None)
    second = StudioSingleInstance(name, lambda: None)
    try:
        assert first.claim()
        first.close()
        assert second.claim()
    finally:
        second.close()


def test_separate_process_launch_activates_owner_and_reclaims_after_exit(tmp_path) -> None:
    import json
    from pathlib import Path
    import subprocess
    import sys
    import time
    # Unique local IPC name: never address the user's running Studio or PYNQ.
    name = f'voice-view-studio-process-test-{uuid.uuid4().hex}'
    ready = tmp_path/'ready.json'
    child = tmp_path/'instance_child.py'
    child.write_text('''import json, sys
from pathlib import Path
from PySide6.QtCore import QTimer
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.studio.single_instance import StudioSingleInstance
app = QApplication([])
def activate():
    print('ACTIVATED', flush=True)
    app.quit()
instance = StudioSingleInstance(sys.argv[1], activate)
try:
    acquired = instance.claim()
    print(json.dumps({'acquired': acquired}), flush=True)
    if sys.argv[2] == 'owner':
        ready=Path(sys.argv[3]);temporary=ready.with_suffix('.tmp')
        temporary.write_text(json.dumps({'acquired': acquired}))
        temporary.replace(ready)
        QTimer.singleShot(10000, app.quit)
        if acquired: app.exec()
finally:
    instance.close()
''', encoding='utf-8')
    environment = dict(os.environ, QT_QPA_PLATFORM='offscreen')
    environment['PYTHONPATH'] = str(Path(__file__).resolve().parents[1]/'python')
    process = subprocess.Popen([sys.executable, '-B', str(child), name, 'owner', str(ready)],
                               env=environment, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                               text=True)
    try:
        deadline = time.monotonic()+5
        while not ready.exists() and process.poll() is None and time.monotonic()<deadline:
            time.sleep(.01)
        assert ready.exists(), 'primary local IPC did not become ready'
        assert json.loads(ready.read_text())['acquired'] is True
        second = subprocess.run([sys.executable, '-B', str(child), name, 'second'],
                                env=environment, capture_output=True, text=True, timeout=5)
        assert second.returncode == 0, second.stderr
        assert json.loads(second.stdout)['acquired'] is False
        output, errors = process.communicate(timeout=5)
        assert process.returncode == 0, errors
        assert 'ACTIVATED' in output
        third = subprocess.run([sys.executable, '-B', str(child), name, 'reclaim'],
                               env=environment, capture_output=True, text=True, timeout=5)
        assert third.returncode == 0, third.stderr
        assert json.loads(third.stdout)['acquired'] is True
    finally:
        if process.poll() is None:
            process.terminate()
        process.communicate(timeout=5)
