from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
UNIT = ROOT / "board" / "pynq_z2" / "systemd" / "voice-view-shell.service"
INSTALLER = ROOT / "board" / "pynq_z2" / "install_shell_service.sh"


def test_shell_service_uses_c6i_and_persistent_sd_library() -> None:
    unit = UNIT.read_text(encoding="ascii")

    assert "--backend c6i-shell" in unit
    assert "--build-id 0xC0060700" in unit
    assert "--library-root /home/xilinx/voice-view-game/library" in unit
    assert "--shell-settle-seconds 2" in unit
    assert "c6_runtime_return_integrated.bit" in unit
    assert "Restart=on-failure" in unit


def test_shell_service_installer_checks_artifacts_before_enable() -> None:
    installer = INSTALLER.read_text(encoding="ascii")

    assert "c6_runtime_return_integrated.bit" in installer
    assert '"${bitstream%.bit}.hwh"' in installer
    assert "systemctl enable --now voice-view-shell.service" in installer