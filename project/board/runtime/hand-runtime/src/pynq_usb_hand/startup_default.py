"""One bounded startup correction; never relax normal motion calibration."""

import math

from .motion import FeedbackCancellation
from .orca_backend import OrcaBackend


COUNT = 2 * math.pi / 4096
MAX_EXCURSION = 16
MAX_TRAVEL = 64
RECOVERY_SPEED = 50
RECOVERY_SECONDS = 3.0
STALL_SECONDS = 0.5
POLL_SECONDS = 0.02
# The first board trace settled at raw 43 for target 46. Keep a small explicit
# arrival window inside the original calibration, instead of demanding encoder
# equality or treating this near-target settlement as an unrecovered fault.
TARGET_TOLERANCE = 4


class StartupDefaultBackend(OrcaBackend):
    """Correct one slightly out-of-range motor to its captured default.

    Connection is still read-only. Recovery runs only inside the owner's
    explicitly authorized arm action, before normal all-motor enable. Speed is
    reduced, but this is NOT force limiting; persistent torque limits are kept.
    """

    def __init__(self, *args, recovery_report, **kwargs):
        super().__init__(*args, **kwargs)
        self.recovery_report = recovery_report
        self.startup_plan = None
        self.startup_failed = False
        self.startup_consumed = False
        self.recovery = dict(schema="hand-startup-default-v1", status="unchecked",
                             attempted=False, samples=[], release_failed_ids=None)

    def emit(self, status):
        self.recovery["status"] = status
        self.recovery_report(self.recovery)

    def startup_scan(self, cancel):
        bounds = {mid: (lo - MAX_EXCURSION * COUNT - 1e-10,
                        hi + MAX_EXCURSION * COUNT + 1e-10)
                  for mid, (lo, hi) in self.model.bounds.items()}
        _, _, motor = self.read_motor_positions(
            cancel, bounds=bounds, torques=dict.fromkeys(self.model.ids, 0))
        outside = [mid for mid, value in motor.items()
                   if not self.model.bounds[mid][0] <= value <= self.model.bounds[mid][1]]
        if not outside:
            return None
        if len(outside) != 1:
            raise ValueError("Startup default requires exactly one slightly out-of-range motor")
        mid = outside[0]
        raw = round(motor[mid] / COUNT)
        target = round(self.model.to_motor(self.poses["default"])[mid] / COUNT)
        lo, hi = self.model.bounds[mid]
        if (abs(target - raw) > MAX_TRAVEL
                or not lo + TARGET_TOLERANCE * COUNT < target * COUNT < hi - TARGET_TOLERANCE * COUNT):
            raise ValueError(f"Startup default target too far or too close to a limit ID {mid}")
        return dict(motor_id=mid, initial_raw=raw, target_raw=target)

    def check_connected_position(self, cancel):
        self.startup_plan = self.startup_scan(cancel)
        self.recovery["plan"] = self.startup_plan
        self.emit("eligible" if self.startup_plan else "not_needed")

    def arm(self, cancel):
        if self.startup_failed:
            raise RuntimeError("Startup default failed; automatic retry is forbidden")
        if not self.startup_consumed:
            self.startup_consumed = True
            if self.startup_plan is not None:
                try:
                    self.recover_default(cancel)
                except BaseException:
                    self.startup_failed = True
                    raise
        # Resumes and all ordinary samples retain the original strict checks.
        super().arm(cancel)

    def recover_default(self, parent):
        cancel = FeedbackCancellation(parent, parent.clock() + RECOVERY_SECONDS)
        plan = self.startup_scan(cancel)
        if plan is None:
            self.emit("no_longer_needed")
            return
        if (plan["motor_id"] != self.startup_plan["motor_id"]
                or abs(plan["initial_raw"] - self.startup_plan["initial_raw"]) > 2):
            raise ValueError("Startup position changed before authorized recovery")
        mid, initial, target = (plan[key] for key in ("motor_id", "initial_raw", "target_raw"))
        bounds = dict(self.model.bounds)
        bounds[mid] = ((min(initial, target) - 1) * COUNT,
                       (max(initial, target) + 1) * COUNT)
        torques = dict.fromkeys(self.model.ids, 0)
        torques[mid] = 1
        servo = self.client.servo
        self.recovery.update(attempted=True, plan=plan, speed=RECOVERY_SPEED,
                             target_tolerance_counts=TARGET_TOLERANCE)
        self.emit("recovering")  # Evidence must be writable before any command.
        error = None
        failed = ()
        try:
            cancel.check()
            # Set the reviewed goal while OFF; never enable a stale servo goal.
            with self.transport.transaction(cancel):
                comm, device = servo.WritePos(mid, target, 0, RECOVERY_SPEED)
                self.checked((target, comm, device), mid, "startup_default_target")
            cancel.check()
            with self.transport.transaction(cancel):
                comm, device = servo.write1ByteTxRx(mid, 40, 1)
                self.checked((1, comm, device), mid, "startup_default_enable")
            best = abs(target - initial)
            progress_at = cancel.clock()
            settled = 0
            while True:
                _, _, motor = self.read_motor_positions(cancel, bounds=bounds, torques=torques)
                raw = round(motor[mid] / COUNT)
                distance = abs(target - raw)
                self.recovery["samples"].append(raw)
                self.recovery["samples"] = self.recovery["samples"][-64:]
                if distance > best + 2:
                    raise OSError("Startup default moved away from the target")
                if distance < best:
                    best, progress_at = distance, cancel.clock()
                settled = settled + 1 if distance <= TARGET_TOLERANCE else 0
                if settled >= 2:
                    break
                if not settled and cancel.clock() - progress_at >= STALL_SECONDS:
                    raise TimeoutError("Startup default stalled; possible obstruction")
                cancel.wait(POLL_SECONDS)
        except BaseException as caught:
            error = caught
        finally:
            # Independent of cancellation: OFF + all 17 readbacks, including
            # lost enable ACKs. The controller also retains its outer release.
            try:
                failed = self.release()
                self.recovery["release_failed_ids"] = list(failed)
            except BaseException as caught:
                self.recovery["release_error"] = f"{type(caught).__name__}: {caught}"
                if error is None:
                    error = caught
        if failed and error is None:
            error = OSError(f"Startup default OFF unconfirmed IDs {failed}")
        if error is None:
            try:
                self.sample(cancel)  # Strict calibrated-range recheck while OFF.
            except BaseException as caught:
                error = caught
        if error is not None:
            self.recovery["error"] = f"{type(error).__name__}: {error}"
            self.emit("failed")
            raise error
        self.emit("recovered")
