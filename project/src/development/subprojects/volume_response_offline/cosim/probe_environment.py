"""Read-only Linux cosimulation prerequisites; does not contact any FPGA.

Run from PowerShell:
  wsl -d Ubuntu-20.04 -- python3 /mnt/e/projects/fpga/voice-view-game/subprojects/volume_response_offline/cosim/probe_environment.py
Output: JSON on stdout. Next: select an isolated supported QEMU/SystemC build.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys


def command(args):
    try:
        result=subprocess.run(args,capture_output=True,text=True,timeout=15)
        return dict(returncode=result.returncode,stdout=result.stdout[:3000],stderr=result.stderr[:1000])
    except (OSError,subprocess.TimeoutExpired) as error:
        return dict(error=str(error))


if __name__=='__main__':
    result=dict(board_access=False,uid=os.getuid(),python=sys.version,
                os_release=Path('/etc/os-release').read_text(),
                tools={name:shutil.which(name) for name in
                    ('git','g++','cmake','make','ninja','meson','verilator','qemu-system-arm',
                     'qemu-system-aarch64','dtc','cpio','bison','flex','rsync','pkg-config')},
                libraries={name:command(['pkg-config','--modversion',name]) for name in
                    ('glib-2.0','pixman-1','systemc','zlib')},
                compiler=command(['g++','--version']),
                linux_free_bytes=shutil.disk_usage('/').free)
    print(json.dumps(result,indent=2))
