from xml.etree import ElementTree

import pytest

from board.pynq_z2.scripts.verify_vision_capture_budget import EXPECTED, audit_capture_hwh


def fixture_hwh(tmp_path, *, omit=None, override=None, duplicate=None):
    root = ElementTree.Element("SYSTEM")
    for name, values in {**EXPECTED, "ps7_0": {
        "PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ": "100.000000",
        "PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ": "23.809525",
        "PCW_FPGA1_PERIPHERAL_FREQMHZ": "24.000000",
    }}.items():
        module = ElementTree.SubElement(root, "MODULE", INSTANCE=name)
        parameters = ElementTree.SubElement(module, "PARAMETERS")
        if name == "video_in":
            ports = ElementTree.SubElement(module, "PORTS")
            for port_name in ("overflow", "underflow"):
                ElementTree.SubElement(ports, "PORT", NAME=port_name, DIR="O")
            ElementTree.SubElement(ports, "PORT", NAME="vid_io_in_clk", DIR="I", CLKFREQUENCY="74250000")
        for key, value in values.items():
            if (name, key) == omit:
                continue
            if override and override[:2] == (name, key):
                value = override[2]
            ElementTree.SubElement(parameters, "PARAMETER", NAME=key, VALUE=str(value))
            if (name, key) == duplicate:
                ElementTree.SubElement(parameters, "PARAMETER", NAME=key, VALUE=str(value))
    path = tmp_path / "capture.hwh"
    ElementTree.ElementTree(root).write(path, encoding="utf-8")
    return path


def test_known_configuration_never_implies_camera_admission(tmp_path):
    path = fixture_hwh(tmp_path)
    original = path.read_bytes()
    result = audit_capture_hwh(path)
    assert path.read_bytes() == original
    assert result["video_fifo_address_space_entries"] == 1024
    assert result["usable_video_fifo_entries"] is None
    assert result["rgb_frame_stores"] == 3
    assert result["rgb_frame_stores_are_consumer_owned_queue"] is False
    assert result["clock_metadata_mhz"]["PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ"] == "23.809525"
    assert result["clock_metadata_mhz"]["PCW_FPGA1_PERIPHERAL_FREQMHZ"] == "24.000000"
    assert result["sensor_pclk_hz"] is None and result["worst_common_stall_ns"] is None
    assert result["sensor_pclk_hwh_metadata_hz"] == "74250000"
    assert result["video_fault_outputs_connected"] == {"overflow": False, "underflow": False}
    assert len(result["unknowns"]) == 6
    assert result["camera_admission_passed"] is False
    assert result["hardware_access"] is False and result["release_ready"] is False


@pytest.mark.parametrize("module,key", [(name, key) for name, values in EXPECTED.items() for key in values])
def test_every_controlling_parameter_is_required(tmp_path, module, key):
    with pytest.raises(ValueError, match="required"):
        audit_capture_hwh(fixture_hwh(tmp_path, omit=(module, key)))


@pytest.mark.parametrize("module,key,value", [
    ("video_in", "C_ADDR_WIDTH", 9), ("video_in", "C_HAS_ASYNC_CLK", 0),
    ("video_in", "C_INCLUDE_PIXEL_DROP", 1), ("frame_dma", "C_NUM_FSTORES", 1),
    ("frame_dma", "C_S2MM_LINEBUFFER_DEPTH", 1024), ("moments_dma", "C_INCLUDE_SG", 1),
    ("ps7_0", "PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ", 99),
    ("ps7_0", "PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ", "nan"),
])
def test_changed_profile_requires_explicit_reassessment(tmp_path, module, key, value):
    with pytest.raises(ValueError):
        audit_capture_hwh(fixture_hwh(tmp_path, override=(module, key, value)))


def test_duplicate_parameter_rejected(tmp_path):
    with pytest.raises(ValueError, match="duplicate"):
        audit_capture_hwh(fixture_hwh(tmp_path, duplicate=("video_in", "C_ADDR_WIDTH")))


def test_conflicting_case_alias_rejected(tmp_path):
    path = fixture_hwh(tmp_path)
    document = ElementTree.parse(path)
    module = document.find(".//MODULE[@INSTANCE='frame_dma']")
    ElementTree.SubElement(module.find("PARAMETERS"), "PARAMETER", NAME="c_num_fstores", VALUE="4")
    document.write(path, encoding="utf-8")
    with pytest.raises(ValueError, match="aliases"):
        audit_capture_hwh(path)


def test_duplicate_module_rejected(tmp_path):
    path = fixture_hwh(tmp_path)
    document = ElementTree.parse(path)
    ElementTree.SubElement(document.getroot(), "MODULE", INSTANCE="video_in")
    document.write(path, encoding="utf-8")
    with pytest.raises(ValueError, match="exactly one"):
        audit_capture_hwh(path)


def test_nested_interface_parameters_do_not_change_ip_configuration(tmp_path):
    path = fixture_hwh(tmp_path)
    document = ElementTree.parse(path)
    module = document.find(".//MODULE[@INSTANCE='frame_dma']")
    interfaces = ElementTree.SubElement(module, "BUSINTERFACES")
    for name in ("S_AXI_LITE", "M_AXI_S2MM"):
        interface = ElementTree.SubElement(interfaces, name)
        ElementTree.SubElement(interface, "PARAMETER", NAME="ADDR_WIDTH", VALUE="32")
        ElementTree.SubElement(interface, "PARAMETER", NAME="C_NUM_FSTORES", VALUE="99")
    document.write(path, encoding="utf-8")
    result = audit_capture_hwh(path)
    assert result["rgb_frame_stores"] == 3
    assert result["camera_admission_passed"] is False