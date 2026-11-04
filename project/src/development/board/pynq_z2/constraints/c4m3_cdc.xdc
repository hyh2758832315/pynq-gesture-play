# The frame request and acknowledgement each cross through two-flop toggle synchronizers.
set_clock_groups -asynchronous \
    -group [get_clocks clk_fpga_0] \
    -group [get_clocks -regexp {^clk_out1_(c4m[0-9]+|c6i|c6v)_pixel_clock_0$}]