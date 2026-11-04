# Fixed coworker-validated PMOD wiring: PCLK on Y19 is not a clock-capable IO.
# Same exception as reference camera_direct_plug_clock_probe.xdc. No rewiring.
# Allows placement, NOT a waiver of input setup/hold timing or board validation.
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets vid_pclk_IBUF]
