`timescale 1ns/1ps
module tb_voice_volume_numeric;
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst_n = 0, enable = 0, configure = 0, pcm_valid = 0, input_fault = 0, ack_valid = 0;
    reg signed [15:0] pcm_s16 = 0;
    reg [31:0] config_epoch = 1, soft_sum = 5000000, loud_sum = 10000000, quiet_sum = 500000;
    reg [31:0] ack_epoch = 0, ack_sequence = 0;
    wire [2:0] state;
    wire [7:0] faults;
    wire ack_error, window_valid, event_pending;
    wire [63:0] sample_count, event_sample;
    wire [31:0] window_count, last_sum, event_sequence, event_epoch, event_window, event_age;
    wire [1:0] event_kind;
    voice_volume_core #(.MAX_CLIPPED_SAMPLES(977)) dut (.*);
    longint signed model_dc = 0, model_delta, model_centered, model_magnitude;
    longint unsigned model_sum = 0;
    integer model_index = 0, model_windows = 0, checks = 0;
    reg [31:0] random_state = 32'h6a294103;
    task automatic sample(input signed [15:0] value);
        model_delta = (longint'(value) <<< 8) - model_dc;
        model_dc = model_dc + (model_delta >>> 10);
        model_centered = ((longint'(value) <<< 8) - model_dc) >>> 8;
        model_magnitude = model_centered < 0 ? -model_centered : model_centered;
        model_sum = model_sum + model_magnitude;
        model_index = model_index + 1;
        @(negedge clk); pcm_valid = 1; pcm_s16 = value;
        @(negedge clk); pcm_valid = 0;
        repeat (2) @(negedge clk);
        if ($signed(dut.dc_level) !== model_dc) $fatal(1, "NUMERIC_FAIL DC value=%0d", value);
        checks = checks + 1;
        if (model_index == 977) begin
            model_windows = model_windows + 1;
            if (!window_valid || last_sum !== model_sum[31:0] || window_count !== model_windows)
                $fatal(1, "NUMERIC_FAIL window=%0d RTL=%0d model=%0d", model_windows, last_sum, model_sum);
            if (model_sum > 32'hffffffff) $fatal(1, "NUMERIC_FAIL reference range");
            checks = checks + 1;
            model_index = 0; model_sum = 0;
        end else if (window_valid) $fatal(1, "NUMERIC_FAIL early window");
        if (faults != 0) $fatal(1, "NUMERIC_FAIL unexpected fault %h", faults);
    endtask
    initial begin
        repeat (4) @(negedge clk); rst_n = 1; enable = 1; configure = 1;
        @(negedge clk); configure = 0;
        repeat (977 * 6) sample(0);
        repeat (977 * 12) sample(1200);
        if (last_sum >= 5000) $fatal(1, "NUMERIC_FAIL DC failed to settle");
        for (integer index = 0; index < 977 * 8; index = index + 1) sample(index[0] ? -32768 : 32767);
        for (integer index = 0; index < 977 * 16; index = index + 1) begin
            random_state = {random_state[30:0], random_state[31] ^ random_state[21] ^ random_state[1] ^ random_state[0]};
            sample($signed(random_state[15:0]));
        end
        if (model_windows != 42 || sample_count != 977 * 42 || model_index != 0)
            $fatal(1, "NUMERIC_FAIL coverage count");
        $display("VOLUME_NUMERIC_PASS samples=%0d windows=%0d checks=%0d", sample_count, model_windows, checks);
        $finish;
    end
    initial begin #10000000; $fatal(1, "NUMERIC_WATCHDOG"); end
endmodule