#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
    printf 'Run with sudo -n: %s\n' "$0" >&2
    exit 1
fi

deploy_root=/home/xilinx/voice-view-game/shell
library_root=/home/xilinx/voice-view-game/library
unit_source="${deploy_root}/board/pynq_z2/systemd/voice-view-shell.service"
bitstream="${deploy_root}/board/pynq_z2/output/c6_runtime_return_integrated.bit"
hwh="${bitstream%.bit}.hwh"

for required in "$unit_source" "$bitstream" "$hwh"; do
    if [[ ! -f "$required" ]]; then
        printf 'Missing required deployment file: %s\n' "$required" >&2
        exit 1
    fi
done

install -d -m 0755 "$library_root" "$library_root/games" "$library_root/videos" \
    "$library_root/images" "$library_root/.staging"
install -m 0644 "$unit_source" /etc/systemd/system/voice-view-shell.service
systemctl daemon-reload
systemctl enable --now voice-view-shell.service
systemctl --no-pager --full status voice-view-shell.service