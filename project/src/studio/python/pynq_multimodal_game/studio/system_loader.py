"""Studio system deployment transaction; no shell strings from package data."""
from pathlib import Path
import json
import os
import re
import shlex
import socket
import subprocess
import tarfile
import threading
import time
import uuid

from . import system_board
from .device import DeviceState
from .board_connection import probe_board, board_startup_message


def run_process(argv,*,input=None,timeout=180):
    flags=subprocess.CREATE_NO_WINDOW if os.name=='nt' else 0
    result=subprocess.run(argv,input=input,stdout=subprocess.PIPE,stderr=subprocess.PIPE,
                          timeout=timeout,creationflags=flags)
    if result.returncode:
        raise RuntimeError(result.stderr.decode('utf-8',errors='replace')[-3000:] or
                           result.stdout.decode('utf-8',errors='replace')[-3000:])
    return result.stdout


class BoardBusyError(RuntimeError):
    pass


class SystemLoader:
    """Verified folder -> SSH upload -> normal startup -> Agent identity check.

    Unlike media loading this works while the Agent is stopped. The SSH alias
    uses the user's existing key configuration; credentials never enter receipts.
    """
    def __init__(self,device,*,ssh_alias='pynq-z2',runner=run_process):
        if not re.fullmatch('[A-Za-z0-9][A-Za-z0-9_.-]{0,63}',ssh_alias):
            raise ValueError('SSH alias must be a configured host name')
        self.device=device;self.ssh_alias=ssh_alias;self.runner=runner
        self.script=Path(system_board.__file__).read_bytes()

    def inspect(self, *, stop_event=None):
        return probe_board(self.device, ssh_alias=self.ssh_alias, stop_event=stop_event)

    def start_installed(self, output, *, hand_enabled=False, stop_event=None,
                        progress=lambda message: None):
        """Normal unlimited start, independent of a PC package or Agent connection."""
        stop_event = stop_event or threading.Event()
        output = Path(output); output.mkdir(parents=True, exist_ok=False)
        receipt = dict(schema='studio-system-start-v1', transaction=uuid.uuid4().hex,
                       result='RUNNING', hand_enabled=hand_enabled, steps=[])
        def save():
            (output/'receipt.json').write_text(json.dumps(receipt, indent=2, ensure_ascii=False), encoding='utf-8')
        save()
        try:
            progress('检查 SSH 板卡连接和已安装项目')
            deadline = time.monotonic() + 600
            while True:
                if stop_event.is_set(): raise InterruptedError('已取消启动等待；现有板端任务保持不变')
                if time.monotonic() >= deadline:
                    raise TimeoutError('板卡启动事务仍未完成；可查看记录或稍后重新连接')
                info = self.inspect(stop_event=stop_event)
                service = info.get('service') or {}
                if (info.get('loader_busy') or (not info.get('running')
                        and service.get('ActiveState') in ('active','activating')
                        and str(service.get('MainPID','0')) != '0')):
                    progress(board_startup_message(info));stop_event.wait(2);continue
                active = info.get('installed')
                if not active:
                    raise RuntimeError('板卡在线，但尚未安装项目；请选择完整系统包并安装')
                if not info.get('runtime_available'):
                    raise RuntimeError('板卡在线，但缺少 PYNQ Python 运行环境，不能启动项目')
                if info.get('startup_error'):
                    raise RuntimeError(board_startup_message(info))
                identity = active['manifest_sha256']; receipt['manifest_sha256'] = identity
                use_hand = (bool(info.get('hand_default', active.get('hand_enabled', True)))
                            and info.get('hand_available', True)) if hand_enabled is None else hand_enabled
                receipt['hand_enabled'] = bool(use_hand)
                if hand_enabled is None and not info.get('hand_available', True):
                    receipt['hand_note']='未检测到灵巧手 USB，本次仅启动界面系统'
                    progress(receipt['hand_note'])
                save()
                if info['running'] and (not use_hand or active.get('hand_enabled')):
                    started = None
                    break
                self.device.disconnect()
                progress('正常退出当前无电机项目，再初始化并启用灵巧手' if info['running'] else
                         '启动已安装项目；执行正常初始化和检查')
                try:
                    started = self.remote('start-current-hand' if use_hand else 'start-current',
                                          receipt['transaction'], identity)
                except BoardBusyError:
                    progress('启动事务正在交接，自动等待并重新检查；不重复启动')
                    stop_event.wait(2)
                    continue
                break
            if started is None:
                progress('项目已运行，直接连接；不重复启动')
                # A reconnect never changes the current hand ownership policy.
                receipt['already_running'] = True
                receipt['hand_enabled'] = active.get('hand_enabled', False)
                deadline = time.monotonic() + 600
                while True:
                    if stop_event.is_set():
                        raise InterruptedError('已取消连接等待；板端项目保持运行')
                    try:
                        snapshot = self.device.connect()
                    except (OSError, TimeoutError):
                        snapshot = None
                    if snapshot is not None and snapshot.state is DeviceState.READY:
                        break
                    if time.monotonic() >= deadline:
                        raise TimeoutError('已等待初始化 10 分钟；板端项目保留，可重新连接')
                    progress('板卡项目正在初始化或恢复；自动重连中')
                    stop_event.wait(3)
                receipt['result'] = 'PASS'
                return receipt
            receipt['steps'].append(dict(name='started', result=started))
            save()
            progress('项目进程已启动，等待初始化和 Agent 就绪；图像回传尚未开启')
            deadline = time.monotonic() + 600
            while True:
                if stop_event.is_set():
                    raise InterruptedError('已取消等待；启动请求已发送，板端状态保留在记录中')
                try:
                    snapshot = self.device.connect()
                except (OSError, TimeoutError):
                    snapshot = None
                if snapshot is not None and snapshot.state is DeviceState.READY: break
                state = self.remote('status', receipt['transaction'], identity)
                if not state['running']:
                    raise RuntimeError('项目启动退出：' + '\n'.join(state.get('console', [])))
                if time.monotonic() >= deadline: raise TimeoutError('项目启动尚未确认，查看启动记录')
                stop_event.wait(3)
            state = self.remote('status', receipt['transaction'], identity)
            if not state['running'] or state['boot_id'] != started['boot_id']:
                raise RuntimeError('启动实例身份改变')
            receipt['steps'].append(dict(name='running', result=state))
            receipt['result'] = 'PASS'
            progress('项目已就绪；回传仍按需开启')
            return receipt
        except BaseException as error:
            receipt.update(result='FAIL', error=str(error)); raise
        finally:
            save()

    def ensure_running(self, candidate, output, *, stop_event=None, progress=lambda message: None):
        """The content upload button bootstraps an absent Agent through SSH."""
        try:
            info = self.inspect(stop_event=stop_event)
            if info.get('installed'):
                return self.start_installed(output, hand_enabled=None, stop_event=stop_event, progress=progress)
            if candidate is None:
                raise RuntimeError('板卡在线但尚未安装项目，请先选择完整系统包')
            return self.load(candidate, output, stop_event=stop_event, progress=progress)
        except Exception as error:
            output = Path(output)
            if not (output/'receipt.json').exists():
                output.mkdir(parents=True, exist_ok=True)
                (output/'receipt.json').write_text(json.dumps(dict(schema='studio-system-ensure-v1',
                    result='FAIL', error=str(error)), ensure_ascii=False, indent=2), encoding='utf-8')
            raise

    def remote(self,action,transaction,identity):
        command=shlex.join(['sudo','-n','/usr/local/share/pynq-venv/bin/python','-B','-',
                            action,transaction,identity])
        source=self.device.connection_settings[2]
        binding=['-b',source] if source else []
        raw=self.runner(['ssh','-o','BatchMode=yes','-o','ConnectTimeout=20',*binding,self.ssh_alias,command],
                        input=self.script,timeout=600)
        result=json.loads(raw.decode('utf-8').strip().splitlines()[-1])
        if result.get('result')=='BUSY':
            raise BoardBusyError(result.get('message','板卡启动事务正在进行'))
        return result

    def resume_installed(self,failed_receipt,output,*,stop_event=None,progress=lambda message:None):
        """Retry a verified, released startup failure, without upload or reinstall.

        The original failed receipt is immutable. A separate recovery receipt
        carries the new PID and the original transaction/package identity.
        """
        stop_event=stop_event or threading.Event()
        source=Path(failed_receipt)
        receipt=json.loads(source.read_text(encoding='utf-8'))
        if receipt['result']!='FAIL' or receipt.get('hand_enabled'):
            raise ValueError('Only a failed hand-disabled installation can resume')
        identity=receipt['manifest_sha256'];transaction=receipt['transaction']
        manifest=system_board.verify(Path(receipt['candidate']),identity,exact=True)
        if self.device.expected_build_id!=int(manifest['build_id'],0):
            raise ValueError('Studio platform differs')
        output=Path(output);output.mkdir(parents=True,exist_ok=False)
        receipt=dict(receipt,result='RUNNING',recovery_of=str(source.resolve()),steps=list(receipt['steps']))
        try:
            if stop_event.is_set():raise InterruptedError('启动重试已取消，原失败记录保留')
            self.device.disconnect()
            progress('恢复已验证系统的启动；不重新上传')
            installed=self.remote('resume',transaction,identity)
            receipt['steps']=[s for s in receipt['steps'] if s['name']!='installed']
            receipt['steps'].append(dict(name='installed',result=installed))
            deadline=time.monotonic()+600
            while True:
                if stop_event.is_set():raise InterruptedError('已取消启动确认；已启动任务保留，查看记录')
                state=self.remote('status',transaction,identity)
                if not state['running']:
                    raise RuntimeError('启动进程已退出：'+'\n'.join(state.get('console',[])))
                try:snapshot=self.device.connect()
                except (OSError,TimeoutError):snapshot=None
                if snapshot is not None and snapshot.state is DeviceState.READY:break
                if time.monotonic()>deadline:raise TimeoutError('恢复启动未确认')
                time.sleep(3)
            if snapshot.build_id!=int(manifest['build_id'],0) or state['boot_id']!=installed['boot_id']:
                raise RuntimeError('Recovered system identity differs')
            receipt['steps'].append(dict(name='running',result=state))
            receipt.pop('error',None);receipt['result']='PASS'
            return receipt
        except BaseException as error:
            receipt.update(result='FAIL',error=str(error));raise
        finally:
            (output/'receipt.json').write_text(json.dumps(receipt,indent=2,ensure_ascii=False),encoding='utf-8')

    def confirm_installed(self,source_receipt,output):
        """Read-only readiness recovery after a wait timeout; never start a process."""
        source=Path(source_receipt)
        receipt=json.loads(source.read_text(encoding='utf-8'))
        identity=receipt['manifest_sha256']
        manifest=system_board.verify(Path(receipt['candidate']),identity,exact=True)
        if self.device.expected_build_id!=int(manifest['build_id'],0):raise ValueError('Studio platform differs')
        installed=next(s['result'] for s in receipt['steps'] if s['name']=='installed')
        output=Path(output);output.mkdir(parents=True,exist_ok=False)
        receipt=dict(receipt,result='RUNNING',confirmation_of=str(source.resolve()),steps=list(receipt['steps']))
        try:
            state=self.remote('status',receipt['transaction'],identity)
            if not state['running'] or state['boot_id']!=installed['boot_id']:
                raise RuntimeError('Installed process ownership not confirmed')
            snapshot=self.device.connect()
            if snapshot.state is not DeviceState.READY or snapshot.build_id!=int(manifest['build_id'],0):
                raise RuntimeError('Installed Agent is not ready')
            receipt['steps'].append(dict(name='running',result=state))
            receipt.pop('error',None);receipt['result']='PASS'
            return receipt
        except BaseException as error:
            receipt.update(result='FAIL',error=str(error));raise
        finally:
            (output/'receipt.json').write_text(json.dumps(receipt,indent=2,ensure_ascii=False),encoding='utf-8')

    def start_field(self,candidate,output,*,observer_confirmed=False,stop_event=None,progress=lambda text:None):
        if observer_confirmed is not True:raise ValueError('实体手实验需要现场观察确认')
        stop_event=stop_event or threading.Event()
        output=Path(output);output.mkdir(parents=True,exist_ok=False)
        receipt=dict(schema='studio-system-field-v1',transaction=uuid.uuid4().hex,result='RUNNING',
                     candidate=str(candidate),ssh_alias=self.ssh_alias,
                     hand_enabled=True,observer_confirmed=True,steps=[])
        start_attempted=False
        def save():
            (output/'receipt.json').write_text(json.dumps(receipt,indent=2,ensure_ascii=False),encoding='utf-8')
        try:
            manifest=system_board.verify(Path(candidate),exact=True)
            identity=system_board.sha(Path(candidate)/'deployment_manifest.json')
            receipt['manifest_sha256']=identity
            if self.device.expected_build_id!=int(manifest['build_id'],0):raise ValueError('Studio platform differs')
            progress('检查当前系统、灵巧手配对和 USB 身份')
            checked=self.remote('field-check',receipt['transaction'],identity)
            receipt['steps'].append(dict(name='field-check',result=checked));save()
            if socket.gethostbyname(self.device.connection_settings[0]) not in checked['addresses']:
                raise ValueError('SSH 与 Studio 连接目标不同')
            if stop_event.is_set():raise InterruptedError('启动前已取消')
            self.device.disconnect()
            progress('正常交接并启动联合系统；启动检查后启用灵巧手')
            start_attempted=True
            started=self.remote('field-start',receipt['transaction'],identity)
            receipt['steps'].append(dict(name='field-start',result=started));save()
            deadline=time.monotonic()+600
            while self.device.connect().state is not DeviceState.READY:
                if time.monotonic()>deadline or stop_event.wait(3):raise TimeoutError('联合系统启动未确认，查阅收据')
            # Startup-only cached checks; stop all checks before human operation.
            deadline=time.monotonic()+60
            while True:
                status=self.device.video_status()
                receipt['startup_snapshot']=status;save()
                snap=status['snapshot'];vision=snap.get('vision') or {}
                hand=vision.get('hand_session') or {}
                if snap.get('last_error') or vision.get('last_error') or hand.get('error'):
                    raise RuntimeError('联合系统报告启动错误')
                if (hand.get('phase')=='ACTIVE' and hand.get('mode')=='serial-fixed-playback'
                        and hand.get('preview_interlock') is True and hand.get('preview_allowed') is False):break
                if time.monotonic()>deadline or stop_event.wait(2):raise TimeoutError('灵巧手未确认 ACTIVE，查阅启动收据')
            receipt['result']='PASS'
            progress('联合系统已启动，30 分钟现场窗口；回传关闭')
            return receipt
        except BaseException as error:
            receipt.update(result='FAIL',error=str(error))
            if start_attempted:
                try:
                    receipt['failure_stop']=self.remote('stop',receipt['transaction'],identity)
                except Exception as cleanup_error:
                    receipt['failure_stop_error']=str(cleanup_error)
            raise
        finally:save()

    def load(self,candidate,output,*,stop_event=None,progress=lambda message:None):
        stop_event=stop_event or threading.Event()
        candidate=Path(candidate).resolve();output=Path(output).resolve()
        output.mkdir(parents=True,exist_ok=False)
        receipt=dict(schema='studio-system-load-v1',transaction=uuid.uuid4().hex,
                     candidate=str(candidate),ssh_alias=self.ssh_alias,result='RUNNING',steps=[],
                     hand_enabled=False)
        identity=None
        def step(name,value):
            receipt['steps'].append(dict(name=name,result=value))
            (output/'receipt.json').write_text(json.dumps(receipt,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
        def check_cancel():
            if stop_event.is_set():raise InterruptedError('已取消；未确认的板端状态保留在记录中')
        try:
            progress('校验界面系统与配对文件')
            manifest=system_board.verify(candidate,exact=True)
            if self.device.expected_build_id!=int(manifest['build_id'],0):
                raise ValueError('请先将 Studio 目标平台设为 0xC0061000')
            identity=system_board.sha(candidate/'deployment_manifest.json')
            receipt['manifest_sha256']=identity
            step('verified',dict(files=len(manifest['sha256']),build_id=manifest['build_id']))
            archive=output/'package.tar.gz'
            with tarfile.open(archive,'w:gz') as tar:
                for name in sorted(set(manifest['sha256'])|{'deployment_manifest.json'}):
                    tar.add(candidate/name,arcname=name,recursive=False)
            check_cancel()
            progress('检查板卡占用与现有内容库')
            prepared=self.remote('prepare',receipt['transaction'],identity)
            step('preflight',prepared);check_cancel()
            host=self.device.connection_settings[0]
            if socket.gethostbyname(host) not in prepared['addresses']:
                raise ValueError('SSH 主机与 Studio 连接目标不是同一台设备')
            storage=prepared.get('storage')
            if storage:
                # Budget compressed upload, unpacked system, copied old library,
                # and first-launch seed copies before releasing the old task.
                files=[candidate/name for name in manifest['sha256']]
                seed_bytes=sum(p.stat().st_size for p in files if
                    p.relative_to(candidate).parts[0] in ('seed_games','seed_videos'))
                required=(archive.stat().st_size+sum(p.stat().st_size for p in files)
                    +storage['library_bytes']+seed_bytes+16*1024*1024)
                reserve=max(2*1024**3,int(storage['total']*.1))
                if storage['free']-required<reserve:
                    raise OSError(f'板端空间不足：需要 {required+reserve} 字节（含保留空间），'
                                  f'可用 {storage["free"]}；旧任务未停止')
            progress('正常退出旧任务并确认资源释放；完成后才上传')
            self.device.disconnect()
            released=self.remote('quiesce',receipt['transaction'],identity)
            step('quiesced',released)
            if not released.get('stopped') or released.get('owners'):
                raise RuntimeError('Old system release is unconfirmed; upload blocked')
            check_cancel()
            progress('上传已验证系统；保留现有游戏和视频')
            source=self.device.connection_settings[2]
            binding=['-o','BindAddress='+source] if source else []
            self.runner(['scp','-q','-o','BatchMode=yes','-o','ConnectTimeout=20',*binding,str(archive),
                         self.ssh_alias+':'+prepared['archive']],timeout=240)
            step('uploaded',dict(bytes=archive.stat().st_size));check_cancel()
            # Other workspaces are stopped by before_run. Close the old Agent
            # connection before its process is replaced; reconnect only to HELLO.
            self.device.disconnect()
            progress('板端校验并启动新版界面')
            installed=self.remote('install',receipt['transaction'],identity)
            step('installed',installed)
            progress('等待新版启动完成并核对设备身份')
            deadline=time.monotonic()+600
            while True:
                check_cancel()
                try:snapshot=self.device.connect()
                except (OSError,TimeoutError):snapshot=None
                if snapshot is None or snapshot.state is not DeviceState.READY:
                    state=self.remote('status',receipt['transaction'],identity)
                    if not state['running']:
                        raise RuntimeError('启动进程已退出：'+'\n'.join(state.get('console',[])))
                if snapshot is not None and snapshot.state is DeviceState.READY:break
                if time.monotonic()>deadline:raise TimeoutError(snapshot.message if snapshot else 'Agent 连接超时')
                stop_event.wait(3)
            if snapshot.build_id!=int(manifest['build_id'],0):raise RuntimeError('Agent platform mismatch')
            status=self.remote('status',receipt['transaction'],identity)
            step('running',status)
            if not status['running'] or status['boot_id']!=installed['boot_id']:
                raise RuntimeError('New system process did not retain ownership')
            receipt['result']='PASS'
            progress('新版界面已启动；实体手保持未启用，原内容库已保留')
            return receipt
        except BaseException as error:
            receipt.update(result='FAIL',error=f'{type(error).__name__}: {error}')
            if identity and any(s['name']=='installed' for s in receipt['steps']):
                try:step('failure_status',self.remote('status',receipt['transaction'],identity))
                except Exception as status_error:receipt['status_error']=str(status_error)
            raise
        finally:
            (output/'receipt.json').write_text(json.dumps(receipt,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')


