`timescale 1ns/1ps
module tb_voice_volume_i2s;
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst_n = 0, bclk = 0, lrclk = 0, sdata = 0;
    wire pcm_valid, frame_fault;
    wire signed [15:0] pcm_s16;
    integer valid_count = 0, fault_count = 0, checks = 0;
    reg signed [15:0] expected;
    reg expect_sample = 0;
    voice_volume_i2s_rx dut (.*);
    always @(posedge clk) begin
        if (pcm_valid) begin
            if (!expect_sample || pcm_s16 !== expected) $fatal(1, "I2S_FAIL got=%h expected=%h", pcm_s16, expected);
            valid_count = valid_count + 1; expect_sample = 0;
        end
        if (frame_fault) fault_count = fault_count + 1;
    end
    task automatic slot(input bit channel, input [31:0] payload, input integer bits, input integer half_period);
        for (integer index = 0; index < bits; index = index + 1) begin
            bclk = 0; lrclk = channel;
            sdata = index == 0 ? 0 : payload[32-index];
            #(half_period); bclk = 1;
            #(half_period);
        end
        bclk = 0;
    endtask
    task automatic left(input signed [15:0] value, input integer half_period);
        expected = value; expect_sample = 1;
        slot(0, {value, 8'ha5, 8'h5a}, 32, half_period);
        #80;
        if (expect_sample) $fatal(1, "I2S_FAIL missing left sample");
        checks = checks + 1;
    endtask
    initial begin
        repeat (4) @(negedge clk); rst_n = 1;
        #3; slot(1, 32'h76543210, 32, 160);
        for (integer phase = 0; phase < 10; phase = phase + 1) begin
            #(phase);
            left(-32768 + phase, 159 + phase % 3);
            slot(1, 32'h7fffffff, 32, 159 + phase % 3);
            left(32767 - phase, 159 + phase % 3);
            slot(1, 32'h80000000, 32, 159 + phase % 3);
        end
        if (valid_count != 20 || fault_count != 0) $fatal(1, "I2S_FAIL nominal count");
        slot(0, 0, 10, 160); slot(1, 0, 32, 160);
        if (fault_count == 0) $fatal(1, "I2S_FAIL short frame not rejected");
        checks = checks + 1;
        slot(0, 0, 8, 160); rst_n = 0;
        #50; rst_n = 1;
        slot(0, 0, 24, 160); slot(1, 0, 32, 160);
        left(-12345, 160);
        if (valid_count != 21) $fatal(1, "I2S_FAIL restart replay");
        #10000;
        if (valid_count != 21) $fatal(1, "I2S_FAIL stopped clock produced samples");
        checks = checks + 1;
        $display("VOLUME_I2S_PASS checks=%0d samples=%0d faults=%0d phases=10", checks, valid_count, fault_count); $finish;
    end
    initial begin #10000000; $fatal(1, "I2S_WATCHDOG"); end
endmodule