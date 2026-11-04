#!/bin/sh
set -eu

deploy_dir=/home/xilinx/c2_overlay
runtime_dir=/opt/voice-view-game/c2
evidence_dir=/var/lib/voice-view-game/c2
python_bin=/usr/local/share/pynq-venv/bin/python

install -d -o root -g root -m 0755 "$runtime_dir/pynq_multimodal_game" "$evidence_dir"
install -o root -g root -m 0644 \
    "$deploy_dir/c2_overlay.bit" \
    "$deploy_dir/c2_overlay.hwh" \
    "$deploy_dir/c1_demo_controls.jsonl" \
    "$deploy_dir/verify_c2.py" \
    "$deploy_dir/c2_headless.py" \
    "$runtime_dir/"

for source_file in "$deploy_dir"/pynq_multimodal_game/*.py; do
    install -o root -g root -m 0644 "$source_file" "$runtime_dir/pynq_multimodal_game/"
done

cat > /usr/local/sbin/voice-game-c2-verify <<'EOF'
#!/bin/sh
exec env XILINX_XRT=/usr PYTHONPATH=/opt/voice-view-game/c2 \
    /usr/local/share/pynq-venv/bin/python /opt/voice-view-game/c2/verify_c2.py \
    /opt/voice-view-game/c2/c2_overlay.bit --exercise-inputs \
    --evidence /var/lib/voice-view-game/c2/c2_input_evidence.json
EOF

cat > /usr/local/sbin/voice-game-c2-replay <<'EOF'
#!/bin/sh
exec env XILINX_XRT=/usr PYTHONPATH=/opt/voice-view-game/c2 \
    /usr/local/share/pynq-venv/bin/python /opt/voice-view-game/c2/c2_headless.py \
    /opt/voice-view-game/c2/c2_overlay.bit \
    /opt/voice-view-game/c2/c1_demo_controls.jsonl \
    --report /var/lib/voice-view-game/c2/c2_headless.report.json
EOF

chown root:root /usr/local/sbin/voice-game-c2-verify /usr/local/sbin/voice-game-c2-replay
chmod 0755 /usr/local/sbin/voice-game-c2-verify /usr/local/sbin/voice-game-c2-replay

sudoers_file=/etc/sudoers.d/voice-game-c2
cat > "$sudoers_file" <<'EOF'
Cmnd_Alias VOICE_GAME_C2 = /usr/local/sbin/voice-game-c2-verify, /usr/local/sbin/voice-game-c2-replay
xilinx ALL=(root) NOPASSWD: VOICE_GAME_C2
EOF
chmod 0440 "$sudoers_file"
visudo -cf "$sudoers_file"