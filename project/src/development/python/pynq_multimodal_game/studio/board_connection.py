"""Authenticated, read-only board discovery independent of the project Agent.

Used by Studio's connection worker and system loader; no hardware is opened.
The probe runs with the default system Python, including on a fresh PYNQ image.
"""
import json
import os
import re
import shlex
import socket
import subprocess
import time


PROBE = r'''
import json, os, subprocess
from pathlib import Path
base = Path('/home/xilinx/voice-view-game/.studio-system')
python = Path('/usr/local/share/pynq-venv/bin/python')
active_path = base / 'active.json'
active = json.loads(active_path.read_text()) if active_path.exists() else None
boot = Path('/proc/sys/kernel/random/boot_id').read_text().strip()
running = False
if active and active.get('boot_id') == boot:
    p = Path('/proc') / str(int(active['pid']))
    try:
        stat = (p/'stat').read_text().rsplit(')', 1)[1].split()
        argv = (p/'cmdline').read_bytes().split(b'\0')
        running = (stat[0] != 'Z' and stat[19] == active['start_ticks']
            and str(Path(active['root'])/'start_board_test.py').encode() in argv)
    except OSError:
        pass
loader_busy = False
loader_pid = None
try:
    lock = (base/'loader.lock').stat()
    identity = (os.major(lock.st_dev), os.minor(lock.st_dev), lock.st_ino)
    for line in Path('/proc/locks').read_text().splitlines():
        parts = line.split()
        if len(parts) < 6 or parts[1:4] != ['FLOCK', 'ADVISORY', 'WRITE']:
            continue
        dev = parts[5].split(':')
        if (int(dev[0],16), int(dev[1],16), int(dev[2])) == identity:
            loader_busy, loader_pid = True, int(parts[4])
            break
except (OSError, ValueError, IndexError):
    pass
service = {}
try:
    result = subprocess.run(['systemctl','show','voice-view-shell.service',
        '-p','ActiveState','-p','SubState','-p','MainPID','-p','Result'],
        stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, timeout=2, universal_newlines=True)
    service = dict(line.split('=',1) for line in result.stdout.splitlines() if '=' in line)
except (OSError, subprocess.TimeoutExpired):
    pass
hand_default = bool(active.get('hand_enabled', True)) if active else True
try:
    config = json.loads((base/'boot/config.json').read_text())
    if type(config.get('hand_enabled')) is bool:
        hand_default = config['hand_enabled']
except (OSError, ValueError):
    pass
startup_stage = None
startup_error = None
if running:
    transaction = active.get('transaction', '')
    if len(transaction)==32 and all(c in '0123456789abcdef' for c in transaction):
        try:
            with (base/transaction/'console.log').open('rb') as stream:
                stream.seek(0,2);stream.seek(max(0,stream.tell()-8192))
                log=stream.read().decode('utf-8',errors='replace')
            startup_stage = ('连接 Agent' if 'UI_SESSION_READY' in log else
                '界面与设备初始化' if 'CAMERA_IIC_CHIP_ID_STATUS=PASS' in log else
                '内容库初始化' if 'BUNDLED_GAMES' in log else '加载运行环境')
            if 'Traceback (most recent call last)' in log or 'shell initialization failed:' in log:
                startup_error = log.splitlines()[-1][-300:]
        except OSError:
            pass
print(json.dumps(dict(ssh_ready=True, boot_id=boot, installed=active,
    running=running, runtime_available=python.is_file(), loader_busy=loader_busy,
    loader_pid=loader_pid, service=service, hand_default=hand_default,
    startup_stage=startup_stage, startup_error=startup_error,
    hand_available=Path('/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00').exists(),
    addresses=subprocess.check_output(['hostname', '-I']).decode().split())))
'''


def board_startup_message(info):
    """Describe observed startup state without promising a successful future boot."""
    if not info or not info.get('ssh_ready'):
        return '板卡 SSH 未确认'
    if info.get('loader_busy'):
        return '板卡正在启动检查或安装，自动等待中'
    if info.get('startup_error'):
        return '项目启动异常：' + info['startup_error']
    if info.get('running'):
        return '项目正在' + (info.get('startup_stage') or '初始化／连接恢复') + '，等待 Agent 就绪'
    service = info.get('service') or {}
    if service.get('ActiveState') == 'failed':
        return '项目自启动失败：' + str(service.get('Result', '请查看启动记录'))
    if service.get('ActiveState') in ('activating', 'active'):
        return '系统自启动进行中，等待项目初始化'
    return '项目尚未运行，可启动已安装项目' if info.get('installed') else '尚未安装项目'


def board_startup_title(info):
    if not info or not info.get('ssh_ready'):return '程序未连接'
    if info.get('loader_busy'):return '启动检查中'
    if info.get('startup_error'):return '启动异常'
    if info.get('running'):return info.get('startup_stage') or '项目初始化中'
    state=(info.get('service') or {}).get('ActiveState')
    if state=='failed':return '自启动失败'
    if state in ('active','activating'):return '系统启动中'
    return '项目未运行' if info.get('installed') else '尚未安装项目'


def validate_alias(alias):
    if not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9_.-]{0,63}', alias):
        raise ValueError('SSH 主机别名无效，请在加载页配置已授权的 SSH 主机')
    return alias


def probe_board(device, *, ssh_alias='pynq-z2', stop_event=None):
    """Bounded and cancellable; SSH authentication is required, not just TCP 22."""
    validate_alias(ssh_alias)
    host, _, source, _ = device.connection_settings
    argv = ['ssh', '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=5',
            *(['-b', source] if source else []), ssh_alias,
            shlex.join(['sudo', '-n', 'python3', '-B', '-'])]
    flags = subprocess.CREATE_NO_WINDOW if os.name == 'nt' else 0
    with subprocess.Popen(argv, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE, creationflags=flags) as child:
        deadline = time.monotonic() + 8
        data = PROBE.encode()
        while True:
            if (stop_event is not None and stop_event.is_set()) or time.monotonic() > deadline:
                child.kill()
                child.communicate()
                raise TimeoutError('板卡 SSH 检查已取消或超时')
            try:
                out, error = child.communicate(data, timeout=.1)
                break
            except subprocess.TimeoutExpired:
                data = None
        if child.returncode:
            raise RuntimeError(error.decode('utf-8', errors='replace')[-1000:] or 'SSH 检查失败')
    result = json.loads(out.decode().strip().splitlines()[-1])
    if socket.gethostbyname(host) not in result['addresses']:
        raise ValueError('SSH 主机与 Studio 地址不是同一块板卡，请修正连接设置')
    return result
