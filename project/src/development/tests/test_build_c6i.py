from pathlib import Path


ROOT = Path(__file__).parents[1]
SHARED_BUILD = ROOT / "board" / "pynq_z2" / "scripts" / "build_c4m3.tcl"
C4M7_BUILD = ROOT / "board" / "pynq_z2" / "scripts" / "build_c4m7.tcl"
C6I_BUILD = ROOT / "board" / "pynq_z2" / "scripts" / "build_c6i.tcl"
CDC_CONSTRAINTS = ROOT / "board" / "pynq_z2" / "constraints" / "c4m3_cdc.xdc"


def test_return_path_is_opt_in_and_c4m7_stays_frozen() -> None:
    shared = SHARED_BUILD.read_text(encoding="utf-8")
    c4m7 = C4M7_BUILD.read_text(encoding="utf-8")
    c6i = C6I_BUILD.read_text(encoding="utf-8")

    assert "set enable_return_path 0" in shared
    assert "set enable_return_path" not in c4m7
    assert "set enable_return_path 1" in c6i
    assert "set post_route_phys_opt_directive AggressiveExplore" in c6i
    assert "set build_id 0xC0060700" in c6i
    assert "set project_name c6_runtime_return_integrated" in c6i


def test_c6i_reuses_c6t_return_addresses() -> None:
    shared = SHARED_BUILD.read_text(encoding="utf-8")
    expected = {
        "RETURN_DMA_CONTROL_ADDRESS=0x40410000",
        "RETURN_CONTROL_ADDRESS=0x41380000",
        "RETURN_START_ADDRESS=0x41390000",
        "RETURN_STATUS_ADDRESS=0x413A0000",
        "RETURN_STATE_ADDRESS=0x413B0000",
    }

    assert "INPUT_GPIO_ADDRESS=0x41370000" in shared
    for assignment in expected:
        assert assignment in shared


def test_return_state_gpio_preserves_c6t_channel_widths() -> None:
    shared = SHARED_BUILD.read_text(encoding="utf-8")

    assert "CONFIG.C_ALL_INPUTS {1} CONFIG.C_GPIO_WIDTH {1}" in shared
    assert "CONFIG.C_ALL_INPUTS_2 {1} CONFIG.C_GPIO2_WIDTH {32}" in shared


def test_return_dma_uses_axi_lite_control_interface() -> None:
    shared = SHARED_BUILD.read_text(encoding="utf-8")

    assert "return_dma/S_AXI_LITE return_control_gpio/S_AXI" in shared
    assert "$return_dma/S_AXI" not in shared


def test_cdc_constraints_cover_c4m_c6i_and_c6v_clock_names() -> None:
    constraints = CDC_CONSTRAINTS.read_text(encoding="utf-8")

    assert "(c4m[0-9]+|c6i|c6v)" in constraints


def test_post_route_phys_opt_is_opt_in() -> None:
    shared = SHARED_BUILD.read_text(encoding="utf-8")
    c4m7 = C4M7_BUILD.read_text(encoding="utf-8")

    assert "set post_route_phys_opt_directive none" in shared
    assert "phys_opt_design -directive $post_route_phys_opt_directive" in shared
    assert "set post_route_phys_opt_directive" not in c4m7


def test_volume_fusion_is_separate_and_preserves_baseline_addresses() -> None:
    scripts = SHARED_BUILD.parent
    fusion = (scripts / "build_c6i_volume.tcl").read_text(encoding="utf-8")
    vision = (scripts / "build_c6i_vision.tcl").read_text(encoding="utf-8")
    assert "build_c6i_volume" not in vision
    assert "source -notrace [file join $fusion_script_dir build_c6i_vision.tcl]" in fusion
    assert "CONFIG.CONST_VAL 0xC0060C00" in fusion
    assert "-offset 0x43C10000 -range 4K" in fusion
    assert "get_property CONFIG.NUM_MI" in fusion and "$fusion_master_index + 1" in fusion
    assert "fusion_previous_addresses" in fusion and "fusion changed baseline address" in fusion
    assert "vision_net rst_fclk0/peripheral_aresetn voice_volume_0/s_axi_aresetn" in fusion
    assert "axi_dma" not in fusion and "S_AXI_HP" not in fusion
    audit = (scripts / "check_c6i_volume.tcl").read_text(encoding="utf-8")
    assert "check_c6i_volume.tcl" in fusion
    assert "fusion volume overlaps" in audit and "fusion connection mismatch" in audit
    assert "GP0_MI=31" in audit and "RANGE=4096" in audit
    assert "vision_gp0_pipeline" in fusion and "audit_requirements vision_gp0_slice" in fusion
    for channel in ("AW", "AR", "W", "R", "B"):
        assert f"vision_gp0_slice CONFIG.REG_{channel} 1" in audit


def test_volume_fusion_pinout_preserves_independent_codec_pins() -> None:
    constraints = ROOT / "board/pynq_z2/constraints"
    original = (constraints / "voice_volume.xdc").read_text(encoding="utf-8")
    fused = (constraints / "c6v_volume.xdc").read_text(encoding="utf-8")
    assert fused == original.replace("volume_i/", "c6v_i/")


def test_volume_fusion_preserves_real_800_camera_clock_and_cdc_constraints() -> None:
    constraints = ROOT / "board/pynq_z2/constraints"
    physical = (constraints / "c6v_volume_baseline.xdc").read_text(encoding="utf-8")
    assert physical.splitlines() == [
        "set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets vid_pclk_IBUF]",
    ]
    fusion = (SHARED_BUILD.parent / "build_c6i_volume.tcl").read_text(encoding="utf-8")
    postopt = (SHARED_BUILD.parent / "check_c6i_volume_postopt.tcl").read_text(encoding="utf-8")
    assert "{vid_pclk_IBUF vid_pclk_IBUF_BUFG}" in postopt
    assert "[llength $fusion_pclk_net] != 1" in postopt
    assert "set_property CLOCK_DEDICATED_ROUTE FALSE $fusion_pclk_net" in postopt
    assert "STEPS.OPT_DESIGN.TCL.POST" in fusion and "check_c6i_volume_postopt.tcl" in fusion
    assert "add_files -fileset utils_1 -norecurse [file join $fusion_script_dir check_c6i_volume_postopt.tcl]" in fusion
    assert "export_ip_user_files -of_objects $fusion_bd -no_script -sync -force -quiet" in fusion
    assert "USED_IN_SYNTHESIS false [get_files c6v_volume_baseline.xdc]" in fusion
    assert "c6v_sync_cdc.xdc" in fusion and "remove_files $fusion_old_cdc" in fusion