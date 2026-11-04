"""Read-only boot-service and load inspection on PYNQ-Z2, Vivado 2026.1.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/inspect_boot_service_c02.py --output build/hosd/osd-reset-r01/boot-service-c02.json --timeout 30
Output: exclusive local receipt containing boot identity, load, service state and journal.
Next: load no Overlay until the service result and current board owner are understood.
"""
import json
from pathlib import Path
import subprocess
import time


def command(*args):
    try:
        result = subprocess.run(args, capture_output=True, text=True, timeout=6)
        return dict(code=result.returncode, stdout=result.stdout[-5000:], stderr=result.stderr[-1000:])
    except subprocess.TimeoutExpired as error:
        return dict(error='timeout', stdout=str(error.stdout)[-1000:])


def cpu_times():
    fields = Path('/proc/stat').read_text().splitlines()[0].split()
    assert fields[0] == 'cpu'
    values = list(map(int, fields[1:]))
    return sum(values), values[3] + values[4]


start = cpu_times()
time.sleep(1)
end = cpu_times()
delta_total = end[0] - start[0]
delta_idle = end[1] - start[1]
print(json.dumps(dict(
    boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
    uptime_seconds=float(Path('/proc/uptime').read_text().split()[0]),
    loadavg=Path('/proc/loadavg').read_text().strip(),
    cpu_busy_fraction=None if delta_total <= 0 else (delta_total - delta_idle) / delta_total,
    meminfo=Path('/proc/meminfo').read_text().splitlines()[:5],
    bootpy=command('systemctl', 'show', 'bootpy.service', '-p', 'ActiveState', '-p',
                   'SubState', '-p', 'Result', '-p', 'ExecMainCode', '-p',
                   'ExecMainStatus', '-p', 'ExecMainStartTimestamp', '-p',
                   'ExecMainExitTimestamp'),
    bootpy_journal=command('journalctl', '-u', 'bootpy.service', '-b', '--no-pager', '-n', '40'),
), ensure_ascii=False), flush=True)
