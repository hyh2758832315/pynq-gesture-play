"""Select a verified local system package for the desktop Studio; never install.

Run: .venv/Scripts/python.exe -B tools/studio_select_candidate.py --candidate build/ps-ui-studio-pink-preview-r03 --output build/studio-pink-default-candidate.json
Outputs: JSON receipt, native desktop Studio candidate preference.
Next: open Studio normally; board installation remains an explicit user action.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sys
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'python'))

from PySide6.QtCore import Qt
from pynq_multimodal_game.studio import main_window, qt_app
from pynq_multimodal_game.studio.system_board import verify


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    candidate = args.candidate.resolve(strict=True)
    verify(candidate, exact=True)
    report = dict(board_access=False, install_started=False, candidate=str(candidate),
                  manifest_sha256=hashlib.sha256((candidate/'deployment_manifest.json').read_bytes()).hexdigest())
    original = main_window.StudioMainWindow

    class Select(original):
        def __init__(self, *a, **kw):
            super().__init__(*a, **kw)
            self.setAttribute(Qt.WidgetAttribute.WA_DontShowOnScreen, True)
            report['settings_file'] = self.settings.fileName()
            report['previous_candidate'] = self.settings.value('content/system-candidate', '')
            self.load_workspace.set_system_candidate(candidate)
            self.settings.sync()
            assert self.load_workspace.system_candidate == candidate
            assert self.settings.value('content/system-candidate') == str(candidate)
            assert not self.load_workspace.is_busy and not self.vision_workspace._http_attached()

    # The desktop module runs in python.exe, whose Qt application name is python.
    with patch.object(qt_app, 'StudioMainWindow', Select):
        assert qt_app.run_studio(['python', '--smoke-test', '--agent-build-id', '0xC0061000']) == 0
    report['result'] = 'PASS'
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps(report, ensure_ascii=False))


if __name__ == '__main__':
    main()
