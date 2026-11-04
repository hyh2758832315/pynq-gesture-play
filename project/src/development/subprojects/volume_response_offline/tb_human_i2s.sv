`timescale 1ns/1ps
// Replay real Base ADC words in 32-bit I2S slots through the frozen R20 RX.
module tb_human_i2s;
    localparam integer NSAMPLES = 1954;
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst_n = 0, bclk = 0, lrclk = 0, sdata = 0;
    wire pcm_valid, frame_fault;
    wire signed [15:0] pcm_s16;
    reg [31:0] left_payload [0:NSAMPLES-1];
    reg [31:0] right_payload [0:NSAMPLES-1];
    integer valid_count = 0, fault_count = 0;

    voice_volume_i2s_rx dut (.*);

    always @(posedge clk) begin
        if (pcm_valid) begin
            if (valid_count >= NSAMPLES || pcm_s16 !== left_payload[valid_count][31:16])
                $fatal(1, "HUMAN_I2S_FAIL sample=%0d got=%h expected=%h",
                    valid_count, pcm_s16, left_payload[valid_count][31:16]);
            valid_count = valid_count + 1;
        end
        if (frame_fault) fault_count = fault_count + 1;
    end

    task automatic slot(input bit channel, input [31:0] payload);
        for (integer bit_index = 0; bit_index < 32; bit_index = bit_index + 1) begin
            bclk = 0;
            lrclk = channel;
            // I2S word MSB follows the LRCLK transition by one bit clock.
            sdata = bit_index == 0 ? 0 : payload[32-bit_index];
            // R20 top uses BCLK = 100 MHz / 32: 16 AXI cycles per half-bit.
            repeat (16) @(negedge clk);
            bclk = 1;
            repeat (16) @(negedge clk);
        end
        bclk = 0;
    endtask

    initial begin
        $readmemh("human-left-payload.mem", left_payload);
        $readmemh("human-right-payload.mem", right_payload);
        repeat (4) @(negedge clk);
        rst_n = 1;
        slot(1, 32'h76543210);
        for (integer i = 0; i < NSAMPLES; i = i + 1) begin
            slot(0, left_payload[i]);
            slot(1, right_payload[i]);
        end
        repeat (5) @(negedge clk);
        if (valid_count != NSAMPLES || fault_count != 0)
            $fatal(1, "HUMAN_I2S_FAIL coverage=%0d faults=%0d", valid_count, fault_count);
        $display("TEST_PASS human_i2s samples=%0d faults=%0d", valid_count, fault_count);
        $finish;
    end
    initial begin #50000000; $fatal(1, "HUMAN_I2S_WATCHDOG"); end
endmodule
