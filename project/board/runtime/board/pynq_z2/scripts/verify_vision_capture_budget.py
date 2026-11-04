"""Read-only generated-HWH audit; configuration is not a camera service proof."""

import argparse
import hashlib
import json
from pathlib import Path
from xml.etree import ElementTree


EXPECTED = {
    "video_in": {
        "C_ADDR_WIDTH": 10,
        "C_HAS_ASYNC_CLK": 1,
        "C_PIXELS_PER_CLOCK": 1,
        "C_M_AXIS_VIDEO_DATA_WIDTH": 8,
        "C_INCLUDE_PIXEL_DROP": 0,
    },
    "frame_dma": {
        "C_INCLUDE_MM2S": 0,
        "C_INCLUDE_S2MM": 1,
        "C_INCLUDE_SG": 0,
        "C_NUM_FSTORES": 3,
        "C_S2MM_LINEBUFFER_DEPTH": 512,
        "C_S2MM_SOF_ENABLE": 1,
    },
    "moments_dma": {
        "C_INCLUDE_MM2S": 1,
        "C_INCLUDE_S2MM": 1,
        "C_INCLUDE_SG": 0,
    },
}


def audit_capture_hwh(path: Path) -> dict:
    data = path.read_bytes()
    document = ElementTree.fromstring(data)
    parameters = {}
    for name in (*EXPECTED, "ps7_0"):
        modules = [module for module in document.iter("MODULE") if module.get("INSTANCE") == name]
        if len(modules) != 1:
            raise ValueError(f"expected exactly one HWH module: {name}")
        values = {}
        for parameter in modules[0].findall("./PARAMETERS/PARAMETER"):
            key, value = parameter.get("NAME"), parameter.get("VALUE")
            if key is None or value is None:
                raise ValueError(f"incomplete HWH parameter: {name}")
            if key in values:
                raise ValueError(f"duplicate HWH parameter: {name}/{key}")
            values[key] = value
        parameters[name] = values
    for name, expected in EXPECTED.items():
        for key, wanted in expected.items():
            try:
                actual = int(parameters[name][key], 10)
            except (KeyError, ValueError) as error:
                raise ValueError(f"missing/integer HWH parameter required: {name}/{key}") from error
            if actual != wanted:
                raise ValueError(f"capture profile differs: {name}/{key}={actual}, expected {wanted}")
            alias = key.lower()
            if alias in parameters[name] and int(parameters[name][alias], 10) != actual:
                raise ValueError(f"conflicting HWH parameter aliases: {name}/{key}")
    clocks = {}
    for key in ("PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ", "PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ",
                "PCW_FPGA1_PERIPHERAL_FREQMHZ"):
        try:
            clocks[key] = parameters["ps7_0"][key]
            value = float(clocks[key])
        except (KeyError, ValueError) as error:
            raise ValueError(f"actual/requested clock metadata required: {key}") from error
        if not 0 < value < 1000:
            raise ValueError(f"invalid clock metadata: {key}")
    if float(clocks["PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ"]) != 100:
        raise ValueError("capture core profile requires actual 100MHz FCLK0")
    video = next(module for module in document.iter("MODULE") if module.get("INSTANCE") == "video_in")
    faults = {}
    for name in ("overflow", "underflow"):
        ports = video.findall(f"./PORTS/PORT[@NAME='{name}']")
        if len(ports) != 1 or ports[0].get("DIR") != "O":
            raise ValueError(f"Video-In fault output metadata required: {name}")
        faults[name] = bool(ports[0].get("SIGNAME") and ports[0].findall("./CONNECTIONS/CONNECTION"))
    pixel_clock = video.find("./PORTS/PORT[@NAME='vid_io_in_clk']")
    selected = {name: {key: parameters[name][key] for key in expected} for name, expected in EXPECTED.items()}
    return {
        "status": "CONFIGURATION_VERIFIED_CAMERA_SERVICE_PENDING",
        "hwh": str(path.resolve()),
        "hwh_sha256": hashlib.sha256(data).hexdigest(),
        "profile": "RETAINED_CAMERA_IP_PARAMETERS_ONLY",
        "parameters": selected,
        "clock_metadata_mhz": clocks,
        "video_fifo_address_bits": int(parameters["video_in"]["C_ADDR_WIDTH"]),
        "video_fifo_address_space_entries": 1 << int(parameters["video_in"]["C_ADDR_WIDTH"]),
        "usable_video_fifo_entries": None,
        "rgb_frame_stores": 3,
        "rgb_frame_stores_are_consumer_owned_queue": False,
        "mask_dma_scatter_gather": False,
        "video_fault_outputs_connected": faults,
        "sensor_pclk_hwh_metadata_hz": None if pixel_clock is None else pixel_clock.get("CLKFREQUENCY"),
        "sensor_pclk_hz": None,
        "worst_common_stall_ns": None,
        "unknowns": [
            "actual sensor PCLK and active/blanking arrival envelope",
            "usable Video-In capacity, CDC margin and initial occupancy",
            "demosaic and exact frontend worst-case service/drain envelope",
            "guaranteed RGB VDMA and mask S2MM DDR service and rearm stall",
            "autonomous receive ownership, exhaustion and stop/drain protocol",
            "input overflow detection and capture epoch invalidation",
        ],
        "hardware_access": False,
        "camera_admission_passed": False,
        "board_pending": True,
        "release_ready": False,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--hwh", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    arguments = parser.parse_args()
    result = audit_capture_hwh(arguments.hwh)
    serialized = json.dumps(result, indent=2, ensure_ascii=True) + "\n"
    with arguments.output.open("x", encoding="utf-8") as output:
        output.write(serialized)
    print("CAPTURE_CONFIG_AUDIT_PASS CAMERA_ADMISSION=false RELEASE_READY=false")


if __name__ == "__main__":
    main()