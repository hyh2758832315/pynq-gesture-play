`timescale 1ns/1ps
module tb_voice_volume_core;
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst_n = 0, enable = 0, configure = 0, pcm_valid = 0, input_fault = 0, ack_valid = 0;
    reg signed [15:0] pcm_s16 = 0;
    reg [31:0] config_epoch = 1, soft_sum = 40, loud_sum = 120, quiet_sum = 30;
    reg [31:0] ack_epoch = 1, ack_sequence = 0;
    wire [2:0] state;
    wire [7:0] faults;
    wire ack_error, window_valid, event_pending;
    wire [63:0] sample_count, event_sample;
    wire [31:0] window_count, last_sum, event_sequence, event_epoch, event_window, event_age;
    wire [1:0] event_kind;
    integer checks = 0;
    voice_volume_core #(.WINDOW_SAMPLES(4), .DC_SHIFT(30), .SAMPLE_TIMEOUT_CLKS(500),
                        .EVENT_TIMEOUT_CLKS(5000), .MAX_CLIPPED_SAMPLES(1)) dut (.*);
    task automatic check(input bit condition, input string message);
        if (!condition) $fatal(1, "CORE_FAIL %s state=%0d faults=%h event=%0d seq=%0d", message, state, faults, event_kind, event_sequence);
        checks = checks + 1;
    endtask
    task automatic restart;
        @(negedge clk); enable = 1; configure = 1; config_epoch = config_epoch + 1;
        @(negedge clk); configure = 0;
    endtask
    task automatic sample(input signed [15:0] value);
        @(negedge clk); pcm_valid = 1; pcm_s16 = value;
        @(negedge clk); pcm_valid = 0;
        repeat (2) @(negedge clk);
    endtask
    task automatic window(input signed [15:0] value);
        repeat (4) sample(value);
    endtask
    task automatic arm;
        repeat (5) window(0);
        check(state == 1 && !event_pending, "five quiet windows arm");
    endtask
    task automatic acknowledge;
        @(negedge clk); ack_valid = 1; ack_epoch = event_epoch; ack_sequence = event_sequence;
        @(negedge clk); ack_valid = 0;
    endtask
    initial begin
        repeat (4) @(negedge clk);
        rst_n = 1;
        restart(); arm();
        window(20); check(!event_pending, "first medium window waits");
        window(20); check(!event_pending, "second medium window waits");
        window(20); check(event_pending && event_kind == 1 && event_sequence == 1, "third medium emits soft");
        check(event_sample == 32 && event_window == 8, "source counters bind event");
        repeat (12) window(40);
        check(event_sequence == 1 && event_kind == 1, "sustained and slow escalation do not append");
        @(negedge clk); ack_valid = 1; ack_epoch = event_epoch; ack_sequence = 0;
        @(negedge clk); ack_valid = 0;
        check(event_pending && ack_error, "wrong acknowledgement retains event");
        acknowledge(); repeat (5) window(0);
        check(state == 1, "quiet plus ack rearms");
        window(40); check(!event_pending, "first loud window waits");
        window(40); check(event_pending && event_kind == 2 && event_sequence == 2, "two loud windows win");
        repeat (3000) sample(0);
        check(faults == 8'h10 && !event_pending, "unacknowledged event expires without overwrite");
        restart(); arm();
        window(40); window(20); window(20);
        check(!event_pending && state == 3, "unconfirmed high disturbance never becomes soft");
        repeat (6) window(0); check(state == 1, "abandoned candidate rearms after quiet");
        window(20); window(0); window(20);
        check(!event_pending, "spike and broken medium run rejected");
        restart();
        sample(-32768); repeat (3) sample(0);
        check(last_sum >= 32768 && faults == 0, "negative full scale absolute value does not wrap");
        window(32767); check(faults == 8'h04, "severe clipping invalidates source");
        restart(); repeat (510) @(negedge clk);
        check(faults == 8'h02, "clock stopped is fault not silence");
        restart(); arm(); window(20); window(20); window(20);
        check(event_pending, "event available before new epoch");
        restart(); check(!event_pending && state == 0 && faults == 0, "configuration epoch clears old event");
        loud_sum = 40; restart(); check(faults == 1, "invalid threshold ordering rejected");
        loud_sum = 120; restart(); input_fault = 1;
        @(negedge clk); input_fault = 0;
        check(faults == 8'h40 && !event_pending, "upstream framing fault neutralizes event");
          restart();
          @(negedge clk); pcm_valid = 1; pcm_s16 = 20;
          repeat (2) @(negedge clk);
          pcm_valid = 0;
          check(faults == 8'h80 && !event_pending, "busy input fails explicitly");
          restart();
          @(negedge clk); pcm_valid = 1; pcm_s16 = 300;
          @(negedge clk); pcm_valid = 0; configure = 1; config_epoch = config_epoch + 1;
          @(negedge clk); configure = 0;
          repeat (4) @(negedge clk);
          check(sample_count == 0 && window_count == 0 && dut.dc_level == 0 && faults == 0,
              "new epoch flushes all in-flight samples");
        $display("VOLUME_CORE_PASS checks=%0d", checks);
        $finish;
    end
    initial begin #1000000; $fatal(1, "CORE_WATCHDOG"); end
endmodule