"""Opt-in passive game hook and bounded same-host datagram channel.

No ORCA imports, device access, automatic arm, camera sampling or motor commands.
Install only in an independently verified runtime candidate. The controller owner
must bind a fresh channel/game/source identity explicitly; revoke is irreversible.
"""
from dataclasses import asdict, dataclass
import functools
import json
import math
import threading
import time

from .gesture_consumer import GestureObservation

MAX_PACKET = 2048


@dataclass(frozen=True)
class GameObservation:
    game_run: str
    observation: GestureObservation


def identity(value):
    return isinstance(value, str) and 0 < len(value) <= 256


class GameFeed:
    """In-process latest slot; the game producer never waits on a consumer lock."""
    def __init__(self):
        self._lock = threading.Lock()
        self._latest = None
        self._bound_run = None
        self.revoked = None

    def revoke(self, reason):
        # A one-way immutable reference is independent of the try-lock slot.
        if self.revoked is None:
            self.revoked = str(reason)[:160]

    def offer(self, game_run, game_input, receipt, *, now):
        if self.revoked is not None:
            return False
        if not identity(game_run):
            self.revoke('invalid_game_identity')
            return False
        try:
            observation = GestureObservation.from_game(game_input, receipt, observed_at=now)
        except (TypeError, ValueError, AttributeError, KeyError):
            self.revoke('invalid_game_receipt')
            return False
        if not self._lock.acquire(blocking=False):
            return False
        try:
            if self.revoked is not None:
                return False
            if self._bound_run is not None and game_run != self._bound_run:
                self.revoke('game_changed')
                return False
            previous = self._latest
            if previous is not None:
                old = previous.observation
                if (old.run_id, old.config_epoch) != (observation.run_id, observation.config_epoch):
                    self.revoke('vision_source_changed')
                    return False
                if observation.frame_id <= old.frame_id and observation.valid:
                    return False
            self._bound_run = game_run
            self._latest = GameObservation(game_run, observation)
            return True
        finally:
            self._lock.release()

    def read(self):
        with self._lock:
            return self._latest


def install_game_observer(runtime_type, feed, *, clock=time.monotonic):
    """Explicit candidate-only hooks. Returns an identity-checked uninstall.

    The original sample is called exactly once and its result returned untouched.
    pause/stop/test playback permanently revoke this feed; resume cannot re-arm.
    """
    if getattr(runtime_type, '_usb_hand_observer_installed', False):
        raise RuntimeError('A hand observer is already installed')
    originals = {name: getattr(runtime_type, name) for name in ('_sample_live_input', 'pause', 'stop', 'start')}

    @functools.wraps(originals['_sample_live_input'])
    def sample(runtime, *args, **kwargs):
        result = originals['_sample_live_input'](runtime, *args, **kwargs)
        try:
            if runtime._test_case is not None:
                feed.revoke('test_playback')
            elif runtime._paused.is_set():
                feed.revoke('paused')
            else:
                game_input, receipt = result
                feed.offer(runtime._game_run, game_input, receipt, now=clock())
        except Exception:
            # The optional consumer must not change game input or stop rendering.
            feed.revoke('observer_fault')
        return result

    def lifecycle(name):
        original = originals[name]
        @functools.wraps(original)
        def wrapped(runtime, *args, **kwargs):
            if name != 'start':
                feed.revoke(name)
            elif runtime._test_case is not None:
                feed.revoke('test_playback')
            elif feed._bound_run is not None and runtime._game_run != feed._bound_run:
                feed.revoke('game_changed')
            return original(runtime, *args, **kwargs)
        return wrapped

    installed = {'_sample_live_input': sample, **{name:lifecycle(name) for name in ('pause','stop','start')}}
    for name, method in installed.items():
        setattr(runtime_type, name, method)
    runtime_type._usb_hand_observer_installed = True

    def uninstall():
        feed.revoke('uninstalled')
        if any(getattr(runtime_type,name) is not method for name,method in installed.items()):
            raise RuntimeError('Runtime hooks changed; do not overwrite another owner')
        for name, method in originals.items():
            setattr(runtime_type,name,method)
        delattr(runtime_type, '_usb_hand_observer_installed')
    return uninstall


class DatagramPublisher:
    """Call from a separate low-rate worker, never the render/sample callback.

    A connected datagram socket must be supplied by the owner. It must be a
    private same-host channel: monotonic timestamps are not network timestamps.
    """
    def __init__(self, sock, feed, *, session_id):
        if not identity(session_id):
            raise ValueError('Explicit channel session identity required')
        self.sock, self.feed, self.session_id = sock, feed, session_id
        self.sock.setblocking(False)
        self.sequence = 0
        self.dropped = 0

    def publish(self):
        value = self.feed.read()
        self.sequence += 1
        payload = dict(schema='hand-passive-v1', session=self.session_id, sequence=self.sequence,
                       revoked=self.feed.revoked, value=None if value is None else asdict(value))
        packet = json.dumps(payload,separators=(',',':'),allow_nan=False).encode()
        if len(packet) > MAX_PACKET:
            self.feed.revoke('packet_budget')
            return False
        try:
            if self.sock.send(packet) != len(packet):
                self.feed.revoke('partial_datagram')
                return False
            return True
        except (BlockingIOError, OSError):
            self.dropped += 1
            return False


class DatagramReceiver:
    """Bounded drain, latest valid frame, immutable expected identities, fail closed."""
    def __init__(self, sock, *, session_id, game_run, max_age=0.5, budget=32, clock=None,
                 preview_interlock=False, recover_stale=False):
        if not identity(session_id) or not identity(game_run):
            raise ValueError('Explicit channel and game identity required')
        if type(max_age) not in (int,float) or not math.isfinite(max_age) or max_age <= 0:
            raise ValueError('Positive finite freshness budget required')
        if type(budget) is not int or not 1 <= budget <= 64:
            raise ValueError('Bounded receive budget required')
        if clock is not None and not callable(clock):
            raise ValueError('Optional same-host monotonic clock must be callable')
        self.sock, self.session_id, self.game_run = sock, session_id, game_run
        self.sock.setblocking(False)
        self.max_age, self.budget = max_age, budget
        self.sequence, self.latest, self.stopped = 0, None, None
        self.clock = clock
        if type(preview_interlock) is not bool:
            raise ValueError('explicit boolean preview interlock required')
        self.preview_interlock = preview_interlock
        self.preview_resume_generation = None
        if type(recover_stale) is not bool:
            raise ValueError('explicit boolean source recovery required')
        self.recover_stale = recover_stale
        self.waiting_for_fresh = False
        self.overload_waits = 0

    def poll(self, now):
        if self.stopped is not None:
            return None
        if type(now) not in (int,float) or not math.isfinite(now) or now < 0:
            raise ValueError('Same-host monotonic time required')
        try:
            for _ in range(self.budget):
                try:
                    packet = self.sock.recv(MAX_PACKET+1)
                except BlockingIOError:
                    break
                if len(packet) > MAX_PACKET:
                    raise ValueError('oversized_packet')
                data = json.loads(packet)
                if (type(data) is not dict or set(data) != {'schema','session','sequence','revoked','value'}
                        or data['schema'] != 'hand-passive-v1' or data['session'] != self.session_id
                        or type(data['sequence']) is not int or data['sequence'] < 1):
                    raise ValueError('channel_identity')
                if data['revoked'] is not None:
                    reason = data['revoked']
                    def generation(kind):
                        prefix='preview_'+kind+':'
                        if not self.preview_interlock or not isinstance(reason,str) or not reason.startswith(prefix):
                            return None
                        digits=reason[len(prefix):]
                        return (int(digits) if 1 <= len(digits) <= 9 and digits.isascii()
                                and digits.isdigit() and digits[0]!='0' else None)
                    pause,resume=generation('pause'),generation('resume')
                    if pause is not None and data['value'] is None:
                        raise ValueError(reason)
                    if resume is not None and data['value'] is not None:
                        self.preview_resume_generation=resume
                    else:
                        raise ValueError('producer_revoked')
                if data['sequence'] <= self.sequence:
                    continue
                self.sequence = data['sequence']
                value = data['value']
                if value is None:
                    continue
                if type(value) is not dict or set(value) != {'game_run','observation'} or value['game_run'] != self.game_run:
                    raise ValueError('game_identity')
                candidate = GestureObservation(**value['observation'])
                # A packet may arrive after the caller sampled ``now``. Real
                # channels resample the same-host clock after recv; explicit
                # timestamps remain useful for deterministic replay tests.
                received_at = now if self.clock is None else self.clock()
                if (not math.isfinite(received_at) or received_at < now
                        or candidate.observed_at > received_at):
                    raise ValueError('invalid_source_clock' if self.recover_stale else 'stale_source')
                old = self.latest
                if old is not None:
                    if (old.run_id,old.config_epoch) != (candidate.run_id,candidate.config_epoch):
                        raise ValueError('source_identity')
                    if candidate.frame_id <= old.frame_id and candidate.valid:
                        continue
                self.latest = candidate
            else:
                if self.recover_stale:
                    # CPU scheduling gaps can accumulate ordinary datagrams.
                    # Yield after the fixed budget; never approve the partial
                    # tail, and keep checking every packet's identity/revocation.
                    # The next lifecycle tick continues draining without a queue
                    # of actuator requests or an unbounded busy receive loop.
                    self.overload_waits += 1
                    self.waiting_for_fresh = True
                    return None
                raise ValueError('receive_budget')
            # Check freshness only after the bounded drain selected the newest
            # frame. Superseded old datagrams must never hide a fresh tail.
            checked_at = now if self.clock is None else self.clock()
            if not math.isfinite(checked_at) or checked_at < now:
                raise ValueError('invalid_source_clock' if self.recover_stale else 'stale_source')
            if self.latest is not None and checked_at-self.latest.source_at > self.max_age:
                if self.recover_stale:
                    self.waiting_for_fresh = True
                    return None
                raise ValueError('stale_source')
            self.waiting_for_fresh = False
            return self.latest
        except (OSError,TypeError,ValueError,KeyError,UnicodeError) as error:
            self.stopped = str(error)[:160]
            self.latest = None
            return None
