"""Run: python scripts/package_handoff.py
Output: handoff_manifest.json and ../gesture_vision_handoff_v61.zip.
Next: verify_handoff.py; supply a GitHub destination before publishing.
Only packages files; does not touch hardware or any Git remote.
"""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import zipfile


def main():
    root = Path(__file__).resolve().parents[1]
    files = sorted(p for p in root.rglob('*') if p.is_file()
                   and '__pycache__' not in p.parts
                   and p.suffix != '.pyc'
                   and p.name != 'handoff_manifest.json')
    manifest = {
        'version': 'gesture_vision_handoff_v61',
        'target': 'PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1',
        'external_board_dependency': '/home/xilinx/voice-view-game/camera-corrected-hdmi-prototype/capture_camera_direct_plug.py',
        'sha256': {p.relative_to(root).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest().upper()
                   for p in files}}
    manifest_path = root / 'handoff_manifest.json'
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    subprocess.run([sys.executable, str(root/'scripts/verify_handoff.py')], check=True)
    archive = root.parent / (root.name + '.zip')
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED) as output:
        for path in files + [manifest_path]:
            output.write(path, path.relative_to(root.parent).as_posix())
    with zipfile.ZipFile(archive) as output:
        if output.testzip() is not None:
            raise ValueError('ZIP integrity failure')
    print(f'HANDOFF_ZIP_PASS path={archive} files={len(files)+1} bytes={archive.stat().st_size}')


if __name__ == '__main__':
    main()
