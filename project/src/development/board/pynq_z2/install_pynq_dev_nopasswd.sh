#!/bin/sh
set -eu

sudoers_file=/etc/sudoers.d/xilinx-development-nopasswd
temporary_file=$(mktemp)
trap 'rm -f "$temporary_file"' EXIT

cat > "$temporary_file" <<'EOF'
xilinx ALL=(ALL:ALL) NOPASSWD: ALL
EOF

chmod 0440 "$temporary_file"
visudo -cf "$temporary_file"
install -o root -g root -m 0440 "$temporary_file" "$sudoers_file"
visudo -cf "$sudoers_file"