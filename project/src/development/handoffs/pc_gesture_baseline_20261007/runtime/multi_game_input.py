"""Game-specific, process-local inputs over the unchanged v6 control gates."""
from dataclasses import replace

from four_way_input import FourWayVisionInputProvider
from pynq_multimodal_game.game_sdk import HandGesture


CHOICES = {'0': ('ROCK', HandGesture.FIST),
           '2': ('SCISSORS', HandGesture.SCISSORS),
           '5': ('PAPER', HandGesture.PAPER)}


class ClassifiedController:
    """Carry same-frame stable labels before the worker publishes local input."""
    def __init__(self, controller):
        self.controller = controller

    def __getattr__(self, name):
        return getattr(self.controller, name)

    def update(self, observed, frame, now):
        control = dict(self.controller.update(observed, frame, now))
        stable = observed.get('stable')
        expected = CHOICES.get(stable) if isinstance(stable, str) else None
        # Only explicit stable labels with matching classification are admitted.
        control['stable_gesture'] = stable if expected else None
        control['rps_gesture'] = (expected[0] if expected and
                                  observed.get('rps') == expected[0] else 'UNKNOWN')
        return control


def install_classification(runtime):
    base = runtime.SharedVisionWorker
    if getattr(base, '_multi_game_classification', False):
        return

    class ClassifiedWorker(base):
        _multi_game_classification = True

        def __init__(self, hardware, recognizer, controller, input_provider, **kwargs):
            super().__init__(hardware, recognizer, ClassifiedController(controller),
                             input_provider, **kwargs)

    runtime.SharedVisionWorker = ClassifiedWorker


class MultiGameVisionInputProvider(FourWayVisionInputProvider):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self._classification = None
        self._gesture = None
        self._gesture_sequence = 0

    def _clear_classification(self):
        self._classification = None

    def publish(self, packet, *, config_epoch='default'):
        with self._lock:
            previous = self.receipt
            accepted = super().publish(packet, config_epoch=config_epoch)
            result = accepted.result
            if not result.valid:
                self._clear_classification()
            elif (config_epoch != previous.config_epoch or
                  result.run_id != previous.result.run_id or
                  result.frame_id > previous.result.frame_id):
                control = packet.get('control', {})
                stable = control.get('stable_gesture')
                choice = CHOICES.get(stable) if isinstance(stable, str) else None
                gesture = choice[1] if choice and control.get('rps_gesture') == choice[0] else None
                self._classification = (result.run_id, config_epoch, result.frame_id, gesture)
            return accepted

    def sample_for_game(self, game_id, *, tick_id, timestamp_ns=None):
        with self._lock:
            # Game1 and Game3 retain the exact v6 directional/action behavior.
            sample, receipt = super().sample_with_receipt(
                tick_id=tick_id, timestamp_ns=timestamp_ns)
            receipt['game_id'] = game_id
            if game_id != 'game2':
                return sample, receipt
            identity = (receipt['run_id'], receipt['config_epoch'], receipt['source_frame_id'])
            gesture = (self._classification[3] if sample.hand_valid and
                       self._classification is not None and
                       self._classification[:3] == identity else None)
            changed = gesture != self._gesture
            if changed:
                self._gesture_sequence += 1
                self._gesture = gesture
            # RPS classification must never synthesize or leak a jump event.
            sample = replace(sample, hand_x=0.0, hand_y=0.0, fist_event=False,
                             hand_gesture=gesture, gesture_sequence=self._gesture_sequence,
                             gesture_changed=changed)
            receipt.update(control_mapping='STABLE_RPS', hand_x=0.0, hand_y=0.0,
                           hand_gesture=None if gesture is None else gesture.value,
                           gesture_sequence=self._gesture_sequence, gesture_changed=changed,
                           action_consumed=False, consumed_action_seq=None)
            return sample, receipt

    def suspend(self):
        with self._lock:
            super().suspend()
            self._clear_classification()

    def resume(self):
        with self._lock:
            super().resume()
            self._clear_classification()

    def release(self, message='Vision producer stopped'):
        with self._lock:
            super().release(message)
            self._clear_classification()


def install_game_routing():
    from pynq_multimodal_game.agent import c6i_shell, game_runtime
    from pynq_multimodal_game.game_package import validate_game_package
    import time

    base = game_runtime.PackagedGameRuntime
    if getattr(base, '_multi_game_routing', False):
        return

    class RoutedRuntime(base):
        _multi_game_routing = True

        def __init__(self, package_path, sink, **kwargs):
            # The validated package manifest, not a mutable UI selection, routes input.
            self._input_game_id = validate_game_package(
                package_path, require_extension=False).manifest.game_id
            super().__init__(package_path, sink, **kwargs)

        def _sample_live_input(self, tick_id):
            sampler = getattr(self._live_input, 'sample_for_game', None)
            if callable(sampler):
                return sampler(self._input_game_id, tick_id=tick_id,
                               timestamp_ns=time.monotonic_ns())
            return super()._sample_live_input(tick_id)

    # Both references must agree for shell isinstance checks and test playback.
    game_runtime.PackagedGameRuntime = RoutedRuntime
    c6i_shell.PackagedGameRuntime = RoutedRuntime
