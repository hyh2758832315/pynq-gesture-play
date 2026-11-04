`timescale 1ns/1ps
// Structural parameter binding makes the negative test independent of launcher generic options.
module tb_c0e_reset_blocked;
    tb_c0e_reset #(.BAD_READ(1)) scenario();
endmodule
