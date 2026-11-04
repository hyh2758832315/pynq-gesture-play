#!/usr/bin/env bash
# Run: bash scripts/run_host_preview.sh [duration 1..600]
# Output: runtime/camera_host_performance.log, runtime/results/project1_results_*.
# Next: inspect logs/CSV; see docs/GAME_INTERFACE.md. No shutdown/reboot.
set -uo pipefail
task_duration="${1:-60}"
if [[ ! "$task_duration" =~ ^[0-9]+$ ]] || (( 10#$task_duration < 1 || 10#$task_duration > 600 )); then
  printf 'Duration must be an integer from 1 to 600 seconds.\n' >&2
  exit 2
fi
task_timeout=$((10#$task_duration + 90))
task_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$task_root/runtime" || exit 1
timeout --signal=INT "${task_timeout}s" /usr/local/share/pynq-venv/bin/python3 -u \
"$PWD/run_accel_guarded.py" "$PWD/project1_live_ov5640.py" \
"$PWD/camera_hand_skin_v6.bit" "$PWD/first_frame.ppm" \
--live --tracking --host-only --pl-skin --pl-skin-mode performance --debug-view \
--capture-order bgr --rotate 180 --duration "$task_duration" --no-record \
--results-dir "$PWD/results" --bind 192.168.2.99 --port 8088 \
2>&1 | tee camera_host_performance.log
task_status=("${PIPESTATUS[@]}")
printf 'TEST_PIPESTATUS=%s\n' "${task_status[*]}"
exit "${task_status[0]}"
