"""PS lifecycle for an opt-in serial owner, independent of render/game loops.

Unlike the memory-only probe, this owner never terminates a child to make a
timeout look clean. Unknown child exit or missing OFF receipt stays a fault.
"""

from __future__ import annotations

import json
import hashlib
import math
import os
from pathlib import Path
import socket
import sys
import subprocess
import threading
import time
from uuid import uuid4


# A source may already be 300--400 ms old when PS receives it. Keep the
# nonblocking latest-slot handoff below the remaining 500 ms freshness margin.
SERIAL_PUBLISH_SECONDS = .05


class SerialHandActionSession:
    def __init__(self, feed, *, gate, entry: Path, output_dir: Path, stage_waits,
                 seconds: float | None = None, approval_seconds: float | None = None):
        from .hand_shadow_bridge import verify_serial_child
        from pynq_usb_hand.motion import MotionSettings

        if gate.passed is not True or gate.report_path is None:
            raise RuntimeError("serial motion requires a passed read-only startup gate")
        if seconds is not None and (type(seconds) not in (int, float)
                                    or not math.isfinite(seconds) or seconds <= 0):
            raise ValueError("optional serial lifetime must be finite and positive")
        verified = verify_serial_child(entry.parent.parent)
        if verified != entry.resolve(strict=True):
            raise ValueError("serial entry identity mismatch")
        self.stage_waits = MotionSettings.fixed_playback(stage_waits=stage_waits).stage_waits
        if approval_seconds is not None and (type(approval_seconds) not in (int, float)
                or not math.isfinite(approval_seconds) or not 0 < approval_seconds <= 10):
            raise ValueError("approval window must be finite, positive and at most ten seconds")
        self.approval_seconds = approval_seconds
        self.feed, self.gate, self.entry = feed, gate, verified
        self.output_dir = output_dir.absolute()
        self.seconds = seconds
        self.session = uuid4().hex
        self.error = None
        self.finished = threading.Event()
        self._stop = threading.Event()
        self._thread = None
        self._child = None
        self._active = False
        self._release_confirmed = None
        self._source_stop_reason = None
        self._preview_requested = None
        self._video_paused = False
        self._preview_allowed = False
        self._control_phase = None
        self._pause_generation = None
        self._generation = 0
        self._control_mtime = None
        self._preview_idle = lambda: True
        self._page_lock = threading.Lock()
        self._page_mode = "idle"
        self._page_generation = 0
        self._page_last_write = -1.
        self._page_status = None
        self._page_mtime = None
        self._page_last_poll = None

    def set_page_mode(self, mode, *, restart=False):
        if mode not in ('idle', 'live', 'demo'):
            raise ValueError('Unknown hand page mode')
        with self._page_lock:
            if mode != self._page_mode or restart:
                self._page_mode = mode
                self._page_generation += 1
                self._page_last_write = -1.
            return self._page_generation

    def page_status(self):
        with self._page_lock:
            value = self._page_status
            if value is None or value.get('generation') != self._page_generation:
                return dict(phase='WAITING',generation=self._page_generation,pose='default',index=0,off=False)
            if self._page_last_poll is None or time.monotonic()-self._page_last_poll>=2:
                return dict(value,phase='WAITING_COMMAND',off=False,release_confirmed_ids=[])
            return dict(value)

    def _publish_page(self):
        if not hasattr(self, '_source'):
            return
        now = time.monotonic()
        value=None
        with self._page_lock:
            if now-self._page_last_write >= .5:
                value = dict(schema='hand-page-command-v1', session=self.session,game_run=self._source,
                             mode=self._page_mode,generation=self._page_generation,sent_at=now)
        # The lifecycle thread is the sole writer. Never hold the HDMI/menu
        # state lock across storage I/O; a return may supersede this snapshot.
        if value is not None:
            temporary=self.output_dir/'page-command.tmp'
            temporary.write_text(json.dumps(value),encoding='utf-8')
            try:
                temporary.replace(self.output_dir/'page-command.json')
            except PermissionError:
                if os.name!='nt': raise
            else:
                with self._page_lock:
                    if self._page_generation==value['generation']:
                        self._page_last_write=now
        path=self.output_dir/'page-state.json'
        try:
            stamp=path.stat().st_mtime_ns
            if stamp==self._page_mtime:
                with self._page_lock:self._page_last_poll=time.monotonic()
                return
            value=json.loads(path.read_text(encoding='utf-8'))
        except (FileNotFoundError,json.JSONDecodeError):
            return
        except PermissionError:
            if os.name!='nt': raise
            return
        if (value.get('schema')!='hand-page-state-v1' or value.get('session')!=self.session
                or value.get('game_run')!=self._source):
            raise ValueError('Hand page receipt identity mismatch')
        if value.get('off') is True and (value.get('lifecycle')!='CONNECTED_OFF'
                or value.get('enable_epoch') is not None
                or value.get('release_confirmed_ids')!=list(range(1,18))):
            raise ValueError('Hand page transfer requires confirmed 17 motor OFF receipt')
        with self._page_lock:
            if type(value.get('generation')) is not int or value['generation']>self._page_generation:
                raise ValueError('Hand page receipt generation mismatch')
            self._page_status=value
            self._page_mtime=stamp
            self._page_last_poll=time.monotonic()

    def attach_preview(self, preview, encoder=None):
        if self._thread is not None or self._preview_requested is not None:
            raise RuntimeError('preview interlock must attach once before hand start')
        if not callable(getattr(preview, 'requested_modes', None)) or preview.allow_preview is not None:
            raise ValueError('unowned preview interlock required')
        # A busy HTTP lock is not an unsubscribe event. Only this low-rate
        # lifecycle thread takes the reliable subscription snapshot.
        self._preview_requested = lambda: preview.requested_modes(blocking=True)
        if encoder is not None:
            if not callable(getattr(encoder,'idle',None)):
                raise ValueError('preview encoder must expose bounded idle confirmation')
            self._preview_idle = encoder.idle
        preview.allow_preview = lambda: self._preview_allowed

    def _requested(self):
        return bool(getattr(self, '_video_paused', False)
                    or (self._preview_requested is not None and self._preview_requested()))

    def set_video_paused(self, paused):
        """Reuse the existing OFF/fresh-resume handshake; no new worker or queue."""
        if type(paused) is not bool:
            raise TypeError('video pause must be boolean')
        self._video_paused = paused

    def status(self):
        if self.finished.is_set():
            phase = "FAULT" if self.error else "CLOSED"
        elif self._stop.is_set():
            phase = "CLOSING"
        elif self._control_phase is not None:
            phase = self._control_phase
        elif self._active:
            phase = "ACTIVE"
        elif self._child is not None:
            phase = "STARTING"
        else:
            phase = "WAITING_SOURCE" if self._thread is not None else "NEW"
        return {"schema": "hand-session-status-v1", "mode": "serial-fixed-playback",
                "max_seconds": self.seconds,
                "approval_seconds": self.approval_seconds,
                "preview_interlock": self._preview_requested is not None,
                "video_paused": getattr(self, '_video_paused', False),
                "preview_allowed": self._preview_allowed,
                "phase": phase, "session": self.session,
                "child_pid": None if self._child is None else self._child.pid,
                "release_confirmed": self._release_confirmed, "error": self.error,
                "release_not_required": self._child is None and self.gate.passed is True,
                "source_stop_reason": self._source_stop_reason}

    def _update_preview(self):
        if (self._preview_requested is None and not getattr(self, '_video_paused', False)
                and self._pause_generation is None):
            return
        requested = self._requested()
        if requested and self._pause_generation is None:
            self._generation += 1
            self._pause_generation = self._generation
            self._preview_allowed = False
            self._control_phase = 'PAUSING'
        elif not requested and self._pause_generation is not None:
            self._preview_allowed = False
            if self._preview_idle():
                self._pause_generation = None
                self._control_phase = 'RESUMING'
        if requested and self._control_phase == 'PAUSED':
            # This generation's OFF receipt was already validated. Keep its
            # UDP lease independent of storage while the child remains OFF.
            # Child exit is checked by the owner loop before each heartbeat.
            return
        path = self.output_dir/'control-state.json'
        try:
            stamp = path.stat().st_mtime_ns
            if stamp == self._control_mtime:
                return
            value = json.loads(path.read_text(encoding='utf-8'))
        except (FileNotFoundError, json.JSONDecodeError):
            return
        if (value.get('schema') != 'hand-preview-interlock-v1' or value.get('pid') != self._child.pid
                or value.get('session') != self.session or value.get('game_run') != self._source
                or value.get('actuator') != 'serial-fixed-playback'):
            raise ValueError('preview interlock receipt identity mismatch')
        controller = value.get('controller') or {}
        generation = value.get('pause_generation')
        if type(generation) is not int or generation < 0 or controller.get('error') is not None:
            raise ValueError('preview interlock receipt state mismatch')
        if value.get('phase') == 'PAUSED':
            if (controller.get('lifecycle') != 'CONNECTED_OFF'
                    or controller.get('enable_epoch') is not None
                    or value.get('release_confirmed_ids') != list(range(1,18))):
                raise ValueError('preview requires confirmed 17 motor OFF receipt')
            if requested and generation == self._pause_generation:
                self._control_phase = 'PAUSED'
                self._preview_allowed = True
        elif value.get('phase') in ('WAITING_SOURCE', 'WAITING_SOURCE_OFF'):
            if value['phase'] == 'WAITING_SOURCE_OFF' and (
                    controller.get('lifecycle') != 'CONNECTED_OFF'
                    or controller.get('enable_epoch') is not None
                    or value.get('release_confirmed_ids') != list(range(1,18))):
                raise ValueError('source wait requires confirmed 17 motor OFF receipt')
            if not requested and self._pause_generation is None:
                self._control_phase = value['phase']
            self._preview_allowed = False
        elif value.get('phase') == 'ACTIVE':
            if controller.get('lifecycle') != 'READY_IDLE' or not controller.get('enable_epoch'):
                raise ValueError('preview resume requires armed controller receipt')
            if not requested and generation == self._generation:
                self._control_phase = None
        else:
            raise ValueError('unknown preview interlock phase')
        self._control_mtime = stamp

    def start(self):
        if self._thread is not None:
            raise RuntimeError("serial hand session cannot restart")
        self.output_dir.mkdir(mode=0o700, parents=False, exist_ok=False)
        self._thread = threading.Thread(target=self._run, name="hand-serial-publisher", daemon=False)
        self._thread.start()

    def close(self):
        self._stop.set()
        self.feed.revoke("serial_owner_close")
        if self._thread is not None:
            self._thread.join(35)
            if self._thread.is_alive():
                raise TimeoutError("serial hand owner cleanup remains unconfirmed")
        if self._child is not None:
            exit_code = self._child.poll()
            if exit_code is None:
                raise RuntimeError("serial hand child still owns process; physical release UNKNOWN")
            if self.finished.is_set() and self._release_confirmed is not True:
                # The bounded parent wait can finish before a slow child exits.
                # Only this explicit close retry may consume its late receipt;
                # never add a polling worker, re-arm, or infer OFF from exit alone.
                try:
                    receipt = json.loads((self.output_dir / "serial-motion.json").read_text(encoding="utf-8"))
                except (OSError,ValueError) as error:
                    raise RuntimeError(self.error or 'Missing child shutdown receipt') from error
                try:
                    self._verify_release(receipt, self._source, exit_code)
                except Exception:
                    try:
                        self._recheck_closed_child_off(receipt, exit_code)
                    except Exception as recovery_error:
                        raise RuntimeError(self.error or "serial child late OFF verification failed") from recovery_error
                else:
                    try:
                        record = dict(schema="hand-late-release-v1", session=self.session,
                                      game_run=self._source, child_pid=self._child.pid,
                                      child_exit=exit_code, release_confirmed=True,
                                      error=self.error, child_receipt=receipt)
                        temporary = self.output_dir / "cleanup-release.tmp"
                        temporary.write_text(json.dumps(record, indent=2), encoding="utf-8")
                        temporary.replace(self.output_dir / "cleanup-release.json")
                    except Exception as error:
                        raise RuntimeError(self.error or "serial child late OFF receipt failed") from error
                self._release_confirmed = True
                self._preview_allowed = True
                self._source_stop_reason = receipt.get("receiver_stop") or receipt.get("stop_reason")
        if self.error is not None and self._release_confirmed is not True:
            raise RuntimeError(self.error)

    def _recheck_closed_child_off(self, receipt, exit_code):
        """Shutdown-only proof; retain the original fault and never arm again."""
        from .hand_startup import HandStartupGate
        if (sys.platform != 'linux' or type(exit_code) is not int
                or self._child.poll() is None or receipt.get('backend_closed') is not True
                or receipt.get('session') != self.session
                or receipt.get('game_run') != self._source
                or receipt.get('actuator') != 'serial-fixed-playback'):
            raise RuntimeError('OFF recheck requires the same exited and closed child')
        port=Path(self.gate.port).resolve(strict=True)
        for fd in Path('/proc').glob('[0-9]*/fd/*'):
            try:
                if fd.resolve()==port:raise RuntimeError('OFF recheck serial port still owned')
            except (FileNotFoundError,ProcessLookupError,PermissionError):
                continue
        probe=HandStartupGate(root=self.gate.root,python=self.gate.python,port=self.gate.port,
                              report_dir=self.output_dir/'shutdown-off-recheck')
        if probe() is not True:raise RuntimeError('Shutdown OFF probe did not pass')
        original=self.output_dir/'serial-motion.json'
        record=dict(schema='hand-off-recheck-v1',session=self.session,game_run=self._source,
                    child_pid=self._child.pid,child_exit=exit_code,original_error=self.error,
                    original_sha256=hashlib.sha256(original.read_bytes()).hexdigest(),
                    probe_path=str(probe.report_path),
                    probe_sha256=hashlib.sha256(probe.report_path.read_bytes()).hexdigest())
        target=self.output_dir/'cleanup-off-recheck.json'
        target.write_text(json.dumps(record,indent=2),encoding='utf-8')

    def _run(self):
        from pynq_usb_hand.game_bridge import DatagramPublisher

        sock = publisher = None
        report = {"schema": "vision-hand-serial-parent-v1", "session": self.session,
                  "actuator": "serial-fixed-playback", "child_started": False}
        started = time.monotonic()
        source = None
        deadline = None
        try:
            deadline = None if self.seconds is None else started + self.seconds
            while not self._stop.is_set() and (deadline is None or time.monotonic() < deadline):
                if self._requested():
                    # Initial read-only gate already proved OFF. Do not load a
                    # hand child just to stop it while preview was requested.
                    self._control_phase = 'PAUSED'
                    self._preview_allowed = True
                    self._stop.wait(.2)
                    continue
                self._preview_allowed = False
                if not self._preview_idle():
                    self._control_phase = 'PAUSED'
                    self._stop.wait(.1)
                    continue
                self._control_phase = None
                value = self.feed.read()
                if self.feed.revoked is not None:
                    break
                if value is None:
                    self._stop.wait(SERIAL_PUBLISH_SECONDS)
                    continue
                source = value.game_run
                self._source = source
                sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
                sock.bind(("127.0.0.1", 0))
                command = [str(self.gate.python), "-I", "-B", str(self.entry),
                           "--hand-root", str(self.gate.root), "--session", self.session,
                           "--game-run", source, "--peer-port", str(sock.getsockname()[1]),
                           "--output-dir", str(self.output_dir),
                           "--port", self.gate.port, "--enable-motion", "--stage-waits",
                           *(str(value) for value in self.stage_waits)]
                if self.seconds is not None:
                    command.extend(("--seconds", str(self.seconds)))
                if self.approval_seconds is not None:
                    command.extend(("--approval-seconds", str(self.approval_seconds)))
                if self._preview_requested is not None:
                    command.append('--preview-interlock')
                command.extend(("--page-control",))
                if "--preview-interlock" not in command: command.append("--preview-interlock")
                self._publish_page()
                with (self.output_dir / "child-stdout.log").open("xb") as out, (
                        self.output_dir / "child-stderr.log").open("xb") as err:
                    self._child = subprocess.Popen(command, stdin=subprocess.DEVNULL,
                                                   stdout=out, stderr=err)
                self._release_confirmed = False
                report.update(child_started=True, child_pid=self._child.pid, game_run=source)
                ready = self._await_receipt("ready.json", source, timeout=15)
                address = ready.get("address")
                if (not isinstance(address, list) or len(address) != 2
                        or address[0] != "127.0.0.1" or type(address[1]) is not int
                        or not 0 < address[1] < 65536):
                    raise ValueError("serial child local address mismatch")
                sock.connect(tuple(address))
                owner = self
                class ControlFeed:
                    value = None
                    @property
                    def revoked(inner):
                        if owner.feed.revoked is not None:
                            return owner.feed.revoked
                        if owner._pause_generation is not None:
                            return 'preview_pause:' + str(owner._pause_generation)
                        if owner._control_phase == 'RESUMING':
                            return ('preview_resume:' if inner.value is not None else 'preview_pause:')+str(owner._generation)
                        return None
                    def read(inner):
                        inner.value=None if owner._pause_generation is not None else owner.feed.read()
                        return inner.value
                publisher = DatagramPublisher(sock, ControlFeed(), session_id=self.session)
                self._await_receipt("active.json", source, timeout=15, publisher=publisher)
                self._active = True
                while not self._stop.is_set() and (deadline is None or time.monotonic() < deadline):
                    if self._child.poll() is not None or self.feed.revoked is not None:
                        break
                    self._update_preview()
                    # A paused child never reads page commands. Avoid unused
                    # SD writes delaying its OFF heartbeat during video I/O.
                    # Resume refreshes the page before sending fresh input.
                    if self._pause_generation is None:
                        self._publish_page()
                    publisher.publish()
                    idle_page=self._page_mode=='idle' and self.page_status().get('off')
                    self._stop.wait(.2 if self._control_phase == 'PAUSED' or idle_page else SERIAL_PUBLISH_SECONDS)
                break
        except Exception as error:
            self.error = f"{type(error).__name__}: {error}"
        finally:
            self._preview_allowed = False
            cleanup_errors = []

            def cleanup_error(stage, error):
                message = f"{type(error).__name__}: {error}"
                self.error = self.error or message
                cleanup_errors.append(dict(stage=stage, error=message))

            try:
                try:
                    self.feed.revoke("serial_session_finished")
                    if publisher is not None:
                        publisher.publish()
                except Exception as error:
                    # A failed best-effort notification cannot skip the child's
                    # bounded wait and OFF receipt. Its lease still owns safety.
                    cleanup_error("source_notification", error)
                if self._child is not None:
                    try:
                        # Never kill a serial owner to make cleanup look clean.
                        report["child_exit"] = self._child.wait(timeout=15)
                        receipt = json.loads((self.output_dir / "serial-motion.json").read_text(encoding="utf-8"))
                        self._verify_release(receipt, source, report["child_exit"])
                        self._release_confirmed = True
                        report["child_receipt"] = receipt
                        self._source_stop_reason = receipt.get('receiver_stop') or receipt.get('stop_reason')
                        source_error = self._child_source_error(receipt,
                            expected_stop=self._stop.is_set() or
                            (deadline is not None and time.monotonic() >= deadline))
                        self.error = self.error or source_error
                        if report["child_exit"] != 0 or receipt.get("error") is not None or receipt.get("active") is not True:
                            self.error = self.error or "serial child failed: " + str(receipt.get("error"))
                    except Exception as error:
                        cleanup_error("child_release", error)
                if sock is not None:
                    try:
                        sock.close()
                    except Exception as error:
                        cleanup_error("socket_close", error)
                # Proven OFF may release unrelated preview work even when the
                # transport fault remains visible as FAULT in the hand status.
                if self._child is None or self._release_confirmed is True:
                    self._preview_allowed = True
                report.update(error=self.error, cleanup_errors=cleanup_errors,
                              release_confirmed=self._release_confirmed,
                              release_not_required=self._child is None and self.gate.passed is True,
                              feed_revoked=self.feed.revoked, elapsed=time.monotonic() - started)
                try:
                    with (self.output_dir / "parent.json").open("x", encoding="utf-8") as out:
                        json.dump(report, out, indent=2)
                except Exception as error:
                    cleanup_error("parent_receipt", error)
            finally:
                self.finished.set()

    @staticmethod
    def _child_source_error(receipt, *, expected_stop):
        """A confirmed OFF receipt does not turn a source failure into success."""
        receiver = receipt.get('receiver_stop')
        reason = receipt.get('stop_reason')
        if receiver == 'producer_revoked' and expected_stop:
            return None
        if receiver is not None:
            return 'serial source failed: ' + str(receiver)
        if reason in ('duration_complete', 'owner_stop'):
            return None
        return 'serial source stopped unexpectedly: ' + str(reason)

    def _await_receipt(self, name, source, *, timeout, publisher=None):
        deadline = time.monotonic() + timeout
        while not self._stop.is_set():
            self._publish_page()
            if self._child.poll() is not None:
                raise RuntimeError("serial child exited before " + name)
            if time.monotonic() >= deadline:
                raise TimeoutError("serial child receipt deadline: " + name)
            if publisher is not None:
                publisher.publish()
            try:
                value = json.loads((self.output_dir / name).read_text(encoding="utf-8"))
            except (FileNotFoundError, json.JSONDecodeError):
                self._stop.wait(.05)
                continue
            if (value.get("pid") != self._child.pid or value.get("session") != self.session
                    or value.get("game_run") != source
                    or value.get("actuator") != "serial-fixed-playback"):
                raise ValueError("serial child receipt identity mismatch: " + name)
            if value.get("approval_seconds") != self.approval_seconds:
                raise ValueError("serial child approval window mismatch: " + name)
            return value
        raise RuntimeError("serial owner stopped during startup")

    def _verify_release(self, receipt, source, exit_code):
        controller = receipt.get("controller") or {}
        if (receipt.get("schema") != "vision-hand-actuator-owner-v1"
                or receipt.get("session") != self.session or receipt.get("game_run") != source
                or receipt.get("actuator") != "serial-fixed-playback"
                or receipt.get("arm_attempted") is not True
                or receipt.get("backend_closed") is not True
                or receipt.get("release_confirmed") is not True
                or receipt.get("release_confirmed_ids") != list(range(1, 18))
                or not receipt.get("release_attempts")
                or receipt["release_attempts"][-1] != {"failed_ids": [], "error": None}
                or controller.get("lifecycle") != "CLOSED" or controller.get("error") is not None):
            raise RuntimeError("serial child final OFF receipt mismatch; physical release UNKNOWN")
